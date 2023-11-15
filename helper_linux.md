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

```bash
# to keep password into SCP_PASS_AUTO
# ssh-pass123 lankahsu520
# sshpp scp -vr /work/* lanka@192.168.0.99:/work
function sshpp()
{
	FILES="$*"

	if [ ! -z "$SCP_PASS_AUTO" ]; then
		sshpass -p "$SCP_PASS_AUTO" $FILES
	else 
		$FILES
	fi
}

function ssh-pass123()
{
	SCP_PASS="$1"

	if [ ! -z "$SCP_PASS" ]; then
		export SCP_PASS_AUTO=$SCP_PASS
	else
		echo "Please set [SCP_PASS_AUTO]"
		echo "SCP_PASS_AUTO=$SCP_PASS_AUTO"
	fi
}
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



## 1.3. [Linux chmod命令](https://www.runoob.com/linux/linux-comm-chmod.html)  and [Linux chown 命令](https://www.runoob.com/linux/linux-comm-chown.html)

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

#### hexdump, hd — ASCII, decimal, hexadecimal, octal dump

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

#### read - read a line from standard input

```bash
read_file_cvs_fn()
{
	FILE_NAME=$1
	echo "$RUN_SH ($PID) ${FUNCNAME[0]} - (FILE_NAME: $FILE_NAME) ... "

	LINE_NO=1
	while IFS="," read -r ARG1 ARG2 || [ -n "$ARG1" ]
	do
		echo "(LINE_NO: $LINE_NO, ARG1: $ARG1, ARG2: $ARG2)"
		(( LINE_NO++ ))
	done < $FILE_NAME

	echo "$RUN_SH ($PID) ${FUNCNAME[0]} - (FILE_NAME: $FILE_NAME) ok "
}
```

```bash
input_filename_fn()
{
	FILE_NAME=$1

	echo 
	echo "$RUN_SH ($PID) ${FUNCNAME[0]} ... "
	[ -z "$FILE_NAME" ] && read -p "Please input file name or (q)uit：" FILE_NAME
	case $FILE_NAME in
		q|Q)
			IS_QUIT=1
		;;
		*)
			if [ ! -z "$FILE_NAME" ]; then
				echo "(FILE_NAME: $FILE_NAME)"
				read_file_cvs_fn "$FILE_NAME
			else
				IS_QUIT=1
			fi
		;;
	esac
}
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

# 尋找重複的檔案名稱
function find-dup()
{
	find . -type f -printf '%p -> %f\n' | sort -k2 | uniq -f1 --all-repeated=separate
}

```

#### fdupes - finds duplicate files in a given set of directories

```bash
sudo apt install fdupes

# 尋找重複的檔案名稱
fdupes -r ./

```

#### locate - find files by name

```bash
sudo apt install mlocate

locate -r .bash_aliases
locate -r libmpc.so

# to find the special filename under this folder
sudo apt install mlocate

locate libmpc.so | grep `pwd`
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
# 列出所有行程所開啟的檔案
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



## 2.1. [Linux crontab 命令](https://www.runoob.com/linux/linux-comm-crontab.html)

```bash
crontab -e

crontab -l

# 刪除自已所有的排程工作，在使用前一定要特別的注意哦…因為一不小心就全刪除了。
crontab -r

crontab -e -u lanka

sudo systemctl status cron.service
sudo systemctl enable cron.service
```

```bash
# at bootup
@reboot sleep 20 && helloworld

# every hour
0 * * * * /bin/util_123
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

#### eval - construct command by concatenating arguments

```bash
DO_COMMAND="ls -al"
eval "${DO_COMMAND}"
```

```bash
function eval-it()
{
	DO_COMMAND="$*"
	echo "[${DO_COMMAND}]"
	eval ${DO_COMMAND}
}
```

#### export - set the export attribute for variables

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

#### tr - translate or delete characters

```bash
INPUT_ARY=($(echo "$INPUT_TXT" | tr "," "\n"))
```

# 5. User Handler

#### ac -  print statistics about users' connect time

```bash
# 檢視每位使用者的連線時間
ac -p

# 檢視每天的連線時間
ac -d

