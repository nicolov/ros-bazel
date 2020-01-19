# Build ROS packages using Bazel

[Bazel](http://bazel.build) is the open-source version of Google's internal
build system, featuring fast incremental compiles and remote caching for
distributed builds.

It proved really fast on some of the [benchmarks I
ran](http://nicolovaligi.com/benchmark-bazel-build-cpp.html), so I decided to
try using it to build ROS packages.

Since converting the whole ROS build to Bazel is quite a lot of work (albeit
highly recommended for larger teams), this project takes a different route
and imports a prebuilt ROS environment (likely installed using apt and the
default instructions). This gets you the best of both worlds: your code builds
and tests using Bazel, and there's no overhead in maintaining Bazel builds of
the whole ROS ecosystem.

It's even possible to import other catkin packages outside of the default
ROS binary distribution.

# Status

[x] Import C++ libraries like `roscpp`, etc..
[x] Code generation for messages, both C++ and Python
[x] Depend on Bazel-generated messages
[x] Bazel caching and sandboxing ready
[ ] ROS Python libraries are not imported into Bazel. Python is generally quite messy in Bazel anyhow.
[ ] Integration with `rospack`, `roslaunch`, and generally anything that crawls the
    filesystem at runtime. Bazel-built binaries will probably just not be found by such tools.
[ ] Actions, services, `dynamic_reconfigure` and probably other less-known message-based stuff.

This code is not supported in any way, and probably not recommended for
production use.  I just wanted to see if there was an easier way to onboard ROS
teams to Bazel without having to maintain a whole separate build system for
ROS.

## Try it out

Get a shell in the docker environment:

    docker-compose build && docker-compose run bazeler bash

Start a talker node with custom messages:

    bazel run //src/talker

## How it works

It uses a Bazel [repository
rule](https://docs.bazel.build/versions/master/skylark/repository_rules.html)
to parse the ROS installation under `/opt/ros/melodic` and produce Bazel BUILD
files and repositories. For example, `roscpp` becomes a `@roscpp` Bazel target
that add the correct link and compile flags.
