# -*- python -*-
workspace(name = "ros_example")

load("//bazel:repository_rules.bzl", "import_ros_workspace")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

import_ros_workspace(
    name = "ros_ws",
    path = "/opt/ros/melodic",
)

load("@ros_ws//:workspace.bzl", "ros_repositories")

ros_repositories()

# Packages needed for code generation that we want to import from source.

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
