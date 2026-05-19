"""Shared rules and macros for building TeX Live components."""

load("@rules_cc//cc:cc_binary.bzl", "cc_binary")

# Common compiler options for TeX Live code.
TEXLIVE_COPTS = select({
    "@rules_cc//cc/compiler:msvc-cl": ["/w"],
    "//conditions:default": ["-w"],
})

TEXLIVE_LOCAL_DEFINES = ["HAVE_CONFIG_H"] + select({
    "@platforms//os:windows": ["WIN32"],
    "//conditions:default": [],
})

MATH_LINKOPTS = select({
    "@platforms//os:windows": [],
    "//conditions:default": ["-lm"],
})

def _wrapper_args(ctx, chdir = None, env = {}):
    """Build argument list for the process_wrapper tool.

    Returns an Args object with env/chdir flags set. Callers must add
    any --cat/--stdout flags, then "--" followed by the command.
    """
    args = ctx.actions.args()
    for k, v in env.items():
        args.add("--env", "{}={}".format(k, v))
    if chdir:
        args.add("--chdir", chdir)
    return args

def _texlive_env(extra = {}):
    """Standard env vars for TeX Live tools to suppress kpathsea search."""
    env = {"TEXMFCNF": "/nonexistent"}
    env.update(extra)
    return env

# =============================================================================
# tangle_web rule
# =============================================================================

def _tangle_web_impl(ctx):
    web_base = ctx.file.web.basename.rsplit(".", 1)[0]
    out = ctx.actions.declare_file(web_base + ".p")
    inputs = [ctx.file.web]

    extra_env = {"WEBINPUTS": ctx.file.web.dirname}
    args = _wrapper_args(ctx, chdir = out.dirname, env = _texlive_env(extra_env))
    args.add("--")
    args.add(ctx.executable.tangle_tool)
    args.add(ctx.file.web)
    if ctx.file.ch:
        inputs.append(ctx.file.ch)
        args.add(ctx.file.ch)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [args],
        inputs = inputs,
        outputs = [out],
        tools = [ctx.executable.tangle_tool],
        mnemonic = "TangleWeb",
        progress_message = "Tangling %{input}",
    )
    return [DefaultInfo(files = depset([out]))]

tangle_web = rule(
    doc = """\
Runs Knuth's `tangle` on a WEB source file to produce Pascal (.p) output.

WEB is a literate programming system where `.web` files contain interwoven
documentation and Pascal source. The `tangle` tool extracts the Pascal,
optionally applying changes from a `.ch` (change) file. The output `.p` file
is then converted to C by the `web2c_convert` rule.
""",
    implementation = _tangle_web_impl,
    attrs = {
        "ch": attr.label(
            doc = "Optional change file (.ch) applied on top of the WEB source.",
            allow_single_file = [".ch"],
        ),
        "tangle_tool": attr.label(
            doc = "The tangle binary. Override for bootstrapping.",
            default = Label("//texk/web2c:tangle"),
            executable = True,
            cfg = "exec",
        ),
        "web": attr.label(
            doc = "The WEB source file (.web) to tangle.",
            allow_single_file = [".web"],
            mandatory = True,
        ),
        "_process_wrapper": attr.label(
            default = Label("//bazel:process_wrapper"),
            executable = True,
            cfg = "exec",
        ),
    },
)

# =============================================================================
# web2c_convert rule
# =============================================================================

