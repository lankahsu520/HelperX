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

>## Using AWS for troubleshooting and diagnostics
>
>As you learn to develop applications with the AWS SDK for C++, it's also valuable to get comfortable in using both the AWS Management Console and the AWS CLI. These tools can be used interchangeably for various troubleshooting and diagnostics .
>
>The following tutorial shows you an example of these troubleshooting and diagnostics tasks. It focuses on the `Access denied` error, which can be encountered for several different reasons. The tutorial shows an example of how you might determine the actual cause of the error. It focuses on two of the possible causes: incorrect permissions for the current user and a resource that isn't available to the current user.

### 1.1.1. [Providing AWS credentials](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/credentials.html)

> 要使用 AWS 服務，都需要先建立憑證；步驟很複雜，先跳過再研究

#### A. [Credentials Providers](https://github.com/aws/aws-sdk-cpp/blob/master/Docs/Credentials_Providers.md)

```bash
$ cat ~/.aws/credentials
$ cat ~/.aws/config
```

## 1.2. [API Reference](http://sdk.amazonaws.com/cpp/api/LATEST/index.html)

## 1.3. [AWS SDKs and Tools Reference Guide](https://docs.aws.amazon.com/sdkref/latest/guide/index.html)

## 1.4. [AWS Code Examples Repository](https://github.com/awsdocs/aws-doc-sdk-examples)

# 2. [AWS Free Tier](https://aws.amazon.com/free)

> 憑證，很複雜！很複雜！很複雜！

# 3. [AWS Command Line Interface](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-welcome.html)

## 3.1. [helper_AWS-CLI.md](./helper_AWS-CLI.md)

>AWS 的文件有千萬篇（有些描述真的過於冗長，這就是我為什麼一直要寫文件，把事情簡單化），可是卻沒有說明當程式編譯完後，執行程式時要如何引用憑證。

