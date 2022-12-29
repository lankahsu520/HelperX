.EXPORT_ALL_VARIABLES:

include mk/function.mk

#********************************************************************************
#** CLEANDIRS **
#********************************************************************************
LIBS_CHECK_yes = 
BINS_CHECK_yes =

# USERS_yes
include mk/user.mk

#make listtasks R=yokisv5
R ?= yokisv5

TASKS=listtasks configure clean cleanall fetch compile build install package_qa#
MAKE_ARG=$(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL = all

.PHONY: all cook cook-build dry-run generate toolchain toolchain_pure $(TASKS)
generate:
	./cooker_123.sh generate

dry-run:
	./cooker_123.sh dry-run

cook-build:
	./cooker_123.sh build

cook:
	./cooker_123.sh cook

all: cook check

toolchain:
	#cooker build -s $(PJ_YOCTO_TARGET)
	bitbake core-image-base -c populate_sdk

toolchain_pure:
	bitbake meta-toolchain

$(TASKS):
	@echo "TASK=[$@], R=[$(R)], MAKE_ARG=[$(MAKE_ARG)]"
ifneq ("$(R)", "")
	bitbake -c $@ $(R)
else
	@echo "Please input [R]ECIPE !!!"
endif
	@echo

%:
	@: