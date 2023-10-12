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

BB_TASKS=listtasks configure clean cleanall fetch compile build install package_qa#
MAKE_ARG=$(filter-out $@,$(MAKECMDGOALS))

.DEFAULT_GOAL = all

# .cook-build -> cook-patched -> .cook-update -> .cook-init
.PHONY: all cook cook-clean cook-build dry-run toolchain toolchain_pure $(BB_TASKS)
all: cook-build check

cook-clean:
	@rm -f .cook-*

dry-run:
	./cooker_123.sh dry-run

cook-build: .cook-patched
	./cooker_123.sh build

cook:
	./cooker_123.sh cook

.cook-init:
	./cooker_123.sh init
	touch $@

.cook-update: .cook-init
	./cooker_123.sh update
	touch $@

.cook-generate: .cook-update 
	./cooker_123.sh generate
	touch $@

.cook-patched: .cook-generate
	@if [ -d patches/$(PJ_YOCTO_LAYERS) ]; then \
		cp -avr patches/$(PJ_YOCTO_LAYERS)/* $(PJ_YOCTO_LAYERS); \
	fi
	touch $@

history:
	@cd builds/build-$(PJ_YOCTO_TARGET) \
	&& buildhistory-collect-srcrevs -a

toolchain:
	#cooker build -s $(PJ_YOCTO_TARGET)
	bitbake core-image-base -c populate_sdk

toolchain_pure:
	bitbake meta-toolchain

$(BB_TASKS):
	@echo "BB_TASK=[$@], R=[$(R)], MAKE_ARG=[$(MAKE_ARG)]"
ifneq ("$(R)", "")
	bitbake -c $@ $(R)
else
	@echo "Please input [R]ECIPE !!!"
endif
	@echo

%:
	@: