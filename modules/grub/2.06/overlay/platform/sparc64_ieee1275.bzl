"""GRUB 2.06 build data for the sparc64_ieee1275 firmware platform (see common.bzl).

Generated from grub-core/Makefile.core.def and Makefile.gcry.def as gentpl.py
expands them for `sparc64_ieee1275`, and from configure.ac's target-compiler section.
"""

SPARC64_IEEE1275 = {
    "cflags_platform": [],
    "config_h": {
        "BSS_START_SYMBOL": "",
        "END_SYMBOL": "",
        "GRUB_PLATFORM": "ieee1275",
        "GRUB_TARGET_CPU": "sparc64",
        "HAVE_ASM_USCORE": "0",
    },
    "cppflags_gcry_asm": [],
    "cpu_dir": "include/grub/sparc64",
    "cpu_hdrs": [
        Label("//:include/grub/sparc64/ieee1275/boot.h"),
        Label("//:include/grub/sparc64/ieee1275/ieee1275.h"),
        Label("//:include/grub/sparc64/ieee1275/kernel.h"),
        Label("//:include/grub/sparc64/setjmp.h"),
        Label("//:include/grub/sparc64/time.h"),
        Label("//:include/grub/sparc64/types.h"),
    ],
    "data": {
        "gdb_grub": Label("//:grub-core/gdb_grub.in"),
        "genmod.sh": Label("//:grub-core/genmod.sh.in"),
        "gensyminfo.sh": Label("//:grub-core/gensyminfo.sh.in"),
        "gmodule.pl": Label("//:grub-core/gmodule.pl.in"),
        "modinfo.sh": Label("//:grub-core/modinfo.sh.in"),
    },
    "efiemu": None,
    "gentpl_platform": "sparc64_ieee1275",
    "images": {
        "boot": {
            "ldflags": [
                "-Wl,-Ttext=0x3fe0",
            ],
            "objcopyflags": [
                "-O",
                "binary",
            ],
            "srcs": [
                Label("//:grub-core/boot/sparc64/ieee1275/boot.S"),
            ],
        },
        "cdboot": {
            "cppflags": [
                "-DCDBOOT=1",
            ],
            "ldflags": [
                "-Wl,-Ttext=0x3fe0",
            ],
            "objcopyflags": [
                "-O",
                "binary",
            ],
            "srcs": [
                Label("//:grub-core/boot/sparc64/ieee1275/boot.S"),
            ],
        },
        "diskboot": {
            "ldflags": [
                "-Wl,-Ttext=0x4200",
            ],
            "objcopyflags": [
                "-O",
                "binary",
            ],
            "srcs": [
                Label("//:grub-core/boot/sparc64/ieee1275/diskboot.S"),
            ],
        },
    },
    "img_base_ldopt": "-Wl,-Ttext",
    "img_cflags": [],
    "img_ldflags": [
        "-Wl,-N",
    ],
    "kernel": {
        "ldflags": [
            "-Wl,-Ttext,0x4400",
        ],
        "nodist": [
            "symlist.c",
        ],
        "nostrip": False,
        "srcs": [
            Label("//:grub-core/kern/sparc64/cache.S"),
            Label("//:grub-core/kern/sparc64/dl.c"),
            Label("//:grub-core/kern/sparc64/ieee1275/ieee1275.c"),
            Label("//:grub-core/disk/ieee1275/obdisk.c"),
            Label("//:grub-core/disk/ieee1275/ofdisk.c"),
            Label("//:grub-core/kern/ieee1275/cmain.c"),
            Label("//:grub-core/kern/ieee1275/ieee1275.c"),
            Label("//:grub-core/kern/ieee1275/mmap.c"),
            Label("//:grub-core/kern/ieee1275/openfw.c"),
            Label("//:grub-core/term/ieee1275/console.c"),
            Label("//:grub-core/kern/ieee1275/init.c"),
            Label("//:grub-core/term/terminfo.c"),
            Label("//:grub-core/term/tparm.c"),
            Label("//:grub-core/commands/extcmd.c"),
            Label("//:grub-core/lib/arg.c"),
            Label("//:grub-core/kern/compiler-rt.c"),
            Label("//:grub-core/kern/mm.c"),
            Label("//:grub-core/kern/time.c"),
            Label("//:grub-core/kern/generic/millisleep.c"),
            Label("//:grub-core/kern/buffer.c"),
            Label("//:grub-core/kern/command.c"),
            Label("//:grub-core/kern/corecmd.c"),
            Label("//:grub-core/kern/device.c"),
            Label("//:grub-core/kern/disk.c"),
            Label("//:grub-core/kern/dl.c"),
            Label("//:grub-core/kern/env.c"),
            Label("//:grub-core/kern/err.c"),
            Label("//:grub-core/kern/file.c"),
            Label("//:grub-core/kern/fs.c"),
            Label("//:grub-core/kern/list.c"),
            Label("//:grub-core/kern/main.c"),
            Label("//:grub-core/kern/misc.c"),
            Label("//:grub-core/kern/parser.c"),
            Label("//:grub-core/kern/partition.c"),
            Label("//:grub-core/kern/rescue_parser.c"),
            Label("//:grub-core/kern/rescue_reader.c"),
            Label("//:grub-core/kern/term.c"),
            Label("//:grub-core/kern/verifiers.c"),
        ],
        "startup": [
            Label("//:grub-core/kern/sparc64/ieee1275/crt0.S"),
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
        Label("//:include/grub/stack_protector.h"),
        Label("//:include/grub/term.h"),
        Label("//:include/grub/time.h"),
        Label("//:include/grub/verify.h"),
        Label("//:include/grub/mm_private.h"),
        Label("//:include/grub/net.h"),
        Label("//:include/grub/memory.h"),
        Label("//:include/grub/ieee1275/ieee1275.h"),
        Label("//:include/grub/sparc64/ieee1275/ieee1275.h"),
        Label("//:include/grub/terminfo.h"),
        Label("//:include/grub/extcmd.h"),
        Label("//:include/grub/lib/arg.h"),
    ],
    "ldflags_oldmagic": "-Wl,-N",
    "ldflags_platform": [
        "-Wl,-melf64_sparc",
    ],
    "link_addr": {},
    "literal_flags": {
        "ccasflags": [
            "-m64",
            "-g",
        ],
        "cflags": [
            "-std=gnu99",
            "-Os",
            "-m64",
            "-g",
        ],
        "cppflags": [
            "-DGRUB_MACHINE_IEEE1275=1",
            "-DGRUB_MACHINE=SPARC64_IEEE1275",
            "-m64",
        ],
        "ldflags": [
            "-m64",
            "-mno-relax",
            "-Wl,--build-id=none",
        ],
    },
    "machine_dir": "include/grub/sparc64/ieee1275",
    "machine_hdrs": [
        Label("//:include/grub/sparc64/ieee1275/boot.h"),
        Label("//:include/grub/sparc64/ieee1275/ieee1275.h"),
        Label("//:include/grub/sparc64/ieee1275/kernel.h"),
    ],
    "module_format": "elf64",
    "modules": {
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
        "all_video": {
            "srcs": [
                Label("//:grub-core/lib/fake_module.c"),
            ],
        },
        "archelp": {
            "srcs": [
                Label("//:grub-core/fs/archelp.c"),
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
        "blocklist": {
            "srcs": [
                Label("//:grub-core/commands/blocklist.c"),
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
        "cmdline_cat_test": {
            "srcs": [
                Label("//:grub-core/tests/cmdline_cat_test.c"),
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
        "crc64": {
            "srcs": [
                Label("//:grub-core/lib/crc64.c"),
            ],
        },
        "crypto": {
            "srcs": [
                Label("//:grub-core/lib/crypto.c"),
            ],
        },
        "cryptodisk": {
            "srcs": [
                Label("//:grub-core/disk/cryptodisk.c"),
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
                Label("//:grub-core/lib/ieee1275/datetime.c"),
                Label("//:grub-core/lib/ieee1275/cmos.c"),
                Label("//:grub-core/lib/cmos_datetime.c"),
                Label("//:grub-core/lib/datetime.c"),
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
        "echo": {
            "srcs": [
                Label("//:grub-core/commands/echo.c"),
            ],
        },
        "elf": {
            "srcs": [
                Label("//:grub-core/kern/elf.c"),
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
                Label("//:grub-core/tests/lib/functional_test.c"),
                Label("//:grub-core/tests/lib/test.c"),
                Label("//:grub-core/tests/video_checksum.c"),
                Label("//:grub-core/tests/fake_input.c"),
                Label("//:grub-core/video/capture.c"),
            ],
        },
        "gcry_arcfour": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
        "gcry_blowfish": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
        "gcry_idea": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
        "gcry_md4": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
        "gcry_seed": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/cipher/sha512.c"),
            ],
        },
        "gcry_tiger": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
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
                Label("//:grub-core/gfxmenu/gfxmenu.c"),
                Label("//:grub-core/gfxmenu/view.c"),
                Label("//:grub-core/gfxmenu/font.c"),
                Label("//:grub-core/gfxmenu/icon_manager.c"),
                Label("//:grub-core/gfxmenu/theme_loader.c"),
                Label("//:grub-core/gfxmenu/widget-box.c"),
                Label("//:grub-core/gfxmenu/gui_canvas.c"),
                Label("//:grub-core/gfxmenu/gui_circular_progress.c"),
                Label("//:grub-core/gfxmenu/gui_box.c"),
                Label("//:grub-core/gfxmenu/gui_label.c"),
                Label("//:grub-core/gfxmenu/gui_list.c"),
                Label("//:grub-core/gfxmenu/gui_image.c"),
                Label("//:grub-core/gfxmenu/gui_progress_bar.c"),
                Label("//:grub-core/gfxmenu/gui_util.c"),
                Label("//:grub-core/gfxmenu/gui_string_util.c"),
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
        "gfxterm_menu": {
            "srcs": [
                Label("//:grub-core/tests/gfxterm_menu.c"),
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
                Label("//:grub-core/lib/ieee1275/halt.c"),
                Label("//:grub-core/commands/halt.c"),
            ],
        },
        "hashsum": {
            "srcs": [
                Label("//:grub-core/commands/hashsum.c"),
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
        "linux": {
            "srcs": [
                Label("//:grub-core/loader/sparc64/ieee1275/linux.c"),
                Label("//:grub-core/loader/linux.c"),
                Label("//:grub-core/lib/cmdline.c"),
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
        "lsmmap": {
            "srcs": [
                Label("//:grub-core/commands/lsmmap.c"),
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
                Label("//:grub-core/loader/macho.c"),
                Label("//:grub-core/loader/macho32.c"),
                Label("//:grub-core/loader/macho64.c"),
                Label("//:grub-core/loader/lzss.c"),
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
        "mpi": {
            "cflags": [
                "-fno-builtin",
            ],
            "cppflags": [
                "-D_GCRYPT_IN_LIBGCRYPT=1",
            ],
            "include_dirs": [
                "grub-core/lib/libgcrypt_wrap",
                "grub-core/lib/posix_wrap",
                "include/grub/gcrypt",
            ],
            "srcs": [
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpiutil.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-bit.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-add.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mul.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mod.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-gcd.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-div.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-cmp.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-inv.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-pow.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-mpow.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-lshift.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul2.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-mul3.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-add1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-sub1.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-div.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpicoder.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpih-rshift.c"),
                Label("//:grub-core/lib/libgcrypt-grub/mpi/mpi-inline.c"),
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
        "net": {
            "srcs": [
                Label("//:grub-core/net/net.c"),
                Label("//:grub-core/net/dns.c"),
                Label("//:grub-core/net/bootp.c"),
                Label("//:grub-core/net/ip.c"),
                Label("//:grub-core/net/udp.c"),
                Label("//:grub-core/net/tcp.c"),
                Label("//:grub-core/net/icmp.c"),
                Label("//:grub-core/net/icmp6.c"),
                Label("//:grub-core/net/ethernet.c"),
                Label("//:grub-core/net/arp.c"),
                Label("//:grub-core/net/netbuff.c"),
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
                "grub_script.yy.c",
                "grub_script.tab.h",
                "grub_script.yy.h",
            ],
            "srcs": [
                Label("//:grub-core/normal/main.c"),
                Label("//:grub-core/normal/cmdline.c"),
                Label("//:grub-core/normal/dyncmd.c"),
                Label("//:grub-core/normal/auth.c"),
                Label("//:grub-core/normal/autofs.c"),
                Label("//:grub-core/normal/color.c"),
                Label("//:grub-core/normal/completion.c"),
                Label("//:grub-core/normal/menu.c"),
                Label("//:grub-core/normal/menu_entry.c"),
                Label("//:grub-core/normal/menu_text.c"),
                Label("//:grub-core/normal/misc.c"),
                Label("//:grub-core/normal/crypto.c"),
                Label("//:grub-core/normal/term.c"),
                Label("//:grub-core/normal/context.c"),
                Label("//:grub-core/normal/charset.c"),
                Label("//:grub-core/lib/getline.c"),
                Label("//:grub-core/script/main.c"),
                Label("//:grub-core/script/script.c"),
                Label("//:grub-core/script/execute.c"),
                Label("//:grub-core/script/function.c"),
                Label("//:grub-core/script/lexer.c"),
                Label("//:grub-core/script/argv.c"),
                Label("//:grub-core/commands/menuentry.c"),
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
        "ofnet": {
            "srcs": [
                Label("//:grub-core/net/drivers/ieee1275/ofnet.c"),
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
        "pgp": {
            "cflags": [
                "-fno-builtin",
            ],
            "include_dirs": [
                "grub-core/lib/posix_wrap",
            ],
            "srcs": [
                Label("//:grub-core/commands/pgp.c"),
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
        "read": {
            "srcs": [
                Label("//:grub-core/commands/read.c"),
            ],
        },
        "reboot": {
            "srcs": [
                Label("//:grub-core/lib/ieee1275/reboot.c"),
                Label("//:grub-core/commands/reboot.c"),
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
                Label("//:grub-core/lib/gnulib/regex.c"),
            ],
        },
        "reiserfs": {
            "srcs": [
                Label("//:grub-core/fs/reiserfs.c"),
            ],
        },
        "romfs": {
            "srcs": [
                Label("//:grub-core/fs/romfs.c"),
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
                Label("//:grub-core/term/ieee1275/serial.c"),
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
                Label("//:grub-core/lib/syslinux_parse.c"),
                Label("//:grub-core/commands/syslinuxcfg.c"),
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
        "video": {
            "srcs": [
                Label("//:grub-core/video/video.c"),
            ],
        },
        "video_colors": {
            "srcs": [
                Label("//:grub-core/video/colors.c"),
            ],
        },
        "video_fb": {
            "srcs": [
                Label("//:grub-core/video/fb/video_fb.c"),
                Label("//:grub-core/video/fb/fbblit.c"),
                Label("//:grub-core/video/fb/fbfill.c"),
                Label("//:grub-core/video/fb/fbutil.c"),
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
        "xfs": {
            "srcs": [
                Label("//:grub-core/fs/xfs.c"),
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
            "srcs": [
                Label("//:grub-core/fs/zfs/zfs.c"),
                Label("//:grub-core/fs/zfs/zfs_lzjb.c"),
                Label("//:grub-core/fs/zfs/zfs_lz4.c"),
                Label("//:grub-core/fs/zfs/zfs_sha256.c"),
                Label("//:grub-core/fs/zfs/zfs_fletcher.c"),
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
    },
    "name": "sparc64_ieee1275",
    "nostdinc": True,
    "platform": "ieee1275",
    "programs": {},
    "steps": [
        {
            "literal": {
                "cflags": [
                    "-std=gnu99",
                    "-Os",
                ],
                "cppflags": [
                    "-DGRUB_MACHINE_IEEE1275=1",
                    "-DGRUB_MACHINE=SPARC64_IEEE1275",
                ],
            },
        },
        {
            "literal": {
                "ccasflags": [
                    "-m64",
                ],
                "cflags": [
                    "-m64",
                ],
                "cppflags": [
                    "-m64",
                ],
                "ldflags": [
                    "-m64",
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
                        "-mllvm",
                        "-sparc-reserve-app-registers",
                    ],
                    "to": {
                        "cppflags": [
                            "-mllvm",
                            "-sparc-reserve-app-registers",
                        ],
                    },
                },
                {
                    "flags": [
                        "-mno-app-regs",
                    ],
                    "to": {
                        "cflags": [
                            "-mno-app-regs",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "probe": "mno_app_regs",
        },
        {
            "literal": {
                "ldflags": [
                    "-mno-relax",
                ],
            },
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
                        "-mcmodel=large",
                    ],
                    "to": {
                        "cflags": [
                            "-mcmodel=large",
                        ],
                    },
                },
            ],
            "code": "int main (void) { return 0; }\n",
            "otherwise": {
                "cflags": [
                    "-mcmodel=medany",
                ],
            },
            "probe": "mcmodel",
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
                "cflags_platform": [],
                "ldflags_platform": [
                    "-Wl,-melf64_sparc",
                ],
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
                    "BSS_START_SYMBOL": "",
                    "END_SYMBOL": "",
                },
            },
        },
    ],
    "target_ccasflags": [
        "-m64",
        "-g",
        "-msoft-float",
        "-fno-PIE",
        "-fno-pie",
    ],
    "target_cflags": [
        "-std=gnu99",
        "-Os",
        "-m64",
        "-g",
        "-freg-struct-return",
        "-msoft-float",
        "-mno-app-regs",
        "-fno-dwarf2-cfi-asm",
        "-fno-asynchronous-unwind-tables",
        "-fno-unwind-tables",
        "-fno-ident",
        "-fno-PIE",
        "-fno-pie",
        "-mcmodel=medany",
        "-fno-stack-protector",
    ],
    "target_cppflags": [
        "-DGRUB_MACHINE_IEEE1275=1",
        "-DGRUB_MACHINE=SPARC64_IEEE1275",
        "-m64",
    ],
    "target_cpu": "sparc64",
    "target_ldflags": [
        "-m64",
        "-mno-relax",
        "-no-pie",
        "-Wl,--build-id=none",
    ],
}
