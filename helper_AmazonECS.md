

# [Amazon ECS](https://aws.amazon.com/tw/ecs/)

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

# 1. Amazon Elastic Container Service

> Amazon Elastic Container Service (Amazon ECS) 是全受管容器協同運作服務，協助您更高效地部署、管理和擴展容器化應用程式。它與 AWS 環境深度整合，為使用 Amazon ECS Anywhere 的進階安全功能，在雲端和內部部署中執行容器工作負載提供簡單易用的解決方案。

> 這邊要先清楚什麼是容器（Container），而虛擬機（Virtual Machine）又是什麼。[helper_Docker.md](https://github.com/lankahsu520/HelperX/blob/master/helper_Docker.md) 可以透過 Docker 來了解。

> 拜讀 Developer Guide 和網路文章後，還是完全沒有進展，這篇或許可以讓你有成就感。
>
> 此篇只是讓大家起個頭，了解運作後，再針對個人需求進行發展。

# 2. ECS vs EC2

> 此處的 EC2 並不是 AWS EC2 launch type。
>
> 而是使用者直接去租用 EC2，用 SSH連結進去後，安裝相關的程式或是服務。

## 2.1. Cost

> 成本很重要！

### 2.1.1. Task Allocation vs. Resource Capacity

> 當然執行數量少時看不出差異，但當需求量提高，兩邊的差異就會很明顯。
>
> 這邊假設在同一時間下，需要啟動 1,000 tasks，每月的費用的如下。

> 先看看需求，假設同時啟動1,000 tasks，每月的費用的如下。

|           | task(s) | ECS Fargate (0.25 vCPU, 128MB RAM)                           | EC2 t3.medium (vCPU:2, RAM: 4GB) |
| --------- | ------- | ------------------------------------------------------------ | -------------------------------- |
| USD/month | 1000    | (0.25 * 0.04048 + 0.125 * 0.004445) * 24 * 7.68 *1000= 7689.6 | 33                               |
| USD/month | 1       | (0.25 * 0.04048 + 0.125 * 0.004445) * 24 * 7.68 *1= 7.689    | 33                               |

#### A. Managing Multiple Tasks with Limited Resources

> 此情境就好比訂購系統，當特惠時節提高處理單元（1000 個）；之後維持基本處理單元（10 個）就行，

```mermaid
flowchart LR
	 Task1 --> Resource
	 Task2 --> Resource
	 Task3 --> Resource
	 Task4 --> Resource
```

#### B. Independent Resource Allocation per Task

> 每個處理單元個別管理自己的資源，而且資源是無法分享。

```mermaid
flowchart LR
	 Task1 --> Resource1
	 Task2 --> Resource2
	 Task3 --> Resource3
	 Task4 --> Resource4
```

### 2.1.2. Run time

> 執行時間的長和短，也是需要考量

## 2.2. Manage & Deploy

> 單究『無需管理伺服器』，在傳統思維裏，空間太小加空間，主機落後換主機；而 ECS 中，開發者要清楚知道如何註冊、部署等問題；相較之下，彼此之間的不同之處在那？或許只是換個方式。

> 另外，知道 「電腦」的人比較多，還是知道 Docker 的人多？

|        | ECS                          | EC2                                                          |
| ------ | ---------------------------- | ------------------------------------------------------------ |
| 擴展   | 無上限                       | 可擴展，限於使用中的 EC2 能力。使用者要先預估執行數量，例如每台 EC2可執行 1000 個tasks。 |
| 管理   | 不見得簡單。                 | 不見得容易。                                                 |
| 部署   | 要會 AWS 的 magic language。 | 會 linux 的，就會。                                          |
| 除錯   | 不容易。                     | 會 linux 的，就會。                                          |
| 帶參數 | 困難。                       | 會 linux 的，就會。                                          |
| 功能   | 功能單一化                   | 可執行不同功能的服務                                         |

# 3. Docker Image

## 3.1. [Amazon ECR Public Gallery](https://gallery.ecr.aws)

#### A. [amazonlinux](https://gallery.ecr.aws/amazonlinux/amazonlinux)

> public.ecr.aws/amazonlinux/amazonlinux:latest

#### B. [ubuntu](https://gallery.ecr.aws/ubuntu/ubuntu)

> public.ecr.aws/ubuntu/ubuntu:20.04

## 3.2. Create a Docker Image with Dockerfile

### 3.2.1. Create a Docker image

```bash
$ export AWS_DOCKER_IMAGE_NAME=hello-world

$ docker build -t $AWS_DOCKER_IMAGE_NAME .

# check
$ docker images --filter reference=$AWS_DOCKER_IMAGE_NAME
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
hello-world   latest    64d4dc0afe03   2 minutes ago   301MB
```

#### A. Dockerfile

```bash
FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# Update installed packages and install Apache
RUN yum update -y && \
 yum install -y httpd iputils

# Write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

# Configure Apache
RUN echo 'mkdir -p /var/run/httpd' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/httpd' >> /root/run_apache.sh && \
 echo '/usr/sbin/httpd -D FOREGROUND' >> /root/run_apache.sh && \
 chmod 755 /root/run_apache.sh

EXPOSE 80

CMD /root/run_apache.sh
```

#### B. Dockerfile with supervisord

> 請參考 [helper_Docker.md](https://github.com/lankahsu520/HelperX/blob/master/helper_Docker.md)  [8.2. supervisord](https://github.com/lankahsu520/HelperX/blob/master/helper_Docker.md#82-supervisord)

### 3.2.2. Testing

```mermaid
flowchart TB
	subgraph Host[Host - Ubuntu]
		subgraph Container[Container - hello-world]

		end
		browser <--> Container
	end
```

```bash
# run
$ docker run -t -i -p 8888:80 $AWS_DOCKER_IMAGE_NAME

# open browser http://localhost:8888
```

## 3.3. Create a repository

```bash
$ export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`

$ export AWS_DEFAULT_REGION=eu-west-1
#$ export AWS_DEFAULT_REGION=us-west-1
$ export AWS_REPOSITORY_NAME=hello-repository
$ export AWS_REPOSITORY_JSON=$AWS_REPOSITORY_NAME.json
$ export AWS_DOCKER_IMAGE_NAME=hello-world

$ aws ecr create-repository --repository-name $AWS_REPOSITORY_NAME --region $AWS_DEFAULT_REGION > $AWS_REPOSITORY_JSON
$ export AWS_REPOSITORY_URI=$(cat $AWS_REPOSITORY_JSON  | jq -r '.repository.repositoryUri')
$ echo $AWS_REPOSITORY_URI
123456789012.dkr.ecr.eu-west-1.amazonaws.com/hello-repository

$ aws ecr describe-repositories --query 'repositories[]. [repositoryName, repositoryUri]' --output table
---------------------------------------------------------------------------------------
|                                DescribeRepositories                                 |
+------------------+------------------------------------------------------------------+
|  hello-repository|  123456789012.dkr.ecr.eu-west-1.amazonaws.com/hello-repository   |
+------------------+------------------------------------------------------------------+
```

<img src="./images/amazon_ecs91.png" alt="amazon_ecs91" style="zoom:50%;" />

## 3.4. Tag the Docker Image

```bash
$ docker tag $AWS_DOCKER_IMAGE_NAME $AWS_REPOSITORY_URI
$ docker images
REPOSITORY                                                      TAG       IMAGE ID       CREATED          SIZE
123456789012.dkr.ecr.eu-west-1.amazonaws.com/hello-repository   latest    24e33260f209   44 minutes ago   301MB
hello-world                                                     latest    24e33260f209   44 minutes ago   301MB
public.ecr.aws/amazonlinux/amazonlinux                          latest    e049bd4be1b1   10 days ago      154MB
```

## 3.5. Push the Docker Image to Amazon ECR

```bash
$ aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_REPOSITORY_URI
WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

$ docker push $AWS_REPOSITORY_URI

$ aws ecr describe-images --repository-name $AWS_REPOSITORY_NAME
{
    "imageDetails": [
        {
            "registryId": "123456789012",
            "repositoryName": "hello-repository",
            "imageDigest": "sha256:112f62a8d1a0cc277edc78994fb32ed2cc132555bccaf15c4b538a76e6471296",
            "imageTags": [
                "latest"
            ],
            "imageSizeInBytes": 144785629,
            "imagePushedAt": "2025-04-22T02:12:53.510000+02:00",
            "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
            "artifactMediaType": "application/vnd.docker.container.image.v1+json"
        }
    ]
}
```

<img src="./images/amazon_ecs92.png" alt="amazon_ecs92" style="zoom:50%;" />

## 3.6.  Delete the Docker Image from Amazon ECR

```bash
$ aws ecr delete-repository --repository-name $AWS_REPOSITORY_NAME --region $AWS_DEFAULT_REGION --force
```

# 4. Deploy Methods

> AWS ECS 部署有很多方式，選擇自己喜歡的方式。
>
> 這邊語重心長的提醒各位，「開發者應該是著重於 docker 裏要處理的特定功能，而不是去花時間解決 AWS  部署問題」

#### AWS CLI

> 此篇採用 AWS CLI + Web Console。因為 AWS CLI 安裝方便，而 Web Console 方便驗證。

#### AWS Web Console

> 圖形化介面。

#### [AWS CDK](https://docs.aws.amazon.com/zh_tw/AmazonECS/latest/developerguide/tutorial-ecs-web-server-cdk.html)

> 沒用過。需再學 AWS 的 magic language。

#### [AWS CloudFormation](https://docs.aws.amazon.com/zh_tw/AmazonECS/latest/developerguide/creating-resources-with-cloudformation.html)

> 常常困在 json 的格式裏，回報的訊息不利 debug。

#### [AWS Copilot](https://docs.aws.amazon.com/zh_tw/AmazonECS/latest/developerguide/AWS_Copilot.html)

> 看到安裝繁瑣，還要 PGP 等，看了就累。

# 5. ECS launch type

## 5.1. EC2

## 5.2. Farget

```mermaid
flowchart TB
	subgraph Farget[ECS Farget]
		subgraph Cluster1
			subgraph Service1
				subgraph TaskDef1["Task Definition1"]
					Task101(Task101)
					Task102(Task102)
				end
			end
			subgraph Service3
				subgraph TaskDef3["Task Definition3"]
					Task301(Task301)
				end
			end
		end
		subgraph Cluster2
			subgraph Service2
				subgraph TaskDef2["Task Definition2"]
					Task201(Task201)
					Task202(Task202)
				end
			end
		end
	end

```

### 5.2.1. ECS Execution Role

#### A. AWS CLI

##### A.1. create-role

```bash
$ export AWS_ECS_ROLE=ecsTaskExecutionRole
$ export AWS_ECS_ROLE_JSON=$AWS_ECS_ROLE.json
$ export AWS_ECS_ROLE_POLICY_JSON=$AWS_ECS_ROLE_POLICY.json

# Create IAM role
$	cat > "$AWS_ECS_ROLE_JSON" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

$ aws iam create-role \
  --role-name $AWS_ECS_ROLE \
  --assume-role-policy-document file://$AWS_ECS_ROLE_JSON

# attach-role-policy - AmazonECSTaskExecutionRolePolicy
$ aws iam attach-role-policy \
  --role-name $AWS_ECS_ROLE \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# put-role-policy - ecsCreateECSexec
$ cat > "$AWS_ECS_ROLE_POLICY_JSON" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "ssmmessages:*",
        "ssm:UpdateInstanceInformation"
      ],
      "Resource": "*"
    }
  ]
}
EOF

