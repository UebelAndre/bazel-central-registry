"""Helper macro for declaring the upstream `tests/TESTS` shell scripts as tests."""

load("@bazel_skylib//rules:native_binary.bzl", "native_test")

_GREP = Label("//:grep")
_CONFIG_H = Label("//:config")
_INIT_SH = Label("//tests:init.sh")
_GET_MB_CUR_MAX = Label("//tests:get-mb-cur-max")
_RUNNER = Label("//tests:run_grep_test")

def declared_tests(*, mirror, omitted, present):
    """Subtract the omitted tests from the `tests/Makefile.am` `TESTS` mirror.

    Also guards the mirror against going stale: at the next version bump a
    renamed or removed upstream test would otherwise silently drop its
    coverage. (The reverse -- a *new* upstream test missing from the mirror --
    cannot be caught here and needs a manual diff.)

    Args:
        mirror: Verbatim copy of upstream's `TESTS`.
        omitted: `{test name: reason}` for the tests deliberately not declared.
        present: The names actually shipped in the tarball's `tests/`.

    Returns:
        The sorted list of test names to declare.
    """
    missing = [t for t in mirror if t not in present]
    unused = [t for t in omitted if t not in mirror]
    if missing or unused:
        fail("tests/Makefile.am TESTS mirror is stale. Not in the tarball: {}. Omitted but not listed: {}.".format(
            missing,
            unused,
        ))
    return [t for t in mirror if t not in omitted]

def grep_test(*, name, data):
    """Declare one upstream `tests/<name>` script as a test.

    Every test is the same binary, `//tests:run_grep_test`, told which script
    to run. It reconstructs the directory layout and environment that
    `tests/Makefile.am`'s `TESTS_ENVIRONMENT` would have provided (a build
    tree with `src/grep` next to `tests/`, the `srcdir`/`abs_top_builddir`
    variables, `PATH` pointing at the built binaries, and file descriptor 9
    aliased to stderr for `init.cfg`) and then runs the script through
    `/bin/sh` -- or, on Windows, the shell `BAZEL_SH` names.

    Upstream tests signal "not applicable here" with exit status 77 -- most
    often a missing locale. Bazel has no runtime-skip status, so the runner
    maps 77 to 0 after printing a `SKIPPED:` banner; check the test log to
    see which ones did not actually execute.

    The target is named `<name>_test` rather than `<name>`: the script itself
    is a source file in this package and is passed through `data`, and a rule
    sharing that name would shadow the file into a self-edge.

    Args:
        name: Name of the upstream script in `tests/`.
        data: The `tests/` data files to stage (the whole directory -- the
            scripts source `init.sh`/`init.cfg` and several reach for
            siblings such as `bre.awk` or `khadafy.lines`).
    """
    native_test(
        name = "{}_test".format(name),
        size = "small",
        src = _RUNNER,
        args = [
            "$(rlocationpath {})".format(_GREP),
            "$(rlocationpath {})".format(_INIT_SH),
            "$(rlocationpath {})".format(_GET_MB_CUR_MAX),
            "$(rlocationpath {})".format(_CONFIG_H),
            name,
        ],
        data = data + [
            _CONFIG_H,
            _GET_MB_CUR_MAX,
            _GREP,
            _INIT_SH,
        ],
        # The runner itself is portable and the suite does run under MSYS2's
        # bash (65 of 124 pass on a Windows box), but the rest need
        # /dev/full, directories that open(), SIGPIPE, or expect `grep:`
        # rather than `grep.exe:` in diagnostics.  Until those are triaged
        # into a per-platform omission list, Windows keeps the portable
        # smoke test only.
        target_compatible_with = select({
            "@platforms//os:windows": ["@platforms//:incompatible"],
            "//conditions:default": [],
        }),
    )
