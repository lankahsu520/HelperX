# VirtualBox-x86_64-Ubuntu20.04onWin10
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

# 1. Host - Windows 10

# 2. Client - Ubuntu 20.04

```mermaid
flowchart LR
	subgraph Host[Host - Windows 10]
		subgraph Container[Client - x86_64-Ubuntu 20.04]
		
		end
	end

```
## 2.1. Download [Ubuntu 20.04.4 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/)

```bash
Ubuntu 22.04 already uses OpenSSL 3.0 and gcc is too brand new to compile.
```

## 2.2. [VirtualBox](https://www.virtualbox.org)

#### A. Download

##### A.1. [Windows hosts](https://download.virtualbox.org/virtualbox/6.1.36/VirtualBox-6.1.36-152435-Win.exe)

#### B. Install

#### C. Machine / New

![imager0001](./images/virtualbox0001.jpg)

![imager0002](./images/virtualbox0002.jpg)

#### D. Settings

##### D.1. Storage

- ubuntu-20.04.4-desktop-amd64.iso
- ubuntu.vdi
- work_curr.vdi - please create by yourself ! about 500GB.
- opt_curr.vdi - please create by yourself ! about 128GB.

![virtualbox0003](./images/virtualbox0003.jpg)

##### D.2. Netowrk - use Bridged Adapter

![virtualbox0004](./images/virtualbox0004.jpg)

#### E. Start

- please install Ubuntu step by step !!!

# 3. Ubuntu

## 3.1. Disks

- work_curr.vdi - Mounted at /work.
- opt_curr.vdi - Mounted at /opt.

![ubuntu0001](./images/ubuntu0001.jpg)

## 3.2. System Configuration

#### /etc/hostname

```bash
sudo vi /etc/hostname
sudo hostname -F /etc/hostname
```

#### /etc/hosts

```bash
sudo vi /etc/hosts
```

## 3.3 apt-get

```bash
sudo apt-get --yes update
sudo apt-get --yes upgrade

cd /bin && sudo rm sh; sudo ln -s bash sh

sudo chmod 777 /work
sudo chmod 777 /opt

```

## 3.4. Service

#### A. ssh

```bash
sudo apt-get --yes install openssh-server

```

#### B. samba

```bash
sudo apt-get --yes install samba
sudo apt-get --yes install cifs-utils

sudo usermod -a -G sambashare `whoami`
sudo pdbedit -a -u `whoami` # 設定密碼

sudo mkdir -p /etc/samba
sudo nano /etc/samba/smb.conf

sudo service smbd restart
```
- /etc/samba/smb.conf
```conf
[work]
  path = /work

  vfs object = recycle
  recycle: keeptree = yes
  recycle: versions = yes
  recycle: repository = ../work/recycle/%u

  write list = @sambashare
  browseable = yes
  writeable = yes
  read only = no

[recycle]
  path=/work/recycle/%u
  comment = Recycle Bin
  browseable = no
  writable = yes
```

> 如果 symbolic links outside of the shared path

```conf
[global]
allow insecure wide links = yes
unix extensions = no

follow symlinks = yes
wide links = yes
unix extensions = no

[work]
path = /work

```

#### C. nfs

```bash
sudo apt-get --yes install nfs-common
sudo apt-get --yes install nfs-kernel-server
sudo nano /etc/exports

sudo /etc/init.d/nfs-kernel-server restart
```
- /etc/exports
```conf
/work  *(rw,sync,no_root_squash,no_subtree_check)

```

#### D. tftp

```bash
mkdir -p /work/tftpboot
sudo apt-get --yes install xinetd
sudo apt-get --yes install tftpd-hpa
sudo nano /etc/default/tftpd-hpa

```

- /etc/default/tftpd-hpa
```conf
# /etc/default/tftpd-hpa

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/work/tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure"

```

#### E. rsyslog

```bash
sudo nano /etc/rsyslog.conf

sudo systemctl restart rsyslog
```

- /etc/rsyslog.conf

```bash
# add the below lines
$EscapeControlCharactersOnReceive off
```

#### F. dbus - [dbusX.conf](./DBus/dbusX.conf)

```bash
# to register com.github.lankahsu520, com.github
sudo cp dbusX.conf /etc/dbus-1/system.d

sudo reboot
```

# 4. VBoxManage

## 4.1. Commands

#### A. modifyhd

##### A.1. Client (Ubuntu 20.04)

```bash
#!/bin/sh

telinit 1

MOUNT_DISK="work"
PURGE_DISK=`mount | grep $MOUNT_DISK | cut -d" " -f1`
mount -o remount,ro $PURGE_DISK
zerofree -v $PURGE_DISK

```

##### A.2. Host (Windows 10)

```bash
$ "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyhd work_curr.vdi --compact

```

#### B. list

##### B.1. Host (Windows 10)

```bash
$ "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list hdds

UUID:           8f57809e-9a5e-4160-9b08-7c42e80ec070
Parent UUID:    base
State:          locked write
Type:           normal (base)
Location:       D:\work\VirtualBox\opt_curr.vdi
Storage format: VDI
Capacity:       131072 MBytes
Encryption:     disabled

UUID:           35af928b-87c3-43a7-ab61-4f5f76e57c7e
Parent UUID:    base
State:          locked write
Type:           normal (base)
Location:       D:\work\VirtualBox\work_curr.vdi
Storage format: VDI
Capacity:       524288 MBytes
Encryption:     disabled

UUID:           9edd1810-e0a9-497c-a400-75fa2b706bdf
Parent UUID:    base
State:          locked write
Type:           normal (base)
Location:       D:\work\VirtualBox\Ubuntu2004_buildX_curr.vdi
Storage format: VDI
Capacity:       131072 MBytes
Encryption:     disabled

```

## 4.2. Virtual Media Manager

#### A. Add Disk Image

> 載入現有的 Disk Image。

#### B. Create Disk Image

> 建立新的 Disk Image。

#### C. Copy Disk Image

> 複製選定的  Disk Image。如果你是用 win10 的檔案總管複製，會同時複製內部的 uuid。但是使用此工具會建立新的uuid。

# 5. Images
#### A. [OSBoxes - Virtual Machines for VirtualBox & VMware](http://www.osboxes.org/#)

#### B. [Android-x86](https://www.android-x86.org)

# Appendix

# I. Study

## I.1. [Ubuntu kernel lifecycle and enablement stack](https://ubuntu.com/kernel/lifecycle)

# II. Debug

## II.1. Your Hardware Enablement Stack (HWE) is supported until April 2025.

>Your Hardware Enablement Stack (HWE) is supported until April 2025.
>*** System restart required ***

```bash
$ hwe-support-status
Your Hardware Enablement Stack (HWE) is supported until 四月 2025.

$ ubuntu-drivers list-oem
$ ubuntu-drivers list
virtualbox-guest-dkms, (kernel modules provided by virtualbox-guest-dkms)
virtualbox-guest-dkms-hwe, (kernel modules provided by virtualbox-guest-dkms-hwe)
open-vm-tools-desktop

```

# III. Glossary

# IV. Tool Usage


# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