$ aws iam put-role-policy \
  --role-name $AWS_ECS_ROLE \
  --policy-name ecsCreateECSexec \
  --policy-document file://$AWS_ECS_ROLE_POLICY_JSON

# 查詢 Role ARN
$ export AWS_ECS_ROLE_ARN=`aws iam get-role --role-name $AWS_ECS_ROLE --query 'Role.Arn' --output text`
$ echo $AWS_ECS_ROLE_ARN
arn:aws:iam::123456789012:role/ecsTaskExecutionRole
```

##### A.2. delete-role

```bash
# 移除附加的 Policies
$ aws iam list-attached-role-policies --role-name $AWS_ECS_ROLE
$ aws iam detach-role-policy --role-name $AWS_ECS_ROLE --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# 刪除 inline policy
$ aws iam list-role-policies --role-name $AWS_ECS_ROLE
$ aws iam delete-role-policy --role-name $AWS_ECS_ROLE --policy-name YourInlinePolicyName

# 刪除 Role
$ aws iam delete-role --role-name $AWS_ECS_ROLE
```

#### B. AWS Web Console

> 建議先用 AWS CLI

### 5.2.2. [Clusters](https://eu-west-1.console.aws.amazon.com/ecs/v2/clusters?region=eu-west-1)

#### A. AWS CLI

##### A.1. create-cluster

```bash
$ export AWS_ECS_CLUSTER=hello-cluster

