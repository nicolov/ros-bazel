FROM ubuntu:trusty
ENV DEBIAN_FRONTEND noninteractive

# Python
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python2.7 \
        python-pip

COPY requirements.txt /src/requirements.txt
RUN pip install -r /src/requirements.txt

# Development
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        vim

# Bazel
RUN apt-get install -y --no-install-recommends \
        software-properties-common \
    && apt-add-repository ppa:webupd8team/java --yes \
    && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections \
    && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        oracle-java8-installer \
    && apt-get install -y --no-install-recommends \
        bazel \
    && bazel --batch version

# ROS dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libconsole-bridge-dev \
        libtinyxml-dev
