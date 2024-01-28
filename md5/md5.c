#include <janet.h>

/***************/
/* C Functions */
/***************/

JANET_FN(cfun_test,
        "(md5/test)",
        "return true") {
    janet_fixarity(argc, 0);
    return janet_wrap_boolean(1);
}

/****************/
/* Module Entry */
/****************/

JANET_MODULE_ENTRY(JanetTable *env) {
    JanetRegExt cfuns[] = {
        JANET_REG("test", cfun_test),
        JANET_REG_END
    };
    janet_cfuns_ext(env, "md5", cfuns);
}
