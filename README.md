# Build ROS packages using Bazel

[Bazel](http://bazel.build) is the open-source version of Google's internal
build system, featuring fast incremental compiles and remote caching for
distributed builds.

It proved really fast on some of the [benchmarks I
ran](http://nicolovaligi.com/benchmark-bazel-build-cpp.html), so I decided to
try using it to build ROS packages.

## How it works

First, we use `catkin` to build the base set of ROS packages we need for a
simple node (`roscpp`, `rospy`, ..). Then, we can expose the resulting install
space to Bazel using the `new_local_repository` repository rule in the
`WORKSPACE` file. Bazel will then use the `ros.BUILD` file to understand the
contents of the catkin install space. For now, we just declare all `.so` files
as a single prebuilt C++ library, and all the Python code as a single Python
package.

With this setup in place, Bazel-native binaries just need to depend on the C++
and Python libraries in the `@ros` repository. Two simple examples live in the
`src` directory.

## Testing

Install Python dependencies (preferably in a virtualenv):

    pip install -r requirements.txt

Download and compile the ROS workspace using `catkin`:

    ./compile_ros_workspace.py

Build the Bazel workspace:

    bazel build //... -s
