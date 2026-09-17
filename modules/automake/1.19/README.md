# Patches

This version ships the following patch on top of upstream GNU Automake 1.19:

- **`relocatable-tool-paths.patch`** -- Two changes, both aimed at letting `aclocal` and `automake` run from a Bazel
runfiles tree with nothing but a shell on `PATH`.

  **Paths.** Upstream composes its install directories inside the scripts -- `'@datadir@/@PACKAGE@-@APIVERSION@'` in
  the `BEGIN` blocks and in `Automake/Config.in`, `'@datadir@/aclocal-' . $APIVERSION` in `aclocal` -- which pins the
  directory names to the package name and version. `configure` already `AC_SUBST`s each of those directories as a
  single variable (`pkgvdatadir`, `automake_acdir`, `system_acdir`; see `configure.ac` and the `do_subst` rule in
  `Makefile.am`), so the patch switches the scripts to those. That is a no-op for `make install`, and it lets the
  Bazel build point them at the tarball's own `lib/` and `m4/` directories rather than reconstructing an install tree.

  Each of them, plus `@am_AUTOCONF@` and `@am_AUTOM4TE@`, then goes through
  `File::Spec->rel2abs ($path, File::Basename::dirname ($0))`. That is a no-op for an absolute path -- a normal
  install tree behaves exactly as before -- but anchors a relative one to the script's own directory, which is what
  `BUILD.bazel` substitutes. For the two tool paths the patch additionally leaves a bare program name alone, since
  that is what `configure` substitutes when it wants a `PATH` lookup.

  **`cp`.** `aclocal --install` and `automake --add-missing` each shelled out to `cp(1)`, the last external program
  either script needed. Both now call a new `Automake::FileUtils::copy_file`, which is `File::Copy::copy` plus an
  explicit `chmod` to carry the mode over -- several of the files `--add-missing` installs are scripts and have to
  stay executable.

# Overriding tools from an action

Every external program the two scripts invoke keeps its environment-variable override, so a rule can repoint any of
them:

| Variable | Used by | Overrides |
| --- | --- | --- |
| `AUTOCONF` | `automake` | the `@autoconf//:autoconf` launcher it traces `configure.ac` with |
| `AUTOM4TE` | `aclocal` | the `@autoconf//:autom4te` launcher |
| `AUTOMAKE_LIBDIR` | both | `pkgvdatadir`: the Perl library, the `am/*.am` fragments and the `--add-missing` scripts |
| `ACLOCAL_PATH` | `aclocal` | adds directories to the system macro search path |
| `AUTOMAKE_UNINSTALLED` | both | skips the `@INC` entry entirely, for running from a build tree |
| `AUTOMAKE_JOBS` | `automake` | number of Makefiles to generate in parallel |

`aclocal` also takes `--automake-acdir` and `--system-acdir` on the command line.

When driving the suite through `autoreconf` from `@autoconf`, set `ACLOCAL` and `AUTOMAKE` to the launchers in this
module; `autoreconf` looks both up on `PATH` otherwise.

Note that a `perl_binary`'s `env` attribute only reaches `bazel run` and tests -- it is carried by
`RunEnvironmentInfo`, which `ctx.actions.run` ignores. A rule that wants one of these set for a build action must put
it in the action's own `env`.

# Platform support

All targets are `target_compatible_with` not-Windows, matching `@autoconf`. `aclocal` and `automake` read `autom4te`
through a shell pipeline, and the Makefiles they emit are for a POSIX `make`, so Windows use means MSYS, which is
outside what this module can express.
