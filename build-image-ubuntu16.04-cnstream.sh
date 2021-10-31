#/bin/bash
set -e
# -------------------------------------------------------------------------------
# Filename:     build-image-ubuntu16.04-cnstream.sh
# UpdateDate:   2021/02/23
# Description:  Build docker images for cnstream.
# Example:      ./build-image-ubuntu16.04-cnstream.sh
# Depends:
#               driver(ftp://download.cambricon.com:8821/product/MLU270/1.6.602/driver/neuware-mlu270-driver-dkms_4.9.2_all.deb)
#               cntoolkit(ftp://download.cambricon.com:8821/product/MLU270/1.6.602/cntoolkit/X86_64/ubuntu16.04/cntoolkit_1.7.2-1.ubuntu16.04_amd64.deb)
#               cnstream(https://gitee.com/SolutionSDK/CNStream.git)
#               ffmpeg(https://gitee.com/mirrors/ffmpeg.git)
# Notes:
# -------------------------------------------------------------------------------
#################### function ####################
help_info() {
    echo "
Build docker images for cnstream.
Usage:
    $0 <command> [arguments]
The commands are:
    -h      Help info.
    -m      MLU Platform.(mlu270, mlu220m.2)
Examples:
    $0 -h
    $0 -m mlu270
    $0 -m mlu220m.2
Use '$0 -h' for more information about a command.
    "
}

# Refresh global variables
refresh_global_variables() {
    #UPPERCASE:mlu270--->MLU270
    MLU_Platform=`echo ${MLU} | tr '[a-z]' '[A-Z]'`
    if [[ "${MLU_Platform}" == "MLU270" ]] || [[ "${MLU_Platform}" == "MLU220M.2" ]] ; then
        MLU_Platform="MLU270"
    else
        help_info
    fi
}

#################### main ####################
# Source env
source "./env.sh"

#MLU Platform
MLU="mlu270"

# Get parameters
while getopts "h:m:" opt; do
    case $opt in
    h) help_info  &&  exit 0
        ;;
    m) MLU="$OPTARG"
        ;;
    \?)
        help_info && exit 0
        ;;
    esac
done

#Refresh global variables
refresh_global_variables

##0.git clone
if [ ! -d "${PATH_WORK}" ];then
    #git clone https://github.com/Cambricon/CNStream.git
    git clone https://gitee.com/SolutionSDK/CNStream.git
    mv CNStream ${PATH_WORK}
else
    echo "Directory($PATH_WORK): Exists!"
fi
cd "${PATH_WORK}"
git submodule update --init
# del .git
find . -name ".git" | xargs rm -Rf

##copy the dependent packages into the directory of $PATH_WORK
if [ -f "${neuware_package_name}" ];then
    echo "File(${neuware_package_name}): Exists!"
else
    echo -e "${red}File(${neuware_package_name}): Not exist!${none}"
    echo -e "${yellow}1.Please download ${neuware_package_name} from FTP(ftp://download.cambricon.com:8821/***)!${none}"
    echo -e "${yellow}  For further information, please contact us.${none}"
    echo -e "${yellow}2.Copy the dependent packages(${neuware_package_name}) into the directory!${none}"
    echo -e "${yellow}  eg:cp -v /data/ftp/product/GJD/MLU270/$VER/Ubuntu16.04/CNToolkit/${neuware_package_name} ./${PATH_WORK}${none}"
    #Manual copy
    #cp -v /data/ftp/product/GJD/MLU270/1.7.602/Ubuntu16.04/CNToolkit/cntoolkit_1.7.5-1.ubuntu16.04_amd64.deb ./cnstream
    exit -1
fi
cd ../
#1.build image
echo "====================== build image ======================"
sudo docker build -f ./docker/$FILENAME_DOCKERFILE \
    --build-arg neuware_package=${neuware_package_name} \
    --build-arg mlu_platform=${MLU_Platform} \
    -t $NAME_IMAGE .
#2.save image
echo "====================== save image ======================"
sudo docker save -o $FILENAME_IMAGE $NAME_IMAGE
mv $FILENAME_IMAGE ./docker/
ls -lh ./docker/$FILENAME_IMAGE
