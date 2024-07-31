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

$ ls -al LICENSE
-rwxrwxr-x 1 lanka lanka 1538  七   8 10:30 LICENSE

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
/var$ tree -L 1
.
├── backups
├── cache
├── crash
├── lib
├── local
├── lock -> /run/lock
├── log
├── mail
├── metrics
├── opt
├── run -> /run
├── snap
├── spool
├── tmp
└── www

15 directories, 0 files

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

#### hexdump, hd - ASCII, decimal, hexadecimal, octal dump

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

#### fuser - identify processes using files or sockets

```bash
$ fuser -mv /work_999/
                     USER        PID ACCESS COMMAND
/work_999:           root     kernel mount /
                     lanka      3939 .rce. systemd
                     lanka      4770 .rce. bash
                     lanka      4888 .r.e. bash
# 刷除佔用的 task
$ fuser -kv /work_999

```

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

# 列出所有開啟 /work 的行程
$ lsof /work
```

#### pidof -- find the process ID of a running program.

```bash
pidof helloworld

```

#### ps - report a snapshot of the current processes.

```bash
ps -aux
ps -aux | grep helloworld | grep -v grep

ps -p `pidof curl` -o pid,%mem,%cpu,vsz,cmd
ps -p 495220 -o pid,%mem,%cpu,vsz,cmd

ps-name curl
```

```bash
function ps-id()
{
	HINT="Usage: ${FUNCNAME[0]} <id1>"
	ID1=$1

	if [ ! -z "${ID1}" ]; then
		PID=${ID1}
		DO_COMMAND="(ps -p ${PID} -o pid,%mem,%cpu,vsz,time,etime,start,cmd)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function ps-name()
{
	HINT="Usage: ${FUNCNAME[0]} <name1>"
	NAME1=$1

	if [ ! -z "${NAME1}" ]; then
		PID=`pidof ${NAME1}`
		if [ ! -z "${PID}" ]; then
			ps-id ${PID}
		else
			echo "NAME1=$NAME1, PID=$PID"
		fi
	else
		echo $HINT
	fi
}
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

#### renice - alter priority of running processes

```bash
# ID1234, to set priority as 19
renice 19 1234

# To increase the priority of Lanka's tasks by +1.
renice +1 -u lanka
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

#### df - report file system disk space usage

```bash
function free-disk()
{
	df -h
}
```

#### du - estimate file space usage
```bash
function free-folder()
{
	du -h --max-depth=$1 $2
}
```

#### e2fsck - check a Linux ext2/ext3/ext4 file system

```bash
e2fsck -f /dev/sdd1
```

#### gparted - GNOME Partition Editor for manipulating disk partitions.

```bash
gparted
```

#### lsblk - list block devices

```bash
function mount-disk()
{
	lsblk -o model,name,fstype,size,label,mountpoint
}
```

#### mke2fs - create an ext2/ext3/ext4 filesystem

```bash
sudo mke2fs /dev/sdb1

```

#### ncdu - NCurses Disk Usage

```bash
sudo apt install -y ncdu

ncdu -x
```

#### tune2fs - adjust tunable filesystem parameters on ext2/ext3/ext4 filesystems

> 當複製虛擬機的硬碟時（如使用 VirtualBox 的 *.vdi），雖然在 * .vbox 會產生不同的 uuid，但是實際 vdi 裏的 uuid 的同一份。當 linux 對其進行  mount 動作時，會有對應的問題。 

```bash
# 要先執行 e2fsck
e2fsck -f /dev/sdd1
uuidgen | xargs tune2fs /dev/sdd1 -U

```

# 4. String Handler

```bash
$ export HELLO_WORLD="Hello World"

# uppercase
$ echo ${HELLO_WORLD^^}
HELLO WORLD

# lowercase
$ echo ${HELLO_WORLD,}
hello World

```

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

# remove line:94
sed -i '94d' $CFG_FILE
# add one line "\n" after line:94
sed -i '94a\\n'

# remove the line containing "PJ_BUILD_DIR"
sed -i "s|PJ_BUILD_DIR|d" *.conf
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

#### gpasswd - administer /etc/group and /etc/gshadow

```bash
$ sudo gpasswd -d pokemon pikachu
Removing user pokemon from group pikachu

```

#### groupadd - create a new group

```bash
$ sudo groupadd pokomon
```

#### groupdel - delete a group

```bash
$ sudo groupdel pikachu
```

#### groups- user group file

```bash
$ groups
lanka adm cdrom sudo dip plugdev lpadmin lxd sambashare docker

$ groups lanka
lanka : lanka adm cdrom sudo dip plugdev lpadmin lxd sambashare docker

```

#### id - print real and effective user and group IDs

```bash
$ id lanka
uid=1000(lanka) gid=1000(lanka) groups=1000(lanka),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),120(lpadmin),131(lxd),132(sambashare),142(docker)

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

#### newgrp - log in to a new group

> switch to the group

```bash
$ newgrp pokomon
```

#### passwd - change user password

```bash
$ sudo passwd pikachu
New password:
Retype new password:
passwd: password updated successfully

```

#### sudo, sudoedit - execute a command as another user

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

#### useradd - create a new user or update default new user information

