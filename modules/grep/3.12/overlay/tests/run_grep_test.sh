#!/usr/bin/env bash
#
# Runs one script from grep's upstream `tests/` suite.
#
# The suite is written against `make check`: each script does
# `. "${srcdir=.}/init.sh"; path_prepend_ ../src`, so it expects the working
# directory to be `<builddir>/tests` with the binaries one level up in
# `<builddir>/src`. Bazel hands us a flat, read-only runfiles tree instead, so
# this reassembles that layout under $TEST_TMPDIR and re-exports the variables
# `tests/Makefile.am`'s TESTS_ENVIRONMENT would have set.

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
# shellcheck disable=SC1090
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

GREP=$(rlocation "$1"); shift
INIT_SH=$(rlocation "$1"); shift
GET_MB_CUR_MAX=$(rlocation "$1"); shift
CONFIG_H=$(rlocation "$1"); shift
TEST_NAME="$1"; shift

# Every `tests/` source file is in `data`, so the directory holding `init.sh`
# in the runfiles tree is the upstream `srcdir`.
SRCDIR=$(dirname "$INIT_SH")

# `init.sh`'s setup_ does `mktempd_ "$initial_cwd_"` and cds into the result,
# so only this directory needs to be writable -- its contents are read-only to
# the suite and can stay as links into the runfiles tree.
STAGE="${TEST_TMPDIR:?required by the bazel test environment}/tree"
mkdir -p "$STAGE/src" "$STAGE/tests"
ln -s "$SRCDIR"/* "$STAGE/tests/"
ln -s "$GREP" "$STAGE/src/grep"
# `-f`: get-mb-cur-max is declared in this package, so it already arrived in
# the runfiles directory the glob above linked.
ln -sf "$GET_MB_CUR_MAX" "$STAGE/tests/get-mb-cur-max"

# Upstream generates egrep/fgrep from `src/egrep.sh` at install time; the
# `help-version` test runs whatever `built_programs` advertises.
printf '#!/bin/sh\nexec grep -E "$@"\n' > "$STAGE/src/egrep"
printf '#!/bin/sh\nexec grep -F "$@"\n' > "$STAGE/src/fgrep"
chmod u+x "$STAGE/src/egrep" "$STAGE/src/fgrep"

cd "$STAGE/tests"

# `envvar-check` unsets the variables whose presence would perturb the suite
# (TERM, LS_COLORS, POSIXLY_CORRECT, ...). Its last statement is a `test`
# that returns 1 when it found nothing to do, so guard it.
# shellcheck disable=SC1091
. ./envvar-check || :

# configure probes these with gt_LOCALE_FR*, but locale availability is a
# property of the machine running the test, not the one that built grep, so
# probe here. `init.cfg` treats "none" as "skip the test for want of a locale".
available_locales=$(locale -a 2>/dev/null)
locale_or_none() {
  local candidate
  for candidate in "$@"; do
    if printf '%s\n' "$available_locales" | grep -qx "$candidate"; then
      echo "$candidate"
      return
    fi
  done
  echo none
}

export LOCALE_FR
export LOCALE_FR_UTF8
LOCALE_FR=$(locale_or_none fr_FR fr_FR.ISO-8859-1 fr_FR.ISO8859-1)
LOCALE_FR_UTF8=$(locale_or_none fr_FR.UTF-8 fr_FR.utf8)

# `help-version` cross-checks `grep --version` against $VERSION, and several
# tests report $PACKAGE_BUGREPORT. Read both out of the generated config.h so
# they cannot drift from what the binary was actually built with.
config_define() {
  sed -n "s/^#define $1 \"\\(.*\\)\"\$/\\1/p" "$CONFIG_H"
}

export PACKAGE_BUGREPORT
export VERSION
PACKAGE_BUGREPORT=$(config_define PACKAGE_BUGREPORT)
VERSION=$(config_define VERSION)

export AWK=awk
export CONFIG_HEADER="$CONFIG_H"
export LC_ALL=C
export MALLOC_PERTURB_=1
export SHELL=/bin/sh
export TMPDIR="$STAGE"
export abs_srcdir="$STAGE/tests"
export abs_top_builddir="$STAGE"
export abs_top_srcdir="$STAGE"
export built_programs='grep egrep fgrep'
export srcdir=.
export top_srcdir=..

# Only `tests/stack-overflow` reads this, and only to skip on MidnightBSD.
export host_triplet=unknown

export PATH="$STAGE/src:$PATH"

# `tests/init.cfg` sets stderr_fileno_=9 to match the `9>&2` that
# TESTS_ENVIRONMENT appends; without it every skip_/fail_ diagnostic dies on a
# bad file descriptor.
exec 9>&2

rc=0
"$SHELL" "./$TEST_NAME" || rc=$?

# Upstream uses exit 77 for "not applicable on this machine" -- almost always a
# missing locale, or an expensive test that is off by default. Bazel has no
# runtime-skip status, so report it loudly and pass.
if [ "$rc" -eq 77 ]; then
  echo "SKIPPED: $TEST_NAME requested a skip (exit 77); see the log above."
  exit 0
fi
exit "$rc"
