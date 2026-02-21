"""Rule for generating asm-offsets.h from a C source file."""

load("@rules_cc//cc:action_names.bzl", "ACTION_NAMES")
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

_CC_TOOLCHAIN_TYPE = "@rules_cc//cc:toolchain_type"

def _uboot_asm_offsets_impl(ctx):
    cc_toolchain = ctx.toolchains[_CC_TOOLCHAIN_TYPE].cc
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
    )
    cc = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = ACTION_NAMES.c_compile,
    )

    asm_file = ctx.actions.declare_file(ctx.label.name + ".s")
    out = ctx.outputs.out

    # Resolve include paths relative to the package root
    src_root = ctx.file.src.root.path
    pkg = ctx.label.workspace_root
    base = (src_root + "/" + pkg) if src_root else pkg

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

    compile_args = ctx.actions.args()
    compile_args.add("-S")
    compile_args.add("-o", asm_file)
    compile_args.add_all(ctx.attr.copts)
    for inc in ctx.attr.includes:
        compile_args.add("-I", (base + "/" + inc) if base else inc)
    for inc in dep_includes:
        compile_args.add("-isystem", inc)
    compile_args.add(ctx.file.src)

    ctx.actions.run(
        executable = cc,
        arguments = [compile_args],
        inputs = depset(
            [ctx.file.src] + ctx.files.hdrs,
            transitive = [cc_toolchain.all_files] + dep_inputs,
        ),
        outputs = [asm_file],
        mnemonic = "AsmOffsetsCompile",
    )

    extract_args = ctx.actions.args()
    extract_args.add(asm_file)
    extract_args.add(out)

    ctx.actions.run(
        executable = ctx.executable._extractor,
        arguments = [extract_args],
        inputs = [asm_file],
        outputs = [out],
        mnemonic = "AsmOffsetsExtract",
    )

    return [DefaultInfo(files = depset([out]))]

uboot_asm_offsets = rule(
    doc = "Compile a C source to assembly and extract asm-offsets defines.",
    implementation = _uboot_asm_offsets_impl,
    attrs = {
        "copts": attr.string_list(
            doc = "Additional compiler flags for the assembly compilation.",
            default = [],
        ),
        "deps": attr.label_list(
            doc = "cc_library dependencies providing headers and include paths.",
            providers = [CcInfo],
            default = [],
        ),
        "hdrs": attr.label_list(
            doc = "Header file dependencies.",
            allow_files = True,
            default = [],
        ),
        "includes": attr.string_list(
            doc = "Include directories relative to the package root.",
            default = [],
        ),
        "out": attr.output(
            doc = "Output header file.",
            mandatory = True,
        ),
        "src": attr.label(
            doc = "The asm-offsets C source file.",
            allow_single_file = [".c"],
            mandatory = True,
        ),
        "_extractor": attr.label(
            default = Label("//bazel:extract_asm_offsets"),
            cfg = "exec",
            executable = True,
        ),
    },
    fragments = ["cpp"],
    toolchains = [_CC_TOOLCHAIN_TYPE],
)