```bash
$ sudo useradd pikachu
$ id pikachu
uid=1001(pikachu) gid=1003(pikachu) groups=1003(pikachu)
$ cat /etc/passwd | grep pikachu
pikachu:x:1003:1003::/home/pikachu:/bin/sh

$ groups pokemon pikachu
pokemon : pokemon
pikachu : pikachu

$ sudo mkdir -p /home/pikachu
$ sudo chown pikachu:pikachu /home/pikachu

$ sudo usermod -aG pokemon pikachu
$ id pikachu
uid=1003(pikachu) gid=1003(pikachu) groups=1003(pikachu),1004(pokemon)

$ groups pokemon pikachu
pokemon : pokemon
pikachu : pikachu pokemon

```

#### userdel - delete a user account and related files

```bash
$ sudo userdel pikachu
userdel: group pikachu not removed because it has other members.

$ sudo userdel -r pikachu
userdel: user pikachu is currently used by process 7499

$ sudo userdel -rf pikachu
userdel: user pikachu is currently used by process 7499
userdel: pikachu mail spool (/var/mail/pikachu) not found

$ cat /etc/group | grep pikachu

$ sudo groupdel pikachu
```

#### usermod - modify a user account

```bash
# Add the user to the supplementary group(s). Use only with the -G option.
$ sudo usermod -aG pokemon pikachu

# The user's new login directory
$ sudo usermod -d /work/pikachu pikachu
$ cat /etc/passwd | grep pikachu
pikachu:x:1003:1003::/work/pikachu:/bin/sh

# grant pikachu sudo privileges 
$ sudo usermod -aG sudo pikachu
```

#### users - print the user names of users currently logged in to the current host

```bash
$ users
lanka

```

#### w - Show who is logged on and what they are doing

```bash
$ w -i
 11:45:58 up  4:04,  1 user,  load average: 0.22, 0.10, 0.03
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
lanka    pts/0    192.168.56.1     08:34    4.00s  0.28s  0.00s w -i

```

#### who - show who is logged on

```bash
$ who
lanka    pts/0        2024-07-31 08:34 (192.168.56.1)

```

#### whoami - print effective userid

```bash
$ whoami
lanka

```

#### /etc/group

> Groupname:Group Password:GID:User in group

```bash
$ cat /etc/group
$ cat /etc/group | grep lanka
```

#### /etc/gshadow

```bash
$ sudo cat /etc/gshadow
```

#### /etc/passwd

> Username:Password:UserID (UID):GroupID (GID):UserID Info:Home Directory:Shell

```bash
$ cat /etc/passwd
$ cat /etc/passwd | grep lanka
lanka:x:1000:1000:lanka,,,:/home/lanka:/bin/bash

```

#### /etc/shadow

>Username:Encrypted Password:Modified Date:Minimum Password Age:Maximum Password Age:Password Expiration Warning Period:Password Inactivity Period:Account Experiation Date:Reserved Field

```bash
$ sudo cat /etc/shadow
$ sudo cat /etc/shadow | grep lanka
lanka:lanka520:19276:0:99999:7:::

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

# 查詢 IPv4 位址
ip -o -4 addr list
# 查詢 IPv6 位址
ip -o -6 addr list

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

```bash
$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:33:73:52 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:33:1b:19 brd ff:ff:ff:ff:ff:ff
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:7a:52:5b brd ff:ff:ff:ff:ff:ff
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
    link/ether 02:42:c6:06:04:0f brd ff:ff:ff:ff:ff:ff

$ ip link show enp0s3
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

> - **open**. The service on the associated port is active and listens for incoming connections. The port is available for connections.
> - **closed**. No service is listening on the port. No services are bound on the port, and the port will refuse all incoming connections.
> - **filtered**. The port state is unknown. The port's status is concealed or restricted due to packet filtering, firewall rules, or a network security device configuration.
> - **unfiltered**. The port state is unknown. The port is accessible and unrestricted but has no active service linked to it.
> - **open|filtered**. The port state is open or filtered. Nmap cannot determine which due to network conditions.
> - **closed|filtered**. The port state is closed or filtered. The exact state is indeterminate due to network conditions.

```bash
alias port-nmap="sudo nmap -p-  -sTU localhost"
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

# 當有變更*.service 時，記得
sudo systemctl daemon-reload
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

# 升級系統
sudo apt-get dist-upgrade

sudo apt-get dselect-upgrade 使用 dselect 升級

# 清理無用的包
sudo apt-get clean && sudo apt-get autoclean

# 檢查是否有損壞的依賴
sudo apt-get check

sudo apt-get -y --fix-missing upgrade
```

```bash
# 安裝 subversion-tools
sudo apt-get -y install subversion-tools
# 重新安裝 subversion-tools
sudo apt-get reinstall subversion-tools

# 搜索 subversion-tools
apt-cache search package subversion-tools

# 獲取 subversion-tools 的相關信息，如說明、大小、版本等
apt-cache show package subversion-tools

# 修覆安裝 -f = --fix-missing
sudo apt-get -f install subversion-tools

# 刪除 subversion-tools
sudo apt-get remove subversion-tools

# 刪除 subversion-tools，包括刪除配置文件等
sudo apt-get purge subversion-tools

# 了解 subversion-tools 使用依賴
apt-cache depends subversion-tools

# 是查看 subversion-tools 被哪些包依賴
apt-cache rdepends subversion-tools

# 安裝相關的編譯環境
sudo apt-get build-dep subversion-tools

```

