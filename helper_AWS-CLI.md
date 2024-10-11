# [AWS Command Line Interface](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-welcome.html)
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

# 1. aws cli v2

## 1.1. Install

```bash
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```
## 1.2. Environment Variables

```bash
$ export AWS_ACCESS_KEY_ID=<access_key>
$ export AWS_SECRET_ACCESS_KEY=<secret_key>
$ export AWS_DEFAULT_REGION=us-west-2
```
```bash
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]:ap-northeast-1
Default output format [None]:json
```
#### A. AWS_SHARED_CREDENTIALS_FILE - ~/.aws/credentials

```bash
$ echo $AWS_SHARED_CREDENTIALS_FILE

$ cat ~/.aws/credentials
[default]
aws_access_key_id = 
aws_secret_access_key =
```

#### B. AWS_CONFIG_FILE - ~/.aws/config

```bash
$ echo $AWS_CONFIG_FILE

$ cat ~/.aws/config
[default]
region = ap-northeast-1
output = json
cli_binary_format=raw-in-base64-out
cli_pager =
```

###### **cli_pager**

> The following example sets the default to disable the use of a pager.
>

#### C. Others

```bash
AWS_ROLE_ARN
AWS_WEB_IDENTITY_TOKEN_FILE
AWS_ROLE_SESSION_NAME

AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

AWS_EC2_METADATA_DISABLED
```

```bash
# please set your .bash_aliases
function eval-it()
{
	DO_COMMAND="$*"
	[ ! -z "$ECHO_COMMAND" ] && echo "[${DO_COMMAND}]"
	eval ${DO_COMMAND}
}
```

## 1.3. aws Usage

```bash
$ aws --version
aws-cli/2.4.13 Python/3.8.8 Linux/5.15.0-52-generic exe/x86_64.ubuntu.20 prompt/off

$ aws

usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:

  aws help
  aws <command> help
  aws <command> <subcommand> help

aws: error: the following arguments are required: command

$ aws help
$ aws <command> help
$ aws <command> <subcommand> help

$ aws sts get-caller-identity
```

# 2. AWS Services

## 2.1. [DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html)

```mermaid
flowchart TD
	subgraph Amazon
		DynamoDB
	end

	subgraph ubuntu
  subgraph awsCli[aws cli]
		awsCliDynamodb[aws dynamodb xxx]
	end
	end
	DynamoDB <--> awsCliDynamodb

	classDef yellow fill:#FFFFCC
	classDef pink fill:#FFCCCC
	classDef blue fill:#0000FF
	classDef lightblue fill:#ADD8E6

	class DynamoDB pink
	class awsCliDynamodb pink
```

### 2.1.1. [DynamoDB Dashboard](https://eu-west-1.console.aws.amazon.com/dynamodbv2/home?region=eu-west-1#service)

### 2.1.2. [aws dynamodb xxx](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-services-dynamodb.html)

#### [create-table](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/create-table.html)

```bash
$ aws dynamodb create-table \
    --table-name Music \
    --attribute-definitions \
        AttributeName=Artist,AttributeType=S \
        AttributeName=SongTitle,AttributeType=S \
    --key-schema \
        AttributeName=Artist,KeyType=HASH \
        AttributeName=SongTitle,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --table-class STANDARD
```

```json
{
    "TableDescription": {
        "AttributeDefinitions": [
            {
                "AttributeName": "Artist",
                "AttributeType": "S"
            },
            {
                "AttributeName": "SongTitle",
                "AttributeType": "S"
            }
        ],
        "TableName": "Music",
        "KeySchema": [
            {
                "AttributeName": "Artist",
                "KeyType": "HASH"
            },
            {
                "AttributeName": "SongTitle",
                "KeyType": "RANGE"
            }
        ],
        "TableStatus": "CREATING",
        "CreationDateTime": "2022-04-13T13:19:42.957000+08:00",
        "ProvisionedThroughput": {
            "NumberOfDecreasesToday": 0,
            "ReadCapacityUnits": 5,
            "WriteCapacityUnits": 5
        },
        "TableSizeBytes": 0,
        "ItemCount": 0,
        "TableArn": "arn:aws:dynamodb:ap-northeast-1:123456789012:table/Music",
        "TableId": "25e42645-c399-4c68-aac6-f7b7084bd23e",
        "TableClassSummary": {
            "TableClass": "STANDARD"
        }
    }
}
```