[aws-doc-sdk-examples/README.md](https://github.com/awsdocs/aws-doc-sdk-examples/blob/main/README.md)

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

```bash
# Builds only the clients you want to use.
# dynamodb, iam, S3 and sts
$ cd build_xxx \
	&& cmake \
	-DCMAKE_BUILD_TYPE=Debug \
	-DBUILD_ONLY="dynamodb;iam;s3;sts" \
	..
```

> The core SDK module, `aws-sdk-cpp-core`, is *always* built, regardless of the value of the *BUILD_ONLY* parameter.

#### C. Myself

```makefile
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

# 5. [aws-doc-sdk-examples](https://github.com/awsdocs/aws-doc-sdk-examples)

## 5.1. [Getting started with the AWS SDK for C++ code examples](https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/getting-started-code-examples.html)

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

>## Invoke example code
>
>To invoke this example code, you must have an AWS account. For more information about creating an account, see [AWS Free Tier](https://aws.amazon.com/free/).
>
>You must also have AWS credentials configured. For steps on using the AWS Command Line Interface (AWS CLI) to configure credentials, see [CLI Configuration basics](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

## 5.2. DynamoDB applications

```bash
$ ls -al aws-doc-sdk-examples/cpp/example_code/dynamodb/*
```

#### [create_table_composite_key.cpp](./AWS/patches/dynamodb/create_table_composite_key.cpp)

```bash
$ run_create_table_composite_key
Usage:
    run_create_table_composite_key <table> <optional:region>
Where:
    table - the table to create
Example:
    run_create_table_composite_key Music
```

```bash
$ run_create_table_composite_key Music
Creating table Music with a composite primary key:
* Artist - partition key
* SongTitle - sort key
Table "Music" was created!

$ run_create_table_composite_key Music
Creating table Music with a composite primary key:
* Artist - partition key
* SongTitle - sort key
Failed to create table:Table already exists: Music
```

#### [describe_table.cpp](./AWS/patches/dynamodb/describe_table.cpp)

```bash
$ run_describe_table
Usage:
    run_describe_table <region> <table>
Where:
    region - region.
    table - the table to describe.
Examples:
    run_describe_table ap-northeast-1 Music
```
```bash
$ run_describe_table ap-northeast-1 Music
Table name  : Music
Table ARN   : arn:aws:dynamodb:ap-northeast-1:877409152866:table/Music
Status      : ACTIVE
Item count  : 4
Size (bytes): 285
Throughput
  Read Capacity : 5
  Write Capacity: 5
Attributes
  Artist (S)
  SongTitle (S)
```

#### [delete_item.cpp](./AWS/patches/dynamodb/delete_item.cpp)

```bash
$ run_delete_item
Usage:
    run_delete_item <tableName> <Artist-keyValue> <SongTitle-keyValue>
Where:
    tableName - the table to delete the item from.
    Artist-keyValue - the key value to update
    SongTitle-keyValue - the key value to update
Example:
    run_delete_item Music Lanka Lanka520520
**Warning** This program will actually delete the item that you specify!
```
```bash
$ run_delete_item Music Lanka Lanka520520
Deleting item Artist: "Lanka", SongTitle: "Lanka520520" from table Music
Artist "Lanka", SongTitle: "Lanka520520" deleted!
```

#### [delete_table.cpp](./AWS/patches/dynamodb/delete_table.cpp)

```bash
$ run_delete_table
Usage:
     run_delete_table <tableName>
Where:
    tableName - the table to delete.
Example:
    delete_table Music
**Warning** This program will actually delete the table that you specify!
```

```bash
$ run_delete_table Music
Your Table "Music was deleted!
$ run_delete_table Music
Failed to delete table: Requested resource not found: Table: Music not found
```

#### [get_item.cpp](./AWS/patches/dynamodb/get_item.cpp)

```bash
Failed to get item: The provided key element does not match the schema

Attributes
  Artist (S)
  SongTitle (S)

需要完整輸入，Partition key (Artist) 和 Sort key (SongTitle)；
原本的程式只有 Partition key (Artist)。
```

```bash
$ run_get_item
Usage:
    run_get_item <tableName> <pk> <pkval> <sk> <skval>
Where:
    tableName - the Amazon DynamoDB table from which an item is retrieved (for example, Music).
    pk - the key used in the Amazon DynamoDB table (for example, Artist).
    pkval - the key value that represents the item to get (for example, Acme Band).
    sk - the key used in the Amazon DynamoDB table (for example, SongTitle).
    skval - the key value that represents the item to get (for example, Happy Day).
Examples:
    run_get_item Music Artist Lanka SongTitle Lanka520520
```
```bash
$ run_get_item Music Artist 'Acme Band' SongTitle 'Happy Day'
Values: AlbumTitle: Songs About Life
Values: Artist: Acme Band
Values: Awards: 10
Values: SongTitle: Happy Day

$ run_get_item Music Artist 'Lanka' SongTitle 'Lanka520520'
No item found with the key Artist
```

#### list_tables.cpp

```bash
$ run_list_tables
Your DynamoDB Tables:
Music
```

#### put_item.cpp

```bash
$ run_put_item
Usage:
    <tableName> <key> <keyVal> <albumtitle> <albumtitleval> <awards> <awardsval> <Songtitle> <songtitleval>

Where:
    tableName - the Amazon DynamoDB table in which an item is placed (for example, Music3).
    key - the key used in the Amazon DynamoDB table (for example, Artist).
    keyval - the key value that represents the item to get (for example, Famous Band).
    albumTitle - album title (for example, AlbumTitle).
    AlbumTitleValue - the name of the album (for example, Songs About Life ).
    Awards - the awards column (for example, Awards).
    AwardVal - the value of the awards (for example, 10).
    SongTitle - the song title (for example, SongTitle).
    SongTitleVal - the value of the song title (for example, Happy Day).
**Warning** This program will  place an item that you specify into a table!
```
```bash
$ run_put_item Music \
	Artist 'Lanka' \
	AlbumTitle "Lanka520" \
	Awards "1" \
	SongTitle "Lanka520520"
Successfully added Item!
```

#### query_items.cpp

```bash
$ run_query_items
Usage:
    query_items <table> <partitionKeyAttributeName>=<partitionKeyValue> [projection_expression]

Where:
    table - the table to get an item from.
    partitionKeyAttributeName  - Partition Key attribute of the table.
    partitionKeyValue  - Partition Key value to query.

Example:
    query_items HelloTable Name=Namaste
    query_items Players FirstName=Mike
    query_items SiteColors Background=white "default, bold"
```
```bash
$ run_query_items Music Artist='No One You Know'
Number of items retrieved from Query: 2
******************************************************
AlbumTitle: Somewhat Famous
Artist: No One You Know
Awards: 1
SongTitle: Call Me Today
******************************************************
AlbumTitle: Somewhat Famous
Artist: No One You Know
Awards: 2
SongTitle: Howdy
```

#### scan_table.cpp

```bash
$ run_scan_table
Usage:
    scan_table <table> [projection_expression]

Where:
    table - the table to Scan.

You can add an optional projection expression (a quote-delimited,
comma-separated list of attributes to retrieve) to limit the
fields returned from the table.

Example:
    scan_table HelloTable
    scan_table SiteColors "default, bold"
```

```bash
$ run_scan_table Music
Number of items retrieved from scan: 5
******************************************************
AlbumTitle: Somewhat Famous
Artist: No One You Know
Awards: 1
SongTitle: Call Me Today
******************************************************
AlbumTitle: Somewhat Famous
Artist: No One You Know
Awards: 2
SongTitle: Howdy
******************************************************
AlbumTitle: Lanka520
Artist: Lanka
Awards: 1
SongTitle: Lanka520520
******************************************************
AlbumTitle: Songs About Life
Artist: Acme Band
Awards: 10
SongTitle: Happy Day
******************************************************
AlbumTitle: Another Album Title
Artist: Acme Band
Awards: 8
SongTitle: PartiQL Rocks
```

#### [update_item.cpp](./AWS/patches/dynamodb/update_item.cpp)

```bash
$ run_update_item
Usage:
    run_update_item <tableName> <Artist-keyValue> <SongTitle-keyValue> <attribute=value>
Where:
    tableName       - name of the table to put the item in
    Artist-keyValue - the key value to update
    SongTitle-keyValue - the key value to update
    attribute=value - attribute=updated value
Examples:
    run_update_item Music Lanka Lanka520520 AlbumTitle=Lanka520twice
```
```bash
$ run_update_item Music Lanka Lanka520520 AlbumTitle=Lanka520twice
Item was updated
```

## 5.3. S3 applications

```bash
$ ls -al aws-doc-sdk-examples/cpp/example_code/s3/*
```

#### list_buckets.cpp

```bash
$ run_list_buckets
Found 2 buckets
HelperX
utilx9
```

# 6. S3

## 6.1. [Building the SDK from source on EC2](https://github.com/aws/aws-sdk-cpp/wiki/Building-the-SDK-from-source-on-EC2) - [s3sample.cpp](./AWS/patches/s3/s3sample.cpp)

```bash
$ s3sample
 Usage: s3sample <region> <bucket> <object> <local destination path>
Example: s3sample ap-northeast-1 st-1 utilx9 demo_000.c demo_000.c_local

```

## 注意！注意！注意！

```c
request.WithBucket(argv[2]).WithKey(argv[3]);

WithBucket: bucket name
WithKey: object name not aws_access_key_id or aws_secret_access_key
^^^^^^^ 不熟悉 AWS，一開始會認為是 key or pass；結果呢？ object 才對！
只能說我不懂 AWS 的 nameing rules。
```

# 7.  [DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html) - [AWS Management Console](https://ap-northeast-1.console.aws.amazon.com/dynamodbv2/home?region=ap-northeast-1#dashboard)

## 7.1. [Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)

## 7.2. [aws_dynamo](https://github.com/devicescape/aws_dynamo) - AWS DynamoDB Library for C and C++

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

