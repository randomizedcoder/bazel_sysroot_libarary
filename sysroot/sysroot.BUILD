cc_library(
    name = "system_deps",
    srcs = glob(["lib/*.so*"]),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include"],
    linkstatic = 0,
    visibility = ["//visibility:public"],
)

# Separate library for static linking
cc_library(
    name = "system_deps_static",
    srcs = glob(["lib/*.a"]),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)
