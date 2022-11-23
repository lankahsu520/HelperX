# AWS SDK
[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]


[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues

# 1. [AWS SDK for C++ Documentation](https://docs.aws.amazon.com/sdk-for-cpp/index.html)

## 1.1. [Developer Guide](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/index.html)

### 1.1.1. [Providing AWS credentials](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/credentials.html)

> 要使用 AWS 服務，都需要先建立憑證；步驟很複雜，先跳過再研究

#### A. [Credentials Providers](https://github.com/aws/aws-sdk-cpp/blob/master/Docs/Credentials_Providers.md)

## 1.2. [API Reference](http://sdk.amazonaws.com/cpp/api/LATEST/index.html)

## 1.3. [AWS SDKs and Tools Reference Guide](https://docs.aws.amazon.com/sdkref/latest/guide/index.html)

## 1.4. [AWS Code Examples Repository](https://github.com/awsdocs/aws-doc-sdk-examples)

# 2. [AWS Free Tier](https://aws.amazon.com/free)

> 憑證，很複雜！很複雜！很複雜！

# 3. [AWS Command Line Interface](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-welcome.html)

## 3.1. [helper_AWS-CLI.md](./helper_AWS-CLI.md)

>AWS 的文件有千萬篇（有些描述真的過於冗長，這就是我為什麼一直要寫文件，把事情簡單化），可是卻沒有說明當程式編譯完後，執行程式時要如何引用憑證。
>
>其實我也是遶了一大圈，最後得到一個結果 “AWS CLI” 可以正常執行，偉大的 SDK & examples 就可以執行。

# 4. [AWS SDK for C++ Repository](https://github.com/aws/aws-sdk-cpp)

> 使用請三思，雖然是官方提供，但是支援度和更新並不是每個功能都能完整使用或編譯。GitHub 和 AWS 官網之間的文件有差異，請小心使用。
>
> AWS 文件很多，很偉大！再加一句，我有閱讀 AWS 文件困難！

## 4.1. Download

```bash
$ git clone --recurse-submodules https://github.com/aws/aws-sdk-cpp

or

$ cd aws-sdk-cpp
$ git checkout main
$ git pull origin main
$ git submodule update --init --recursive
```

```bash
$ cd aws-sdk-cpp-1.10.9
# 請一定要執行
$ ./prefetch_crt_dependency.sh
```

> The AWS SDK for C++ has a dependency on cJSON. This dependency was updated to version 1.7.14 in the recent SDK updates. We would recommend to upgrade your SDK to version 1.9.67 for 1.9.x or 1.8.187 for 1.8.x. Thank @dkalinowski for reporting this issue: #1594

### 4.1.1. code-generation/api-descriptions/*.json

### 4.1.2. [General CMake Variables and Options](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/cmake-params.html)

```cmake
ADD_CUSTOM_CLIENTS
BUILD_ONLY
BUILD_SHARED_LIBS
CPP_STANDARD
CURL_INCLUDE_DIR
CURL_LIBRARY
CUSTOM_MEMORY_MANAGEMENT
ENABLE_CURL_LOGGING
ENABLE_RTTI
ENABLE_TESTING
ENABLE_UNITY_BUILD
FORCE_CURL
FORCE_SHARED_CRT
G
MINIMIZE_SIZE
NO_ENCRYPTION
NO_HTTP_CLIENT
REGENERATE_CLIENTS
SIMPLE_INSTALL
TARGET_ARCH
USE_OPENSSL
```

## 4.2. Building the SDK

### 4.2.1. Cmake build options

#### A. All services


```bash
$ cd aws-sdk-cpp-1.10.9
$ mkdir build_xxx

$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug \
	..
```

#### B. BUILD_ONLY

```
# Builds only the clients you want to use.
# monitoring, logs and S3
$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug \
	-DBUILD_ONLY="dynamodb;iam;s3;sts" \
	..
```

> The core SDK module, `aws-sdk-cpp-core`, is *always* built, regardless of the value of the *BUILD_ONLY* parameter.

#### C. Myself

```bash
CMAKE_FLAGS += \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DBUILD_ONLY="dynamodb;iam;s3;sts"
		
cd $(SOURCE) \
&& $(PJ_SH_MKDIR) build_xxx \
&& cd build_xxx \
&& $(PJ_SH_CP) $(PJ_CMAKE_CROSS) ./build.cmake \
&& cmake \
	-DCMAKE_TOOLCHAIN_FILE=./build.cmake \
	-DCMAKE_INSTALL_PREFIX=$(SDK_ROOT_DIR) \
	-DCMAKE_PREFIX_PATH=$(SDK_ROOT_DIR) \
	$(CMAKE_FLAGS) \
	..
	#-DTARGET_ARCH=ANDROID
	#-DCMAKE_VERBOSE_MAKEFILE=ON \
	#-DCMAKE_MODULE_LINKER_FLAGS=-L$(SDK_LIB_DIR) \
	#-DCMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE=$(SDK_INC_DIR)
	#-DOPENSSL_ROOT_DIR=$(PJ_INSTALL_OPENSSL) \

```

### 4.2.2. Build

```bash
$ cd build_xxx \
	&& make
$ cd build_xxx \
	&& make install

```

# 5. Examples

## 5.1. [aws-doc-sdk-examples](https://github.com/awsdocs/aws-doc-sdk-examples)

### 5.1.1. [Getting started with the AWS SDK for C++ code examples](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/getting-started-code-examples.html)

```bash
$ git clone --recurse-submodules https://github.com/awsdocs/aws-doc-sdk-examples.git

$ cd aws-doc-sdk-examples

# dynamodb
$ cd aws-doc-sdk-examples/cpp/example_code/dynamodb 

# s3
$ cd aws-doc-sdk-examples/cpp/example_code/s3 

```

```bash
$ mkdir build_xxx \
	&& cmake \
	..

```

# 6. S3

## 6.1. [Building the SDK from source on EC2](https://github.com/aws/aws-sdk-cpp/wiki/Building-the-SDK-from-source-on-EC2)

```bash
$ ./build_xxx/s3sample
 Usage: s3sample <region> <bucket> <object> <local destination path>
Example: s3sample us-west-1 utilx9 demo_000.c demo_000.c_local

```

### 注意！注意！注意！

```c
request.WithBucket(argv[2]).WithKey(argv[3]);

WithBucket: bucket name
WithKey: object name not aws_access_key_id or aws_secret_access_key
^^^^^^^ 不熟悉 AWS，一開始會認為是 key or pass；結果呢？ object 才對！
```

# 7. [Amazon DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStarted.html)

## 7.1. [aws_dynamo](https://github.com/devicescape/aws_dynamo) - AWS DynamoDB Library for C and C++

# 8. [AWS IoT](https://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html)

## 8.1. [aws-iot-device-sdk-embedded-C](https://github.com/aws/aws-iot-device-sdk-embedded-C)

> The AWS IoT Device SDK for Embedded C (C-SDK) is a collection of C source files under the [MIT open source license](https://github.com/aws/aws-iot-device-sdk-embedded-C/blob/main/LICENSE) that can be used in embedded applications to securely connect IoT devices to [AWS IoT Core](https://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html). It contains MQTT client, HTTP client, JSON Parser, AWS IoT Device Shadow, AWS IoT Jobs, and AWS IoT Device Defender libraries. 

## 8.2. [aws-iot-device-sdk-cpp-v2](https://github.com/aws/aws-iot-device-sdk-cpp-v2)

 > The AWS IoT SDKs and the `aws-iot-device-sdk-cpp` are separate from this SDK. The AWS IoT Device SDK for C++ v2 is available at [`aws-iot-device-sdk-cpp-v2`](https://github.com/aws/aws-iot-device-sdk-cpp-v2) on GitHub.



# Appendix

# I. Study

#### A. [C++ 的 AWS SDK 開發套件使用教學與範例](https://officeguide.cc/aws-sdk-cpp-installation-tutorial-examples/)

#### B. [Building the SDK from source on EC2](https://github.com/aws/aws-sdk-cpp/wiki/Building-the-SDK-from-source-on-EC2)

# II. Debug


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

