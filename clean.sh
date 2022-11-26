#/bin/bash
set -e

# Source env
source "./env.sh"

# 1.PATH_WORK
sudo rm -rvf ${PATH_WORK}

# 2.FILENAME_IMAGE
sudo rm -vf ${FULLNAME_IMAGE}

# 3.rm docker container
#sudo docker stop `sudo docker ps -a | grep container-mlu220-cross-compile | awk '{print $1}'`
num_container=`sudo docker ps -a | grep ${MY_CONTAINER} | awk '{print $1}'`
if [ $num_container ]; then sudo docker stop $num_container;fi
#sudo docker rm `sudo docker ps -a | grep container-ubuntu16.04-caffe-v1.6.0 | awk '{print $1}'`
if [ $num_container ]; then sudo docker rm $num_container;fi

# 3.rmi docker image
#sudo docker rmi `sudo docker images | grep cam/ubuntu16.04-caffe | awk '{print $3}'`
num_images=`sudo docker images | grep ${MY_IMAGE} | awk '{print $3}'`
if [ $num_images ]; then sudo docker rmi $num_images;fi

# 4.del tar.gz.eg
#sudo rm -vf image-*.tar.gz
