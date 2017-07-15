# -*- python -*-

# ROS packages built with Bazel

cc_binary(
    name='main',
    srcs=['src/main.cpp'],
    deps=[
        '@ros',
    ],
)

py_binary(
    name='main_python',
    srcs=['src/main_python.py'],
    deps=[
        '@ros//:ros_python',
    ],
)

py_binary(
    name='genmsg_test',
    srcs=['src/genmsg_test.py'],
    deps=[
        '@genmsg',
    ],
)