```

#### last, lastb - show a listing of last logged in users

```bash
last -aiF -30

```

#### lastcomm -  print out information about previously executed commands

```bash
# 程序歷史清單
lastcomm --forwards

```

#### lastlog - reports the most recent login of all users or of a given user

```bash
lastlog

```

#### sudo, sudoedit — execute a command as another user

```bash
sudo 
# environment and background
sudo -E -b
# environment
sudo -E

```

```bash
# to keep passwoard in $SUDO_PASS_AUTO
# sudo-pass123 lankahsu520
# sudoo ls -al
function sudoo()
{
	FILES="$*"

	if [ ! -z "$SUDO_PASS_AUTO" ]; then
		echo -e "$SUDO_PASS_AUTO" | sudo -S -$FILES
	else
		echo "Please set SUDO_PASS_AUTO"
		sudo $FILES
	fi
}

function sudo-pass123()
{
	SUDO_PASS="$1"

	if [ ! -z "$SUDO_PASS" ]; then
		export SUDO_PASS_AUTO=$SUDO_PASS
	else 
		echo "SUDO_PASS_AUTO=$SUDO_PASS_AUTO"
	fi
}
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
# 查詢 IP 位址
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
( route -n | grep $MCTT_IP ) || ( $SUDO route add $MCTT_IP dev lo )

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
		ss -tnul | grep -E 'LISTEN|UNCONN' | grep $WATCH_PORT
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
alias port-nmap="sudo nmap -sNU localhost"
nmap localhost

sudo nmap -sNU localhost

# 查尋網路芳鄰
nmap 192.168.0.100-200 -p80

# 查尋特定IP
sudo nmap -P0 -O 192.168.0.92

# UDP狀況
sudo nmap -sU localhost

# 查看SIP
nmap -v -sV localhost -p 5060
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
查看現有的設定檔
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

apt-cache search package 搜索包

apt-cache show package 獲取包的相關信息，如說明、大小、版本等

sudo apt-get install package 安裝包

sudo apt-get install package - - reinstall 重新安裝包

sudo apt-get -f install 修覆安裝"-f = ——fix-missing"

sudo apt-get remove package 刪除包

sudo apt-get remove package - - purge 刪除包，包括刪除配置文件等

sudo apt-get dist-upgrade 升級系統

sudo apt-get dselect-upgrade 使用 dselect 升級

apt-cache depends package 了解使用依賴

apt-cache rdepends package 是查看該包被哪些包依賴

sudo apt-get build-dep package 安裝相關的編譯環境

apt-get source package 下載該包的源代碼

sudo apt-get clean && sudo apt-get autoclean 清理無用的包

sudo apt-get check 檢查是否有損壞的依賴
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

#### lshw - list hardware

```bash
$ sudo lshw -c cpu
  *-cpu
       product: Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
       vendor: Intel Corp.
       physical id: 2
       bus info: cpu@0
       width: 64 bits
       capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp x86-64 constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d

$ sudo lshw

```

#### lscpu - display information about the CPU architecture

```bash
$ lscpu
Architecture:                       x86_64
CPU op-mode(s):                     32-bit, 64-bit
Byte Order:                         Little Endian
Address sizes:                      39 bits physical, 48 bits virtual
CPU(s):                             4
On-line CPU(s) list:                0-3
Thread(s) per core:                 1
Core(s) per socket:                 4
Socket(s):                          1
NUMA node(s):                       1
Vendor ID:                          GenuineIntel
CPU family:                         6
Model:                              158
Model name:                         Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
Stepping:                           9
CPU MHz:                            2808.004
BogoMIPS:                           5616.00
Hypervisor vendor:                  KVM
Virtualization type:                full
L1d cache:                          128 KiB
L1i cache:                          128 KiB
L2 cache:                           1 MiB
L3 cache:                           24 MiB
NUMA node0 CPU(s):                  0-3
Vulnerability Gather data sampling: Unknown: Dependent on hypervisor status
Vulnerability Itlb multihit:        KVM: Mitigation: VMX unsupported
Vulnerability L1tf:                 Mitigation; PTE Inversion
Vulnerability Mds:                  Mitigation; Clear CPU buffers; SMT Host state unknown
Vulnerability Meltdown:             Mitigation; PTI
Vulnerability Mmio stale data:      Mitigation; Clear CPU buffers; SMT Host state unknown
Vulnerability Retbleed:             Vulnerable
Vulnerability Spec rstack overflow: Not affected
Vulnerability Spec store bypass:    Vulnerable
Vulnerability Spectre v1:           Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:           Mitigation; Retpolines, STIBP disabled, RSB filling, PBRSB-eIBRS Not affected
Vulnerability Srbds:                Unknown: Dependent on hypervisor status
Vulnerability Tsx async abort:      Not affected
Flags:                              fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nop
                                    l xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_l
                                    m abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d

```