```bash
$ sudo vi /etc/apt/sources.list
# replace # deb-src -> deb-src

# 下載該包的源代碼
apt-get source package


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

#### htop - process manager

> [你一定用過 htop，但你有看懂每個欄位嗎？](https://medium.com/starbugs/do-you-understand-htop-ffb72b3d5629)

```bash
$ sudo snap install htop
$ htop

```

#### lshw - list hardware

```bash
$ sudo lshw -c cpuster
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
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
stepping        : 9
cpu MHz         : 2808.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit srbds mmio_stale_data retbleed gds
bogomips        : 5616.00
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
stepping        : 9
cpu MHz         : 2808.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit srbds mmio_stale_data retbleed gds
bogomips        : 5616.00
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
stepping        : 9
cpu MHz         : 2808.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 2
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit srbds mmio_stale_data retbleed gds
bogomips        : 5616.00
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 158
model name      : Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
stepping        : 9
cpu MHz         : 2808.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit srbds mmio_stale_data retbleed gds
bogomips        : 5616.00
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

```

#### /proc/meminfo

```bash
$ cat /proc/meminfo
MemTotal:        8128112 kB
MemFree:         4106224 kB
MemAvailable:    6642780 kB
Buffers:          134364 kB
Cached:          2575252 kB
SwapCached:            0 kB
Active:           681992 kB
Inactive:        2988256 kB
Active(anon):       2872 kB
Inactive(anon):   970220 kB
Active(file):     679120 kB
Inactive(file):  2018036 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2097148 kB
SwapFree:        2097148 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        960636 kB
Mapped:           507832 kB
Shmem:             12460 kB
KReclaimable:     116532 kB
Slab:             212152 kB
SReclaimable:     116532 kB
SUnreclaim:        95620 kB
KernelStack:       10432 kB
PageTables:        17908 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6161204 kB
Committed_AS:    5359732 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       46064 kB
VmallocChunk:          0 kB
Percpu:             5200 kB
HardwareCorrupted:     0 kB
AnonHugePages:      2048 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      268224 kB
DirectMap2M:     8120320 kB

```

#### /proc/sys/vm

```bash
$ cat /proc/sys/vm/swappiness
60
$ cat /proc/sys/vm/dirty_background_ratio
10
$ cat /proc/sys/vm/dirty_ratio
20
$ cat /proc/sys/vm/dirty_expire_centisecs
3000
# 清除重建 dentry和inode的頻率
$ $ cat /proc/sys/vm/vfs_cache_pressure
100

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

## 14.1. Message Digest & Hash Function

#### md5sum - compute and check MD5 message digest

```bash
$ md5sum LICENSE
a828cf528fac643fcfef67d9304b685b  LICENSE

$ md5sum LICENSE > LICENSE.md5sum
$ md5sum -c LICENSE.md5sum
LICENSE: OK

$ cat LICENSE | md5sum
a828cf528fac643fcfef67d9304b685b  -

```

#### sha1sum - compute and check SHA1 message digest

```bash
$ sha1sum LICENSE
d27307d3abeb72ceec1181d641795d96e3004c8e  LICENSE

$ sha1sum LICENSE > LICENSE.sha1sum
$ sha1sum -c LICENSE.sha1sum
LICENSE: OK

$ cat LICENSE | sha1sum
d27307d3abeb72ceec1181d641795d96e3004c8e  -

```

#### sha256sum - compute and check SHA256 message digest

```bash
$ sha256sum LICENSE
d351638bb049dd4b46c8079adb0c059990e352bc28285a84835568fb1650f2da  LICENSE

$ sha256sum LICENSE > LICENSE.sha256sum
$ sha256sum -c LICENSE.sha256sum
LICENSE: OK

$ cat LICENSE | sha256sum
d351638bb049dd4b46c8079adb0c059990e352bc28285a84835568fb1650f2da  -

```

## 14.2. openssl

```bash
# list all security version
$ openssl ciphers -v | awk '{print $2}' | sort | uniq
SSLv3
TLSv1
TLSv1.2
TLSv1.3

$ openssl s_client -help 2>&1  > /dev/null | egrep "\-(ssl|tls)[^a-z]"
 -ssl_config val            Use specified configuration file
 -tls1                      Just use TLSv1
 -tls1_1                    Just use TLSv1.1
 -tls1_2                    Just use TLSv1.2
 -tls1_3                    Just use TLSv1.3
 -ssl_client_engine val     Specify engine to be used for client certificate operations

$ openssl s_client -help 2>&1 | awk '/-ssl[0-9]|-tls[0-9]/{print $1}'
-tls1
-tls1_1
-tls1_2
-tls1_3

$ openssl ciphers
TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:DHE-RSA-AES256-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:RSA-PSK-AES256-GCM-SHA384:DHE-PSK-AES256-GCM-SHA384:RSA-PSK-CHACHA20-POLY1305:DHE-PSK-CHACHA20-POLY1305:ECDHE-PSK-CHACHA20-POLY1305:AES256-GCM-SHA384:PSK-AES256-GCM-SHA384:PSK-CHACHA20-POLY1305:RSA-PSK-AES128-GCM-SHA256:DHE-PSK-AES128-GCM-SHA256:AES128-GCM-SHA256:PSK-AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:ECDHE-PSK-AES256-CBC-SHA384:ECDHE-PSK-AES256-CBC-SHA:SRP-RSA-AES-256-CBC-SHA:SRP-AES-256-CBC-SHA:RSA-PSK-AES256-CBC-SHA384:DHE-PSK-AES256-CBC-SHA384:RSA-PSK-AES256-CBC-SHA:DHE-PSK-AES256-CBC-SHA:AES256-SHA:PSK-AES256-CBC-SHA384:PSK-AES256-CBC-SHA:ECDHE-PSK-AES128-CBC-SHA256:ECDHE-PSK-AES128-CBC-SHA:SRP-RSA-AES-128-CBC-SHA:SRP-AES-128-CBC-SHA:RSA-PSK-AES128-CBC-SHA256:DHE-PSK-AES128-CBC-SHA256:RSA-PSK-AES128-CBC-SHA:DHE-PSK-AES128-CBC-SHA:AES128-SHA:PSK-AES128-CBC-SHA256:PSK-AES128-CBC-SHA
```

