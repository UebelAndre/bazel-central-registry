#!/usr/bin/env python3
"""Generates the per-platform build data of a GRUB module version.

Writes `<platform>.bzl` for every firmware platform gentpl.py knows (plus the
little-endian mips variants) and the platforms.bzl index into
modules/grub/<version>/overlay/platform/.  The package's BUILD file,
probes.bzl and common.bzl are maintained by hand.

The kernel, module and image tables come from gentpl.py's own def parser over
grub-core/Makefile.core.def and Makefile.gcry.def.  `flag_steps` transcribes
configure.ac's target-compiler section as an ordered list of literal flags
and compiler probes; the probes become rules_cc_autoconf checks in the
module, and their GCC/binutils answers give the static `target_*` lists,
which were checked against ./configure runs of every x86 platform and
arm64-efi for 2.06 and 2.14.  Review the configure.ac diff of a new release
against `flag_steps` before trusting the output.

Usage:
    python3 modules/grub/generate_platform_data.py /path/to/grub-2.14
The output goes through buildifier when one is on PATH.
"""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
from pathlib import Path
from typing import Any

Entry = dict[str, Any]
Flags = dict[str, Any]  # {"cflags": [...], "ccasflags": [...], "cppflags": [...], "ldflags": [...], "subst": {...}}

CPUS = ["x86_64", "loongarch64", "riscv32", "riscv64", "sparc64", "powerpc", "arm64", "i386", "mips", "ia64", "arm"]

# gentpl's mips platforms stand for both endiannesses; configure's target_cpu
# tells them apart.  loongson is mipsel only; arc and qemu_mips get a
# `mipsel_` variant.
MIPSEL_VARIANTS = {"mips_arc": "mipsel_arc", "mips_qemu_mips": "mipsel_qemu_mips"}

MACHINE = {
    "coreboot": "COREBOOT",
    "multiboot": "MULTIBOOT",
    "efi": "EFI",
    "xen": "XEN",
    "xen_pvh": "XEN_PVH",
    "ieee1275": "IEEE1275",
    "uboot": "UBOOT",
    "qemu": "QEMU",
    "pc": "PCBIOS",
    "emu": "EMU",
    "loongson": "MIPS_LOONGSON",
    "qemu_mips": "MIPS_QEMU_MIPS",
    "arc": "ARC",
}

# CPPFLAGS_GCRY_ASM: what configure's assembler probes find with GNU as.
GCRY_ASM_X86_64_EFI = [
    "-D__x86_64",
    "-DHAVE_CPU_ARCH_X86",
    "-D__PIC__=1",
    "-DHAVE_COMPATIBLE_GCC_AMD64_PLATFORM_AS",
    "-DHAVE_INTEL_SYNTAX_PLATFORM_AS",
    "-DHAVE_GCC_INLINE_ASM_SSSE3",
    "-DHAVE_GCC_INLINE_ASM_SHAEXT",
    "-DENABLE_SHAEXT_SUPPORT",
    "-DHAVE_GCC_INLINE_ASM_SSE41",
    "-DHAVE_GCC_INLINE_ASM_AVX",
    "-DHAVE_GCC_INLINE_ASM_AVX2",
    "-DHAVE_GCC_INLINE_ASM_AVX512",
    "-DHAVE_GCC_INLINE_ASM_BMI2",
]

EFIEMU = {
    "efiemu32.o": {
        "srcs": ["grub-core/efiemu/runtime/efiemu.c"],
        "include_dirs": ["grub-core/efiemu/runtime"],
        "cflags": ["-m32", "-nostdlib", "-static", "-O2"],
    },
    "efiemu64.o": {
        "srcs": ["grub-core/efiemu/runtime/efiemu.c", "grub-core/efiemu/runtime/efiemu.S"],
        "include_dirs": ["grub-core/efiemu/runtime"],
        "cflags": ["-m64", "-nostdlib", "-O2", "-mcmodel=large", "-mno-red-zone"],
        "ldflags": ["-m64", "-Wl,-melf_x86_64", "-nostdlib", "-static", "-Wl,-r"],
    },
}

# Fields whose string values are repository paths, emitted as Label()s.
LABEL_FIELDS = {"srcs", "startup", "extra_inputs", "kernel_headers", "cpu_hdrs", "machine_hdrs", "data"}

