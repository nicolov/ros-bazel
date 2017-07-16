# Reference:
# https://docs.bazel.build/versions/master/skylark/cookbook.html
# https://github.com/RobotLocomotion/drake/blob/eefddbee62439156b6faaf3b0cecdd0c57e704d7/tools/lcm.bzl

load('//bazel:path_utils.bzl', 'basename', 'dirname', 'join_paths')


def _genmsg_outs(srcs, ros_package_name, extension):
    """ Given a list of *.msg files, return the generated msg
    files with a given extension. """

    (extension in ['.py', '.h']
        or fail('Unknown extension %s' % extension))

    subdir = dirname(srcs[0])
    msg_names = []
    for item in srcs:
        if dirname(item) != subdir:
            fail('Put all .msg files in the same directory')
        if not item.endswith('.msg'):
            fail('%s does not end in .msg' % item)
        item_name = basename(item)[:-len('.msg')]

        if extension == '.py':
            item_name = '_' + item_name

        msg_names.append(item_name)

    outs = [
        join_paths(subdir, msg_name + extension)
        for msg_name in msg_names
    ]

    return outs


def _genpy_impl(ctx):
    # Shell out to the appropriate code generation script from ROS

    outpath = ctx.outputs.outs[0].dirname

    # Generate __init__.py for msg module
    ctx.action(
        inputs=ctx.files.srcs,
        outputs=ctx.outputs.out_init,
        executable=ctx.executable._gen_script,
        arguments=[
            '--initpy',
            '-o', outpath,
            '-p', ctx.attr.ros_package_name,
        ],
    )

    # Generate the actual messages
    ctx.action(
        inputs=ctx.files.srcs,
        outputs=ctx.outputs.outs,
        executable=ctx.executable._gen_script,
        arguments=[
            '-o', outpath,
            '-p', ctx.attr.ros_package_name,
        ] + [
            f.path for f in ctx.files.srcs
        ],
        progress_message='Generating ROS messages',
    )

    return struct()


_genpy = rule(
    implementation=_genpy_impl,
    output_to_genfiles=True,
    attrs={
        'srcs': attr.label_list(allow_files=True),
        'ros_package_name': attr.string(),
        '_gen_script': attr.label(
            default=Label('@genpy_repo//:genmsg_py'),
            executable=True,
            cfg='host'),
        'outs': attr.output_list(),
        'out_init': attr.output_list(),
    },
)


def generate_messages(srcs=None,
                      ros_package_name=None):
    if not srcs:
        fail('srcs is required (*.msg files).')
    if not ros_package_name:
        fail('ros_package_name is required.')

    outs = _genmsg_outs(srcs, ros_package_name, '.py')
    # TODO: make this nicer
    out_init = [join_paths(dirname(srcs[0]), '__init__.py')]

    print(outs)

    _genpy(
        name='lkfjaklsjfklasd',
        srcs=srcs,
        ros_package_name=ros_package_name,
        outs=outs,
        out_init=out_init,
    )

    native.py_library(
        name='msgs_py',
        srcs=outs + out_init,
    )
