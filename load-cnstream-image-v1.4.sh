#/bin/bash
set -e

#Images name
MY_IMAGES="ubuntu16.04_cnstream-v1.4.0"

num=`sudo docker images | grep -w "$MY_IMAGES" | wc -l`
echo $num
echo $MY_IMAGES

#if [ 0 -ne $num ];then
#    sudo docker stop $MY_CONTAINER
#    sudo docker rm $MY_CONTAINER
#    sudo docker rmi mlu270_docker_ubuntu16.04:v1.3
#fi

if [ 0 -eq $num ];then
    echo "The image is not loaded and is loading......"
    #load image
    sudo docker load < ubuntu16.04_cnstream-v1.4.0.tar
else
    echo "The image is already loaded!"
fi
echo "====================== image information ======================"
sudo docker images
