# Linux
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

# 1. File Handler

#### cd  - change the working directory

```bash
cd -
cd
cd /work

```

#### ls - list directory contents


```bash
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# display file type
alias ls-type="ls  | xargs -n 1 file"

```

#### mkdir - make directories

```bash
mkdir -p /work/codebase

```

#### mv - move (rename) files

```bash
mv /work/README.md /work/README_bak.md

```

#### pwd - print name of current/working directory

```bash
pwd

```

#### tree - list contents of directories in a tree-like format.

```bash
function usb-tree()
{
	tree /dev/bus/usb
}

```

## 1.1 Copy

#### cp - copy files and directories

```bash
cp -avr * /work
cp -vrf --no-dereference --preserve=mode,links * /work

```

#### dd - convert and copy a file

```bash
dd if=uboot.bin of=/dev/mtdblock0
dd if=uImage.bin of=/dev/mtdblock7
dd if=/dev/mtdblock0 of=./uboot.bin

dd if=/dev/zero of=/dev/mtdblock9 bs=1M count=1
dd if=/dev/zero of=/dev/mtdblock10 bs=4M count=1

```

#### rsync - a fast, versatile, remote (and local) file-copying tool

```bash
rsync -av --progress /work/* /work_bak

rsync -av --progress --delete /work/* /work_bak

```

#### scp - OpenSSH secure file copy

```bash
scp -vr /work/* lanka@192.168.0.99:/work

```

## 1.2. Remove

#### rm - remove files or directories

```bash
rm -f README.md
rm -vrf /work/codebase/xbox

```

#### rmdir - remove empty directories

```bash
rmdir -v /work/codebase/xbox
```



## 1.3. [Linux chmod??????](https://www.runoob.com/linux/linux-comm-chmod.html)  and [Linux chown ??????](https://www.runoob.com/linux/linux-comm-chown.html)

#### chmod - change file mode bits

>![file-permissions-rwx](./images/file-permissions-rwx.jpg)

>![rwx-standard-unix-permission-bits](./images/rwx-standard-unix-permission-bits.png)

```bash
chmod -R ug+rw *
chmod -R o-rwx *
```

#### chown - change file owner and group

```bash
chown -R root.root *

```

## 1.4. Reader

#### cat - concatenate files and print on the standard output

```bash
cat README.md

```

#### hexdump, hd ??? ASCII, decimal, hexadecimal, octal dump

```bash
hexdump -C helloworld.tar.gz.enc | less
```

#### less - opposite of more

```bash
less /var/log/syslog

```

#### more - file perusal filter for crt viewing

```bash
more /var/log/syslog

```

#### tail - output the last part of files

```bash
tail -f /var/log/syslog

```

## 1.5. Compare

#### diff - compare files line by line

```bash
function diffx()
{
	HINT="Usage: ${FUNCNAME[0]} <files1> <file2>"
	FILE1=$1
	FILE2=$2

	if [ ! -z "$FILE1" ] && [ ! -z "$FILE2" ]; then
		diff -Naur $FILE1 $FILE2 
	else
		echo $HINT
	fi
}

```

#### patch - apply a diff file to an original

```
patch -p1 < configure_fixes.patch

```

## 1.6. Finder

#### find - search for files in a directory hierarchy

```bash
function find-min()
{
	find . -mmin -$1
}
function find-time()
{
	find . -mtime -$1
}
function find-size()
{
	find . -type f -size $1
}

alias find-bak="find * -name *.bak"

alias find-name="find * -name"

# display file type
alias find-type="find * -type f | xargs -n 1 file"

function find-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <path> <file>"
	PATH1=$1
	FILE1=$2

	echo "[$1][$2]"
	if [ ! -z "$PATH1" ] && [ ! -z "$FILE1" ]; then
		(cd $PATH1; find * -name $FILE1; cd - >/dev/null )
	else
		echo $HINT
	fi
}

# ???????????????????????????
function find-dup()
{
	find . -type f -printf '%p -> %f\n' | sort -k2 | uniq -f1 --all-repeated=separate
}

```

#### fdupes - finds duplicate files in a given set of directories

```bash
sudo apt install fdupes

# ???????????????????????????
fdupes -r ./

```