# The programs configure's probes compile (acinclude.m4, configure.ac).
TRIVIAL = "int main (void) { return 0; }\n"
CLANG_CODE = "#ifndef __clang__\n#error not clang\n#endif\n" + TRIVIAL
PIE_CODE = "#ifdef __PIE__\n#error PIE by default\n#endif\n" + TRIVIAL
PIC_CODE = "#ifdef __PIC__\n#error PIC by default\n#endif\n" + TRIVIAL
SSP_CODE = "char foo (void) { volatile char a[8]; a[3] = 1; return a[3]; }\n"  # configure's, made -Wall -Werror clean
USCORE_CODE = (
    "#define GRUB_STR_(x) #x\n#define GRUB_STR(x) GRUB_STR_(x)\n"
    'int main (void) { _Static_assert (sizeof (GRUB_STR (__USER_LABEL_PREFIX__)) == 1, "prefix"); return 0; }\n'
)
MIPS_O32_CODE = (
    "#if !defined(_ABIO32) || !defined(_MIPS_SIM) || (_MIPS_SIM != _ABIO32)\n#error not o32 ABI\n#endif\n" + TRIVIAL
)


PLATFORM_HEADER = '''"""GRUB {ver} build data for the {name} firmware platform (see common.bzl).

Generated from grub-core/Makefile.core.def and Makefile.gcry.def as gentpl.py
expands them for `{gentpl}`, and from configure.ac's target-compiler section.
"""

'''

INDEX_HEADER = '''"""The firmware platforms GRUB {ver}'s gentpl.py knows (plus the little-endian
mips variants), the groups Makefile.core.def tags sources with, and the
per-platform data by name.
"""

'''


class Gentpl:
    """gentpl.py's definitions parser and platform helpers, loaded from the source tree."""

    def __init__(self, src: Path) -> None:
        # gentpl.py is a script; everything above its option parser is the library part.
        text = (src / "gentpl.py").read_text().split("parser = OptionParser")[0]
        namespace: dict[str, Any] = {}
        exec(compile(text, "gentpl.py", "exec"), namespace)  # noqa: S102
        self.ns = namespace
        self.defs = namespace["defparser"]
        self.defs.read_definitions(str(src / "grub-core" / "Makefile.core.def"))
        self.defs.read_definitions(str(src / "grub-core" / "Makefile.gcry.def"))
        self.platforms: list[str] = list(namespace["GRUB_PLATFORMS"])
        self.groups: dict[str, list[str]] = {k: list(v) for k, v in namespace["GROUPS"].items()}

    def values(self, defn: Any, platform: str, kind: str) -> str:
        """`platform_<kind>(defn, platform)`: the def's value of a field for the platform."""
        result: str = self.ns["platform_" + kind](defn, platform)
        return result.strip()

    def tagged(self, defn: Any, platform: str, tag: str) -> bool:
        return bool(self.ns["platform_tagged"](defn, platform, tag))

    def enabled(self, defn: Any, platform: str) -> bool:
        return self.tagged(defn, platform, "enable") if "enable" in defn else True


def split(name: str) -> tuple[str | None, str]:
    """A platform name into (cpu, platform); `mipsel_*` is the mips cpu."""
    if name == "emu":
        return None, "emu"
    for c in CPUS + ["mipsel"]:
        if name.startswith(c + "_"):
            return ("mips" if c == "mipsel" else c), name[len(c) + 1 :]
    raise SystemExit(name)


def target_cpu(name: str) -> str | None:
    """configure's $target_cpu for the platform."""
    cpu, _ = split(name)
    return "mipsel" if name.startswith("mipsel_") or name == "mips_loongson" else cpu


def every(flag: str) -> Flags:
    """A flag configure adds to all four of CFLAGS, CPPFLAGS, CCASFLAGS and LDFLAGS."""
    return {"cflags": [flag], "cppflags": [flag], "ccasflags": [flag], "ldflags": [flag]}


def literal(when: str | None = None, **to: Any) -> Entry:
    step: Entry = {"literal": to}
    if when:
        step["when"] = when
    return step


def probe(
    name: str,
    candidates: list[tuple[list[str], Flags]],
    gcc: int | None = 0,
    code: str = TRIVIAL,
    negate: bool = False,
    when: str | None = None,
    copts: list[str] | None = None,
    otherwise: Flags | None = None,
) -> Entry:
    """A configure probe: the first candidate whose flags compile contributes its `to` flags.

    `gcc` is the index of the candidate GCC and GNU ld take, None if none does;
    it only feeds the static lists.  `negate` makes a failing compile the hit
    (the `#error` style probes).
    """
    step: Entry = {
        "probe": name,
        "code": code,
        "candidates": [{"flags": flags, "to": to} for flags, to in candidates],
        "gcc": gcc,
    }
    if negate:
        step["negate"] = True
    if when:
        step["when"] = when
    if copts:
        step["copts"] = copts
    if otherwise:
        step["otherwise"] = otherwise
    return step


