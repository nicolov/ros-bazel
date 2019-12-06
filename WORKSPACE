# -*- python -*-
workspace(name = "ros_example")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Pip requirements
git_repository(
    name = "rules_python",
    commit = "38f86fb55b698c51e8510c807489c9f4e047480e",
    remote = "https://github.com/bazelbuild/rules_python.git",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

load("@rules_python//python:pip.bzl", "pip_repositories")

pip_repositories()

load("@rules_python//python:pip.bzl", "pip3_import")

# Create a central repo that knows about the dependencies needed for
# requirements.txt.
pip3_import(
    name = "pypi_deps",
    requirements = "//:requirements.txt",
)

# Load the central repo's install function from its `//:requirements.bzl` file,
# and call it.
load("@pypi_deps//:requirements.bzl", "pip_install")

pip_install()

# Prebuilt ROS workspace

new_local_repository(
    name = "ros",
    build_file = "ros.BUILD",
    path = "bundle_ws/install",
)

# Other catkin packages from source
# TODO: generate this automatically from rosinstall_generator

new_local_repository(
    name = "roslz4",
    build_file = "roslz4.BUILD",
    path = "ros_comm/utilities/roslz4",
)

http_archive(
    name = "genmsg_repo",
    build_file = "@//bazel:genmsg.BUILD",
    sha256 = "d7627a2df169e4e8208347d9215e47c723a015b67ef3ed8cda8b61b6cfbf94d2",
    strip_prefix = "genmsg-0.5.8",
    urls = ["https://github.com/ros/genmsg/archive/0.5.8.tar.gz"],
)

http_archive(
    name = "genpy_repo",
    build_file = "@//bazel:genpy.BUILD",
    sha256 = "35e5cd2032f52a1f77190df5c31c02134dc460bfeda3f28b5a860a95309342b9",
    strip_prefix = "genpy-0.6.5",
    urls = ["https://github.com/ros/genpy/archive/0.6.5.tar.gz"],
)

http_archive(
    name = "gencpp_repo",
    build_file = "@//bazel:gencpp.BUILD",
    sha256 = "1340928931d873e2d43801b663a4a8d87402b88173adb01e21e58037d490fda5",
    strip_prefix = "gencpp-0.5.5",
    urls = ["https://github.com/ros/gencpp/archive/0.5.5.tar.gz"],
)
