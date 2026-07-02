// text_replace — substitute a fixed prefix on any input line that
// starts with it. Stands in for the `sed 's/^prefix/replacement/'`
// one-liners in gnutls's lib/Makefile.am, without depending on a POSIX
// shell or sed being on the build host.
//
// Usage: text_replace <input> <output> <find> <replace>
//
// For each line: if the line's leading bytes equal <find>, emit
// <replace> then the rest of the line; else emit the line unchanged.
// Reads/writes in binary mode so line endings pass through verbatim.

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

namespace {

int usage(const char* argv0) {
    std::fprintf(stderr, "usage: %s <input> <output> <find> <replace>\n", argv0);
    return 2;
}

void emit(const std::string& line, const char* find, size_t find_len,
          const char* replace, size_t replace_len, std::FILE* out) {
    if (line.size() >= find_len &&
        std::memcmp(line.data(), find, find_len) == 0) {
        std::fwrite(replace, 1, replace_len, out);
        std::fwrite(line.data() + find_len, 1, line.size() - find_len, out);
    } else {
        std::fwrite(line.data(), 1, line.size(), out);
    }
}

}  // namespace

int main(int argc, char** argv) {
    if (argc != 5) return usage(argc > 0 ? argv[0] : "text_replace");
    const char* in_path = argv[1];
    const char* out_path = argv[2];
    const char* find = argv[3];
    const char* replace = argv[4];
    const size_t find_len = std::strlen(find);
    const size_t replace_len = std::strlen(replace);

    std::FILE* in = std::fopen(in_path, "rb");
    if (!in) {
        std::fprintf(stderr, "text_replace: cannot open input %s: %s\n",
                     in_path, std::strerror(errno));
        return 2;
    }
    std::FILE* out = std::fopen(out_path, "wb");
    if (!out) {
        std::fprintf(stderr, "text_replace: cannot open output %s: %s\n",
                     out_path, std::strerror(errno));
        std::fclose(in);
        return 2;
    }

    std::string line;
    line.reserve(4096);
    int c;
    while ((c = std::fgetc(in)) != EOF) {
        line.push_back(static_cast<char>(c));
        if (c == '\n') {
            emit(line, find, find_len, replace, replace_len, out);
            line.clear();
        }
    }
    if (!line.empty()) {
        emit(line, find, find_len, replace, replace_len, out);
    }
    std::fclose(in);
    if (std::fclose(out) != 0) {
        std::fprintf(stderr, "text_replace: error closing %s: %s\n",
                     out_path, std::strerror(errno));
        return 2;
    }
    return 0;
}
