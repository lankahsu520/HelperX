SUMMARY = "bitbake-layers recipe"
DESCRIPTION = "Recipe created by bitbake-layers"
LICENSE = "MIT"

python do_display_banner() {
    bb.plain("***********************************************");
    bb.plain("*                                             *");
    bb.plain("*  Example recipe created by bitbake-layers   *");
    bb.plain("*                                             *");
    bb.plain("***********************************************");
}

addtask display_banner before do_build

# copy from /poky/meta-skeleton/recipes-skeleton/hello-single
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://helloworld-123.c \
           file://Makefile"

S = "${WORKDIR}"

do_compile() {
	#${CC} ${LDFLAGS} helloworld-123.c -o helloworld-123
	oe_runmake -f Makefile
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 helloworld-123 ${D}${bindir}
}
