# Reference:
# https://docs.bazel.build/versions/master/skylark/cookbook.html
# https://github.com/RobotLocomotion/drake/blob/eefddbee62439156b6faaf3b0cecdd0c57e704d7/tools/lcm.bzl

load("//bazel:path_utils.bzl", "basename", "dirname", "join_paths")

def _genmsg_outs(srcs, ros_package_name, extension):
    """ Given a list of *.msg files, return the expected paths
    to the generated code with that extension. """

    (extension in [".py", ".h"] or
     fail("Unknown extension %s" % extension))

    msg_names = []
    for item in srcs:
        if not item.endswith(".msg"):
            fail("%s does not end in .msg" % item)
        item_name = basename(item)[:-len(".msg")]

        if extension == ".py":
            item_name = "_" + item_name

        msg_names.append(item_name)

    msgs_dir = ""
    if extension == ".py":
        msgs_dir = "msg"

    outs = [
        join_paths(ros_package_name, msgs_dir, msg_name + extension)
        for msg_name in msg_names
    ]

    if extension == ".py":
        outs += [
            join_paths(ros_package_name, "msg", "__init__.py"),
            join_paths(ros_package_name, "__init__.py"),
        ]

    return outs

def _genpy_impl(ctx):
    """Implementation for the genpy rule. Shells out to the scripts
    shipped with genpy."""

    srcpath = ctx.files.srcs[0].dirname
    outpath = ctx.outputs.outs[0].dirname

    # Generate __init__.py for package
    ctx.actions.write(
        output = ctx.outputs.outs[-1],
        content = "",
    )

    # Generate the actual messages
    ctx.actions.run(
        inputs = ctx.files.srcs,
        outputs = ctx.outputs.outs[:-2],
        executable = ctx.executable._gen_script,
        arguments = [
            "-o",
            outpath,
            "-p",
            ctx.attr.ros_package_name,
            # Include path for the current package
            "-I",
            "%s:%s" % (ctx.attr.ros_package_name, srcpath),
            # TODO: include paths of dependent packages
        ] + [
            f.path
            for f in ctx.files.srcs
        ],
    )

    # Generate __init__.py for msg module
    # NOTE: it looks at the .py files in its output path, so it also
    # needs to depend on the previous step.
    ctx.actions.run(
        inputs = ctx.files.srcs + ctx.outputs.outs[:-2],
        outputs = [ctx.outputs.outs[-2]],
        executable = ctx.executable._gen_script,
        arguments = [
            "--initpy",
            "-o",
            outpath,
            "-p",
            ctx.attr.ros_package_name,
        ],
    )

    return struct()

_genpy = rule(
    implementation = _genpy_impl,
    output_to_genfiles = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "ros_package_name": attr.string(),
        "_gen_script": attr.label(
            default = Label("@genpy_repo//:genmsg_py"),
            executable = True,
            cfg = "host",
        ),
        "outs": attr.output_list(),
    },
)

def _gencpp_impl(ctx):
    """Implementation for the gencpp rule. Shells out to the sripts
    shipped with gencpp"""
    srcpath = ctx.files.srcs[0].dirname
    outpath = ctx.outputs.outs[0].dirname

    # TODO: deleteme
    print("SRCPATH is:" + srcpath)
    print("ctx.attr.ros_package_name: " + ctx.attr.ros_package_name)

    # Generate the actual messages
    for i in range(0, len(ctx.files.srcs)):
        msg_file = ctx.files.srcs[i]
        msg_header_out = ctx.outputs.outs[i]

        ctx.actions.run(
            # We include all the src's here in case there
            # are messages that depend on each other
            inputs = ctx.files.srcs,
            outputs = [msg_header_out],
            executable = ctx.executable._gen_script,
            arguments = [
                "-o",
                outpath,
                "-p",
                ctx.attr.ros_package_name,
                # Include path for the current package
                "-I",
                "%s:%s" % (ctx.attr.ros_package_name, srcpath),
                # TODO: include paths of dependent packages
                msg_file.path,
            ],
        )

    return struct()

_gencpp = rule(
    implementation = _gencpp_impl,
    output_to_genfiles = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "ros_package_name": attr.string(),
        "_gen_script": attr.label(
            default = Label("@gencpp_repo//:gen_cpp"),
            executable = True,
            cfg = "host",
        ),
        "outs": attr.output_list(),
    },
)

def generate_messages(
        srcs = None,
        ros_package_name = None):
    """ Wraps all message generation functionality. Uses the _genpy
    and _gencpp to shell out to the code generation scripts, then wraps
    the resulting files into Python and C++ libraries.
    We use macros to hide some of the book-keeping of input & output
    files. """

    if not srcs:
        fail("srcs is required (*.msg files).")
    if not ros_package_name:
        fail("ros_package_name is required.")

    genpy_outs = _genmsg_outs(srcs, ros_package_name, ".py")
    gencpp_outs = _genmsg_outs(srcs, ros_package_name, ".h")

    _genpy(
        name = "lkfjaklsjfklasd",
        srcs = srcs,
        ros_package_name = ros_package_name,
        outs = genpy_outs,
    )

    native.py_library(
        name = "msgs_py",
        srcs = genpy_outs,
        imports = ["."],
        deps = [
            "@genpy_repo//:genpy",
        ],
    )

    _gencpp(
        name = "kldajfaowijdafdvgqwe",
        srcs = srcs,
        ros_package_name = ros_package_name,
        outs = gencpp_outs,
    )

    print("OUTS: ")
    for out in gencpp_outs:
        print(out)
    print("INs: ")
    for out in srcs:
        print(out)

    native.cc_library(
        name = "msgs_cc",
        hdrs = gencpp_outs,
        includes = ["."],
    )
