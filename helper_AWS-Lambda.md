# [AWS Lambda](https://aws.amazon.com/tw/lambda/?nc1=h_ls)

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

# 1. [AWS Lambda (Developer Guide)](https://docs.aws.amazon.com/zh_tw/lambda/latest/dg/welcome.html)

> Run code without thinking about servers or clusters

> 一般我們寫程式，都是稱為 application，而 Lambda 是稱為 function. 

## 1.1. How it works

#### A. File processing
![aws_lambda01](./images/aws_lambda01.png)
#### B. Stream processing
![aws_lambda01](./images/aws_lambda02.png)
#### C. Web applications
![aws_lambda01](./images/aws_lambda03.png)
#### D. IoT backends
![aws_lambda01](./images/aws_lambda04.png)
#### E. Mobile backends
![aws_lambda01](./images/aws_lambda05.png)

# 2. Sample

## 2.1. Hello world

### 2.1.1. Create and Execution

#### A. Sign in as IAM user

> **Account ID (12 digits)** : 123456789012
>
> 請先登入 https://123456789012.signin.aws.amazon.com/console

![aws_lambda021](./images/aws_lambda021.png)

#### B. [AWS Lambda](https://us-west-1.console.aws.amazon.com/lambda/home?region=us-west-1#/)
![aws_lambda022](./images/aws_lambda022.png)

#### C. Create function
![aws_lambda023](./images/aws_lambda023.png)

##### C.1. index.js

```node.js
console.log('Loading function');

exports.handler = async (event, context) => {
    //console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('value1 =', event.key1);
    console.log('value2 =', event.key2);
    console.log('value3 =', event.key3);
    return event.key1;  // Echo back the first key value
    // throw new Error('Something went wrong');
};

```

##### C.2. lambda_function.py

```python
import json

print('Loading function')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    print("value1 = " + event['key1'])
    print("value2 = " + event['key2'])
    print("value3 = " + event['key3'])
    return event['key1']  # Echo back the first key value
    #raise Exception('Something went wrong')

```



#### D. create a test event - SAVE / TEST

![aws_lambda024](./images/aws_lambda024.png)

#### E. Execution result
![aws_lambda025](./images/aws_lambda025.png)

### 2.1.2. [CloudWatch](https://us-west-1.console.aws.amazon.com/cloudwatch/home?region=us-west-1#)

![aws_cloudwatch010](./images/aws_cloudwatch010.png)

### 2.1.3. [IAM](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles)
![aws_iam011](./images/aws_iam011.png)

## 2.2. [aws-lambda-developer-guide](https://github.com/awsdocs/aws-lambda-developer-guide)

> Blank 函數範例應用程式利用一個呼叫 Lambda API 的函數來示範 Lambda 中的一般操作。它示範如何使用記錄、環境變數、AWS X-Ray 追蹤、Layer、單元測試和 AWS 開發套件。探索此應用程式可了解如何使用您的程式設計語言建置 Lambda 函數，或以它做為自有專案的起點。

### 2.2.1. Use Shell Script (follow the README.md)

#### A. To download

```bash
$ git clone https://github.com/awsdocs/aws-lambda-developer-guide.git
$ cd aws-lambda-developer-guide/sample-apps/blank-python

$ pip3 install jsonpickle
$ pip3 install aws_xray_sdk
$ pip3 install boto3
$ pip3 install testresources
$ pip3 install --upgrade launchpadlib
```
#### B. To Run on local

##### B.1. sample-apps\blank-python\function\lambda_function.test.py

> fix event = jsonpickle.decode(ba) raise TypeError("Input string must be text, not bytes")

```bash
$ vi sample-apps\blank-python\function\lambda_function.test.py

		try:
      ba = bytearray(file.read())
      event = jsonpickle.decode(ba.decode('utf-8'))
      logger.warning('## EVENT')
      logger.warning(jsonpickle.encode(event))

```

##### B.2. Run