#### locate - find files by name

```bash
sudo apt install mlocate

locate -r .bash_aliases
locate -r libmpc.so

```

#### which - locate a command

```bash
which find

```

# 2. Task Handler

#### history - GNU History Library

```bash
history
history 10

echo $HISTFILE

```

#### lsof - list open files

```bash
# ????????????????????????????????????
sudo lsof -c sftp-server

```

#### pidof -- find the process ID of a running program.

```bash
pidof helloworld

```

#### ps - report a snapshot of the current processes.

```bash
ps -aux
ps -aux | grep helloworld | grep -v grep

```

#### kill - send a signal to a process

```bash
kill `pidof helloworld`

kill 123
kill -SIGTERM 123

kill -9 123
kill -SIGKILL 123

kill -USR1 123
kill -USR2 123
```

#### killall - kill processes by name

```bash
killall helloworld
kill -SIGTERM helloworld

```

#### shutdown - Halt, power-off or reboot the machine

```bash
# Power-off the machine (the default).
sudo shutdown -P 20:00

# Cancel a pending shutdown.
sudo shutdown -c

```

## 2.1. [Linux crontab ??????](https://www.runoob.com/linux/linux-comm-crontab.html)

```bash
crontab -e

crontab -l

# ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????
crontab -r

crontab -e -u lanka

```

# 3. Disk Handler

#### du - estimate file space usage
```bash
function free-folder()
{
	du -h --max-depth=$1 $2
}

function free-disk()
{
	df -h
}

```

#### mke2fs - create an ext2/ext3/ext4 filesystem

```bash
sudo mke2fs /dev/sdb1

```

# 4. String Handler

#### cut - remove sections from each line of files

```bash
ifconfig enp0s3 | grep "ether" | cut -d" " -f 10-11

```

#### echo - display a line of text

```bash
echo "Hello World !!!"

```

#### export ??? set the export attribute for variables

```bash
export SVN_EDITOR=vim

export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH

export PATH=/opt:$PATH
export PATH=`pwd`:$PATH

PS1='[\u@\h\W]\$'
```

#### gawk - pattern scanning and processing language

```bash
ifconfig enp0s3 | grep 'ether' | awk -F ' ' '{print $2}'

ip -o -4 addr list enp0s3 | awk '{print $4}' | cut -d/ -f1

```

#### grep, egrep, fgrep, rgrep - print lines that match patterns

```bash
alias gr="grep --exclude-dir='.svn' --exclude-dir='.git' -nrs"
function gr-include()
{
	echo "[$1][$2]"
	grep --exclude-dir='.svn' --exclude-dir='.git' -nrs --include=$1 $2
}

ps -aux | grep helloworld | grep -v grep

```

#### integer checker

```bash
[[ $ABC == ?(-)+([0-9]) ]] && echo "$ABC is an integer"
[[ $ABC == ?(-)+([:digit:]) ]] && echo "$ABC is an integer"

```

#### number checker

```bash
[ ! -z "${ABC##*[!0-9]*}" ] && echo "is a number" || echo "is not a number";

```

#### sed - stream editor for filtering and transforming text

```bash
sed -i "s|<user>.*|<user>$WHO</user>|g" $CFG_FILE

```

# 5. User Handler

#### ac -  print statistics about users' connect time

```bash
# ????????????????????????????????????
ac -p

# ???????????????????????????
ac -d

```

#### last, lastb - show a listing of last logged in users

```bash
last -aiF -30

```

#### lastcomm -  print out information about previously executed commands

```bash
# ??????????????????
lastcomm --forwards

```

#### lastlog - reports the most recent login of all users or of a given user

```bash
lastlog

```

#### sudo, sudoedit ??? execute a command as another user

```bash
sudo 
# environment and background
sudo -E -b
# environment
sudo -E

```

#### w - Show who is logged on and what they are doing

```bash
w -i

```

#### who - show who is logged on

```bash
who

```

#### whoami - print effective userid

```bash
whoami

```

#### /etc/group

```bash
cat /etc/group

```

# 6. Log Handler

#### logger - enter messages into the system log

```bash
./helloworld | logger -t helloworld

```

#### logread

