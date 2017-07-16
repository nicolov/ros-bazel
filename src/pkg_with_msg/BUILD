load('//bazel:message_generation.bzl', 'generate_messages')

# Implicitly creates a msgs_py target in the current scope
generate_messages(
    srcs=glob(['msg/Message1.msg']),
    ros_package_name='pkg_with_msg',
)

py_binary(
    name='main',
    srcs=['scripts/main.py'],
    deps=[
        ':msgs_py',
    ],
)
