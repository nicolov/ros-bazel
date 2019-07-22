FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive

# Development
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        vim

# Python
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python \
        unzip \
        zip

# Pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && python /tmp/get-pip.py

COPY requirements.txt /src/requirements.txt
RUN pip install -r /src/requirements.txt

# Bazel
RUN curl -L -o /tmp/bazel-installer https://github.com/bazelbuild/bazel/releases/download/0.28.0/bazel-0.28.0-installer-linux-x86_64.sh \
    && chmod +x /tmp/bazel-installer \
    && /tmp/bazel-installer \
    && rm /tmp/bazel-installer \
    && bazel --batch version

# ROS dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libconsole-bridge-dev \
        liblog4cxx-dev \
        libgtest-dev \
        libtinyxml-dev \
        libtinyxml2-dev
