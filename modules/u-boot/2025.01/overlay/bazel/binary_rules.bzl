"""Rules for linker script preprocessing and binary post-processing."""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

_CC_TOOLCHAIN_TYPE = "@rules_cc//cc:toolchain_type"

def _preprocess_linker_script_impl(ctx):
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE].cc
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    cc = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = ACTION_NAMES.c_compile,
    )

    out = ctx.outputs.out
    lds = ctx.file.src

    # Resolve include paths relative to the package root
    src_root = lds.root.path
    pkg = ctx.label.workspace_root
    base = (src_root + "/" + pkg) if src_root else pkg

    args = ctx.actions.args()
    args.add("-E")
    args.add("-P")
    args.add("-x", "assembler-with-cpp")
    args.add("-std=c99")
    args.add("-D__KERNEL__")
    args.add("-D__UBOOT__")
    args.add("-D__ASSEMBLY__")
    prev_was_include = False
    for copt in ctx.attr.copts:
        if prev_was_include:
            args.add((base + "/" + copt) if base else copt)
            prev_was_include = False
        elif copt == "-include":
            args.add(copt)
            prev_was_include = True
        else:
            args.add(copt)
    for inc in ctx.attr.includes:
        args.add("-I", (base + "/" + inc) if base else inc)

    # Collect include paths and headers from deps (CcInfo providers)
    dep_inputs = []
    dep_includes = []
    for dep in ctx.attr.deps:
        if CcInfo in dep:
            cc_ctx = dep[CcInfo].compilation_context
            dep_inputs.append(cc_ctx.headers)
            for inc in cc_ctx.includes.to_list():
                dep_includes.append(inc)
            for inc in cc_ctx.system_includes.to_list():
                dep_includes.append(inc)
            for inc in cc_ctx.quote_includes.to_list():
                dep_includes.append(inc)
    for inc in dep_includes:
        args.add("-isystem", inc)

    args.add("-o", out)
    args.add(lds)

    ctx.actions.run(
        executable = cc,
        arguments = [args],
        inputs = depset(
            [lds] + ctx.files.hdrs,
            transitive = [cc_toolchain.all_files] + dep_inputs,
        ),
        outputs = [out],
        mnemonic = "PreprocessLds",
    )

    return [DefaultInfo(files = depset([out]))]

preprocess_linker_script = rule(
    doc = "Preprocess a linker script (.lds) using the C preprocessor.",
    implementation = _preprocess_linker_script_impl,
    attrs = {
        "copts": attr.string_list(
            doc = "Additional flags passed to the C preprocessor (e.g. -include, -D).",
            default = [],
        ),
        "deps": attr.label_list(
            doc = "cc_library dependencies providing headers and include paths.",
            providers = [CcInfo],
            default = [],
        ),
        "hdrs": attr.label_list(
            doc = "Header files available during preprocessing.",
            allow_files = True,
            default = [],
        ),
        "includes": attr.string_list(
            doc = "Include search paths passed as -I flags.",
            default = [],
        ),
        "out": attr.output(
            doc = "The preprocessed linker script output file.",
            mandatory = True,
        ),
        "src": attr.label(
            doc = "The input .lds linker script to preprocess.",
            allow_single_file = True,
            mandatory = True,
        ),
    },
    fragments = ["cpp"],
    toolchains = [_CC_TOOLCHAIN_TYPE],
)

def _objcopy_binary_impl(ctx):
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE].cc
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    objcopy = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = ACTION_NAMES.objcopy_embed_data,
    )

    out = ctx.outputs.out
    src = ctx.file.src

    args = ctx.actions.args()
    args.add("-O", ctx.attr.output_format)
    args.add(src)
    args.add(out)

    ctx.actions.run(
        executable = objcopy,
        arguments = [args],
        inputs = [src],
        tools = cc_toolchain.all_files,
        outputs = [out],
        mnemonic = "ObjcopyBinary",
    )

    return [DefaultInfo(files = depset([out]))]

objcopy_binary = rule(
    doc = "Run objcopy to convert an ELF binary to another format (e.g. raw binary).",
    implementation = _objcopy_binary_impl,
    attrs = {
        "out": attr.output(
            doc = "The converted output file.",
            mandatory = True,
        ),
        "output_format": attr.string(
            doc = "Output format passed to objcopy -O (e.g. \"binary\", \"srec\", \"ihex\").",
            default = "binary",
        ),
        "src": attr.label(
            doc = "The input ELF binary to convert.",
            allow_single_file = True,
            mandatory = True,
        ),
    },
    fragments = ["cpp"],
    toolchains = [_CC_TOOLCHAIN_TYPE],
)

# --- Binary data embedding ---