def _web2c_convert_impl(ctx):
    c_outs = [ctx.actions.declare_file(f) for f in ctx.attr.outs if f.endswith(".c")]
    h_outs = [ctx.actions.declare_file(f) for f in ctx.attr.outs if f.endswith(".h")]
    outputs = c_outs + h_outs
    out_dir = outputs[0].dirname
    prog = ctx.attr.program

    # Step 1: Concatenate defines + source into a single .p file.
    combined = ctx.actions.declare_file(prog + "_combined.p")
    concat_args = _wrapper_args(ctx, env = _texlive_env())
    for f in ctx.files.defines:
        concat_args.add("--cat", f)
    concat_args.add("--cat", ctx.file.src)
    concat_args.add("--stdout", combined)
    concat_args.add("--")
    concat_args.add("cat")

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [concat_args],
        inputs = [ctx.file.src] + ctx.files.defines,
        outputs = [combined],
        mnemonic = "Web2CCat",
        progress_message = "Preparing %{input} for web2c",
    )

    # Step 2: Run web2c on the combined input.
    # web2c writes a .h file to CWD named <program>.h, and C to stdout.
    web2c_out = ctx.actions.declare_file(prog + "_web2c.c")
    web2c_args = _wrapper_args(ctx, chdir = out_dir, env = _texlive_env())
    web2c_args.add("--cat", combined)
    web2c_args.add("--stdout", web2c_out)
    web2c_args.add("--")
    web2c_args.add(ctx.executable._web2c)
    web2c_args.add("-h" + ctx.attr.header)
    web2c_args.add("-c" + prog)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [web2c_args],
        inputs = [combined],
        outputs = [web2c_out] + h_outs,
        tools = [ctx.executable._web2c],
        mnemonic = "Web2CTranslate",
        progress_message = "Translating %{input} Pascal to C",
    )

    # Step 3: Run fixwrites.
    fixwrites_out = ctx.actions.declare_file(prog + "_fixwrites.c")
    fix_args = _wrapper_args(ctx, env = _texlive_env())
    fix_args.add("--cat", web2c_out)
    fix_args.add("--stdout", fixwrites_out)
    fix_args.add("--")
    fix_args.add(ctx.executable._fixwrites)
    if ctx.attr.is_tex_engine:
        fix_args.add("-t")
    fix_args.add(prog)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [fix_args],
        inputs = [web2c_out],
        outputs = [fixwrites_out],
        tools = [ctx.executable._fixwrites],
        mnemonic = "Web2CFixwrites",
        progress_message = "Fixwrites %{input}",
    )

    # Step 4: Run splitup (for large engines) or rename for simple programs.
    if ctx.attr.use_splitup:
        split_args = _wrapper_args(ctx, chdir = out_dir, env = _texlive_env())
        split_args.add("--cat", fixwrites_out)
        split_args.add("--")
        split_args.add(ctx.executable._splitup)
        split_args.add("-i")
        split_args.add("-l")
        split_args.add("65000")
        split_args.add(prog)

        ctx.actions.run(
            executable = ctx.executable._process_wrapper,
            arguments = [split_args],
            inputs = [fixwrites_out],
            outputs = c_outs,
            tools = [ctx.executable._splitup],
            mnemonic = "Web2CSplitup",
            progress_message = "Splitting %{input}",
        )
    else:
        # Simple program: fixwrites output IS the final .c file.
        # The .h was already produced by web2c in step 2.
        ctx.actions.symlink(output = c_outs[0], target_file = fixwrites_out)

    return [DefaultInfo(files = depset(outputs))]

web2c_convert = rule(
    doc = """\
Converts a Pascal (.p) file to C using the web2c toolchain.

Runs a pipeline: `cat defines src | web2c | fixwrites > output.c`, or for
large engines: `... | fixwrites | splitup` which splits into numbered chunks.
""",
    implementation = _web2c_convert_impl,
    attrs = {
        "defines": attr.label_list(
            doc = "Define files prepended to the Pascal source (e.g., common.defines).",
            allow_files = True,
            default = [],
        ),
        "header": attr.string(
            doc = "Header name passed to web2c -h flag (e.g., 'cpascal.h' or 'texmfmp.h').",
            default = "cpascal.h",
        ),
        "is_tex_engine": attr.bool(
            doc = "If true, passes -t to fixwrites (for TeX-like engines).",
            default = False,
        ),
        "outs": attr.string_list(
            doc = "Output file names produced by the pipeline.",
            mandatory = True,
        ),
        "program": attr.string(
            doc = "Program name passed to web2c/fixwrites/splitup.",
            mandatory = True,
        ),
        "src": attr.label(
            doc = "The Pascal (.p) source file to convert.",
            allow_single_file = True,
            mandatory = True,
        ),
        "use_splitup": attr.bool(
            doc = "If true, pipes output through splitup for large programs.",
            default = False,
        ),
        "_fixwrites": attr.label(
            default = Label("//texk/web2c/web2c:fixwrites"),
            executable = True,
            cfg = "exec",
        ),
        "_process_wrapper": attr.label(
            default = Label("//bazel:process_wrapper"),
            executable = True,
            cfg = "exec",
        ),
        "_splitup": attr.label(
            default = Label("//texk/web2c/web2c:splitup"),
            executable = True,
            cfg = "exec",
        ),
        "_web2c": attr.label(
            default = Label("//texk/web2c/web2c:web2c_tool"),
            executable = True,
            cfg = "exec",
        ),
    },
)

# =============================================================================
# ctangle_cweb rule
# =============================================================================

