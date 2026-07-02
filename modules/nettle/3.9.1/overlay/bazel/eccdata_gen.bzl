"""Rule wrapping the `eccdata` bootstrap tool that prints a curve's
precomputed points to stdout. Mirrors this Makefile.in recipe:

    ecc-<curve>.h: eccdata.stamp
        ./eccdata <curve> <k> <c> $(NUMB_BITS) > $@T && mv $@T $@

The stdout redirect and rename-on-success are wrapped in a small
cross-platform C++ helper (//bazel/tools:stdout_to_file) so no shell
is required on the build host.
"""

def _eccdata_gen_impl(ctx):
    args = ctx.actions.args()
    args.add(ctx.outputs.out)
    args.add(ctx.executable._eccdata)
    args.add(ctx.attr.curve)
    args.add(str(ctx.attr.k))
    args.add(str(ctx.attr.c))
    args.add(str(ctx.attr.numb_bits))

    ctx.actions.run(
        executable = ctx.executable._stdout_to_file,
        arguments = [args],
        tools = [ctx.executable._eccdata],
        outputs = [ctx.outputs.out],
        mnemonic = "EccData",
        progress_message = "Generating ECC table for %{output}",
    )

    return [DefaultInfo(files = depset([ctx.outputs.out]))]

eccdata_gen = rule(
    implementation = _eccdata_gen_impl,
    attrs = {
        "out": attr.output(
            mandatory = True,
            doc = "Path of the generated ecc-<curve>.h header.",
        ),
        "curve": attr.string(
            mandatory = True,
            doc = "Curve name passed to eccdata (e.g. `secp256r1`).",
        ),
        "k": attr.int(
            mandatory = True,
            doc = "Table window size — see Makefile.in ecc-<curve>.h recipes.",
        ),
        "c": attr.int(
            mandatory = True,
            doc = "Chunk size — see Makefile.in ecc-<curve>.h recipes.",
        ),
        "numb_bits": attr.int(
            default = 64,
            doc = "GMP limb width. 64 matches every 64-bit target; add a " +
                  "select() for a future 32-bit port.",
        ),
        "_eccdata": attr.label(
            default = Label("//:eccdata"),
            executable = True,
            cfg = "exec",
        ),
        "_stdout_to_file": attr.label(
            default = Label("//bazel/tools:stdout_to_file"),
            executable = True,
            cfg = "exec",
        ),
    },
)
