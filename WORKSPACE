# -*- python -*-

workspace(name='ros_example')

# Prebuilt ROS workspace

new_local_repository(
    name='ros',
    path='bundle_ws/install',
    build_file='ros.BUILD',
)

# Other catkin packages from source
# TODO: generate this automatically from rosinstall_generator

new_local_repository(
    name='roslz4',
    path='ros_comm/utilities/roslz4',
    build_file='roslz4.BUILD'
)

new_http_archive(
	name='genmsg',
	build_file='bazel/genmsg.BUILD',
	sha256='d7627a2df169e4e8208347d9215e47c723a015b67ef3ed8cda8b61b6cfbf94d2',
	urls = ['https://github.com/ros/genmsg/archive/0.5.8.tar.gz'],
	strip_prefix='genmsg-0.5.8',
)