```
$ ./0-run-tests.sh
## EVENT
{"Records": [{"messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78", "receiptHandle": "MessageReceiptHandle", "body": "Hello from SQS!", "attributes": {"ApproximateReceiveCount": "1", "SentTimestamp": "1523232000000", "SenderId": "123456789012", "ApproximateFirstReceiveTimestamp": "1523232000001"}, "messageAttributes": {}, "md5OfBody": "7b270e59b47ff90a553787216d55d91d", "eventSource": "aws:sqs", "eventSourceARN": "arn:aws:sqs:us-west-2:123456789012:MyQueue", "awsRegion": "us-west-2"}]}
{'TotalCodeSize': 773, 'FunctionCount': 2}
.
----------------------------------------------------------------------
Ran 1 test in 0.146s

OK

```
#### C. To create a new bucket (It will create a new bucket in S3)
```bash
$ ./1-create-bucket.sh
make_bucket: lambda-artifacts-5d63c7b31336e36e

```

#### D. To build a Lambda layer

```bash
$ ./2-build-layer.sh
Collecting jsonpickle==1.3
  Using cached jsonpickle-1.3-py2.py3-none-any.whl (32 kB)
Collecting aws-xray-sdk==2.4.3
  Using cached aws_xray_sdk-2.4.3-py2.py3-none-any.whl (87 kB)
Collecting wrapt
  Using cached wrapt-1.15.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (81 kB)
Collecting botocore>=1.11.3
  Using cached botocore-1.29.103-py3-none-any.whl (10.6 MB)
Processing /home/lanka/.cache/pip/wheels/a0/0b/ee/e6994fadb42c1354dcccb139b0bf2795271bddfe6253ccdf11/future-0.18.3-py3-none-any.whl
Collecting jmespath<2.0.0,>=0.7.1
  Using cached jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting urllib3<1.27,>=1.25.4
  Using cached urllib3-1.26.15-py2.py3-none-any.whl (140 kB)
Collecting python-dateutil<3.0.0,>=2.1
  Using cached python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
Collecting six>=1.5
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Installing collected packages: jsonpickle, wrapt, jmespath, urllib3, six, python-dateutil, botocore, future, aws-xray-sdk
Successfully installed aws-xray-sdk-2.4.3 botocore-1.29.103 future-0.18.3 jmespath-1.0.1 jsonpickle-1.3 python-dateutil-2.8.2 six-1.16.0 urllib3-1.26.15 wrapt-1.15.0

```

#### E. To deploy the application

```bash
$ ./3-deploy.sh
Uploading to 3115f4e1f511ea0befef6922e2716e34  13160846 / 13160846.0  (100.00%)
Successfully packaged artifacts and wrote output template to file out.yml.
Execute the following command to deploy the packaged template
aws cloudformation deploy --template-file /work/codebase/xbox/AWS/AWSLambda/aws-lambda-developer-guide/sample-apps/blank-python/out.yml --stack-name <YOUR STACK NAME>

Waiting for changeset to be created..
Waiting for stack create/update to complete

Successfully created/updated stack - blank-python

```

#### F. To invoke the function

##### F.1. ok

```bash
$ cat ~/.aws/config
[default]
region = us-west-1
output = json
cli_binary_format=raw-in-base64-out

```

```bash
./4-invoke.sh
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
{"TotalCodeSize": 26325013, "FunctionCount": 3}
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
{"TotalCodeSize": 26325013, "FunctionCount": 3}

```

##### F.2. A base64 error

```bash
cat ~/.aws/config
[default]
region = us-west-1
output = json

```

```bash
$ ./4-invoke.sh
Invalid base64: "{
  "Records": [
    {
      "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
      "receiptHandle": "MessageReceiptHandle",
      "body": "Hello from SQS!",
      "attributes": {
        "ApproximateReceiveCount": "1",
        "SentTimestamp": "1523232000000",
        "SenderId": "123456789012",
        "ApproximateFirstReceiveTimestamp": "1523232000001"
      },
      "messageAttributes": {},
      "md5OfBody": "7b270e59b47ff90a553787216d55d91d",
      "eventSource": "aws:sqs",
      "eventSourceARN": "arn:aws:sqs:us-west-2:123456789012:MyQueue",
      "awsRegion": "us-west-2"
    }
  ]
}
"

```

#### G. To delete the application

```bash
$ ./5-cleanup.sh
Deleted blank-python stack.
Delete deployment artifacts and bucket (lambda-artifacts-936c7a7b0eed2088)? (y/n)y
delete: s3://lambda-artifacts-936c7a7b0eed2088/d80ce43fb31ca44632b5b761801203cb
delete: s3://lambda-artifacts-936c7a7b0eed2088/3115f4e1f511ea0befef6922e2716e34
remove_bucket: lambda-artifacts-936c7a7b0eed2088
Delete function log group (/aws/lambda/blank-python-function-F75ut0BBpl5x)? (y/n)y

```

