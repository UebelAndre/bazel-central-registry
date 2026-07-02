// stdout_to_file — spawn a subprocess and write its standard output to
// a named file. Substitutes for the shell redirect `cmd > file`, which
// isn't expressible via ctx.actions.run.
//
// Usage: stdout_to_file <output_path> <executable> [args...]
//
// Portable across POSIX (fork+dup2+execvp) and Windows (CreateProcess
// with STARTF_USESTDHANDLES). Produces the same file bytes on both.

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <fcntl.h>
#include <sys/wait.h>
#include <unistd.h>
#endif

namespace {

int usage(const char* argv0) {
    std::fprintf(stderr, "usage: %s <output> <executable> [args...]\n", argv0);
    return 2;
}

#ifdef _WIN32

// Build a Windows command line from argv per the CommandLineToArgvW rules
// (backslash-escape internal quotes, wrap in quotes when needed).
std::string quote_arg(const char* arg) {
    bool needs_quote = *arg == '\0';
    for (const char* p = arg; *p; ++p) {
        if (*p == ' ' || *p == '\t' || *p == '"') {
            needs_quote = true;
            break;
        }
    }
    if (!needs_quote) return std::string(arg);
    std::string out;
    out.push_back('"');
    for (const char* p = arg; *p; ++p) {
        // Count consecutive backslashes preceding a `"` or end-of-string.
        size_t bs = 0;
        while (*p == '\\') { ++bs; ++p; }
        if (*p == '\0') {
            out.append(bs * 2, '\\');
            break;
        } else if (*p == '"') {
            out.append(bs * 2 + 1, '\\');
            out.push_back('"');
        } else {
            out.append(bs, '\\');
            out.push_back(*p);
        }
    }
    out.push_back('"');
    return out;
}

int run(int argc, char** argv) {
    const char* out_path = argv[1];
    HANDLE hOut = CreateFileA(
        out_path,
        GENERIC_WRITE,
        FILE_SHARE_READ,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        NULL);
    if (hOut == INVALID_HANDLE_VALUE) {
        std::fprintf(stderr, "stdout_to_file: CreateFileA(%s) failed: %lu\n",
                     out_path, (unsigned long)GetLastError());
        return 2;
    }
    if (!SetHandleInformation(hOut, HANDLE_FLAG_INHERIT, HANDLE_FLAG_INHERIT)) {
        std::fprintf(stderr, "stdout_to_file: SetHandleInformation failed: %lu\n",
                     (unsigned long)GetLastError());
        CloseHandle(hOut);
        return 2;
    }

    STARTUPINFOA si;
    std::memset(&si, 0, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = hOut;
    si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);

    std::string cmdline;
    for (int i = 2; i < argc; ++i) {
        if (!cmdline.empty()) cmdline.push_back(' ');
        cmdline += quote_arg(argv[i]);
    }

    PROCESS_INFORMATION pi;
    std::memset(&pi, 0, sizeof(pi));
    if (!CreateProcessA(
            argv[2],
            const_cast<char*>(cmdline.c_str()),
            NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        std::fprintf(stderr, "stdout_to_file: CreateProcessA(%s) failed: %lu\n",
                     argv[2], (unsigned long)GetLastError());
        CloseHandle(hOut);
        return 2;
    }
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD exit_code = 0;
    GetExitCodeProcess(pi.hProcess, &exit_code);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    CloseHandle(hOut);
    return static_cast<int>(exit_code);
}

#else

int run(int argc, char** argv) {
    const char* out_path = argv[1];
    int fd = open(out_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) {
        std::fprintf(stderr, "stdout_to_file: open(%s) failed: %s\n",
                     out_path, std::strerror(errno));
        return 2;
    }
    pid_t pid = fork();
    if (pid < 0) {
        std::fprintf(stderr, "stdout_to_file: fork failed: %s\n",
                     std::strerror(errno));
        close(fd);
        return 2;
    }
    if (pid == 0) {
        if (dup2(fd, STDOUT_FILENO) < 0) {
            std::fprintf(stderr, "stdout_to_file: dup2 failed: %s\n",
                         std::strerror(errno));
            _exit(127);
        }
        close(fd);
        execvp(argv[2], argv + 2);
        std::fprintf(stderr, "stdout_to_file: execvp(%s) failed: %s\n",
                     argv[2], std::strerror(errno));
        _exit(127);
    }
    close(fd);
    int status = 0;
    if (waitpid(pid, &status, 0) < 0) {
        std::fprintf(stderr, "stdout_to_file: waitpid failed: %s\n",
                     std::strerror(errno));
        return 2;
    }
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return 1;
}

#endif

}  // namespace

int main(int argc, char** argv) {
    if (argc < 3) return usage(argc > 0 ? argv[0] : "stdout_to_file");
    return run(argc, argv);
}