```
An error occurred (ResourceInUseException) when calling the CreateTable operation: Table already exists: Music
```

#### [describe-table](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/describe-table.html)

```bash
$ aws dynamodb describe-table --table-name Music | grep TableStatus
```

```
"TableStatus": "ACTIVE",
```

#### [put-item](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/put-item.html)

```bash
$ aws dynamodb execute-statement --statement "INSERT INTO Music  \
                VALUE  \
                {'Artist':'No One You Know','SongTitle':'Call Me Today', 'AlbumTitle':'Somewhat Famous', 'Awards':'1'}"

$ aws dynamodb execute-statement --statement "INSERT INTO Music  \
                VALUE  \
                {'Artist':'No One You Know','SongTitle':'Howdy', 'AlbumTitle':'Somewhat Famous', 'Awards':'2'}"

$ aws dynamodb execute-statement --statement "INSERT INTO Music  \
                VALUE  \
                {'Artist':'Acme Band','SongTitle':'Happy Day', 'AlbumTitle':'Songs About Life', 'Awards':'10'}"
                            
$ aws dynamodb execute-statement --statement "INSERT INTO Music  \
                VALUE  \
                {'Artist':'Acme Band','SongTitle':'PartiQL Rocks', 'AlbumTitle':'Another Album Title', 'Awards':'8'}"
```

```json
{
    "Items": []
}
```

```
An error occurred (DuplicateItemException) when calling the ExecuteStatement operation: Duplicate primary key exists in table
```

#### [get-item](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/get-item.html)

```bash
$ aws dynamodb get-item --consistent-read \
    --table-name Music \
    --key '{ "Artist": {"S": "Acme Band"}, "SongTitle": {"S": "Happy Day"}}'
```

```json
{
    "Item": {
        "AlbumTitle": {
            "S": "Songs About Life"
        },
        "Awards": {
            "S": "10"
        },
        "Artist": {
            "S": "Acme Band"
        },
        "SongTitle": {
            "S": "Happy Day"
        }
    }
}
```

#### [scan](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/scan.html)

```bash
$ aws dynamodb scan --table-name Music
```

```json
{
    "Items": [
        {
            "AlbumTitle": {
                "S": "Somewhat Famous"
            },
            "Awards": {
                "S": "1"
            },
            "Artist": {
                "S": "No One You Know"
            },
            "SongTitle": {
                "S": "Call Me Today"
            }
        },
        {
            "AlbumTitle": {
                "S": "Somewhat Famous"
            },
            "Awards": {
                "S": "2"
            },
            "Artist": {
                "S": "No One You Know"
            },
            "SongTitle": {
                "S": "Howdy"
            }
        },
        {
            "AlbumTitle": {
                "S": "Songs About Life"
            },
            "Awards": {
                "S": "10"
            },
            "Artist": {
                "S": "Acme Band"
            },
            "SongTitle": {
                "S": "Happy Day"
            }
        },
        {
            "AlbumTitle": {
                "S": "Another Album Title"
            },
            "Awards": {
                "S": "8"
            },
            "Artist": {
                "S": "Acme Band"
            },
            "SongTitle": {
                "S": "PartiQL Rocks"
            }
        }
    ],
    "Count": 4,
    "ScannedCount": 4,
    "ConsumedCapacity": null
}
```

## 2.2. [EC2 (Amazon Elastic Compute Cloud)](https://docs.aws.amazon.com/zh_tw/AWSEC2/latest/UserGuide/concepts.html)

```mermaid
flowchart TD
	subgraph Amazon
		EC2
	end

	subgraph ubuntu
	subgraph awsCli[aws cli]
		awsCliEC2[aws ec2 xxx]
	end
		sshClient[ssh client]
  end
	EC2 <--> awsCliEC2
	EC2 <--> sshClient

	classDef yellow fill:#FFFFCC
	classDef pink fill:#FFCCCC
	classDef blue fill:#0000FF
	classDef lightblue fill:#ADD8E6

	class EC2 pink
	class awsCliEC2 pink
	class sshClient pink
```

### 2.2.1. [EC2 Dashboard](https://eu-west-1.console.aws.amazon.com/ec2/home?region=eu-west-1)

