# Reference:
# https://docs.bazel.build/versions/master/skylark/cookbook.html
# NOTE: Could probably have been built using the "master rule"
# pattern instead of a custom rule.

# def _generate_messages_impl(ctx):
#     tmp = ctx.new_file('hello')

#     print(ctx.files.srcs)

#     # Run the code generation script
#     ctx.action(
#         inputs=ctx.files.srcs,
#         outputs=[tmp],
#         executable=ctx.executable._gen_script,
#         arguments=[f.path for f in ctx.files.srcs],
#         progress_message='Generating ROS messages',
#     )

#     # Export python library
#     native.py_library(
#         name='msgs',
#         srcs=[tmp],
#         visibility=['//visibility:public'],
#     )


# generate_messages = rule(
#     implementation=_generate_messages_impl,
#     attrs={
#         'srcs': attr.label_list(allow_files=True),
#         '_gen_script': attr.label(
#             executable=True,
#             cfg='host',
#             allow_files=True,
#             default=Label('@genpy//:genmsg_py'))
#     },
# )

def generate_messages(srcs):
    # Generate python
    s = srcs[0]

    native.genrule(
        name='genpy_2',
        srcs=[s],
        outs=['__init__.py'],
        cmd='$(location @genpy//:genmsg_py) --initpy -p my_pkg -o $(@D) $(location ' + s + ') && tree $(@D)',
        tools=[
            '@genpy//:genmsg_py',
        ],
    )

    native.py_library(
        name='msgs_py',
        srcs=['__init__.py']
    )