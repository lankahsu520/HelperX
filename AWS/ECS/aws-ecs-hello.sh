#!/bin/sh

export AWS_DEFAULT_REGION=eu-west-1
export AWS_REPOSITORY_NAME=hello-repository
export AWS_REPOSITORY_JSON=$AWS_REPOSITORY_NAME.json
export AWS_REPOSITORY_TAG=latest

export DOCKER_IMAGE_NAME=hello-world
#export DOCKER_IMAGE_NAME=ecr-ubuntu:20.04v8
#export DOCKER_IMAGE_NAME=ecr-ubuntu

export AWS_ECS_CLUSTER=hello-cluster
export AWS_ECS_ROLE=ecsTaskExecutionRole


export AWS_TASK_DEFINITION_JSON=hello-task-definition.json
export AWS_TASK_DEFINITION_ARN_TXT=hello-task-definition-arn.txt
export AWS_TASK_DEFINITION_FAMILY=sample-fargate-v2

export AWS_TASK_DEFINITION_HOST_PORT=80
export AWS_TASK_DEFINITION_CONTAINER_NAME=fargate-app
export AWS_TASK_DEFINITION_CONTAINER_PORT=80
export AWS_TASK_DEFINITION_PROTOCOL=tcp

export AWS_TASK_DEFINITION_CPU=256
export AWS_TASK_DEFINITION_MEMORY=512

export AWS_VPC_SUBNET=subnet-f525c9be
export AWS_VPC_SECURITY_GROUP=sg-0479b628c3f87df12


export AWS_ECS_SERVICE_NAME=hello-service
export AWS_ECS_SERVICE_JSON=$AWS_ECS_SERVICE_NAME.json
export AWS_ECS_SERVICE_RESPONSE_JSON=$AWS_ECS_SERVICE_NAME-response.json

export AWS_LOG_DRIVER=awslogs
export AWS_LOG_GROUP=awslogs-wordpress
export AWS_LOG_PREFIX=awslogs-example

#*******************************************************************************
#** Amazon Elastic Container Registry **
#*******************************************************************************

# Create a repository
aws ecr create-repository --repository-name $AWS_REPOSITORY_NAME --region $AWS_DEFAULT_REGION > $AWS_REPOSITORY_JSON
export AWS_REPOSITORY_URI=$(cat $AWS_REPOSITORY_JSON  | jq -r '.repository.repositoryUri')
echo $AWS_REPOSITORY_URI
aws ecr describe-repositories --query 'repositories[]. [repositoryName, repositoryUri]' --output table

# Tag the Docker Image
docker tag $DOCKER_IMAGE_NAME $AWS_REPOSITORY_URI

# Push the Docker Image to Amazon ECR
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_REPOSITORY_URI

docker push $AWS_REPOSITORY_URI

aws ecr describe-images --repository-name $AWS_REPOSITORY_NAME


#*******************************************************************************
#** IAM **
#*******************************************************************************

# Create IAM role
aws iam create-role \
  --role-name $AWS_ECS_ROLE \
  --assume-role-policy-document file://<(cat <<EOF
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
)

aws iam attach-role-policy \
  --role-name $AWS_ECS_ROLE \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

export AWS_ECS_ROLE_ARN=`aws iam get-role --role-name $AWS_ECS_ROLE --query 'Role.Arn' --output text`


#*******************************************************************************
#** Amazon Elastic Container Service **
#*******************************************************************************

# Create Cluster
aws ecs create-cluster --cluster-name $AWS_ECS_CLUSTER

# Create task definition
cat > "$AWS_TASK_DEFINITION_JSON" <<EOF
{
    "family": "$AWS_TASK_DEFINITION_FAMILY",
    "networkMode": "awsvpc",
    "executionRoleArn": "$AWS_ECS_ROLE_ARN",
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

aws ecs register-task-definition --cli-input-json file://$AWS_TASK_DEFINITION_JSON

aws ecs list-task-definitions --family-prefix $AWS_TASK_DEFINITION_FAMILY --query 'taskDefinitionArns' --output text > $AWS_TASK_DEFINITION_ARN_TXT
cat $AWS_TASK_DEFINITION_ARN_TXT

export AWS_TASK_DEFINITION_ARN=`cat $AWS_TASK_DEFINITION_ARN_TXT`
echo $AWS_TASK_DEFINITION_ARN

# Create service
cat > "$AWS_ECS_SERVICE_JSON" <<EOF
{
    "cluster": "$AWS_ECS_CLUSTER",
    "serviceName": "$AWS_ECS_SERVICE_NAME",
    "taskDefinition": "$AWS_TASK_DEFINITION_ARN",
    "loadBalancers": [
    ],
    "desiredCount": 1,
    "launchType": "FARGATE",
    "platformVersion": "LATEST",
    "networkConfiguration": {
        "awsvpcConfiguration": {
            "subnets": [
                "$AWS_VPC_SUBNET"
            ],
            "securityGroups": [
                "$AWS_VPC_SECURITY_GROUP"
            ],
            "assignPublicIp": "ENABLED"
        }
    }
}
EOF

aws ecs create-service --cli-input-json file://$AWS_ECS_SERVICE_JSON > $AWS_ECS_SERVICE_RESPONSE_JSON
