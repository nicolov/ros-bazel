#!/usr/bin/env bash

set -e

PACKAGES="roscpp rospy"

rm -rf bundle_ws
mkdir bundle_ws
pushd bundle_ws

rosinstall_generator \
    --deps \
    --tar \
    --flat \
    --rosdistro melodic \
    $PACKAGES > ws.rosinstall
wstool init -j8 src ws.rosinstall

catkin config \
    --install \
    --source-space src \
    --build-space build \
    --devel-space devel \
    --log-space log \
    --install-space install \
    --isolate-devel \
    --no-extend

catkin build
