"""Rules for probing compiler version from the cc_toolchain."""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")

visibility(["//..."])

_CC_TOOLCHAIN_TYPE = "@rules_cc//cc:toolchain_type"
_GCC_VERSION_FALLBACK = 140000
_CLANG_VERSION_FALLBACK = 180000

def _parse_version_from_strings(strings, marker, offset):
    """Extract compiler version from path-bearing strings.

    Scans each string for a path segment matching `marker`, then checks
    the segment `offset` positions after it for a dotted-numeric version
    like "14", "14.2", or "14.2.0".

    For GCC:   gcc/<triple>/<version>/...  (marker="gcc", offset=2)
    For Clang: clang/<version>/...         (marker="clang", offset=1)
    """
    for s in strings:
        parts = s.split("/")
        for i, part in enumerate(parts):
            if part != marker or i + offset >= len(parts):
                continue
            version_str = parts[i + offset]
            segments = version_str.split(".")
            if not all([seg.isdigit() for seg in segments]):
                continue
            major = int(segments[0])
            minor = int(segments[1]) if len(segments) > 1 else 0
            patch = int(segments[2]) if len(segments) > 2 else 0
            return major * 10000 + minor * 100 + patch
    return None

def _toolchain_compile_args(ctx, cc_toolchain):
    """Return the default C-compile command-line strings for the toolchain."""
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    compile_variables = cc_common.create_compile_variables(
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
    )
    return cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = ACTION_NAMES.c_compile,
        variables = compile_variables,
    )

def _detect_version(ctx, marker, offset):
    """Try compile-args, then built-in include dirs."""
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE]
    args = _toolchain_compile_args(ctx, cc_toolchain.cc)
    version = _parse_version_from_strings(args, marker, offset)
    if version != None:
        return version
    return _parse_version_from_strings(
        cc_toolchain.cc.built_in_include_directories,
        marker,
        offset,
    )

def _gcc_version_impl(ctx):
    compiler = ctx.toolchains[_CC_TOOLCHAIN_TYPE].cc.compiler
    if "gcc" in compiler or "g++" in compiler:
        version = _detect_version(ctx, "gcc", 2)
        value = version if version != None else _GCC_VERSION_FALLBACK
    else:
        value = 0
    return [BuildSettingInfo(value = value)]

gcc_version = rule(
    doc = "Provide CONFIG_GCC_VERSION derived from the cc_toolchain.",
    implementation = _gcc_version_impl,
    toolchains = [_CC_TOOLCHAIN_TYPE],
    fragments = ["cpp"],
    provides = [BuildSettingInfo],
)

def _clang_version_impl(ctx):
    compiler = ctx.toolchains[_CC_TOOLCHAIN_TYPE].cc.compiler
    if "clang" in compiler:
        version = _detect_version(ctx, "clang", 1)
        value = version if version != None else _CLANG_VERSION_FALLBACK
    else:
        value = 0
    return [BuildSettingInfo(value = value)]

clang_version = rule(
    doc = "Provide CONFIG_CLANG_VERSION derived from the cc_toolchain.",
    implementation = _clang_version_impl,
    toolchains = [_CC_TOOLCHAIN_TYPE],
    fragments = ["cpp"],
    provides = [BuildSettingInfo],
)

def _kconfig_value_impl(ctx):
    return [BuildSettingInfo(value = ctx.attr.value)]

kconfig_value = rule(
    doc = "Provide a kconfig value via settings_labels. Use select() on the value attr.",
    implementation = _kconfig_value_impl,
    attrs = {
        "value": attr.int(mandatory = True),
    },
    provides = [BuildSettingInfo],
)

kconfig_bool = rule(
    doc = "Provide a kconfig bool via settings_labels. Use select() on the value attr.",
    implementation = _kconfig_value_impl,
    attrs = {
        "value": attr.bool(mandatory = True),
    },
    provides = [BuildSettingInfo],
)
