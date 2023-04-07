ifeq ("$(PJ_ROOT)", "")
PJ_ROOT=`pwd`
endif

ifeq ("$(PJ_BUILDER)", "")
PJ_BUILDER=`whoami`
endif

ifeq ("$(PJ_SH_CP)", "")
PJ_SH_CP=cp -avrf
endif

ifeq ("$(PJ_SH_MKDIR)", "")
PJ_SH_MKDIR=mkdir -p
endif

ifeq ("$(PJ_SH_RMDIR)", "")
PJ_SH_RMDIR=rm -rf
endif

ifeq ("$(PJ_SH_RM)", "")
PJ_SH_RM=rm -f
endif

#** AWS Lambda **
PROJECT_JSON = project.json
ifneq ("$(wildcard $(PROJECT_JSON))","")
	STACK_NAME=$(shell jq -cr '.stack_name' $(PROJECT_JSON))

	S3_BUCKET_NAME=$(shell jq -cr '.s3_bucket_name' $(PROJECT_JSON))
	#LAMBDA_FUNCTION_NAME=$(shell jq -cr '.lambda_function_name' $(PROJECT_JSON))

	EVENT_JSON_FILE=$(shell jq -cr '.event_json_file' $(PROJECT_JSON))
	RESULT_JSON_FILE=$(shell jq -cr '.result_json_file' $(PROJECT_JSON))

	TEMPLATE_FILE=$(shell jq -cr '.template_file' $(PROJECT_JSON))
	OUTPUT_TEMPLATE_FILE=$(shell jq -cr '.output_template_file' $(PROJECT_JSON))

	LAMBDA_FUNCTION_DIR=$(strip $(shell cat $(TEMPLATE_FILE) | grep CodeUri | cut -d":" -f2 | cut -d"/" -f1))
	#LAMBDA_FUNCTION_DIR=$(shell jq -cr '.lambda_function_dir' $(PROJECT_JSON))

	#CONTENT_URI=$(shell cat $(TEMPLATE_FILE) | grep ContentUri | cut -d":" -f2 | cut -d"/" -f1)
	CONTENT_URI=$(strip $(shell cat $(TEMPLATE_FILE) | grep ContentUri | cut -d":" -f2 | cut -d"/" -f1))
	#CONTENT_URI=$(shell jq -cr '.package_name' $(PROJECT_JSON))

	RUNTIME=$(strip $(shell cat $(TEMPLATE_FILE) | grep "Runtime:" | cut -d":" -f2))
else
	$(error Can't find $(PROJECT_JSON) !!!")
endif

FUNCTION_FILES = $(wildcard $(LAMBDA_FUNCTION_DIR)/*)

S3_BUCKET_CHK=.s3_bucket_chk
S3_BUCKET_FOUND=

LAMBDA_FUNCTION_FOUND=

ifneq ("$(findstring python,$(RUNTIME))", "")
RUNTIME_SHORT=python
else
RUNTIME_SHORT=nodejs
endif

REGION=$(shell aws configure get region)