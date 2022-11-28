# [AWS Command Line Interface](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-welcome.html)
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

# 1. Install
```bash
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```
# 2. Environment Variables

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
```

#### C. Others

```bash
AWS_ROLE_ARN
AWS_WEB_IDENTITY_TOKEN_FILE
AWS_ROLE_SESSION_NAME

AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

AWS_EC2_METADATA_DISABLED
```

# 3. aws Usage

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

# 4. S3

## 4.1. [S3 Dashboard](https://s3.console.aws.amazon.com/s3/buckets?region=eu-west-1)

## 4.2. aws s3 xxx

#### [cp](https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html)

>#### copies a single file to a specified bucket and key

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
$ aws s3 mb s3://HelperX
```

#### [rb](https://docs.aws.amazon.com/cli/latest/reference/s3/rb.html)

>removes a bucket

```bash
$ aws s3 rb s3://HelperX
```

#### [rm](https://docs.aws.amazon.com/cli/latest/reference/s3/rm.html)

>deletes a single s3 object

```bash
$ aws s3 rm s3://utilx9/demo_000.c
```

# 4. [DynamoDB](https://docs.aws.amazon.com/zh_tw/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html)

## 4.1. [DynamoDB Dashboard](https://eu-west-1.console.aws.amazon.com/dynamodbv2/home?region=eu-west-1#service)

## 4.2. aws dynamodb xxx

#### create-table

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
```
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
        "TableArn": "arn:aws:dynamodb:ap-northeast-1:877409152866:table/Music",
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
#### describe-table

```bash
$ aws dynamodb describe-table --table-name Music | grep TableStatus
```

```
"TableStatus": "ACTIVE",
```
#### put-item

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

```
{
    "Items": []
}
```

```
An error occurred (DuplicateItemException) when calling the ExecuteStatement operation: Duplicate primary key exists in table
```
#### get-item

```bash
$ aws dynamodb get-item --consistent-read \
    --table-name Music \
    --key '{ "Artist": {"S": "Acme Band"}, "SongTitle": {"S": "Happy Day"}}'
```

```
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

#### scan

```bash
$ aws dynamodb scan --table-name Music
```

```
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

# Appendix

# I. Study

# II. Debug


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