def _embed_binary_data_impl(ctx):
    out = ctx.outputs.out
    src = ctx.file.src
    symbol = ctx.attr.symbol

    content = """\
.section .rodata.{section},"a"
.balign 16
.global __{symbol}_begin
__{symbol}_begin:
.incbin "{path}"
__{symbol}_end:
.global __{symbol}_end
.balign 16
""".format(
        section = ctx.attr.section,
        symbol = symbol,
        path = src.path,
    )

    ctx.actions.write(output = out, content = content)

    return [DefaultInfo(files = depset([out]))]

embed_binary_data = rule(
    doc = "Generate an assembly file that embeds a binary file via .incbin.",
    implementation = _embed_binary_data_impl,
    attrs = {
        "out": attr.output(
            doc = "Output .S assembly file.",
            mandatory = True,
        ),
        "section": attr.string(
            doc = "ELF section name for the embedded data.",
            default = "ttf.init",
        ),
        "src": attr.label(
            doc = "Binary file to embed.",
            allow_single_file = True,
            mandatory = True,
        ),
        "symbol": attr.string(
            doc = "Symbol prefix (produces `__<symbol>_begin` and `__<symbol>_end`).",
            mandatory = True,
        ),
    },
)

# --- include/config.h generation ---

def _generate_config_h_impl(ctx):
    out = ctx.outputs.out

    config_name = ctx.attr.config_name[BuildSettingInfo].value
    vendor = ctx.attr.vendor[BuildSettingInfo].value
    board = ctx.attr.board[BuildSettingInfo].value

    if vendor:
        boarddir = "board/{}/{}".format(vendor, board)
    else:
        boarddir = "board/{}".format(board)

    lines = [
        "/* Automatically generated - do not edit */",
        "#define CFG_BOARDDIR {}".format(boarddir),
    ]
    if config_name:
        lines.append("#include <configs/{}.h>".format(config_name))
    lines.extend([
        "#ifndef USE_HOSTCC",
        "#include <asm/config.h>",
        "#endif",
        "#include <linux/kconfig.h>",
        "#include <config_fallbacks.h>",
        "",
    ])

    ctx.actions.write(
        output = out,
        content = "\n".join(lines),
    )

    return [DefaultInfo(files = depset([out]))]

generate_config_h = rule(
    doc = "Generate include/config.h with board-specific content from kconfig build settings.",
    implementation = _generate_config_h_impl,
    attrs = {
        "board": attr.label(
            doc = "The CONFIG_SYS_BOARD build setting.",
            mandatory = True,
            providers = [BuildSettingInfo],
        ),
        "config_name": attr.label(
            doc = "The CONFIG_SYS_CONFIG_NAME build setting.",
            mandatory = True,
            providers = [BuildSettingInfo],
        ),
        "out": attr.output(
            doc = "Output config.h file.",
            mandatory = True,
        ),
        "vendor": attr.label(
            doc = "The CONFIG_SYS_VENDOR build setting.",
            mandatory = True,
            providers = [BuildSettingInfo],
        ),
    },
)

# --- timestamp_autogenerated.h ---

def _generate_timestamp_h_impl(ctx):
    out = ctx.outputs.out
    ctx.actions.write(
        output = out,
        content = """\
#define U_BOOT_DATE "Jan 01 2026"
#define U_BOOT_TIME "00:00:00"
#define U_BOOT_TZ "+0000"
#define U_BOOT_DMI_DATE "01/01/2026"
#define U_BOOT_BUILD_DATE 0x20260101
""",
    )
    return [DefaultInfo(files = depset([out]))]

generate_timestamp_h = rule(
    doc = "Generate timestamp_autogenerated.h with fixed values for reproducibility.",
    implementation = _generate_timestamp_h_impl,
    attrs = {
        "out": attr.output(
            doc = "Output header file.",
            mandatory = True,
        ),
    },
)

# --- dt.h ---

def _generate_dt_h_impl(ctx):
    out = ctx.outputs.out
    device_tree = ctx.attr.device_tree[BuildSettingInfo].value

    if device_tree:
        content = '#define DEVICE_TREE "{}"\n'.format(device_tree)
    else:
        content = "#define DEVICE_TREE CONFIG_DEFAULT_DEVICE_TREE\n"

    ctx.actions.write(output = out, content = content)
    return [DefaultInfo(files = depset([out]))]

generate_dt_h = rule(
    doc = "Generate dt.h with the DEVICE_TREE define from kconfig.",
    implementation = _generate_dt_h_impl,
    attrs = {
        "device_tree": attr.label(
            doc = "The CONFIG_DEFAULT_DEVICE_TREE build setting.",
            mandatory = True,
            providers = [BuildSettingInfo],
        ),
        "out": attr.output(
            doc = "Output header file.",
            mandatory = True,
        ),
    },
)
