# GStreamer
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

# 1. videotestsrc 

## 1.1. videotestsrc -> autovideosink/ximagesink

```mermaid
flowchart LR
	videotestsrc[videotestsrc]
	autovideosink[videotestsrc/ximagesink]

	videotestsrc --> autovideosink
```

```bash
gst-launch-1.0 videotestsrc \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! autovideosink

gst-launch-1.0 videotestsrc \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! ximagesink
```

# 2. audiotestsrc

## 2.1. audiotestsrc -> autoaudiosink

```mermaid
flowchart LR
	audiotestsrc[audiotestsrc]
	autoaudiosink[autoaudiosink]

	audiotestsrc --> autoaudiosink
```

```bash
$ gst-launch-1.0 audiotestsrc \
 ! audioconvert \
 ! autoaudiosink
```

# 3. filesrc

## 3.1. filesrc -> alsasink/pulsesink/autoaudiosink

```mermaid
flowchart LR
	filesrc[filesrc]
	autoaudiosink[alsasink/pulsesink/autoaudiosink]

	filesrc --> autoaudiosink
```

#### A. filesrc (wav or mp3) -> alsasink/pulsesink/autoaudiosink

```bash
export MUSIC_FILE="/work/BeethovenFurElise.mp3"
export MUSIC_FILE="/work/BeethovenFurElise.wav"

gst-launch-1.0 filesrc \
 location=$MUSIC_FILE \
 ! decodebin \
 ! audioconvert \
 ! alsasink

gst-launch-1.0 filesrc \
 location=$MUSIC_FILE \
 ! decodebin \
 ! audioconvert \
 ! pulsesink

gst-launch-1.0 filesrc \
 location=$MUSIC_FILE \
 ! decodebin \
 ! audioconvert \
 ! autoaudiosink
```

#### B. filesrc (pcm) -> autoaudiosink

```mermaid
flowchart LR
	filesrc[filesrc]
	autoaudiosink[alsasink/pulsesink/autoaudiosink]

	filesrc --> autoaudiosink
```

```bash
gst-launch-1.0 filesrc \
 location="/work/BeethovenFurElise-S16BE.pcm" \
 ! audio/x-raw,format=S16BE,channels=2,rate=44100,layout=interleaved \
 ! audioconvert \
 ! audioresample \
 ! autoaudiosink

gst-launch-1.0 filesrc \
 location="/work/BeethovenFurElise-S16LE.pcm" \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100,layout=interleaved \
 ! audioconvert \
 ! audioresample \
 ! autoaudiosink

gst-launch-1.0 filesrc \
 location="/work/BeethovenFurElise-S16LE.pcm" \
 ! rawaudioparse format=pcm pcm-format=s16le sample-rate=44100 num-channels=2 \
 ! audioconvert \
 ! autoaudiosink
```

#### C. filesrc (opus) -> autoaudiosink

> [opusSampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/opusSampleFrames)

```bash
export MUSIC_FILE="./opusSampleFrames/sample-000.opus"

gst-launch-1.0 filesrc \
 location=$MUSIC_FILE \
 ! opusparse \
 ! opusdec \
 ! alsasink
```

## 3.2. filesrc -> udpsink  ⇢ |rtpL16pay|udpsrc -> alsasink

```mermaid
flowchart LR
	filesrc[filesrc]
	udpsink[udpsink]
	udpsrc[udpsrc]
	alsasink[alsasink]

	filesrc --> udpsink ..-> |rtpL16pay,:51000| udpsrc --> |rtpL16depay| alsasink
```

