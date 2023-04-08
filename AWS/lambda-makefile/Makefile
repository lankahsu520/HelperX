PWD=$(shell pwd)
-include $(SDK_CONFIG_CONFIG)

#** include *.mk **
include define.mk

#[major].[minor].[revision].[build]
VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_REVISION = 0
VERSION_FULL = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_REVISION)
LIBNAME_A = xxx
LIBNAME_SO =
LIBNAME_MOD =

#********************************************************************************
#** All **
#********************************************************************************
# all -> $(S3_BUCKET_CHK) -> .customer 

.DEFAULT_GOAL = all

.PHONY: all clean distclean install romfs layer
all: envs $(S3_BUCKET_CHK)

clean:
	$(PJ_SH_RM) export.log
	$(PJ_SH_RM) .configured
	$(PJ_SH_RMDIR) node_modules/ $(S3_BUCKET_CHK) $(CONTENT_URI)/ $(OUTPUT_TEMPLATE_FILE) $(RESULT_JSON_FILE)
	$(PJ_SH_RM) $(PJ_NAME)/version.txt
	@for subdir in $(CONFS_yes); do \
		[ -d "$$subdir" ] && (make -C $$subdir $@;) || echo "skip !!! ($$subdir)"; \
	done

distclean: clean

envs:
	@echo '----->> $@'
	@echo 'PROJECT_JSON: $(PROJECT_JSON)'
	@echo 'RUNTIME: $(RUNTIME)'
	@echo 'RUNTIME_SHORT: $(RUNTIME_SHORT)'

	@echo 'STACK_NAME: $(STACK_NAME)'

	@echo 'S3_BUCKET_NAME: $(S3_BUCKET_NAME)'

	@echo 'LAMBDA_FUNCTION_DIR: $(LAMBDA_FUNCTION_DIR)'

	@echo 'EVENT_JSON_FILE: $(EVENT_JSON_FILE)'
	@echo 'RESULT_JSON_FILE: $(RESULT_JSON_FILE)'

	@echo 'CONTENT_URI: $(CONTENT_URI)'
	@echo 'TEMPLATE_FILE: $(TEMPLATE_FILE)'
	@echo 'OUTPUT_TEMPLATE_FILE: $(OUTPUT_TEMPLATE_FILE)'
	@echo

layer_generate: layer_$(RUNTIME_SHORT)
	@echo

run_python: layer_generate
	@echo '----->> $@'
	@if [ -f "$(LAMBDA_FUNCTION_DIR)/lambda_function.test.py" ]; then \
		PYTHONPATH=$(CONTENT_URI)/python python3 $(LAMBDA_FUNCTION_DIR)/lambda_function.test.py; \
	elif [ -f "$(LAMBDA_FUNCTION_DIR)/lambda_function.py" ]; then \
		PYTHONPATH=$(CONTENT_URI)/python python3 $(LAMBDA_FUNCTION_DIR)/lambda_function.py; \
	fi

run_nodejs: layer_generate
	@echo '----->> $@'
	AWS_REGION=$(REGION) npm run test

run: run_$(RUNTIME_SHORT)
	@echo

s3_bucket_found:
	$(eval S3_BUCKET_FOUND:=$(shell aws s3 ls | grep $(S3_BUCKET_NAME) | cut -d" " -f3))

$(S3_BUCKET_CHK): s3_bucket_found
	@echo '----->> $@ - $(S3_BUCKET_NAME)'
	@[ "$(S3_BUCKET_FOUND)" = "" ] \
	&& aws s3 mb s3://$(S3_BUCKET_NAME) \
	|| echo "Found $(S3_BUCKET_NAME) !!!"
	@touch $@

s3_bucket_rb: s3_bucket_found
	@echo '----->> $@ - s3://$(S3_BUCKET_NAME)'
	@[ "$(S3_BUCKET_FOUND)" != "" ] \
	&& aws s3 rb --force s3://$(S3_BUCKET_NAME) \
	|| echo "Not Found $(S3_BUCKET_NAME) !!!"

