load("@//bazel:message_generation.bzl", "generate_messages")

generate_messages(
    srcs = glob([
        "msg/*.msg",
    ]),
    ros_package_name = "other_msgs",
    deps = [
        "//src/hello_msgs:msgs",
        "@std_msgs//:msgs",
    ],
)
