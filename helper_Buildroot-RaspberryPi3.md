# [Buildroot](https://buildroot.org) Raspberry Pi 3
[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]
[![GitHub watchers][watchers-image]][watchers-image]

[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues
[watchers-image]: https://img.shields.io/github/watchers/lankahsu520/HelperX.svg
[watchers-url]: https://github.com/lankahsu520/HelperX/watchers

# 1. Overview

> Buildroot is a simple, efficient and easy-to-use tool to generate embedded Linux systems through cross-compilation.

# 2. Environment

> Host: Ubuntu 20.04 x86_64

```bash
$ sudo apt install -y sed make binutils gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev

```

# 2. Build with Buildroot

> Host: Ubuntu 20.04 x86_64
>
> Target: Raspberry Pi3

## 2.1. To build Image

#### A. Download [buildroot-2022.02.tar.gz](https://buildroot.org/downloads/buildroot-2022.02.tar.gz)

```bash
$ wget https://buildroot.org/downloads/buildroot-2022.02.tar.gz
$ tar xvzf buildroot-2022.02.tar.gz
$ cd buildroot-2022.02
```

#### B. menuconfig

```bash
# for the original curses-based configurator
$ make menuconfig
# new curses-based configurator
$ make nconfig
# for the Qt-based configurator
$ make xconfig
# for the GTK-based configurator
$ make gconfig

$ make list-defconfigs

```
#### B.1. Select raspberrypi3_64_defconfig

> 也可以使用預設參數，本篇選擇 raspberrypi3_64_defconfig

```bash
# make <defconfig name>
# Build for raspberrypi
$ make raspberrypi_defconfig
# Build for raspberrypi3_64
$ make raspberrypi3_64_defconfig
```

```bash
# 進行微調
$ make menuconfig
```

- [x] Toolchain/C library/glibc
- [x] System Configuration/System Banner
- [x] System Configuration/Root password
- [x] Target packages/Networking applications/dropbear
- [x] Target packages/Networking applications/iftop
- [x] Target packages/System tools/htop
- [x] Target packages/Filesystem and flash utilities/e2fsprogs
- [x] Target packages/Filesystem and flash utilities/nfs-utils
- [x] Target packages/Compressors and decompressors/bzip2
- [x] Target packages/Compressors and decompressors/zip

#### C. Build

```bash
$ make all
```

## 2.2. To Generate Toolchain

```bash
$ make sdk

$ ll output/images/aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz
$ cp output/images/aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz /opt

$ cd /opt
$ tar -zxvf aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz
$ cd /opt/aarch64-buildroot-linux-gnu_sdk-buildroot
$ ./relocate-sdk.sh
```

# 3. Burn Your Image into SD CARD

```mermaid
flowchart LR
	SD[SD CARD]
	Image --> |dd|SD
	Image --> |balenaEtcher|SD
	
```

#### A. use dd

```bash
$ cd output/images

$ ls -ls sdcard.img

#unmount your sdcard first
$ sudo umount /dev/sdb1

#write img file to microsd card
$ sudo dd if=output/images/sdcard.img of=/dev/sdb bs=1M
```

#### B. use [balenaEtcher-Portable-1.5.49](https://www.balena.io/etcher/)

# 4. Raspberry PI

## 4.1. Boot from SD Card

```bash
$ uname -a
Linux luffanet-pi3 5.10.92-v8 #1 SMP PREEMPT Wed Apr 6 11:04:25 CST 2022 aarch64 GNU/Linux

$ cat /proc/version
Linux version 5.10.92-v8 (lanka@msi-vbx) (aarch64-buildroot-linux-gnu-gcc.br_real (Buildroot -svn8) 10.3.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Wed Apr 6 11:04:25 CST 2022

$ cat /etc/os-release
NAME=Buildroot
VERSION=-svn8
ID=buildroot
VERSION_ID=2022.02
PRETTY_NAME="Buildroot 2022.02"

$ cat /etc/issue
Welcome to Buildroot

$ ls -al /bin/sh
lrwxrwxrwx    1 root     root             7 Apr  6  2022 /bin/sh -> busybox

```

# 5. Build helloworld on Host

```bash
$ aarch64-buildroot-linux-gnu-gcc  -o helloworld helloworld.o  -L/work/codebase/xbox/xbox_123/install/raspi009_aarch64-buildroot-linux-gnu/lib -Wl,-rpath,/usr/lib  -ldl -pthread -lm

$ file helloworld
helloworld: ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-aarch64.so.1, for GNU/Linux 5.10.0, with debug_info, not stripped

```

# 6. Run helloworld on Pi

```bash
# Please scp helloworld from Ubuntu -> Pi 
$ helloworld
```

# Appendix

# I. Study

## I.1. [Building custom Linux for Raspberry Pi using Buildroot](https://medium.com/@hungryspider/building-custom-linux-for-raspberry-pi-using-buildroot-f81efc7aa817)

## I.2. [Building a custom Linux OS for RaspberryPi using buildroot](https://www.linkedin.com/pulse/building-custom-linux-os-raspberrypi-using-buildroot-aswin-venu)

## I.3. [Building Raspberry Pi Systems with Buildroot](https://jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Buildroot.html)

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
