load("@//bazel:message_generation.bzl", "generate_messages")

generate_messages(
    srcs = glob([
        "msg/*.msg",
    ]),
    ros_package_name = "hello_msgs",
    deps = [
        "@std_msgs//:msgs",
    ],
)