#### sysctl - configure kernel parameters at runtime

```bash
# 停用 IPv6 網路位址 - https://officeguide.cc/ubuntu-linux-disable-ipv6-address-tutorial/
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
# 啟用 IPv6 網路位址
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=0

```

#### uname - print system information

```bash
$ uname -a
Linux build20-vbx 5.15.0-87-generic #97~20.04.1-Ubuntu SMP Thu Oct 5 08:25:28 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

$ uname -m
x86_64
```

#### /proc/cpuinfo

```bash
cat /proc/cpuinfo
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

# 清除重建 dentry和inode的頻率
cat /proc/sys/vm/vfs_cache_pressure

```

#### /proc/sys/vm/drop_caches

```bash
# 頁面緩存
sync; echo 1 > /proc/sys/vm/drop_caches

# 目錄緩存和inodes
sync; echo 2 > /proc/sys/vm/drop_caches

# 頁面緩存、目錄緩存和inodes
sync; echo 3 > /proc/sys/vm/drop_caches

```

#### /proc/sys/vm/overcommit_memory

```bash
# https://access.redhat.com/documentation/zh-tw/red_hat_enterprise_linux/6/html/performance_tuning_guide/s-memory-captun

# kernel 不進行記憶體過度寫入處理。在此設定下，過度使用記憶體的機會會增加，但對於頻繁存取記憶體的任務來說，效能也會增加。
echo 1 > /proc/sys/vm/overcommit_memory

# kernel 拒絕相等或大於總可用置換空間與實體記憶體比例（於 overcommit_ratio 指定）的記憶體需求。如果您想要降低記憶體過度寫入的風險，這是最佳設定。
echo 2 > /proc/sys/vm/overcommit_memory

```

# 14. Security Handler

## 14.1. openssl

```bash
# list all security version
openssl ciphers -v | awk '{print $2}' | sort | uniq
openssl s_client -help 2>&1  > /dev/null | egrep "\-(ssl|tls)[^a-z]"
openssl s_client -help 2>&1 | awk '/-ssl[0-9]|-tls[0-9]/{print $1}' 
openssl ciphers
```

```bash
# base64
PASS_ENC=`openssl base64 -e <<< "lankahsu520"`; echo "(PASS_ENC: $PASS_ENC)"
PASS_DEC=`openssl base64 -d <<< "$PASS_ENC"`; echo "(PASS_DEC: $PASS_DEC)"
```

## 14.2. base64

```bash
PASS_ENC=`echo lankahsu520 | base64`; echo "(PASS_ENC: $PASS_ENC)"
PASS_DEC=`echo $PASS_ENC | base64 -d`; echo "(PASS_DEC: $PASS_DEC)"
```

## 14.3. lynis

> 只是一個安全審計工具，就算找出問題後，也沒有相關的修補方式，因此實用性就不高了。

```bash
sudo apt install -y lynis

sudo lynis update check

# Perform local security scan
sudo lynis audit system
```

```bash
# upgrade
sudo apt update
sudo apt upgrade
# add lynis repository 
echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
# download the public signing key
wget -O - https://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -
sudo apt update
sudo apt install -y lynis
lynis show version
```

# 15. MTD Handler

```bash
sudo apt install -y mtd-utils

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

> 掃出後的資訊很多，

```bash
sudo apt-get install rkhunter

