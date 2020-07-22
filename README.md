# CNStream Docker Images #

Build docker images for [CNStream](https://github.com/Cambricon/CNStream).

## Directory tree ##

```bash
.
├── build-cnstream-image.sh
├── Dockerfile.16.04
├── load-cnstream-image-v1.4.sh
├── rm-all-docker-container.sh
└── run-cnstream-container-v1.4.sh
```

## Build ##

```bash
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$ ./build-cnstream-image.sh
Cloning into 'cnstream'...
remote: Enumerating objects: 271, done.
remote: Counting objects: 100% (271/271), done.
remote: Compressing objects: 100% (206/206), done.
remote: Total 4208 (delta 105), reused 154 (delta 59), pack-reused 3937
Receiving objects: 100% (4208/4208), 176.91 MiB | 324.00 KiB/s, done.
Resolving deltas: 100% (2132/2132), done.
Checking connectivity... done.
File(neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb): Not exist!
Copy your neuware package(neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb) into the directory of CNStream!
eg:cp -v /data/ftp/v1.4.0/neuware/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb ./cnstream
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$ cp -v /data/ftp/v1.4.0/neuware/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb ./cnstream
'/data/ftp/v1.4.0/neuware/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb' -> './cnstream/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb'
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$ ./build-cnstream-image.sh
Directory(cnstream): Exists!
File(neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb): Exists!
====================== build image ======================
Sending build context to Docker daemon  137.3MB
Step 1/11 : FROM ubuntu:16.04
16.04: Pulling from library/ubuntu
6aa38bd67045: Already exists
981ae4862c05: Already exists
5bad8949dcb1: Already exists
ca9461589e70: Already exists
Digest: sha256:69bc24edd22c270431d1a9e6dbf57cfc4a77b2da199462d0251b145fdd7fa538
Status: Downloaded newer image for ubuntu:16.04
 ---> c522ac0d6194
Step 2/11 : MAINTAINER <Cambricon, Inc.>
 ---> Running in 79adcf3cef42
Removing intermediate container 79adcf3cef42
 ---> b00336dc9e2e
Step 3/11 : WORKDIR /root/CNStream/
 ---> Running in 22ba062a2566
Removing intermediate container 22ba062a2566
 ---> b3dc3724e087
Step 4/11 : ARG neuware_package=neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb
 ---> Running in 67b28422fdd2
Removing intermediate container 67b28422fdd2
 ---> 5900e5f01c41
Step 5/11 : ARG mlu_platform=MLU270
 ---> Running in 123e64c931aa
Removing intermediate container 123e64c931aa
 ---> 1573d22994ba
Step 6/11 : ARG with_neuware_installed=yes
 ---> Running in ae9355203164
Removing intermediate container ae9355203164
 ---> 1d8b9e82644a
Step 7/11 : RUN echo -e 'nameserver 114.114.114.114' > /etc/resolv.conf
 ---> Running in c7fa9091e2b8
Removing intermediate container c7fa9091e2b8
 ---> 3c579795437b
Step 8/11 : RUN echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted > /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial universe >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates universe >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial multiverse >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates multiverse >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security universe >> /etc/apt/sources.list &&     echo deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security multiverse >> /etc/apt/sources.list &&     apt-get install --assume-yes && apt-get update --fix-missing &&     rm -rf /var/lib/apt/lists/* && mkdir /var/lib/apt/lists/partial &&     apt-get clean && apt-get update --fix-missing &&     apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends             curl git wget vim build-essential cmake make             libopencv-dev             libgoogle-glog-dev             openssh-server             libsdl2-dev              lcov              net-tools &&     apt-get clean &&     rm -rf /var/lib/apt/lists/*
 ---> Running in 6f14dead8854
Reading package lists...
Building dependency tree...
Reading state information...
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Get:1 http://mirrors.tuna.tsinghua.edu.cn/ubuntu xenial InRelease [247 kB]
......
......
......
Unpacking multiarch-support (2.23-0ubuntu11.2) over (2.23-0ubuntu11) ...
Setting up multiarch-support (2.23-0ubuntu11.2) ...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  binutils bzip2 cmake-data cpp cpp-5 dpkg-dev fontconfig fontconfig-config
  fonts-dejavu-core g++ g++-5 gcc gcc-5 gir1.2-atk-1.0 gir1.2-freedesktop
......
......
......
[ 99%] Building CXX object samples/demo/CMakeFiles/demo.dir/obj_filter/car_filter.cpp.o
[100%] Linking CXX executable ../../../samples/bin/demo
[100%] Built target demo
Removing intermediate container a18fd1a29e68
 ---> d737a0ee2039
Step 11/11 : WORKDIR /root/CNStream/samples/demo
 ---> Running in f5e95459b24c
Removing intermediate container f5e95459b24c
 ---> b5da7e2a95f2
Successfully built b5da7e2a95f2
Successfully tagged ubuntu16.04_cnstream-v1.4.0:v1
====================== save image ======================
-rw------- 1 cam cam 1268862976 7月  22 14:21 ubuntu16.04_cnstream-v1.4.0.tar
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$
```

## Load ##

```bash
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$ ./load-cnstream-image-v1.4.sh
0
ubuntu16.04_cnstream-v1.4.0
The image is not loaded and is loading......
d908d9ad6713: Loading layer [==================================================>]  130.1MB/130.1MB
631dfaad8559: Loading layer [==================================================>]  11.78kB/11.78kB
968d3b985bf4: Loading layer [==================================================>]  15.87kB/15.87kB
377c01c3f4e3: Loading layer [==================================================>]  3.072kB/3.072kB
e5c38e1d74ba: Loading layer [==================================================>]   2.56kB/2.56kB
baa3ba43b324: Loading layer [==================================================>]  709.2MB/709.2MB
5a4fddfb803d: Loading layer [==================================================>]  137.3MB/137.3MB
cc14262c927f: Loading layer [==================================================>]  292.2MB/292.2MB
Loaded image: ubuntu16.04_cnstream-v1.4.0:v1
====================== image information ======================
REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
ubuntu16.04_cnstream-v1.4.0   v1                  ccbc900c88d7        10 minutes ago      1.25GB
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$
```

## Run ##

```bash
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$ ./run-cnstream-container-v1.4.sh
0
ubuntu_cnstream-v1.4.0
root@cam-3630:~/CNStream/samples/demo# exit
exit
cam@cam-3630:/data/docker/cnstream$ docker ps -a
CONTAINER ID        IMAGE                            COMMAND             CREATED              STATUS                     PORTS               NAMES
9e953cbfd0c7        ubuntu16.04_cnstream-v1.4.0:v1   "/bin/bash"         About a minute ago   Exited (0) 5 seconds ago                       ubuntu_cnstream-v1.4.0
cam@cam-3630:/data/docker/cnstream/cnstream-docker-image$
```