### 2.2.2. [aws ec2 xxx](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-services-ec2.html)

>因為本身就是虛擬運算，設定起來也較複雜，不建議使用 AWS CLI；請多加使用 Dashboard。

### 2.2.3. ec2metadata xxx

```bash
# please use ssh to link with ec2
$ ec2metadata --instance-id
i-01234567890abcdef

$ ec2metadata --instance-type
t3.medium

$ ec2metadata --public-ipv4
199.199.199.199

$ ec2metadata --public-hostname
ec2-199-199-199-199.eu-west-1.compute.amazonaws.com

or
$ curl http://169.254.169.254/latest/meta-data/public-hostname
ec2-199-199-199-199.eu-west-1.compute.amazonaws.com
```

## 2.3. [S3 (Amazon Simple Storage Service)](https://docs.aws.amazon.com/zh_tw/AmazonS3/latest/userguide/Welcome.html)

```mermaid
flowchart TD
	subgraph Amazon
		S3
	end

	subgraph ubuntu
	subgraph awsCli[aws cli]
		awsCliS3[aws s3 xxx]
	end
  end
	S3 <--> awsCliS3

	classDef yellow fill:#FFFFCC
	classDef pink fill:#FFCCCC
	classDef blue fill:#0000FF
	classDef lightblue fill:#ADD8E6

	class S3 pink
	class awsCliS3 pink
```

### 2.3.1. [S3 Dashboard](https://s3.console.aws.amazon.com/s3/buckets?region=eu-west-1)

### 2.3.2. [aws s3 xxx](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-services-s3.html)

#### [cp](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html)

> copies a single file to a specified bucket and key

```bash
$ aws s3 cp s3://utilx9/demo_000.c ./
$ aws s3 demo_000.c cp s3://utilx9
```

```bash
# to create a folder - demo
$ aws s3 demo_000.c cp s3://utilx9/demo/demo_000.c
```

#### [ls](https://docs.aws.amazon.com/cli/latest/reference/s3/ls.html)

>copies a single file to a specified bucket and key

```bash
$ aws s3 ls
$ aws s3 ls s3://utilx9
```

#### [mb](https://docs.aws.amazon.com/cli/latest/reference/s3/mb.html)

>creates a bucket

```bash
$ aws s3 mb s3://helperx
```

#### [mv](https://docs.aws.amazon.com/cli/latest/reference/s3/mv.html)

> move a file

```bash
$ aws s3 mv s3://helperx/README.md s3://helperx/README_bak.md
```

#### [rb](https://docs.aws.amazon.com/cli/latest/reference/s3/rb.html)

>removes a bucket

```bash
$ aws s3 rb s3://helperx
```

#### [rm](https://docs.aws.amazon.com/cli/latest/reference/s3/rm.html)

>deletes a single s3 object

```bash
$ aws s3 rm s3://utilx9/demo_000.c
```

#### [sync](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/sync.html)

> Syncs directories and S3 prefixes

```bash
$ aws s3 sync s3://helperx s3://helperx_Bak
```

### 2.3.3. [aws s3api](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/index.html)

#### [get-bucket-notification-configuration](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/get-bucket-notification-configuration.html)

> Returns the notification configuration of a bucket.

```bash
$ aws s3api get-bucket-notification-configuration \
	--bucket lambdax9 --output yaml

$ aws s3api get-bucket-notification-configuration \
	--bucket lambdax9 --output json

```

- s3_notification.yml

```json
LambdaFunctionConfigurations:
- Events:
  - s3:ObjectCreated:*
  - s3:ObjectRemoved:*
  Id: bbecdad0-0539-4d92-a563-1ae812316dd0
  LambdaFunctionArn: arn:aws:lambda:us-west-1:123456789012:function:LambdaHello-function-bLJNjfr7pRL5

```

#### [put-bucket-notification-configuration](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-notification-configuration.html)

>Enables notifications of specified events for a bucket.

- s3_notification.json

```bash
$ aws s3api put-bucket-notification-configuration \
	--bucket lambdax9 \
	--notification-configuration file://s3_notification.json
```

```json
{
	"LambdaFunctionConfigurations": [{
			"LambdaFunctionArn": "arn:aws:lambda:us-west-1:123456789012:function:LambdaHello-function-bLJNjfr7pRL5",
			"Events": [
				"s3:ObjectCreated:*",
				"s3:ObjectRemoved:*"
			]
		}
	]
}
```

