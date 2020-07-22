#/bin/bash
set -e

# 1. build image
# (1) build image with neuware installed:
#   a. copy your neuware package into the directory of CNStream
#   b. docker build -f docker/Dockerfile.16.04 --build-arg neuware_package=${neuware_package_name} -t ubuntu_cnstream:v1 .
# (2) build image without neuware installed: docker build -f docker/Dockerfile.16.04 --build-arg with_neuware_installed=no -t ubuntu_cnstream:v1 .
# 2. start container: docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged -v /dev:/dev --net=host --ipc=host --pid=host -v $HOME/.Xauthority -it --name container_name  -v $PWD:/workspace ubuntu_cnstream:v1

PATH_CNSTREAM="cnstream"
neuware_package_name="neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb"
NAME_IMAGE="ubuntu16.04_cnstream-v1.4.0:v1"
FILENAME_IMAGE="ubuntu16.04_cnstream-v1.4.0.tar"

none="\033[0m"
green="\033[0;32m"
red="\033[0;31m"
yellow="\033[1;33m"

##0.git clone
if [ ! -d "$PATH_CNSTREAM" ];then
    git clone https://github.com/Cambricon/cnstream.git
else
    echo "Directory($PATH_CNSTREAM): Exists!"
fi
cd "${PATH_CNSTREAM}"
# del .git
find . -name ".git" | xargs rm -Rf

##copy your neuware package into the directory of CNStream
if [ -f "${neuware_package_name}" ];then
    echo "File(${neuware_package_name}): Exists!"
else
    echo -e "${red}File(${neuware_package_name}): Not exist!${none}"
    echo -e "${yellow}Copy your neuware package(${neuware_package_name}) into the directory of CNStream!${none}"
    echo -e "${yellow}eg:cp -v /data/ftp/v1.4.0/neuware/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb ./${PATH_CNSTREAM}${none}"
    #Manual copy
    #cp -v /data/ftp/v1.4.0/neuware/neuware-mlu270-1.4.0-1_Ubuntu16.04_amd64.deb ./cnstream
    exit -1
fi

#1.build image
echo "====================== build image ======================"
docker build -f ../Dockerfile.16.04 --build-arg neuware_package=${neuware_package_name} -t $NAME_IMAGE .
#2.save image
echo "====================== save image ======================"
docker save -o $FILENAME_IMAGE $NAME_IMAGE
mv $FILENAME_IMAGE ../
cd ../
ls -la $FILENAME_IMAGE
