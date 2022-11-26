<p align="center">
    <a href="https://github.com/Cambricon/CNStream">
        <h1 align="center">CNStream环境搭建与验证</h1>
    </a>
</p>

# 1. 概述

本工具集主要基于Docker容器进行[CNStream](https://github.com/Cambricon/CNStream)环境搭建与验证。力求压缩寒武纪CNStream环境搭建与功能验证的时间成本, 以便快速上手寒武纪CNStream。

*本工具集仅用于个人学习，打通流程； 不对效果负责，不承诺商用。*

## 1.1. 硬件环境准备

| 名称            | 数量       | 备注                |
| :-------------- | :--------- | :------------------ |
| 开发主机/服务器   | 一台       |主流配置即可；电源功率按需配置；PCIe Gen.3 x16/Gen.4 x16 |
| MLU270/MLU370   | 一套       | 二选一, 避免混插混用 |

## 1.2. 软件环境准备

| 名称                   | 版本/文件                                    | 备注            |
| :-------------------- | :-------------------------------             | :--------------- |
| Linux OS              | Ubuntu16.04/Ubuntu18.04/CentOS7   | 宿主机操作系统   |
| 以下为MLU270软件依赖包   |                                   |                      |
| Driver_MLU270         | neuware-mlu270-driver-dkms_4.9.13_all.deb    | 驱动程序   |
| CNToolkit_MLU270      | cntoolkit_1.7.14-1.ubuntu18.04_amd64.deb     | SDK For MLU270   |
| CNCV_MLU270           | cncv_0.4.606-1.ubuntu18.04_amd64.deb         | SDK For MLU270   |

*以上软件包涉及FTP手动下载的,可下载到本地[dependent_files](./dependent_files)目录下,方便对应以下步骤中的提示操作。*

**环境变量**

以下环境变量在Docker容器中已经设置:
- NEUWARE_HOME=/usr/local/neuware
- LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${NEUWARE_HOME}/lib64
- LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
- WORK_DIR=/root/cnstream

# 2. 目录结构

```bash
.
├── build-image-cnstream.sh
├── clean.sh
├── cnstream
├── dependent_files
├── docker
├── env.sh
├── load-image-cnstream.sh
├── mlu220m.2
├── README.md
├── res
├── run-container-cnstream.sh
├── save-image-cnstream.sh
└── sync.sh
```

# 3. 下载源码
```bash
git clone https://github.com/CambriconKnight/cnstream-docker-image.git
```

# 4. 编译镜像
```bash
#编译cnstream镜像
./build-image-cnstream.sh
```
编译后会在docker目录下生存一个镜像文件。$VERSION版本以实际为准
```bash
......
====================== save image ======================
-rw-rw-r-- 1 root root 2.1G 11月 27 01:18 ./docker/image-ubuntu18.04-cnstream-v1.7.610.tar.gz
```

# 5. 加载镜像
```bash
#加载Docker镜像
./load-image-cnstream.sh
```

# 6. 启动容器
```bash
#启动Docker容器
./run-container-cnstream.sh
```

# 7. 实例测试
寒武纪 CNStream 开发样例为用戶提供了物体分类、检测、追踪等场景的编程样例。另外还提供了前处理、后处理、自定义模块以及如何使用非配置文件方式创建应用程序的样例源码。帮助用戶快速体验如何使用CNStream开发应用。用戶只需直接通过脚本运行样例程序，无需修改任何配置。

CNStream 开发样例主要包括 .json 文件和 .sh 文件，其中 .json 文件为样例的配置文件，用于声明 pipeline 中各个模块的上下游关系以及配置模块的参数。用戶可以根据自己的需求修改配置文件参数，完成应用开发。 .sh 文件为样例的运行脚本，通过运行该脚本来运行样例。

开发样例中的模型在运行样例时被自动加载，并且会保存在${CNSTREAM_DIR}/data/models目录下。下面以目标检测为例, 介绍如何运行CNStream提供的样例。
## YOLOv3 ##
使用 YOLOv3 网络预训练模型进行⽬标检测.
```bash
#硬件平台：MLU270、MLU220
#软件环境：Docker（image-ubuntu18.04-cnstream-v1.7.610.tar.gz）
#环境变量：${CNSTREAM_DIR}=/root/cnstream , 此环境变量在docker镜像中已设置,可直接使用
#运行实例：基于CNStream的YOLOv3运行实例
#业务流程：读取视频文件 --> MLU硬件解码 --> MLU硬件推理 --> 叠加OSD信息 --> RTSP推流输出
#所用插件：DataSource; Inferencer; Osd; RtspSink
#离线模型：http://video.cambricon.com/models/MLU270/yolov3/yolov3_offline_u4_v1.3.0.cambricon
#视频文件：${CNSTREAM_DIR}/data/videos/cars.mp4
#启动脚本：${CNSTREAM_DIR}/samples/cns_launcher/object_detection/run.sh
#        Usages: run.sh [mlu220/mlu270] [encode_jpeg/encode_video/display/rtsp/kafka]
#配置文件：${CNSTREAM_DIR}/samples/cns_launcher/object_detection/config_template.json
#后处理代码：${CNSTREAM_DIR}/samples/common/postprocess/postprocess_yolov3.cpp
#启动命令：cd ${CNSTREAM_DIR}/samples/cns_launcher/object_detection && ./run.sh mlu270 rtsp
#结果演示：执行启动命令后，脚本会自动下载检测模型, 之后按照 json 配置文件启动业务处理流程.
#        最后把检测后的结果通过 RTSP 服务模块推送出去.
```

**推理结果摘选：**
<table>
    <tr>
        <td ><center><img alt="yolov3.gif" src="./res/yolov3.gif" height="250" </center></td>
    </tr>
</table>
<table>
    <tr>
        <td ><center><img alt="yolo_mosaic_500.gif" src="./res/yolo_mosaic_500.gif" height="500" </center></td>
    </tr>
</table>