def flag_steps(name: str, new: bool, pci: list[str]) -> list[Entry]:
    """configure.ac's target-compiler section, in its order (2.14's where 2.06 differs only in order).

    Each step is a `literal` (flags configure adds outright) or a `probe`
    (flags it adds when a compile test passes).  `when` names an earlier
    probe whose hit (`clang`, `pie`) or miss (`!clang`) the step depends on.
    configure's link probes are literals here: what they test (the ELF
    emulation name, `-no-pie`, `--build-id=none`, the `__bss_start` and
    `end` symbols) holds for every ELF linker, and a link check under Bazel
    gets the toolchain's own `-lstdc++ -lm`, which a `-m32` probe cannot
    satisfy on a host without 32-bit libraries.
    """
    cpu, plat = split(name)
    tcpu = target_cpu(name)
    emu = plat == "emu"
    x86 = cpu in ("i386", "x86_64")
    mips = cpu == "mips"
    steps: list[Entry] = []

    cpp = []
    if tcpu == "mipsel":
        cpp.append("-DGRUB_CPU_MIPSEL=1")
    if tcpu == "mips":
        cpp.append("-DGRUB_CPU_MIPS=1")
    cpp.append(f"-DGRUB_MACHINE_{MACHINE[plat]}=1")
    if not emu and tcpu:
        cpp.append("-DGRUB_MACHINE=" + ("mips" if tcpu == "mipsel" else tcpu).upper() + "_" + plat.upper())
    steps.append(literal(cflags=["-std=gnu99"] + (["-fno-common"] if new else []) + ["-Os"], cppflags=cpp))
    if (cpu in ("i386", "powerpc") and not emu) or (cpu in ("x86_64", "sparc64") and not emu) or name == "sparc64_emu":
        m = "-m32" if cpu in ("i386", "powerpc") else "-m64"
        steps.append(literal(cflags=[m], ccasflags=[m], cppflags=[m], ldflags=[m]))
    steps.append(literal(cflags=["-g"], ccasflags=["-g"]))
    if tcpu in ("powerpc", "mips"):
        steps.append(
            probe(
                "big_endian",
                [(["-EB"], every("-EB")), (["-mbig-endian"], every("-mbig-endian"))],
                gcc=1 if tcpu == "powerpc" else 0,
            )
        )
    if tcpu == "mipsel":
        steps.append(
            probe(
                "little_endian",
                [(["-EL"], {"cflags": ["-EL"], "cppflags": ["-EL"], "ccasflags": ["-EL"], "ldflags": ["-EL"]})],
            )
        )
    if mips:
        steps.append(
            probe(
                "mips_o32_abi",
                [([], {}), (["-mabi=32"], {"cflags": ["-mabi=32"], "ccasflags": ["-mabi=32"]})],
                gcc=1,
                code=MIPS_O32_CODE,
            )
        )
    steps.append(probe("clang", [([], {})], gcc=None, code=CLANG_CODE))
    if cpu == "i386" and not emu:
        steps.append(literal(cflags=["-march=i386"]))
        if plat != "efi":
            steps.append(literal(when="!clang", cflags=["-mrtd", "-mregparm=3"]))
    if mips:
        steps.append(
            probe("mflush_func", [(["-mflush-func=grub_red_herring"], {"cflags": ["-mflush-func=grub_red_herring"]})])
        )
        if new:
            steps.append(probe("mno_gpopt", [(["-mno-gpopt"], {"cflags": ["-mno-gpopt"]})]))
    if cpu == "i386":
        if new:
            steps.append(literal(cflags=["-falign-functions=1"]))
            steps.append(probe("falign_loops", [(["-falign-loops=1"], {"cflags": ["-falign-loops=1"]})]))
            steps.append(probe("falign_jumps", [(["-falign-jumps=1"], {"cflags": ["-falign-jumps=1"]})]))
        else:
            falign = ["-falign-jumps=1", "-falign-loops=1", "-falign-functions=1"]
            malign = ["-malign-jumps=1", "-malign-loops=1", "-malign-functions=1"]
            steps.append(
                probe("falign", [(["-falign-loops=1"], {"cflags": falign}), (["-malign-loops=1"], {"cflags": malign})])
            )
    steps.append(probe("freg_struct_return", [(["-freg-struct-return"], {"cflags": ["-freg-struct-return"]})]))
    if x86 and not emu:
        steps.append(literal(cflags=["-mno-mmx", "-mno-sse", "-mno-sse2", "-mno-sse3", "-mno-3dnow"]))
    if new and x86:
        steps.append(
            probe(
                "mx86_used_note",
                [
                    (
                        ["-Wa,-mx86-used-note=no"],
                        {"cflags": ["-Wa,-mx86-used-note=no"], "ccasflags": ["-Wa,-mx86-used-note=no"]},
                    )
                ],
            )
        )
    if new and cpu == "loongarch64":
        relocs = ["-mno-explicit-relocs", "-fno-plt"]
        steps.append(probe("mno_explicit_relocs", [(relocs, {"cflags": relocs, "ccasflags": relocs})]))
    if new and cpu in ("loongarch64", "riscv32", "riscv64"):
        steps.append(
            probe(
                "mno_relax",
                [
                    (["-mno-relax"], {"cflags": ["-mno-relax"], "ccasflags": ["-mno-relax"]}),
                    (["-Wa,-mno-relax"], {"cflags": ["-Wa,-mno-relax"], "ccasflags": ["-Wa,-mno-relax"]}),
                ],
            )
        )
    if new and cpu == "loongarch64":
        steps.append(literal(cflags=["-Wa,-mla-global-with-abs"], ccasflags=["-Wa,-mla-global-with-abs"]))
    if not emu:
        if cpu == "arm64":
            cands = [["-mgeneral-regs-only"]]
        elif cpu == "riscv32":
            cands = ([["-march=rv32imac_zicsr_zifencei", "-mabi=ilp32"]] if new else []) + [
                ["-march=rv32imac", "-mabi=ilp32"]
            ]
        elif cpu == "riscv64":
            cands = ([["-march=rv64imac_zicsr_zifencei", "-mabi=lp64"]] if new else []) + [
                ["-march=rv64imac", "-mabi=lp64"]
            ]
        elif cpu == "ia64":
            cands = [["-mno-inline-float-divide", "-mno-inline-sqrt"]]
        else:
            cands = [["-msoft-float"]]
        steps.append(probe("soft_float", [(c, {"cflags": c, "ccasflags": c}) for c in cands]))
    if cpu == "sparc64":
        steps.append(
            probe(
                "mno_app_regs",
                [
                    (
                        ["-mllvm", "-sparc-reserve-app-registers"],
                        {"cppflags": ["-mllvm", "-sparc-reserve-app-registers"]},
                    ),
                    (["-mno-app-regs"], {"cflags": ["-mno-app-regs"]}),
                ],
                gcc=1,
            )
        )
        steps.append(literal(ldflags=["-mno-relax"]))  # link probe upstream; GNU ld and lld take it
    if new:
        steps.append(
            probe("fno_omit_frame_pointer", [(["-fno-omit-frame-pointer"], {"cflags": ["-fno-omit-frame-pointer"]})])
        )
    steps.append(probe("fno_dwarf2_cfi_asm", [(["-fno-dwarf2-cfi-asm"], {"cflags": ["-fno-dwarf2-cfi-asm"]})]))
    steps.append(
        probe(
            "mno_stack_arg_probe",
            [(["-mno-stack-arg-probe"], {"cflags": ["-mno-stack-arg-probe"]})],
            gcc=0 if x86 else None,
        )
    )
    for flag in ["-fno-asynchronous-unwind-tables", "-fno-unwind-tables", "-fno-ident"]:
        steps.append(probe(flag.strip("-").replace("-", "_"), [([flag], {"cflags": [flag]})]))
    if x86 and not emu:
        fmts = [f"-Wl,-melf_{cpu}" + s for s in ["", "_fbsd", "_obsd", "_haiku"]]
        steps.append(
            literal(ldflags=[f"-Wl,-melf_{cpu}"])
        )  # link probe upstream (the BSD and Haiku spellings are the alternatives)
    if name == "x86_64_efi":
        steps.append(probe("mno_red_zone", [(["-mno-red-zone"], {"cflags": ["-mno-red-zone"]})]))
    if cpu == "arm":
        movt = [["-mno-movt"], ["-mllvm", "-arm-use-movt=0"], ["-mword-relocations"]]
        steps.append(probe("mno_movt", [(c, {"cppflags": c}) for c in movt], gcc=2))
        steps.append(probe("mthumb_interwork", [(["-mthumb-interwork"], {"cflags": ["-mthumb-interwork"]})]))
    steps.append(probe("qn", [(["-Qn", "-Qunused-arguments"], {"cflags": ["-Qn", "-Qunused-arguments"]})], gcc=None))
    steps.append(
        probe(
            "pie",
            [([], {"cflags": ["-fno-PIE", "-fno-pie"], "ccasflags": ["-fno-PIE", "-fno-pie"]})],
            code=PIE_CODE,
            negate=True,
        )
    )
    steps.append(literal(when="pie", ldflags=["-no-pie"]))  # link probe upstream; every PIE-defaulting driver takes it
    steps.append(
        probe("pic", [([], {"cflags": ["-fno-PIC"]})], gcc=None, code=PIC_CODE, negate=True, copts=["-fno-PIE"])
    )
    if cpu in ("mips", "arm64"):
        steps.append(literal(when="clang", cflags=["-fPIC"]))
    if cpu == "x86_64":
        steps.append(probe("mcmodel", [(["-mcmodel=large"], {"cflags": ["-mcmodel=large"]})]))
    elif cpu in ("sparc64", "riscv64"):
        steps.append(
            probe(
                "mcmodel",
                [(["-mcmodel=large"], {"cflags": ["-mcmodel=large"]})],
                gcc=None,
                otherwise={"cflags": ["-mcmodel=medany"]},
            )
        )
    steps.append(
        probe("stack_protector", [(["-fstack-protector"], {"cflags": ["-fno-stack-protector"]})], code=SSP_CODE)
    )
    if cpu == "arm":
        align = [["-mno-unaligned-access"], ["-Xclang", "-mstrict-align"], ["-mstrict-align"]]
        steps.append(probe("strict_align", [(c, {"cflags": c}) for c in align]))
    steps.append(literal(ldflags=["-Wl,--build-id=none"]))  # link probe upstream; GNU ld and lld take it

    # conf/Makefile.common
    cflags_platform, ldflags_platform = [], []
    if name == "sparc64_ieee1275":
        ldflags_platform.append("-Wl,-melf64_sparc")
    if cpu == "arm" and not emu:
        ldflags_platform.append("-Wl,--wrap=__clear_cache")
    if cpu == "arm64":
        cflags_platform.append("-mcmodel=large")
    if name == "powerpc_ieee1275":
        cflags_platform.append("-mcpu=powerpc")
    if new and name in pci:
        cflags_platform.append("-DGRUB_HAS_PCI")
    steps.append(literal(cflags_platform=cflags_platform, ldflags_platform=ldflags_platform))

    # config.h: grub_ASM_USCORE and, on i386, the BSS/end symbol probes.
    if emu:
        steps.append(literal(subst={"HAVE_ASM_USCORE": "0"}))
    else:
        steps.append(
            probe(
                "asm_uscore",
                [([], {"subst": {"HAVE_ASM_USCORE": "0"}})],
                code=USCORE_CODE,
                otherwise={"subst": {"HAVE_ASM_USCORE": "1"}},
            )
        )
    if cpu == "i386" and not emu:
        # Link probes upstream (grub_CHECK_BSS_START_SYMBOL, grub_CHECK_END_SYMBOL); GNU ld and lld
        # define both for ELF.
        steps.append(literal(subst={"BSS_START_SYMBOL": "__bss_start", "END_SYMBOL": "end"}))
    else:
        steps.append(literal(subst={"BSS_START_SYMBOL": "", "END_SYMBOL": ""}))
    return steps