> [rtpL16pay](https://gstreamer.freedesktop.org/documentation/rtp/rtpL16pay.html?gi-language=c)

#### A. filesrc (rtpL16pay) -> udpsink

```bash
export UDP_SINK="udpsink host=127.0.0.1 port=51000"
export UDP_SINK="udpsink host=192.168.56.1 port=51000"
export UDP_SINK="udpsink host=224.0.0.1 port=51000 auto-multicast=true"
export MUSIC_FILE="/work/BeethovenFurElise.mp3"

gst-launch-1.0 filesrc \
 location=$MUSIC_FILE \
 ! decodebin \
 ! audioconvert \
 ! rtpL16pay \
 ! $UDP_SINK
```

#### B. udpsrc -> |rtpL16depay| alsasink

```bash
export UDP_SRC="multicast-group=224.0.0.1 port=51000 auto-multicast=true"
export UDP_SRC="port=51000"

gst-launch-1.0 -v udpsrc \
 $UDP_SRC \
 caps='application/x-rtp, media=(string)audio, clock-rate=(int)44100, encoding-name=(string)L16, payload=(int)10' \
 ! rtpL16depay  \
 ! audioconvert \
 ! pulsesink
```

```bash
gst-launch-1.0 -v udpsrc \
 $UDP_SRC \
 caps='application/x-rtp, media=(string)audio, clock-rate=(int)44100, encoding-name=(string)L16, payload=(int)10' \
 ! rtpL16depay  \
 ! audioconvert \
 ! autoaudiosink
```

## 3.3. filesrc -> filesink

> -e, put EOS

```mermaid
flowchart LR
	filesrc[filesrc]
	filesink[filesink]

	filesrc --> filesink
```

#### A. filesrc (wav) -> filesink (pcm, S16BE)

```bash
gst-launch-1.0 -e filesrc \
 location=$MUSIC_FILE \
 ! wavparse \
 ! audioconvert \
 ! audioresample \
 ! audio/x-raw,format=S16BE,channels=2,rate=44100 \
 ! filesink location="/work/BeethovenFurElise-S16BE.pcm"
```

#### B. filesrc (wav) -> filesink (pcm, S16LE)

```bash
gst-launch-1.0 -e filesrc \
 location=$MUSIC_FILE \
 ! wavparse \
 ! audioconvert \
 ! audioresample \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100 \
 ! filesink location="/work/BeethovenFurElise-S16LE.pcm"
```

#### C. filesrc (mp3) -> filesink (pcm, S16LE)

```bash
gst-launch-1.0 -e filesrc \
 location=$MUSIC_FILE \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100 \
 ! filesink location="/work/BeethovenFurElise-S16LE.pcm"
```

#### D. filesrc (wav) -> filesink (ogg, opusenc)

```bash
gst-launch-1.0 -e filesrc \
 location=$MUSIC_FILE \
 ! wavparse \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! oggmux \
 ! filesink location="/work/BeethovenFurElise-opus.ogg"
```

#### E. filesrc (wav) -> filesink (ogg ,vorbisenc)

```bash
gst-launch-1.0 -e filesrc \
 location=$MUSIC_FILE \
 ! wavparse \
 ! audioconvert \
 ! audioresample \
 ! vorbisenc \
 ! oggmux \
 ! filesink location="/work/BeethovenFurElise-vorbis.ogg"
```

#### F. filesrc (pcm, rawaudioparse) -> filesink (wav)

> [rawaudioparse](https://gstreamer.freedesktop.org/documentation/rawparse/rawaudioparse.html?gi-language=c)

##### F.1. filesrc (pcm, S16BE)

```bash
gst-launch-1.0 -e filesrc \
 location="/work/BeethovenFurElise-S16BE.pcm" \
 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16be sample-rate=44100 num-channels=2 \
 ! audioconvert \
 ! wavenc \
 ! filesink location="/work/BeethovenFurElise.wav"
```

##### F.2. filesrc (pcm, S16LE)

```bash
gst-launch-1.0 -e filesrc \
 location="/work/BeethovenFurElise-S16LE.pcm" \
 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16le sample-rate=44100 num-channels=2 \
 ! audioconvert \
 ! wavenc \
 ! filesink location="/work/BeethovenFurElise.wav"
```

#### G. filesrc (pcm, rawaudioparse) -> filesink (ogg, opusenc)

> [rawaudioparse](https://gstreamer.freedesktop.org/documentation/rawparse/rawaudioparse.html?gi-language=c)

```bash
gst-launch-1.0 -e filesrc \
 location="/work/BeethovenFurElise-S16BE.pcm" \
 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16be sample-rate=44100 num-channels=2 \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! oggmux \
 ! filesink location="/work/BeethovenFurElise-opus.ogg"
```

#### H. filesrc (pcm, audio/x-raw) -> filesink (wav, wavenc)

```bash
gst-launch-1.0 -e filesrc \
 location="/work/BeethovenFurElise-S16LE.pcm" \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100,layout=interleaved \
 ! audioconvert \
 ! wavenc \
 ! filesink location="/work/BeethovenFurElise.wav"
```

# 4. multifilesrc

## 4.1. multifilesrc -> alsasink/pulsesink/autoaudiosink

```mermaid
flowchart LR
	multifilesrc[multifilesrc]
	autoaudiosink[alsasink/pulsesink/autoaudiosink]

	multifilesrc --> autoaudiosink
```

#### A. multifilesrc (mp3) -> alsasink

```bash
gst-launch-1.0 multifilesrc \
 location="/work/%04d.mp3" \
 ! decodebin \
 ! audioconvert \
 ! alsasink

# loop
gst-launch-1.0 multifilesrc \
 location="/work/BeethovenFurElise.mp3" loop=true \
 ! decodebin \
 ! audioconvert \
 ! alsasink

# loop
gst-launch-1.0 multifilesrc \
 location="/work/BeethovenFurElise.mp3" loop=true \
 ! decodebin \
 ! audioconvert \
 ! alsasink
```

#### B. multifilesrc (opus) -> alsasink

> [opusSampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/opusSampleFrames)

```bash
gst-launch-1.0 -e multifilesrc \
 location="./opusSampleFrames/sample-%03d.opus" start-index=1 stop-index=618 \
 ! opusparse \
 ! opusdec \
 ! alsasink

gst-launch-1.0 -e multifilesrc \
 location="./opusSampleFrames/sample-%03d.opus" \
 ! opusparse \
 ! opusdec \
 ! alsasink
```

## 4.2. multifilesrc -> autovideosink

#### A. multifilesrc (h264) -> autovideosink

> [h264SampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/h264SampleFrames)

```bash
gst-launch-1.0 -e -v multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 loop=true \
 ! h264parse \
 ! avdec_h264 ! autovideosink

```

## 4.3. multifilesrc -> filesink

#### A. multifilesrc (opus) -> filesink (ogg)

> [opusSampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/opusSampleFrames)

```bash
gst-launch-1.0 -e multifilesrc \
 location="./opusSampleFrames/sample-%03d.opus" start-index=1 \
 ! opusparse \
 ! oggmux \
 ! filesink location="./opusSampleFrames.ogg"

```

#### B. multifilesrc (h264) -> filesink (mp4)

> [h264SampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/h264SampleFrames)

```bash
gst-launch-1.0 -e -v multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 stop-index=1500 \
 ! decodebin \
 ! videoconvert \
 ! video/x-raw,width=1280,height=720,framerate=25/1 \
 ! x264enc \
 ! queue \
 ! mp4mux \
 ! queue \
 ! filesink location=./h264SampleFrames.mp4

gst-launch-1.0 -e -v multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 stop-index=1500 \
 ! h264parse \
 ! avdec_h264 \
 ! video/x-raw,width=1280,height=720,framerate=25/1 \
 ! x264enc \
 ! queue \
 ! mp4mux \
 ! queue \
 ! filesink location=./h264SampleFrames.mp4
```

#### C. multifilesrc (h264 + opus) -> filesink (mkv)

> [opusSampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/opusSampleFrames)
>
> [h264SampleFrames](https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c/tree/master/samples/h264SampleFrames)

> Caps changes are not supported by Matroska

```bash
gst-launch-1.0 -e -v \
 multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 stop-index=1500 \
 ! h264parse \
 ! avdec_h264 \
 ! video/x-raw,width=1280,height=720,framerate=25/1 \
 ! x264enc \
 ! queue \
 ! matroskamux name=mux \
 ! filesink location=./lanka520-h264andopus.mkv \
 multifilesrc \
 location="./opusSampleFrames/sample-%03d.opus" start-index=1 \
 ! opusparse \
 ! queue \
 ! mux.
```

#### D. multifilesrc (h264 + ogg) -> filesink (mp4)

```bash
gst-launch-1.0 -e -v \
 multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 stop-index=1500 \
 ! h264parse \
 ! avdec_h264 \
 ! video/x-raw,width=1280,height=720,framerate=25/1 \
 ! x264enc \
 ! queue \
 ! mp4mux name=mux \
 ! filesink location=./lanka520-h264andogg.mp4 \
 multifilesrc \
 location="./opusSampleFrames/sample-%03d.ogg" start-index=1 \
 ! oggdemux \
 ! opusparse \
 ! queue \
 ! mux.
```

#### E. multifilesrc (h264 + mp3) -> filesink (mp4)

```bash
gst-launch-1.0 -e -v \
 multifilesrc \
 location="./h264SampleFrames/frame-%04d.h264" index=1 stop-index=1500 \
 ! h264parse \
 ! avdec_h264 \
 ! video/x-raw,width=1280,height=720,framerate=25/1 \
 ! x264enc \
 ! queue \
 ! mp4mux name=mux \
 ! filesink location=./lanka520-h264andmp3.mp4 \
 filesrc \
 location="/work/BeethovenFurElise.mp3" \
 ! mpegaudioparse \
 ! queue \
 ! mux.
```

## 4.4. multifilesrc (mp3) -> udpsink(A-Law, PCMA)

```bash
gst-launch-1.0 multifilesrc \
 location="/work/BeethovenFurElise.mp3" loop=true \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! alawenc \
 ! rtppcmapay \
 ! udpsink host=127.0.0.1 port=51000

gst-launch-1.0 -v udpsrc port=51000 \
  ! 'application/x-rtp,media=audio,payload=8,clock-rate=8000,encoding-name=PCMA'  \
  ! rtppcmadepay \
  ! alawdec \
  ! audioconvert \
  ! autoaudiosink sync=false
```

# 5. appsrc

## 5.1. appsrc (i420) -> udpsink (Multicast) ⇢ udpsrc -> autovideosink

```mermaid
flowchart LR
	appsrc[appsrc]
	udpsink[udpsink]

	udpsrc[udpsrc]
	autovideosink[autovideosink]

	appsrc --> udpsink
	udpsink ..-> |224.0.0.1:50000| udpsrc
	udpsrc --> autovideosink
```
#### A. appsrc (i420) -> udpsink (Multicast, x264enc/rtph264pay) 
```bash
appsrc name=source is-live=TRUE do-timestamp=TRUE block=TRUE max-bytes=-1 emit-signals=TRUE \
	! videoparse width=720 height=480 format=i420 framerate=20/1 \
	! x264enc byte-stream=TRUE rc-lookahead=0 tune=zerolatency speed-preset=ultrafast sync-lookahead=0 bitrate=500 \
	! rtph264pay \
	! udpsink host=224.0.0.1 port=50000 auto-multicast=true
```
#### B. udpsrc -> autovideosink
```bash
gst-launch-1.0 -v udpsrc \
 multicast-group=224.0.0.1 port=50000 auto-multicast=true \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink
```
```
v=0
m=video 50000 RTP/AVP 96
c=IN IP4 224.0.0.1
a=rtpmap:96 H264/90000
```

# 6. playbin

```mermaid
flowchart LR
	uri[(http://relay.slayradio.org:800)]
	playbin[playbin]

	uri --> playbin
```

#### A. http

```bash
gst-launch-1.0 -v playbin \
 uri=http://relay.slayradio.org:8000/
```

#### B. file

```bash
gst-launch-1.0 -v playbin \
 uri=file:///work/BeethovenFurElise.mp3
```

# 7. rtmpsrc with youtube-dl

#### A. youtube-dl

```bash
#https://github.com/ytdl-org/youtube-dl
$ sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
$ sudo chmod a+rx /usr/local/bin/youtube-dl

$ youtube-dl --list-formats https://www.youtube.com/watch?v=rSgzrSyQZc0
$ youtube-dl --format "best[ext=mp4][protocol=https]" --get-url https://www.youtube.com/watch?v=rSgzrSyQZc0
```

#### B. souphttpsrc -> autovideosink

```bash
gst-launch-1.0 souphttpsrc is-live=true \
 location="$(youtube-dl --format 134 --get-url https://www.youtube.com/watch?v=rSgzrSyQZc0)" \
 ! decodebin ! videoconvert ! autovideosink
```

# 8. v4l2src

## 8.1. v4l-utils

```bash
$ sudo apt-get --yes install v4l-utils
$ v4l2-ctl --list-devices
w300: w300 (usb-0000:00:0b.0-1):
        /dev/video0
        /dev/video1

$ v4l2-ctl --all
Driver Info:
        Driver name      : uvcvideo
        Card type        : w300: w300
        Bus info         : usb-0000:00:0b.0-1
        Driver version   : 5.15.143
        Capabilities     : 0x84a00001
                Video Capture
                Metadata Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps      : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format
Priority: 2
Video input : 0 (Input 1: ok)
Format Video Capture:
        Width/Height      : 640/480
        Pixel Format      : 'YUYV' (YUYV 4:2:2)
        Field             : None
        Bytes per Line    : 1280
        Size Image        : 614400
        Colorspace        : sRGB
        Transfer Function : Rec. 709
        YCbCr/HSV Encoding: ITU-R 601
        Quantization      : Default (maps to Limited Range)
        Flags             :
Crop Capability Video Capture:
        Bounds      : Left 0, Top 0, Width 640, Height 480
        Default     : Left 0, Top 0, Width 640, Height 480
        Pixel Aspect: 1/1
Selection Video Capture: crop_default, Left 0, Top 0, Width 640, Height 480, Flags:
Selection Video Capture: crop_bounds, Left 0, Top 0, Width 640, Height 480, Flags:
Streaming Parameters Video Capture:
        Capabilities     : timeperframe
        Frames per second: 30.000 (30/1)
        Read buffers     : 0

User Controls

                     brightness 0x00980900 (int)    : min=-64 max=64 step=1 default=0 value=0
                       contrast 0x00980901 (int)    : min=0 max=64 step=1 default=32 value=32
                     saturation 0x00980902 (int)    : min=0 max=128 step=1 default=64 value=64
                            hue 0x00980903 (int)    : min=-40 max=40 step=1 default=0 value=0
        white_balance_automatic 0x0098090c (bool)   : default=1 value=1
                          gamma 0x00980910 (int)    : min=72 max=500 step=1 default=100 value=100
                           gain 0x00980913 (int)    : min=0 max=100 step=1 default=0 value=0
           power_line_frequency 0x00980918 (menu)   : min=0 max=2 default=2 value=2
                                0: Disabled
                                1: 50 Hz
                                2: 60 Hz
      white_balance_temperature 0x0098091a (int)    : min=2800 max=6500 step=1 default=4600 value=4600 flags=inactive
                      sharpness 0x0098091b (int)    : min=0 max=6 step=1 default=4 value=4
         backlight_compensation 0x0098091c (int)    : min=0 max=160 step=1 default=80 value=80

Camera Controls

                  auto_exposure 0x009a0901 (menu)   : min=0 max=3 default=3 value=3
                                1: Manual Mode
                                3: Aperture Priority Mode
         exposure_time_absolute 0x009a0902 (int)    : min=1 max=5000 step=1 default=157 value=157 flags=inactive
     exposure_dynamic_framerate 0x009a0903 (bool)   : default=0 value=1
                  iris_absolute 0x009a0911 (int)    : min=0 max=0 step=0 default=0 value=0

```

## 8.2. v4l2src -> autovideosink/ximagesink

```mermaid
flowchart LR
	v4l2src[v4l2src]
	autovideosink[videotestsrc/ximagesink]

	v4l2src --> autovideosink
```
#### A. v4l2src (not set)
```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! ximagesink

gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! clockoverlay time-format="%D %H:%M:%S" \
 ! autovideosink
```
#### B. v4l2src (video/x-raw, not set)
```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! ximagesink

gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! autovideosink 
```
#### C. v4l2src (video/x-raw, YUYV 4:2:2)
```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=YUY2 \
 ! autovideosink
```
#### D. v4l2src (image/jpeg, MJPG) 
```bash
gst-launch-1.0 -v v4l2src device=/dev/video0 \
 ! image/jpeg, width=640, height=480, framerate=30/1, format=MJPG \
 ! jpegdec \
 ! videoconvert \
 ! autovideosink
```

## 8.3. v4l2src -> udpsink/multiudpsink

#### A. v4l2src -> udpsink

```mermaid
flowchart LR
	v4l2src[v4l2src]
	udpsink[udpsink]

	v4l2src --> udpsink
```

```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! clockoverlay time-format="%D %H:%M:%S" \
 ! x264enc \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=50000
```

#### B. v4l2src -> multiudpsink
```mermaid
flowchart LR
	v4l2src[v4l2src]
	multiudpsink[multiudpsink]

	v4l2src --> multiudpsink
```

```bash
gst-launch-1.0 v4l2src device=/dev/video0 \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! clockoverlay time-format="%D %H:%M:%S" \
 ! x264enc \
 ! rtph264pay \
 ! multiudpsink clients=192.168.0.2:50000,192.168.0.3:50000,192.168.0.4:50000
```
## 8.3. v4l2src -> udpsink/multiudpsink ⇢ udpsrc
```mermaid
flowchart LR
	v4l2src[v4l2src]
	udpsink[udpsink]

	v4l2src --> udpsink
  udpsrc --> autovideosink

  udpsink ..-> udpsrc
```


```bash
$ gst-launch-1.0 -v udpsrc \
 port=50000 \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink

# 如果沒有 repeat_sequence_header=1。你就必須先啟動上面的接收指令
$ gst-launch-1.0 -e v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! queue \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=50000
```

# 9. alsasrc/autoaudiosrc

## 9.0. arecord

```bash
# check audiosrc
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

## 9.1. alsasrc -> |vorbisenc,oggmux| filesink

```mermaid
flowchart LR
	alsasrc[alsasrc]
	filesink[filesink]

	alsasrc --> |vorbisenc,oggmux| filesink
```

```bash
gst-launch-1.0 -e alsasrc \
 ! queue \
 ! audioconvert \
 ! vorbisenc \
 ! oggmux \
 ! filesink location="record-vorbis.ogg"
```

## 9.2. alsasrc -> autoaudiosink

```mermaid
flowchart LR
	alsasrc[alsasrc]
	autoaudiosink[autoaudiosink]

	alsasrc --> autoaudiosink
```

```bash
gst-launch-1.0 alsasrc \
 ! queue \
 ! audioconvert \
 ! audioresample \
 ! autoaudiosink
```

```bash
gst-launch-1.0 alsasrc \
 device="hw:0,0" \
 ! audioconvert \
 ! audioresample \
 ! autoaudiosink
```

## 9.3. autoaudiosrc -> autoaudiosink

```mermaid
flowchart LR
	autoaudiosrc[autoaudiosrc]
	autoaudiosink[autoaudiosink]

	autoaudiosrc --> autoaudiosink
```

```bash
$ gst-launch-1.0 autoaudiosrc \
 ! audioconvert \
 ! audioresample \
 ! autoaudiosink
```

# 10. rtspsrc

## 10.1. Display file metadata and stream information

```bash
$ gst-discoverer-1.0 rtsp://admin:admin@192.168.50.21:554
Analyzing rtsp://admin:admin@192.168.50.21:554
Done discovering rtsp://admin:admin@192.168.50.21:554

Topology:
  unknown: application/x-rtp
    video: H.264 (High Profile)

Properties:
  Duration: 99:99:99.999999999
  Seekable: no
  Live: yes
  Tags:
      video codec: H.264 (High Profile)
```

## 10.2. rtspsrc -> autovideosink

```mermaid
flowchart LR
	rtspsrc[rtspsrc]
	autovideosink[autovideosink]

	rtspsrc --> autovideosink
```

#### A. avdec_h264

```bash
gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! rtph264depay \
 ! avdec_h264 \
 ! autovideosink

gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! rtph264depay \
 ! video/x-h264,stream-format=avc,alignment=au \
 ! avdec_h264 \
 ! autovideosink
```

#### B. decodebin

```bash
gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! decodebin \
 ! autovideosink

gst-launch-1.0 -v rtspsrc \
 location=rtsp://admin:admin@192.168.50.21:554 protocols=4 \
 ! decodebin \
 ! autovideosink
```

#### C. decodebin -> x264enc -> decodebin

> 這邊可以用在，將 h265 轉成 h264

```bash
gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! decodebin \
 ! x264enc \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! decodebin \
 ! autovideosink
```

## 10.3. rtspsrc -> autovideosink and autoaudiosink

```mermaid
flowchart LR
	rtspsrc[rtspsrc]
	autovideosink[autovideosink]
	autoaudiosink[autoaudiosink]

	rtspsrc --> autovideosink
	rtspsrc --> autoaudiosink
```

> The file BigBuckBunny_115k.mp4 is corrupted.
>
> [RTSP.Stream](https://rtsp.stream)
>
> Please visit **RTSP.Stream** to request a test video.

```bash
#export RTSP_SRC="rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4"
export RTSP_SRC="rtsp://rtspstream:49d94336abfe907ef96dc4a26c651461@zephyr.rtsp.stream/movie"

gst-launch-1.0 rtspsrc \
 location=${RTSP_SRC} protocols=tcp name=src \
 src. ! queue ! decodebin ! videoconvert ! autovideosink \
 src. ! queue ! decodebin ! audioconvert ! audioresample ! autoaudiosink
```

```bash
export RTSP_SRC="rtsp://rtspstream:1c4480aa4712534d983c30fd483dda08@zephyr.rtsp.stream/pattern"

gst-launch-1.0 -v rtspsrc \
 location=${RTSP_SRC} \
 ! decodebin \
 ! autovideosink
```

## 10.4. rtspsrc -> udpsink (Multicast) ⇢ udpsrc -> autovideosink

```mermaid
flowchart LR
	rtspsrc[rtspsrc]
	udpsink[udpsink]

	udpsrc[udpsrc]
	autovideosink[autovideosink]

	rtspsrc --> udpsink
	udpsink ..-> |224.0.0.1:5000| udpsrc
	udpsrc --> autovideosink
```

#### A. rtspsrc -> udpsink (Multicast) 

```bash
gst-launch-1.0 rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! udpsink host=224.0.0.1 port=50000 auto-multicast=true
```

#### B. udpsrc -> autovideosink

```bash
gst-launch-1.0 -v udpsrc \
 multicast-group=224.0.0.1 port=50000 auto-multicast=true \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink
```

## 10.5. rtspsrc -> udpsink  ⇢ udpsrc -> autovideosink

```mermaid
flowchart LR
	rtspsrc[rtspsrc]
	udpsink[udpsink]

	udpsrc[udpsrc]
	autovideosink[autovideosink]

	rtspsrc --> udpsink
	udpsink ..-> |:5000| udpsrc
	udpsrc --> autovideosink
```

#### A. rtspsrc -> udpsink

```bash
gst-launch-1.0 rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! udpsink host=127.0.0.1 port=50000 sync=false -v
```

#### B. rtspsrc -> udpsink (x264enc/rtph264pay)

```bash
export VIDEO_PORT="50000"

gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 name=src \
 src. \
 ! decodebin \
 ! autovideoconvert \
 ! x264enc tune=zerolatency \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=$VIDEO_PORT
```

#### C. udpsrc -> autovideosink

```bash
export VIDEO_PORT="50000"

gst-launch-1.0 -v udpsrc \
 port=$VIDEO_PORT \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink
```

## 10.6. rtspsrc -> kvssink

```mermaid
flowchart LR
	rtspsrc[rtspsrc]
	kvssink[kvssink]

	rtspsrc --> kvssink
```

```bash
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=AKI00000000000000000
export AWS_SECRET_ACCESS_KEY=KEY0000000000000000000000000/00000000000
```

#### A. video-only

```bash
RTSP_SRC="rtsp://rtspstream:49d94336abfe907ef96dc4a26c651461@zephyr.rtsp.stream/movie"

gst-launch-1.0 rtspsrc \
 location=${RTSP_SRC} protocols=tcp \
 ! rtph264depay \
 ! h264parse \
 ! kvssink stream-name="HelloLankaRTSP" storage-size=512
```

#### B. audio-video

```bash
gst-launch-1.0 rtspsrc \
 location=${RTSP_SRC} protocols=tcp name=src \
 src. ! queue ! rtph264depay ! h264parse ! kvssink stream-name="HelloLankaRTSP" storage-size=512 name=sink \
 src. ! queue ! decodebin ! audioconvert ! voaacenc ! audio/mpeg,stream-format=raw ! sink.
```

#### C. x264enc

```bash
gst-launch-1.0 -v rtspsrc \
 location=rtsp://192.168.50.21:554 user-id=admin user-pw=admin protocols=4 \
 ! decodebin \
 ! x264enc \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! h264parse \
 ! kvssink stream-name="HelloLankaRTSP" storage-size=512
```

# 11. uridecodebin

> 使用 uridecodebin 時，比 rtspsrc 簡單化了很多

```mermaid
flowchart LR
	uri[uri]
	uridecodebin[uridecodebin]
	autovideosink[autovideosink]

	uri ..-> uridecodebin
	uridecodebin --> autovideosink
```


## 11.1. uridecodebin -> autovideosink

```bash
gst-launch-1.0 -v uridecodebin \
 uri='rtsp://admin:admin@192.168.50.21:554' \
 ! autovideosink
```

## 11.2. uridecodebin -> autovideosink and autoaudiosink

```bash
#export RTSP_SRC="rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4"
export RTSP_SRC="rtsp://rtspstream:49d94336abfe907ef96dc4a26c651461@zephyr.rtsp.stream/movie"

gst-launch-1.0 rtspsrc \
 location=${RTSP_SRC} protocols=tcp name=src \
 src. ! queue ! autovideosink \
 src. ! queue ! autoaudiosink
```

# 12. udpsrc

## 12.1. filesrc (audio) -> udpsink  ⇢ udpsrc -> ???sink

```mermaid
flowchart LR
	filesrc[filesrc]
	udpsink[udpsink]
	udpsrc[udpsrc]
	alsasink[???sink]

	filesrc --> udpsink ..-> |:51000| udpsrc --> alsasink
```
> [rtpopuspay](https://gstreamer.freedesktop.org/documentation/rtp/rtpopuspay.html?gi-language=c)

### 12.1.1. filesrc (audio) -> udpsink
```
export UDP_SINK="udpsink host=127.0.0.1 port=51000"
export UDP_SINK="udpsink host=192.168.56.1 port=51000"
export UDP_SINK="udpsink host=192.168.50.9 port=52000"
export UDP_SINK="udpsink host=192.168.50.51 port=52000"
export UDP_SINK="udpsink host=224.0.0.1 port=51000 auto-multicast=true"
```
#### A. filesrc (wav) -> udpsink (opus)
```bash
gst-launch-1.0 filesrc \
 location=/work/wav/0001.wav \
 ! wavparse \
 ! audioconvert \
 ! audioresample \
 ! opusenc ! rtpopuspay \
 ! $UDP_SINK
```
#### B. filesrc (pcm) -> udpsink (opus)
```bash
gst-launch-1.0 filesrc \
 location=./0001be.pcm \
 ! rawaudioparse use-sink-caps=false format=pcm pcm-format=s16be sample-rate=44100 num-channels=2 \
 ! audioconvert \
 ! audioresample \
 ! opusenc ! rtpopuspay \
 ! $UDP_SINK
```
#### C. filesrc (mp3) -> udpsink (opus)

```/bash
gst-launch-1.0 filesrc \
 location="/work/BeethovenFurElise.mp3" \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! opusenc ! rtpopuspay \
 ! $UDP_SINK
```

## 12.2. udpsrc (audio) -> ???sink

#### A. udpsrc (opus) -> autoaudiosink (pcm, S16LE)
```bash
export UDP_SRC="multicast-group=224.0.0.1 port=51000 auto-multicast=true"
export UDP_SRC="port=51000"

gst-launch-1.0 udpsrc \
 $UDP_SRC \
 ! application/x-rtp,payload=96,encoding-name=OPUS \
 ! rtpopusdepay  \
 ! opusdec \
 ! autoaudiosink

gst-launch-1.0 udpsrc \
 port=51000 \
 caps='application/x-rtp, media=(string)audio, payload=(int)0, clock-rate=(int)8000' \
 ! rtppcmudepay \
 ! autoaudiosink

gst-launch-1.0 udpsrc \
 $UDP_SRC \
 ! application/x-rtp,payload=96,encoding-name=OPUS \
 ! rtpopusdepay  \
 ! opusdec \
 ! queue \
 ! audioconvert \
 ! audioresample \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100 \
 ! autoaudiosink
```
#### B. udpsrc (opus) -> filesink (pcm, S16LE)
```bash
gst-launch-1.0 -e udpsrc \
 $UDP_SRC \
 ! application/x-rtp,payload=96,encoding-name=OPUS \
 ! rtpopusdepay  \
 ! opusdec \
 ! audioconvert \
 ! audioresample \
 ! audio/x-raw,format=S16LE,channels=2,rate=44100 \
 ! filesink location="0001le.pcm"
```
## 12.3. Video/Audio -> udpsink ⇢ udpsrc -> autoaudiosink
```mermaid
flowchart LR
	udpsink[udpsink]
	udpsrc[udpsrc]
	autoaudiosink[autoaudiosink]

	udpsink --> |Video:50000|udpsrc
	udpsink --> |Audio:51000|udpsrc

	udpsrc --> autoaudiosink
```
#### A. audiotestsrc and videotestsrc  -> udpsink

```bash
gst-launch-1.0 audiotestsrc \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! rtpopuspay \
 ! udpsink host=127.0.0.1 port=51000 \
 videotestsrc \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=50000
```

#### B. udpsrc -> autoaudiosink

```bash
gst-launch-1.0 -v udpsrc port=50000 \
 ! application/x-rtp,payload=96 \
 ! rtph264depay \
 ! queue \
 ! decodebin ! videoconvert ! autovideosink \
 udpsrc port=51000 \
 ! application/x-rtp,payload=97,encoding-name=OPUS \
 ! rtpopusdepay  \
 ! queue \
 ! opusdec \
 ! autoaudiosink
```
# 13. [Raspberry Pi] [libcamerasrc](https://libcamera.org/index.html)

> https://git.libcamera.org/libcamera/libcamera.git

```bash
$ git clone https://git.libcamera.org/libcamera/libcamera.git
$ cd libcamera
$ mkdir build_xxx
$ meson setup build_xxx
$ ninja -C build_xxx
$ ninja -C build_xxx install
```

## 13.1. libcamerasrc -> |x264enc,???| filesink

> 使用 x264 庫進行 H.264 軟件編碼。x264 是一種流行的開源 H.264 編碼器，提供了豐富的編碼參數和質量控制選項。

#### A. libcamerasrc -> |x264enc,h264| filesink

```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	filesink[filesink]

	libcamerasrc --> |x264enc,h264| filesink
```

```bash
# libcamerasrc -> |x264enc,h264| filesink
# -e, put EOS 
$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! queue \
 ! filesink location=libcamerasrc-x264.h264

# filesrc -> autovideosink
$ gst-launch-1.0 -v filesrc \
 location="./libcamerasrc-x264.h264" \
 ! decodebin \
 ! videoconvert \
 ! autovideosink
```

#### B. libcamerasrc -> |x264enc,mp4| filesink
```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	filesink[filesink]

	libcamerasrc --> |x264enc,mp4| filesink
```


```bash
# libcamerasrc -> |x264enc,mp4| filesink
$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! x264enc \
 ! mp4mux \
 ! queue \
 ! filesink location=libcamerasrc-x264.mp4

$ gst-launch-1.0 -v filesrc \
 location="./libcamerasrc-x264.mp4" \
  ! decodebin \
  ! videoconvert \
  ! autovideosink
```

## 13.2. libcamerasrc -> |v4l2h264enc,???| filesink

> 使用 V4L2 接口提供的硬件編碼器進行 H.264 編碼。這意味著它通常會直接利用設備上的硬件編碼器，比如一些支持 H.264 編碼的硬件視頻編碼器。

#### A. libcamerasrc -> |v4l2h264enc,h264| filesink

```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	filesink[filesink]

	libcamerasrc --> |v4l2h264enc,h264| filesink
```

```bash
# libcamerasrc -> |v4l2h264enc,h264| filesink
$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc \
 ! 'video/x-h264,level=(string)4' \
 ! filesink location=libcamerasrc-v4l2.h264

$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc \
 ! 'video/x-h264,level=(string)4' \
 ! filesink location=libcamerasrc-v4l2.h264

# filesrc -> autovideosink
$ gst-launch-1.0 -v filesrc \
 location="libcamerasrc-v4l2.h264" \
  ! decodebin \
  ! videoconvert \
  ! autovideosink
```

#### B. libcamerasrc -> |v4l2h264enc,mp4| filesink
```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	filesink[filesink]

	libcamerasrc --> |v4l2h264enc,h264| filesink
```
```bash
# libcamerasrc -> |v4l2h264enc,mp4| filesink
$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc \
 ! 'video/x-h264,profile=high,level=(string)4' \
 ! h264parse \
 ! mp4mux \
 ! queue \
 ! filesink location=libcamerasrc-v4l2.mp4

# filesrc -> autovideosink
$ gst-launch-1.0 -v filesrc \
 location="libcamerasrc-v4l2.mp4" \
 ! decodebin \
 ! videoconvert \
 ! autovideosink
```

# 14. [gst-rtsp-server](https://github.com/GStreamer/gst-rtsp-server)

> RTSP server based on GStreamer (>= 1.19). This module has been merged into the main GStreamer repo for further development.

## 14.1. Build

```bash
$ git clone https://github.com/GStreamer/gst-rtsp-server.git
$ cd gst-rtsp-server
$ mkdir build_xxx
$ meson setup build_xxx
$ ninja -C build_xxx
$ ninja -C build_xxx install

$ cd build_xxx/examples
# audio (A-Law, PCMA) + video (H.264, Constrained Baseline Profile) -> rtspsink
$ ./test-video

# video (H.264, Constrained Baseline Profile) -> rtspsink
$ ./test-launch "( \
 videotestsrc \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"

# audio (Mu-Law) + video (H.264, Constrained Baseline Profile) -> rtspsink
$ ./test-launch "( \
 audiotestsrc \
 ! audioconvert \
 ! audioresample \
 ! mulawenc \
 ! rtppcmupay name=pay1 pt=0 \
 videotestsrc \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

```bash
$ gst-launch-1.0 rtspsrc \
 location="rtsp://127.0.0.1:8554/test" name=src \
 src. ! queue ! decodebin ! videoconvert ! autovideosink \
 src. ! queue ! decodebin ! audioconvert ! audioresample ! autoaudiosink

$ gst-launch-1.0 rtspsrc \
 location=rtsp://127.0.0.1:8554/test \
 ! decodebin \
 ! videoconvert ! autovideosink

$ gst-launch-1.0 -v rtspsrc \
 location=rtsp://127.0.0.1:8554/test \
 ! rtph265depay \
 ! h265parse \
 ! fakesink

$ gst-discoverer-1.0 'rtsp://127.0.0.1:8554/test'
```

## 14.2. rtspsink ⇢ rtspsrc

```mermaid
flowchart LR
	audiotestsrc[audiotestsrc]
	videotestsrc[videotestsrc]
	rtspsink[rtspsink]
	rtspsrc[rtspsrc]
	autovideosink[autovideosink]
	autoaudiosink[autoaudiosink]

	videotestsrc --> rtspsink
	audiotestsrc -->rtspsink

	rtspsrc --> autovideosink
	rtspsrc --> autoaudiosink

	rtspsink ..-> rtspsrc
```

### 14.2.1. audio + video (H.264)

#### A. audio (A-Law, PCMA) + video (H.264, Constrained Baseline Profile) -> rtspsink

```bash
DO_COMMAND_ARG_PCMA_H264=" \
 multifilesrc location=/work/BeethovenFurElise.mp3 loop=true \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! alawenc \
 ! rtppcmapay name=pay1 pt=8 \
 videotestsrc \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 "

./test-launch "$DO_COMMAND_ARG_PCMA_H264"
```

#### B. audio (Mu-Law, PCMU) + video (H.264, Constrained Baseline Profile) -> rtspsink

```bash
DO_COMMAND_ARG_PCMU_H264=" \
 multifilesrc location=/work/BeethovenFurElise.mp3 loop=true \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! mulawenc \
 ! rtppcmupay name=pay1 pt=0 \
 videotestsrc \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 "

./test-launch "$DO_COMMAND_ARG_PCMU_H264"
```

#### C. audio (Opus) + video (H.264, Constrained Baseline Profile) -> rtspsink

```bash
DO_COMMAND_ARG_OPUS_H264=" \
 multifilesrc location=/work/BeethovenFurElise.mp3 loop=true \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! rtpopuspay name=pay1 pt=97 \
 videotestsrc \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 "

./test-launch "$DO_COMMAND_ARG_OPUS_H264"
```

### 14.2.2. audio + video (H.265)

#### D.  audio (A-Law, PCMA) + video (H.265) -> rtspsink

```bash
DO_COMMAND_ARG_PCMA_H265=" \
 multifilesrc location=/work/BeethovenFurElise.mp3 loop=true \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! alawenc \
 ! rtppcmapay name=pay1 pt=8 \
 videotestsrc \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x265enc tune=zerolatency \
 ! h265parse config-interval=-1 \
 ! rtph265pay name=pay0 pt=96 \
 "

./test-launch "$DO_COMMAND_ARG_PCMA_H265"
```

## 14.3. v4l2src -> |x264enc| ???sink

#### A. v4l2src -> rtspsink

```mermaid
flowchart LR
	v4l2src[v4l2src]
	rtspsink[rtspsink]

	v4l2src --> |x264enc|rtspsink
```

```bash
$ export CAMERA_DEVICE=/dev/video0
$ cd build_xxx/examples
$ ./test-launch --gst-debug=1 "( \
 v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

#### B. v4l2src -> udpsink

```bash
$ gst-launch-1.0 -v udpsrc \
 port=50000 \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink

# 如果沒有 repeat_sequence_header=1。你就必須先啟動上面的接收指令
$ gst-launch-1.0 -e v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! queue \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=50000
```

## 14.4. [Raspberry Pi] libcamerasrc -> |???| ???sink

#### A. libcamerasrc -> |x264enc| rtspsink

```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	rtspsink[rtspsink]

	libcamerasrc --> |x264enc|rtspsink
```

```bash
$ ./test-launch --gst-debug=1 "( \
 libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

#### B. libcamerasrc -> |v4l2h264enc| rtspsink
```mermaid
flowchart LR
	libcamerasrc[libcamerasrc]
	rtspsink[rtspsink]

	libcamerasrc --> |v4l2h264enc|rtspsink
```
> always hang at 1st frame，穩定度不高，時好時壞

```bash
$ ./test-launch --gst-debug=3 "( \
 libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc extra-controls=\"controls,repeat_sequence_header=1\" \
 ! video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline \
 ! queue \
 ! rtph264pay name=pay0 pt=96 \
 )"

$ ./test-launch --gst-debug=3 "( \
 libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc output-io-mode=2 extra-controls=\"controls,force_key_frame=1,video_b_frames=1,h264_i_frame_period=1,repeat_sequence_header=1\" \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! queue \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

#### C. libcamerasrc -> |v4l2h264enc| udpsink

> 輔助測試用。

```bash
$ gst-launch-1.0 -v udpsrc \
 port=50000 \
 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96' \
 ! rtph264depay \
 ! decodebin \
 ! videoconvert \
 ! autovideosink

# 如果沒有 repeat_sequence_header=1。你就必須先啟動上面的接收指令
$ gst-launch-1.0 -e libcamerasrc \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! v4l2h264enc extra-controls="controls,repeat_sequence_header=1" \
 ! 'video/x-h264,stream-format=byte-stream,level=(string)4,profile=baseline' \
 ! queue \
 ! rtph264pay \
 ! udpsink host=127.0.0.1 port=50000
```

## 14.5. alsasrc/autoaudiosrc and v4l2src -> |x264enc,opusenc| rtspsink

```mermaid
flowchart LR
	alsasrc[alsasrc/autoaudiosrc]
	v4l2src[v4l2src]
	rtspsink[rtspsink]

	alsasrc --> rtspsink
	v4l2src --> rtspsink
```

#### A. [Raspberry Pi] alsasrc/autoaudiosrc and libcamerasrc -> rtspsink

> 穩定度不高，時好時壞

```bash
$ cd build_xxx/examples
$ ./test-launch --gst-debug=1 "( \
	alsasrc \
	! queue \
	! audioconvert \
	! audioresample \
	! opusenc \
	! rtpopuspay name=pay1 pt=97 \
	libcamerasrc \
	! videoconvert \
	! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
	! clockoverlay time-format=\"%D %H:%M:%S\" \
	! x264enc \
	! rtph264pay name=pay0 pt=96 \
	)"

$ ./test-launch --gst-debug=1 "( \
	autoaudiosrc \
	! queue \
	! audioconvert \
	! audioresample \
	! opusenc \
	! rtpopuspay name=pay1 pt=97 \
	libcamerasrc \
	! videoconvert \
	! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
	! clockoverlay time-format=\"%D %H:%M:%S\" \
	! x264enc \
	! rtph264pay name=pay0 pt=96 \
	)"
```

#### B. autoaudiosrc and v4l2src -> rtspsink

```bash
$ export CAMERA_DEVICE=/dev/video0
$ ./test-launch --gst-debug=1 "( \
 autoaudiosrc \
 ! queue \
 ! audioconvert \
 ! volume volume=1.0 \
 ! audioresample \
 ! queue \
 ! opusenc \
 ! rtpopuspay name=pay1 pt=97 \
 v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! queue \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

## 14.6.  filesrc/multifilesrc and v4l2src -> |x264enc,opusenc| rtspsink

```mermaid
flowchart LR
	filesrc[filesrc/multifilesrc]
	v4l2src[v4l2src]
	rtspsink[rtspsink]

	filesrc --> rtspsink
	v4l2src --> rtspsink
```

#### A. filesrc and v4l2src -> rtspsink


```bash
$ export CAMERA_DEVICE=/dev/video0
$ cd build_xxx/examples
$ ./test-launch --gst-debug=1 "( \
 filesrc location="/work/BeethovenFurElise.mp3" \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! rtpopuspay name=pay1 pt=97 \
 v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

#### B. multifilesrc and v4l2src -> rtspsink

```bash
$ export CAMERA_DEVICE=/dev/video0
$ cd build_xxx/examples
$ ./test-launch --gst-debug=1 "( \
 multifilesrc location="/work/BeethovenFurElise.mp3" loop=true \
 ! queue \
 ! decodebin \
 ! audioconvert \
 ! audioresample \
 ! opusenc \
 ! rtpopuspay name=pay1 pt=97 \
 v4l2src device=$CAMERA_DEVICE \
 ! videoconvert \
 ! video/x-raw,width=640,height=480,framerate=30/1,format=I420 \
 ! clockoverlay time-format=\"%D %H:%M:%S\" \
 ! x264enc \
 ! rtph264pay name=pay0 pt=96 \
 )"
```

# Appendix

# I. Study

## I.1. gstreamer

### I.1.1. [Core Library](https://gstreamer.freedesktop.org/documentation/gstreamer/gi-index.html?gi-language=c#core-library)

### 1.1.2. [API reference](https://gstreamer.freedesktop.org/documentation/libs.html?gi-language=c)

### 1.1.3. [Plugins](https://gstreamer.freedesktop.org/documentation/plugins_doc.html?gi-language=c)

#### [h264parse](https://gstreamer.freedesktop.org/documentation/videoparsersbad/h264parse.html#h264parse)

[queue](https://gstreamer.freedesktop.org/documentation/coreelements/queue.html?gi-language=c#queue-page)

#### [rtph264depay](https://gstreamer.freedesktop.org/documentation/rtp/rtph264depay.html#rtph264depay)

#### [rtph265pay](https://gstreamer.freedesktop.org/documentation/rtp/rtph265pay.html#rtph265pay)

#### [rtpopusdepay](https://gstreamer.freedesktop.org/documentation/rtp/rtpopusdepay.html#rtpopusdepay)

#### [rtspsrc](https://gstreamer.freedesktop.org/documentation/rtsp/rtspsrc.html#rtspsrc)

#### [videoconvert](https://gstreamer.freedesktop.org/documentation/videoconvertscale/videoconvert.html#videoconvert)

#### [x264enc](https://gstreamer.freedesktop.org/documentation/x264/index.html#x264enc)

#### [x265enc](https://gstreamer.freedesktop.org/documentation/x265/index.html?gi-language=c#x265enc-page)

# II. Debug

## II.1. sudo: add-apt-repository: command not found

```bash
sudo apt update
sudo apt install software-properties-common
```

## II.2. Caps changes are not supported by Matroska

> matroskamux 不支援變動的 Caps，例如 width 和 height 有變更。
>
> 建議可改用 mp4mux。

## II.3.  no element "x265enc"

```bash
sudo apt install gstreamer1.0-libav gstreamer1.0-plugins-bad

```

# III. Glossary

# IV. Tool Usage

## IV.1. gst-launch-1.0 Usage

```bash
$ gst-launch-1.0 --help
Usage:
  gst-launch-1.0 [OPTION…] PIPELINE-DESCRIPTION

Help Options:
  -h, --help                        Show help options
  --help-all                        Show all help options
  --help-gst                        Show GStreamer Options

Application Options:
  -t, --tags                        Output tags (also known as metadata)
  -c, --toc                         Output TOC (chapters and editions)
  -v, --verbose                     Output status information and property notifications
  -q, --quiet                       Do not print any progress information
  -m, --messages                    Output messages
  -X, --exclude=PROPERTY-NAME       Do not output status information for the specified property if verbose output is enabled (can be used multiple times)
  -f, --no-fault                    Do not install a fault handler
  -e, --eos-on-shutdown             Force EOS on sources before shutting the pipeline down
  --version                         Print version information and exit
```

## IV.2. gst-inspect-1.0 Usage

```bash
$ gst-inspect-1.0 --help
Usage:
  gst-inspect-1.0 [OPTION…] [ELEMENT-NAME | PLUGIN-NAME]

Help Options:
  -h, --help                           Show help options
  --help-all                           Show all help options
  --help-gst                           Show GStreamer Options

Application Options:
  -a, --print-all                      Print all elements
  -b, --print-blacklist                Print list of blacklisted files
  --print-plugin-auto-install-info     Print a machine-parsable list of features the specified plugin or all plugins provide.
                                       Useful in connection with external automatic plugin installation mechanisms
  --plugin                             List the plugin contents
  -t, --types                          A slashes ('/') separated list of types of elements (also known as klass) to list. (unordered)
  --exists                             Check if the specified element or plugin exists
  --atleast-version                    When checking if an element or plugin exists, also check that its version is at least the version specified
  -u, --uri-handlers                   Print supported URI schemes, with the elements that implement them
  --no-colors                          Disable colors in output. You can also achieve the same by setting'GST_INSPECT_NO_COLORS' environment variable to any value.
  --version                            Print version information and exit
```

## IV.3. v4l2-ctl Usage

```bash
$ v4l2-ctl

General/Common options:
  --all              display all information available
  -C, --get-ctrl <ctrl>[,<ctrl>...]
                     get the value of the controls [VIDIOC_G_EXT_CTRLS]
  -c, --set-ctrl <ctrl>=<val>[,<ctrl>=<val>...]
                     set the value of the controls [VIDIOC_S_EXT_CTRLS]
  -D, --info         show driver info [VIDIOC_QUERYCAP]
  -d, --device <dev> use device <dev> instead of /dev/video0
                     if <dev> starts with a digit, then /dev/video<dev> is used
                     Otherwise if -z was specified earlier, then <dev> is the entity name
                     or interface ID (if prefixed with 0x) as found in the topology of the
                     media device with the bus info string as specified by the -z option.
  -e, --out-device <dev> use device <dev> for output streams instead of the
                     default device as set with --device
                     if <dev> starts with a digit, then /dev/video<dev> is used
                     Otherwise if -z was specified earlier, then <dev> is the entity name
                     or interface ID (if prefixed with 0x) as found in the topology of the
                     media device with the bus info string as specified by the -z option.
  -E, --export-device <dev> use device <dev> for exporting DMA buffers
                     if <dev> starts with a digit, then /dev/video<dev> is used
                     Otherwise if -z was specified earlier, then <dev> is the entity name
                     or interface ID (if prefixed with 0x) as found in the topology of the
                     media device with the bus info string as specified by the -z option.
  -z, --media-bus-info <bus-info>
                     find the media device with the given bus info string. If set, then
                     -d, -e and -E options can use the entity name or interface ID to refer
                     to the device nodes.
  -h, --help         display this help message
  --help-all         all options
  --help-io          input/output options
  --help-meta        metadata format options
  --help-misc        miscellaneous options
  --help-overlay     overlay format options
  --help-sdr         SDR format options
  --help-selection   crop/selection options
  --help-stds        standards and other video timings options
  --help-streaming   streaming options
  --help-subdev      sub-device options
  --help-tuner       tuner/modulator options
  --help-vbi         VBI format options
  --help-vidcap      video capture format options
  --help-vidout      vidout output format options
  --help-edid        edid handling options
  -k, --concise      be more concise if possible.
  -l, --list-ctrls   display all controls and their values [VIDIOC_QUERYCTRL]
  -L, --list-ctrls-menus
                     display all controls and their menus [VIDIOC_QUERYMENU]
  -r, --subset <ctrl>[,<offset>,<size>]+
                     the subset of the N-dimensional array to get/set for control <ctrl>,
                     for every dimension an (<offset>, <size>) tuple is given.
  -w, --wrapper      use the libv4l2 wrapper library.
  --list-devices     list all v4l devices. If -z was given, then list just the
                     devices of the media device with the bus info string as
                     specified by the -z option.
  --log-status       log the board status in the kernel log [VIDIOC_LOG_STATUS]
  --get-priority     query the current access priority [VIDIOC_G_PRIORITY]
  --set-priority <prio>
                     set the new access priority [VIDIOC_S_PRIORITY]
                     <prio> is 1 (background), 2 (interactive) or 3 (record)
  --silent           only set the result code, do not print any messages
  --sleep <secs>     sleep <secs>, call QUERYCAP and close the file handle
  --verbose          turn on verbose ioctl status reporting
```

# V. gstreamer1.0

> [GStreamer 1.20](https://launchpad.net/~tidewise/+archive/ubuntu/gstreamer-1.20)

## V.1. apt-get install

```bash
#sudo apt-get remove *gstreamer*
sudo add-apt-repository ppa:tidewise/gstreamer-1.20
sudo apt list --upgradable
sudo apt-get upgrade
```

```bash
sudo apt-get --yes install gstreamer1.0-tools
gst-inspect-1.0 --version

#sudo apt-get --yes install gstreamer1.0
sudo apt-get --yes install gstreamer1.0-plugins-base
sudo apt-get --yes install gstreamer1.0-plugins-good
sudo apt-get --yes install gstreamer1.0-plugins-base-apps
sudo apt-get --yes install gstreamer1.0-plugins-bad 
sudo apt-get --yes install gstreamer1.0-plugins-ugly

sudo apt-get --yes install libgstreamer1.0-dev
sudo apt-get --yes install libgstreamer-plugins-base1.0-dev
sudo apt-get --yes install libgstreamer-plugins-good1.0-dev
sudo apt-get --yes install libgstreamer-plugins-bad1.0-dev

# gstreamer Missing element: H.264 (Constrained Baseline Profile) decoder
sudo apt-get --yes install gstreamer1.0-libav

# WARNING: erroneous pipeline: no element "alsasrc"
sudo apt-get --yes install gstreamer1.0-alsa
```
## V.2. Environment

```bash
export GST_PLUGIN_PATH=`pwd`
export LD_LIBRARY_PATH=`pwd`
```
- [Amazon Kinesis Video Streams CPP Producer, GStreamer Plugin and JNI](https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp)
- [GstApp.AppSrc](https://lazka.github.io/pgi-docs/GstApp-1.0/classes/AppSrc.html)
- [IPv4 Multicast Address Space Registry](https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml)

# VI. Audio Input

## VI.1. sound-recorder

```
sudo apt install gnome-sound-recorder
```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