s3_object_found:
	$(eval S3_OBJECT_FOUND:=$(shell aws s3 ls s3://$(S3_BUCKET_NAME) | grep "$(STACK_NAME)/"))

s3_object_rm: s3_object_found
	@echo '----->> $@ - s3://$(S3_BUCKET_NAME)/$(STACK_NAME)'
	@[ "$(S3_OBJECT_FOUND)" != "" ] \
	&& aws s3 rm --recursive s3://$(S3_BUCKET_NAME)/$(STACK_NAME) \
	|| echo "Not Found s3://$(S3_BUCKET_NAME)/$(STACK_NAME) !!!"

layer_python:
	@echo '----->> $@ - $(PWD)/$(CONTENT_URI)/'
	@[ ! -d "./$(CONTENT_URI)" ] \
	&& cd $(LAMBDA_FUNCTION_DIR) \
	&& pip3 install --target ../$(CONTENT_URI)/python -r requirements.txt \
	|| echo

layer_nodejs:
	@echo '----->> $@ - $(PWD)/$(CONTENT_URI)/nodejs'
	@[ ! -d "./$(CONTENT_URI)/nodejs" ] \
	&& mkdir -p $(PWD)/$(CONTENT_URI)/nodejs \
	&& rm -rf node_modules \
	&& npm install --production \
	&& cp -avr node_modules $(CONTENT_URI)/nodejs/ \
	|| echo

deploy_s3_object: layer_generate
	@echo '----->> $@ - ./$(CONTENT_URI)'
	@[ -d "./$(CONTENT_URI)" ] \
	&& aws cloudformation \
			package \
			--template-file $(TEMPLATE_FILE) \
			--s3-bucket $(S3_BUCKET_NAME) \
			--s3-prefix $(STACK_NAME)/ \
			--output-template-file $(OUTPUT_TEMPLATE_FILE) \
	|| echo "Not Found ./$(CONTENT_URI) !!!"

deploy_s3: deploy_s3_object

deploy_stack: deploy_s3 s3_object_found
	@echo '----->> $@ - $(STACK_NAME)'
	@[ "$(S3_OBJECT_FOUND)" != "" ] \
	&& aws cloudformation deploy \
		--template-file $(OUTPUT_TEMPLATE_FILE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
	|| echo "Not Found s3://$(S3_BUCKET_NAME) !!!"

lambda_function_found:
	$(eval LAMBDA_FUNCTION_FOUND:=$(shell aws cloudformation describe-stack-resource --stack-name $(STACK_NAME) --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text 2>/dev/null))

# deploy_all -> deploy_stack -> deploy_s3
deploy_all: deploy_stack lambda_function_found
	@echo '----->> $@ - $(LAMBDA_FUNCTION_FOUND)'
	@echo

delete_s3: s3_object_rm

delete_stack: lambda_function_found delete_s3
	@echo '----->> $@ - $(STACK_NAME)'
	@[ "$(LAMBDA_FUNCTION_FOUND)" != "" ] \
	&& aws cloudformation delete-stack --stack-name $(STACK_NAME) 2>/dev/null \
	|| echo "Not Found $(STACK_NAME) !!!"

delete_log_group: delete_stack
	@echo '----->> $@ - $(STACK_NAME) & /aws/lambda/$(LAMBDA_FUNCTION_FOUND)'
	@[ "$(LAMBDA_FUNCTION_FOUND)" != "" ] \
	&& aws logs delete-log-group --log-group-name /aws/lambda/$(LAMBDA_FUNCTION_FOUND) 2>/dev/null \
	|| echo "Not Found (/aws/lambda/$(LAMBDA_FUNCTION_FOUND)) !!!"

# delete_all -> delete_log_group -> delete_stack -> delete_s3
delete_all: envs delete_log_group
	@echo

invoke: lambda_function_found
	@echo '----->> $@ - $(STACK_NAME) & $(LAMBDA_FUNCTION_FOUND)'
	@[ "$(LAMBDA_FUNCTION_FOUND)" != "" ] \
	&& aws lambda invoke \
		--function-name $(LAMBDA_FUNCTION_FOUND) \
		$(PAYLOAD_ARG) \
		$(RESULT_JSON_FILE) \
	&& cat $(RESULT_JSON_FILE) \
	&& echo \
	|| echo "Not Found (LAMBDA_FUNCTION_FOUND) !!!"