$ aws ecs create-cluster --cluster-name $AWS_ECS_CLUSTER
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:eu-west-1:123456789012:cluster/hello-cluster",
        "clusterName": "hello-cluster",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```

##### A.2. delete-cluster

```bash
$ aws ecs delete-cluster --cluster $AWS_ECS_CLUSTER
```

#### B. AWS Web Console

##### B.1. Create cluster

<img src="./images/amazon_ecs01.png" alt="amazon_ecs01" style="zoom:50%;" />

##### B.2. Cluster configuration

> **Cluster name**: hello-cluster

<img src="./images/amazon_ecs02.png" alt="amazon_ecs02" style="zoom:50%;" />

##### B.3. Create

<img src="./images/amazon_ecs03.png" alt="amazon_ecs03" style="zoom:50%;" />

##### B.4. List

<img src="./images/amazon_ecs04.png" alt="amazon_ecs04" style="zoom:50%;" />

### 5.2.3. [Task definitions](https://eu-west-1.console.aws.amazon.com/ecs/v2/task-definitions?region=eu-west-1)

#### A. AWS CLI

> **CPU**: 256 units (0.25 vCPU)
>
> **Memory**: 512 MiB (0.5 GB)
>
> [任務 CPU 和記憶體](https://docs.aws.amazon.com/zh_tw/AmazonECS/latest/developerguide/fargate-tasks-services.html#fargate-tasks-size)。

##### A.1. register-task-definition

> [Example Amazon ECS task definition: Route logs to CloudWatch](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specify-log-config.html)

```bash
$ export AWS_TASK_DEFINITION_JSON=hello-task-definition.json
$ export AWS_TASK_DEFINITION_ARN_TXT=hello-task-definition-arn.txt
$ export AWS_TASK_DEFINITION_FAMILY=sample-fargate-v2

$ export AWS_TASK_DEFINITION_HOST_PORT=80
$ export AWS_TASK_DEFINITION_CONTAINER_NAME=fargate-app
$ export AWS_TASK_DEFINITION_CONTAINER_PORT=80
$ export AWS_TASK_DEFINITION_PROTOCOL=tcp

$ export AWS_TASK_DEFINITION_CPU=256
$ export AWS_TASK_DEFINITION_MEMORY=512

$ export AWS_LOG_DRIVER=awslogs
$ export AWS_LOG_GROUP=awslogs-wordpress
$ export AWS_LOG_PREFIX=awslogs-example

# family: sample-fargate-v2
$ cat > "$AWS_TASK_DEFINITION_JSON" <<EOF
{
    "family": "$AWS_TASK_DEFINITION_FAMILY",
    "networkMode": "awsvpc",
    "executionRoleArn": "$AWS_ECS_ROLE_ARN",
    "taskRoleArn": "$AWS_ECS_ROLE_ARN",
    "containerDefinitions": [
        {
            "name": "$AWS_TASK_DEFINITION_CONTAINER_NAME",
            "image": "$AWS_REPOSITORY_URI:$AWS_REPOSITORY_TAG",
            "portMappings": [
                {
                    "containerPort": $AWS_TASK_DEFINITION_CONTAINER_PORT,
                    "hostPort": $AWS_TASK_DEFINITION_HOST_PORT,
                    "protocol": "$AWS_TASK_DEFINITION_PROTOCOL"
                }
            ],
            "essential": true,
            "logConfiguration": {
                "logDriver": "$AWS_LOG_DRIVER",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "$AWS_LOG_GROUP",
                    "awslogs-region": "$AWS_DEFAULT_REGION",
                    "awslogs-stream-prefix": "$AWS_LOG_PREFIX"
                }
            }
        }
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "$AWS_TASK_DEFINITION_CPU",
    "memory": "$AWS_TASK_DEFINITION_MEMORY"
}
EOF

