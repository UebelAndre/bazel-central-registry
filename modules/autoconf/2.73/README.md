# Patches

This version ships the following patch on top of upstream GNU Autoconf 2.73:

- **`relocatable-tool-paths.patch`** -- Upstream's `configure` bakes absolute install paths into the generated Perl
scripts: `@pkgdatadir@` for the macro and Perl-library tree, `@bindir@` for the sibling tools, and `@M4@` for m4
itself. A Bazel runfiles tree has no fixed location, so the patch routes every one of those through
`File::Spec->rel2abs ($path, File::Basename::dirname ($0))`. That is a no-op for an absolute path -- a normal
`make install` tree behaves exactly as before -- but anchors a relative one to the script's own directory, which is
what `BUILD.bazel` substitutes. The patch also gives `autoscan` and `autoupdate` the `AC_MACRODIR` override the other
tools already had, and drops the four `--prepend-include '@pkgdatadir@'` lines from `lib/autom4te.in` (the one place
an absolute path reached `autom4te` as data rather than as code), restoring the upstream include precedence in
`bin/autom4te.in` instead.

  Two smaller changes in the same patch remove system tools from paths that run on *every* invocation, so the
  Autoconf programs depend on nothing but the shell and the m4 staged in their own runfiles:

  - The GNU m4 version check in `bin/autom4te.in` was `system ("$m4 --help | grep reload-state")`. It is now a Perl
    regex match on the captured output, so it needs neither `grep` nor `/dev/null`.
  - `bin/autoheader.in` read `autom4te`'s trace output through a `sed` subprocess. It now reads the file directly and
    only shells out to `sed` under `--verbose --debug`, where the intent is to show the pipeline.

# Overriding tools from an action

Every external program the Autoconf tools invoke keeps (or gains) an environment-variable override, so a rule can
repoint any of them without patching further:

| Variable | Used by | Overrides |
| --- | --- | --- |
| `M4` | `autom4te`, `autoupdate` | the m4 staged at `bin/m4` |
| `AUTOM4TE` | `autoconf`, `autoheader`, `autoscan`, `autoupdate`, `autoreconf` | the `autom4te` launcher |
| `AUTOCONF` | `autoreconf`, `autoupdate` | the `autoconf` launcher |
| `AUTOHEADER` | `autoreconf` | the `autoheader` launcher |
| `AUTOMAKE`, `ACLOCAL`, `LIBTOOLIZE`, `AUTOPOINT`, `MAKE` | `autoreconf` | tools from outside this module; these are looked up on `PATH` unless set |
| `AC_MACRODIR` | `autoscan`, `autoupdate` | the macro search path |
| `autom4te_perllibdir` | all | the Perl library and macro directory (`pkgdatadir`) |
| `autom4te_buildauxdir` | `autoreconf` | the `config.guess` / `config.sub` / `install-sh` directory |
| `AUTOM4TE_CFG` | `autom4te` | the `autom4te.cfg` language definitions |
| `AUTOM4TE_DEBUG`, `AUTOCONF_DEBUG` | `autom4te`, `autoconf` | keep temporary directories for debugging |
| `trailer_m4` | `autoconf` | the `trailer.m4` appended to `configure.ac` |

Note that a `perl_binary`'s `env` attribute only reaches `bazel run` and tests -- it is carried by
`RunEnvironmentInfo`, which `ctx.actions.run` ignores. A rule that wants one of these set for a build action must put
it in the action's own `env`.

# Platform support

All targets are `target_compatible_with` not-Windows. `autom4te` drives m4 through a POSIX shell -- single-quoted
arguments, `>` redirection and `< /dev/null` -- and the `configure` scripts Autoconf emits are POSIX shell as well, so
Windows use means MSYS, which is outside what this module can express.
