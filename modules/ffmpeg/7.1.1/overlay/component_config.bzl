"""FFmpeg component configuration rule.

Provides a Bazel rule that resolves component dependencies and generates
config_components.h and *_list.c files based on per-component bool_flag
build settings.

Usage in BUILD.bazel:
    ffmpeg_component_gen(name = "ffmpeg_components")

Configure via build flags:
    bazel build //:ffmpeg --//:enable_aac_decoder=True --//:enable_h264_decoder=True
    bazel build //:ffmpeg --//:enable_vp9_decoder=False
"""

load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load(
    ":component_defs.bzl",
    "ALWAYS_AVAILABLE_LIBS",
    "COMPONENT_REGISTRY",
    "CONFIG_EXTRA_REGISTRY",
    "FILTER_SYMBOL_MAP",
    "PROFILE_EVERYTHING",
)
load(
    ":component_resolve.bzl",
    "generate_config_components_lines",
    "generate_config_extra_lines",
    "resolve_components",
)

def _resolve_from_settings(ctx):
    """Read per-component bool_flags and resolve the final component set."""
    enabled = []
    for i, target in enumerate(ctx.attr._components):
        if target[BuildSettingInfo].value:
            enabled.append(PROFILE_EVERYTHING[i])
    return resolve_components(enabled, COMPONENT_REGISTRY, CONFIG_EXTRA_REGISTRY, ALWAYS_AVAILABLE_LIBS)

def _gen_list_content(state, comp_types, struct_type, list_name, symbol_fn):
    """Generate content lines for a *_list.c file."""
    lines = ["static const {} * const {} [] = {{".format(struct_type, list_name)]
    for comp in sorted(COMPONENT_REGISTRY.keys()):
        entry = COMPONENT_REGISTRY[comp]
        if entry.get("type") not in comp_types:
            continue
        if not state.get(comp, False):
            continue
        sym = symbol_fn(comp, entry)
        lines.append("    &ff_{},".format(sym))
    return lines

def _identity_symbol(comp, _entry):
    return comp

def _filter_symbol(comp, _entry):
    return FILTER_SYMBOL_MAP.get(comp, comp)

def _indev_symbol(comp, _entry):
    if comp.endswith("_indev"):
        return comp[:-len("_indev")] + "_demuxer"
    return comp

def _outdev_symbol(comp, _entry):
    if comp.endswith("_outdev"):
        return comp[:-len("_outdev")] + "_muxer"
    return comp

_LIST_CONFIGS = [
    ("libavcodec/codec_list.c", ["decoder", "encoder"], "FFCodec", "codec_list", _identity_symbol),
    ("libavcodec/parser_list.c", ["parser"], "AVCodecParser", "parser_list", _identity_symbol),
    ("libavcodec/bsf_list.c", ["bsf"], "FFBitStreamFilter", "bitstream_filters", _identity_symbol),
    ("libavformat/demuxer_list.c", ["demuxer"], "FFInputFormat", "demuxer_list", _identity_symbol),
    ("libavformat/muxer_list.c", ["muxer"], "FFOutputFormat", "muxer_list", _identity_symbol),
    ("libavformat/protocol_list.c", ["protocol"], "URLProtocol", "url_protocols", _identity_symbol),
    ("libavfilter/filter_list.c", ["filter"], "AVFilter", "filter_list", _filter_symbol),
    ("libavdevice/indev_list.c", ["indev"], "FFInputFormat", "indev_list", _indev_symbol),
    ("libavdevice/outdev_list.c", ["outdev"], "FFOutputFormat", "outdev_list", _outdev_symbol),
]

_FILTER_BUFFER_ENTRIES = [
    "asrc_abuffer",
    "vsrc_buffer",
    "asink_abuffer",
    "vsink_buffer",
]

def _ffmpeg_component_gen_impl(ctx):
    state = _resolve_from_settings(ctx)

    outputs = []

    # config_components.h (ALL_COMPONENTS only)
    comp_h = ctx.actions.declare_file("config_components.h")
    lines = generate_config_components_lines(state, COMPONENT_REGISTRY)
    ctx.actions.write(comp_h, "\n".join(lines) + "\n")
    outputs.append(comp_h)

    # config_extra.h (CONFIG_EXTRA subsystems, included by config.h)
    extra_h = ctx.actions.declare_file("config_extra.h")
    extra_lines = generate_config_extra_lines(state, CONFIG_EXTRA_REGISTRY)
    ctx.actions.write(extra_h, "\n".join(extra_lines) + "\n")
    outputs.append(extra_h)

    # *_list.c files
    for path, comp_types, struct_type, list_name, symbol_fn in _LIST_CONFIGS:
        out = ctx.actions.declare_file(path)
        lines = _gen_list_content(state, comp_types, struct_type, list_name, symbol_fn)

        if list_name == "filter_list":
            for buf in _FILTER_BUFFER_ENTRIES:
                lines.append("    &ff_{},".format(buf))

        lines.append("    NULL };")
        ctx.actions.write(out, "\n".join(lines) + "\n")
        outputs.append(out)

    return [DefaultInfo(files = depset(outputs))]

_COMPONENT_LABELS = [Label("//:enable_" + comp) for comp in PROFILE_EVERYTHING]

ffmpeg_component_gen = rule(
    doc = "Resolves component dependencies and generates config_components.h, " +
          "config_extra.h, and *_list.c files from per-component bool_flag settings.",
    implementation = _ffmpeg_component_gen_impl,
    attrs = {
        "_components": attr.label_list(
            doc = "Per-component bool_flag targets, one per entry in PROFILE_EVERYTHING.",
            default = _COMPONENT_LABELS,
        ),
    },
)
