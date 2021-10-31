#!/bin/bash
#
echo -e 'nameserver 114.114.114.114' > /etc/resolv.conf
cp sources_16.04.list /etc/apt/sources.list
#add-apt-repository ppa:jonathonf/python-3.7
DEBIAN_FRONTEND=noninteractive
rm -rf /var/lib/apt/lists/* \
    && mkdir /var/lib/apt/lists/partial \
    && apt-get clean \
    && apt-get update --fix-missing \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl git wget vim build-essential cmake make \
        libopencv-dev libcurl4-openssl-dev \
        libgoogle-glog-dev \
        openssh-server librdkafka-dev\
        libsdl2-dev  \
        lcov  \
        ca-certificates \
        net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo -e "\033[0;32m[apt install... Done] \033[0m"
