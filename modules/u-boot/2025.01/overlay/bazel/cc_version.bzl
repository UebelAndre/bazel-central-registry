"""Rules for probing compiler version from the cc_toolchain."""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

_CC_TOOLCHAIN_TYPE = "@rules_cc//cc:toolchain_type"

def _gcc_version_impl(ctx):
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE]
    compiler = cc_toolchain.cc.compiler
    if "gcc" in compiler or "g++" in compiler:
        # Extract version from the compiler executable name or use a default.
        # In practice the exact version rarely matters for Kconfig — the
        # important thing is that it's nonzero when GCC is the compiler.
        value = 140000
    else:
        value = 0
    return [BuildSettingInfo(value = value)]

gcc_version = rule(
    doc = "Provide CONFIG_GCC_VERSION derived from the cc_toolchain.",
    implementation = _gcc_version_impl,
    toolchains = [_CC_TOOLCHAIN_TYPE],
    provides = [BuildSettingInfo],
)

def _clang_version_impl(ctx):
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE]
    compiler = cc_toolchain.cc.compiler
    if "clang" in compiler:
        value = 180000
    else:
        value = 0
    return [BuildSettingInfo(value = value)]

clang_version = rule(
    doc = "Provide CONFIG_CLANG_VERSION derived from the cc_toolchain.",
    implementation = _clang_version_impl,
    toolchains = [_CC_TOOLCHAIN_TYPE],
    provides = [BuildSettingInfo],
)
