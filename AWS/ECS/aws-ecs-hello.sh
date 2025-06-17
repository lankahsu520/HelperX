#!/bin/sh

RUN_SH=`basename $0`
HINT="$RUN_SH {create|execute|query}"

export AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text`
export AWS_DEFAULT_REGION=eu-west-1
export AWS_REPOSITORY_NAME=hello-repository
export AWS_REPOSITORY_JSON=$AWS_REPOSITORY_NAME.json
export AWS_REPOSITORY_TAG=latest

export AWS_DOCKER_IMAGE_NAME=hello-world
#export AWS_DOCKER_IMAGE_NAME=ecr-ubuntu:20.04v8
#export AWS_DOCKER_IMAGE_NAME=ecr-ubuntu

export AWS_ECS_CLUSTER=hello-cluster
export AWS_ECS_ROLE=ecsTaskExecutionRole
export AWS_ECS_ROLE_ARN=
export AWS_ECS_ROLE_JSON=$AWS_ECS_ROLE.json
export AWS_ECS_ROLE_POLICY_JSON=$AWS_ECS_ROLE_POLICY.json

export AWS_TASK_DEFINITION_JSON=hello-task-definition.json
export AWS_TASK_DEFINITION_ARN_TXT=hello-task-definition-arn.txt
export AWS_TASK_DEFINITION_ARN=
export AWS_TASK_DEFINITION_FAMILY=sample-fargate-v2

export AWS_TASK_DEFINITION_HOST_PORT=80
export AWS_TASK_DEFINITION_CONTAINER_NAME=fargate-app
export AWS_TASK_DEFINITION_CONTAINER_PORT=80
export AWS_TASK_DEFINITION_PROTOCOL=tcp

export AWS_TASK_DEFINITION_CPU=256
export AWS_TASK_DEFINITION_MEMORY=512

# use public subnet
export AWS_VPC_SUBNET_ID=subnet-f525c9be
# use private subnet
#export AWS_VPC_SUBNET_ID=subnet-018a98c18b970bc4e
export AWS_VPC_SECURITY_GROUP=sg-0479b628c3f87df12

export AWS_ECS_SERVICE_NAME=hello-service
export AWS_ECS_SERVICE_JSON=$AWS_ECS_SERVICE_NAME.json
export AWS_ECS_SERVICE_RESPONSE_JSON=$AWS_ECS_SERVICE_NAME-response.json
#export AWS_ECS_SERVICE_EXECUTE_COMMAND=false
export AWS_ECS_SERVICE_EXECUTE_COMMAND=true
#export AWS_ECS_SERVICE_PUBLIC_IP=ENABLED
export AWS_ECS_SERVICE_PUBLIC_IP=DISABLED
export AWS_ECS_SERVICE_DESIRED_COUNT=1

export AWS_LOG_DRIVER=awslogs
export AWS_LOG_GROUP=awslogs-wordpress
export AWS_LOG_PREFIX=awslogs-example

export AWS_TASK_ID=

ACTION=$1

die_fn()
{
	echo "$@"
	exit 1
}

#*******************************************************************************
#** Amazon Elastic Container Registry **
#*******************************************************************************
ECR_create_fn()
{
	# Create a repository
	aws ecr create-repository --repository-name $AWS_REPOSITORY_NAME --region $AWS_DEFAULT_REGION > $AWS_REPOSITORY_JSON
	export AWS_REPOSITORY_URI=$(cat $AWS_REPOSITORY_JSON  | jq -r '.repository.repositoryUri')
	echo $AWS_REPOSITORY_URI
	aws ecr describe-repositories --query 'repositories[]. [repositoryName, repositoryUri]' --output table

	# Tag the Docker Image
	docker tag $AWS_DOCKER_IMAGE_NAME $AWS_REPOSITORY_URI

	# Push the Docker Image to Amazon ECR
	aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_REPOSITORY_URI

	docker push $AWS_REPOSITORY_URI

	aws ecr describe-images --repository-name $AWS_REPOSITORY_NAME
}

#*******************************************************************************
#** IAM **
#*******************************************************************************
IAM_create_fn()
{
	cat > "$AWS_ECS_ROLE_JSON" <<EOF
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

	# Create IAM role
	aws iam create-role \
  --role-name $AWS_ECS_ROLE \
  --assume-role-policy-document file://$AWS_ECS_ROLE_JSON

	# attach-role-policy - AmazonECSTaskExecutionRolePolicy
	aws iam attach-role-policy \
  --role-name $AWS_ECS_ROLE \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

	# put-role-policy - ecsCreateECSexec
	cat > "$AWS_ECS_ROLE_POLICY_JSON" <<EOF
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

	aws iam put-role-policy \
  --role-name $AWS_ECS_ROLE \
  --policy-name ecsCreateECSexec \
  --policy-document file://$AWS_ECS_ROLE_POLICY_JSON
}

IAM_ROLE_ARN_fn()
{
	AWS_ECS_ROLE_ARN=`aws iam get-role --role-name $AWS_ECS_ROLE --query 'Role.Arn' --output text`
}

#*******************************************************************************
#** Amazon Elastic Container Service **
#*******************************************************************************
ECS_CLUSTER_create_fn()
{
	# Create Cluster
	aws ecs create-cluster --cluster-name $AWS_ECS_CLUSTER
}

ECS_TASK_DEFINITION_create_fn()
{
	[ -z "$AWS_ECS_ROLE_ARN" ] && { die_fn "AWS_ECS_ROLE_ARN is NULL !!!";}

	# Create task definition
	cat > "$AWS_TASK_DEFINITION_JSON" <<EOF
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

	aws ecs register-task-definition --cli-input-json file://$AWS_TASK_DEFINITION_JSON

	aws ecs list-task-definitions --family-prefix $AWS_TASK_DEFINITION_FAMILY --query 'taskDefinitionArns' --output text > $AWS_TASK_DEFINITION_ARN_TXT
	cat $AWS_TASK_DEFINITION_ARN_TXT

	export AWS_TASK_DEFINITION_ARN=`cat $AWS_TASK_DEFINITION_ARN_TXT`
	echo $AWS_TASK_DEFINITION_ARN
}

ECS_SERVICE_create_fn()
{
	# Create service
	cat > "$AWS_ECS_SERVICE_JSON" <<EOF
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
          "assignPublicIp": "$AWS_ECS_SERVICE_PUBLIC_IP"
      }
  },
  "enableExecuteCommand": $AWS_ECS_SERVICE_EXECUTE_COMMAND
}
EOF

	aws ecs create-service --cli-input-json file://$AWS_ECS_SERVICE_JSON > $AWS_ECS_SERVICE_RESPONSE_JSON
}

ECS_SERVICE_query_fn()
{
	aws ecs describe-services --cluster $AWS_ECS_CLUSTER --services $AWS_ECS_SERVICE_NAME
}

ECS_TASK_ID_fn()
{
	# cd /work/codebase/Docker
	# git clone https://github.com/aws-containers/amazon-ecs-exec-checker.git
	AWS_TASK_ID=`aws ecs list-tasks --cluster $AWS_ECS_CLUSTER --service-name $AWS_ECS_SERVICE_NAME --query "taskArns[]" --output text`
	echo $AWS_TASK_ID
}

ECS_TASK_execute_fn()
{
	[ -z "$AWS_TASK_ID" ] && { die_fn "AWS_TASK_ID is NULL !!!";}

	# cd /work/codebase/Docker
	# git clone https://github.com/aws-containers/amazon-ecs-exec-checker.git
	# /work/codebase/Docker/amazon-ecs-exec-checker/check-ecs-exec.sh $AWS_ECS_CLUSTER $AWS_TASK_ID

	aws ecs execute-command --cluster $AWS_ECS_CLUSTER \
  --task $AWS_TASK_ID \
  --container $AWS_TASK_DEFINITION_CONTAINER_NAME \
  --interactive \
  --command "/bin/sh"
}

ECS_TASK_EXEC_check_fn()
{
	# cd /work/codebase/Docker
	# git clone https://github.com/aws-containers/amazon-ecs-exec-checker.git
	[ -z "$AWS_TASK_ID" ] && { die_fn "AWS_TASK_ID is NULL !!!";}

	/work/codebase/Docker/amazon-ecs-exec-checker/check-ecs-exec.sh $AWS_ECS_CLUSTER $AWS_TASK_ID
}

create_fn()
{
	ECR_create_fn

	#IAM_create_fn
	IAM_ROLE_ARN_fn

	ECS_CLUSTER_create_fn
	ECS_TASK_DEFINITION_create_fn

	ECS_SERVICE_create_fn
}

execute_fn()
{
	ECS_TASK_ID_fn
	ECS_TASK_execute_fn
}

query_fn()
{
	ECS_SERVICE_query_fn
}

showusage_fn()
{
	printf "$HINT"; echo; exit 1

	return 0
}

main_fn()
{
	case $ACTION in
		create)
			create_fn
		;;
		execute)
			execute_fn
		;;
		query)
			query_fn
		;;
		*)
			showusage_fn
		;;
	esac
}

main_fn

exit 0