def _ctangle_cweb_impl(ctx):
    out = ctx.actions.declare_file(ctx.attr.out if ctx.attr.out else ctx.attr.name + ".c")
    inputs = [ctx.file.w_file] + ctx.files.extra_srcs

    extra_env = {"CWEBINPUTS": ctx.file.w_file.dirname}
    args = _wrapper_args(ctx, chdir = out.dirname, env = _texlive_env(extra_env))
    args.add("--")
    args.add(ctx.executable.ctangle_tool)
    args.add(ctx.file.w_file)
    if ctx.file.ch:
        inputs.append(ctx.file.ch)
        args.add(ctx.file.ch)
    args.add(out.basename)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [args],
        inputs = inputs,
        outputs = [out],
        tools = [ctx.executable.ctangle_tool],
        mnemonic = "CTangleCWeb",
        progress_message = "CTangling %{input}",
    )
    return [DefaultInfo(files = depset([out]))]

ctangle_cweb = rule(
    doc = """\
Runs `ctangle` on a CWEB source file to produce C output.

CWEB is the C variant of Knuth's literate programming system. The `.w` file
contains interwoven documentation and C source. `ctangle` extracts the C,
optionally applying a change file.
""",
    implementation = _ctangle_cweb_impl,
    attrs = {
        "ch": attr.label(
            doc = "Optional change file (.ch) applied on top of the CWEB source.",
            allow_single_file = [".ch"],
        ),
        "ctangle_tool": attr.label(
            doc = "The ctangle binary. Override for bootstrapping.",
            default = Label("//texk/web2c:ctangle"),
            executable = True,
            cfg = "exec",
        ),
        "extra_srcs": attr.label_list(
            doc = "Additional source files needed by the CWEB file (e.g., included .w or .h files).",
            allow_files = True,
            default = [],
        ),
        "out": attr.string(
            doc = "Output filename. Defaults to `<name>.c`.",
        ),
        "w_file": attr.label(
            doc = "The CWEB source file (.w) to process.",
            allow_single_file = [".w"],
            mandatory = True,
        ),
        "_process_wrapper": attr.label(
            default = Label("//bazel:process_wrapper"),
            executable = True,
            cfg = "exec",
        ),
    },
)

# =============================================================================
# kpathsea_paths_h rule
# =============================================================================

def _kpathsea_paths_h_impl(ctx):
    out = ctx.actions.declare_file("paths.h")

    # Step 1: bsnl.awk joins backslash-continued lines.
    bsnl_out = ctx.actions.declare_file("_paths_bsnl.txt")
    bsnl_args = _wrapper_args(ctx)
    bsnl_args.add("--stdout", bsnl_out)
    bsnl_args.add("--")
    bsnl_args.add(ctx.executable._gawk)
    bsnl_args.add("-f", ctx.file.bsnl_awk)
    bsnl_args.add(ctx.file.cnf)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [bsnl_args],
        inputs = [ctx.file.cnf, ctx.file.bsnl_awk],
        outputs = [bsnl_out],
        tools = [ctx.executable._gawk],
        mnemonic = "KpathseaBsnl",
    )

    # Step 2: Strip %-comments and whitespace (replaces sed in the
    # original Makefile). Uses gawk inline program instead of sed.
    stripped_out = ctx.actions.declare_file("_paths_stripped.txt")
    strip_args = _wrapper_args(ctx)
    strip_args.add("--cat", bsnl_out)
    strip_args.add("--stdout", stripped_out)
    strip_args.add("--")
    strip_args.add(ctx.executable._gawk)
    strip_args.add("{ sub(/%.*/, \"\"); gsub(/^[ \\t]+|[ \\t]+$/, \"\"); print }")

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [strip_args],
        inputs = [bsnl_out],
        outputs = [stripped_out],
        tools = [ctx.executable._gawk],
        mnemonic = "KpathseaStrip",
    )

    # Step 3: cnf-to-paths.awk produces #define lines. Prepend the
    # header comment by feeding it as an extra --cat file.
    comment = ctx.actions.declare_file("_paths_comment.txt")
    ctx.actions.write(comment, "/* paths.h: Generated from texmf.cnf. */\n")

    cnf_args = _wrapper_args(ctx)
    cnf_args.add("--cat", comment)
    cnf_args.add("--cat", stripped_out)
    cnf_args.add("--stdout", out)
    cnf_args.add("--")
    cnf_args.add(ctx.executable._gawk)
    cnf_args.add("-f", ctx.file.cnf_to_paths_awk)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        arguments = [cnf_args],
        inputs = [comment, stripped_out, ctx.file.cnf_to_paths_awk],
        outputs = [out],
        tools = [ctx.executable._gawk],
        mnemonic = "KpathseaCnfToPaths",
    )

    return [DefaultInfo(files = depset([out]))]

