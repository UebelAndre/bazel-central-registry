/* stubs_unicode.c — minimal replacements for lib/str-iconv.c,
 * lib/str-idna.c, and lib/str-unicode.c. Those files pull in
 * libunistring for Unicode NFKC/IDNA on SNI hostnames + password
 * normalization; the bundled lib/unistring/ tree in the tarball is
 * ~84 .c files with gnulib .in.h templates that this port has not
 * yet handled.
 *
 * These stubs keep the symbols linkable so libgnutls builds. ASCII
 * inputs pass through as-is; the runtime behaviour on non-ASCII
 * hostnames or passwords is a byte-identity copy rather than the
 * proper NFC/NFKC/IDNA transform. Follow-up: create a libunistring
 * BCR module and remove this file plus put the three real source
 * files back into srcs.
 */

#include <config.h>
#include <gnutls/gnutls.h>
#include <string.h>

int _gnutls_ucs2_to_utf8(const void *data, size_t size,
                         gnutls_datum_t *output, unsigned be) {
    (void)data;
    (void)size;
    (void)output;
    (void)be;
    return GNUTLS_E_UNIMPLEMENTED_FEATURE;
}

int _gnutls_utf8_to_ucs2(const void *data, size_t size,
                         gnutls_datum_t *output) {
    (void)data;
    (void)size;
    (void)output;
    return GNUTLS_E_UNIMPLEMENTED_FEATURE;
}

int _gnutls_idna_email_map(const char *input, unsigned ilen,
                           gnutls_datum_t *output) {
    (void)ilen;
    size_t n = strlen(input);
    output->data = gnutls_malloc(n + 1);
    if (!output->data) return GNUTLS_E_MEMORY_ERROR;
    memcpy(output->data, input, n + 1);
    output->size = (unsigned)n;
    return 0;
}

int _gnutls_idna_email_reverse_map(const char *input, unsigned ilen,
                                   gnutls_datum_t *output) {
    return _gnutls_idna_email_map(input, ilen, output);
}

int gnutls_idna_map(const char *input, unsigned ilen,
                    gnutls_datum_t *out, unsigned flags) {
    (void)flags;
    return _gnutls_idna_email_map(input, ilen, out);
}

int gnutls_idna_reverse_map(const char *input, unsigned ilen,
                            gnutls_datum_t *out, unsigned flags) {
    (void)flags;
    return _gnutls_idna_email_map(input, ilen, out);
}

int gnutls_utf8_password_normalize(const unsigned char *password, unsigned plen,
                                   gnutls_datum_t *out, unsigned flags) {
    (void)flags;
    out->data = gnutls_malloc(plen + 1);
    if (!out->data) return GNUTLS_E_MEMORY_ERROR;
    memcpy(out->data, password, plen);
    out->data[plen] = 0;
    out->size = plen;
    return 0;
}
