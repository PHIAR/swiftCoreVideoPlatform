#pragma once

#define NONNULL_BEGIN _Pragma ("clang assume_nonnull begin")
#define NONNULL_END _Pragma ("clang assume_nonnull end")

#define BEGIN_ENUM(type, name) typedef enum __attribute__((enum_extensibility(closed))) name
#define END_ENUM(name) name

#ifdef __cplusplus
    #define BEGIN_DECLS extern "C" {
    #define END_DECLS }
#else
    #define BEGIN_DECLS
    #define END_DECLS
#endif

#define EXPORT_SYMBOL __attribute__ ((visibility ("default")))
#define NULLABLE_RETURN _Nullable
#define NONNULL_RETURN _Nonnull
#define NULLABLE_SYMBOL _Nullable
#define NONNULL_SYMBOL _Nonnull
