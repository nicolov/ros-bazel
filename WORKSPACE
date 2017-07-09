# -*- python -*-

workspace(name='ros')

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