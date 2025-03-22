# ffmpeg

The `ffmpeg` module is a hand crafted port from the original `configure` build scripts.

## Adding a New FFmpeg Version to the BCR

When adding new versions, the following steps may be helpful.

### 1. Directory Setup

```bash
cp -r modules/ffmpeg/7.1.1 modules/ffmpeg/<NEW_VERSION>
```

Add `"<NEW_VERSION>"` to `metadata.json` `"versions"` array.

### 2. Files to Update

All paths below are relative to `modules/ffmpeg/<NEW_VERSION>/`.

#### `config_defs.bzl`

Update the version string in `FFVERSION_H`.

#### `component_defs.bzl`

Re-extract from the new FFmpeg `configure` script:

| Variable                | Source in `configure`                                                                                                                 |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `COMPONENT_TYPES`       | `DECODER_LIST`, `ENCODER_LIST`, `MUXER_LIST`, `DEMUXER_LIST`, `FILTER_LIST`, `BSF_LIST`, `PROTOCOL_LIST`, `INDEV_LIST`, `OUTDEV_LIST` |
| `PROFILE_EVERYTHING`    | Flat union of all the above lists                                                                                                     |
| `CONFIG_EXTRA_REGISTRY` | `CONFIG_EXTRA` block in `configure`                                                                                                   |
| `FILTER_SYMBOL_MAP`     | `FILTER_LIST` entries mapped to their C symbol names (see `libavfilter/allfilters.c`)                                                 |

#### `ffmpeg_config_checks.bzl`

Diff the new `configure` for added/removed/changed feature-detection checks and mirror them as `checks.AC_TRY_COMPILE` entries.

#### `BUILD.bazel`

Update unconditional source lists (`_AVUTIL_SRCS`, `_AVCODEC_BASE_SRCS`, etc.) by diffing the new Makefiles' unconditional `OBJS =` / `OBJS +=` lines. Check for new/removed headers in glob patterns and any new library dependencies.

#### Test `BUILD.bazel` files

Add or remove test targets in `libavcodec/tests/`, `libavfilter/tests/`, `libavutil/tests/`, `libswscale/tests/`, and `tests/` if test sources changed.

### 3. Regenerating `component_srcs.bzl`

`generate_component_srcs.py` (at `modules/ffmpeg/generate_component_srcs.py`) is reusable across versions. It reads `PROFILE_EVERYTHING` from `component_defs.bzl` **in the same directory as the script**, parses `OBJS-$(CONFIG_*)` lines from the FFmpeg Makefiles, and writes `component_srcs.bzl` to stdout.

Steps:

1. Update `component_defs.bzl` in the overlay first (the script depends on it).
2. Copy or symlink `generate_component_srcs.py` into the overlay directory.
3. Run:
   ```bash
   python3 generate_component_srcs.py /path/to/ffmpeg/source > $VERSION/overlay/component_srcs.bzl
   ```
4. New components are handled automatically as long as `PROFILE_EVERYTHING` is current.

#### Script tunables

If the new FFmpeg version introduces changes, these lists inside `generate_component_srcs.py` may need updating:

| Variable                 | When to update                                                                       |
| ------------------------ | ------------------------------------------------------------------------------------ |
| `CONFIG_EXTRA`           | New internal subsystem flags appear in `configure`'s `CONFIG_EXTRA` block            |
| `EXTERNAL_FILES_TO_SKIP` | New source files require external/platform headers unavailable in the Bazel build    |
| `LIBS[].sub_makefiles`   | A library gains a new sub-directory with its own `Makefile` (e.g. `libavcodec/vvc/`) |

### 4. x86 NASM Assembly

FFmpeg uses NASM-syntax `.asm` files for x86 SIMD optimizations (161 files in 7.1.1). These are compiled via `rules_nasm` and linked into each library through `select()` on `@platforms//cpu:x86_64`.

Key points for new versions:

- All `.asm` files are compiled unconditionally; the C init files gate registration via `HAVE_X86ASM` and component flags.
- `config.asm` is auto-generated from `config.h` by a `genrule` (converts `#define` to `%define`).
- Template `.asm` files (e.g. `*_template.asm`) must be excluded from `srcs` and listed in `hdrs`.
- Include-only files (`x86inc.asm`, `x86util.asm`) go in `hdrs`, not `srcs`.
- All `nasm_library` targets are tagged `manual` to avoid building on non-x86 platforms.

When updating, check each library's `x86/Makefile` for new `.asm` files. The glob patterns in `BUILD.bazel` pick up additions automatically. If a new library gains x86 assembly, add a corresponding `nasm_library` target and wire it into the `cc_variant_library` `srcs`.

### 5. External Library Dependencies

Components that wrap external libraries (e.g. `libx264_encoder`, `alsa_indev`) need conditional `select()` entries in the library target's `deps` so the external library is linked only when the component is enabled. The pattern is:

```starlark
deps = [...] + select({
    "//:enable_libx264_encoder_is_true": ["@x264"],
    "//conditions:default": [],
}),
```

When adding a new version, check `COMPONENT_REGISTRY` in `component_defs.bzl` for entries with `"deps"` fields. If the dep maps to a `bazel_dep` in `MODULE.bazel`, ensure a matching `select()` exists on the appropriate library target (`avcodec`, `avformat`, `avfilter`, or `avdevice`).

Dependencies listed as `"suggest"` (e.g. `bzlib`, `lzma`) are optional -- the source code guards their usage behind autoconf `CONFIG_*` flags and compiles without them.