### 2.2.2. Use Makefile (follow the lankahsu520)

#### A. Copy Makefile

```bash
$ cp AWS/lambda-makefile/* ${YOUR_ws-lambda-developer-guide}/aws-lambda-developer-guide/sample-apps/blank-python
$ cd ${YOUR_ws-lambda-developer-guide}/aws-lambda-developer-guide/sample-apps/blank-python

```

#### B. Edit project.json

> Please make sure
> stack_name: the stack name of AWS CloudFormation
> package_name: it is the same as the ContentUri of template_file (template.yml)
> s3_bucket_name: To create a new bucket for deployment artifacts, s3://lambda-artifacts520/blank-python
> lambda_function_name: the function name
> lambda_function_dir: this is local folder

```bash
$ vi project.json
{
	"stack_name": "blank520",
	"package_name": "package",
	"s3_bucket_name": "lambda-artifacts520",
	"lambda_function_name": "blank-python",
	"lambda_function_dir": "function",
	"event_json_file": "event.json",
	"result_json_file": "result.json",
	"template_file": "template.yml",
	"output_template_file": "out.yml"
}
```

#### C. To Run on local

```mermaid
flowchart LR
	Start([Start])
 	run[run]
	subgraph run
		run_python[[run_python]]
		run_nodejs[[run_nodejs]]
	end
  subgraph local_install
		local_install_python[[local_install_python]]
		local_install_nodejs[[local_install_nodejs]]
	end
  End([End])
	
	Start-->local_install-->run-->End
```
```bash
$ make run
```

#### D. To create a new bucket

```mermaid
flowchart LR
	Start([Start])
 	all[all]
 	envs[envs]
  End([End])
	
	Start-->all-->envs-->End
```

```bash
$ make
----->> envs
PROJECT_JSON: project.json
STACK_NAME: blank520
PACKAGE_NAME: package
S3_BUCKET_NAME: lambda-artifacts520
LAMBDA_FUNCTION_NAME: blank-python
LAMBDA_FUNCTION_DIR: function
EVENT_JSON_FILE: event.json
RESULT_JSON_FILE: result.json
TEMPLATE_FILE: template.yml
OUTPUT_TEMPLATE_FILE: out.yml

----->> .s3_bucket_chk - lambda-artifacts520
Found lambda-artifacts520 !!!

$ aws s3 ls s3://lambda-artifacts520

```

#### E. Deploy with aws CloudFormation

```mermaid
flowchart LR
	Start([Start])
 	deploy_all[deploy_all]
	subgraph CloudFormation
 		deploy_stack[deploy_stack]
	end
	subgraph s3
		deploy_s3[deploy_s3]
		deploy_s3_object[[deploy_s3_object]]
	end
  End([End])
	
	Start-->deploy_all-->deploy_stack-->deploy_s3
	deploy_s3-->deploy_s3_object-->End
```
```bash
$ make deploy_all
----->> layer_python_install - /work/codebase/xbox/AWS/AWSLambda/aws-lambda-developer-guide/sample-apps/blank-python/package/
Collecting jsonpickle==1.3
  Using cached jsonpickle-1.3-py2.py3-none-any.whl (32 kB)
Collecting aws-xray-sdk==2.4.3
  Using cached aws_xray_sdk-2.4.3-py2.py3-none-any.whl (87 kB)
Processing /home/lanka/.cache/pip/wheels/a0/0b/ee/e6994fadb42c1354dcccb139b0bf2795271bddfe6253ccdf11/future-0.18.3-py3-none-any.whl
Collecting wrapt
  Using cached wrapt-1.15.0-cp38-cp38-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (81 kB)
Collecting botocore>=1.11.3
  Using cached botocore-1.29.108-py3-none-any.whl (10.6 MB)
Collecting urllib3<1.27,>=1.25.4
  Using cached urllib3-1.26.15-py2.py3-none-any.whl (140 kB)
Collecting jmespath<2.0.0,>=0.7.1
  Using cached jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting python-dateutil<3.0.0,>=2.1
  Using cached python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
Collecting six>=1.5
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Installing collected packages: jsonpickle, future, wrapt, urllib3, jmespath, six, python-dateutil, botocore, aws-xray-sdk
Successfully installed aws-xray-sdk-2.4.3 botocore-1.29.108 future-0.18.3 jmespath-1.0.1 jsonpickle-1.3 python-dateutil-2.8.2 six-1.16.0 urllib3-1.26.15 wrapt-1.15.0
----->> deploy_s3_object - s3://lambda-artifacts520/blank-python
Uploading to blank-python//8034650f8d3f348927fb09cf2fe5ddcd  13174083 / 13174083.0  (100.00%)
Successfully packaged artifacts and wrote output template to file out.yml.
Execute the following command to deploy the packaged template
aws cloudformation deploy --template-file /work/codebase/xbox/AWS/AWSLambda/aws-lambda-developer-guide/sample-apps/blank-python/out.yml --stack-name <YOUR STACK NAME>
----->> s3_object_ls - s3://lambda-artifacts520
aws s3 ls s3://lambda-artifacts520
                           PRE blank-python/
----->> deploy_stack - blank520

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - blank520
----->> lambda_function_ls - blank520-function-gduLfxyZL7d1

```

