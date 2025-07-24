# %%

import shlex
import json
import re
import os
from pathlib import Path

INCLUDE_PATTERN = re.compile(r"^-I(.*)")
DEFINE_PATTERN = re.compile(r"^-D(.*)")
ARCHIVE_PATTERN = re.compile(r"(lib[\w\d\.]+)\.a")
DEPENDENCY_PATTERN = re.compile(r"-l(.+)")
FRAMEWORK_PATTERN = re.compile(r"-framework [\w]+ lib([\w]+)\.a")
OUTPUT_PATTERN = re.compile(r"-o ([\w\d\.]+)")

DEP_MAPPING = {
    "z": "@zlib",
    "libsqlite3.47.2.dylib": "@sqlite3",
    "libtdbcstub1.1.10": ":libtdbcstub",
    "libtdbcstub1.1.10.dylib": ":libtdbcstub",
    "libitcl4.3.2": "Llibitcl",
    "libitcl4.3.2.dylib": ":libitcl",
    "tdbcstub1.1.10": ":tdbcstub",
    "tdbcstub1.1.10.dylib": ":tdbcstub",
    "tclstub": ":tclstub",
    "itclstub": ":itclstub",
    "tdbcstub": ":tdbcstub",
    "libtclstub": ":tclstub",
    "pthread": ":pthread",
}

TOP_TARGETS = [
    "Tcl",
    "libtclstub",
    "libitclstub",
    "libtdbcstub",
    "tclstub",
    "itclstub",
    "tdbcstub",
    "tclsh",
    "tcltest",
]

OBJECT_MAP = {
    "tclTestInit.o": ":tclAppInit",
    "tclTest.o": "generic/tclTest.c",
    "tclTestObj.o": "generic/tclTestObj.c",
    "tclTestProcBodyObj.o": "generic/tclTestProcBodyObj.c",
    "tclThreadTest.o": "generic/tclThreadTest.c",
    "tclUnixTest.o": ":tclAppInit",
    "tclTestABSList.o": "generic/tclTestABSList.c",
}

SOURCE_MAP = {
    "unix/tclAppInit.c": ":tclAppInit",
    "windows/tclAppInit.c": ":tclAppInit",
}

DEFAULT_LIBRARY_NAME = "UNKNOWN"

CC_TARGET_TPL = """\
cc_{kind}(
    name = "{name}",
    srcs = {srcs},
    deps = {deps},
    local_defines = COMMON_DEFINES + {defines},
    includes = {includes},
    {all_hdrs}
    copts = {copts},
)
"""


def allowed_define(define):
    if "HAVE_" in define:
        return True
    if "TCL" in define:
        return True
    if "PACKAGE" in define:
        if define.startswith(("PACKAGE_BUGREPORT", "PACKAGE_URL")):
            return False
        return True
    if "USE_" in define:
        return True
    if "CFG_" in define:
        return True
    if "MP_" in define:
        return True
    return False

