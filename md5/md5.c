#include <janet.h>

/***************/
/* C Functions */
/***************/
#include <janet.h>
#include <openssl/evp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE_HASH 32

static Janet md5checksum(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 2);

    const uint8_t *password = janet_getstring(argv, 0);
    const uint8_t *hash_md5 = janet_getstring(argv, 1);

    unsigned char pswd_md5[16] = {0};
    unsigned char hash_digest[SIZE_HASH] = {0};
    EVP_MD_CTX *context = EVP_MD_CTX_new();

    if (!context) {
        return janet_cstringv("Error creating context");
    }

    if (!EVP_DigestInit(context, EVP_md5())) {
        EVP_MD_CTX_free(context);
        return janet_cstringv("Error initializing the hash");
    }

    if (!EVP_DigestUpdate(context, password, strlen((const char *)password))) {
        EVP_MD_CTX_free(context);
        return janet_cstringv("Error calculating MD5 hash");
    }

    if (!EVP_DigestFinal(context, pswd_md5, NULL)) {
        EVP_MD_CTX_free(context);
        return janet_cstringv("Error saving the MD5 hash");
    }

    EVP_MD_CTX_free(context);

    char *hash_md5_calculated = (char*)hash_digest;
    for (int i = 0; i < 16; i++) {
        hash_md5_calculated += sprintf(hash_md5_calculated, "%02x", pswd_md5[i]);
    }

    if (!strncmp((char*)hash_md5, (char*)hash_digest, SIZE_HASH)) {
        return janet_wrap_true();
    }
    return janet_wrap_false();
}

/****************/
/* Module Entry */
/****************/

static const JanetReg cfuns[] = {
    {"md5checksum", md5checksum, "(md5/md5checksum password hash)\n\nCalculates MD5 hash and checks for a match."},
    {NULL, NULL, NULL}
};


JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "md5", cfuns);
}