kpathsea_paths_h = rule(
    doc = "Generates paths.h from texmf.cnf using bsnl.awk and cnf-to-paths.awk.",
    implementation = _kpathsea_paths_h_impl,
    attrs = {
        "bsnl_awk": attr.label(
            doc = "The bsnl.awk script that joins backslash-continued lines.",
            allow_single_file = True,
            mandatory = True,
        ),
        "cnf": attr.label(
            doc = "The texmf.cnf configuration file.",
            allow_single_file = True,
            mandatory = True,
        ),
        "cnf_to_paths_awk": attr.label(
            doc = "The cnf-to-paths.awk script that converts cnf to C #defines.",
            allow_single_file = True,
            mandatory = True,
        ),
        "_gawk": attr.label(
            default = Label("@gawk//:gawk"),
            executable = True,
            cfg = "exec",
        ),
        "_process_wrapper": attr.label(
            default = Label("//bazel:process_wrapper"),
            executable = True,
            cfg = "exec",
        ),
    },
)

# =============================================================================
# tex_engine macro (composes tangle_web + web2c_convert + cc_binary)
# =============================================================================

def tex_engine(
        name,
        web = None,
        ch = None,
        extra_c_srcs = [],
        extra_hdrs = [],
        deps = [],
        copts = [],
        local_defines = [],
        linkopts = [],
        visibility = ["//visibility:public"]):
    """Full pipeline for a WEB-based TeX engine.

    Args:
        name: Engine name (e.g., "tex", "pdftex").
        web: Label of the .web source file. If None, assumes C-only engine.
        ch: Label of the .ch change file.
        extra_c_srcs: Additional C source files/labels.
        extra_hdrs: Additional header files/labels.
        deps: Additional cc_library dependencies.
        copts: Additional compiler flags.
        local_defines: Additional preprocessor defines.
        linkopts: Additional linker flags.
        visibility: Bazel visibility.
    """
    all_srcs = list(extra_c_srcs)
    all_hdrs = list(extra_hdrs)

    if web:
        tangle_web(
            name = name + "_p",
            web = web,
            ch = ch,
        )
        web2c_convert(
            name = name + "_c",
            src = ":" + name + "_p",
            program = name,
            outs = [
                name + "0.c",
                name + "1.c",
                name + "2.c",
                name + "ini.c",
                name + "d.h",
                name + "coerce.h",
            ],
        )
        all_srcs.extend([
            ":" + name + "_c",
        ])

    cc_binary(
        name = name,
        srcs = all_srcs + all_hdrs,
        copts = TEXLIVE_COPTS + copts,
        local_defines = TEXLIVE_LOCAL_DEFINES + local_defines,
        linkopts = MATH_LINKOPTS + linkopts,
        deps = [
            Label("//texk/kpathsea"),
            Label("//texk/web2c:web2c_lib"),
            Label("@zlib"),
        ] + deps,
        visibility = visibility,
    )

# =============================================================================
# texk_program macro
# =============================================================================

def texk_program(
        name,
        srcs = None,
        hdrs = None,
        deps = [],
        copts = [],
        local_defines = [],
        linkopts = [],
        visibility = ["//visibility:public"]):
    """Simple texk utility program depending on kpathsea.

    Args:
        name: Program name.
        srcs: Source files. Defaults to glob(["*.c"]).
        hdrs: Header files. Defaults to glob(["*.h"]).
        deps: Additional dependencies beyond kpathsea.
        copts: Additional compiler flags.
        local_defines: Additional preprocessor defines.
        linkopts: Additional linker flags.
        visibility: Bazel visibility.
    """
    if srcs == None:
        srcs = native.glob(["*.c"])
    if hdrs == None:
        hdrs = native.glob(["*.h"])
    cc_binary(
        name = name,
        srcs = srcs + hdrs,
        copts = TEXLIVE_COPTS + copts,
        local_defines = TEXLIVE_LOCAL_DEFINES + local_defines,
        linkopts = MATH_LINKOPTS + linkopts,
        deps = [Label("//texk/kpathsea")] + deps,
        visibility = visibility,
    )
