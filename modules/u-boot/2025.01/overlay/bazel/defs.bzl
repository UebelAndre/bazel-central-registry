"""Core macros for the U-Boot Bazel build."""

load("@rules_cc//cc:cc_library.bzl", "cc_library")

UBOOT_VERSION = "2025.01"

_COMMON_COPTS = [
    "-include",
    "include/linux/kconfig.h",
    "-include",
    "include/generated/autoconf_fixup.h",
    "-Wall",
    "-Wstrict-prototypes",
    "-Wno-format-security",
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
]

def uboot_copts():
    """Return the standard U-Boot compilation flags."""
    return _COMMON_COPTS + _COMMON_COPTS_EXTRA + select({
        "//:arch_sandbox": [],
        "//conditions:default": ["-fno-PIE"],
    }) + select({
        "//:CONFIG_CC_OPTIMIZE_FOR_SIZE": ["-Os"],
        "//:CONFIG_CC_OPTIMIZE_FOR_SPEED": ["-O2"],
        "//conditions:default": ["-Os"],
    })

def uboot_defines():
    """Return the standard U-Boot preprocessor defines."""
    return _COMMON_DEFINES + select({
        "//:arch_sandbox": ["__SANDBOX__"],
        "//conditions:default": [],
    }) + select({
        _KCONFIG_SETTINGS_PREFIX + "CONFIG_MBEDTLS_LIB_Y": [
            'MBEDTLS_CONFIG_FILE=\\"mbedtls_def_config.h\\"',
        ],
        "//conditions:default": [],
    })

def uboot_includes():
    """Return architecture-specific and feature-conditional include paths."""
    return [".", "include"] + select({
        "//:arch_arc": ["arch/arc/include"],
        "//:arch_arm": ["arch/arm/include"],
        "//:arch_m68k": ["arch/m68k/include"],
        "//:arch_microblaze": ["arch/microblaze/include"],
        "//:arch_mips": ["arch/mips/include"],
        "//:arch_nios2": ["arch/nios2/include"],
        "//:arch_powerpc": ["arch/powerpc/include"],
        "//:arch_riscv": ["arch/riscv/include"],
        "//:arch_sandbox": ["arch/sandbox/include"],
        "//:arch_sh": ["arch/sh/include"],
        "//:arch_x86": ["arch/x86/include"],
        "//:arch_xtensa": ["arch/xtensa/include"],
    }) + select({
        _KCONFIG_SETTINGS_PREFIX + "CONFIG_MBEDTLS_LIB_Y": [
            "lib/mbedtls",
            "lib/mbedtls/port",
            "lib/mbedtls/external/mbedtls",
            "lib/mbedtls/external/mbedtls/include",
        ],
        "//conditions:default": [],
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

def uboot_cc_library(name, srcs = [], hdrs = [], deps = [], copts = [], local_defines = [], includes = [], textual_hdrs = [], **kwargs):
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
        deps = ["//:asm_arch_headers", "//:generated_headers"] + deps,
        alwayslink = kwargs.pop("alwayslink", True),
        features = ["-supports_dynamic_linker"],
        **kwargs
    )
