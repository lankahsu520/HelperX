# [Amazon Kinesis Video Streams](https://aws.amazon.com/tw/kinesis/video-streams/)

[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]
[![GitHub watchers][watchers-image]][watchers-image]

[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues
[watchers-image]: https://img.shields.io/github/watchers/lankahsu520/HelperX.svg
[watchers-url]: https://github.com/lankahsu520/HelperX/watchers

# 1. [Amazon Kinesis Video Streams (Developer Guide)](https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/what-is-kinesis-video.html)

> Amazon Kinesis Video Streams 可讓您安全輕鬆地將影片從連線裝置串流到 AWS，以進行分析、機器學習 (ML)、播放及其他處理。Kinesis Video Streams 可自動佈建和彈性地擴展所需的全部基礎設施，以便從數百萬台裝置導入串流影片資料。

![amazon_kvs01](./images/amazon_kvs01.png)

>Amazon Kinesis Video Streams 中提供 **Video stream** 和 **Signaling channel** 兩種。

>兩邊最大的不同在於**Signaling channel** (WebRTC) 是提供雙向串流。
>
>網路上很多教學都是以 **Video stream** 為主。所以大家要小心取用。

```mermaid
flowchart LR

classDef Aqua    fill:#00FFFF
classDef lightblue fill:#ADD8E6
classDef Lime    fill:#00FF00
classDef Tomato  fill:#FF6347

subgraph aws[aws cloud]
	subgraph kvsServer["KVS (Kinesis Video Streams)"]
		subgraph Video[Video streams]
            v1[HelloLankaKVS]
        end
		subgraph Signaling[Signaling channels]
			s1[HelloLankaKVS]
		end
	end
end
class aws Aqua
```

# 2. Video stream

## 2.1. Repository

### 2.1.1. [amazon-kinesis-video-streams-producer-sdk-cpp](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp)

> Amazon Kinesis Video Streams Producer SDK for C++ is for developers to install and customize for their connected camera and other devices to securely stream video, audio, and time-encoded data to Kinesis Video Streams.

## 2.2. Build

>[Release 3.4.1 of the Amazon Kinesis Video C++ Producer SDK](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/releases/tag/v3.4.1)
>
>[Source code(tar.gz)](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp/archive/refs/tags/v3.4.1.tar.gz)

```bash
# please download amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1.tar.gz
$ rm -rf amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1.tar.gz
$ tar -zxvf amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1.tar.gz

$ cd amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1
$ tree -L 1 ./
./
├── certs
├── CMake
├── CMakeLists.txt
├── docs
├── kvs_log_configuration
├── LICENSE
├── NOTICE
├── README.md
├── samples
├── src
└── tst

6 directories, 5 files
```

```bash
$ cd amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1

$ (rm -rf build_xxx; mkdir -p build_xxx)

# To Include Building GStreamer Sample Programs
$ (cd build_xxx; cmake -DBUILD_GSTREAMER_PLUGIN=TRUE ..)
```

```bash
# 於 open-source 可以看到已經編譯了很多相關 libraries；
# 開發 Embedded Linux 的同仁，請查看裏面有無重複 libraries。
$ tree -L 3 open-source/
open-source/
└── local
    ├── bin
    │   ├── aclocal
    │   ├── aclocal-1.16
    │   ├── autoconf
    │   ├── autoheader
    │   ├── autom4te
    │   ├── automake
    │   ├── automake-1.16
    │   ├── autoreconf
    │   ├── autoscan
    │   ├── autoupdate
    │   ├── c_rehash
    │   ├── curl-config
    │   ├── ifnames
    │   └── openssl
    ├── include
    │   ├── curl
    │   ├── log4cplus
    │   └── openssl
    ├── lib
    │   ├── cmake
    │   ├── engines-1.1
    │   ├── libcrypto.a
    │   ├── libcrypto.so -> libcrypto.so.1.1
    │   ├── libcrypto.so.1.1
    │   ├── libcurl.so
    │   ├── liblog4cplus-2.0.so.3 -> liblog4cplus-2.0.so.3.2.2
    │   ├── liblog4cplus-2.0.so.3.2.2
    │   ├── liblog4cplus.la
    │   ├── liblog4cplus.so -> liblog4cplus-2.0.so.3.2.2
    │   ├── liblog4cplusU-2.0.so.3 -> liblog4cplusU-2.0.so.3.2.2
    │   ├── liblog4cplusU-2.0.so.3.2.2
    │   ├── liblog4cplusU.la
    │   ├── liblog4cplusU.so -> liblog4cplusU-2.0.so.3.2.2
    │   ├── libssl.a
    │   ├── libssl.so -> libssl.so.1.1
    │   ├── libssl.so.1.1
    │   └── pkgconfig
    └── share
        ├── aclocal
        ├── aclocal-1.16
        ├── autoconf
        ├── automake-1.16
        ├── doc
        ├── info
        └── man

18 directories, 29 files
```

```bash
$ (cd build_xxx;make)
# or
$ (cd build_xxx;make VERBOSE=1)
```

```bash
$ (cd build_xxx; tree -L 1 ./)
./
├── CMakeCache.txt
├── CMakeFiles
├── cmake_install.cmake
├── dependency
├── kvs_gstreamer_audio_video_sample
├── kvs_gstreamer_file_uploader_sample
├── kvs_gstreamer_multistream_sample
├── kvs_gstreamer_sample
├── kvssink_gstreamer_sample
├── libgstkvssink.so
├── libKinesisVideoProducer.so
└── Makefile

2 directories, 10 files
```

## 2.3. Samples

> Channel - HelloLankaKVS

```bash
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=AKI00000000000000000
export AWS_SECRET_ACCESS_KEY=KEY0000000000000000000000000/00000000000
```

```bash
cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1

export GST_PLUGIN_PATH=`pwd`/build_xxx
export LD_LIBRARY_PATH=`pwd`/open-source/local/lib

# to check gstreamer plugin
$ gst-inspect-1.0 kvssink
Factory Details:
  Rank                     primary + 10 (266)
  Long-name                KVS Sink
  Klass                    Sink/Video/Network
  Description              GStreamer AWS KVS plugin
  Author                   AWS KVS <kinesis-video-support@amazon.com>

Plugin Details:
  Name                     kvssink
  Description              GStreamer AWS KVS plugin
  Filename                 /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx/libgstkvssink.so
  Version                  1.0
  License                  Proprietary
  Source module            kvssinkpackage
  Binary package           GStreamer
  Origin URL               http://gstreamer.net/
...
```

### 2.3.1. kvs_gstreamer_file_uploader_sample

>kvs_gstreamer_file_uploader_sample 上傳格式
>
>video: h264
>
>audio: aac

#### A. lanka520-h264andmp3.mp4

>lanka520-h264andmp3.mp4
>
>video: h264
>
>audio: mp3

```mermaid
flowchart LR
	subgraph lanka520-h264andmp3.mp4
		video[vide: h264]
		audio[audio: mp3]
	end

	video --> |h264|kvssink
	audio --> |aac|kvssink
```

##### A.1. video-only

```bash
$ cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx
$ ./kvs_gstreamer_file_uploader_sample HelloLankaKVS /work/lanka520-h264andmp3.mp4 0
```

##### A.2. audio-video

> video: h264 (file)
>
> audio: mp3 (file) -> aac
>
> please update kvs_gstreamer_file_uploader_sample.cpp
>
> ​	"demuxer. ! queue ! aacparse ! audio/mpeg,stream-format=raw ! sink.",
>
> 換成
>
> ​	"demuxer. ! queue ! mpegaudioparse ! mpg123audiodec ! audioconvert ! voaacenc ! audio/mpeg,stream-format=raw ! sink.",

```bash
$ cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx
$ ./kvs_gstreamer_file_uploader_sample HelloLankaKVS /work/lanka520-h264andmp3.mp4 0 audio-video
```

#### B. lanka520-h264andmp3.mp4 (alsasrc)

> lanka520-h264andmp3.mp4
>
> video: h264
>
> audio: mp3 (這邊用 alsasrc 取代)

```mermaid
flowchart LR
	subgraph lanka520-h264andmp3.mp4
		video[vide: h264]
		audio[audio: alsasrc]
	end

	video --> |h264|kvssink
	audio --> |aac|kvssink
```
##### B.1. audio-video

> video: h264 (file)
>
> audio: alsasrc -> aac
>
> please update kvs_gstreamer_file_uploader_sample.cpp
>
> ​	"demuxer. ! queue ! aacparse ! audio/mpeg,stream-format=raw ! sink.",
>
> 換成
>
> ​	"alsasrc device=\"hw:0,0\" ! audioconvert ! voaacenc ! audio/mpeg,stream-format=raw ! sink.",

```bash
$ cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx
$ ./kvs_gstreamer_file_uploader_sample HelloLankaKVS /work/lanka520-h264andmp3.mp4 0 audio-video
```

### 2.3.2. kvs_gstreamer_audio_video_sample

```mermaid
flowchart LR
	subgraph ubuntu
		video[vide: videosrc]
		audio[audio: audiosrc]
	end

	video --> |h264|kvssink
	audio --> |aac|kvssink
```

#### A. check audiosrc

```bash
$ arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: I82801AAICH [Intel 82801AA-ICH], device 0: Intel ICH [Intel 82801AA-ICH]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: I82801AAICH [Intel 82801AA-ICH], device 1: Intel ICH - MIC ADC [Intel 82801AA-ICH - MIC ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: w300 [w300], device 0: USB Audio [USB Audio]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: I82801AAICH [Intel 82801AA-ICH], device 0: Intel ICH [Intel 82801AA-ICH]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

#### B. check videosrc

```bash
$ sudo apt-get --yes install v4l-utils
$ v4l2-ctl --list-devices
w300: w300 (usb-0000:00:0b.0-1):
        /dev/video0
        /dev/video1

$ v4l2-ctl --all
$ gst-device-monitor-1.0
Probing devices...

Device found:

        name  : w300 Analog Stereo
        class : Audio/Source
        caps  : audio/x-raw, format={ (string)S16LE, (string)S16BE, (string)F32LE, (string)F32BE, (string)S32LE, (string)S32BE, (string)S24LE, (string)S24BE, (string)S24_32LE, (string)S24_32BE, (string)U8 }, layout=interleaved, rate=[ 1, 384000 ], channels=[ 1, 32 ]
                audio/x-alaw, rate=[ 1, 384000 ], channels=[ 1, 32 ]
                audio/x-mulaw, rate=[ 1, 384000 ], channels=[ 1, 32 ]
        properties:
                alsa.resolution_bits = 16
                device.api = alsa
                device.class = sound
                alsa.class = generic
                alsa.subclass = generic-mix
                alsa.name = "USB\ Audio"
                alsa.id = "USB\ Audio"
                alsa.subdevice = 0
                alsa.subdevice_name = "subdevice\ \#0"
                alsa.device = 0
                alsa.card = 1
                alsa.card_name = w300
                alsa.long_card_name = "Sonix\ Technology\ Co.\,\ Ltd.\ w300\ at\ usb-0000:00:0c.0-2\,\ high\ speed"
                alsa.driver_name = snd_usb_audio
                device.bus_path = pci-0000:00:0c.0-usb-0:2:1.2
                sysfs.path = /devices/pci0000:00/0000:00:0c.0/usb1/1-2/1-2:1.2/sound/card1
                udev.id = usb-Sonix_Technology_Co.__Ltd._w300_SN0001-02
                device.bus = usb
                device.vendor.id = 03f0
                device.vendor.name = "HP\,\ Inc"
                device.product.id = 0a59
                device.product.name = w300
                device.serial = Sonix_Technology_Co.__Ltd._w300_SN0001
                device.form_factor = webcam
                device.string = front:1
                device.buffering.buffer_size = 17632
                device.buffering.fragment_size = 4408
                device.access_mode = mmap
                device.profile.name = analog-stereo
                device.profile.description = "Analog\ Stereo"
                device.description = "w300\ Analog\ Stereo"
                module-udev-detect.discovered = 1
                device.icon_name = camera-web-usb
                is-default = true
        gst-launch-1.0 pulsesrc device=alsa_input.usb-Sonix_Technology_Co.__Ltd._w300_SN0001-02.analog-stereo ! ...

Device found:

        name  : w300: w300
        class : Video/Source
        caps  : video/x-raw, format=YUY2, width=864, height=480, pixel-aspect-ratio=1/1, framerate=10/1
                video/x-raw, format=YUY2, width=848, height=480, pixel-aspect-ratio=1/1, framerate=10/1
                video/x-raw, format=YUY2, width=800, height=448, pixel-aspect-ratio=1/1, framerate=10/1
                video/x-raw, format=YUY2, width=640, height=480, pixel-aspect-ratio=1/1, framerate=30/1
                video/x-raw, format=YUY2, width=640, height=360, pixel-aspect-ratio=1/1, framerate=30/1
                video/x-raw, format=YUY2, width=352, height=288, pixel-aspect-ratio=1/1, framerate=30/1
                video/x-raw, format=YUY2, width=320, height=240, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=1920, height=1080, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=1600, height=896, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=1280, height=720, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=1024, height=768, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=1024, height=576, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=960, height=544, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=864, height=480, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=848, height=480, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=800, height=448, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=640, height=480, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=640, height=360, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=352, height=288, pixel-aspect-ratio=1/1, framerate=30/1
                image/jpeg, width=320, height=240, pixel-aspect-ratio=1/1, framerate=30/1
        properties:
                udev-probed = true
                device.bus_path = pci-0000:00:0c.0-usb-0:2:1.0
                sysfs.path = /sys/devices/pci0000:00/0000:00:0c.0/usb1/1-2/1-2:1.0/video4linux/video0
                device.bus = usb
                device.subsystem = video4linux
                device.vendor.id = 03f0
                device.vendor.name = "Sonix\\x20Technology\\x20Co.\\x2c\\x20Ltd."
                device.product.id = 0a59
                device.product.name = "w300:\ w300"
                device.serial = Sonix_Technology_Co.__Ltd._w300_SN0001
                device.capabilities = :capture:
                device.api = v4l2
                device.path = /dev/video0
                v4l2.device.driver = uvcvideo
                v4l2.device.card = "w300:\ w300"
                v4l2.device.bus_info = usb-0000:00:0c.0-2
                v4l2.device.version = 331683 (0x00050fa3)
                v4l2.device.capabilities = 2225078273 (0x84a00001)
                v4l2.device.device_caps = 69206017 (0x04200001)
        gst-launch-1.0 v4l2src ! ...

```

#### C. run

```bash
export AWS_KVS_AUDIO_DEVICE=hw:0,0
export AWS_KVS_VIDEO_DEVICE=/dev/video0

cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx

./kvs_gstreamer_audio_video_sample HelloLankaKVS
```

### 2.3.3. kvssink_gstreamer_sample

```bash
cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx

./kvssink_gstreamer_sample HelloLankaKVS
```

### 2.3.4. kvs_gstreamer_sample

```bash
cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1/build_xxx

./kvs_gstreamer_sample HelloLankaKVS -w 640 -h 480 -f 30 -b 500
```

### 2.3.5. gst-launch-1.0 and kvssink

| name                    | desc                                                         |                                                     |
| ----------------------- | ------------------------------------------------------------ | --------------------------------------------------- |
| stream-name             | Name of the destination stream                               | DEFAULT_STREAM_NAME "DEFAULT_STREAM"                |
| user-agent              | Name of the user agent                                       | KVS_CLIENT_USER_AGENT_NAME "AWS-SDK-KVS-CPP-CLIENT" |
| retention-period        | Length of time stream is preserved. Unit: hours              | 0                                                   |
| streaming-type          | Streaming type                                               |                                                     |
| content-type            | content type                                                 |                                                     |
| max-latency             | Max Latency. Unit: seconds                                   |                                                     |
| fragment-duration       | Fragment Duration. Unit: miliseconds                         |                                                     |
| timecode-scale          | Timecode Scale. Unit: milliseconds                           |                                                     |
| key-frame-fragmentation | If true, generate new fragment on each keyframe, otherwise generate new fragment on first keyframe after fragment-duration has passed. |                                                     |
| frame-timecodes         | Do frame timecodes                                           |                                                     |
| absolute-fragment-times | Use absolute fragment time                                   |                                                     |
| fragment-acks           | Do fragment acks                                             |                                                     |
| restart-on-error        | Do restart on error                                          |                                                     |
| recalculate-metrics     | Do recalculate metrics                                       |                                                     |
| framerate               | Framerate                                                    |                                                     |
| avg-bandwidth-bps       | Average bandwidth bps                                        |                                                     |
| buffer-duration         | Buffer duration. Unit: seconds                               | 120                                                 |
| replay-duration         | Replay duration. Unit: seconds                               | 40                                                  |
| connection-staleness    | Connection staleness. Unit: seconds                          |                                                     |
| codec-id                | Codec ID                                                     |                                                     |
| track-name              | Track name                                                   |                                                     |
| access-key              | AWS Access Key                                               |                                                     |
| secret-key              | AWS Secret Key                                               |                                                     |
| session-token           | AWS Session token                                            |                                                     |
| aws-region              | AWS Region                                                   |                                                     |
| rotation-period         | Rotation Period. Unit: seconds                               |                                                     |
| log-config              | Log Configuration Path                                       | DEFAULT_LOG_FILE_PATH "../kvs_log_configuration"    |
| storage-size            | Storage Size. Unit: MB                                       |                                                     |
| stop-stream-timeout     | Stop stream timeout: seconds                                 |                                                     |
| connection-timeout      | Service call connection timeout: seconds                     |                                                     |
| completion-timeout      | Service call completion timeout: seconds. Should be more than connection timeout. If it isnt, SDK will override with defaults |                                                     |
| credential-path         | Credential File Path                                         |                                                     |
| iot-certificate         | Use aws iot certificate to obtain credentials                |                                                     |
| stream-tags             | key-value pair that you can define and assign to each stream |                                                     |
| file-start-time         | Epoch time that the file starts in kinesis video stream. By default, current time is used. Unit: Seconds |                                                     |
| disable-buffer-clipping | Set to true only if your src/mux elements produce GST_CLOCK_TIME_NONE for segment start times.  It is non-standard behavior to set this to true, only use if there are known issues with your src/mux segment start/stop times. |                                                     |
| use-original-pts        | Set to true only if you want to use the original presentation time stamp on the buffer and that timestamp is expected to be a valid epoch value in nanoseconds. Most encoders will not have a valid PTS |                                                     |
| get-kvs-metrics         | Set to true if you want to read on the producer streamMetrics and clientMetrics object every key frame. Disabled by default |                                                     |
| allow-create-stream     | Set to true if allowing create stream call, false otherwise  |                                                     |

```bash
cd /work/codebase/xbox/amazon-kinesis-video-streams-producer-sdk-cpp-3.4.1

export GST_PLUGIN_PATH=`pwd`/build_xxx
export LD_LIBRARY_PATH=`pwd`/open-source/local/lib
```

#### A. v4l2src

```bash
gst-launch-1.0 -v \
 v4l2src device=/dev/video0 \
 ! queue \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc bitrate=500 \
 ! h264parse \
 ! video/x-h264,stream-format=avc,alignment=au \
 ! kvssink stream-name=\"HelloLankaKVS\" storage-size=512 name=sink
```

#### B. v4l2src + alsasrc

```bash
gst-launch-1.0 -v \
 v4l2src device=/dev/video0 \
 ! queue \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! queue \
 ! x264enc bframes=0 speed-preset=veryfast key-int-max=60 bitrate=512 byte-stream=TRUE tune=zerolatency \
 ! video/x-h264,stream-format=byte-stream,alignment=au,profile=baseline \
 ! h264parse \
 ! kvssink stream-name="HelloLankaKVS" storage-size=128 name=sink \
 alsasrc device="hw:0,0" \
 ! queue \
 ! audioconvert \
 ! audio/x-raw,rate=24000 \
 ! voaacenc \
 ! audio/mpeg,stream-format=raw \
 ! queue \
 ! sink.
```

#### C. rtspsrc

> [RTSP.Stream](https://rtsp.stream)
>
> Please visit **RTSP.Stream** to request a test video.

```bash
RTSP_SRC="rtsp://rtspstream:49d94336abfe907ef96dc4a26c651461@zephyr.rtsp.stream/movie"

gst-launch-1.0 rtspsrc \
 location=${RTSP_SRC} protocols=tcp name=src \
 src. ! queue ! rtph264depay ! h264parse ! kvssink stream-name="HelloLankaRTSP" storage-size=512 name=sink \
 src. ! queue ! decodebin ! audioconvert ! voaacenc ! audio/mpeg,stream-format=raw ! sink.
```

## 2.4. Watch Viewer

### 2.4.1. [Kinesis Video Streams](https://ap-northeast-1.console.aws.amazon.com/)

#### A. Search Stream name

![amazon_kvsv01](./images/amazon_kvsv01.png)

#### B. Media playback

![amazon_kvsv02](./images/amazon_kvsv02.png)

## 2.5. Application

## 2.5.1. Image Extraction to S3



# 3. **Signaling channel** (WebRTC)

## 3.1. Repository

### 3.1.1. [amazon-kinesis-video-streams-pic](https://github.com/awslabs/amazon-kinesis-video-streams-pic)

> Amazon Kinesis Video Streams PIC provides the underlying tool API for the Amazon Kinesis Video Streams WebRTC SDK.

### 3.1.2. [amazon-kinesis-video-streams-producer-sdk-cpp](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp)

> Amazon Kinesis Video Streams Producer SDK for C++ is for developers to install and customize for their connected camera and other devices to securely stream video, audio, and time-encoded data to Kinesis Video Streams.

### 3.1.3. [amazon-kinesis-video-streams-webrtc-sdk-c](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c)

> Amazon Kinesis Video Streams Webrtc SDK is for developers to install and customize realtime communication between devices and enable secure streaming of video, audio to Kinesis Video Streams.

```mermaid
graph LR

	subgraph AWS
		subgraph kvs[Amazon Kinesis Video Streams]
			Signaling[Signaling] 
			STUN[STUN]
			TURN[TURN]
		end
		Lambda
		ChimeSDK[Amazon Chime SDK]
	end

  subgraph chrome1[chrome 1]
    subgraph KVS-WebRTC1[WebRTC KVS 1]
      SDP1[SDP Offer 1]
    end
  end

  subgraph chrome2[chrome 2]
    subgraph KVS-WebRTC2[WebRTC KVS 2]
      SDP2[SDP Offer 2]
    end
  end
	
	KVS-WebRTC1 <--> |WebSocket|Signaling
	KVS-WebRTC2 <--> |WebSocket|Signaling
	
	SDP2 --> |SDP, if STUN is ok| KVS-WebRTC1
	SDP1 --> |SDP, if STUN is ok| KVS-WebRTC2  
	KVS-WebRTC1 <.-> |ICE|STUN
	KVS-WebRTC2 <.-> |ICE|STUN
	
	KVS-WebRTC1 <--> |if STUN is fail|TURN
	KVS-WebRTC2 <--> |if STUN is fail|TURN
```

## 3.2. Build

>[Release 1.10.2 of the Amazon Kinesis Video WebRTC C SDK](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/releases/tag/v1.10.2)
>
>[Source code(tar.gz)](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/archive/refs/tags/v1.10.2.tar.gz)

```bash
# please download amazon-kinesis-video-streams-webrtc-sdk-c-1.10.2.tar.gz
$ rm -rf amazon-kinesis-video-streams-webrtc-sdk-c-1.10.2
$ tar -zxvf amazon-kinesis-video-streams-webrtc-sdk-c-1.10.2.tar.gz

$ cd amazon-kinesis-video-streams-webrtc-sdk-c-1.10.2
$ tree -L 1 ./
./
├── bench
├── certs
├── CMake
├── CMakeLists.txt
├── CODE_OF_CONDUCT.md
├── configs
├── CONTRIBUTING.md
├── Doxyfile
├── DoxygenLayout.xml
├── Introduction.md
├── LICENSE
├── NOTICE
├── README.md
├── samples
├── scripts
├── src
└── tst

8 directories, 9 files
```
```bash
$ cd amazon-kinesis-video-streams-webrtc-sdk-c-1.10.2

# to keep Dependencies
$ sed -i "s|  file(REMOVE_RECURSE|#  file(REMOVE_RECURSE|g" CMake/Utilities.cmake

$ (rm -rf build_xxx; mkdir -p build_xxx)

# 這邊採用原始設定
$ (cd build_xxx; cmake ..)

```
```bash
# 於 open-source 可以看到已經編譯了很多相關 libraries；
# 開發 Embedded Linux 的同仁，請查看裏面有無重複 libraries。
# libkvsCommon* from Amazon Kinesis Video Streams Producer SDK for C++
# libkvspic* from Amazon Kinesis Video Streams PIC
$ (tree -L 2 open-source/)
open-source/
├── bin
│   ├── c_rehash
│   └── openssl
├── include
│   ├── com
│   ├── libwebsockets
│   ├── libwebsockets.h
│   ├── lws_config.h
│   ├── openssl
│   ├── srtp2
│   └── usrsctp.h
├── lib
│   ├── cmake
│   ├── engines-1.1
│   ├── libcrypto.a
│   ├── libcrypto.so -> libcrypto.so.1.1
│   ├── libcrypto.so.1.1
│   ├── libkvsCommonLws.so -> libkvsCommonLws.so.1
│   ├── libkvsCommonLws.so.1 -> libkvsCommonLws.so.1.5.2
│   ├── libkvsCommonLws.so.1.5.2
│   ├── libkvspic.a
│   ├── libkvspicClient.a
│   ├── libkvspicState.a
│   ├── libkvspicUtils.a
│   ├── libsrtp2.a
│   ├── libssl.a
│   ├── libssl.so -> libssl.so.1.1
│   ├── libssl.so.1.1
│   ├── libusrsctp.a
│   ├── libwebsockets.a
│   ├── libwebsockets.so -> libwebsockets.so.19
│   ├── libwebsockets.so.19
│   └── pkgconfig
├── libkvsCommonLws
│   ├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── cmake_install.cmake
│   ├── CMakeLists.txt
│   └── Makefile
├── libopenssl
│   ├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── cmake_install.cmake
│   ├── CMakeLists.txt
│   └── Makefile
├── libsrtp
│   ├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── cmake_install.cmake
│   ├── CMakeLists.txt
│   └── Makefile
├── libusrsctp
│   ├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── cmake_install.cmake
│   ├── CMakeLists.txt
│   └── Makefile
└── libwebsockets
    ├── build
    ├── CMakeCache.txt
    ├── CMakeFiles
    ├── cmake_install.cmake
    ├── CMakeLists.txt
    ├── libwebsockets-leak-pipe-fix.patch
    ├── libwebsockets-old-gcc-fix-cast-cmakelists.patch
    └── Makefile

25 directories, 45 files
```

```bash
$ (cd build_xxx;make)
# or
$ (cd build_xxx;make VERBOSE=1)
```

```bash
$ (cd build_xxx; tree -L 1 ./)
.
├── CMakeCache.txt
├── CMakeFiles
├── cmake_install.cmake
├── h264SampleFrames
├── h265SampleFrames
├── libkvsWebrtcClient.so
├── libkvsWebrtcSignalingClient.so
├── libkvsWebRtcThreadpool.so
├── Makefile
├── opusSampleFrames
└── samples

5 directories, 6 files

$ (cd build_xxx; tree -L 1 ./samples/)
./samples/
├── CMakeFiles
├── cmake_install.cmake
├── discoverNatBehavior
├── h264SampleFrames
├── h265SampleFrames
├── kvsWebrtcClientMaster
├── kvsWebrtcClientMasterGstSample
├── kvsWebrtcClientViewer
├── kvsWebrtcClientViewerGstSample
├── Makefile
└── opusSampleFrames

4 directories, 7 files
```

### 3.3. Samples

3.3.1. kvsWebrtcClientMasterGstSample

> Channel - HelloLankaKVS
>
> LOG_LEVEL_VERBOSE=1
> LOG_LEVEL_DEBUG=2
> LOG_LEVEL_INFO=3
> LOG_LEVEL_WARN=4
> LOG_LEVEL_ERROR=5
> LOG_LEVEL_FATAL=6
> LOG_LEVEL_SILENT=7
> LOG_LEVEL_PROFILE=8

```bash
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=AKI00000000000000000
export AWS_SECRET_ACCESS_KEY=KEY0000000000000000000000000/00000000000

export AWS_KVS_LOG_LEVEL=4
export DEBUG_LOG_SDP=FALSE

./samples/kvsWebrtcClientMasterGstSample HelloLankaKVS
```

## 3.4. Watch Viewer

### 3.4.1. [KVS WebRTC Test Page](https://awslabs.github.io/amazon-kinesis-video-streams-webrtc-sdk-js/examples/index.html)

#### A. Input

![amazon_kvs02](./images/amazon_kvs02.png)

#### B. Start Viewer

![amazon_kvs03](./images/amazon_kvs03.png)

### 3.4.2. [Kinesis Video Streams](https://ap-northeast-1.console.aws.amazon.com/)

#### A. Search Signaling Channel Name

![amazon_kvs04](./images/amazon_kvs04.png)

#### B. Select Signaling Channel Name

![amazon_kvs05](./images/amazon_kvs05.png)

#### C. Start Viewer

![amazon_kvs06](./images/amazon_kvs06.png)

## 3.5. Others

### 3.5.1. [alexa-sh-camera-webrtc](https://github.com/nachawat/alexa-sh-camera-webrtc)

> Sample Alexa skill to demonstrate WebRTC Integration with AWS KVS for Camera Streaming

### 3.5.2. [kvs_webrtc_example](https://github.com/mganeko/kvs_webrtc_example)

> example of Amazon Kinesis Video Streams WebRTC

# Appendix

# I. Study

## I.1. Official - [Amazon Kinesis Video Streams (Developer Guide)](https://docs.aws.amazon.com/kinesisvideostreams/latest/dg/what-is-kinesis-video.html)

## I.2. Official - [Kinesis Video Streams (Amazon Kinesis Video Streams WebRTC Developer Guide)](https://docs.aws.amazon.com/kinesisvideostreams-webrtc-dg/latest/devguide/what-is-kvswebrtc.html)

## I.3. Official - [什麼是 Amazon Kinesis Video Streams 與 Web RTC](https://docs.aws.amazon.com/zh_tw/kinesisvideostreams-webrtc-dg/latest/devguide/what-is-kvswebrtc.html)

## I.4. [helper_WebRTC](https://github.com/lankahsu520/HelperX/blob/master/helper_WebRTC.md) - WebRTC helper.

## I.5. [ChatGPT] 有kvs播放或是管理程式嗎

> **Amazon Kinesis Video Streams (KVS)** 目前没有专门的官方第三方图形界面播放器或管理程序，但通过 AWS 提供的 SDK 和 API 以及一些开源或第三方工具，您可以实现播放和管理功能。以下是一些与 KVS 相关的播放和管理工具：
>
> ### 1. **Amazon Kinesis Video Streams Console**
> AWS 管理控制台提供了内置的 KVS 视频流管理和播放功能：
>
> - **播放功能**：您可以在 KVS 流的详情页中选择 "Play" 来查看实时或存储的视频流。
> - **管理功能**：包括查看视频流的状态、统计信息、配置流（如修改权限或删除流）。
>
> **优点**：
> - 无需额外工具，AWS 控制台即提供了基础播放和管理功能。
>
> ### 2. **KVS HLS/DASH 播放器**
> KVS 支持通过 **HLS (HTTP Live Streaming)** 或 **DASH** 播放视频，您可以使用各种播放器播放视频流。
>
> - **获取 HLS URL**：使用 AWS CLI 或 SDK 生成 HLS 播放 URL，然后在支持 HLS 的播放器中播放。
>
>   生成 HLS URL 的 CLI 命令：
>   ```bash
>   aws kinesisvideo get-hls-streaming-session-url --stream-name your-stream-name --region your-region
>   ```
>
> - **播放器**：
>   - **VLC**：直接粘贴 HLS URL 播放视频。
>   - **HLS.js / Dash.js**：开源 JavaScript 库，可以嵌入到网页中实现播放功能。
>
>   **优点**：
>   - 简单易用，支持大多数常见播放器。
>
> ### 3. **WebRTC for Real-time Video Playback**
> KVS 支持 **WebRTC**，用于实时视频传输和播放。
>
> - **KVS WebRTC SDK**：AWS 提供了用于 WebRTC 的 SDK，可以在网页或移动设备中实现实时视频的播放和互动（双向通话）。
> - **浏览器支持**：任何支持 WebRTC 的浏览器都可以与 KVS 进行实时视频通信，适合实时监控、视频会议等场景。
>
> **优点**：
> - 实现实时互动和低延迟的视频播放。
>
> ### 4. **AWS SDK for Custom Playback and Management**
> 通过 AWS 提供的 SDK（支持 Python、Java、JavaScript 等），您可以定制自己的播放器和管理程序。
>
> - **GetMedia API**：用于提取 KVS 中的视频流，并将其播放或存储。
> - **GetHLSStreamingSessionURL API**：用于获取 HLS 播放 URL，结合播放器播放。
>
>
> 您可以构建自定义的播放器或管理界面，来处理视频流并实现特定业务逻辑。
>
> ### 5. **第三方开源工具**
> 虽然没有很多专门针对 KVS 的第三方应用程序，但一些开源项目和 VMS （视频管理系统）提供了对 KVS 的支持。
>
> #### 示例：
> - **Milestone、Genetec** 等视频管理系统可以集成 KVS，用于视频监控和管理。
> - **FFmpeg**：虽然 FFmpeg 不能直接播放 KVS 流，但可以通过 AWS SDK 结合使用，用于拉取、转码和播放视频流。
>
> ### 6. **AWS Elemental Media Services**
> **AWS Elemental MediaConvert** 和 **MediaLive** 提供了对视频流的处理、转码、管理和分发功能。
>
> - **MediaConvert**：将 KVS 视频流转码为不同的格式，如 MP4。
> - **MediaLive**：用于处理实时流，可以将 KVS 输入流处理后分发给 CDN 或其他流媒体服务。
>
> ### 总结：
> 虽然目前没有专门用于 **KVS** 的图形界面播放器或管理程序，但 AWS 提供的管理控制台、HLS 播放、WebRTC 实时视频播放和 SDK 支持可以帮助您轻松实现播放和管理功能。

## I.6. [Live video streaming using Amazon S3](https://aws.amazon.com/blogs/media/live-video-streaming-using-amazon-s3/)

## I.99. YouTude

#### A. [KVS ingestion from RTSP cameras a Kinesis Video Streams tutorial | Amazon Web Services](https://www.youtube.com/watch?v=nVxwX7Q9nPU)

#### B. Kinesis Video Streams (KVS) RTSP Stream

##### B.1.  [Part 1 - Ingestion from RTSP cameras (Tutorial)](https://www.youtube.com/watch?v=YoOYTCD_v3Q)

##### B.2. [Part 2 - Image Extraction to S3 for Rekognition](https://www.youtube.com/watch?v=pUvxI76YnfA)

#### C. Building a serverless Facial Analysis system with AWS Kinesis Video Stream & AWS Rekognition

##### C.1. [PART1](https://www.youtube.com/watch?v=lMdavqoWRKc)

##### C.2. [PART2](https://www.youtube.com/watch?v=LrQt4U-CLXE)

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. gst-inspect-1.0 kvssink

```bash
$ gst-inspect-1.0 kvssink
Factory Details:
  Rank                     primary + 10 (266)
  Long-name                KVS Sink
  Klass                    Sink/Video/Network
  Description              GStreamer AWS KVS plugin
  Author                   AWS KVS <kinesis-video-support@amazon.com>

Plugin Details:
  Name                     kvssink
  Description              GStreamer AWS KVS plugin
  Filename                 /work/rootfs_intercom/lib/libgstkvssink.so
  Version                  1.0
  License                  Proprietary
  Source module            kvssinkpackage
  Binary package           GStreamer
  Origin URL               http://gstreamer.net/

GObject
 +----GInitiallyUnowned
       +----GstObject
             +----GstElement
                   +----GstKvsSink

Pad Templates:
  SINK template: 'audio_%u'
    Availability: On request
    Capabilities:
      audio/mpeg
            mpegversion: { (int)2, (int)4 }
          stream-format: raw
               channels: [ 1, 2147483647 ]
                   rate: [ 1, 2147483647 ]
      audio/x-alaw
               channels: { (int)1, (int)2 }
                   rate: [ 8000, 192000 ]
      audio/x-mulaw
               channels: { (int)1, (int)2 }
                   rate: [ 8000, 192000 ]
  
  SINK template: 'video_%u'
    Availability: On request
    Capabilities:
      video/x-h264
          stream-format: avc
              alignment: au
                  width: [ 16, 2147483647 ]
                 height: [ 16, 2147483647 ]
      video/x-h265
              alignment: au
                  width: [ 16, 2147483647 ]
                 height: [ 16, 2147483647 ]

Element has no clocking capabilities.
Element has no URI handling capabilities.

Pads:
  none

Element Properties:
  absolute-fragment-times: Use absolute fragment time
                        flags: readable, writable
                        Boolean. Default: true
  access-key          : AWS Access Key
                        flags: readable, writable
                        String. Default: "access_key"
  allow-create-stream : Set to true if allowing create stream call, false otherwise
                        flags: readable, writable
                        Boolean. Default: true
  avg-bandwidth-bps   : Average bandwidth bps
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 4194304 
  aws-region          : AWS Region
                        flags: readable, writable
                        String. Default: "us-west-2"
  buffer-duration     : Buffer duration. Unit: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 120 
  codec-id            : Codec ID
                        flags: readable, writable
                        String. Default: "V_MPEG4/ISO/AVC"
  completion-timeout  : Service call completion timeout: seconds. Should be more than connection timeout. If it isnt, SDK will override with defaults
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 10 
  connection-staleness: Connection staleness. Unit: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 60 
  connection-timeout  : Service call connection timeout: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 5 
  content-type        : content type
                        flags: readable, writable
                        String. Default: null
  credential-path     : Credential File Path
                        flags: readable, writable
                        String. Default: ".kvs/credential"
  disable-buffer-clipping: Set to true only if your src/mux elements produce GST_CLOCK_TIME_NONE for segment start times.  It is non-standard behavior to set this to true, only use if there are known issues with your src/mux segment start/stop times.
                        flags: readable, writable
                        Boolean. Default: false
  file-start-time     : Epoch time that the file starts in kinesis video stream. By default, current time is used. Unit: Seconds
                        flags: readable, writable
                        Unsigned Integer64. Range: 0 - 18446744073709551615 Default: 1728443695 
  fragment-acks       : Do fragment acks
                        flags: readable, writable
                        Boolean. Default: true
  fragment-duration   : Fragment Duration. Unit: miliseconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 2000 
  frame-timecodes     : Do frame timecodes
                        flags: readable, writable
                        Boolean. Default: true
  framerate           : Framerate
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 25 
  get-kvs-metrics     : Set to true if you want to read on the producer streamMetrics and clientMetrics object every key frame. Disabled by default
                        flags: readable, writable
                        Boolean. Default: false
  iot-certificate     : Use aws iot certificate to obtain credentials
                        flags: readable, writable
                        Boxed pointer of type "GstStructure"
  key-frame-fragmentation: If true, generate new fragment on each keyframe, otherwise generate new fragment on first keyframe after fragment-duration has passed.
                        flags: readable, writable
                        Boolean. Default: true
  log-config          : Log Configuration Path
                        flags: readable, writable
                        String. Default: "../kvs_log_configuration"
  max-latency         : Max Latency. Unit: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 60 
  name                : The name of the object
                        flags: readable, writable, 0x2000
                        String. Default: "kvssink0"
  parent              : The parent of the object
                        flags: readable, writable, 0x2000
                        Object of type "GstObject"
  recalculate-metrics : Do recalculate metrics
                        flags: readable, writable
                        Boolean. Default: true
  replay-duration     : Replay duration. Unit: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 40 
  restart-on-error    : Do restart on error
                        flags: readable, writable
                        Boolean. Default: true
  retention-period    : Length of time stream is preserved. Unit: hours
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 2 
  rotation-period     : Rotation Period. Unit: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 3600 
  secret-key          : AWS Secret Key
                        flags: readable, writable
                        String. Default: "secret_key"
  session-token       : AWS Session token
                        flags: readable, writable
                        String. Default: "session_token"
  stop-stream-timeout : Stop stream timeout: seconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 120 
  storage-size        : Storage Size. Unit: MB
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 128 
  stream-name         : Name of the destination stream
                        flags: readable, writable
                        String. Default: "DEFAULT_STREAM"
  stream-tags         : key-value pair that you can define and assign to each stream
                        flags: readable, writable
                        Boxed pointer of type "GstStructure"
  streaming-type      : Streaming type
                        flags: readable, writable
                        Enum "GstKvsSinkStreamingType" Default: 0, "realtime"
                           (0): realtime         - streaming type realtime
                           (1): near-realtime    - streaming type near realtime
                           (2): offline          - streaming type offline
  timecode-scale      : Timecode Scale. Unit: milliseconds
                        flags: readable, writable
                        Unsigned Integer. Range: 0 - 4294967295 Default: 1 
  track-name          : Track name
                        flags: readable, writable
                        String. Default: "kinesis_video"
  use-original-pts    : Set to true only if you want to use the original presentation time stamp on the buffer and that timestamp is expected to be a valid epoch value in nanoseconds. Most encoders will not have a valid PTS
                        flags: readable, writable
                        Boolean. Default: false
  user-agent          : Name of the user agent
                        flags: readable, writable
                        String. Default: "AWS-SDK-KVS-CPP-CLIENT/3.4.1"

Element Signals:
  "stream-error" :  void user_function (GstElement* object,
                                        guint64 arg0,
                                        gpointer user_data);

Element Actions:
  "fragment-ack" :  void user_function (GstElement* object,
                                        gpointer arg0);
  "stream-client-metric" :  void user_function (GstElement* object,
                                                gpointer arg0);
```



# V. Tools

## V.1. [KVS WebRTC Test Page](https://awslabs.github.io/amazon-kinesis-video-streams-webrtc-sdk-js/examples/index.html)

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
