#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

#include "rules_cc/cc/runfiles/runfiles.h"

using rules_cc::cc::runfiles::Runfiles;

static std::string extract_quoted(const std::string& line) {
    auto first = line.find('"');
    if (first == std::string::npos) return "";
    auto last = line.find('"', first + 1);
    if (last == std::string::npos) return "";
    return line.substr(first + 1, last - first - 1);
}

static std::string strip_bcr_suffix(const std::string& version) {
    auto pos = version.find(".bcr");
    if (pos != std::string::npos) return version.substr(0, pos);
    return version;
}

static std::string read_module_version(const std::string& path) {
    std::ifstream f(path);
    std::string line;
    while (std::getline(f, line)) {
        if (line.find("version") != std::string::npos &&
            line.find('"') != std::string::npos &&
            line.find("compatibility") == std::string::npos) {
            return strip_bcr_suffix(extract_quoted(line));
        }
    }
    return "";
}

int main(int argc, char* argv[]) {
    std::string error;
    std::unique_ptr<Runfiles> runfiles(Runfiles::CreateForTest(&error));
    if (!runfiles) {
        std::cerr << "FAIL: could not create runfiles: " << error << std::endl;
        return 1;
    }

    const char* uboot_version = std::getenv("UBOOT_VERSION");
    if (!uboot_version) {
        std::cerr << "FAIL: UBOOT_VERSION env var not set" << std::endl;
        return 1;
    }

    const char* module_rlocation = std::getenv("MODULE_BAZEL");
    if (!module_rlocation) {
        std::cerr << "FAIL: MODULE_BAZEL env var not set" << std::endl;
        return 1;
    }

    std::string module_path = runfiles->Rlocation(module_rlocation);
    if (module_path.empty()) {
        std::cerr << "FAIL: could not resolve runfile: " << module_rlocation
                  << std::endl;
        return 1;
    }

    std::string module_version = read_module_version(module_path);
    if (module_version.empty()) {
        std::cerr << "FAIL: could not find version in " << module_path
                  << std::endl;
        return 1;
    }

    if (std::string(uboot_version) != module_version) {
        std::cerr << "FAIL: UBOOT_VERSION (" << uboot_version
                  << ") != MODULE.bazel version (" << module_version << ")"
                  << std::endl;
        return 1;
    }

    std::cout << "OK: versions match (" << uboot_version << ")" << std::endl;
    return 0;
}