class Library:

    def __init__(self):
        self.name = DEFAULT_LIBRARY_NAME
        self.defines = []
        self.includes = []
        self.sources = []
        self.deps = []
        self.locked = False

    def to_dict(self) -> dict[str, str | list[str]]:
        return {
            "name": self.name,
            "defines": self.defines,
            "includes": self.includes,
            "sources": self.sources,
            "deps": self.deps,
        }

    def __repr__(self) -> str:
        return json.dumps(self.to_dict(), indent=2)

    def is_unpopulated(self) -> bool:
        return (not self.defines) and (not self.includes) and (not self.sources)

    def to_cc_library(self) -> str:
        is_binary = True if self.name in ["tclsh"] else False
        return CC_TARGET_TPL.format(
            kind="binary" if is_binary else "library",
            name=self.name,
            srcs=json.dumps(self.sources),
            defines=json.dumps([d.replace('"', '\\""') for d in self.defines]),
            includes=json.dumps(self.includes),
            deps=json.dumps(
                sorted(self.deps + ([":cc_all_headers"] if is_binary else []))
            ),
            all_hdrs=("" if is_binary else 'textual_hdrs = [":all_headers"],'),
            copts=json.dumps([]),
        )

    def consume(self, line: str) -> bool:
        if self.locked:
            raise RuntimeError(f"Library {self.name} is locked")

        if line.startswith("ar cr"):
            text, _, _ = line.partition(";")
            matches = ARCHIVE_PATTERN.findall(text)
            if not matches:
                raise ValueError(f"Bad archive name: {text}")
            self.name = matches[0]
            if self.name.startswith("lib"):
                self.name = self.name[len("lib") :]
            return True

        if line.startswith("gcc "):
            try:
                data = shlex.split(line)
            except:
                print(f"BAD: {line}")
                raise

            for group in FRAMEWORK_PATTERN.findall(line):
                self.deps.append(DEP_MAPPING.get(group, group))

            self.deps = sorted(set(self.deps))

            for entry in data:
                regex = INCLUDE_PATTERN.match(entry)
                if regex:
                    _, _, include = regex.group(1).partition("/tcl_lang/")
                    if not include:
                        continue
                    self.includes.append(os.path.normpath(include))
                    self.includes = sorted(set(self.includes))
                    continue

                regex = DEFINE_PATTERN.match(entry)
                if regex:
                    define = regex.group(1)
                    if not allowed_define(define):
                        continue
                    self.defines.append(define)
                    self.defines = sorted(set(self.defines))
                    continue

                regex = DEPENDENCY_PATTERN.match(entry)
                if regex:
                    self.deps.append(DEP_MAPPING.get(regex.group(1), regex.group(1)))
                    self.deps = sorted(set(self.deps))

                if entry in OBJECT_MAP:
                    self.sources.append(OBJECT_MAP[entry])
                    self.sources = sorted(set(self.sources))

                if entry.startswith("/") and entry.endswith(
                    (".c", ".cc", ".cpp", ".h", ".hpp", ".c`")
                ):
                    _, _, path = entry.partition("/tcl_lang/")
                    if not path:
                        raise ValueError(f"Unknown source: {entry}")
                    src = path.strip("`")
                    self.sources.append(SOURCE_MAP.get(src, src))
                    self.sources = sorted(set(self.sources))

            # Look for the output name for non-compile commands
            if " -c " not in line:
                matches = OUTPUT_PATTERN.findall(line)
                if matches:
                    for entry in matches:
                        if entry.endswith(".o"):
                            continue

                        if self.name == DEFAULT_LIBRARY_NAME:
                            self.name = entry

                        if "." not in self.name:
                            continue

                        self.name = entry
                    if self.name.startswith("lib"):
                        self.name = self.name[len("lib") :]
                    return True

        return False

def parse_common_defines(libs: list[Library]):
    common = {}
    for lib in libs:
        if not lib.defines:
            continue
        if not common:
            common = set(lib.defines)
            continue

        common &= set(lib.defines)
    return sorted(common)

def main() -> None:

    log_text = Path(
        "/Users/andrebrisco/Code/tcl_lang/tcl_lang_9.0.1/macos.log"
    ).read_text()

    flat_text = []

    libraries = []
    library = Library()

    for line in log_text.splitlines():

        if line.endswith("\\"):
            flat_text.append(line[:-1])
            continue

        if flat_text:
            flat_text.append(line)
            finished = library.consume(" ".join(flat_text))
            flat_text = []
        else:
            finished = library.consume(line)

        if finished:
            libraries.append(library)
            library = Library()

    if not library.is_unpopulated():
        libraries.append(library)
        library = Library()

    all_defs = []
    for lib in libraries:
        if not all_defs:
            all_defs.extend(lib.defines)
            continue
        if all_defs != lib.defines:
            # print("Not all the same!")
            break

    # for lib in libraries:
    #     print(lib.name)

    all_libs = {lib.name: lib for lib in libraries if lib.name in TOP_TARGETS}
    # print(json.dumps({k: v.to_dict() for k, v in all_libs.items()}, indent=4, sort_keys=True))
    for lib in all_libs.values():
        print(lib.to_cc_library())

    # print(json.dumps(parse_common_defines(all_libs.values()), indent=2))


main()

# %%