def apply_steps(steps: list[Entry]) -> Flags:
    """The flags GCC and GNU ld end up with: literals plus each probe's expected candidate."""
    out: Flags = {
        "cflags": [],
        "ccasflags": [],
        "cppflags": [],
        "ldflags": [],
        "cflags_platform": [],
        "ldflags_platform": [],
        "subst": {},
    }

    def add(to: Flags) -> None:
        for k, v in to.items():
            if k == "subst":
                out["subst"].update(v)
            else:
                out[k] += v

    for step in steps:
        if "literal" in step:
            if step.get("when") != "clang":
                add(step["literal"])
        elif step["gcc"] is not None:
            add(step["candidates"][step["gcc"]]["to"])
        elif "otherwise" in step:
            add(step["otherwise"])
    return out


def steps_of(steps: list[Entry]) -> list[Entry]:
    """The steps as the BUILD file consumes them, in order, without the GCC expectation."""
    return [{k: v for k, v in s.items() if k != "gcc"} for s in steps]


def literal_flags(steps: list[Entry]) -> Flags:
    """The unconditional flags, which the response-file templates carry verbatim."""
    out: Flags = {"cflags": [], "ccasflags": [], "cppflags": [], "ldflags": []}
    for step in steps:
        if "literal" in step and "when" not in step:
            for k in out:
                out[k] += step["literal"].get(k, [])
    return out