$ aws ecs register-task-definition --cli-input-json file://$AWS_TASK_DEFINITION_JSON
```

##### A.2. list-task-definitions

```bash
$ aws ecs list-task-definitions --family-prefix $AWS_TASK_DEFINITION_FAMILY
{
    "taskDefinitionArns": [
        "arn:aws:ecs:eu-west-1:123456789012:task-definition/sample-fargate-v2:3"
    ]
}

$ aws ecs list-task-definitions --family-prefix $AWS_TASK_DEFINITION_FAMILY --query 'taskDefinitionArns' --output text > $AWS_TASK_DEFINITION_ARN_TXT

$ cat $AWS_TASK_DEFINITION_ARN_TXT
arn:aws:ecs:eu-west-1:123456789012:task-definition/sample-fargate-v2:3

$ export AWS_TASK_DEFINITION_ARN=`cat $AWS_TASK_DEFINITION_ARN_TXT`
$ echo $AWS_TASK_DEFINITION_ARN
arn:aws:ecs:eu-west-1:123456789012:task-definition/sample-fargate-v2:3
```

##### A.3. deregister-task-definition

```bash
$ aws ecs deregister-task-definition --task-definition $AWS_TASK_DEFINITION_ARN

```

#### B. AWS Web Console

##### B.1. Create definition

<img src="./images/amazon_ecs11.png" alt="amazon_ecs11" style="zoom:50%;" />

##### B.2. Create new revision with JSON

> 從 [Learn how to create a Linux task for the Fargate launch type](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started-fargate.html) 擷取下來的；這邊真的要抱怨一下，前一個章節是介紹建立 container image，結果範例居然不使用該 image，寫這說明文件的人不知在想什麼？

```json
{
    "family": "sample-fargate",
    "networkMode": "awsvpc",
    "containerDefinitions": [
        {
            "name": "fargate-app",
            "image": "public.ecr.aws/docker/library/httpd:latest",
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "entryPoint": [
                "sh",
		"-c"
            ],
            "command": [
                "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
            ]
        }
    ],
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "cpu": "256",
    "memory": "512"
}
```

<img src="./images/amazon_ecs12.png" alt="amazon_ecs12" style="zoom:50%;" />

##### B.3. List

<img src="./images/amazon_ecs13.png" alt="amazon_ecs13" style="zoom:50%;" />

### 5.2.3. Services

#### A. AWS CLI

##### A.1. create-service

```bash
$ export AWS_VPC_SUBNET_ID=subnet-f525c9be
$ export AWS_VPC_SECURITY_GROUP=sg-03ae822762b0fe90f

$ export AWS_ECS_SERVICE_NAME=hello-service
$ export AWS_ECS_SERVICE_JSON=$AWS_ECS_SERVICE_NAME.json
$ export AWS_ECS_SERVICE_RESPONSE_JSON=$AWS_ECS_SERVICE_NAME-response.json
$ export AWS_ECS_SERVICE_EXECUTE_COMMAND=true
$ export AWS_ECS_SERVICE_PUBLIC_IP=ENABLED
#$ export AWS_ECS_SERVICE_PUBLIC_IP=DISABLED
$ export AWS_ECS_SERVICE_DESIRED_COUNT=1

$ cat > "$AWS_ECS_SERVICE_JSON" <<EOF
{
    "cluster": "$AWS_ECS_CLUSTER",
    "serviceName": "$AWS_ECS_SERVICE_NAME",
    "taskDefinition": "$AWS_TASK_DEFINITION_ARN",
    "loadBalancers": [
    ],
    "desiredCount": $AWS_ECS_SERVICE_DESIRED_COUNT,
    "launchType": "FARGATE",
    "platformVersion": "LATEST",
    "networkConfiguration": {
        "awsvpcConfiguration": {
            "subnets": [
                "$AWS_VPC_SUBNET_ID"
            ],
            "securityGroups": [
                "$AWS_VPC_SECURITY_GROUP"
            ],
            "assignPublicIp": "ENABLED"
        }
    },
    "enableExecuteCommand": $AWS_ECS_SERVICE_EXECUTE_COMMAND
}
EOF

