def _import_ros_workspace_impl(repo_ctx):
    repo_ctx.file("BUILD", "")

    # Generate top-level workspace.bzl file and build files for all ROS packages
    # in the workspace.
    res = repo_ctx.execute([
        repo_ctx.path(repo_ctx.attr._gen_ros_workspace),
        "--ws-name",
        "ros_ws",
        "--ros-path",
        repo_ctx.attr.path,
        "--out-dir",
        repo_ctx.path(""),
    ])

    if res.return_code:
        fail("failed to generate ROS workspace at {}: {} ({})".format(
            repo_ctx.attr.path,
            res.stdout,
            res.stderr,
        ))

import_ros_workspace = repository_rule(
    attrs = {
        "path": attr.string(mandatory = True),
        "_gen_ros_workspace": attr.label(
            executable = True,
            default = Label("@//bazel:gen_ros_workspace_bzl.py"),
            cfg = "host",
        ),
    },
    implementation = _import_ros_workspace_impl,
)