```bash
function logman-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <tag>"
	LOGGER_TAG=$1

	if [ ! -z "$LOGGER_TAG" ]; then
		LOGGER_COLOR="| awk '{gsub(/\^\[/,\"\x1b\"); print}'"
		LOGREAD=`which logread`
		LOGREAD_ARG=" [ ! -z '$LOGREAD' ] "
		[ -z "$LOGREAD" ] || LOGREAD_ARG="(logread -f -e $LOGGER_TAG 2>/dev/null;) || (logread -f $LOGGER_COLOR | grep $LOGGER_TAG 2>/dev/null; )"
		DO_COMMAND="$LOGREAD_ARG || (tail -f /var/log/syslog $LOGGER_COLOR | grep $LOGGER_TAG;)"
		echo "[$DO_COMMAND]"
		sh -c "$DO_COMMAND"
	else
		echo $HINT
	fi
}

logman-ex helloworld

```

#### /var/log/syslog

```bash
alias logman-syslog="tail -f /var/log/syslog"

```

#### /var/log/auth.log

```bash
alias logman-auth="tail -f -n 60 /var/log/auth.log"

```

#### /etc/rsyslog.conf

```bash
sudo vi /etc/rsyslog.conf

$EscapeControlCharactersOnReceive off

Then restart rsyslog and your service.

$ systemctl restart rsyslog
```

# 7. Mount Handler

#### mount - mount a filesystem

```bash
mkdir -p /tmp/sdk;
mount -t nfs -o tcp,nolock,nosuid,rsize=1024,wsize=1024 192.168.0.92:/work/codebase /tmp/sdk

mkdir -p /tmp/sdk;mount.nfs4 192.168.0.92:/work/codebase /tmp/sdk

mount -t cifs -o username=lanka,password=lanka520 //192.168.0.92/work /mnt/smb

mount -t jffs2 /dev/mtdblock2 /mnt/mtd

mount -t smbfs -o username=lanka,password=lanka520 //192.168.10.5/work /mnt/smb

mount -t vfat -o codepage=950 iocharset=utf8 /dev/ide/host0/bus0/target1/disc /mnt/CF
mount -t vfat -o iocharset=big5 -o codepage=950  /dev/ide/host0/bus0/target1/lun0/part1 /mnt/CF
mount -t vfat -o iocharset=big5 -o codepage=unicode  /dev/ide/host0/bus0/target1/lun0/part1 /mnt/CF
mount -t vfat /dev/ide/host0/bus0/target1/lun0/part1 /mnt/CF
mount -t vfat /dev/mmcblk0p1 /mnt/CF
```

```bash
dd if=/dev/zero of=test8mb.img bs=4k count=2048
mkfs.ext4 test8mb.img
sudo mount -o loop -w test8mb.img
sudo mount test8mb.img ./ext4

```

# 8. Network Handler

#### avahi-browse - Browse for mDNS/DNS-SD services using the Avahi daemon

```bash
alias avahi-http="avahi-browse -r -t _http._tcp"
alias avahi-ssh="avahi-browse -r -t _ssh._tcp"
alias avahi-print="avahi-browse -r -t _printer._tcp"

```

#### ifconfig - configure a network interface

```bash
ifconfig -a

ifconfig eth0

# mtu
sudo ifconfig enp0s3 mtu 9000

IFACE=ra0
MYMASK=`ifconfig $IFACE | awk '/netmask/{ print $4;}'`

MAC_ADDR=$(ifconfig $IFACE | grep 'HWaddr' | awk -F ' ' '{print $NF}')
MAC_ADDR=$(ifconfig $IFACE | grep 'ether' | awk -F ' ' '{print $2}')

MYBR="br9"
MYIP=192.168.0.99

sudo ifconfig $MYBR hw ether $MAC_ADDR
sudo ifconfig $IFACE down
sudo ifconfig $IFACE 0.0.0.0 up
sudo ifconfig $MYBR $MYIP netmask $MYMASK
sudo ifconfig $IFACE 0.0.0.0

```

#### ifdata - get network interface info without parsing ifconfig output

```bash
sudo apt install moreutils

MYIP=`ifdata -pa $IFACE`
MYMASK=`ifdata -pn $IFACE`

```

