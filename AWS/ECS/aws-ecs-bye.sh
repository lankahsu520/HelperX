#!/bin/sh

export AWS_DEFAULT_REGION=eu-west-1
export AWS_REPOSITORY_NAME=hello-repository
export AWS_REPOSITORY_JSON=$AWS_REPOSITORY_NAME.json

export DOCKER_IMAGE_NAME=hello-world
#export DOCKER_IMAGE_NAME=ecr-ubuntu:20.04v8
#export DOCKER_IMAGE_NAME=ecr-ubuntu

export AWS_ECS_CLUSTER=hello-cluster
export AWS_ECS_ROLE=ecsTaskExecutionRole


export AWS_TASK_DEFINITION_JSON=hello-task-definition.json
export AWS_TASK_DEFINITION_ARN_TXT=hello-task-definition-arn.txt
export AWS_TASK_DEFINITION_FAMILY=sample-fargate-v2


export AWS_VPC_SUBNET=subnet-f525c9be
export AWS_VPC_SECURITY_GROUP=sg-0479b628c3f87df12


export AWS_ECS_SERVICE_NAME=hello-service
export AWS_ECS_SERVICE_JSON=$AWS_ECS_SERVICE_NAME.json
export AWS_ECS_SERVICE_RESPONSE_JSON=$AWS_ECS_SERVICE_NAME-response.json



#*******************************************************************************
#** Amazon Elastic Container Registry **
#*******************************************************************************

aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_NAME --desired-count 0

aws ecs delete-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_NAME --force

aws ecs deregister-task-definition --task-definition $AWS_TASK_DEFINITION_ARN

aws ecs delete-cluster --cluster $AWS_ECS_CLUSTER


#*******************************************************************************
#** IAM **
#*******************************************************************************

aws iam list-attached-role-policies --role-name ecsTaskExecutionRole
aws iam detach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
aws iam list-role-policies --role-name ecsTaskExecutionRole
aws iam delete-role --role-name ecsTaskExecutionRole


#*******************************************************************************
#** Amazon Elastic Container Registry **
#*******************************************************************************
aws ecr delete-repository --repository-name $AWS_REPOSITORY_NAME --region $AWS_DEFAULT_REGION --force