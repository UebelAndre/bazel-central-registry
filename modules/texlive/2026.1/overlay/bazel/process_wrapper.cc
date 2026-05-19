/// @file process_wrapper.cc
/// @brief Process wrapper for TeX Live build tools.
///
/// Provides hermetic tool execution with environment control, directory
/// changes, stdin/stdout redirection — replacing shell scripts for
/// portability across Unix and Windows.
///
/// @par Usage
/// @code
///   process_wrapper [OPTIONS] -- COMMAND [ARGS...]
/// @endcode
///
/// @par Options
///   - `--chdir DIR`     Change to DIR before running the command.
///   - `--env KEY=VALUE` Set an environment variable (repeatable).
///   - `--cat FILE`      Feed FILE to the command's stdin (repeatable;
///                        files are concatenated in order).
///   - `--stdout FILE`   Redirect the command's stdout to FILE.
///
/// If `--chdir` is given, all arguments after `--` that are existing
/// relative paths are resolved to absolute before changing directory.
/// Environment variable values that are existing relative paths are
/// also resolved.

#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#include <process.h>
#else
#include <sys/wait.h>
#include <unistd.h>
#endif

namespace fs = std::filesystem;

/// Resolve @p path to an absolute path if it exists as a relative path.
///
/// Paths that are already absolute, empty, or start with `-` are
/// returned unchanged. On Windows, drive-letter paths (e.g. `C:\...`)
/// are also left alone.
///
/// @param path The path to resolve.
/// @return The absolute path if the file exists, otherwise @p path unchanged.
static std::string resolve_if_exists(const std::string& path) {
    if (path.empty() || path[0] == '/' || path[0] == '-') return path;
#ifdef _WIN32
    if (path.size() > 1 && path[1] == ':') return path;
#endif
    std::error_code ec;
    fs::path abs = fs::absolute(path, ec);
    if (!ec && fs::exists(abs, ec)) return abs.string();
    return path;
}

/// Set an environment variable portably.
///
/// @param key   Variable name.
/// @param value Variable value.
static void set_env(const std::string& key, const std::string& value) {
#ifdef _WIN32
    _putenv_s(key.c_str(), value.c_str());
#else
    setenv(key.c_str(), value.c_str(), 1);
#endif
}

int main(int argc, char* argv[]) {
    std::string chdir_path;
    std::string stdout_file;
    std::vector<std::pair<std::string, std::string>> env_vars;
    std::vector<std::string> cat_files;
    int cmd_start = -1;

    for (int i = 1; i < argc; i++) {
        if (std::strcmp(argv[i], "--") == 0) {
            cmd_start = i + 1;
            break;
        }
        if (std::strcmp(argv[i], "--chdir") == 0 && i + 1 < argc) {
            chdir_path = argv[++i];
        } else if (std::strcmp(argv[i], "--env") == 0 && i + 1 < argc) {
            std::string kv = argv[++i];
            std::string::size_type eq = kv.find('=');
            if (eq != std::string::npos) {
                env_vars.emplace_back(kv.substr(0, eq), kv.substr(eq + 1));
            }
        } else if (std::strcmp(argv[i], "--cat") == 0 && i + 1 < argc) {
            cat_files.push_back(argv[++i]);
        } else if (std::strcmp(argv[i], "--stdout") == 0 && i + 1 < argc) {
            stdout_file = argv[++i];
        }
    }

    if (cmd_start < 0 || cmd_start >= argc) {
        std::cerr << "process_wrapper: no command after --\n";
        return 1;
    }

    bool will_chdir = !chdir_path.empty();

    // Resolve env values to absolute paths before chdir.
    for (std::pair<std::string, std::string>& kv : env_vars) {
        if (will_chdir) kv.second = resolve_if_exists(kv.second);
        set_env(kv.first, kv.second);
    }

    // Resolve --cat files to absolute paths before chdir.
    if (will_chdir) {
        for (std::string& f : cat_files) f = resolve_if_exists(f);
    }

    // Resolve --stdout to absolute. It is an output file so its parent
    // directory may not yet exist — resolve just the parent.
    if (!stdout_file.empty() && will_chdir) {
        fs::path parent = fs::path(stdout_file).parent_path();
        fs::path name = fs::path(stdout_file).filename();
        std::error_code ec;
        fs::path abs_parent = fs::absolute(parent, ec);
        if (!ec) stdout_file = (abs_parent / name).string();
    }

    // Resolve command and arguments to absolute paths before chdir.
    std::vector<std::string> args;
    for (int i = cmd_start; i < argc; i++) {
        std::string arg = argv[i];
        if (will_chdir) arg = resolve_if_exists(arg);
        args.push_back(arg);
    }

    // Create and change to the target directory.
    if (will_chdir) {
        std::error_code ec;
        fs::create_directories(chdir_path, ec);
        fs::current_path(chdir_path, ec);
        if (ec) {
            std::cerr << "process_wrapper: chdir " << chdir_path
                      << ": " << ec.message() << "\n";
            return 1;
        }
    }

    // Feed --cat files to stdin via a pipe (Unix) or temp file (Windows).
    if (!cat_files.empty()) {
#ifndef _WIN32
        int pipefd[2];
        if (pipe(pipefd) != 0) {
            std::cerr << "process_wrapper: pipe: " << std::strerror(errno) << "\n";
            return 1;
        }
        pid_t pid = fork();
        if (pid == 0) {
            close(pipefd[0]);
            for (const std::string& f : cat_files) {
                std::ifstream in(f, std::ios::binary);
                if (!in) {
                    std::cerr << "process_wrapper: cat: " << f
                              << ": " << std::strerror(errno) << "\n";
                    _exit(1);
                }
                char buf[8192];
                while (in.read(buf, sizeof(buf)) || in.gcount() > 0) {
                    std::streamsize n = in.gcount();
                    if (write(pipefd[1], buf, n) != n) _exit(1);
                }
            }
            close(pipefd[1]);
            _exit(0);
        }
        close(pipefd[1]);
        dup2(pipefd[0], STDIN_FILENO);
        close(pipefd[0]);
#else
        fs::path tmp = fs::temp_directory_path() / "pw_cat.tmp";
        {
            std::ofstream out(tmp, std::ios::binary);
            for (const std::string& f : cat_files) {
                std::ifstream in(f, std::ios::binary);
                out << in.rdbuf();
            }
        }
        FILE* fin = freopen(tmp.string().c_str(), "rb", stdin);
        if (!fin) {
            std::cerr << "process_wrapper: freopen stdin: "
                      << std::strerror(errno) << "\n";
            return 1;
        }
#endif
    }

    // Redirect stdout to file.
    if (!stdout_file.empty()) {
        FILE* fout = freopen(stdout_file.c_str(), "w", stdout);
        if (!fout) {
            std::cerr << "process_wrapper: freopen stdout " << stdout_file
                      << ": " << std::strerror(errno) << "\n";
            return 1;
        }
    }

    // Build argv for exec.
    std::vector<char*> exec_argv;
    for (std::string& a : args) {
        exec_argv.push_back(a.data());
    }
    exec_argv.push_back(nullptr);

#ifdef _WIN32
    int rc = _spawnvp(_P_WAIT, exec_argv[0], exec_argv.data());
    if (!cat_files.empty()) {
        fs::path tmp = fs::temp_directory_path() / "pw_cat.tmp";
        fs::remove(tmp);
    }
    return rc;
#else
    execvp(exec_argv[0], exec_argv.data());
    std::cerr << "process_wrapper: exec " << exec_argv[0]
              << ": " << std::strerror(errno) << "\n";
    return 1;
#endif
}