#### ip - show / manipulate routing, network devices, interfaces and tunnels

```bash
# ?????? IP ??????
ip address

MYIP=`ip -o -4 addr list $IFACE | awk '{print $4}' | cut -d/ -f1`
MYGW=`ip route show 0.0.0.0/0 dev $IFACE | cut -d\  -f3`
ip -6 route

ZIPSRV_PREFIX="fd00:bbcc"
ZIPSRV=${ZIPSRV_PREFIX}::${MAC_SUFFIX}
sudo ip -6 route add ${ZIPSRV_PREFIX}::/64 dev $MYTAP
sudo ip -6 route add ${ZIPPAN_PREFIX}::/64 via ${ZIPSRV} dev $MYTAP

sudo ip -6 route del ${ZIPSRV_PREFIX}::/64 dev $MYTAP
sudo ip -6 route del ${ZIPPAN_PREFIX}::/64 via ${ZIPSRV} dev $MYTAP

```

#### nslookup - query Internet name servers interactively

```bash
nslookup www.google.com

```

#### ping - send ICMP ECHO_REQUEST to network hosts

```bash
ping -c 4 8.8.8.8

```

#### route - show / manipulate the IP routing table

```bash
MCTT_IP="229.255.255.250"
route -n | grep $MCTT_IP ) || ( $SUDO route del $MCTT_IP dev lo

route add default gw 192.168.0.1 dev ra0
route del default gw 192.168.0.1 dev ra0

route add -net 192.168.0.0 netmask 255.255.255.0 ra0
route del -net 192.168.0.0 netmask 255.255.255.0 ra0

```

#### umount - unmount file systems

```bash
umount /mnt/CF

```

## 8.1. ARP

#### arping - sends arp and/or ip pings to a given host

```bash
sudo arping -i enp0s3 192.168.0.1 -c 1

for ip in 192.168.0.{1..100}; do \
	echo $ip; sudo arping -i enp0s3 -w 1 -c 1 $ip | grep from; \
done

```

#### arp - manipulate the system ARP cache

```bash
arp -n

```

## 8.2. iftop - display bandwidth usage on an interface by host

```bash
sudo apt-get install iftop
sudo iftop

```

## 8.3. Network State

#### ss - another utility to investigate sockets

```bash
function port-listen()
{
	HINT="Usage: ${FUNCNAME[0]} <port>"
	WATCH_PORT="$1"

	#echo "WATCH_PORT=$WATCH_PORT"
	if [ ! -z "$WATCH_PORT" ]; then
		ss -tnl | grep LISTEN | grep $WATCH_PORT
	else
		echo $HINT
	fi
}
```

#### netstat - Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships

```bash
sudo netstat -ntlp | grep LISTEN
sudo netstat -tulpn | grep ftp
sudo netstat -tulpn    
sudo netstat -ntlp | grep :80

```

#### nmap - Network exploration tool and security / port scanner

```bash
alias port-nmap="nmap 127.0.0.1"
nmap localhost

# ??????????????????
nmap 192.168.0.100-200 -p80

# ????????????IP
sudo nmap -P0 -O 192.168.0.92
```

#### swconfig - openwrt

```bash
swconfig dev switch0 show | grep port
swconfig dev switch0 port 0 show
swconfig dev switch0 port 0 get link

```

#### /sys/class/net

```bash
for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/carrier; done
for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/carrier_changes; done
for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/operstate; done
for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/iflink; done
for i in $( ls /sys/class/net ); do echo -n $i: ; cat /sys/class/net/$i/link_mode; done

```

## 8.4. Wifi

#### iwpriv - configure optionals (private) parameters of a wireless network interface

