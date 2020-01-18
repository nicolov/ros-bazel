load('//bazel:message_generation.bzl', 'generate_messages')

# Implicitly creates msgs_py and msg_cc targets in the current scope
generate_messages(
    srcs=glob(['msg/*.msg']),
    ros_package_name='test_msgs',
)

py_binary(
    name = "main_py",
    srcs = ["scripts/main.py"],
    main = "scripts/main.py",
    deps = [
        ":msgs_py",
    ],
)

cc_binary(
    name = "main_cc",
    srcs = ["src/main.cpp"],
    deps = [
        ":msgs_cc",
        "@ros",
    ],
)
