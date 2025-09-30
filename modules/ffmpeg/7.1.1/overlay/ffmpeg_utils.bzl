"""Utility functions for building FFmpeg with Bazel."""

load("@rules_cc//cc:cc_library.bzl", "cc_library")

def ffmpeg_library(
        name,
        srcs = [],
        hdrs = [],
        deps = [],
        copts = [],
        linkopts = [],
        local_defines = [],
        includes = [],
        visibility = None,
        nasm_srcs = [],
        asm_srcs = [],
        textual_hdrs = []):
    """Helper macro to build an FFmpeg library with architecture-specific support.

    Args:
        name: Name of the library
        srcs: C source files
        hdrs: Header files (public API)
        deps: Dependencies
        copts: Compiler options
        linkopts: Linker options
        local_defines: Local defines
        includes: Include directories
        visibility: Visibility
        nasm_srcs: x86 NASM assembly files
        asm_srcs: ARM/AARCH64 assembly files
        textual_hdrs: Headers that can be textually included
    """

    # Common FFmpeg compiler flags with platform-specific defines
    common_copts = select({
        "@platforms//os:macos": [
            "-D_DARWIN_C_SOURCE",  # Enable BSD extensions on macOS
            "-D_DEFAULT_SOURCE",  # Enable all features including time_t
            "-std=gnu11",
            "-Wno-deprecated-declarations",
            "-Wno-pointer-sign",
            "-Wno-switch",
            "-Wno-unused-function",
            "-Wno-uninitialized",
            "-Wno-ignored-qualifiers",
            "-Wno-incompatible-pointer-types",
            "-Wno-implicit-function-declaration",
            "-Wno-error=implicit-function-declaration",  # Suppress as error too
            "-Wno-language-extension-token",
            "-Wno-int-conversion",
            "-pthread",
        ] + copts,
        "//conditions:default": [
            "-D_DEFAULT_SOURCE",  # Enable all features including time_t
            "-std=gnu11",
            "-Wno-deprecated-declarations",
            "-Wno-pointer-sign",
            "-Wno-switch",
            "-Wno-unused-function",
            "-Wno-uninitialized",
            "-Wno-ignored-qualifiers",
            "-Wno-incompatible-pointer-types",
            "-Wno-implicit-function-declaration",
            "-Wno-error=implicit-function-declaration",  # Suppress as error too
            "-Wno-language-extension-token",
            "-Wno-int-conversion",
            "-pthread",
        ] + copts,
    })

    # Combine sources with architecture-specific assembly
    all_srcs = srcs + asm_srcs

    cc_library(
        name = name,
        srcs = all_srcs,
        hdrs = hdrs,
        textual_hdrs = textual_hdrs,
        deps = deps,
        copts = common_copts,
        linkopts = linkopts,
        local_defines = local_defines,
        includes = includes,
        visibility = visibility,
        alwayslink = 1,
    )

def glob_sources(
        base_path,
        exclude = [],
        include_subdirs = False):
    """Glob source files in a specific pattern.

    Args:
        base_path: Base directory path
        exclude: Files to exclude
        include_subdirs: Whether to include subdirectories

    Returns:
        Dictionary with 'srcs' and 'hdrs' lists
    """
    pattern_prefix = base_path + "/**/" if include_subdirs else base_path + "/"

    return {
        "hdrs": native.glob(
            [pattern_prefix + "*.h"],
            exclude = exclude,
        ),
        "srcs": native.glob(
            [pattern_prefix + "*.c"],
            exclude = exclude,
        ),
    }
