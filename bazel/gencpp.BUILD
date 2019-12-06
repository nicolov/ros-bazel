package(default_visibility = ["//visibility:public"])

load("@pypi_deps//:requirements.bzl", "requirement")

py_library(
    name = "gencpp",
    srcs = glob(["src/**/*.py"]),
    imports = ["src"],
    deps = [
        "@genmsg_repo//:genmsg",
    ],
)

py_binary(
    name = "gen_cpp",
    srcs = ["scripts/gen_cpp.py"],
    deps = [
        ":gencpp",
        requirement("empy"),
    ],
)