- s3_notification_null.json

```bash
$ aws s3api put-bucket-notification-configuration \
	--bucket lambdax9 \
	--notification-configuration file://s3_notification_null.json
```

```json
{
}
```



## 2.4. [S3 Glacier](https://docs.aws.amazon.com/zh_tw/amazonglacier/latest/dev/introduction.html)

> 因為不適用正常檔案存取方式，先不花時間研究。

### 2.4.1. [S3 Glacier](https://eu-west-1.console.aws.amazon.com/sns/v3/home?region=eu-west-1#/dashboard)

### 2.4.2. [aws glacier xxx](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-services-glacier.html)

## 2.5. [SNS (Amazon Simple Notification Service)](https://docs.aws.amazon.com/zh_tw/sns/latest/dg/welcome.html)

> publish a message to AmazonSNS, then send ([protocol](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/subscribe.html)) to subscriber(s)

```mermaid
flowchart LR
	awsCli[aws sns publish]
	Lanka["lankahsu@gmail.com"]
	Mary["mary@gmail.com"]

	AmazonSNS[AmazonSNS]

	awsCli --> |publish| AmazonSNS
	Lanka <-.-> | email / arn:aws:sns:us-west-1:123456789012:lankahsu520| AmazonSNS
	Mary <-.-> | email / arn:aws:sns:us-west-1:123456789012:lankahsu520| AmazonSNS
```

### 2.5.1. [SNS Dashboard](https://eu-west-1.console.aws.amazon.com/sns/v3/home?region=eu-west-1#/dashboard)

### 2.5.2. [aws sns xxx](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-services-s3.html)

#### [create-topic](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/create-topic.html)

```bash
$ aws sns create-topic --name lankahsu520
{
    "TopicArn": "arn:aws:sns:eu-west-1:123456789012:lankahsu520"
}
```

#### [delete-topic](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/delete-topic.html)

```bash
$ aws sns delete-topic --topic-arn arn:aws:sns:eu-west-1:123456789012:lankahsu520
```

#### [subscribe](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/subscribe.html)

>The protocol that you want to use. Supported protocols include:
>- `http` – delivery of JSON-encoded message via HTTP POST
>- `https` – delivery of JSON-encoded message via HTTPS POST
>- `email` – delivery of message via SMTP
>- `email-json` – delivery of JSON-encoded message via SMTP
>- `sms` – delivery of message via SMS
>- `sqs` – delivery of JSON-encoded message to an Amazon SQS queue
>- `application` – delivery of JSON-encoded message to an EndpointArn for a mobile app and device
>- `lambda` – delivery of JSON-encoded message to an Lambda function
>- `firehose` – delivery of JSON-encoded message to an Amazon Kinesis Data Firehose delivery stream.

```bash
$ aws sns subscribe --topic-arn arn:aws:sns:us-west-1:123456789012:lankahsu520 --protocol email --notification-endpoint lankahsu@gmail.com
{
    "SubscriptionArn": "pending confirmation"
}
```

#### [list-subscriptions](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/list-subscriptions.html)

```bash
$ aws sns list-subscriptions
{
    "Subscriptions": [
        {
            "SubscriptionArn": "arn:aws:sns:eu-west-1:123456789012:lankahsu520:9aaa9c9a-8dba-45b6-999b-7871bad374d2",
            "Owner": "123456789012",
            "Protocol": "email",
            "Endpoint": "lankahsu@gmail.com",
            "TopicArn": "arn:aws:sns:eu-west-1:123456789012:lankahsu520"
        },
    ]
}
```

#### [list-topics](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/list-topics.html)

```bash
$ aws sns list-topics
```

#### [publish](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/publish.html)

```bash
$ aws sns publish --topic-arn arn:aws:sns:us-west-1:123456789012:lankahsu520 --message "Hello World!"
{
    "MessageId": "2e91a93d-8b5c-5f66-8da9-f5224ebfb6f2"
}
```

#### [unsubscribe](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/unsubscribe.html)

```bash
$ aws sns unsubscribe --subscription-arn arn:aws:sns:eu-west-1:123456789012:lankahsu520:9aaa9c9a-8dba-45b6-999b-7871bad374d2
```

#### [list-subscriptions](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sns/list-subscriptions.html)

