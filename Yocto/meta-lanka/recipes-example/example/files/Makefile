PWD=$(shell pwd)
-include $(SDK_CONFIG_CONFIG)

#** include *.mk **
-include define.mk

#[major].[minor].[revision].[build]
VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_REVISION = 0
VERSION_FULL = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_REVISION)
LIBNAME_A = helloworld
LIBNAME_SO =
LIBNAME_MOD =

#** CFLAGS & LDFLAGS **
CXX_SET=.cpp
CC_SET=$(CC)
ifneq ("$(CXX_SET)", "")
CC_SET=$(CXX)
endif
CFLAGS += $(CFLAGS_OTHERS) $(CFLAGS_CUSTOMER)

CFLAGS += \
					-I./
ifeq ("$(PJ_ARCH)", "x86")
CFLAGS += \
					-Wno-unused-value \
					-Wno-unused-result \
					-Wno-format-truncation
endif
LDFLAGS += \
					-Wl,-rpath,./ \
					-L./
ARFLAGS = rcs

#** LIBXXX_OBJS **
LIBXXX_OBJS += \

# cpp
LIBXXX_OBJS += \

#** LIBXXX_yes **
ifneq ("$(LIBNAME_A)", "")
LIBXXX_A = lib$(LIBNAME_A).a
LIBXXXS_yes += $(LIBXXX_A)
endif
ifneq ("$(LIBNAME_SO)", "")
LIBXXX_SO = lib$(LIBNAME_SO).so
LIBXXXS_yes += -l$(LIBNAME_SO)
endif
ifneq ("$(LIBNAME_MOD)", "")
LIBXXX_MOD = $(LIBNAME_MOD).so
endif

#** HEADER_FILES **
HEADER_FILES = \

#** librarys **
LIBS_yes = $(LIBXXXS_yes)
#** LIBS_yes, CLEAN_BINS, DUMMY_BINS  **
#ifneq ("$(wildcard ./library.mk)","")
#-include ./library.mk
#else
#-include $(PJ_MK_USER_LIB)
#endif

LIBS += $(LIBS_yes)

#** Clean **
CLEAN_OBJS = $(LIBXXX_OBJS)
CLEAN_LIBS = $(LIBXXX_A) $(LIBXXX_SO) $(LIBXXX_MOD)

#** Target (CLEAN_BINS) **
CLEAN_BINS += \

# cpp
CLEAN_BINS += \

#** Target (DUMMY_BINS) **
DUMMY_BINS += \
							helloworld-123

# cpp
DUMMY_BINS += \

CLEAN_BINS += $(DUMMY_BINS)
CLEAN_OBJS += $(addsuffix .o, $(CLEAN_BINS))

#** Target (SHELL_SBINS) **
SHELL_SBINS = \

DUMMY_SBINS = $(SHELL_SBINS)

#** Target (CONFS) **
CONFS = \
				$(wildcard conf/*.conf)

#** Target (AUTO_GENERATEDS) **
AUTO_GENERATEDS = \

TO_FOLDER =

.DEFAULT_GOAL = all
.SUFFIXES: .cpp .cpp.o .c .o

.PHONY: all clean distclean install romfs
all: $(CONFIGURED) $(CLEAN_BINS) $(CLEAN_LIBS)

%.o: %.c $(HEADER_FILES)
	@echo 'Compiling file: $<'
	$(CC) $(CFLAGS) -c -o"$@" "$<"
	@echo 'Finished compiling: $<'
	@echo ' '

%.o: %.cpp $(HEADER_FILES)
	@echo 'Compiling file: $<'
	$(CXX) $(CFLAGS) -c -o"$@" "$<"
	@echo 'Finished compiling: $<'
	@echo ' '

%.cpp.o: %.cpp $(HEADER_FILES)
	@echo 'Compiling file: $<'
	$(CXX) $(CFLAGS) -c -o"$@" "$<"
	@echo 'Finished compiling: $<'
	@echo ' '

$(CLEAN_BINS): $(CLEAN_OBJS) $(CLEAN_LIBS)
	@echo 'Building target: $@'
	#[ -f $@.cpp ] && $(CC_SET) -o $@ $@.o $(LDFLAGS) $(LIBS) || echo -n ""
	#[ -f $@.c ] && $(CC) -o $@ $@.o $(LDFLAGS) $(LIBS) || echo -n ""
	$(CC_SET) -o $@ $@.o $(LDFLAGS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

clean:
	rm -f Makefile.bak $(CLEAN_BINS) $(CLEAN_BINS:=.elf) $(CLEAN_BINS:=.gdb) $(AUTO_GENERATEDS)
	rm -f Makefile.bak $(addsuffix *, $(CLEAN_LIBS)) $(CLEAN_OBJS) $(CLEAN_OBJS:%.o=%.c.bak) $(CLEAN_OBJS:%.o=%.h.bak) $(CLEAN_BINS:=.cpp.o)
	@for subbin in $(CLEAN_BINS); do \
		(rm -f $(SDK_BIN_DIR)/$$subbin;); \
	done
	@for sublib in $(CLEAN_LIBS); do \
		(rm -f $(SDK_LIB_DIR)/$$sublib*;); \
	done
	@for subheader in $(HEADER_FILES); do \
		(rm -f $(SDK_INC_DIR)/$$subheader;); \
	done
	@for subshell in $(SHELL_SBINS); do \
		(rm -f $(SDK_SBIN_DIR)/$$subshell;); \
	done

distclean: clean
	[ -L meson_public ] && (rm -rf meson_public; ) || true
	[ -d ./subprojects ] && [ -f meson.build ] && (meson subprojects purge --confirm;) || true
	rm -rf build_xxx .meson_config build.meson meson_options.txt
	rm -f $(CONFIGURED) .patched .unpack

%.a: $(LIBXXX_OBJS)
	@echo 'Building lib (static): $@'
	$(AR) $(ARFLAGS) $@ $(LIBXXX_OBJS)
	@echo 'Finished building lib (static): $@'
	@echo ' '

%.so: $(LIBXXX_OBJS)
	@echo 'Building lib (shared): $@'
	$(CC_SET) -shared $(LDFLAGS) -Wl,-soname,$@.$(VERSION_MAJOR) -o $@.$(VERSION_FULL) $(LIBXXX_OBJS)
	ln -sf $@.$(VERSION_FULL) $@.$(VERSION_MAJOR)
	ln -sf $@.$(VERSION_MAJOR) $@
	@echo 'Finished building lib (shared): $@'
	@echo ' '
