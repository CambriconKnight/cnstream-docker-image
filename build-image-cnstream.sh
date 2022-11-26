#/bin/bash
set -e
# -------------------------------------------------------------------------------
# Filename:     build-image-cnstream.sh
# UpdateDate:   2022/11/26
# Description:  Build docker images for cnstream.
# Example:      ./build-image-cnstream.sh
# Depends:
#               driver(ftp://download.cambricon.com:8821/product/MLU270/1.6.610/driver/neuware-mlu270-driver-dkms_4.9.13_all.deb)
#               cntoolkit(ftp://download.cambricon.com:8821/product/MLU270/1.610/cntoolkit/X86_64/ubuntu16.04/cntoolkit_1.7.14-1.ubuntu18.04_amd64.deb)
#               cnstream(https://gitee.com/SolutionSDK/cnstream.git)
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
AddrGitCNStream="https://github.com/Cambricon/cnstream.git"
#AddrGitCNStream="https://gitee.com/SolutionSDK/cnstream.git"
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
# Download CNStream
#Github clone 指定分支及commit的代码,避免版本更新迭代造成不兼容.
GITHUB_Branch="master"
#GITHUB_Commit="877f5f55b3e21f73ac5eeac3985e4654ed1f73d7"
GITHUB_Commit="7c5e8e0c09b8bf37d17d1216cd23b650c46fe20a"
if [ ! -d "${PATH_WORK}" ];then
    echo "AddrGitCNStream=${AddrGitCNStream}"
    echo "GITHUB_Branch=${GITHUB_Branch}"
    echo "GITHUB_Commit=${GITHUB_Commit}"
    git clone ${AddrGitCNStream} -b ${GITHUB_Branch}
    cd ${PATH_WORK} && git checkout ${GITHUB_Commit} && cd -
    pushd ${PATH_WORK}
    git submodule update --init
    # del .git
    find . -name ".git" | xargs rm -Rf
    popd
else
    echo "Directory($PATH_WORK): Exists!"
fi

# 2. Copy the dependent packages into the directory of $PATH_WORK
## Sync script
#cp -rvf ./docker/build_cnstream.sh ./${PATH_WORK}
#cp -rvf ./docker/install_cntoolkit.sh ./${PATH_WORK}
## Sync CNToolkit
pushd "${PATH_WORK}"
if [ -f "${FILENAME_CNToolkit}" ];then
    echo "File(${FILENAME_CNToolkit}): Exists!"
else
    echo -e "${red}File(${FILENAME_CNToolkit}): Not exist!${none}"
    echo -e "${yellow}1.Please download ${FILENAME_CNToolkit} from FTP(ftp://download.cambricon.com:8821/***)!${none}"
    echo -e "${yellow}  For further information, please contact us.${none}"
    echo -e "${yellow}2.Copy the dependent packages(${FILENAME_CNToolkit}) into the directory!${none}"
    echo -e "${yellow}  eg:cp -v /data/ftp/product/GJD/MLU270/$VER/Ubuntu18.04/CNToolkit/${FILENAME_CNToolkit} ./${PATH_WORK}${none}"
    #Manual copy
    #cp -v /data/ftp/product/GJD/MLU270/1.7.610/Ubuntu18.04/CNToolkit/cntoolkit_1.7.14-1.ubuntu18.04_amd64.deb ./cnstream
    exit -1
fi
popd
## Sync CNCV
pushd "${PATH_WORK}"
if [ -f "${FILENAME_CNCV}" ];then
    echo "File(${FILENAME_CNCV}): Exists!"
else
    echo -e "${red}File(${FILENAME_CNCV}): Not exist!${none}"
    echo -e "${yellow}1.Please download ${FILENAME_CNCV} from FTP(ftp://download.cambricon.com:8821/***)!${none}"
    echo -e "${yellow}  For further information, please contact us.${none}"
    echo -e "${yellow}2.Copy the dependent packages(${FILENAME_CNCV}) into the directory!${none}"
    echo -e "${yellow}  eg:cp -v /data/ftp/product/GJD/MLU270/$VER/Ubuntu18.04/CNToolkit/${FILENAME_CNCV} ./${PATH_WORK}${none}"
    #Manual copy
    #cp -v /data/ftp/product/GJD/MLU270/1.7.610/Ubuntu18.04/CNToolkit/cncv_0.4.606-1.ubuntu18.04_amd64.deb ./cnstream
    exit -1
fi
popd
#1.build image
echo "====================== build image ======================"
sudo docker build -f ./docker/$FILENAME_DOCKERFILE \
    --build-arg cntoolkit_package=${FILENAME_CNToolkit} \
    --build-arg cncv_package=${FILENAME_CNCV} \
    --build-arg mlu_platform=${MLU_Platform} \
    -t $NAME_IMAGE .
#2.save image
echo "====================== save image ======================"
sudo docker save -o ${FILENAME_IMAGE} $NAME_IMAGE
sync && sync
sudo chmod 664 ${FILENAME_IMAGE}
mv ${FILENAME_IMAGE} ./${DIR_DOCKER}/
ls -lh ./${DIR_DOCKER}/${FILENAME_IMAGE}