```bash
$ aws sns list-subscriptions
{
    "Subscriptions": [
        {
            "SubscriptionArn": "arn:aws:sns:eu-west-1:123456789012:lankahsu520:9aaa9c9a-8dba-45b6-999b-7871bad374d2",
            "Owner": "123456789012",
            "Protocol": "email",
            "Endpoint": "lankahsu@gmail.com",
            "TopicArn": "arn:aws:sns:eu-west-1:123456789012:lankahsu520"
        },
    ]
}
```

## 2.6. [KVS (Kinesis Video Streams)](https://docs.aws.amazon.com/zh_tw/kinesisvideostreams/latest/dg/what-is-kinesis-video.html)

### 2.6.0. export

```bash
export AWS_KVS_STREAM_NAME=HelloLanka520
export AWS_KVS_STREAM_NAME_ARG="--stream-name ${AWS_KVS_STREAM_NAME}"

export AWS_KVS_STREAM_STARTDATE="2024-10-10"
export AWS_KVS_STREAM_STARTTIMESTAMP="${AWS_KVS_STREAM_STARTDATE}T00:00:00+08:00"
export AWS_KVS_STREAM_ENDTIMESTAMP="${AWS_KVS_STREAM_STARTDATE}T23:59:59+08:00"
export AWS_KVS_STREAM_FRAME_SEL="'{\"FragmentSelectorType\":\"SERVER_TIMESTAMP\",\"TimestampRange\": {\"StartTimestamp\":\"${AWS_KVS_STREAM_STARTTIMESTAMP}\",\"EndTimestamp\":\"${AWS_KVS_STREAM_ENDTIMESTAMP}\"}}'"
export AWS_KVS_STREAM_FRAME_SEL_ARG="--fragment-selector ${AWS_KVS_STREAM_FRAME_SEL}"

export AWS_KVS_STREAM_STARTDATE_CLIP="2024-10-10"
export AWS_KVS_STREAM_STARTTIMESTAMP_CLIP="${AWS_KVS_STREAM_STARTDATE_CLIP}T11:30:00+08:00"
export AWS_KVS_STREAM_ENDTIMESTAMP_CLIP="${AWS_KVS_STREAM_STARTDATE_CLIP}T11:40:59+08:00"
export AWS_KVS_STREAM_FRAME_SEL_CLIP="'{\"FragmentSelectorType\":\"SERVER_TIMESTAMP\",\"TimestampRange\": {\"StartTimestamp\":\"${AWS_KVS_STREAM_STARTTIMESTAMP_CLIP}\",\"EndTimestamp\":\"${AWS_KVS_STREAM_ENDTIMESTAMP_CLIP}\"}}'"
export AWS_KVS_STREAM_FRAME_SEL_CLIP_ARG="--clip-fragment-selector ${AWS_KVS_STREAM_FRAME_SEL_CLIP}"

export AWS_KVS_STREAM_ENDPOINT="https://b-fd02c7db.kinesisvideo.us-east-1.amazonaws.com"
export AWS_KVS_STREAM_ENDPOINT_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT}"

export AWS_KVS_STREAM_OUTPUT="text"
export AWS_KVS_STREAM_OUTPUT_ARG="--output ${AWS_KVS_STREAM_OUTPUT}"

export AWS_KVS_STREAM_OUTPUT_MP4=/work/HelloLanka520-${AWS_KVS_STREAM_STARTDATE}.mp4
export AWS_KVS_STREAM_OUTPUT_MKV_LAST=/work/HelloLanka520-last.mkv

echo "AWS_KVS_STREAM_STARTTIMESTAMP=${AWS_KVS_STREAM_STARTTIMESTAMP}"
echo "AWS_KVS_STREAM_ENDTIMESTAMP=${AWS_KVS_STREAM_ENDTIMESTAMP}"
echo "AWS_KVS_STREAM_ENDPOINT=${AWS_KVS_STREAM_ENDPOINT}"
```

### 2.6.1. [KVS Dashboard](https://us-east-1.console.aws.amazon.com/dashboard)

### 2.6.2. aws [kinesisvideo](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesisvideo/index.html) xxx

#### [describe-stream](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesisvideo/describe-stream.html)

> Returns the most current information about the specified stream. You must specify either the `StreamName` or the `StreamARN`.

