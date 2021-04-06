#/bin/bash
set -e

# 1. build image
# (1) build image with neuware installed:
#   a. copy your neuware package into the directory of CNStream
#   b. docker build -f docker/Dockerfile.16.04 --build-arg neuware_package=${neuware_package_name} -t ubuntu_cnstream:v1 .
# (2) build image without neuware installed: docker build -f docker/Dockerfile.16.04 --build-arg with_neuware_installed=no -t ubuntu_cnstream:v1 .
# 2. start container: docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged -v /dev:/dev --net=host --ipc=host --pid=host -v $HOME/.Xauthority -it --name container_name  -v $PWD:/workspace ubuntu_cnstream:v1

#################### function ####################
help_info() {
    echo "
Build docker images for CNStream.
Usage:
    $0 <command> [arguments]
The commands are:
    -h      Help info.
    -m      MLU Platform.(mlu270, mlu220m.2)
    -v      Neuware version.
Examples:
    $0 -h
    $0 -m mlu270 -v 1.6.602
    $0 -m mlu220m.2 -v 1.6.602
Use '$0 -h' for more information about a command.
    "
}

# Refresh global variables
refresh_global_variables() {
    MLU_Platform=`echo ${MLU} | tr '[a-z]' '[A-Z]'`
    if [[ "${MLU_Platform}" == "MLU270" ]] || [[ "${MLU_Platform}" == "MLU220M.2" ]] ; then
        MLU_Platform="MLU270"
    else
        help_info
    fi
    VERSION="v${VER}"
    neuware_version="neuware-${MLU}-${VER}"
    neuware_package_name="cntoolkit_1.7.2-1.ubuntu16.04_amd64.deb"
    NAME_IMAGE="ubuntu16.04_cnstream:$VERSION"
    FILENAME_IMAGE="ubuntu16.04_cnstream-$VERSION.tar.gz"
}

#################### main ####################
#MLU Platform
MLU="mlu270"
#Version
VER="1.6.602"

#Global variables
#UPPERCASE:mlu270--->MLU270
MLU_Platform=`echo ${MLU} | tr '[a-z]' '[A-Z]'`
VERSION="v${VER}"
PATH_CNSTREAM="CNStream"
neuware_version="neuware-${MLU}-${VER}"
neuware_package_name="cntoolkit_1.7.2-1.ubuntu16.04_amd64.deb"
NAME_IMAGE="ubuntu16.04_cnstream:$VERSION"
FILENAME_IMAGE="ubuntu16.04_cnstream-$VERSION.tar.gz"

none="\033[0m"
green="\033[0;32m"
red="\033[0;31m"
yellow="\033[1;33m"

#if [[ $# -eq 0 ]];then
#    help_info && exit 0
#fi

# Get parameters
while getopts "h:m:v:" opt; do
    case $opt in
    h) help_info  &&  exit 0
        ;;
    m) MLU="$OPTARG"
        ;;
    v) VER="$OPTARG"
        ;;
    \?)
        help_info && exit 0
        ;;
    esac
done

#Refresh global variables
#refresh_global_variables

##0.git clone
if [ ! -d "$PATH_CNSTREAM" ];then
    #git clone https://github.com/Cambricon/CNStream.git
    git clone https://gitee.com/SolutionSDK/CNStream.git
else
    echo "Directory($PATH_CNSTREAM): Exists!"
fi
cd "${PATH_CNSTREAM}"
git submodule  update  --init
# del .git
#find . -name ".git" | xargs rm -Rf

##copy your neuware package into the directory of CNStream
if [ -f "${neuware_package_name}" ];then
    echo "File(${neuware_package_name}): Exists!"
else
    echo -e "${red}File(${neuware_package_name}): Not exist!${none}"
    echo -e "${yellow}Copy your neuware package(${neuware_package_name}) into the directory of CNStream!${none}"
    echo -e "${yellow}eg:cp -v /data/ftp/1.6.602/cntoolkit/ubuntu16.04/${neuware_package_name} ./${PATH_CNSTREAM}${none}"
    #Manual copy
    #cp -v /data/ftp/iva-1.6.106/cntoolkit/ubuntu16.04/cntoolkit_1.4.110-1.ubuntu16.04_amd64.deb ./cnstream
    exit -1
fi

#1.build image
echo "====================== build image ======================"
sudo docker build -f ../Dockerfile.16.04 \
    --build-arg neuware_package=${neuware_package_name} \
    --build-arg mlu_platform=${MLU_Platform} \
    -t $NAME_IMAGE .
#2.save image
echo "====================== save image ======================"
sudo docker save -o $FILENAME_IMAGE $NAME_IMAGE
mv $FILENAME_IMAGE ../
cd ../
ls -la $FILENAME_IMAGE