# 建立 Service，使用私有子網路的範例。需要 enable-execute-command 選項才能使用 Amazon ECS Exec。
$ aws ecs create-service --cli-input-json file://$AWS_ECS_SERVICE_JSON > $AWS_ECS_SERVICE_RESPONSE_JSON
```

##### A.2. describe-services

```bash
$ aws ecs list-services --cluster $AWS_ECS_CLUSTER --query "serviceArns[]" --output text
arn:aws:ecs:eu-west-1:123456789012:service/hello-cluster/hello-service

$ aws ecs describe-services \
  --cluster $AWS_ECS_CLUSTER \
  --services $AWS_ECS_SERVICE_NAME

$ aws ecs describe-services \
  --cluster $AWS_ECS_CLUSTER \
  --services $AWS_ECS_SERVICE_NAME \
  --query "services[0].{Status:status, TaskDefinition:taskDefinition, DesiredCount:desiredCount, RunningCount:runningCount}" \
  --output table
----------------------------------------------------------------------------------------------
|                                      DescribeServices                                      |
+----------------+---------------------------------------------------------------------------+
|  DesiredCount  |  1                                                                        |
|  RunningCount  |  1                                                                        |
|  Status        |  ACTIVE                                                                   |
|  TaskDefinition|  arn:aws:ecs:eu-west-1:123456789012:task-definition/sample-fargate-v2:2   |
+----------------+---------------------------------------------------------------------------+
```

##### A.3. delete-service

> 刪除前，記得先停止所有的 tasks

```bash
# 調整 Service 的 Desired Count；因此會停止所有的 tasks
$ aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_NAME --desired-count 0

# 強制刪除
$ aws ecs delete-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_NAME --force
```

#### B. AWS Web Console

##### B.1. Select cluster

<img src="./images/amazon_ecs21.png" alt="amazon_ecs21" style="zoom:50%;" />

##### B.2. Create service

<img src="./images/amazon_ecs22.png" alt="amazon_ecs22" style="zoom:50%;" />

##### B.3. Service configuration

> **Launch type**: FARGATE
>
> **Task definition family**: sample-fargate
>
> **Service name**: hello-service
>
> **Desired tasks**: 1
>
> **Networking**
>
> ​	**VPC**:
>
> ​	**Subnets**: subnet-f525c9be
>
> ​	**Security group name**: sg-03ae822762b0fe90f

<img src="./images/amazon_ecs23.png" alt="amazon_ecs23" style="zoom:50%;" />

<img src="./images/amazon_ecs23a.png" alt="amazon_ecs23a" style="zoom:50%;" />

<img src="./images/amazon_ecs23b.png" alt="amazon_ecs23b" style="zoom:50%;" />

<img src="./images/amazon_ecs23c.png" alt="amazon_ecs23c" style="zoom:50%;" />

##### B.4. List

<img src="./images/amazon_ecs24.png" alt="amazon_ecs24" style="zoom:50%;" />

### 5.2.4. Tasks

#### A. AWS CLI

##### A.1. list-tasks

```bash
$ aws ecs describe-services \
  --cluster $AWS_ECS_CLUSTER \
  --services $AWS_ECS_SERVICE_NAME \
  --query "services[0].{Status:status, TaskDefinition:taskDefinition, DesiredCount:desiredCount, RunningCount:runningCount}" \
  --output table
----------------------------------------------------------------------------------------------
|                                      DescribeServices                                      |
+----------------+---------------------------------------------------------------------------+
|  DesiredCount  |  1                                                                        |
|  RunningCount  |  1                                                                        |
|  Status        |  ACTIVE                                                                   |
|  TaskDefinition|  arn:aws:ecs:eu-west-1:123456789012:task-definition/sample-fargate-v2:2   |
+----------------+---------------------------------------------------------------------------+

# 列出 tasks
$ aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --service-name $AWS_ECS_SERVICE_NAME --output text
TASKARNS        arn:aws:ecs:eu-west-1:123456789012:task/hello-cluster/12eea332beef474e8d49065c4feac657

# 如果只有 1 task
$ export AWS_TASK_ID=`aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --service-name $AWS_ECS_SERVICE_NAME --query "taskArns[]" --output text`
$ echo $AWS_TASK_ID

$ aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --desired-status RUNNING
$ aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --desired-status STOPPED

# 查看該 task 的內容
$ aws ecs describe-tasks \
  --cluster $AWS_ECS_CLUSTER \
  --tasks 12eea332beef474e8d49065c4feac657 \
  --query 'tasks[*].[taskArn, lastStatus, desiredStatus, containerInstanceArn, startedAt]' \
  --output table