```bash
$ DO_COMMAND="aws kinesisvideo \
 describe-stream \
 ${AWS_KVS_STREAM_NAME_ARG}"

[aws kinesisvideo describe-stream --stream-name HelloLanka520]
{
    "StreamInfo": {
        "DeviceName": "Kinesis_Video_Device",
        "StreamName": "HelloLanka520",
        "StreamARN": "arn:aws:kinesisvideo:us-east-1:",
        "MediaType": "video/h264,audio/aac",
        "KmsKeyId": "arn:aws:kms:us-east-1::",
        "Version": "",
        "Status": "ACTIVE",
        "CreationTime": "2024-10-10T11:23:20.451000+08:00",
        "DataRetentionInHours": 24
    }
}
```

#### [get-data-endpoint](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesisvideo/get-data-endpoint.html)

> Gets an endpoint for a specified stream for either reading or writing. Use this endpoint in your application to read from the specified stream (using the `GetMedia` or `GetMediaForFragmentList` operations) or write to it (using the `PutMedia` operation).

> `--api-name` (string)
>
> The name of the API action for which to get an endpoint.
> 
> Possible values:
> 
> - `PUT_MEDIA`

```bash
```

> - `GET_MEDIA`

```bash
export AWS_KVS_STREAM_ENDPOINT_MEDIA=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_MEDIA`
export AWS_KVS_STREAM_ENDPOINT_MEDIA_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_MEDIA}"
```

> - `LIST_FRAGMENTS`

```bash
export AWS_KVS_STREAM_ENDPOINT_LIST=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name LIST_FRAGMENTS`
export AWS_KVS_STREAM_ENDPOINT_LIST_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_LIST}"
```

> - `GET_MEDIA_FOR_FRAGMENT_LIST`

```bash

```

> - `GET_HLS_STREAMING_SESSION_URL`

```bash
export AWS_KVS_STREAM_ENDPOINT_HLS=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_HLS_STREAMING_SESSION_URL`
export AWS_KVS_STREAM_ENDPOINT_HLS_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_HLS}"
```

> - `GET_DASH_STREAMING_SESSION_URL`

```
```

> - `GET_CLIP`

```bash
export AWS_KVS_STREAM_ENDPOINT_CLIP=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_CLIP`
export AWS_KVS_STREAM_ENDPOINT_CLIP_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_CLIP}"
```

> - `GET_IMAGES`

```bash
export AWS_KVS_STREAM_ENDPOINT_IMAGES=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_IMAGES`
export AWS_KVS_STREAM_ENDPOINT_IMAGES_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_IMAGES}"
```

### 2.6.3. aws [kinesis-video-archived-media](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis-video-archived-media/index.html) xxx

#### [get-clip](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis-video-archived-media/get-clip.html)

> Downloads an MP4 file (clip) containing the archived, on-demand media from the specified video stream over the specified time range.

> must have endpoint-url

```bash
export AWS_KVS_STREAM_ENDPOINT_CLIP=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_CLIP`
export AWS_KVS_STREAM_ENDPOINT_CLIP_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_CLIP}"
```

```bash
$ DO_COMMAND="aws kinesis-video-archived-media \
 get-clip \
 ${AWS_KVS_STREAM_NAME_ARG} \
 ${AWS_KVS_STREAM_ENDPOINT_CLI_ARG} \
 ${AWS_KVS_STREAM_FRAME_SEL_CLIP_ARG} \
 ${AWS_KVS_STREAM_OUTPUT_MP4}"

$ eval-it $DO_COMMAND
[aws kinesis-video-archived-media get-clip --stream-name HelloLanka520 --endpoint-url https://b-fd02c7db.kinesisvideo.us-east-1.amazonaws.com --clip-fragment-selector '{"FragmentSelectorType":"SERVER_TIMESTAMP","TimestampRange": {"StartTimestamp":"2024-10-10T11:30:00+08:00","EndTimestamp":"2024-10-10T11:40:59+08:00"}}' /work/HelloLanka520-2024-10-10.mp4]
{
    "ContentType": "video/mp4"
}
```

#### [list-fragments](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis-video-archived-media/list-fragments.html)

> Returns a list of Fragment objects from the specified stream and timestamp range within the archived data

> must have endpoint-url