```bash
ifconfig apcli0 up

iwpriv apcli0 set ApCliEnable=0
iwpriv apcli0 set ApCliAuthMode=WPA2PSK
iwpriv apcli0 set ApCliEncrypType=AES
iwpriv apcli0 set ApCliSsid=lanka
iwpriv apcli0 set ApCliWPAPSK=lanka520
iwpriv apcli0 set Channel=6
iwpriv apcli0 set ApCliEnable=1

ifconfig apcli0 up

iwpriv apcli0 set SiteSurvey=1
iwpriv apcli0 get_site_survey

iwpriv ra0 set ApCliEnable=0
iwpriv ra0 set ApCliAuthMode=WPA2PSK
iwpriv ra0 set ApCliEncrypType=AES
iwpriv ra0 set ApCliSsid=lanka
iwpriv ra0 set ApCliWPAPSK=lanka520
iwpriv ra0 set Channel=6
iwpriv ra0 set ApCliEnable=1

ifconfig apcli0 up

iwpriv ra0 set SiteSurvey=1
iwpriv ra0 get_site_survey

// STA
iwpriv ra0 set NetworkType=Infra
iwpriv ra0 set AuthMode=WPA2PSK
iwpriv ra0 set EncrypType=AES
iwpriv ra0 set SSID="lanka-FF:FF"
iwpriv ra0 set WPAPSK="lanka520"
iwpriv ra0 set SSID="lanka-FF:FF"

```

## 8.5. Bridge

#### brctl - ethernet bridge administration

```bash
ifconfig eth2.2 down
brctl addbr br1
ifconfig br1 up
brctl addif br1 eth2.1
ifconfig eth2.2 0.0.0.0
ifconfig br1 up

```

#### vconfig - VLAN (802.1q) configuration program

```bash
vconfig add eth2 3
ifconfig eth2.3 up

```

## 8.6. udhcpc

```bash
udhcpc -i br1 -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid

udhcpc -i ra0 -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid

```

## 8.7. [iperf](https://iperf.fr) - perform network throughput tests

```bash
# run in server mode
iperf -s

# run in client mode, connecting to host
iperf -c 192.168.0.92
```



# 9. Datetime Handler

#### date - print or set the system date and time

```bash
date

date +"%Y%m%d %T"
date +"%Y%m%d %H%M%S"

date +%s

```

#### ntpdate - set the date and time via NTP

```bash
sudo apt install ntpdate
ntpdate time.stdtime.gov.tw

TZ="GMT-08:00"
export TZ="GMT-08:00"
echo "GMT-08:00" > /etc/TZ

```

## 9.1. Timezone

```bash
cat /etc/timezone

date +%Z

date +"%Z %z"

```

#### timedatectl - Control the system time and date

```bash
timedatectl

timedatectl list-timezones

sudo timedatectl set-timezone Asia/Taipei

```

# 10. Service Handler

#### service - run a System V init script

```bash
service --status-all
service apache2 status
service apache2 restart

```

#### systemctl - Control the systemd system and service manager

```bash
systemctl list-units
systemctl is-enabled apache2.service
systemctl is-active apache2.service
systemctl restart apache2.service

sudo systemctl status sshd
sudo systemctl start sshd
sudo systemctl enable sshd
sudo systemctl disable sshd
sudo systemctl stop sshd
sudo systemctl kill sshd
sudo systemctl restart sshd

systemctl cat sshd

sudo systemctl status dbus.service
```

```bash
????????????????????????
ls -al /lib/systemd/system/
ls -al /usr/lib/systemd/system
ls -al /usr/lib/systemd/user

ls -al /etc/systemd/system

```

# 11. Debug Handler

#### valgrind - a suite of tools for debugging and profiling programs

```bash
sudo -E valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./ir_daemon -d 2 -s /mnt -i eth0


function valgrind-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <prog-and-args>..."
	PROG_AND_ARGS="$*"

	#echo "PROG_AND_ARGS=$PROG_AND_ARGS"
	if [ ! -z "$PROG_AND_ARGS" ]; then
		valgrind --tool=memcheck --leak-check=full --show-reachable=yes $PROG_AND_ARGS
	else
		echo $HINT
	fi
}

valgrind-ex helloworld

```

# 12. Package Handler

#### apt-get - APT package handling utility -- command-line interface

```bash
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install subversion-tools

apt-cache search package ?????????

apt-cache show package ?????????????????????????????????????????????????????????

sudo apt-get install package ?????????

sudo apt-get install package - - reinstall ???????????????

sudo apt-get -f install ????????????"-f = ??????fix-missing"

sudo apt-get remove package ?????????

sudo apt-get remove package - - purge ???????????????????????????????????????

sudo apt-get dist-upgrade ????????????

sudo apt-get dselect-upgrade ?????? dselect ??????

apt-cache depends package ??????????????????

apt-cache rdepends package ?????????????????????????????????

sudo apt-get build-dep package ???????????????????????????

apt-get source package ????????????????????????

sudo apt-get clean && sudo apt-get autoclean ??????????????????

sudo apt-get check ??????????????????????????????
```

