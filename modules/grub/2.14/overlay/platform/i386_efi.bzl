"""GRUB 2.14 build data for the i386_efi firmware platform (see common.bzl).

Generated from grub-core/Makefile.core.def and Makefile.gcry.def as gentpl.py
expands them for `i386_efi`, and from configure.ac's target-compiler section.
"""

I386_EFI = {
    "cflags_platform": [
        "-DGRUB_HAS_PCI",
    ],
    "config_h": {
        "BSS_START_SYMBOL": "__bss_start",
        "END_SYMBOL": "end",
        "GRUB_PLATFORM": "efi",
        "GRUB_TARGET_CPU": "i386",
        "HAVE_ASM_USCORE": "0",
    },
    "cppflags_gcry_asm": [],
    "cpu_dir": "include/grub/i386",
    "cpu_hdrs": [
        Label("//:include/grub/i386/at_keyboard.h"),
        Label("//:include/grub/i386/bsd.h"),
        Label("//:include/grub/i386/cmos.h"),
        Label("//:include/grub/i386/coreboot/boot.h"),
        Label("//:include/grub/i386/coreboot/console.h"),
        Label("//:include/grub/i386/coreboot/kernel.h"),
        Label("//:include/grub/i386/coreboot/memory.h"),
        Label("//:include/grub/i386/coreboot/serial.h"),
        Label("//:include/grub/i386/coreboot/time.h"),
        Label("//:include/grub/i386/cpuid.h"),
        Label("//:include/grub/i386/efi/kernel.h"),
        Label("//:include/grub/i386/efi/memory.h"),
        Label("//:include/grub/i386/efi/serial.h"),
        Label("//:include/grub/i386/efiemu.h"),
        Label("//:include/grub/i386/floppy.h"),
        Label("//:include/grub/i386/freebsd_linker.h"),
        Label("//:include/grub/i386/freebsd_reboot.h"),
        Label("//:include/grub/i386/gdb.h"),
        Label("//:include/grub/i386/ieee1275/ieee1275.h"),
        Label("//:include/grub/i386/ieee1275/kernel.h"),
        Label("//:include/grub/i386/ieee1275/memory.h"),
        Label("//:include/grub/i386/ieee1275/serial.h"),
        Label("//:include/grub/i386/io.h"),
        Label("//:include/grub/i386/linux.h"),
        Label("//:include/grub/i386/macho.h"),
        Label("//:include/grub/i386/memory.h"),
        Label("//:include/grub/i386/memory_raw.h"),
        Label("//:include/grub/i386/msr.h"),
        Label("//:include/grub/i386/multiboot.h"),
        Label("//:include/grub/i386/multiboot/boot.h"),
        Label("//:include/grub/i386/multiboot/console.h"),
        Label("//:include/grub/i386/multiboot/kernel.h"),
        Label("//:include/grub/i386/multiboot/memory.h"),
        Label("//:include/grub/i386/multiboot/serial.h"),
        Label("//:include/grub/i386/multiboot/time.h"),
        Label("//:include/grub/i386/netbsd_bootinfo.h"),
        Label("//:include/grub/i386/netbsd_reboot.h"),
        Label("//:include/grub/i386/openbsd_bootarg.h"),
        Label("//:include/grub/i386/openbsd_reboot.h"),
        Label("//:include/grub/i386/pc/apm.h"),
        Label("//:include/grub/i386/pc/biosdisk.h"),
        Label("//:include/grub/i386/pc/biosnum.h"),
        Label("//:include/grub/i386/pc/boot.h"),
        Label("//:include/grub/i386/pc/chainloader.h"),
        Label("//:include/grub/i386/pc/console.h"),
        Label("//:include/grub/i386/pc/int.h"),
        Label("//:include/grub/i386/pc/int_types.h"),
        Label("//:include/grub/i386/pc/kernel.h"),
        Label("//:include/grub/i386/pc/memory.h"),
        Label("//:include/grub/i386/pc/pxe.h"),
        Label("//:include/grub/i386/pc/time.h"),
        Label("//:include/grub/i386/pc/vbe.h"),
        Label("//:include/grub/i386/pc/vesa_modes_table.h"),
        Label("//:include/grub/i386/pci.h"),
        Label("//:include/grub/i386/pit.h"),
        Label("//:include/grub/i386/pmtimer.h"),
        Label("//:include/grub/i386/qemu/boot.h"),
        Label("//:include/grub/i386/qemu/console.h"),
        Label("//:include/grub/i386/qemu/kernel.h"),
        Label("//:include/grub/i386/qemu/memory.h"),
        Label("//:include/grub/i386/qemu/serial.h"),
        Label("//:include/grub/i386/qemu/time.h"),
        Label("//:include/grub/i386/reboot.h"),
        Label("//:include/grub/i386/relocator.h"),
        Label("//:include/grub/i386/relocator_private.h"),
        Label("//:include/grub/i386/setjmp.h"),
        Label("//:include/grub/i386/time.h"),
        Label("//:include/grub/i386/tsc.h"),
        Label("//:include/grub/i386/types.h"),
        Label("//:include/grub/i386/xen/hypercall.h"),
        Label("//:include/grub/i386/xen/kernel.h"),
        Label("//:include/grub/i386/xen/memory.h"),
        Label("//:include/grub/i386/xen_pvh/boot.h"),
        Label("//:include/grub/i386/xen_pvh/console.h"),
        Label("//:include/grub/i386/xen_pvh/int.h"),
        Label("//:include/grub/i386/xen_pvh/kernel.h"),
        Label("//:include/grub/i386/xen_pvh/memory.h"),
        Label("//:include/grub/i386/xen_pvh/time.h"),
        Label("//:include/grub/i386/xnu.h"),
    ],
    "data": {
        "gdb_grub": Label("//:grub-core/gdb_grub.in"),
        "gdb_helper.py": Label("//:grub-core/gdb_helper.py.in"),
        "genmod.sh": Label("//:grub-core/genmod.sh.in"),
        "gensyminfo.sh": Label("//:grub-core/gensyminfo.sh.in"),
        "modinfo.sh": Label("//:grub-core/modinfo.sh.in"),
    },
    "efiemu": None,
    "gentpl_platform": "i386_efi",
    "images": {},
    "img_base_ldopt": "-Wl,-Ttext",
    "img_cflags": [],
    "img_ldflags": [
        "-Wl,-N",
    ],
    "kernel": {
        "cflags": [
            "-fshort-wchar",
        ],
        "ldflags": [
            "-Wl,-r",
        ],
        "nodist": [
            "symlist.c",
        ],
        "nostrip": False,
        "srcs": [
            Label("//:grub-core/bus/pci.c"),
            Label("//:grub-core/disk/efi/efidisk.c"),
            Label("//:grub-core/kern/acpi.c"),
            Label("//:grub-core/kern/buffer.c"),
            Label("//:grub-core/kern/command.c"),
            Label("//:grub-core/kern/compiler-rt.c"),
            Label("//:grub-core/kern/corecmd.c"),
            Label("//:grub-core/kern/device.c"),
            Label("//:grub-core/kern/disk.c"),
            Label("//:grub-core/kern/dl.c"),
            Label("//:grub-core/kern/efi/acpi.c"),
            Label("//:grub-core/kern/efi/debug.c"),
            Label("//:grub-core/kern/efi/efi.c"),
            Label("//:grub-core/kern/efi/init.c"),
            Label("//:grub-core/kern/efi/mm.c"),
            Label("//:grub-core/kern/efi/sb.c"),
            Label("//:grub-core/kern/env.c"),
            Label("//:grub-core/kern/err.c"),
            Label("//:grub-core/kern/file.c"),
            Label("//:grub-core/kern/fs.c"),
            Label("//:grub-core/kern/generic/millisleep.c"),
            Label("//:grub-core/kern/i386/dl.c"),
            Label("//:grub-core/kern/i386/efi/init.c"),
            Label("//:grub-core/kern/i386/efi/tsc.c"),
            Label("//:grub-core/kern/i386/tsc.c"),
            Label("//:grub-core/kern/i386/tsc_pit.c"),
            Label("//:grub-core/kern/i386/tsc_pmtimer.c"),
            Label("//:grub-core/kern/list.c"),
            Label("//:grub-core/kern/lockdown.c"),
            Label("//:grub-core/kern/main.c"),
            Label("//:grub-core/kern/misc.c"),
            Label("//:grub-core/kern/mm.c"),
            Label("//:grub-core/kern/parser.c"),
            Label("//:grub-core/kern/partition.c"),
            Label("//:grub-core/kern/rescue_parser.c"),
            Label("//:grub-core/kern/rescue_reader.c"),
            Label("//:grub-core/kern/term.c"),
            Label("//:grub-core/kern/time.c"),
            Label("//:grub-core/kern/verifiers.c"),
            Label("//:grub-core/term/efi/console.c"),
        ],
        "startup": [
            Label("//:grub-core/kern/i386/efi/startup.S"),
        ],
        "stripflags": [
            "--strip-unneeded",
            "-K",
            "start",
            "-R",
            ".note",
            "-R",
            ".comment",
            "-R",
            ".note.gnu.gold-version",
        ],
    },
    "kernel_headers": [
        Label("//:include/grub/cache.h"),
        Label("//:include/grub/command.h"),
        Label("//:include/grub/device.h"),
        Label("//:include/grub/disk.h"),
        Label("//:include/grub/dl.h"),
        Label("//:include/grub/efi/sb.h"),
        Label("//:include/grub/env.h"),
        Label("//:include/grub/env_private.h"),
        Label("//:include/grub/err.h"),
        Label("//:include/grub/file.h"),
        Label("//:include/grub/fs.h"),
        Label("//:include/grub/i18n.h"),
        Label("//:include/grub/kernel.h"),
        Label("//:include/grub/list.h"),
        Label("//:include/grub/lockdown.h"),
        Label("//:include/grub/misc.h"),
        Label("//:include/grub/compiler-rt.h"),
        Label("//:include/grub/mm.h"),
        Label("//:include/grub/parser.h"),
        Label("//:include/grub/partition.h"),
        Label("//:include/grub/key_protector.h"),
        Label("//:include/grub/stack_protector.h"),
        Label("//:include/grub/term.h"),
        Label("//:include/grub/time.h"),
        Label("//:include/grub/verify.h"),
        Label("//:include/grub/mm_private.h"),
        Label("//:include/grub/net.h"),
        Label("//:include/grub/memory.h"),
        Label("//:include/grub/i386/efi/kernel.h"),
        Label("//:include/grub/efi/efi.h"),
        Label("//:include/grub/efi/disk.h"),
        Label("//:include/grub/i386/tsc.h"),
        Label("//:include/grub/acpi.h"),
        Label("//:include/grub/pci.h"),
        Label("//:include/grub/i386/pmtimer.h"),
    ],
    "ldflags_oldmagic": "-Wl,-N",
    "ldflags_platform": [],
    "link_addr": {},
    "literal_flags": {
        "ccasflags": [
            "-m32",
            "-g",
        ],
        "cflags": [
            "-std=gnu99",
            "-fno-common",
            "-Os",
            "-m32",
            "-g",
            "-march=i386",
            "-falign-functions=1",
            "-mno-mmx",
            "-mno-sse",
            "-mno-sse2",
            "-mno-sse3",
            "-mno-3dnow",
        ],
        "cppflags": [
            "-DGRUB_MACHINE_EFI=1",
            "-DGRUB_MACHINE=I386_EFI",
            "-m32",
        ],
        "ldflags": [
            "-m32",
            "-Wl,-melf_i386",
            "-Wl,--build-id=none",
        ],
    },
    "machine_dir": "include/grub/i386/efi",
    "machine_hdrs": [
        Label("//:include/grub/i386/efi/kernel.h"),
        Label("//:include/grub/i386/efi/memory.h"),
        Label("//:include/grub/i386/efi/serial.h"),
    ],
    "module_format": "elf32",
    "modules": {
        "acpi": {
            "srcs": [
                Label("//:grub-core/commands/acpi.c"),
            ],
        },
        "adler32": {
            "srcs": [
                Label("//:grub-core/lib/adler32.c"),
            ],
        },
        "affs": {
            "srcs": [
                Label("//:grub-core/fs/affs.c"),
            ],
        },
        "afs": {
            "srcs": [
                Label("//:grub-core/fs/afs.c"),
            ],
        },
        "afsplitter": {
            "srcs": [
                Label("//:grub-core/disk/AFSplitter.c"),
            ],
        },
        "ahci": {
            "srcs": [
                Label("//:grub-core/disk/ahci.c"),
            ],
        },
        "all_video": {
            "srcs": [
                Label("//:grub-core/lib/fake_module.c"),
            ],
        },
        "aout": {
            "srcs": [
                Label("//:grub-core/loader/aout.c"),
            ],
        },
        "appleldr": {
            "srcs": [
                Label("//:grub-core/loader/efi/appleloader.c"),
            ],
        },
        "archelp": {
            "srcs": [
                Label("//:grub-core/fs/archelp.c"),
            ],
        },
        "argon2": {
            "srcs": [
                Label("//:grub-core/lib/argon2.c"),
            ],
        },
        "argon2_test": {
            "srcs": [
                Label("//:grub-core/tests/argon2_test.c"),
            ],
        },
        "asn1": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/gnulib",
                "grub-core/lib/libtasn1-grub",
                "grub-core/lib/libtasn1-grub/lib",
            ],
            "srcs": [
                Label("//:grub-core/lib/libtasn1-grub/lib/coding.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/decoding.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/element.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/errors.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/gstr.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/parser_aux.c"),
                Label("//:grub-core/lib/libtasn1-grub/lib/structure.c"),
                Label("//:grub-core/lib/libtasn1_wrap/wrap.c"),
            ],
        },
        "asn1_test": {
            "include_dirs": [
                "grub-core/lib/libtasn1-grub",
                "grub-core/tests/asn1",
            ],
            "srcs": [
                Label("//:grub-core/tests/asn1/asn1_test.c"),
                Label("//:grub-core/tests/asn1/tests/CVE-2018-1000654.c"),
                Label("//:grub-core/tests/asn1/tests/Test_overflow.c"),
                Label("//:grub-core/tests/asn1/tests/Test_simple.c"),
                Label("//:grub-core/tests/asn1/tests/Test_strings.c"),
                Label("//:grub-core/tests/asn1/tests/object-id-decoding.c"),
                Label("//:grub-core/tests/asn1/tests/object-id-encoding.c"),
                Label("//:grub-core/tests/asn1/tests/octet-string.c"),
                Label("//:grub-core/tests/asn1/tests/reproducers.c"),
            ],
        },
        "at_keyboard": {
            "srcs": [
                Label("//:grub-core/term/at_keyboard.c"),
                Label("//:grub-core/term/ps2.c"),
            ],
        },
        "ata": {
            "srcs": [
                Label("//:grub-core/disk/ata.c"),
            ],
        },
        "backtrace": {
            "srcs": [
                Label("//:grub-core/lib/backtrace.c"),
                Label("//:grub-core/lib/i386/backtrace.c"),
            ],
        },
        "bfs": {
            "srcs": [
                Label("//:grub-core/fs/bfs.c"),
            ],
        },
        "bitmap": {
            "srcs": [
                Label("//:grub-core/video/bitmap.c"),
            ],
        },
        "bitmap_scale": {
            "srcs": [
                Label("//:grub-core/video/bitmap_scale.c"),
            ],
        },
        "bli": {
            "depends": [
                "part_gpt",
            ],
            "srcs": [
                Label("//:grub-core/commands/bli.c"),
            ],
        },
        "blocklist": {
            "srcs": [
                Label("//:grub-core/commands/blocklist.c"),
            ],
        },
        "blsuki": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/gnulib",
            ],
            "srcs": [
                Label("//:grub-core/commands/blsuki.c"),
                Label("//:grub-core/lib/gnulib/filevercmp.c"),
            ],
        },
        "boot": {
            "srcs": [
                Label("//:grub-core/commands/boot.c"),
            ],
        },
        "boottime": {
            "condition": "COND_ENABLE_BOOT_TIME_STATS",
            "srcs": [
                Label("//:grub-core/commands/boottime.c"),
            ],
        },
        "bsd": {
            "srcs": [
                Label("//:grub-core/loader/i386/bsd.c"),
                Label("//:grub-core/loader/i386/bsd32.c"),
                Label("//:grub-core/loader/i386/bsd64.c"),
            ],
        },
        "bswap_test": {
            "srcs": [
                Label("//:grub-core/tests/bswap_test.c"),
            ],
        },
        "btrfs": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-DMINILZO_HAVE_CONFIG_H",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/minilzo",
                "grub-core/lib/zstd",
            ],
            "srcs": [
                Label("//:grub-core/fs/btrfs.c"),
                Label("//:grub-core/lib/crc.c"),
            ],
        },
        "bufio": {
            "srcs": [
                Label("//:grub-core/io/bufio.c"),
            ],
        },
        "cacheinfo": {
            "condition": "COND_ENABLE_CACHE_STATS",
            "srcs": [
                Label("//:grub-core/commands/cacheinfo.c"),
            ],
        },
        "cat": {
            "srcs": [
                Label("//:grub-core/commands/cat.c"),
            ],
        },
        "cbfs": {
            "srcs": [
                Label("//:grub-core/fs/cbfs.c"),
            ],
        },
        "cbls": {
            "srcs": [
                Label("//:grub-core/commands/i386/coreboot/cbls.c"),
            ],
        },
        "cbmemc": {
            "srcs": [
                Label("//:grub-core/term/i386/coreboot/cbmemc.c"),
            ],
        },
        "cbtable": {
            "srcs": [
                Label("//:grub-core/kern/coreboot/cbtable.c"),
                Label("//:grub-core/kern/i386/coreboot/cbtable.c"),
            ],
        },
        "cbtime": {
            "srcs": [
                Label("//:grub-core/commands/i386/coreboot/cb_timestamps.c"),
            ],
        },
        "chain": {
            "srcs": [
                Label("//:grub-core/loader/efi/chainloader.c"),
            ],
        },
        "cmosdump": {
            "srcs": [
                Label("//:grub-core/commands/i386/cmosdump.c"),
            ],
        },
        "cmostest": {
            "srcs": [
                Label("//:grub-core/commands/i386/cmostest.c"),
            ],
        },
        "cmp": {
            "srcs": [
                Label("//:grub-core/commands/cmp.c"),
            ],
        },
        "cmp_test": {
            "srcs": [
                Label("//:grub-core/tests/cmp_test.c"),
            ],
        },
        "configfile": {
            "srcs": [
                Label("//:grub-core/commands/configfile.c"),
            ],
        },
        "cpio": {
            "srcs": [
                Label("//:grub-core/fs/cpio.c"),
            ],
        },
        "cpio_be": {
            "srcs": [
                Label("//:grub-core/fs/cpio_be.c"),
            ],
        },
        "cpuid": {
            "srcs": [
                Label("//:grub-core/commands/i386/cpuid.c"),
            ],
        },
        "crc64": {
            "srcs": [
                Label("//:grub-core/lib/crc64.c"),
            ],
        },
        "crypto": {
            "srcs": [
                Label("//:grub-core/lib/crypto.c"),
                Label("//:grub-core/lib/hwfeatures-gcry.c"),
            ],
        },
        "crypto_cipher_mode_test": {
            "srcs": [
                Label("//:grub-core/tests/crypto_cipher_mode_test.c"),
            ],
        },
        "cryptodisk": {
            "srcs": [
                Label("//:grub-core/disk/cryptodisk.c"),
            ],
        },
        "cs5536": {
            "srcs": [
                Label("//:grub-core/bus/cs5536.c"),
            ],
        },
        "ctz_test": {
            "srcs": [
                Label("//:grub-core/tests/ctz_test.c"),
            ],
        },
        "date": {
            "srcs": [
                Label("//:grub-core/commands/date.c"),
            ],
        },
        "datehook": {
            "srcs": [
                Label("//:grub-core/hook/datehook.c"),
            ],
        },
        "datetime": {
            "srcs": [
                Label("//:grub-core/lib/datetime.c"),
                Label("//:grub-core/lib/efi/datetime.c"),
            ],
        },
        "disk": {
            "srcs": [
                Label("//:grub-core/lib/disk.c"),
            ],
        },
        "diskfilter": {
            "srcs": [
                Label("//:grub-core/disk/diskfilter.c"),
            ],
        },
        "div": {
            "srcs": [
                Label("//:grub-core/lib/division.c"),
            ],
        },
        "div_test": {
            "srcs": [
                Label("//:grub-core/tests/div_test.c"),
            ],
        },
        "dm_nv": {
            "srcs": [
                Label("//:grub-core/disk/dmraid_nvidia.c"),
            ],
        },
        "dsa_sexp_test": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/tests/dsa_sexp_test.c"),
            ],
        },
        "echo": {
            "srcs": [
                Label("//:grub-core/commands/echo.c"),
            ],
        },
        "efi_gop": {
            "srcs": [
                Label("//:grub-core/video/efi_gop.c"),
            ],
        },
        "efi_uga": {
            "srcs": [
                Label("//:grub-core/video/efi_uga.c"),
            ],
        },
        "efifwsetup": {
            "srcs": [
                Label("//:grub-core/commands/efi/efifwsetup.c"),
            ],
        },
        "efinet": {
            "srcs": [
                Label("//:grub-core/net/drivers/efi/efinet.c"),
            ],
        },
        "efitextmode": {
            "srcs": [
                Label("//:grub-core/commands/efi/efitextmode.c"),
            ],
        },
        "ehci": {
            "srcs": [
                Label("//:grub-core/bus/usb/ehci-pci.c"),
                Label("//:grub-core/bus/usb/ehci.c"),
            ],
        },
        "elf": {
            "srcs": [
                Label("//:grub-core/kern/elf.c"),
            ],
        },
        "erofs": {
            "srcs": [
                Label("//:grub-core/fs/erofs.c"),
            ],
        },
        "eval": {
            "srcs": [
                Label("//:grub-core/commands/eval.c"),
            ],
        },
        "exfat": {
            "srcs": [
                Label("//:grub-core/fs/exfat.c"),
            ],
        },
        "exfctest": {
            "srcs": [
                Label("//:grub-core/tests/example_functional_test.c"),
            ],
        },
        "ext2": {
            "srcs": [
                Label("//:grub-core/fs/ext2.c"),
            ],
        },
        "extcmd": {
            "srcs": [
                Label("//:grub-core/commands/extcmd.c"),
                Label("//:grub-core/lib/arg.c"),
            ],
        },
        "f2fs": {
            "srcs": [
                Label("//:grub-core/fs/f2fs.c"),
            ],
        },
        "fat": {
            "srcs": [
                Label("//:grub-core/fs/fat.c"),
            ],
        },
        "file": {
            "srcs": [
                Label("//:grub-core/commands/file.c"),
                Label("//:grub-core/commands/file32.c"),
                Label("//:grub-core/commands/file64.c"),
                Label("//:grub-core/loader/i386/xen_file.c"),
                Label("//:grub-core/loader/i386/xen_file32.c"),
                Label("//:grub-core/loader/i386/xen_file64.c"),
            ],
        },
        "fixvideo": {
            "srcs": [
                Label("//:grub-core/commands/efi/fixvideo.c"),
            ],
        },
        "font": {
            "srcs": [
                Label("//:grub-core/font/font.c"),
                Label("//:grub-core/font/font_cmd.c"),
            ],
        },
        "fshelp": {
            "srcs": [
                Label("//:grub-core/fs/fshelp.c"),
            ],
        },
        "functional_test": {
            "extra_inputs": [
                Label("//:grub-core/tests/checksums.h"),
            ],
            "srcs": [
                Label("//:grub-core/tests/fake_input.c"),
                Label("//:grub-core/tests/lib/functional_test.c"),
                Label("//:grub-core/tests/lib/test.c"),
                Label("//:grub-core/tests/video_checksum.c"),
                Label("//:grub-core/video/capture.c"),
            ],
        },
        "gcry_arcfour": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/arcfour.c"),
            ],
        },
        "gcry_aria": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/aria.c"),
            ],
        },
        "gcry_blake2": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/blake2.c"),
            ],
        },
        "gcry_blowfish": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/blowfish.c"),
            ],
        },
        "gcry_camellia": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/camellia-glue.c"),
                Label("//:grub-core/lib/libgcrypt-grub/cipher/camellia.c"),
            ],
        },
        "gcry_cast5": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/cast5.c"),
            ],
        },
        "gcry_crc": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/crc.c"),
            ],
        },
        "gcry_des": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/des.c"),
            ],
        },
        "gcry_dsa": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/dsa.c"),
            ],
        },
        "gcry_gost28147": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/gost28147.c"),
            ],
        },
        "gcry_gostr3411_94": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/gostr3411-94.c"),
            ],
        },
        "gcry_hwfeatures": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/src/hwfeatures.c"),
            ],
        },
        "gcry_idea": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/idea.c"),
            ],
        },
        "gcry_kdf": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/kdf.c"),
            ],
        },
        "gcry_keccak": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/keccak.c"),
            ],
        },
        "gcry_md4": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/md4.c"),
            ],
        },
        "gcry_md5": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/md5.c"),
            ],
        },
        "gcry_rfc2268": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/rfc2268.c"),
            ],
        },
        "gcry_rijndael": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/rijndael.c"),
            ],
        },
        "gcry_rmd160": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/rmd160.c"),
            ],
        },
        "gcry_rsa": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/rsa.c"),
            ],
        },
        "gcry_salsa20": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/salsa20.c"),
            ],
        },
        "gcry_seed": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/seed.c"),
            ],
        },
        "gcry_serpent": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/serpent.c"),
            ],
        },
        "gcry_sha1": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sha1.c"),
            ],
        },
        "gcry_sha256": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
                "-DUSE_SHA256",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sha256.c"),
            ],
        },
        "gcry_sha512": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
                "-DUSE_SHA512",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/hash-common.c"),
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sha512.c"),
            ],
        },
        "gcry_sm3": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sm3.c"),
            ],
        },
        "gcry_sm4": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sm4.c"),
            ],
        },
        "gcry_stribog": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/stribog.c"),
            ],
        },
        "gcry_tiger": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/tiger.c"),
            ],
        },
        "gcry_twofish": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/twofish.c"),
            ],
        },
        "gcry_whirlpool": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/whirlpool.c"),
            ],
        },
        "gdb": {
            "srcs": [
                Label("//:grub-core/gdb/cstub.c"),
                Label("//:grub-core/gdb/gdb.c"),
                Label("//:grub-core/gdb/i386/idt.c"),
                Label("//:grub-core/gdb/i386/machdep.S"),
                Label("//:grub-core/gdb/i386/signal.c"),
            ],
        },
        "geli": {
            "srcs": [
                Label("//:grub-core/disk/geli.c"),
            ],
        },
        "gettext": {
            "srcs": [
                Label("//:grub-core/gettext/gettext.c"),
            ],
        },
        "gfxmenu": {
            "srcs": [
                Label("//:grub-core/gfxmenu/font.c"),
                Label("//:grub-core/gfxmenu/gfxmenu.c"),
                Label("//:grub-core/gfxmenu/gui_box.c"),
                Label("//:grub-core/gfxmenu/gui_canvas.c"),
                Label("//:grub-core/gfxmenu/gui_circular_progress.c"),
                Label("//:grub-core/gfxmenu/gui_image.c"),
                Label("//:grub-core/gfxmenu/gui_label.c"),
                Label("//:grub-core/gfxmenu/gui_list.c"),
                Label("//:grub-core/gfxmenu/gui_progress_bar.c"),
                Label("//:grub-core/gfxmenu/gui_string_util.c"),
                Label("//:grub-core/gfxmenu/gui_util.c"),
                Label("//:grub-core/gfxmenu/icon_manager.c"),
                Label("//:grub-core/gfxmenu/theme_loader.c"),
                Label("//:grub-core/gfxmenu/view.c"),
                Label("//:grub-core/gfxmenu/widget-box.c"),
            ],
        },
        "gfxterm": {
            "srcs": [
                Label("//:grub-core/term/gfxterm.c"),
            ],
        },
        "gfxterm_background": {
            "srcs": [
                Label("//:grub-core/term/gfxterm_background.c"),
            ],
        },
        "gptsync": {
            "srcs": [
                Label("//:grub-core/commands/gptsync.c"),
            ],
        },
        "gzio": {
            "srcs": [
                Label("//:grub-core/io/gzio.c"),
            ],
        },
        "halt": {
            "srcs": [
                Label("//:grub-core/commands/acpihalt.c"),
                Label("//:grub-core/commands/halt.c"),
                Label("//:grub-core/lib/efi/halt.c"),
            ],
        },
        "hashsum": {
            "srcs": [
                Label("//:grub-core/commands/hashsum.c"),
            ],
        },
        "hdparm": {
            "srcs": [
                Label("//:grub-core/commands/hdparm.c"),
            ],
        },
        "hello": {
            "srcs": [
                Label("//:grub-core/hello/hello.c"),
            ],
        },
        "help": {
            "srcs": [
                Label("//:grub-core/commands/help.c"),
            ],
        },
        "hexdump": {
            "srcs": [
                Label("//:grub-core/commands/hexdump.c"),
                Label("//:grub-core/lib/hexdump.c"),
            ],
        },
        "hfs": {
            "srcs": [
                Label("//:grub-core/fs/hfs.c"),
            ],
        },
        "hfsplus": {
            "srcs": [
                Label("//:grub-core/fs/hfsplus.c"),
            ],
        },
        "hfspluscomp": {
            "srcs": [
                Label("//:grub-core/fs/hfspluscomp.c"),
            ],
        },
        "http": {
            "srcs": [
                Label("//:grub-core/net/http.c"),
            ],
        },
        "iorw": {
            "srcs": [
                Label("//:grub-core/commands/iorw.c"),
            ],
        },
        "iso9660": {
            "srcs": [
                Label("//:grub-core/fs/iso9660.c"),
            ],
        },
        "jfs": {
            "srcs": [
                Label("//:grub-core/fs/jfs.c"),
            ],
        },
        "jpeg": {
            "srcs": [
                Label("//:grub-core/video/readers/jpeg.c"),
            ],
        },
        "json": {
            "srcs": [
                Label("//:grub-core/lib/json/json.c"),
            ],
        },
        "key_protector": {
            "srcs": [
                Label("//:grub-core/disk/key_protector.c"),
            ],
        },
        "keylayouts": {
            "srcs": [
                Label("//:grub-core/commands/keylayouts.c"),
            ],
        },
        "keystatus": {
            "srcs": [
                Label("//:grub-core/commands/keystatus.c"),
            ],
        },
        "ldm": {
            "srcs": [
                Label("//:grub-core/disk/ldm.c"),
            ],
        },
        "legacy_password_test": {
            "srcs": [
                Label("//:grub-core/tests/legacy_password_test.c"),
            ],
        },
        "legacycfg": {
            "srcs": [
                Label("//:grub-core/commands/legacycfg.c"),
                Label("//:grub-core/lib/i386/pc/vesa_modes_table.c"),
                Label("//:grub-core/lib/legacy_parse.c"),
            ],
        },
        "linux": {
            "srcs": [
                Label("//:grub-core/lib/cmdline.c"),
                Label("//:grub-core/loader/efi/linux.c"),
                Label("//:grub-core/loader/i386/linux.c"),
                Label("//:grub-core/loader/linux.c"),
            ],
        },
        "linux16": {
            "srcs": [
                Label("//:grub-core/loader/i386/pc/linux.c"),
            ],
        },
        "loadbios": {
            "srcs": [
                Label("//:grub-core/commands/efi/loadbios.c"),
            ],
        },
        "loadenv": {
            "srcs": [
                Label("//:grub-core/commands/loadenv.c"),
                Label("//:grub-core/lib/envblk.c"),
            ],
        },
        "loopback": {
            "srcs": [
                Label("//:grub-core/disk/loopback.c"),
            ],
        },
        "ls": {
            "srcs": [
                Label("//:grub-core/commands/ls.c"),
            ],
        },
        "lsacpi": {
            "srcs": [
                Label("//:grub-core/commands/lsacpi.c"),
            ],
        },
        "lsefi": {
            "srcs": [
                Label("//:grub-core/commands/efi/lsefi.c"),
            ],
        },
        "lsefimmap": {
            "srcs": [
                Label("//:grub-core/commands/efi/lsefimmap.c"),
            ],
        },
        "lsefisystab": {
            "srcs": [
                Label("//:grub-core/commands/efi/lsefisystab.c"),
            ],
        },
        "lsmmap": {
            "srcs": [
                Label("//:grub-core/commands/lsmmap.c"),
            ],
        },
        "lspci": {
            "srcs": [
                Label("//:grub-core/commands/lspci.c"),
            ],
        },
        "lssal": {
            "srcs": [
                Label("//:grub-core/commands/efi/lssal.c"),
            ],
        },
        "luks": {
            "srcs": [
                Label("//:grub-core/disk/luks.c"),
            ],
        },
        "luks2": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/gnulib",
                "grub-core/lib/json",
            ],
            "srcs": [
                Label("//:grub-core/disk/luks2.c"),
                Label("//:grub-core/lib/gnulib/base64.c"),
            ],
        },
        "lvm": {
            "srcs": [
                Label("//:grub-core/disk/lvm.c"),
            ],
        },
        "lzopio": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-DMINILZO_HAVE_CONFIG_H",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/minilzo",
            ],
            "srcs": [
                Label("//:grub-core/io/lzopio.c"),
                Label("//:grub-core/lib/minilzo/minilzo.c"),
            ],
        },
        "macbless": {
            "srcs": [
                Label("//:grub-core/commands/macbless.c"),
            ],
        },
        "macho": {
            "srcs": [
                Label("//:grub-core/loader/lzss.c"),
                Label("//:grub-core/loader/macho.c"),
                Label("//:grub-core/loader/macho32.c"),
                Label("//:grub-core/loader/macho64.c"),
            ],
        },
        "mdraid09": {
            "srcs": [
                Label("//:grub-core/disk/mdraid_linux.c"),
            ],
        },
        "mdraid09_be": {
            "srcs": [
                Label("//:grub-core/disk/mdraid_linux_be.c"),
            ],
        },
        "mdraid1x": {
            "srcs": [
                Label("//:grub-core/disk/mdraid1x_linux.c"),
            ],
        },
        "memdisk": {
            "srcs": [
                Label("//:grub-core/disk/memdisk.c"),
            ],
        },
        "memrw": {
            "srcs": [
                Label("//:grub-core/commands/memrw.c"),
            ],
        },
        "memtools": {
            "condition": "COND_MM_DEBUG",
            "srcs": [
                Label("//:grub-core/commands/memtools.c"),
            ],
        },
        "minicmd": {
            "srcs": [
                Label("//:grub-core/commands/minicmd.c"),
            ],
        },
        "minix": {
            "srcs": [
                Label("//:grub-core/fs/minix.c"),
            ],
        },
        "minix2": {
            "srcs": [
                Label("//:grub-core/fs/minix2.c"),
            ],
        },
        "minix2_be": {
            "srcs": [
                Label("//:grub-core/fs/minix2_be.c"),
            ],
        },
        "minix3": {
            "srcs": [
                Label("//:grub-core/fs/minix3.c"),
            ],
        },
        "minix3_be": {
            "srcs": [
                Label("//:grub-core/fs/minix3_be.c"),
            ],
        },
        "minix_be": {
            "srcs": [
                Label("//:grub-core/fs/minix_be.c"),
            ],
        },
        "mmap": {
            "srcs": [
                Label("//:grub-core/mmap/efi/mmap.c"),
                Label("//:grub-core/mmap/i386/mmap.c"),
                Label("//:grub-core/mmap/i386/uppermem.c"),
                Label("//:grub-core/mmap/mmap.c"),
            ],
        },
        "morse": {
            "srcs": [
                Label("//:grub-core/term/morse.c"),
            ],
        },
        "mpi": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/md.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-add.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-bit.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-cmp.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-div.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-gcd.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-inline.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-inv.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mod.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mpow.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mul.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-pow.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-scan.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpicoder.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-add1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-const-time.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-div.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-lshift.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul2.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul3.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-rshift.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-sub1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpiutil.c"),
                Label("//:grub-core/lib/libgcrypt-grub/src/const-time.c"),
                Label("//:grub-core/lib/libgcrypt_wrap/mem.c"),
            ],
        },
        "msdospart": {
            "srcs": [
                Label("//:grub-core/parttool/msdospart.c"),
            ],
        },
        "mul_test": {
            "srcs": [
                Label("//:grub-core/tests/mul_test.c"),
            ],
        },
        "multiboot": {
            "srcs": [
                Label("//:grub-core/loader/i386/multiboot_mbi.c"),
                Label("//:grub-core/loader/multiboot.c"),
            ],
        },
        "multiboot2": {
            "cppflags": [
                "-DGRUB_USE_MULTIBOOT2",
            ],
            "srcs": [
                Label("//:grub-core/loader/multiboot.c"),
                Label("//:grub-core/loader/multiboot_mbi2.c"),
            ],
        },
        "nativedisk": {
            "srcs": [
                Label("//:grub-core/commands/nativedisk.c"),
            ],
        },
        "net": {
            "srcs": [
                Label("//:grub-core/net/arp.c"),
                Label("//:grub-core/net/bootp.c"),
                Label("//:grub-core/net/dns.c"),
                Label("//:grub-core/net/ethernet.c"),
                Label("//:grub-core/net/icmp.c"),
                Label("//:grub-core/net/icmp6.c"),
                Label("//:grub-core/net/ip.c"),
                Label("//:grub-core/net/net.c"),
                Label("//:grub-core/net/netbuff.c"),
                Label("//:grub-core/net/tcp.c"),
                Label("//:grub-core/net/udp.c"),
            ],
        },
        "newc": {
            "srcs": [
                Label("//:grub-core/fs/newc.c"),
            ],
        },
        "nilfs2": {
            "srcs": [
                Label("//:grub-core/fs/nilfs2.c"),
            ],
        },
        "normal": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
            ],
            "nodist": [
                "grub_script.tab.c",
                "grub_script.tab.h",
                "grub_script.yy.c",
                "grub_script.yy.h",
            ],
            "srcs": [
                Label("//:grub-core/commands/menuentry.c"),
                Label("//:grub-core/lib/getline.c"),
                Label("//:grub-core/normal/auth.c"),
                Label("//:grub-core/normal/autofs.c"),
                Label("//:grub-core/normal/charset.c"),
                Label("//:grub-core/normal/cmdline.c"),
                Label("//:grub-core/normal/color.c"),
                Label("//:grub-core/normal/completion.c"),
                Label("//:grub-core/normal/context.c"),
                Label("//:grub-core/normal/crypto.c"),
                Label("//:grub-core/normal/dyncmd.c"),
                Label("//:grub-core/normal/main.c"),
                Label("//:grub-core/normal/menu.c"),
                Label("//:grub-core/normal/menu_entry.c"),
                Label("//:grub-core/normal/menu_text.c"),
                Label("//:grub-core/normal/misc.c"),
                Label("//:grub-core/normal/term.c"),
                Label("//:grub-core/script/argv.c"),
                Label("//:grub-core/script/execute.c"),
                Label("//:grub-core/script/function.c"),
                Label("//:grub-core/script/lexer.c"),
                Label("//:grub-core/script/main.c"),
                Label("//:grub-core/script/script.c"),
                Label("//:grub-core/unidata.c"),
            ],
        },
        "ntfs": {
            "srcs": [
                Label("//:grub-core/fs/ntfs.c"),
            ],
        },
        "ntfscomp": {
            "srcs": [
                Label("//:grub-core/fs/ntfscomp.c"),
            ],
        },
        "odc": {
            "srcs": [
                Label("//:grub-core/fs/odc.c"),
            ],
        },
        "offsetio": {
            "srcs": [
                Label("//:grub-core/io/offset.c"),
            ],
        },
        "ohci": {
            "srcs": [
                Label("//:grub-core/bus/usb/ohci.c"),
            ],
        },
        "part_acorn": {
            "srcs": [
                Label("//:grub-core/partmap/acorn.c"),
            ],
        },
        "part_amiga": {
            "srcs": [
                Label("//:grub-core/partmap/amiga.c"),
            ],
        },
        "part_apple": {
            "srcs": [
                Label("//:grub-core/partmap/apple.c"),
            ],
        },
        "part_bsd": {
            "srcs": [
                Label("//:grub-core/partmap/bsdlabel.c"),
            ],
        },
        "part_dfly": {
            "srcs": [
                Label("//:grub-core/partmap/dfly.c"),
            ],
        },
        "part_dvh": {
            "srcs": [
                Label("//:grub-core/partmap/dvh.c"),
            ],
        },
        "part_gpt": {
            "srcs": [
                Label("//:grub-core/partmap/gpt.c"),
            ],
        },
        "part_msdos": {
            "srcs": [
                Label("//:grub-core/partmap/msdos.c"),
            ],
        },
        "part_plan": {
            "srcs": [
                Label("//:grub-core/partmap/plan.c"),
            ],
        },
        "part_sun": {
            "srcs": [
                Label("//:grub-core/partmap/sun.c"),
            ],
        },
        "part_sunpc": {
            "srcs": [
                Label("//:grub-core/partmap/sunpc.c"),
            ],
        },
        "parttool": {
            "srcs": [
                Label("//:grub-core/commands/parttool.c"),
            ],
        },
        "password": {
            "srcs": [
                Label("//:grub-core/commands/password.c"),
            ],
        },
        "password_pbkdf2": {
            "srcs": [
                Label("//:grub-core/commands/password_pbkdf2.c"),
            ],
        },
        "pata": {
            "srcs": [
                Label("//:grub-core/disk/pata.c"),
            ],
        },
        "pbkdf2": {
            "srcs": [
                Label("//:grub-core/lib/pbkdf2.c"),
            ],
        },
        "pbkdf2_test": {
            "srcs": [
                Label("//:grub-core/tests/pbkdf2_test.c"),
            ],
        },
        "pcidump": {
            "srcs": [
                Label("//:grub-core/commands/pcidump.c"),
            ],
        },
        "pgp": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/commands/pgp.c"),
            ],
        },
        "plainmount": {
            "srcs": [
                Label("//:grub-core/disk/plainmount.c"),
            ],
        },
        "play": {
            "srcs": [
                Label("//:grub-core/commands/i386/pc/play.c"),
            ],
        },
        "png": {
            "srcs": [
                Label("//:grub-core/video/readers/png.c"),
            ],
        },
        "priority_queue": {
            "srcs": [
                Label("//:grub-core/lib/priority_queue.c"),
            ],
        },
        "probe": {
            "srcs": [
                Label("//:grub-core/commands/probe.c"),
            ],
        },
        "procfs": {
            "srcs": [
                Label("//:grub-core/fs/proc.c"),
            ],
        },
        "progress": {
            "srcs": [
                Label("//:grub-core/lib/progress.c"),
            ],
        },
        "pubkey": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/b64dec.c"),
                Label("//:grub-core/lib/libgcrypt-grub/cipher/dsa-common.c"),
                Label("//:grub-core/lib/libgcrypt-grub/cipher/pubkey-util.c"),
                Label("//:grub-core/lib/libgcrypt-grub/cipher/rsa-common.c"),
                Label("//:grub-core/lib/libgcrypt-grub/src/sexp.c"),
            ],
        },
        "raid5rec": {
            "srcs": [
                Label("//:grub-core/disk/raid5_recover.c"),
            ],
        },
        "raid6rec": {
            "srcs": [
                Label("//:grub-core/disk/raid6_recover.c"),
            ],
        },
        "random": {
            "srcs": [
                Label("//:grub-core/lib/i386/random.c"),
                Label("//:grub-core/lib/random.c"),
            ],
        },
        "rdmsr": {
            "srcs": [
                Label("//:grub-core/commands/i386/rdmsr.c"),
            ],
        },
        "read": {
            "srcs": [
                Label("//:grub-core/commands/read.c"),
            ],
        },
        "reboot": {
            "srcs": [
                Label("//:grub-core/commands/reboot.c"),
                Label("//:grub-core/lib/i386/reboot.c"),
                Label("//:grub-core/lib/i386/reboot_trampoline.S"),
            ],
        },
        "regexp": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/gnulib",
            ],
            "srcs": [
                Label("//:grub-core/commands/regexp.c"),
                Label("//:grub-core/commands/wildcard.c"),
                Label("//:grub-core/lib/gnulib/malloc/dynarray_emplace_enlarge.c"),
                Label("//:grub-core/lib/gnulib/malloc/dynarray_finalize.c"),
                Label("//:grub-core/lib/gnulib/malloc/dynarray_resize.c"),
                Label("//:grub-core/lib/gnulib/regex.c"),
            ],
        },
        "reiserfs": {
            "srcs": [
                Label("//:grub-core/fs/reiserfs.c"),
            ],
        },
        "relocator": {
            "srcs": [
                Label("//:grub-core/lib/efi/relocator.c"),
                Label("//:grub-core/lib/i386/relocator.c"),
                Label("//:grub-core/lib/i386/relocator16.S"),
                Label("//:grub-core/lib/i386/relocator32.S"),
                Label("//:grub-core/lib/i386/relocator64.S"),
                Label("//:grub-core/lib/i386/relocator_asm.S"),
                Label("//:grub-core/lib/i386/relocator_common_c.c"),
                Label("//:grub-core/lib/relocator.c"),
            ],
        },
        "romfs": {
            "srcs": [
                Label("//:grub-core/fs/romfs.c"),
            ],
        },
        "rsa_sexp_test": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
                "-D_GCRYPT_CONFIG_H_INCLUDED=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/tests/rsa_sexp_test.c"),
            ],
        },
        "scsi": {
            "srcs": [
                Label("//:grub-core/disk/scsi.c"),
            ],
        },
        "search": {
            "srcs": [
                Label("//:grub-core/commands/search_wrap.c"),
            ],
        },
        "search_fs_file": {
            "srcs": [
                Label("//:grub-core/commands/search_file.c"),
            ],
        },
        "search_fs_uuid": {
            "srcs": [
                Label("//:grub-core/commands/search_uuid.c"),
            ],
        },
        "search_label": {
            "srcs": [
                Label("//:grub-core/commands/search_label.c"),
            ],
        },
        "serial": {
            "srcs": [
                Label("//:grub-core/term/efi/serial.c"),
                Label("//:grub-core/term/ns8250-spcr.c"),
                Label("//:grub-core/term/ns8250.c"),
                Label("//:grub-core/term/pci/serial.c"),
                Label("//:grub-core/term/serial.c"),
            ],
        },
        "setjmp": {
            "srcs": [
                Label("//:grub-core/lib/setjmp.S"),
            ],
        },
        "setjmp_test": {
            "srcs": [
                Label("//:grub-core/tests/setjmp_test.c"),
            ],
        },
        "setpci": {
            "srcs": [
                Label("//:grub-core/commands/setpci.c"),
            ],
        },
        "sfs": {
            "srcs": [
                Label("//:grub-core/fs/sfs.c"),
            ],
        },
        "shift_test": {
            "srcs": [
                Label("//:grub-core/tests/shift_test.c"),
            ],
        },
        "signature_test": {
            "extra_inputs": [
                Label("//:grub-core/tests/signatures.h"),
            ],
            "srcs": [
                Label("//:grub-core/tests/signature_test.c"),
            ],
        },
        "sleep": {
            "srcs": [
                Label("//:grub-core/commands/sleep.c"),
            ],
        },
        "sleep_test": {
            "srcs": [
                Label("//:grub-core/tests/sleep_test.c"),
            ],
        },
        "smbios": {
            "srcs": [
                Label("//:grub-core/commands/efi/smbios.c"),
                Label("//:grub-core/commands/smbios.c"),
            ],
        },
        "spkmodem": {
            "srcs": [
                Label("//:grub-core/term/spkmodem.c"),
            ],
        },
        "squash4": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-DMINILZO_HAVE_CONFIG_H",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/xzembed",
                "grub-core/lib/minilzo",
            ],
            "srcs": [
                Label("//:grub-core/fs/squash4.c"),
            ],
        },
        "strtoull_test": {
            "srcs": [
                Label("//:grub-core/tests/strtoull_test.c"),
            ],
        },
        "syslinuxcfg": {
            "srcs": [
                Label("//:grub-core/commands/syslinuxcfg.c"),
                Label("//:grub-core/lib/syslinux_parse.c"),
            ],
        },
        "tar": {
            "srcs": [
                Label("//:grub-core/fs/tar.c"),
            ],
        },
        "terminal": {
            "srcs": [
                Label("//:grub-core/commands/terminal.c"),
            ],
        },
        "terminfo": {
            "srcs": [
                Label("//:grub-core/term/terminfo.c"),
                Label("//:grub-core/term/tparm.c"),
            ],
        },
        "test": {
            "srcs": [
                Label("//:grub-core/commands/test.c"),
            ],
        },
        "test_blockarg": {
            "srcs": [
                Label("//:grub-core/tests/test_blockarg.c"),
            ],
        },
        "testload": {
            "srcs": [
                Label("//:grub-core/commands/testload.c"),
            ],
        },
        "testspeed": {
            "srcs": [
                Label("//:grub-core/commands/testspeed.c"),
            ],
        },
        "tftp": {
            "srcs": [
                Label("//:grub-core/net/tftp.c"),
            ],
        },
        "tga": {
            "srcs": [
                Label("//:grub-core/video/readers/tga.c"),
            ],
        },
        "time": {
            "srcs": [
                Label("//:grub-core/commands/time.c"),
            ],
        },
        "tpm": {
            "srcs": [
                Label("//:grub-core/commands/efi/tpm.c"),
                Label("//:grub-core/commands/tpm.c"),
            ],
        },
        "tpm2_key_protector": {
            "include_dirs": [
                "grub-core/lib/tss2",
                "grub-core/lib/libtasn1-grub",
            ],
            "srcs": [
                Label("//:grub-core/commands/tpm2_key_protector/args.c"),
                Label("//:grub-core/commands/tpm2_key_protector/module.c"),
                Label("//:grub-core/commands/tpm2_key_protector/tpm2key.c"),
                Label("//:grub-core/commands/tpm2_key_protector/tpm2key_asn1_tab.c"),
            ],
        },
        "tr": {
            "srcs": [
                Label("//:grub-core/commands/tr.c"),
            ],
        },
        "trig": {
            "nodist": [
                "trigtables.c",
            ],
        },
        "true": {
            "srcs": [
                Label("//:grub-core/commands/true.c"),
            ],
        },
        "tss2": {
            "include_dirs": [
                "grub-core/lib/tss2",
            ],
            "srcs": [
                Label("//:grub-core/lib/efi/tcg2.c"),
                Label("//:grub-core/lib/tss2/buffer.c"),
                Label("//:grub-core/lib/tss2/tpm2_cmd.c"),
                Label("//:grub-core/lib/tss2/tss2.c"),
                Label("//:grub-core/lib/tss2/tss2_mu.c"),
            ],
        },
        "udf": {
            "srcs": [
                Label("//:grub-core/fs/udf.c"),
            ],
        },
        "ufs1": {
            "srcs": [
                Label("//:grub-core/fs/ufs.c"),
            ],
        },
        "ufs1_be": {
            "srcs": [
                Label("//:grub-core/fs/ufs_be.c"),
            ],
        },
        "ufs2": {
            "srcs": [
                Label("//:grub-core/fs/ufs2.c"),
            ],
        },
        "uhci": {
            "srcs": [
                Label("//:grub-core/bus/usb/uhci.c"),
            ],
        },
        "usb": {
            "srcs": [
                Label("//:grub-core/bus/usb/usb.c"),
                Label("//:grub-core/bus/usb/usbhub.c"),
                Label("//:grub-core/bus/usb/usbtrans.c"),
            ],
        },
        "usb_keyboard": {
            "srcs": [
                Label("//:grub-core/term/usb_keyboard.c"),
            ],
        },
        "usbms": {
            "srcs": [
                Label("//:grub-core/disk/usbms.c"),
            ],
        },
        "usbserial_common": {
            "srcs": [
                Label("//:grub-core/bus/usb/serial/common.c"),
            ],
        },
        "usbserial_ftdi": {
            "srcs": [
                Label("//:grub-core/bus/usb/serial/ftdi.c"),
            ],
        },
        "usbserial_pl2303": {
            "srcs": [
                Label("//:grub-core/bus/usb/serial/pl2303.c"),
            ],
        },
        "usbserial_usbdebug": {
            "srcs": [
                Label("//:grub-core/bus/usb/serial/usbdebug_late.c"),
            ],
        },
        "usbtest": {
            "srcs": [
                Label("//:grub-core/commands/usbtest.c"),
            ],
        },
        "video": {
            "srcs": [
                Label("//:grub-core/video/video.c"),
            ],
        },
        "video_bochs": {
            "srcs": [
                Label("//:grub-core/video/bochs.c"),
            ],
        },
        "video_cirrus": {
            "srcs": [
                Label("//:grub-core/video/cirrus.c"),
            ],
        },
        "video_colors": {
            "srcs": [
                Label("//:grub-core/video/colors.c"),
            ],
        },
        "video_fb": {
            "srcs": [
                Label("//:grub-core/video/fb/fbblit.c"),
                Label("//:grub-core/video/fb/fbfill.c"),
                Label("//:grub-core/video/fb/fbutil.c"),
                Label("//:grub-core/video/fb/video_fb.c"),
            ],
        },
        "videoinfo": {
            "srcs": [
                Label("//:grub-core/commands/videoinfo.c"),
            ],
        },
        "videotest": {
            "srcs": [
                Label("//:grub-core/commands/videotest.c"),
            ],
        },
        "videotest_checksum": {
            "srcs": [
                Label("//:grub-core/tests/videotest_checksum.c"),
            ],
        },
        "wrmsr": {
            "srcs": [
                Label("//:grub-core/commands/i386/wrmsr.c"),
            ],
        },
        "xfs": {
            "srcs": [
                Label("//:grub-core/fs/xfs.c"),
            ],
        },
        "xnu": {
            "srcs": [
                Label("//:grub-core/loader/i386/xnu.c"),
                Label("//:grub-core/loader/xnu.c"),
                Label("//:grub-core/loader/xnu_resume.c"),
            ],
        },
        "xnu_uuid": {
            "srcs": [
                Label("//:grub-core/commands/xnu_uuid.c"),
            ],
        },
        "xnu_uuid_test": {
            "srcs": [
                Label("//:grub-core/tests/xnu_uuid_test.c"),
            ],
        },
        "xzio": {
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/xzembed",
            ],
            "srcs": [
                Label("//:grub-core/io/xzio.c"),
                Label("//:grub-core/lib/xzembed/xz_dec_bcj.c"),
                Label("//:grub-core/lib/xzembed/xz_dec_lzma2.c"),
                Label("//:grub-core/lib/xzembed/xz_dec_stream.c"),
            ],
        },
        "zfs": {
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/zstd",
            ],
            "srcs": [
                Label("//:grub-core/fs/zfs/zfs.c"),
                Label("//:grub-core/fs/zfs/zfs_fletcher.c"),
                Label("//:grub-core/fs/zfs/zfs_lz4.c"),
                Label("//:grub-core/fs/zfs/zfs_lzjb.c"),
                Label("//:grub-core/fs/zfs/zfs_sha256.c"),
            ],
        },
        "zfscrypt": {
            "srcs": [
                Label("//:grub-core/fs/zfs/zfscrypt.c"),
            ],
        },
        "zfsinfo": {
            "srcs": [
                Label("//:grub-core/fs/zfs/zfsinfo.c"),
            ],
        },
        "zstd": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/zstd",
            ],
            "srcs": [
                Label("//:grub-core/lib/zstd/debug.c"),
                Label("//:grub-core/lib/zstd/entropy_common.c"),
                Label("//:grub-core/lib/zstd/error_private.c"),
                Label("//:grub-core/lib/zstd/fse_decompress.c"),
                Label("//:grub-core/lib/zstd/huf_decompress.c"),
                Label("//:grub-core/lib/zstd/module.c"),
                Label("//:grub-core/lib/zstd/xxhash.c"),
                Label("//:grub-core/lib/zstd/zstd_common.c"),
                Label("//:grub-core/lib/zstd/zstd_decompress.c"),
            ],
        },
        "zstdio": {
            "include_dirs": [
                "grub-core/lib/posix_wrap",
                "grub-core/lib/zstd",
            ],
            "srcs": [
                Label("//:grub-core/io/zstdio.c"),
            ],
        },
    },
    "name": "i386_efi",
    "nostdinc": True,
    "platform": "efi",
    "programs": {},
    "steps": [
        {
            "literal": {
                "cflags": [
                    "-std=gnu99",
                    "-fno-common",
                    "-Os",
                ],
                "cppflags": [
                    "-DGRUB_MACHINE_EFI=1",
                    "-DGRUB_MACHINE=I386_EFI",
                ],
            },
        },
        {
            "literal": {
                "ccasflags": [
                    "-m32",
                ],
                "cflags": [
                    "-m32",
                ],
                "cppflags": [
                    "-m32",
                ],
                "ldflags": [
                    "-m32",
                ],
            },
        },
        {
            "literal": {
                "ccasflags": [
                    "-g",
                ],
                "cflags": [
                    "-g",
                ],
            },
        },
        {
            "candidates": [
                {
                    "flags": [],
                    "to": {},
                },
            ],
            "code": "#ifndef __clang__\n#error not clang\n#endif\nint main (void) { return 0; }\n",
            "probe": "clang",
        },
        {
            "literal": {
                "cflags": [
                    "-march=i386",
                ],
            },
        },
        {
            "literal": {
                "cflags": [
                    "-falign-functions=1",
                ],
            },
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-falign-loops=1",
                    ],
                    "to": {
                        "cflags": [
                            "-falign-loops=1",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "falign_loops",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-falign-jumps=1",
                    ],
                    "to": {
                        "cflags": [
                            "-falign-jumps=1",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "falign_jumps",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-freg-struct-return",
                    ],
                    "to": {
                        "cflags": [
                            "-freg-struct-return",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "freg_struct_return",
        },
        {
            "literal": {
                "cflags": [
                    "-mno-mmx",
                    "-mno-sse",
                    "-mno-sse2",
                    "-mno-sse3",
                    "-mno-3dnow",
                ],
            },
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-Wa,-mx86-used-note=no",
                    ],
                    "to": {
                        "ccasflags": [
                            "-Wa,-mx86-used-note=no",
                        ],
                        "cflags": [
                            "-Wa,-mx86-used-note=no",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "mx86_used_note",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-msoft-float",
                    ],
                    "to": {
                        "ccasflags": [
                            "-msoft-float",
                        ],
                        "cflags": [
                            "-msoft-float",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "soft_float",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fno-omit-frame-pointer",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-omit-frame-pointer",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "fno_omit_frame_pointer",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fno-dwarf2-cfi-asm",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-dwarf2-cfi-asm",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "fno_dwarf2_cfi_asm",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-mno-stack-arg-probe",
                    ],
                    "to": {
                        "cflags": [
                            "-mno-stack-arg-probe",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "mno_stack_arg_probe",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fno-asynchronous-unwind-tables",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-asynchronous-unwind-tables",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "fno_asynchronous_unwind_tables",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fno-unwind-tables",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-unwind-tables",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "fno_unwind_tables",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fno-ident",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-ident",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "fno_ident",
        },
        {
            "literal": {
                "ldflags": [
                    "-Wl,-melf_i386",
                ],
            },
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-Qn",
                        "-Qunused-arguments",
                    ],
                    "to": {
                        "cflags": [
                            "-Qn",
                            "-Qunused-arguments",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "qn",
        },
        {
            "candidates": [
                {
                    "flags": [],
                    "to": {
                        "ccasflags": [
                            "-fno-PIE",
                            "-fno-pie",
                        ],
                        "cflags": [
                            "-fno-PIE",
                            "-fno-pie",
                        ],
                    },
                },
            ],
            "code": "#ifdef __PIE__\n#error PIE by default\n#endif\nint main (void) { return 0; }\n",
            "negate": True,
            "probe": "pie",
        },
        {
            "literal": {
                "ldflags": [
                    "-no-pie",
                ],
            },
            "when": "pie",
        },
        {
            "candidates": [
                {
                    "flags": [],
                    "to": {
                        "cflags": [
                            "-fno-PIC",
                        ],
                    },
                },
            ],
            "code": "#ifdef __PIC__\n#error PIC by default\n#endif\nint main (void) { return 0; }\n",
            "copts": [
                "-fno-PIE",
            ],
            "negate": True,
            "probe": "pic",
        },
        {
            "candidates": [
                {
                    "flags": [
                        "-fstack-protector",
                    ],
                    "to": {
                        "cflags": [
                            "-fno-stack-protector",
                        ],
                    },
                },
            ],
            "code": "char foo (void) { volatile char a[8]; a[3] = 1; return a[3]; }\n",
            "probe": "stack_protector",
        },
        {
            "literal": {
                "ldflags": [
                    "-Wl,--build-id=none",
                ],
            },
        },
        {
            "literal": {
                "cflags_platform": [
                    "-DGRUB_HAS_PCI",
                ],
                "ldflags_platform": [],
            },
        },
        {
            "candidates": [
                {
                    "flags": [],
                    "to": {
                        "subst": {
                            "HAVE_ASM_USCORE": "0",
                        },
                    },
                },
            ],
            "code": "#define GRUB_STR_(x) #x\n#define GRUB_STR(x) GRUB_STR_(x)\nint main (void) { _Static_assert (sizeof (GRUB_STR (__USER_LABEL_PREFIX__)) == 1, \"prefix\"); return 0; }\n",
            "otherwise": {
                "subst": {
                    "HAVE_ASM_USCORE": "1",
                },
            },
            "probe": "asm_uscore",
        },
        {
            "literal": {
                "subst": {
                    "BSS_START_SYMBOL": "__bss_start",
                    "END_SYMBOL": "end",
                },
            },
        },
    ],
    "target_ccasflags": [
        "-m32",
        "-g",
        "-Wa,-mx86-used-note=no",
        "-msoft-float",
        "-fno-PIE",
        "-fno-pie",
    ],
    "target_cflags": [
        "-std=gnu99",
        "-fno-common",
        "-Os",
        "-m32",
        "-g",
        "-march=i386",
        "-falign-functions=1",
        "-falign-loops=1",
        "-falign-jumps=1",
        "-freg-struct-return",
        "-mno-mmx",
        "-mno-sse",
        "-mno-sse2",
        "-mno-sse3",
        "-mno-3dnow",
        "-Wa,-mx86-used-note=no",
        "-msoft-float",
        "-fno-omit-frame-pointer",
        "-fno-dwarf2-cfi-asm",
        "-mno-stack-arg-probe",
        "-fno-asynchronous-unwind-tables",
        "-fno-unwind-tables",
        "-fno-ident",
        "-fno-PIE",
        "-fno-pie",
        "-fno-stack-protector",
    ],
    "target_cppflags": [
        "-DGRUB_MACHINE_EFI=1",
        "-DGRUB_MACHINE=I386_EFI",
        "-m32",
    ],
    "target_cpu": "i386",
    "target_ldflags": [
        "-m32",
        "-Wl,-melf_i386",
        "-no-pie",
        "-Wl,--build-id=none",
    ],
}