def target_flags(name: str, new: bool, pci: list[str]) -> Entry:
    """Everything configure and conf/Makefile.common decide per platform."""
    cpu, plat = split(name)
    tcpu = target_cpu(name)
    emu = plat == "emu"
    steps = flag_steps(name, new, pci)
    got = apply_steps(steps)
    fmt = ""
    if "-m32" in got["cflags"]:
        fmt = "elf32"
    if "-m64" in got["cflags"]:
        fmt = "elf64"
    link_addr: dict[str, str] = {}
    if name == "mips_arc":
        link_addr = {"TARGET_LINK_ADDR": "0x88200000", "TARGET_DECOMPRESSOR_LINK_ADDR": "0x88100000"}
    if name == "mipsel_arc":
        link_addr = {"TARGET_LINK_ADDR": "0x80700000", "TARGET_DECOMPRESSOR_LINK_ADDR": "0x80600000"}
    if name in ("mips_qemu_mips", "mipsel_qemu_mips", "mips_loongson"):
        link_addr = {"TARGET_DECOMPRESSOR_LINK_ADDR": "0x80100000"}
    if name == "i386_qemu":
        link_addr["GRUB_BOOT_MACHINE_LINK_ADDR"] = "0xffe00"
    cpudir = "mips" if tcpu == "mipsel" else tcpu
    return {
        "target_cpu": tcpu,
        "platform": plat,
        "cpu_dir": None if emu else f"include/grub/{cpudir}",
        "machine_dir": None if emu else f"include/grub/{cpudir}/{plat}",
        "config_h": {"GRUB_TARGET_CPU": tcpu or "", "GRUB_PLATFORM": plat} | got["subst"],
        "target_cflags": got["cflags"],
        "target_cppflags": got["cppflags"],
        "target_ccasflags": got["ccasflags"],
        "target_ldflags": got["ldflags"],
        "literal_flags": literal_flags(steps),
        "steps": steps_of(steps),
        "nostdinc": not emu,
        "cflags_platform": got["cflags_platform"],
        "ldflags_platform": got["ldflags_platform"],
        "ldflags_oldmagic": "-Wl,-N",
        "img_ldflags": ["-Wl,-N"],
        "img_base_ldopt": "-Wl,-Ttext",
        "img_cflags": [],
        "module_format": fmt,
        "cppflags_gcry_asm": GCRY_ASM_X86_64_EFI if new and name == "x86_64_efi" else [],
        "link_addr": link_addr,
        "efiemu": EFIEMU if cpu == "i386" and plat not in ("efi", "emu") else None,
    }