# 取得 eni-
$ aws ecs describe-tasks --cluster $AWS_ECS_CLUSTER --tasks $AWS_TASK_ID

# 使用 eni- , 取得 Public IP
$ aws ec2 describe-network-interfaces --network-interface-id eni-0ec1a928f7cb2021a

```

##### A.2. stop-task

> 只有 stop

```bash
# 調整 Service 的 Desired Count；因此會停止所有的 tasks
$ aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_NAME --desired-count 0

# 停止特定的 task
$ aws ecs stop-task --cluster $AWS_ECS_CLUSTER --task arn:aws:ecs:eu-west-1:123456789012:task/hello-cluster/12eea332beef474e8d49065c4feac657
```

##### A.3. execute-command

> 請參考 [使用私有子網路部署的測試任務](https://docs.aws.amazon.com/zh_tw/AmazonECS/latest/developerguide/ECS_AWSCLI_Fargate.html)

```bash
$ curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"

# install
$ sudo dpkg -i session-manager-plugin.deb

# remove
$ sudo dpkg -r session-manager-plugin
```

```bash
$ cd /work/codebase/Docker
$ git clone https://github.com/aws-containers/amazon-ecs-exec-checker.git

$ export AWS_TASK_ID=`aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --service-name $AWS_ECS_SERVICE_NAME --query "taskArns[]" --output text`
$ echo $AWS_TASK_ID

$ /work/codebase/Docker/amazon-ecs-exec-checker/check-ecs-exec.sh $AWS_ECS_CLUSTER $AWS_TASK_ID
```

```bash
$ aws ecs execute-command --cluster $AWS_ECS_CLUSTER \
  --task $AWS_TASK_ID \
  --container $AWS_TASK_DEFINITION_CONTAINER_NAME \
  --interactive \
  --command "/bin/sh"
```

#### B. AWS Web Console

##### B.1. Select task

<img src="./images/amazon_ecs31.png" alt="amazon_ecs31" style="zoom:50%;" />

##### B.2. Configuration

<img src="./images/amazon_ecs32.png" alt="amazon_ecs32" style="zoom:50%;" />

### 5.2.5. Show time

> http://34.244.233.173

<img src="./images/amazon_ecs41.png" alt="amazon_ecs41" style="zoom:50%;" />

# 6. [Networking](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/networking-outbound.html)

## 6.1. Public subnet and internet gateway

> 這邊的設定比較簡單

![](https://docs.aws.amazon.com/images/AmazonECS/latest/developerguide/images/public-network.png)

> 這邊的設定比較簡單，只要有 public subnet 就可以了

## 6.2. Private subnet and NAT gateway

![](https://docs.aws.amazon.com/images/AmazonECS/latest/developerguide/images/private-network.png)

> 請參考 [helper_AmazonEC2.md](https://github.com/lankahsu520/HelperX/blob/master/helper_AmazonEC2.md) 進行相關的設定。 

```bash
# 設定成 private subnet
export AWS_VPC_SUBNET_ID=subnet-018a98c18b970bc4e

# 關閉 assignPublicIp
export AWS_ECS_SERVICE_PUBLIC_IP=DISABLED
```

# Appendix

# I. Study

## I.1. Official - [Amazon Elastic Container Service (Developer Guide)](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)

# II. Debug

# III. Glossary

# IV. Tool Usage

#### A. [aws-ecs-hello.sh](https://github.com/lankahsu520/HelperX/blob/master/AWS/ECS/aws-ecs-hello.sh)

> 將 4.2. Farget，打包成一個 shell script

```bash
$ ./aws-ecs-hello.sh
aws-ecs-hello.sh {create|execute|query}

# 上傳 docker image, 建立 role、cluster、task definitionserbivice
$ ./aws-ecs-hello.sh create

# docker attach 該 task (Container)
$ ./aws-ecs-hello.sh execute

# 查詢 cluster / service
$ ./aws-ecs-hello.sh query
```

#### B. [aws-ecs-bye.sh](https://github.com/lankahsu520/HelperX/blob/master/AWS/ECS/aws-ecs-bye.sh)

> 清除 4.2. Farget 所建立的


# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
