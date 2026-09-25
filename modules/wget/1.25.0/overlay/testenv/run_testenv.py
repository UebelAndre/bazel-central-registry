"""Runs one of upstream's testenv/ tests the way `make check` does.

testenv/Makefile.am:112 runs each `Test-*.py` with the testenv directory on
PYTHONPATH, WGETRC=/dev/null and MAKE_CHECK set, plus SSL_TESTS=1 when wget
was built with TLS (that one comes in through the py_test's `env`), and
automake's harness exports `srcdir`, which the HTTPS tests use to find
`certs/` (testenv/server/http/http_server.py:43).  The test locates wget
through WGET_PATH
(testenv/test/base_test.py:119), creates a `<Test>-test` directory in the
working directory and chdir()s into it, so it has to run somewhere writable.
Exit status 77 is the suite's "skipped", which Bazel has no notion of.

Arguments: the rlocationpath of the test script and that of the wget binary.
"""

import os
import runpy
import sys

from python.runfiles import runfiles


def main() -> None:
    script, wget = sys.argv[1:3]
    r = runfiles.Create()
    script_path = r.Rlocation(script)
    wget_path = r.Rlocation(wget)

    os.environ["WGET_PATH"] = os.path.abspath(wget_path)
    os.environ["WGETRC"] = os.devnull
    os.environ["MAKE_CHECK"] = "True"

    # The test modules (`from test.http_test import ...`) resolve against the
    # testenv directory, exactly as PYTHONPATH=$(srcdir) arranges upstream.
    testenv_dir = os.path.dirname(os.path.abspath(script_path))
    sys.path.insert(0, testenv_dir)
    os.environ["srcdir"] = testenv_dir

    work = os.path.join(os.environ.get("TEST_TMPDIR", "/tmp"), "testenv")
    os.makedirs(work, exist_ok=True)
    os.chdir(work)

    try:
        runpy.run_path(script_path, run_name="__main__")
    except SystemExit as e:
        code = e.code if isinstance(e.code, int) else (0 if e.code is None else 1)
        if code == 77:
            print("SKIPPED: the test reported exit status 77", file=sys.stderr)
            sys.exit(0)
        sys.exit(code)


if __name__ == "__main__":
    main()
