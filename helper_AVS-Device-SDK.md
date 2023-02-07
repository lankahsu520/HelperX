# AVS Device SDK
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

# 1. [Alexa Voice Service](https://developer.amazon.com/en-US/docs/alexa/alexa-voice-service/get-started-with-alexa-voice-service.html)

> Alexa 的官方網站。


> [AVS integration with AWS IoT](https://developer.amazon.com/en-US/docs/alexa/alexa-voice-service/deprecated-features.html)
> 	As of Nov 15, 2022, the AVS Integration with the AWS IoT program is no longer available

![avs-device-sdk-architecture](./images/avs-device-sdk-architecture.png)

![Alexa_Device_SDK_Architecture._TTH_](./images/Alexa_Device_SDK_Architecture._TTH_.png)

## 1.1. [AVS Device SDK 3.X](https://developer.amazon.com/en-US/docs/alexa/avs-device-sdk/overview.html)

# 2. [AVS Device SDK Repository](https://github.com/alexa/avs-device-sdk)

## 2.1. Depend on

- [openssl](https://www.openssl.org)
- [zlib](https://zlib.net)
- [portaudio](http://www.portaudio.com)
- [libxml2](http://xmlsoft.org)
- [libcares](https://c-ares.org)

```bash
$ sudo apt-get install libc-ares-dev
```

- [libev](http://software.schmorp.de/pkg/libev.html)

```bash
$ sudo apt-get install libev-dev
```

- [nghttp2](https://github.com/nghttp2/nghttp2) (openssl, zlib, libev, libcares)
- [curl](https://curl.haxx.se) (openssl, nghttp2)
- [libffi](https://sourceware.org/libffi)
- [glib](https://gitlab.gnome.org/GNOME/glib) (libffi, zlib)
- [orc](https://github.com/GStreamer/orc)
- [gstreamer](https://github.com/GStreamer/gstreamer) (glib)

```bash
$ sudo apt-get --yes install libgstreamer1.0-dev
$ sudo apt-get --yes install libgstreamer-plugins-base1.0-dev
$ sudo apt-get --yes install libgstreamer-plugins-good1.0-dev
$ sudo apt-get --yes install libgstreamer-plugins-bad1.0-dev
```

- gst-plugins-base
- gst-plugins-good
- gst-plugins-ugly
- [sqlite](http://www.sqlite.org)

## 2.2. Build

```bash
$ cd $HOME/sdk-folder/sdk-build
$ cmake $HOME/sdk-folder/sdk-source/avs-device-sdk \
    -DGSTREAMER_MEDIA_PLAYER=ON \
    -DPORTAUDIO=ON \
    -DPKCS11=OFF \
    -DPORTAUDIO_LIB_PATH=$PORTAUDIO_LIB_PATH \
    -DPORTAUDIO_INCLUDE_DIR=/usr/include \
    -DCMAKE_BUILD_TYPE=DEBUG

$ make SampleApp
```

# 3. Register A Device - [Amazon Developer](https://developer.amazon.com/alexa/console/avs/products)


## 3.1. Get config.json

```json
{
 "deviceInfo": {
  "clientId": "your clientid",
  "productId": "your product id"
 }
}
```
## 3.2. Set up your SDK configuration file

```bash
cd $HOME/sdk-folder/sdk-source/avs-device-sdk/tools/Install

bash genConfig.sh \
config.json \
12345 \
$HOME/sdk-folder/db \
$HOME/sdk-folder/sdk-source/avs-device-sdk \
$HOME/sdk-folder/sdk-build/Integration/AlexaClientSDKConfig.json \
-DSDK_CONFIG_MANUFACTURER_NAME="Ubuntu" \
-DSDK_CONFIG_DEVICE_DESCRIPTION="Ubuntu"
```

# 4. Run
```bash
$ cd $HOME/sdk-folder/sdk-build/
./SampleApplications/ConsoleSampleApplication/src/SampleApp ./Integration/AlexaClientSDKConfig.json 
```

#### To relaunch the Sample App

```bash
cd $HOME/sdk-folder/sdk-build
./SampleApplications/ConsoleSampleApplication/src/SampleApp ./Integration/AlexaClientSDKConfig.json DEBUG9
```

# Appendix

# I. Study

#### A. [Alexa交叉编译 (avs-device-sdk)](https://blog.csdn.net/qq_38731735/article/details/120869805)

#### B. Official - [Build the Alexa Voice Service Device SDK](https://developer.amazon.com/en-US/docs/alexa/avs-device-sdk/build-the-sdk.html)

#### C. Official - [Build with Amazon's Newest Devices & Services](https://developer.amazon.com/en-US/alexa/devices/alexa-built-in)

#### D. [在 Raspberry Pi 上使用 AVS Device SDK 實現智慧音箱](https://ellis-wu.github.io/2019/07/15/avs-device-sdk-installation/)

#### E. [更換 AVS Device SDK 的喚醒詞](https://ellis-wu.github.io/2019/07/17/avs-device-sdk-wwe/)

#### F. [在 Raspberry Pi 上使用 AVS Device SDK 實現智慧音箱](https://ellis-wu.github.io/2019/07/15/avs-device-sdk-installation/)

# II. Debug

## II.1. configure: error: applications were requested (--enable-app) but dependencies are not met
```bash
$ sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev
$ sudo apt-get install libc-ares-dev
```

## II.2. -- Could NOT find GTest (missing: GTEST_LIBRARY GTEST_INCLUDE_DIR GTEST_MAIN_LIBRARY)

```bash
$ sudo apt-get install libgtest-dev
```

## II.3. Could NOT find LibArchive (missing: LibArchive_LIBRARY LibArchive_INCLUDE_DIR)

```bash
$ sudo apt-get install -y libarchive-dev
```

## II.4. undefined reference to symbol 'pthread_getspecific@@GLIBC_2.2.5'

- ExtensionPath.cmake

```cmake
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
```

# III. Glossary

# IV. Tool Usage


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
