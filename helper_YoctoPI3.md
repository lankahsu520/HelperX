# [Yocto](https://www.yoctoproject.org) Raspberry Pi 3

[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]


[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues

```
The Yocto Project (YP) is an open source collaboration project that helps developers create custom Linux-based systems regardless of the hardware architecture.
```

# 1. Environment

```bash
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm

```



# 2. [Yocto Cooker](https://github.com/cpb-/yocto-cooker)

> Here, we use Cooker to build.
>
> Yocto Project  isn't friendly to programmer. We have to collect Menu-files and create local.conf by myself.

```bash
$ python3 -m pip install --upgrade git+https://github.com/cpb-/yocto-cooker.git
```

## 2.1. Cooker Menu- ([pi3-sample-menu.json](https://github.com/cpb-/yocto-cooker/blob/master/sample-menus/pi3-sample-menu.json))

```bash
$ mkdir -p /work/YoctoPI3/cooker-menu
$ cd /work/YoctoPI3/cooker-menu
$ curl https://raw.githubusercontent.com/cpb-/yocto-cooker/master/sample-menus/pi3-sample-menu.json -o pi3-sample-menu.json

$ cd /work/YoctoPI3
```
## 2.2. Building

#### A. Step by Step

```bash
$ cd /work/YoctoPI3
$ cooker init ./cooker-menu/pi3-sample-menu.json
$ cat .cookerconfig

$ cooker update
$ cooker generate
$ cooker build
```
#### B. Quick Build
```bash
$ cd /work/YoctoPI3
$ cooker cook ./cooker-menu/pi3-sample-menu.json
```



# 3. Customize

```bash
$ cd /work/YoctoPI3

# provides you a new shell into the build directory with all the environment variables set.
$ cooker shell pi3
```

## 3.1. rootfs

```bash
$ ls -al ./builds/build-pi3/tmp/work/raspberrypi3-poky-linux-gnueabi/core-image-base/1.0-r0/rootfs/
```

## 3.2. Set root's password

```bash
$ vi ./cooker-menu/pi3-sample-menu.json
"IMAGE_CLASSES += 'extrausers'",
"EXTRA_USERS_PARAMS = 'usermod -P 91005476 root;'",

$ cooker generate
$ cat ./builds/build-pi3/conf/local.conf

$ cat ./poky/meta/classes/extrausers.bbclass
```

#### A. [/etc/passwd](https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/)

```bash
$ cat ./builds/build-pi3/tmp/work/raspberrypi3-poky-linux-gnueabi/core-image-base/1.0-r0/rootfs/etc/passwd
```

#### B. [/etc/shadow](https://www.cyberciti.biz/faq/understanding-etcshadow-file/)

```bash
$ cat ./builds/build-pi3/tmp/work/raspberrypi3-poky-linux-gnueabi/core-image-base/1.0-r0/rootfs/etc/shadow
```

## 3.3. ssh

```bash
$ vi ./cooker-menu/pi3-sample-menu.json
add into "local.conf"
"IMAGE_INSTALL += ' dropbear'",

$ cooker generate
$ cat ./builds/build-pi3/conf/local.conf

$ bitbake -s | grep dropbear
$ bitbake -c build dropbear

$ cat ./layers/poky/meta/recipes-core/dropbear/dropbear/init
$ vi ./layers/poky/meta/recipes-core/dropbear/dropbear/dropbear.default
# please mark
# DROPBEAR_EXTRA_ARGS="-w"
```

## 3.4. [create a layer](https://blog.csdn.net/CSDN1013/article/details/111088399)

```bash
$ cd /work/YoctoPI3/layers
$ bitbake-layers create-layer meta-lanka
NOTE: Starting bitbake server...
Add your new layer with 'bitbake-layers add-layer meta-lanka'

$ cd /work/YoctoPI3/layers
$ . ./poky/oe-init-build-env

$ yocto-check-layer meta-lanka
$ rm -rf build
```

```bash
# check example exist
$ bitbake -s | grep example

$ vi ./cooker-menu/pi3-sample-menu.json
# add "meta-lanka" into "layers"

# prepare the build-dir and configuration files (local.conf, bblayers.conf, template.conf) needed by Yocto Project.
$ cooker generate
$ vi ./builds/build-pi3/conf/bblayers.conf

# check again
$ bitbake -s | grep example
```



# 4. Raspberry PI

## 4.1. Image

```bash
$ ls -al ./builds/build-pi3/tmp/deploy/images/raspberrypi3/core-image-base-raspberrypi3.rpi-sdimg
```

#### [balenaEtcher-Portable-1.5.49](https://www.balena.io/etcher/)



# Appendix
# I. Study
# II. Debug

## II. 1. ../qemu-4.1.0/linux-user/syscall.c:7657: undefined reference to `stime'

- [QEMU 3.1.0安装手记](https://segmentfault.com/a/1190000041094251)
- [qemu: Replace stime() API with clock_settime](https://git.openembedded.org/openembedded-core/commit/?h=dunfell&id=2cca75155baec8358939e2aae822e256bed4cfe0)

```bash
$ bitbake -s | grep qemu
$ find -name qemu*.bb
./layers/poky/meta/recipes-devtools/qemu/qemu-helper-native_1.0.bb
./layers/poky/meta/recipes-devtools/qemu/qemu-native_4.1.0.bb
./layers/poky/meta/recipes-devtools/qemu/qemuwrapper-cross_1.0.bb
./layers/poky/meta/recipes-devtools/qemu/qemu_4.1.0.bb
./layers/poky/meta/recipes-devtools/qemu/qemu-system-native_4.1.0.bb

```

```
修改
./layers/poky/meta/recipes-devtools/qemu/qemu-native.inc

新增檔案
./layers/poky/meta/recipes-devtools/qemu/qemu/0012-linux-user-remove-host-stime-syscall.patch
```

## II.2. Fetcher failure for URL: 'git://github.com/RPi-Distro/firmware-nonfree'

- [linux-firmware-rpidistro: add branch in SRC_URI](https://lore.kernel.org/all/a4a248b1-4a28-4c38-981b-76bd7013ec6f@www.fastmail.com/T/)

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