def expand(flags_of: Entry, text: str, new: bool) -> tuple[list[str], list[str]]:
    """Expand the $(...) of a def flag string into (flags, include_dirs)."""
    flags: list[str] = []
    dirs: list[str] = []
    subst = {
        "$(TARGET_IMG_LDFLAGS)": " ".join(flags_of["img_ldflags"]),
        "$(TARGET_IMG_BASE_LDOPT)": flags_of["img_base_ldopt"],
        "$(TARGET_LINK_ADDR)": flags_of["link_addr"].get("TARGET_LINK_ADDR", ""),
        "$(TARGET_DECOMPRESSOR_LINK_ADDR)": flags_of["link_addr"].get("TARGET_DECOMPRESSOR_LINK_ADDR", ""),
        "$(GRUB_BOOT_MACHINE_LINK_ADDR)": flags_of["link_addr"].get("GRUB_BOOT_MACHINE_LINK_ADDR", ""),
        "$(CPPFLAGS_GCRY_ASM)": " ".join(flags_of["cppflags_gcry_asm"]),
    }
    for tok in text.split():
        if tok in ("$(CFLAGS_POSIX)", "$(CFLAGS_GCRY)"):
            flags.append("-fno-builtin")  # CFLAGS_GCRY = warnings + $(CFLAGS_POSIX)
        elif tok == "$(CFLAGS_GNULIB)":
            pass  # warnings only
        elif tok == "$(CPPFLAGS_POSIX)":
            dirs.append("grub-core/lib/posix_wrap")
        elif tok == "$(CPPFLAGS_GNULIB)":
            dirs.append("grub-core/lib/gnulib")
        elif tok == "$(CPPFLAGS_GCRY)":
            dirs += ["grub-core/lib/libgcrypt_wrap", "grub-core/lib/posix_wrap", "include/grub/gcrypt"]
            flags.append("-D_GCRYPT_IN_LIBGCRYPT=1")
            if new:
                flags.append("-D_GCRYPT_CONFIG_H_INCLUDED=1")
        elif tok == "$(SDL2_CFLAGS)":
            flags.append(tok)  # pkg-config output; emu only
        elif tok.startswith("-I$(srcdir)/"):
            dirs.append("grub-core/" + tok[len("-I$(srcdir)/") :].rstrip("/"))
        elif tok.startswith("-W") and not tok.startswith(("-Wl,", "-Wa,")):
            continue
        else:
            for k, v in subst.items():
                tok = tok.replace(k, v)
            if "$(" in tok:
                raise SystemExit(f"unexpanded {tok} in {text}")
            flags += tok.split()  # a variable may expand to several flags
    return flags, dirs