```bash
export AWS_KVS_STREAM_ENDPOINT_LIST=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name LIST_FRAGMENTS`
export AWS_KVS_STREAM_ENDPOINT_LIST_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_LIST}"
```

```bash
$ DO_COMMAND="aws kinesis-video-archived-media \
 list-fragments \
 ${AWS_KVS_STREAM_NAME_ARG} \
 ${AWS_KVS_STREAM_ENDPOINT_LIST_ARG} \
 ${AWS_KVS_STREAM_FRAME_SEL_ARG} \
 ${AWS_KVS_STREAM_OUTPUT_ARG} \
 --max-items 5 | sort -k 6"

$ eval-it $DO_COMMAND
[aws kinesis-video-archived-media list-fragments --stream-name HelloLanka520 --endpoint-url https://b-fd02c7db.kinesisvideo.us-east-1.amazonaws.com --fragment-selector '{"FragmentSelectorType":"SERVER_TIMESTAMP","TimestampRange": {"StartTimestamp":"2024-10-10T00:00:00+08:00","EndTimestamp":"2024-10-10T23:59:59+08:00"}}' --output text --max-items 5 | sort -k 6]

```

```bash
$ export AWS_KVS_STREAM_STARTTOKEN="eyJOZXh0VG9rZW4iOiBudWxsLCAiYm90b190cnVuY2F0ZV9hbW91bnQiOiA1fQ=="
$ export AWS_KVS_STREAM_STARTTOKEN_ARG="--starting-token ${AWS_KVS_STREAM_STARTTOKEN}"

$ DO_COMMAND="aws kinesis-video-archived-media \
 list-fragments \
  ${AWS_KVS_STREAM_NAME_ARG} \
  ${AWS_KVS_STREAM_ENDPOINT_LIST_ARG} \
  ${AWS_KVS_STREAM_FRAME_SEL_ARG} \
  ${AWS_KVS_STREAM_STARTTOKEN_ARG} \
  ${AWS_KVS_STREAM_OUTPUT_ARG} \
  --max-items 5 | sort -k 6"

$ eval-it $DO_COMMAND
```

### 2.6.4. aws [kinesis-video-media](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis-video-media/index.html) xxx

#### [get-media](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kinesis-video-media/get-media.html)

> Use this API to retrieve media content from a Kinesis video stream. In the request, you identify the stream name or stream Amazon Resource Name (ARN), and the starting chunk. Kinesis Video Streams then returns a stream of chunks in order by fragment number.

> Video stream -> a mkv file

```bash
export AWS_KVS_STREAM_ENDPOINT_MEDIA=`aws kinesisvideo get-data-endpoint --stream-name ${AWS_KVS_STREAM_NAME} --output text --api-name GET_MEDIA`
export AWS_KVS_STREAM_ENDPOINT_MEDIA_ARG="--endpoint-url ${AWS_KVS_STREAM_ENDPOINT_MEDIA}"

export AWS_KVS_STREAM_FRAME_LAST="'{\"StartSelectorType\":\"NOW\"}'"
export AWS_KVS_STREAM_FRAME_LAST_ARG="--start-selector ${AWS_KVS_STREAM_FRAME_LAST}"

$ DO_COMMAND="aws kinesis-video-media \
 get-media \
 ${AWS_KVS_STREAM_NAME_ARG} \
 ${AWS_KVS_STREAM_ENDPOINT_MEDIA_ARG} \
 ${AWS_KVS_STREAM_FRAME_LAST_ARG} \
 ${AWS_KVS_STREAM_OUTPUT_MKV_LAST}"

$ eval-it $DO_COMMAND
[aws kinesis-video-media get-media --stream-name HelloLanka520 --endpoint-url https://s-356988f0.kinesisvideo.us-east-1.amazonaws.com --start-selector '{"StartSelectorType":"NOW"}' /work/HelloLanka520-last.mkv]
{
    "ContentType": "video/webm"
}
```

# Appendix

# I. Study
## I.1. Official - [AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/index.html)

# II. Debug

## II.2. Official - An error occurred (NoSuchBucket) when calling the ListObjectsV2 operation: The specified bucket does not exist

> 至 S3 console 建立該 Bucket，再用 aws s3 操作即可。
>
> 這有可能只是aws 自身的 bug 。

# III. Glossary

# IV. Tool Usage

## IV.1. bash

#### A. .bash_aliases

```bash
#******************************************************************************
#** aws cli **
#******************************************************************************
function aws-export()
{
	echo "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"
	echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
	echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"

	echo
	[ ! -v AWS_SHARED_CREDENTIALS_FILE ] && export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
	echo "AWS_SHARED_CREDENTIALS_FILE=${AWS_SHARED_CREDENTIALS_FILE}"
	if [ ! -z "${AWS_SHARED_CREDENTIALS_FILE}" ]; then
		DO_COMMAND="(cat ${AWS_SHARED_CREDENTIALS_FILE})"
		eval-it "$DO_COMMAND"
	else
		echo "Can't find AWS_SHARED_CREDENTIALS_FILE !!! ($HOME/.aws/credentials)"
	fi

	echo
	[ ! -v AWS_CONFIG_FILE ] && export AWS_CONFIG_FILE="$HOME/.aws/config"
	echo "AWS_CONFIG_FILE=${AWS_CONFIG_FILE}"
	if [ ! -z "${AWS_CONFIG_FILE}" ]; then
		DO_COMMAND="(cat ${AWS_CONFIG_FILE})"
		eval-it "$DO_COMMAND"
	else
		echo "Can't find AWS_CONFIG_FILE !!! ($HOME/.aws/config)"
	fi

	echo
}

```

```bash
#******************************************************************************
#** aws cli (S3) **
#******************************************************************************
export S3_BUCKET_NAME=lambdax9

function aws-s3-path()
{
	echo "S3_BUCKET_NAME=${S3_BUCKET_NAME}"
}

function aws-s3-ls()
{
	aws-s3-path
	DO_COMMAND="(aws s3 ls s3://${S3_BUCKET_NAME})"
	eval-it "$DO_COMMAND"
}

function aws-s3-mb()
{
	HINT="Usage: ${FUNCNAME[0]} <bucket>"
	BUCKET1="$1"

	if [ ! -z "${BUCKET1}" ]; then
		DO_COMMAND="(aws s3 mb s3://${BUCKET1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function aws-s3-rb()
{
	HINT="Usage: ${FUNCNAME[0]} <bucket>"
	BUCKET1="$1"

	if [ ! -z "${BUCKET1}" ]; then
		DO_COMMAND="(aws s3 rb s3://${BUCKET1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

#alias aws-s3-pull="aws-s3-path; aws s3 cp s3://${S3_BUCKET_NAME}/$1 ./"
function aws-s3-pull()
{
	aws-s3-path

	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1="$1"

	if [ ! -z "${FILE1}" ]; then
		DO_COMMAND="(aws s3 cp s3://${S3_BUCKET_NAME}/${FILE1} ./)"
		eval-it "$DO_COMMAND"
		#echo "aws s3 cp s3://${S3_BUCKET_NAME}/${FILE1} ./"
	else
		echo $HINT
	fi
}

#alias aws-s3-push="aws s3 cp ${1} s3://${S3_BUCKET_NAME}"
function aws-s3-push()
{
	aws-s3-path

	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1="$1"

	if [ ! -z "${FILE1}" ]; then
		DO_COMMAND="(aws s3 cp ${FILE1} s3://${S3_BUCKET_NAME}/)"
		eval-it "$DO_COMMAND"
		#echo "aws s3 cp s3://${S3_BUCKET_NAME}/${FILE1}"
	else
		echo $HINT
	fi
}

function aws-s3-pull-bash_aliases()
{
	DO_COMMAND="(cd /tmp; aws-s3-pull .bash_aliases; chmod 775 .bash_aliases; cp .bash_aliases ~/)"
	eval-it "$DO_COMMAND"
}

function aws-s3-push-bash_aliases()
{
	aws-s3-push ~/.bash_aliases
}

#alias aws-s3-rm="aws s3 rm s3://${S3_BUCKET_NAME}/$1"
function aws-s3-rm()
{
	aws-s3-path

	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1="$1"

	if [ ! -z "${FILE1}" ]; then
		DO_COMMAND="(aws s3 rm s3://${S3_BUCKET_NAME}/${FILE1})"
		eval-it "$DO_COMMAND"
		#echo "aws s3 rm s3://${S3_BUCKET_NAME}/${FILE1}"
	else
		echo $HINT
	fi
}

```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