#### F.  To invoke the function

```bash
$ make invoke
----->> invoke - blank-python / blank520-function-gduLfxyZL7d1
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
{"TotalCodeSize": 184378893, "FunctionCount": 1}

```

#### G. Delete

```mermaid
flowchart LR
	Start([Start])
 	delete_all[delete_all]
	subgraph CloudWatch
	 	delete_log_group[delete_log_group]
	end
	subgraph CloudFormation
 		delete_stack[delete_stack]
	end
	subgraph s3
		delete_s3[delete_s3]
		s3_object_rm[[s3_object_rm]]
	end
  End([End])
	
	Start-->delete_all-->delete_log_group-->delete_stack-->delete_s3
	delete_s3-->s3_object_rm-->End
```

```bash
$ make delete_all
----->> envs
PROJECT_JSON: project.json
STACK_NAME: blank520
PACKAGE_NAME: package
S3_BUCKET_NAME: lambda-artifacts520
LAMBDA_FUNCTION_NAME: blank-python
LAMBDA_FUNCTION_DIR: function
EVENT_JSON_FILE: event.json
RESULT_JSON_FILE: result.json
TEMPLATE_FILE: template.yml
OUTPUT_TEMPLATE_FILE: out.yml

----->> lambda_function_ls - blank520-function-gduLfxyZL7d1
----->> delete_log_group - blank-python / /aws/lambda/blank520-function-gduLfxyZL7d1
            "creationTime": 1680842914607,
----->> delete_stack - blank520
----->> s3_object_rm - s3://lambda-artifacts520/blank-python
delete: s3://lambda-artifacts520/blank-python//096881c601d991b30ed71be284609ca2
delete: s3://lambda-artifacts520/blank-python//8034650f8d3f348927fb09cf2fe5ddcd
----->> layer_python_rm - /work/codebase/xbox/AWS/AWSLambda/aws-lambda-developer-guide/sample-apps/blank-python/package/

```



# Appendix

# I. Study

> 目前網路上並沒有發現善心人士的心得，只能專心於官方提供的文件

#### A. Official - [AWS Lambda (Developer Guide)](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)

# II. Debug

# III. Glossary

####  AI, Artificial Intelligence

>人工智慧 (AI) 是電腦科學的一個領域，致力於解決與人類智慧相關的常見認知問題，例如學習、解決問題和模式辨識。人工智慧 (通常簡稱為 "AI") 呈現出機器人或未來世界的景像，也就是說，AI 不再是科幻小說中虛構的機器人，而真正成為現代高階電腦科學中的現實。

#### [CSAT, Customer satisfaction][1]

[1]: https://www.qualtrics.com/hk/experience-management/customer/what-is-csat/ "qualtrics"
>CSAT是[顧客滿意度](https://www.qualtrics.com/au/experience-management/customer/customer-satisfaction/)得分的簡稱。它是商業上經常使用的一個指標，在所有類型的企業中，都可以以CSAT作為客戶服務和產品質量的關鍵績效指標。雖然顧客滿意度是一個籠統的概念，但CSAT可以將其轉化成更明確的指標，以百分比表示。例如，100%是非常好的，而0%則是非常糟糕的。

#### ML, Machine Learning

>是一項用於建立機器學習模型並產生預測結果的受管服務，可協助開發穩定且可擴展的智慧應用程式。

# IV. Tool Usage


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