def kernel_headers(makefile_am: str, gentpl_name: str, flags_of: Entry, new: bool, pci: list[str]) -> list[str]:
    """KERNEL_HEADER_FILES of grub-core/Makefile.am for the platform, the automake conditionals evaluated."""
    cpu, plat = split(gentpl_name)
    true = {"COND_" + gentpl_name, "COND_emu" if plat == "emu" else "", "COND_" + (cpu or "")}
    if new and gentpl_name in pci:
        true.add("COND_HAVE_PCI")
    if flags_of["efiemu"]:
        true.add("COND_ENABLE_EFIEMU")
    hdrs: list[str] = []
    stack = [True]
    builddir = {
        "$(top_builddir)/include/grub/machine/": flags_of["machine_dir"],
        "$(top_builddir)/include/grub/cpu/": flags_of["cpu_dir"],
        "$(top_builddir)/": "",
    }
    for raw in makefile_am.splitlines():
        line = raw.strip()
        if line.startswith("if "):
            cond = line[3:].strip()
            stack.append(stack[-1] and ((cond.lstrip("!") in true) != cond.startswith("!")))
        elif line == "else":
            prev = stack.pop()
            stack.append(stack[-1] and not prev)
        elif line == "endif":
            stack.pop()
        elif line.startswith("KERNEL_HEADER_FILES +=") and stack[-1]:
            h = line.split("+=", 1)[1].strip().replace("$(top_srcdir)/", "")
            for prefix, directory in builddir.items():
                if h.startswith(prefix):
                    h = (directory + "/" if directory else "") + h[len(prefix) :]
                    break
            if h not in hdrs:
                hdrs.append(h)
    return hdrs


def entry(g: Gentpl, gentpl_name: str, flags_of: Entry, defn: Any, kind: str, new: bool) -> Entry:
    """One kernel/module/image/program def as the platform sees it."""
    srcs = g.values(defn, gentpl_name, "sources").split()
    e: Entry = {
        "srcs": ["grub-core/" + s for s in srcs if not s.endswith(".h")],
        "extra_inputs": ["grub-core/" + s for s in srcs if s.endswith(".h")],
        "nodist": g.values(defn, gentpl_name, "nodist_sources").split(),
        "depends": list(defn.find_all("depends")),
    }
    for field in ["cflags", "cppflags", "ldflags", "ccasflags"]:
        e[field], dirs = expand(flags_of, g.values(defn, gentpl_name, field), new)
        if field == "cppflags":
            e["include_dirs"] = dirs
        elif dirs:
            raise SystemExit(f"include directories in {field} of {gentpl_name}")
    if kind == "kernel":
        e["startup"] = ["grub-core/" + s for s in g.values(defn, gentpl_name, "startup").split()]
        e["stripflags"] = g.values(defn, gentpl_name, "stripflags").split()
        e["nostrip"] = g.tagged(defn, gentpl_name, "nostrip")
    if kind == "image":
        e["objcopyflags"] = g.values(defn, gentpl_name, "objcopyflags").split()
    if kind == "program":
        e["ldadd"] = g.values(defn, gentpl_name, "ldadd")
    cond = g.ns["platform_specific_values"](defn, gentpl_name, "_condition", "condition").split()
    if cond:
        e["condition"] = cond[0]
    return {k: v for k, v in e.items() if v not in ([], "", None)}


def headers_under(src: Path, directory: str | None) -> list[str]:
    """The headers below `directory`, repository-relative."""
    if not directory or not (src / directory).is_dir():
        return []
    return sorted(str(p.relative_to(src)) for p in (src / directory).rglob("*.h"))


def platform_data(g: Gentpl, src: Path, makefile_am: str, name: str, gentpl_name: str, new: bool) -> Entry:
    """Everything the module publishes for one platform."""
    pci = g.groups["pci"]
    flags_of = target_flags(name, new, pci)
    d: Entry = {"name": name, "gentpl_platform": gentpl_name, **flags_of}
    d["kernel_headers"] = kernel_headers(makefile_am, gentpl_name, flags_of, new, pci)
    d["cpu_hdrs"] = headers_under(src, flags_of["cpu_dir"])
    d["machine_hdrs"] = headers_under(src, flags_of["machine_dir"])
    for kind, key in [("kernel", "kernel"), ("module", "modules"), ("image", "images"), ("program", "programs")]:
        tab: dict[str, Entry] = {}
        for defn in g.defs.definitions.find_all(kind):
            if not g.enabled(defn, gentpl_name):
                continue
            e = entry(g, gentpl_name, flags_of, defn, kind, new)
            if e.get("srcs") or e.get("startup") or e.get("nodist") or kind == "kernel":
                tab[defn["name"]] = e
        d[key] = tab.get("kernel") if kind == "kernel" else dict(sorted(tab.items()))
    if gentpl_name == "i386_qemu" and d["kernel"]:
        # kern/vga_init.c includes ascii.h, which build-grub-gen-asciih makes
        # from unifont (grub-core/Makefile.am, COND_HAVE_FONT_SOURCE).
        d["kernel"]["nodist"] = d["kernel"].get("nodist", []) + ["ascii.h"]
    d["data"] = {
        defn["name"]: "grub-core/" + g.values(defn, gentpl_name, "sources").split()[0]
        for defn in g.defs.definitions.find_all("transform_data")
        if g.enabled(defn, gentpl_name) and g.values(defn, gentpl_name, "sources")
    }
    return d


