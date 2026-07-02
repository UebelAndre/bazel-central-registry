"""gperf_static"""

def _gperf_static_impl(ctx):
    raw = ctx.actions.declare_file(ctx.label.name + ".raw.h")

    # Step 1: gperf → raw.h, capturing stdout via stdout_to_file.
    gperf_args = ctx.actions.args()
    gperf_args.add(raw)
    gperf_args.add(ctx.executable._gperf)
    gperf_args.add("--global-table")
    gperf_args.add("-t")
    gperf_args.add(ctx.file.src)
    ctx.actions.run(
        executable = ctx.executable._stdout_to_file,
        arguments = [gperf_args],
        tools = [ctx.executable._gperf],
        inputs = [ctx.file.src],
        outputs = [raw],
        mnemonic = "Gperf",
        progress_message = "Running gperf on %{input}",
    )

    # Step 2: raw.h → out, rewriting `const struct <name> *` prefix to `static`.
    find = "const struct {} *".format(ctx.attr.struct_name)
    replace = "static const struct {} *".format(ctx.attr.struct_name)
    replace_args = ctx.actions.args()
    replace_args.add(raw)
    replace_args.add(ctx.outputs.out)
    replace_args.add(find)
    replace_args.add(replace)
    ctx.actions.run(
        executable = ctx.executable._text_replace,
        arguments = [replace_args],
        inputs = [raw],
        outputs = [ctx.outputs.out],
        mnemonic = "GperfStaticRewrite",
        progress_message = "Rewriting %{output} to hide gperf lookup table",
    )

    return [DefaultInfo(files = depset([ctx.outputs.out]))]

gperf_static = rule(
    implementation = _gperf_static_impl,
    doc = """\
Run `gperf` on a `.gperf` source, then rewrite the exported table
symbol from `const struct <name> *` to `static const struct <name> *`.

Mirrors the shell pipeline in lib/Makefile.am:

    gperf --global-table -t <input>.gperf > $@-tmp
    sed 's/^const struct <name> \\*/static const struct <name> \\*/' <$@-tmp >$@

The gperf invocation is driven by @gperf//:gperf via //bazel/tools:stdout_to_file
(which handles the `> file` redirect portably); the sed step is replaced
by //bazel/tools:text_replace so no shell is needed on the build host.
""",
    attrs = {
        "src": attr.label(
            allow_single_file = [".gperf"],
            mandatory = True,
            doc = "The `.gperf` source to compile.",
        ),
        "out": attr.output(
            mandatory = True,
            doc = "Path of the generated `.h` file.",
        ),
        "struct_name": attr.string(
            mandatory = True,
            doc = "The `%struct-type`'s C struct name; used to build the " +
                  "prefix that the rewrite step converts to `static`.",
        ),
        "_gperf": attr.label(
            default = "@gperf//:gperf",
            executable = True,
            cfg = "exec",
        ),
        "_stdout_to_file": attr.label(
            default = "//bazel/tools:stdout_to_file",
            executable = True,
            cfg = "exec",
        ),
        "_text_replace": attr.label(
            default = Label("//bazel/tools:text_replace"),
            executable = True,
            cfg = "exec",
        ),
    },
)