# 手動更新病毒碼
sudo rkhunter --propupd
```

```bash
$ sudo vi /etc/rkhunter.conf.local
PKGMGR=DPKG
# netatalk
RTKT_FILE_WHITELIST=/bin/ad

```

```bash
# Check the local system
sudo rkhunter -c

# Don't wait for a keypress after each test
sudo rkhunter -c --skip-keypress
```

```bash
sudo cat /var/log/rkhunter.log
```

- [x] /bin/ad

> Warning: 'Spanish' Rootkit                        [ Warning ]
>           File '/bin/ad' found

```
# 請先刪除
sudo apt remove netatalk
```

## 16.2. ClamAV

```bash
sudo apt install -y clamav
sudo apt install -y libclamunrar9

systemctl status clamav-freshclam
systemctl stop clamav-freshclam
# 手動更新病毒碼
sudo freshclam
systemctl start clamav-freshclam

```

```bash
# 掃所有檔案
sudo clamscan -vr /

# 掃所有檔案，Save scan report to FILE
sudo clamscan -vr --log=~/virus/`date +"%Y%m%d"`.log /

# 掃所有檔案，刪除中毒的檔案
sudo clamscan -vr --remove /

# 掃所有檔案，搬移中毒的檔案
sudo clamscan -vr --move=~/virus /

# 掃所有檔案，複製中毒的檔案
sudo clamscan -vr --copy=~/virus /

# 掃所有檔案，不印出 OK 的檔案
sudo clamscan -vr -o /

# 掃所有檔案，只顯示中毒的檔案
sudo clamscan -vr -i /

# 限定深度 3層
sudo clamscan -vr --max-dir-recursion=3 /

# 針對 checklist.txt 裏指定的檔案
sudo clamscan -vf checklist.txt
```

- /etc/clamav/freshclam.conf

```bash
# freshclam.conf 手冊
$ man freshclam.conf
$ cat /etc/clamav/freshclam.conf
# Automatically created by the clamav-freshclam postinst
# Comments will get lost when you reconfigure the clamav-freshclam package

DatabaseOwner clamav
UpdateLogFile /var/log/clamav/freshclam.log
LogVerbose false
LogSyslog false
LogFacility LOG_LOCAL6
LogFileMaxSize 0
LogRotate true
LogTime true
Foreground false
Debug false
MaxAttempts 5
DatabaseDirectory /var/lib/clamav
DNSDatabaseInfo current.cvd.clamav.net
ConnectTimeout 30
ReceiveTimeout 0
TestDatabases yes
ScriptedUpdates yes
CompressLocalDatabase no
Bytecode true
NotifyClamd /etc/clamav/clamd.conf
# Check for new database 24 times a day
Checks 24
DatabaseMirror db.local.clamav.net
DatabaseMirror database.clamav.net

$ cat  /var/log/clamav/freshclam.log
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

#### alias - define or display aliases

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

#### set - set or unset options and positional parameters

```bash
set -e：在命令返回非零退出狀態碼時自動退出 shell。這意味著，如果命令返回一個錯誤，腳本將會立即停止運行，而不會繼續執行下去。
set -o pipefail：在使用管道連接多個命令時，如果其中任何一個命令失敗，則整個管道返回失敗。預設情況下，管道只返回最後一個命令的退出狀態碼。使用 set -o pipefail 可以使管道的退出狀態碼反映所有命令的退出狀態。

```

#### unset - unset values and attributes of variables and functions

```bash
export BOSS=lanka
unset BOSS

helloworld_fn ()
{
}
unset -f helloworld_fn

```

#### xargs - build and execute command lines from standard input

```bash
ls | xargs cat

```

# 19. Editor

#### vim / vi - a programmer's text editor

> [~/.vimrc](https://github.com/lankahsu520/HelperX/blob/master/linux/.vimrc)

```bash
vi 123
vim 123
```

# Appendix

# I. Study

## I.1. [Linux 教程](https://www.runoob.com/linux/linux-tutorial.html)

## I.2. [Ubuntu Linux 安裝、使用 ClamAV 防毒軟體 clamscan 掃毒指令教學與範例](https://officeguide.cc/linux-clamav-antivirus-clamscan-installation-configuration-tutorial-examples/)

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