def emit(v: Any, indent: int = 0, label: bool = False) -> str:
    """A value as Starlark source; strings in label fields become Label()s."""
    pad = " " * indent
    if isinstance(v, dict):
        if not v:
            return "{}"
        items = [f'{pad}    "{k}": {emit(v[k], indent + 4, label or k in LABEL_FIELDS)},' for k in sorted(v)]
        return "{\n" + "\n".join(items) + "\n" + pad + "}"
    if isinstance(v, list):
        if not v:
            return "[]"
        return "[\n" + "\n".join(f"{pad}    {emit(x, indent + 4, label)}," for x in v) + "\n" + pad + "]"
    if v is None:
        return "None"
    if isinstance(v, bool):
        return "True" if v else "False"
    if isinstance(v, str):
        if label and v:
            return f'Label("//:{v}")'
        escaped = v.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
        return f'"{escaped}"'
    raise SystemExit(repr(v))


def write_starlark(path: Path, text: str, buildifier: str | None) -> None:
    """Writes `text` to `path`, formatted and lint-fixed by buildifier when available."""
    if buildifier:
        result = subprocess.run(
            [buildifier, "-type=bzl", "-lint=fix", "-warnings=all", f"-path={path.name}"],
            input=text,
            capture_output=True,
            text=True,
            check=True,
        )
        text = result.stdout
    path.write_text(text)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("source_dir", type=Path, help="Path to the extracted GRUB source tree")
    parser.add_argument("--version", help="GRUB version (read from configure.ac's AC_INIT if omitted)")
    parser.add_argument(
        "--bcr-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent.parent,
        help="Path to bazel-central-registry root",
    )
    args = parser.parse_args()
    src = args.source_dir.resolve()
    ver = args.version
    if not ver:
        match = re.search(r"AC_INIT\(\[GRUB\],\[([^\]]+)\]", (src / "configure.ac").read_text())
        if not match:
            raise SystemExit("cannot read the version from configure.ac; pass --version")
        ver = match.group(1)
    # Flag logic that changed between 2.06 and 2.14 (configure.ac diff); a
    # newer release needs this reviewed, not just bumped.
    new = tuple(int(x) for x in ver.split(".")[:2]) >= (2, 12)
    out = args.bcr_root / "modules" / "grub" / ver / "overlay" / "platform"
    out.mkdir(parents=True, exist_ok=True)
    buildifier = shutil.which("buildifier")
    if not buildifier:
        print("warning: buildifier not found on PATH; writing unformatted output")

    g = Gentpl(src)
    makefile_am = (src / "grub-core" / "Makefile.am").read_text()
    names: list[tuple[str, str]] = []
    for p in g.platforms:
        names.append((p, p))
        if p in MIPSEL_VARIANTS:
            names.append((MIPSEL_VARIANTS[p], p))
    for name, gentpl_name in names:
        data = platform_data(g, src, makefile_am, name, gentpl_name, new)
        text = PLATFORM_HEADER.format(ver=ver, name=name, gentpl=gentpl_name) + f"{name.upper()} = {emit(data)}\n"
        write_starlark(out / f"{name}.bzl", text, buildifier)
    all_names = sorted(n for n, _ in names)
    index = INDEX_HEADER.format(ver=ver)
    index += "\n".join(f'load(":{n}.bzl", "{n.upper()}")' for n in all_names) + "\n\n"
    index += f"PLATFORMS = {emit([n for n, _ in names])}\n\nGROUPS = {emit(g.groups)}\n\n"
    index += "PLATFORM_DATA = {\n" + "\n".join(f'    "{n}": {n.upper()},' for n in all_names) + "\n}\n"
    write_starlark(out / "platforms.bzl", index, buildifier)
    print(f"wrote {out}: {len(names)} platforms")


if __name__ == "__main__":
    main()
