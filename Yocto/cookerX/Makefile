.EXPORT_ALL_VARIABLES:

include mk/function.mk

#********************************************************************************
#** CLEANDIRS **
#********************************************************************************
LIBS_CHECK_yes = 
BINS_CHECK_yes =

# USERS_yes
include mk/user.mk

BB_TASKS=listtasks configure clean cleanall fetch compile build install package_qa#
#BB ?= avahi

.DEFAULT_GOAL = all

# .cook-build -> cook-patched -> .cook-update -> .cook-init
.PHONY: all distclean cook cook-clean cook-build dry-run
all: cook-build check

cook-clean:
	rm -f .cook-*

distclean: cook-clean
	rm -rf builds

dry-run:
	./cooker_123.sh dry-run

cook-build: .cook-patched
	./cooker_123.sh build

cook:
	./cooker_123.sh cook

.cook-init:
	# please use cooker_123.sh, dont call "cooker init xxx/xxx.json"
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

.PHONY: build-history builds-lnk builds-linker bb-lnk bb-linker toolchain toolchain_pure $(BB_TASKS)
build-history:
	@cd builds/build-$(PJ_YOCTO_TARGET) \
	&& buildhistory-collect-srcrevs -a

builds-lnk:
	@cd builds_lnk \
	&& ls -al --color=auto

builds-linker:
	./builds_linker.sh

bb-lnk:
	@cd bb_lnk \
	&& ls -al --color=auto

bb-linker:
	./bb_linker.sh

bb-list:
	bitbake -s

linker: bb-linker builds-linker

toolchain:
	#cooker build -s $(PJ_YOCTO_TARGET)
	bitbake core-image-base -c populate_sdk

toolchain_pure:
	bitbake meta-toolchain

$(BB_TASKS):
	@echo "BB_TASK=[$@], BB=[$(BB)]"
ifeq ("$(BB)", "")
	@echo "Example:"
	@echo "  make listtasks BB=avahi"
	@echo "  make configure BB=avahi"
	@echo "  make clean BB=avahi"
	@echo "  make cleanall BB=avahi"
	@echo "  make fetch BB=avahi"
	@echo "  make compile BB=avahi"
	@echo "  make build BB=avahi"
	@echo "  make install BB=avahi"
	@echo "  make package_qa BB=avahi"
else
	@for BBx in $(BB); do \
		echo "[bitbake -c $@ $$BBx]"; \
		bitbake -c $@ $$BBx; \
	done
endif
	@echo

%:
	@: