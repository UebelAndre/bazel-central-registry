/**
 * @file extract_asm_offsets.cc
 * @brief Extract asm-offsets defines from compiler assembly output.
 *
 * U-Boot's asm-offsets mechanism compiles a C source file to assembly
 * (using @c -S) where macros like @c DEFINE(name,value) expand to
 * lines of the form <tt>->NAME #VALUE</tt>. This tool scans the
 * assembly output for those marker lines and emits a header file
 * containing the corresponding <tt>\#define NAME VALUE</tt> directives.
 *
 * @par Usage
 * @code
 *   extract_asm_offsets <input.s> <output.h>
 * @endcode
 */

#include <cstdio>
#include <cstring>

int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s <input.s> <output.h>\n", argv[0]);
        return 1;
    }

    FILE* in = fopen(argv[1], "r");
    if (!in) {
        perror(argv[1]);
        return 1;
    }

    FILE* out = fopen(argv[2], "w");
    if (!out) {
        perror(argv[2]);
        fclose(in);
        return 1;
    }

    fputs("/* AUTO-GENERATED FILE. DO NOT EDIT. */\n\n", out);

    char line[4096];
    while (fgets(line, sizeof(line), in)) {
        // Match lines containing "->NAME $VALUE" or "->NAME #VALUE"
        const char* arrow = strstr(line, "->");
        if (!arrow) continue;

        const char* name_start = arrow + 2;

        // "->  " or "->" alone emits a blank line separator
        if (*name_start == '\0' || *name_start == '\n' || *name_start == '\r' ||
            *name_start == '"') {
            fputs("\n", out);
            continue;
        }

        while (*name_start == ' ' || *name_start == '\t') name_start++;

        const char* name_end = name_start;
        while (*name_end && *name_end != ' ' && *name_end != '\t') name_end++;
        if (name_end == name_start) continue;

        const char* delim = name_end;
        while (*delim && *delim != '#' && *delim != '$') delim++;
        if (!*delim) continue;
        delim++;

        const char* val_start = delim;
        while (*val_start == ' ') val_start++;

        const char* val_end = val_start;
        while (*val_end && *val_end != ' ' && *val_end != '\t' &&
               *val_end != '\n' && *val_end != '\r' &&
               *val_end != '"') val_end++;

        fprintf(out, "#define %.*s %.*s\n",
                (int)(name_end - name_start), name_start,
                (int)(val_end - val_start), val_start);
    }

    fputs("\n", out);
    fclose(in);
    fclose(out);
    return 0;
}
