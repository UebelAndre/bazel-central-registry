"""Yosys Bazel utilities"""

# buildifier: disable=bzl-visibility
load(
    "@rules_bison//bison/internal:bison_action.bzl",
    "BISON_ACTION_TOOLCHAINS",
    "bison_action",
    "bison_action_attrs",
)

def _yosys_bison_transition_impl(settings, _attr):
    # Get the current toolchains flag (comma-separated list).
    current = settings["//command_line_option:extra_toolchains"]
    if current:
        return {
            "//command_line_option:extra_toolchains": current + [str(Label("//:bison_toolchain"))],
        }
    else:
        return {
            "//command_line_option:extra_toolchains": [str(Label("//:bison_toolchain"))],
        }

_yosys_bison_transition = transition(
    implementation = _yosys_bison_transition_impl,
    inputs = ["//command_line_option:extra_toolchains"],
    outputs = ["//command_line_option:extra_toolchains"],
)

def _bison(ctx):
    if ctx.file.src.extension == "y":
        language = "c"
    else:
        language = "c++"
    result = bison_action(ctx, language)
    java_srcs = []
    cc_srcs = [result.source]
    cc_hdrs = [result.header]
    return [
        DefaultInfo(files = result.outs),
        OutputGroupInfo(
            bison_report = result.report_files,
            cc_srcs = depset(direct = cc_srcs),
            cc_hdrs = depset(direct = cc_hdrs),
            java_srcs = depset(direct = java_srcs),
        ),
    ]

bison = rule(
    implementation = _bison,
    cfg = _yosys_bison_transition,
    doc = """This rule is a vendoring of the one from `rules_bison` which is used to enforce a unique version of bison.""",
    attrs = bison_action_attrs({
        "src": attr.label(
            doc = """A Bison source file.""",
            mandatory = True,
            allow_single_file = [".y", ".yy", ".y++", ".yxx", ".ypp"],
        ),
    }),
    provides = [
        DefaultInfo,
        OutputGroupInfo,
    ],
    toolchains = BISON_ACTION_TOOLCHAINS,
)
