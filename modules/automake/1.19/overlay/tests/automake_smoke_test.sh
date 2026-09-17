#!/usr/bin/env bash
#
# Drives a real package all the way through the Autotools: aclocal, autoconf,
# automake --add-missing, ./configure, make, and then runs what make built.
#
# The sample package deliberately has no compiled sources, so the test needs
# only a POSIX shell environment, not a working C toolchain.

set -euo pipefail

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
# shellcheck disable=SC1090
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null ||
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null ||
  source "$0.runfiles/$f" 2>/dev/null ||
  source "$(grep -sm1 "^$f " "$0.runfiles/MANIFEST" | cut -f2- -d' ')" 2>/dev/null ||
  source "$(grep -sm1 "^$f " "$0.exe.runfiles/MANIFEST" | cut -f2- -d' ')" 2>/dev/null ||
  { echo >&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

ACLOCAL="$(rlocation "${ACLOCAL_RLOCATIONPATH}")"
AUTOCONF="$(rlocation "${AUTOCONF_RLOCATIONPATH}")"
AUTOMAKE="$(rlocation "${AUTOMAKE_RLOCATIONPATH}")"
AUTORECONF="$(rlocation "${AUTORECONF_RLOCATIONPATH}")"

readonly EXPECTED_VERSION="1.19"

fail() {
  echo >&2 "FAIL: $*"
  exit 1
}

run() {
  local log="$1"
  shift
  "$@" > "${log}" 2>&1 || { cat "${log}" >&2; fail "$1 exited non-zero"; }
}

for tool in "${ACLOCAL}" "${AUTOMAKE}"; do
  version="$("${tool}" --version)" || fail "${tool} --version exited non-zero"
  case "${version}" in
    *"GNU automake) ${EXPECTED_VERSION}"*) ;;
    *) fail "${tool} --version reported '$(echo "${version}" | head -n1)', want ${EXPECTED_VERSION}" ;;
  esac
done

workdir="${TEST_TMPDIR:-$(mktemp -d)}"

# ---------------------------------------------------------------------------
# A package with no compiled sources, so this needs no C toolchain.
# ---------------------------------------------------------------------------
write_package() {
  local dir="$1"
  mkdir -p "${dir}"
  cat > "${dir}/configure.ac" <<'EOF'
AC_INIT([smoke], [1.0], [nobody@example.com])
AM_INIT_AUTOMAKE([foreign -Wall -Werror])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
EOF
  cat > "${dir}/Makefile.am" <<'EOF'
EXTRA_DIST = greet.in
noinst_SCRIPTS = greet
CLEANFILES = greet

greet: greet.in Makefile
	$(AM_V_GEN)sed -e 's,[@]PACKAGE[@],$(PACKAGE),g' $(srcdir)/greet.in > $@
	$(AM_V_at)chmod +x $@
EOF
  cat > "${dir}/greet.in" <<'EOF'
#!/bin/sh
echo "hello from @PACKAGE@"
EOF
}

# --- the tools run individually ---------------------------------------------
pkg="${workdir}/pkg"
write_package "${pkg}"
cd "${pkg}"

run aclocal.log "${ACLOCAL}"
grep -q 'AM_INIT_AUTOMAKE' aclocal.m4 ||
  fail "aclocal.m4 has no AM_INIT_AUTOMAKE; the automake macro dir is not being found"

run autoconf.log "${AUTOCONF}"
[[ -f configure ]] || fail "autoconf did not write configure"

run automake.log "${AUTOMAKE}" --add-missing --copy
[[ -f Makefile.in ]] || fail "automake did not write Makefile.in"

# --add-missing goes through the patched copy_file rather than cp(1). These
# have to land executable or configure will refuse to use them.
for aux in install-sh missing; do
  [[ -f "${aux}" ]] || fail "automake --add-missing did not install ${aux}"
  [[ -x "${aux}" ]] || fail "${aux} was installed without its execute bit"
done

run configure.log ./configure
grep -q '^PACKAGE = smoke$' Makefile ||
  fail "configure did not substitute PACKAGE into Makefile"

run make.log make
[[ -x greet ]] || fail "make did not build greet"
greeting="$(./greet)"
[[ "${greeting}" == "hello from smoke" ]] ||
  fail "greet printed '${greeting}'"

# --- autoreconf drives the whole suite --------------------------------------
# `autoreconf` comes from @autoconf and finds aclocal and automake on PATH
# unless ACLOCAL and AUTOMAKE are set. Setting them is how a Bazel action keeps
# the toolchain hermetic, so that is what is tested.
recon="${workdir}/recon"
write_package "${recon}"
cd "${recon}"
run autoreconf.log env ACLOCAL="${ACLOCAL}" AUTOMAKE="${AUTOMAKE}" \
  "${AUTORECONF}" --force --install
for generated in aclocal.m4 configure Makefile.in install-sh missing; do
  [[ -e "${generated}" ]] || fail "autoreconf --install did not produce ${generated}"
done

# --- aclocal --install ------------------------------------------------------
# The other patched cp(1) call site. A macro reached through ACLOCAL_PATH
# counts as a system macro, which is what --install copies into the project.
inst="${workdir}/inst"
write_package "${inst}"
mkdir -p "${inst}/macros" "${inst}/m4"
cat > "${inst}/macros/smoke_extra.m4" <<'EOF'
AC_DEFUN([SMOKE_EXTRA], [AC_SUBST([SMOKE_EXTRA], [yes])])
EOF
cat >> "${inst}/configure.ac" <<'EOF'
SMOKE_EXTRA
EOF
cd "${inst}"
run aclocal_install.log env ACLOCAL_PATH="${inst}/macros" \
  "${ACLOCAL}" --install -I m4
[[ -f m4/smoke_extra.m4 ]] ||
  fail "aclocal --install did not copy smoke_extra.m4 into m4/"

# --- environment overrides --------------------------------------------------
# Checked negatively: if the override were ignored, the run would succeed
# against the runfiles copy instead of failing.
assert_override_is_honored() {
  local var="$1" tool="$2"
  shift 2
  if env "${var}=/nonexistent/definitely-not-a-program" "${tool}" "$@" \
       > override.log 2>&1; then
    cat override.log >&2
    fail "${var} was ignored: ${tool} succeeded with ${var} pointing at nothing"
  fi
}

cd "${pkg}"
assert_override_is_honored AUTOCONF "${AUTOMAKE}"
assert_override_is_honored AUTOM4TE "${ACLOCAL}"
assert_override_is_honored AUTOMAKE_LIBDIR "${AUTOMAKE}"

echo "PASS"
