# AWS SDK

# 1. [AWS SDK for C++](https://github.com/aws/aws-sdk-cpp)

[^使用請三思，雖然是官方提供，但是支援度和更新並不是每個功能都能完整使用或編譯。]: 
[^另外東西過大，如果只是要連個 s3 或是 dynamodb 時，讓使用者完全沒有辦法去切割不需要的東西，這對嵌入式系統開發很困擾。]: 

## 1.1. Download from git

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
$ ./prefetch_crt_dependency.sh
```

[^The AWS SDK for C++ has a dependency on cJSON. This dependency was updated to version 1.7.14 in the recent SDK updates. We would recommend to upgrade your SDK to version 1.9.67 for 1.9.x or 1.8.187 for 1.8.x. Thank @dkalinowski for reporting this issue: #1594]: 

## 1.2. Build


```bash
$ cd aws-sdk-cpp-1.10.9
$ mkdir build_xxx
$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug
	..

```

# 2. [aws-doc-sdk-examples](https://github.com/awsdocs/aws-doc-sdk-examples)



# 3. [Amazon DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStarted.html)

## 3.1. [aws_dynamo](https://github.com/devicescape/aws_dynamo) - AWS DynamoDB Library for C and C++



# Appendix

# I. Study

#### A. [C++ 的 AWS SDK 開發套件使用教學與範例](https://officeguide.cc/aws-sdk-cpp-installation-tutorial-examples/)

# II. Debug
