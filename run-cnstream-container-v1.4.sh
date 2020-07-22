#/bin/bash
set -e

#Image name
MY_IMAGES="ubuntu16.04_cnstream-v1.4.0:v1"
#Docker container name
MY_CONTAINER="ubuntu_cnstream-v1.4.0"

######Modify according to your development environment#####
#SDK path on the host
PATH_WORKSPACE_HOST="/data/ftp/v1.4.0"
#Work path on the docker container
PATH_WORKSPACE_DOCKER="/home/ftp"

##########################################################

num=`sudo docker ps -a|grep -w "$MY_CONTAINER$"|wc -l`

echo $num
echo $MY_CONTAINER

if [ 0 -eq $num ];then
    #sudo xhost +
    sudo docker run -e DISPLAY=unix$DISPLAY --privileged=true \
        --net=host --pid=host --ipc=host -v /tmp/.X11-unix:/tmp/.X11-unix \
        -it -v $PATH_WORKSPACE_HOST:$PATH_WORKSPACE_DOCKER \
        --name $MY_CONTAINER $MY_IMAGES /bin/bash
else
    sudo docker start $MY_CONTAINER
    sudo docker exec -ti $MY_CONTAINER /bin/bash
fi