#### dpkg - package manager for Debian

```bash
dpkg -L libssl1.1
dpkg -L libcurl4

```

#### ldconfig - configure dynamic linker run-time bindings

```bash
ldconfig -p|grep libmpc

```

# 13. System Handler

#### sysctl - configure kernel parameters at runtime

```bash
# ?????? IPv6 ???????????? - https://officeguide.cc/ubuntu-linux-disable-ipv6-address-tutorial/
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
# ?????? IPv6 ????????????
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=0

```

#### /proc/meminfo

```bash
cat /proc/meminfo

```

#### /proc/sys/vm

```bash
cat /proc/sys/vm/swappiness

cat /proc/sys/vm/dirty_background_ratio

cat /proc/sys/vm/dirty_ratio

cat /proc/sys/vm/dirty_expire_centisecs

# ???????????? dentry???inode?????????
cat /proc/sys/vm/vfs_cache_pressure

```

#### /proc/sys/vm/drop_caches

```bash
# ????????????
sync; echo 1 > /proc/sys/vm/drop_caches

# ???????????????inodes
sync; echo 2 > /proc/sys/vm/drop_caches

# ??????????????????????????????inodes
sync; echo 3 > /proc/sys/vm/drop_caches

```

#### /proc/sys/vm/overcommit_memory

```bash
# https://access.redhat.com/documentation/zh-tw/red_hat_enterprise_linux/6/html/performance_tuning_guide/s-memory-captun

# kernel ????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
echo 1 > /proc/sys/vm/overcommit_memory

# kernel ???????????????????????????????????????????????????????????????????????? overcommit_ratio ?????????????????????????????????????????????????????????????????????????????????????????????????????????
echo 2 > /proc/sys/vm/overcommit_memory

```

# 14. SSL Handler

```bash
openssl ciphers -v | awk '{print $2}' | sort | uniq
openssl s_client -help 2>&1  > /dev/null | egrep "\-(ssl|tls)[^a-z]"
openssl s_client -help 2>&1 | awk '/-ssl[0-9]|-tls[0-9]/{print $1}' 
openssl ciphers

```

# 15. MTD Handler

```bash
sudo apt install mtd-utils

cat /proc/mtd

mkdir jffs2
mkfs.jffs2 -d jffs2 -o jffs2.img
flash_erase /dev/mtd/2
cp ./jffs2.img /dev/mtd/2

sudo mount -t jffs2 /dev/mtdblock/2 ./jffs2

```

# 16. Virus Handler

## 16.1. RootKit

#### chkrootkit - Determine whether the system is infected with a rootkit

```bash
sudo apt-get install chkrootkit
sudo chkrootkit | grep INFECTED

```

#### rkhunter - RootKit Hunter

```bash
sudo apt-get install rkhunter
sudo rkhunter -c

```

# 17. Archive Handler

#### tar - an archiving utility

```bash
tar -zcvf helloworld.tar.gz helloworld
tar -zxvf helloworld.tar.gz

cat helloworld.tar.gz | openssl enc -aes-256-cbc -e > helloworld.tar.gz.enc
cat helloworld.tar.gz.enc | openssl enc -aes-256-cbc -d > helloworld.tar.gz

```

#### zip - package and compress (archive) files

```bash
zip -r helloworld.zip helloworld

```

#### unzip - list, test and extract compressed files in a ZIP archive

```bash
unzip helloworld.zip

```

# 18. Others Handler

#### alias ??? define or display aliases

```bash
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

unalias la

```

#### man - an interface to the system reference manuals

```bash
man ls

```

#### xargs - build and execute command lines from standard input

```bash
ls | xargs cat

```

# Appendix

# I. Study

#### A. [Linux ??????](https://www.runoob.com/linux/linux-tutorial.html)

# II. Debug

# III. Tool Usage

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