```bash
# base64
PASS_ENC=`openssl base64 -e <<< "lankahsu520"`; echo "(PASS_ENC: $PASS_ENC)"
PASS_DEC=`openssl base64 -d <<< "$PASS_ENC"`; echo "(PASS_DEC: $PASS_DEC)"
```

## 14.3. base64

```bash
PASS_ENC=`echo lankahsu520 | base64`; echo "(PASS_ENC: $PASS_ENC)"
PASS_DEC=`echo $PASS_ENC | base64 -d`; echo "(PASS_DEC: $PASS_DEC)"
```

## 14.4. lynis

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

#### unzip - list, test and extract compressed files in a ZIP archive

```bash
unzip helloworld.zip

```

#### uuidgen - create a new UUID value

```bash
$ uuidgen
a9d92443-354b-47aa-a216-e60bbf73a94c

```

#### zip - package and compress (archive) files

```bash
zip -r helloworld.zip helloworld

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

$ cd HelperX/mqtt; ls | xargs -t -I {}  cat {}
cat mqttPub.sh
...
cat mqttSub.sh
...
```

# 19. Editor

#### vim / vi - a programmer's text editor

> [~/.vimrc](https://github.com/lankahsu520/HelperX/blob/master/linux/.vimrc)

```bash
vi 123
vim 123
```

# 20. Shell Scripts

#### eval-it

> 把字串當成命令執行

```bash
#sh -c "$DO_COMMAND"
function eval-it()
{
	DO_COMMAND="$*"
	echo "[${DO_COMMAND}]"
	eval ${DO_COMMAND}
}
```

```bash
$ eval-it "echo 123"
[echo 123]
123
```

#### eval-loop

```bash
function eval-loop()
{
	HINT="Usage: ${FUNCNAME[0]} <min> <max> \"<commands>\""

	MIN1="$1"
	MAX2="$2"
	COMMAND3="$3"

	if [ ! -z "$COMMAND3" ]; then
		for i in `seq ${MIN1} ${MAX2}`
		do
						#echo "Welcome $i !!!"
						eval-it "${COMMAND3}$i"
		done
	else
		echo -e $HINT
	fi
}
```

```bash
$ eval-loop 0 2 "echo "
[echo 0]
0
[echo 1]
1
[echo 2]
2
```

#### now_fn

> 回傳現在時間

```bash
now_fn()
{
	NOW_t=`date +"%Y%m%d%H%M%S"`
	return $NOW_t
}
```

```bash
$ now_fn
$ echo $NOW_t
20231229092235
```

# 21. pkg-config

```bash
$ pkg-config --version
0.29.1
```

#### --list-all

> 列出所有的函式庫

```bash
$ pkg-config --list-all | grep gstreamer
gstreamer-gl-1.0               GStreamer OpenGL Plugins Libraries - Streaming media framework, OpenGL plugins libraries
gstreamer-plugins-base-1.0     GStreamer Base Plugins Libraries - Streaming media framework, base plugins libraries
gstreamer-tag-1.0              GStreamer Tag Library - Tag base classes and helper functions
gstreamer-1.0                  GStreamer - Streaming media framework
gstreamer-sdp-1.0              GStreamer SDP Library - SDP helper functions
gstreamer-controller-1.0       GStreamer controller - Dynamic parameter control for GStreamer elements
gstreamer-base-1.0             GStreamer base classes - Base classes for GStreamer elements
gstreamer-pbutils-1.0          GStreamer Base Utils Library - General utility functions
gstreamer-check-1.0            GStreamer check unit testing - Unit testing helper library for GStreamer modules
gstreamer-video-1.0            GStreamer Video Library - Video base classes and helper functions
gstreamer-riff-1.0             GStreamer RIFF Library - RIFF helper functions
gstreamer-allocators-1.0       GStreamer Allocators Library - Allocators implementation
gstreamer-fft-1.0              GStreamer FFT Library - FFT implementation
gstreamer-audio-1.0            GStreamer Audio library - Audio helper functions and base classes
gstreamer-app-1.0              GStreamer Application Library - Helper functions and base classes for application integration
gstreamer-net-1.0              GStreamer networking library - Network-enabled GStreamer plug-ins and clocking
gstreamer-rtsp-1.0             GStreamer RTSP Library - RTSP base classes and helper functions
gstreamer-rtp-1.0              GStreamer RTP Library - RTP base classes and helper functions
```

#### --exists

> 確定該函式庫是否存在

```bash
$ pkg-config --exists gstreamer-1.0 && echo "yes" || echo "no"
yes
```

#### --cflags

> 連結該函式庫的 CFLAGS

```bash
$ pkg-config --cflags gstreamer-1.0
-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
```

#### --libs

> 連結該函式庫的 LDFLAGS

```bash
$ pkg-config --libs gstreamer-1.0
-lgstreamer-1.0 -lgobject-2.0 -lglib-2.0
```

#### --modversion

> 秀出該函式庫版本號

```bash
$ pkg-config --modversion gstreamer-1.0
1.16.3

$ pkg-config 'gstreamer-1.0 >= 1.17' && echo "yes" || echo "no"
no
$ pkg-config 'gstreamer-1.0 >= 1.16' && echo "yes" || echo "no"
yes
```

#### --print-requires

> 引用該函式庫將需要 depend on ...

```bash
$ pkg-config --print-requires gstreamer-1.0
glib-2.0
gobject-2.0
```

#### pkg-find

```bash
function pkg-find()
{
	HINT="Usage: ${FUNCNAME[0]} <file1>"
	FILE1=$1

	if [ ! -z "$FILE1" ]; then
		pkg-config --list-all | grep ${FILE1}
	else
		echo $HINT
	fi
}
```

#### pkg-config-ex

```bash
function pkg-config-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <files>"
	FILES="$*"

	if [ ! -z "$FILES" ]; then
		for FILE in ${FILES}; do
		(
			DO_COMMAND="pkg-config --variable pc_path pkg-config"
			eval-it "$DO_COMMAND"

			DO_COMMAND="pkg-config --cflags ${FILE}"
			eval-it "$DO_COMMAND"

			DO_COMMAND="pkg-config --libs ${FILE}"
			eval-it "$DO_COMMAND"

			DO_COMMAND="pkg-config --modversion ${FILE}"
			eval-it "$DO_COMMAND"

			DO_COMMAND="pkg-config --print-requires ${FILE}"
			eval-it "$DO_COMMAND"
		)
		done
	else
		echo $HINT
	fi
}
```

# 22. usb Handler

```bash
$ ll /sys/bus/usb/devices/
total 0
drwxr-xr-x 2 root root 0  五   4 15:50 ./
drwxr-xr-x 4 root root 0  五   4 15:50 ../
lrwxrwxrwx 1 root root 0  五   4 15:50 1-0:1.0 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/1-0:1.0/
lrwxrwxrwx 1 root root 0  五   4 15:50 1-1 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/1-1/
lrwxrwxrwx 1 root root 0  五   4 15:50 1-1:1.0 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/1-1/1-1:1.0/
lrwxrwxrwx 1 root root 0  五   4 18:29 1-2 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/1-2/
lrwxrwxrwx 1 root root 0  五   4 18:29 1-2:1.0 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/1-2/1-2:1.0/
lrwxrwxrwx 1 root root 0  五   4 15:50 2-0:1.0 -> ../../../devices/pci0000:00/0000:00:0c.0/usb2/2-0:1.0/
lrwxrwxrwx 1 root root 0  五   4 15:50 usb1 -> ../../../devices/pci0000:00/0000:00:0c.0/usb1/
lrwxrwxrwx 1 root root 0  五   4 15:50 usb2 -> ../../../devices/pci0000:00/0000:00:0c.0/usb2/
```

#### lsusb - list USB devices

```bash
$ lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 10c4:8468 Silicon Labs Tview
Bus 001 Device 002: ID 80ee:0021 VirtualBox USB Tablet
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

$ lsusb -t
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/8p, 480M
    |__ Port 1: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 12M
    |__ Port 2: Dev 3, If 0, Class=Human Interface Device, Driver=, 12M
```

#### usb-tree

```bash
function usb-tree()
{
	tree /dev/bus/usb
}
```

```bash
$ usb-tree
/dev/bus/usb
├── 001
│   ├── 001
│   ├── 002
│   └── 003
└── 002
    └── 001

2 directories, 4 files
```

#### usb-mount

```bash
function usb-mount()
{
	for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
	(
		syspath="${sysdevpath%/dev}"
		devname="$(udevadm info -q name -p $syspath)"
		if [[ "$devname" == "bus/"* ]]; then
			#echo "==> ${FUNCNAME[0]}:${LINENO}- $devname"
			#echo "==> sysdevpath: $sysdevpath"
			#echo "==> syspath: $syspath"
			#udevadm info -q property --export -p $syspath
			eval "$(udevadm info -q property --export -p $syspath)"
			echo "$DEVNAME;${ID_VENDOR_ID^^}:${ID_MODEL_ID^^};${ID_TYPE};${ID_SERIAL};"
		else
			#echo "==> ${FUNCNAME[0]}:${LINENO}- $devname"
			#udevadm info -q property --export -p $syspath
			eval "$(udevadm info -q property --export -p $syspath)"
			[[ -z "$ID_SERIAL" ]] && exit
			echo "/dev/$devname;${ID_VENDOR_ID^^}:${ID_MODEL_ID^^};${ID_TYPE};${ID_SERIAL};"
		fi
	)
	done
}
```

```bash
$ usb-mount
/dev/bus/usb/001/001;1D6B:0002;;Linux_5.15.0-105-generic_xhci-hcd_xHCI_Host_Controller_0000:00:0c.0;
/dev/bus/usb/001/002;80EE:0021;;VirtualBox_USB_Tablet;
/dev/input/event5;80EE:0021;hid;VirtualBox_USB_Tablet;
/dev/input/js0;80EE:0021;hid;VirtualBox_USB_Tablet;
/dev/input/mouse1;80EE:0021;hid;VirtualBox_USB_Tablet;
/dev/bus/usb/001/003;10C4:8468;;Tiqiaa_Tview;
/dev/bus/usb/002/001;1D6B:0003;;Linux_5.15.0-105-generic_xhci-hcd_xHCI_Host_Controller_0000:00:0c.0;
```

# 23. Multimedia Handler

## 23.1. GStreamer
> 請參考 [helper_GStreamer.md](https://github.com/lankahsu520/HelperX/blob/master/helper_GStreamer.md) - GStreamer helper.

## 23.2. [streamlink](https://pypi.org/project/streamlink/)
> extracts streams from various services and pipes them into a video player of choice

```bash
$ pip install --upgrade streamlink
```

```bash
function streamlink-helper()
{
	echo "STREAM_URL=${STREAM_URL}"
	echo "STREAM_SAVETO=${STREAM_SAVETO}"
	echo "STREAM_QUALITY=${STREAM_QUALITY}"
}

function streamlink-info()
{
	HINT="Usage: ${FUNCNAME[0]} <url>"
	URL1="$1"

	if [ ! -z "${URL1}" ]; then
		export STREAM_URL=${URL1}
		unset STREAM_SAVETO
		unset STREAM_QUALITY
		DO_COMMAND="(streamlink ${STREAM_URL} -l info)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function streamlink-pull()
{
	HINT="Usage: ${FUNCNAME[0]} <saveto> <quality> <url>"
	SAVETO1="$1"
	QUALITY2="$2"
	URL3="$3"

	NOW=`date +"%Y%m%d%H%M%S"`

	[ "$SAVETO1" = "" ] && [ "$STREAM_SAVETO" = "" ] && export STREAM_SAVETO="${NOW}.mp4"
	[ "$SAVETO1" != "" ] && export STREAM_SAVETO=${SAVETO1}

	[ "$QUALITY2" = "" ] && [ "$STREAM_QUALITY" = "" ] && export STREAM_QUALITY="best"
	[ "$QUALITY2" != "" ] && export STREAM_QUALITY=${QUALITY2}

	[ "$URL3" != "" ] && export STREAM_URL=${URL3}

	if [ ! -z "${STREAM_URL}" ] && [ ! -z "${STREAM_SAVETO}" ]; then
		DO_COMMAND="(streamlink --retry-max 3 -o ${STREAM_SAVETO} ${STREAM_URL} ${STREAM_QUALITY})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

```bash
$ streamlink-info https://www.youtube.com/watch?v=a_9_38JpdYU
[(streamlink https://www.youtube.com/watch?v=a_9_38JpdYU -l info)]
[cli][info] Found matching plugin youtube for URL https://www.youtube.com/watch?v=a_9_38JpdYU
Available streams: audio_mp4a, audio_opus, 144p (worst), 240p, 360p, 480p, 720p, 1080p (best)

$ streamlink-pull
[(streamlink --retry-max 3 -o 20240527084746.mp4 https://www.youtube.com/watch?v=a_9_38JpdYU best)]
[cli][info] Found matching plugin youtube for URL https://www.youtube.com/watch?v=a_9_38JpdYU
[cli][info] Available streams: audio_mp4a, audio_opus, 144p (worst), 240p, 360p, 480p, 1080p (best)
[cli][info] Opening stream: 1080p (muxed-stream)
[cli][info] Writing output to
/work/codebase/xbox/xbox_123/20240527084746.mp4
[utils.named_pipe][info] Creating pipe streamlinkpipe-136632-1-5194
[utils.named_pipe][info] Creating pipe streamlinkpipe-136632-2-642
[download] Written 1.39 MiB to /work/codebase/xbox/xbox_123/20240527084746.mp4 (5s @ 300.11 KiB/s)
```

```bash
$ streamlink-info https://www.youtube.com/watch?v=ikrasYUi3kM
[(streamlink https://www.youtube.com/watch?v=ikrasYUi3kM -l info)]
[cli][info] Found matching plugin youtube for URL https://www.youtube.com/watch?v=ikrasYUi3kM
error: This plugin does not support protected videos, try youtube-dl instead

```

## 23.3. [yt-dlp](https://pypi.org/project/yt-dlp/)

> [output-template](https://github.com/yt-dlp/yt-dlp#output-template)

```bash
$ pip install --upgrade yt-dlp
```

```bash
function yt-dlp-helper()
{
	echo "YT_DLP_URL=${YT_DLP_URL}"
	echo "YT_DLP_SAVETO=${YT_DLP_SAVETO}"
	echo "YT_DLP_QUALITY=${YT_DLP_QUALITY}"
}

function yt-dlp-info()
{
	HINT="Usage: ${FUNCNAME[0]} <url>"
	URL1="$1"

	if [ ! -z "${URL1}" ]; then
		export YT_DLP_URL=${URL1}
		unset YT_DLP_SAVETO
		unset YT_DLP_QUALITY
		DO_COMMAND="(yt-dlp -F ${YT_DLP_URL})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function yt-dlp-pull()
{
	HINT="Usage: ${FUNCNAME[0]} <saveto> <quality> <url>"
	SAVETO1="$1"
	QUALITY2="$2"
	URL3="$3"

	NOW=`date +"%Y%m%d%H%M%S"`

	[ "$SAVETO1" = "" ] && [ "$YT_DLP_SAVETO" = "" ] && export YT_DLP_SAVETO="${NOW}.mp4"
	[ "$SAVETO1" != "" ] && export YT_DLP_SAVETO=${SAVETO1}

	[ "$QUALITY2" = "" ] && [ "$YT_DLP_QUALITY" = "" ] && export YT_DLP_QUALITY="'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b'"
	[ "$QUALITY2" != "" ] && export YT_DLP_QUALITY=${QUALITY2}

	[ "$URL3" != "" ] && export YT_DLP_URL=${URL3}

	if [ ! -z "${YT_DLP_URL}" ] && [ ! -z "${YT_DLP_SAVETO}" ]; then
		DO_COMMAND="(yt-dlp -f ${YT_DLP_QUALITY} ${YT_DLP_URL} -o ${YT_DLP_SAVETO})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

```bash
$ yt-dlp-info https://www.youtube.com/watch?v=a_9_38JpdYU
[(yt-dlp -F https://www.youtube.com/watch?v=a_9_38JpdYU)]
[youtube] Extracting URL: https://www.youtube.com/watch?v=a_9_38JpdYU
[youtube] a_9_38JpdYU: Downloading webpage
[youtube] a_9_38JpdYU: Downloading ios player API JSON
[youtube] a_9_38JpdYU: Downloading m3u8 information
[info] Available formats for a_9_38JpdYU:
ID      EXT   RESOLUTION FPS CH │   FILESIZE   TBR PROTO │ VCODEC          VBR ACODEC      ABR ASR MORE INFO
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
sb3     mhtml 48x27        0    │                  mhtml │ images                                  storyboard
sb2     mhtml 80x45        0    │                  mhtml │ images                                  storyboard
sb1     mhtml 160x90       0    │                  mhtml │ images                                  storyboard
sb0     mhtml 320x180      0    │                  mhtml │ images                                  storyboard
233     mp4   audio only        │                  m3u8  │ audio only          unknown             [ja] Default
234     mp4   audio only        │                  m3u8  │ audio only          unknown             [ja] Default
139-drc m4a   audio only      2 │    8.26MiB   49k https │ audio only          mp4a.40.5   49k 22k [ja] low, DRC, m4a_dash
249-drc webm  audio only      2 │    9.12MiB   54k https │ audio only          opus        54k 48k [ja] low, DRC, webm_dash
250-drc webm  audio only      2 │   11.87MiB   70k https │ audio only          opus        70k 48k [ja] low, DRC, webm_dash
139     m4a   audio only      2 │    8.26MiB   49k https │ audio only          mp4a.40.5   49k 22k [ja] low, m4a_dash
249     webm  audio only      2 │    9.07MiB   54k https │ audio only          opus        54k 48k [ja] low, webm_dash
250     webm  audio only      2 │   11.81MiB   70k https │ audio only          opus        70k 48k [ja] low, webm_dash
140-drc m4a   audio only      2 │   21.92MiB  129k https │ audio only          mp4a.40.2  129k 44k [ja] medium, DRC, m4a_dash
251-drc webm  audio only      2 │   22.72MiB  134k https │ audio only          opus       134k 48k [ja] medium, DRC, webm_dash
140     m4a   audio only      2 │   21.92MiB  129k https │ audio only          mp4a.40.2  129k 44k [ja] medium, m4a_dash
251     webm  audio only      2 │   22.60MiB  133k https │ audio only          opus       133k 48k [ja] medium, webm_dash
602     mp4   256x144     12    │ ~ 18.14MiB  107k m3u8  │ vp09.00.10.08  107k video only
394     mp4   256x144     24    │    7.84MiB   46k https │ av01.0.00M.08   46k video only          144p, mp4_dash
269     mp4   256x144     24    │ ~ 38.95MiB  230k m3u8  │ avc1.4D400C    230k video only
160     mp4   256x144     24    │    8.04MiB   47k https │ avc1.4D400C     47k video only          144p, mp4_dash
603     mp4   256x144     24    │ ~ 27.85MiB  165k m3u8  │ vp09.00.11.08  165k video only
278     webm  256x144     24    │   11.37MiB   67k https │ vp9             67k video only          144p, webm_dash
395     mp4   426x240     24    │   13.35MiB   79k https │ av01.0.00M.08   79k video only          240p, mp4_dash
229     mp4   426x240     24    │ ~ 65.24MiB  385k m3u8  │ avc1.4D4015    385k video only
133     mp4   426x240     24    │   13.24MiB   78k https │ avc1.4D4015     78k video only          240p, mp4_dash
604     mp4   426x240     24    │ ~ 49.89MiB  295k m3u8  │ vp09.00.20.08  295k video only
242     webm  426x240     24    │   17.08MiB  101k https │ vp9            101k video only          240p, webm_dash
396     mp4   640x360     24    │   23.50MiB  139k https │ av01.0.01M.08  139k video only          360p, mp4_dash
230     mp4   640x360     24    │ ~132.38MiB  782k m3u8  │ avc1.4D401E    782k video only
134     mp4   640x360     24    │   23.80MiB  141k https │ avc1.4D401E    141k video only          360p, mp4_dash
18      mp4   640x360     24  2 │   73.36MiB  433k https │ avc1.42001E         mp4a.40.2       44k [ja] 360p
605     mp4   640x360     24    │ ~ 97.56MiB  576k m3u8  │ vp09.00.21.08  576k video only
243     webm  640x360     24    │   28.81MiB  170k https │ vp9            170k video only          360p, webm_dash
397     mp4   854x480     24    │   36.55MiB  216k https │ av01.0.04M.08  216k video only          480p, mp4_dash
231     mp4   854x480     24    │ ~219.04MiB 1294k m3u8  │ avc1.4D401E   1294k video only
135     mp4   854x480     24    │   35.02MiB  207k https │ avc1.4D401E    207k video only          480p, mp4_dash
606     mp4   854x480     24    │ ~161.68MiB  955k m3u8  │ vp09.00.30.08  955k video only
244     webm  854x480     24    │   42.48MiB  251k https │ vp9            251k video only          480p, webm_dash
22      mp4   1280x720    24  2 │ ≈ 82.18MiB  485k https │ avc1.64001F         mp4a.40.2       44k [ja] 720p
398     mp4   1280x720    24    │   61.94MiB  366k https │ av01.0.05M.08  366k video only          720p, mp4_dash
232     mp4   1280x720    24    │ ~398.59MiB 2355k m3u8  │ avc1.4D401F   2355k video only
136     mp4   1280x720    24    │   60.33MiB  356k https │ avc1.4D401F    356k video only          720p, mp4_dash
609     mp4   1280x720    24    │ ~291.58MiB 1723k m3u8  │ vp09.00.31.08 1723k video only
247     webm  1280x720    24    │   62.78MiB  371k https │ vp9            371k video only          720p, webm_dash
399     mp4   1920x1080   24    │  103.37MiB  611k https │ av01.0.08M.08  611k video only          1080p, mp4_dash
270     mp4   1920x1080   24    │ ~804.28MiB 4751k m3u8  │ avc1.640028   4751k video only
137     mp4   1920x1080   24    │  188.60MiB 1114k https │ avc1.640028   1114k video only          1080p, mp4_dash
614     mp4   1920x1080   24    │ ~477.79MiB 2823k m3u8  │ vp09.00.40.08 2823k video only
248     webm  1920x1080   24    │  134.73MiB  796k https │ vp9            796k video only          1080p, webm_dash
616     mp4   1920x1080   24    │ ~981.90MiB 5801k m3u8  │ vp09.00.40.08 5801k video only          Premium
```

```bash
$ yt-dlp-helper
YT_DLP_URL=https://www.youtube.com/watch?v=a_9_38JpdYU
YT_DLP_SAVETO=
YT_DLP_QUALITY=

$ yt-dlp-pull
[(yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b' https://www.youtube.com/watch?v=a_9_38JpdYU -o 20240530232750.mp4)]
[youtube] Extracting URL: https://www.youtube.com/watch?v=a_9_38JpdYU
[youtube] a_9_38JpdYU: Downloading webpage
[youtube] a_9_38JpdYU: Downloading ios player API JSON
[youtube] a_9_38JpdYU: Downloading m3u8 information
[info] a_9_38JpdYU: Downloading 1 format(s): 616+140
[hlsnative] Downloading m3u8 manifest
[hlsnative] Total fragments: 271
[download] Destination: 20240530232750.f616.mp4
[download] 100% of  269.21MiB in 00:00:30 at 8.79MiB/s
[download] Destination: 20240530232750.f140.m4a
[download] 100% of   21.92MiB in 00:00:01 at 12.69MiB/s
[Merger] Merging formats into "20240530232750.mp4"
Deleting original file 20240530232750.f140.m4a (pass -k to keep)
Deleting original file 20240530232750.f616.mp4 (pass -k to keep)
```

```bash
$ yt-dlp -f bv*+ba "https://www.youtube.com/watch?v=a_9_38JpdYU" -o 20240527084746
# m4a + mp4
$ yt-dlp -f 140+133 "https://www.youtube.com/watch?v=a_9_38JpdYU" -o 20240527084746
# m4a
$ yt-dlp -f 140 "https://www.youtube.com/watch?v=a_9_38JpdYU" -o 20240527084746
```

# Appendix

# I. Study

## I.1. [Linux 教程](https://www.runoob.com/linux/linux-tutorial.html)

## I.2. [Ubuntu Linux 安裝、使用 ClamAV 防毒軟體 clamscan 掃毒指令教學與範例](https://officeguide.cc/linux-clamav-antivirus-clamscan-installation-configuration-tutorial-examples/)

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

