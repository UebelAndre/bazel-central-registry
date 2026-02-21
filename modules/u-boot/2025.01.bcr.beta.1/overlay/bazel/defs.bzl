"""Core macros for the U-Boot Bazel build."""

load("@rules_cc//cc:cc_library.bzl", "cc_library")

visibility(["//..."])

UBOOT_VERSION = "2025.01"

_COMMON_COPTS = [
    "-include",
    "include/linux/kconfig.h",
    "-include",
    "include/generated/autoconf_fixup.h",
    "-w",
    "-fno-builtin",
    "-ffreestanding",
    "-fshort-wchar",
    "-fno-strict-aliasing",
    "-fno-stack-protector",
    "-fno-delete-null-pointer-checks",
    "-ffunction-sections",
    "-fdata-sections",
    "-fmacro-prefix-map=./=",
]

_COMMON_DEFINES = [
    "__KERNEL__",
    "__UBOOT__",
]

_COMMON_COPTS_EXTRA = [
    '-DCONFIG_ENV_CALLBACK_LIST_STATIC=\\"\\"',
    '-DCONFIG_IDENT_STRING=\\"\\"',
    '-DKBUILD_MODNAME=\\"uboot\\"',
]

def uboot_copts():
    """Return the standard U-Boot compilation flags."""
    return _COMMON_COPTS + _COMMON_COPTS_EXTRA + select({
        Label("//:arch_sandbox"): ["-fPIC"],
        "//conditions:default": ["-fno-PIE"],
    }) + select({
        Label("//:CONFIG_CC_OPTIMIZE_FOR_SIZE"): ["-Os"],
        Label("//:CONFIG_CC_OPTIMIZE_FOR_SPEED"): ["-O2"],
        "//conditions:default": ["-Os"],
    })

def uboot_defines():
    """Return the standard U-Boot preprocessor defines."""
    return _COMMON_DEFINES + select({
        Label("//:arch_sandbox"): ["__SANDBOX__"],
        "//conditions:default": [],
    })

def uboot_includes():
    """Return architecture-specific and feature-conditional include paths."""
    return [".", "include"] + select({
        Label("//:arch_arc"): ["arch/arc/include"],
        Label("//:arch_arm"): ["arch/arm/include"],
        Label("//:arch_m68k"): ["arch/m68k/include"],
        Label("//:arch_microblaze"): ["arch/microblaze/include"],
        Label("//:arch_mips"): ["arch/mips/include"],
        Label("//:arch_nios2"): ["arch/nios2/include"],
        Label("//:arch_powerpc"): ["arch/powerpc/include"],
        Label("//:arch_riscv"): ["arch/riscv/include"],
        Label("//:arch_sandbox"): ["arch/sandbox/include"],
        Label("//:arch_sh"): ["arch/sh/include"],
        Label("//:arch_x86"): ["arch/x86/include"],
        Label("//:arch_xtensa"): ["arch/xtensa/include"],
    })

_KCONFIG_SETTINGS_PREFIX = "@u-boot_kconfig//settings:kconfig."

def kconfig_select(config, srcs):
    """Map a Kconfig obj-$(CONFIG_FOO) pattern to a Bazel select().

    Args:
        config: CONFIG_* symbol name (e.g. "CONFIG_AES").
        srcs: Source file(s) to include when the config is enabled.
    """
    return select({
        _KCONFIG_SETTINGS_PREFIX + config + "_Y": srcs if type(srcs) == "list" else [srcs],
        "//conditions:default": [],
    })

def uboot_cc_library(
        *,
        name,
        srcs = [],
        hdrs = [],
        deps = [],
        copts = [],
        local_defines = [],
        includes = [],
        textual_hdrs = [],
        **kwargs):
    """Wrapper around cc_library with U-Boot defaults.

    Sets alwayslink = True (required for U-Boot's linker section
    registration) and adds standard copts/deps/defines/includes.
    """
    cc_library(
        name = name,
        srcs = srcs,
        hdrs = hdrs,
        textual_hdrs = textual_hdrs,
        copts = uboot_copts() + copts,
        local_defines = uboot_defines() + local_defines,
        includes = uboot_includes() + includes,
        deps = [Label("//:asm_arch_headers"), Label("//:generated_headers")] + deps,
        alwayslink = kwargs.pop("alwayslink", True),
        features = ["-supports_dynamic_linker"],
        **kwargs
    )
