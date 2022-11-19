

# AWS SDK

# 1. [AWS SDK for C++ Documentation](https://docs.aws.amazon.com/sdk-for-cpp/index.html)

#### A. [Developer Guide](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/index.html)

##### A.1. [Providing AWS credentials](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/credentials.html)

> 要使用 AWS 服務，都需要先建立憑證；步驟很複雜，先跳過再研究

###### A.1.1. [Credentials Providers](https://github.com/aws/aws-sdk-cpp/blob/master/Docs/Credentials_Providers.md)

#### B. [API Reference](http://sdk.amazonaws.com/cpp/api/LATEST/index.html)

#### C. [AWS SDKs and Tools Reference Guide](https://docs.aws.amazon.com/sdkref/latest/guide/index.html)

#### D. [AWS Code Examples Repository](https://github.com/awsdocs/aws-doc-sdk-examples)

# 2. [AWS SDK for C++ Repository](https://github.com/aws/aws-sdk-cpp)

> 使用請三思，雖然是官方提供，但是支援度和更新並不是每個功能都能完整使用或編譯。GitHub 和 AWS 官網之間的文件有差異，請小心使用。

## 2.1. Download

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

## 2.2. Build


```bash
$ cd aws-sdk-cpp-1.10.9
$ mkdir build_xxx

$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug \
	..
or
# to build the Amazon monitoring, logs and S3 service package
$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug \
	-DBUILD_ONLY="monitoring;logs;s3" \
	..

$ make
$ make install
```

## 2.3. [aws-doc-sdk-examples](https://github.com/awsdocs/aws-doc-sdk-examples)



# 3. [Amazon DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStarted.html)

## 3.1. [aws_dynamo](https://github.com/devicescape/aws_dynamo) - AWS DynamoDB Library for C and C++



# 4. [AWS IoT](https://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html)

## 4.1. [aws-iot-device-sdk-cpp-v2](https://github.com/aws/aws-iot-device-sdk-cpp-v2)

 > The AWS IoT SDKs and the `aws-iot-device-sdk-cpp` are separate from this SDK. The AWS IoT Device SDK for C++ v2 is available at [`aws-iot-device-sdk-cpp-v2`](https://github.com/aws/aws-iot-device-sdk-cpp-v2) on GitHub.



# Appendix

# I. Study

#### A. [C++ 的 AWS SDK 開發套件使用教學與範例](https://officeguide.cc/aws-sdk-cpp-installation-tutorial-examples/)

# II. Debug


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

