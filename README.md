# CNStream Docker Images #

Build docker images for [CNStream](https://github.com/Cambricon/CNStream).

## Directory tree ##

```bash
.
├── build-cnstream-image.sh
├── Dockerfile.16.04
├── load-image-cnstream.sh
├── rm-all-docker-container.sh
└── run-container-cnstream.sh
```

## Clone ##
```bash
git clone https://github.com/CambriconKnight/cnstream-docker-image.git
```
```bash
cam@cam-3630:/data/github$ git clone https://github.com/CambriconKnight/cnstream-docker-image.git
Cloning into 'cnstream-docker-image'...
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (14/14), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 14 (delta 3), reused 13 (delta 2), pack-reused 0
Unpacking objects: 100% (14/14), done.
Checking connectivity... done.
cam@cam-3630:/data/github$ cd cnstream-docker-image
cam@cam-3630:/data/github/cnstream-docker-image$ ls
build-cnstream-image.sh  Dockerfile.16.04  load-image-cnstream.sh  README.md  rm-all-docker-container.sh  run-container-cnstream.sh
cam@cam-3630:/data/github/cnstream-docker-image$
```

## Build ##
```bash
./build-cnstream-image.sh
```
```bash
cam@cam-3630:/data/github/cnstream-docker-image$ ./build-cnstream-image.sh
Cloning into 'cnstream'...
remote: Enumerating objects: 1005, done.
remote: Counting objects: 100% (1005/1005), done.
remote: Compressing objects: 100% (684/684), done.
remote: Total 5920 (delta 422), reused 710 (delta 292), pack-reused 4915
Receiving objects: 100% (5920/5920), 192.19 MiB | 3.02 MiB/s, done.
Resolving deltas: 100% (3113/3113), done.
Checking connectivity... done.
File(neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb): Not exist!
Copy your neuware package(neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb) into the directory of CNStream!
eg:cp -v /data/ftp/v1.5.0/neuware/neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb ./cnstream
cam@cam-3630:/data/github/cnstream-docker-image$ cp -v /data/ftp/v1.5.0/neuware/neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb ./cnstream
'/data/ftp/v1.5.0/neuware/neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb' -> './cnstream/neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb'
cam@cam-3630:/data/github/cnstream-docker-image$ ./build-cnstream-image.sh
Directory(cnstream): Exists!
File(neuware-mlu270-1.5.0-1_Ubuntu16.04_amd64.deb): Exists!
====================== build image ======================
Sending build context to Docker daemon  159.3MB
Step 1/11 : FROM ubuntu:16.04
 ---> c522ac0d6194
......
......
......
Step 11/11 : WORKDIR /root/CNStream/samples/demo
 ---> Running in 3d594d45f6b8
Removing intermediate container 3d594d45f6b8
 ---> 080fdb4ca3c3
Successfully built 080fdb4ca3c3
Successfully tagged ubuntu16.04_cnstream:v1.5.0
====================== save image ======================
-rw------- 1 cam cam 1351632896 12月 15 22:03 ubuntu16.04_cnstream-v1.5.0.tar.gz
cam@cam-3630:/data/github/cnstream-docker-image$
```

## Load ##
```bash
#加载Docker镜像
./load-image-cnstream.sh
```

## Run ##
```bash
#启动Docker容器
./run-container-cnstream.sh
```

## Test ##
```bash
#硬件平台：MLU270、MLU220-M.2
#软件环境：Docker（ubuntu16.04_cnstream-v1.5.0.tar.gz）
#运行实例：基于CNStream的YOLOv3测试Demo
#业务流程：读取视频文件 --> MLU硬件解码 --> MLU硬件推理 --> 叠加OSD信息 --> RTSP推流输出
#离线模型：http://video.cambricon.com/models/MLU270/yolov3/yolov3_offline_u4_v1.3.0.cambricon
#启动脚本：/root/CNStream/samples/demo/detection/mlu270/run_yolov3_mlu270.sh
#        /root/CNStream/samples/demo/detection/mlu220/run_yolov3_mlu220.sh
#配置文件：/root/CNStream/samples/demo/detection/mlu270/yolov3_mlu270_config.json
#        /root/CNStream/samples/demo/detection/mlu220/yolov3_mlu220_config.json
```

推理结果摘选：
<table>
    <tr>
        <td ><center><img alt="yolov3.gif" src="./res/yolov3.gif" height="250" </center></td>
    </tr>
</table>

```bash
root@cam-3630:~# cd /root/CNStream/samples/demo/detection/mlu270/
root@cam-3630:~/CNStream/samples/demo/detection/mlu270# ./run_yolov3_mlu270.sh
--2020-12-15 14:24:42--  http://video.cambricon.com/models/MLU270/yolov3/yolov3_offline_u4_v1.3.0.cambricon
Resolving video.cambricon.com (video.cambricon.com)... 182.92.212.157
Connecting to video.cambricon.com (video.cambricon.com)|182.92.212.157|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 98652692 (94M) [text/plain]
Saving to: 'yolov3_offline_u4_v1.3.0.cambricon'
yolov3_offline_u4_v1.3.0.cambricon                 100%[================================================================================================================>]  94.08M  2.25MB/s    in 45s
2020-12-15 14:25:28 (2.07 MB/s) - 'yolov3_offline_u4_v1.3.0.cambricon' saved [98652692/98652692]
--2020-12-15 14:25:28--  http://video.cambricon.com/models/MLU270/yolov3/label_map_coco.txt
......
......
......
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
===================================[ osd Performance ]==========================================
[stream id] stream_0  -- [latency] avg:    4.3ms, min:    0.9ms, max:   33.6ms, [frame count]: 1784
[stream id] stream_1  -- [latency] avg:    4.5ms, min:    0.7ms, max:   29.7ms, [frame count]: 1784
--------------------------------------------------------
Throughput over the last 2s
Total :         -- [frame count]: 16, [processing time(s)]:   0.038891, [fps]:  411.5
--------------------------------------------------------
Average throughput over the process
Total :         -- [frame count]: 3568, [processing time(s)]:   7.968857, [fps]:  447.8
===================================[ Pipeline Performance ]=====================================
End node of pipeline: rtsp_sink
[stream id] stream_0  -- [latency] avg:  271.8ms, min:   84.1ms, max:  510.7ms, [frame count]: 1784
[stream id] stream_1  -- [latency] avg:  271.1ms, min:   82.1ms, max:  527.8ms, [frame count]: 1784
--------------------------------------------------------
Throughput over the last 2s
[stream id] stream_0  -- [frame count]: 9, [processing time(s)]:   0.246877, [fps]:   36.5
[stream id] stream_1  -- [frame count]: 7, [processing time(s)]:   0.289882, [fps]:   24.2
(* Note: Performance info of pipeline is slightly delayed compared to that of each stream.)
Pipeline :      -- [frame count]: 17, [processing time(s)]:   0.289882, [fps]:   58.7
--------------------------------------------------------
Average throughput over the process
[stream id] stream_0  -- [frame count]: 1784, [processing time(s)]:  59.782535, [fps]:   29.9
[stream id] stream_1  -- [frame count]: 1784, [processing time(s)]:  59.804728, [fps]:   29.9
(* Note: Performance info of pipeline is slightly delayed compared to that of each stream.)
Pipeline :      -- [frame count]: 3568, [processing time(s)]:  59.813077, [fps]:   59.7

Total : 59.700000
CNSTREAM CORE I1215 14:26:30.512209 27883] [MyPipeline] Stop
WARNING: Logging before InitCNStreamLogging() is written to STDERR
CNSTREAM CORE I1215 14:26:30.512708 27887] [MyPipeline] stop updating stream message
I1215 14:26:30.513303 27883 mlu_context.cpp:82] Cambricon runtime destroy
root@cam-3630:~/CNStream/samples/demo/detection/mlu270#
```