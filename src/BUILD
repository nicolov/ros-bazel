cc_binary(
    name = "talker",
    srcs = [
        "talker.cpp",
    ],
    deps = [
        "//src/other_msgs:msgs_cc",
        "@roscpp",
    ],
)

py_binary(
    name = "listener",
    srcs = [
        "listener.py",
    ],
    deps = [
        "//src/other_msgs:msgs_py",
    ],
)
