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

# display folder names
$ ls -lA ~/ | awk '/^d/ {print $9}'
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
rsync -av --progress --delete --exclude lost+found --exclude recycle /work/* /work_bak
```

#### scp - OpenSSH secure file copy

```bash
scp -vr /work/* lanka@192.168.0.99:/work

# use keypair
scp -i KeyPair.pem ubuntu@192.168.0.99:/work/snap-debug-info.sh ./
```

```bash
# to keep password into SCP_PASS_AUTO
# ssh-pass123 lankahsu520
# sshpp scp -vr /work/* lanka@192.168.0.99:/work
function sshpp()
{
	SSH_COMMAND="$*"

	if [ ! -z "$SCP_PASS_AUTO" ]; then
		DO_COMMAND="(sshpass -p '${SCP_PASS_AUTO}' ${SSH_COMMAND})"
		eval-it "$DO_COMMAND"
	else
		echo "Please set [SCP_PASS_AUTO]"
		DO_COMMAND="(${SSH_COMMAND})"
		eval-it "$DO_COMMAND"
	fi
}

function ssh-pass123()
{
	HINT="Usage: ${FUNCNAME[0]} <password>"
	SCP_PASS="$1"

	if [ ! -z "${SCP_PASS}" ]; then
		export SCP_PASS_AUTO=${SCP_PASS}
	else 
		echo $HINT
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
function diffX()
{
	HINT="Usage: ${FUNCNAME[0]} <file1> <file2>"
	FILE1=$1
	FILE2=$2

	if [ ! -z "${FILE1}" ] && [ ! -z "${FILE2}" ]; then
		DO_COMMAND="(diff -Naur ${FILE1} ${FILE2})"
		eval-it "$DO_COMMAND"
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
export FIND_PATH="."
export FIND_PRUNE_ARG="-name lost+found -prune -o"
export FIND_PRINT_ARG="-print"

function find-min()
{
	HINT="Usage: ${FUNCNAME[0]} <?min>"
	MMIN1=$1

	if [ ! -z "${MMIN1}" ]; then
		DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -mmin -${MMIN1} ${FIND_PRINT_ARG};)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function find-day()
{
	HINT="Usage: ${FUNCNAME[0]} <?day>"
	MTIME1=$1

	if [ ! -z "${MTIME1}" ]; then
		DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -mtime -${MTIME1} ${FIND_PRINT_ARG};)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function find-size()
{
	HINT="Usage: ${FUNCNAME[0]} <+?M>"
	SIZE1=$1

	if [ ! -z "${SIZE1}" ]; then
		DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -type f -size ${SIZE1} ${FIND_PRINT_ARG};)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function find-name()
{
	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1="$*"

	if [ ! -z "${FILE1}" ]; then
		for ITEM in ${FILE1}; do
		(
			DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -name ${ITEM} ${FIND_PRINT_ARG};)"
			eval-it "$DO_COMMAND"
			echo
		)
		done
	else
		echo $HINT
	fi
}

alias find123="find-name"

function find-bak()
{
	find-name *.bak
}

function find-bash_aliases()
{
	find-name .bash_aliases
}

function find-type()
{
	DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -type f ${FIND_PRINT_ARG} | xargs -n 1 file;)"
	eval-it "$DO_COMMAND"
}

function find-dup()
{
	DO_COMMAND="(find ${FIND_PATH} ${FIND_PRUNE_ARG} -type f -printf '%p -> %f\n' | sort -k2 | uniq -f1 --all-repeated=separate)"
	eval-it "$DO_COMMAND"
}

function find-path()
{
	HINT="Usage: ${FUNCNAME[0]} <path> <file>"
	PATH1=$1
	FILE2=$2

	if [ ! -z "${PATH1}" ] && [ ! -z "${FILE2}" ]; then
		DO_COMMAND="(cd ${PATH1}; find ${FIND_PATH} ${FIND_PRUNE_ARG} -name ${FILE2} ${FIND_PRINT_ARG}; cd - >/dev/null)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
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

```bash
function find-locate()
{
	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1=$1

	if [ ! -z "${FILE1}" ]; then
		DO_COMMAND="(locate ${FILE1} | grep `pwd`)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

#### which - locate a command

```bash
which find
```

# 2. Task Handler

#### fuser - identify processes using files or sockets

```bash
$ sudo umount /work
umount: /work: target is busy.

$ fuser -v /work
                     USER        PID ACCESS COMMAND
/work:               root     kernel mount /work

$ fuser -vm /work
                     USER        PID ACCESS COMMAND
/work:               root     kernel mount /work
                     lanka     11180 ..c.. bash

# 刷除佔用的 task
$ fuser -kv /work
```

#### history - GNU History Library

```bash
history
history 10

echo $HISTFILE
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
killall -SIGTERM helloworld
```

#### lsof - list open files

```bash
# 列出所有行程所開啟的檔案
sudo lsof -c sftp-server

# 列出所有開啟 /work 的行程
$ sudo lsof /work
```

```bash
function ps-lsof-pname()
{
	HINT="Usage: ${FUNCNAME[0]} <pname>"
	PNAME1=$1

	if [ ! -z "${PNAME1}" ]; then
		DO_COMMAND="(sudo lsof -c ${PNAME1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function ps-lsof-file()
{
	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1=$1

	if [ ! -z "${FILE1}" ]; then
		DO_COMMAND="(sudo lsof ${FILE1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

```bash
$ ps-lsof-pname apache2

$ ps-lsof-file /work
```

#### mkswap - set up a Linux swap area

```bash
# 初始化 /dev/sdd 為一個 swap partition
sudo mkswap /dev/sdd
```

```bash
SWAP_FILE="/work/swapfile"

# 64 MiB * 16 = 1 GB
# 64 MiB * 32 = 2 GB
# 64 MiB * 64 = 4 GB
# 64 MiB * 128 = 8 GB
sudo dd if=/dev/zero of=$SWAP_FILE bs=64M count=128
# or
sudo fallocate -l 8G ${SWAP_FILE}

sudo mkswap $SWAP_FILE
sudo chmod 0600 $SWAP_FILE
```

#### pidof -- find the process ID of a running program.

```bash
pidof helloworld
```

#### ps-pmap - report memory map of a process

```bash
function ps-pmap()
{
	HINT="Usage: ${FUNCNAME[0]} <pid>"
	PID1=$1

	if [ ! -z "${PID1}" ]; then
		DO_COMMAND="(sudo pmap -xp ${PID1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

```bash
$ ps-pmap 1102
```

#### ps - report a snapshot of the current processes.

```bash
ps -aux
ps -aux | grep helloworld | grep -v grep

ps aux --sort -%cpu
```

> `rss`：實際佔用的記憶體（KB）
>
> `vsz`：虛擬記憶體使用量（KB）

```bash
$ ps -p `pidof curl` -o pid,comm,%mem,rss,vsz
$ PS_PID=3138594
$ ps -p $PS_PID -o pid,comm,%mem,rss,vsz; cat /proc/$PS_PID/status | grep VmSwap
    PID COMMAND         %MEM   RSS    VSZ
3138594 baresip          0.8 34136 864944
VmSwap:      956 kB
```

```bash
PS_OUTPUT="pid,nlwp,%mem,%cpu,vsz,time,etime,start,cmd"
PS_OUTPUT_ARG="-o ${PS_OUTPUT}"
PS_OUTPUT_LINES="10"

function ps-args()
{
	echo "PS_OUTPUT=${PS_OUTPUT}"
	echo "PS_OUTPUT_ARG=${PS_OUTPUT_ARG}"
	echo "PS_OUTPUT_LINES=${PS_OUTPUT_LINES}"
}

function ps-sort-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <spec>"
	SPEC1=$1

	if [ ! -z "${SPEC1}" ]; then
		[ "$PS_OUTPUT_LINES" != "" ] && PS_OUTPUT_LINES_ARG="| head -n ${PS_OUTPUT_LINES}"
		DO_COMMAND="(ps -ax ${PS_OUTPUT_ARG} ${SPEC1} ${PS_OUTPUT_LINES_ARG})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function ps-sort-cpu()
{
	ps-sort-ex "--sort=-%cpu"
}

function ps-sort-mem()
{
	ps-sort-ex "--sort=-%mem"
}

function ps-sort-cpu-mem()
{
	ps-sort-ex "--sort=-%cpu,-%mem"
}

function ps-id()
{
	HINT="Usage: ${FUNCNAME[0]} <pid>"
	PID1=$1

	if [ ! -z "${PID1}" ]; then
		DO_COMMAND="(ps -p ${PID1} ${PS_OUTPUT_ARG})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function ps-name()
{
	HINT="Usage: ${FUNCNAME[0]} <name>"
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

```bash
$ ps-name VBoxClient[(ps -p 3421 -o pid,nlwp,%mem,%cpu,vsz,time,etime,start,cmd)]    PID NLWP %MEM %CPU    VSZ     TIME     ELAPSED  STARTED CMD   3421    3  0.0  0.0 157768 00:00:00       28:22 22:15:10 /usr/bin/VBoxClient --vmsvga

$ ps-sort-cpu-mem
[(ps -ax -o pid,nlwp,%mem,%cpu,vsz,time,etime,start,cmd --sort=-%cpu,-%mem | head -n 10)]
    PID NLWP %MEM %CPU    VSZ     TIME     ELAPSED  STARTED CMD
   3512    8  3.1  0.4 3856068 00:00:08      28:44 22:15:11 /usr/bin/gnome-shell
   3813    6  2.0  0.4 894180 00:00:07       28:41 22:15:14 /snap/snap-store/1113/usr/bin/snap-store --gapplication-service
   4002    5  1.2  0.2 468556 00:00:03       28:37 22:15:18 /usr/libexec/fwupd/fwupd
    939   11  0.5  0.1 1505912 00:00:03      43:16 22:00:39 /usr/bin/containerd
    820   10  0.3  0.1 1394092 00:00:03      43:17 22:00:38 /usr/lib/snapd/snapd
   2580    1  0.2  0.1 107720 00:00:03       36:38 22:07:17 /usr/sbin/smbd --foreground --no-process-group
      1    1  0.1  0.1 170560 00:00:03       43:34 22:00:21 /sbin/init splash
   3416    4  0.0  0.1 156012 00:00:03       28:45 22:15:10 /usr/bin/VBoxClient --draganddrop
   1033   30  0.9  0.0 1795580 00:00:02      43:15 22:00:40 /usr/sbin/mysqld
```

#### renice - alter priority of running processes

```bash
# ID1234, to set priority as 19
renice 19 1234

# To increase the priority of Lanka's tasks by +1.
renice +1 -u lanka
```

#### screen - screen manager with VT100/ANSI terminal emulation

> 當建立一個 ssh 連線後，想將一個 task 放入 background 執行，且不會因為 ssh 斷線而結束。
>
> 這時可以借用 screen

> [screen 使用教學](https://hackmd.io/@jimmy801/linux_screen)
>
> [GNU screen 應用手記](https://datahunter.org/screen)

```bash
$ sudo apt install -y screen
$ vi ~/.screenrc
startup_message off
vbell off

defutf8 on
defencoding utf8
encoding utf8 utf8
defscrollback 100000
defshell -bash

# sho status bar
caption always "%3n %t%? @%u%?%? [%h]%?%=%c"

$ vi ~/.bashrc
# add the last line
[ ! -z "$STY" ] && export PS1='[screen] \u@\h:\w\$ '
```

```bash
# create a screen
$ screen

# ** in a screen **
# run a task, 不建議放入background
$ task_123

# detach the screen without disturbing it
Ctrl + A, Then press D

# detach the screen then kill it
Ctrl + A, Then press K

# logout and  kill it
Ctrl + D
[screen is terminating]
```

```bash
$ screen -list
There is a screen on:
        17543.pts-1.lanka-build20-vbx      (01/08/25 09:11:24)     (Detached)
1 Socket in /run/screen/S-lanka.

# resumes a detached screen session
$ screen -r 17543.pts-1.lanka-build20-vbx
# or
$ alias screen-one="screen -r `screen -list | grep Detached | awk -F ' ' '{print $1}'`"
$ screen-one

# kill the screen session
$ screen -S 17543.pts-1.lanka-build20-vbx -X quit 
```

#### shutdown - Halt, power-off or reboot the machine

```bash
# Power-off the machine (the default).
sudo shutdown -P 20:00

# Cancel a pending shutdown.
sudo shutdown -c
```

#### swapon, swapoff - enable/disable devices and files for paging and swapping

```bash
# 啟動
$ sudo swapon /dev/sdd
$ swapon -s
Filename                                Type            Size    Used    Priority
/swapfile                               file            2097148 0       -2
/dev/sdd                                partition       134217724       0       -3

# 關閉
$ sudo swapoff /dev/sdd

$ swapon --show --bytes
NAME      TYPE              SIZE USED PRIO
/swapfile file        2147479552    0   -2
/dev/sdd  partition 137438949376    0   -3

$ swapon --show
NAME      TYPE      SIZE USED PRIO
/swapfile file        2G   0B   -2
/dev/sdd  partition 128G   0B   -3
```

```bash
sudo swapon $SWAP_FILE

sudo swapoff $SWAP_FILE
```

```bash
# 系統開機時就自動啟動
$ sudo vi /etc/fstab
/dev/sdd none swap defaults 0 0

/work/swapfile none swap sw 0 0
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
	DO_COMMAND="(df -h)"
	eval-it "$DO_COMMAND"
}
```

#### du - estimate file space usage
```bash
function free-folder()
{
	HINT="Usage: ${FUNCNAME[0]} <depth> <file>"
	DEPTH1=$1
	FILE2=$2

	if [ ! -z "${DEPTH1}" ] && [ ! -z "$FILE2" ]; then
		DO_COMMAND="(du -h --max-depth=${DEPTH1} ${FILE2})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
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
	DO_COMMAND="(lsblk -o model,name,fstype,size,label,mountpoint)"
	eval-it "$DO_COMMAND"
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
ps -aux | grep helloworld | grep -v grep

# replace ABC with 123
grep -rl 'ABC' . | xargs sed -i 's/ABC/123/g'
grep -rl 'ABC' . | xargs sed -i  's|ABC|123|g'
# 排除 .svn 目錄
grep -rl 'ABC' . --exclude-dir=.svn | xargs sed -i  's|ABC|123|g'

```

```bash
function grep-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STRING1=$1

	if [ ! -z "${STRING1}" ]; then
		DO_COMMAND="(grep --exclude-dir='.svn' --exclude-dir='.git' -nrs '${STRING1}')"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function grep-include()
{
	HINT="Usage: ${FUNCNAME[0]} <include> <string>"
	INCLUDE1=$1
	STRING2=$2

	if [ ! -z "${INCLUDE1}" ] && [ ! -z "${STRING2}" ]; then
		DO_COMMAND="(grep --exclude-dir='.svn' --exclude-dir='.git' -nrs --include=${INCLUDE1} '${STRING2}')"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

```bash
$ grep-include '*.md' grep-inc
[(grep --exclude-dir='.svn' --exclude-dir='.git' -nrs --include="*.md" 'grep-inc')]
helper_linux.md:748:function grep-include()
```

#### integer checker

```bash
[[ $ABC == ?(-)+([0-9]) ]] && echo "$ABC is an integer"
[[ $ABC == ?(-)+([:digit:]) ]] && echo "$ABC is an integer"

function is-integer()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STR1="$1"

	RE='^[+-]?[0-9]+([0-9]+)?$'
	if [ ! -z "${STR1}" ]; then
		[[ ${STR1} =~ ${RE} ]] && echo "$STR1 is an integer" && return 0
		echo "$STR1 isn't an integer" && return 1
	else
		echo $HINT
		return 1
	fi
}
```

```bash
$ is-integer "abc"; echo [$?]
abc isn't an integer
[1]
$ is-integer "1234"; echo [$?]
1234 is an integer
[0]
$ is-integer "1234.12"; echo [$?]
1234.12 isn't an integer
[1]
$ is-integer "-1234"; echo [$?]
-1234 is an integer
[0]
$ is-integer "+1234"; echo [$?]
+1234 is an integer
[0]
```

#### number checker

```bash
[ ! -z "${ABC##*[!0-9.]*}" ] && echo "is a number" || echo "is not a number";

function is-number()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STR1="$1"

	RE='^[+-]?[0-9]+([.][0-9]+)?$'
	if [ ! -z "${STR1}" ]; then
		[[ ${STR1} =~ ${RE} ]] && echo "$STR1 is an number" && return 0
		echo "$STR1 isn't an number" && return 1
	else
		echo $HINT
		return 1
	fi
}
```

```bash
$ is-number "abc"; echo [$?]
abc isn't an number
[1]
$ is-number "1234"; echo [$?]
1234 is an number
[0]
$ is-number "1234.12"; echo [$?]
1234.12 is an number
[0]
$ is-number "-1234"; echo [$?]
-1234 is an number
[0]
$ is-number "+1234"; echo [$?]
+1234 is an number
[0]
```

#### trim

```bash
ABC="    abc    "
function ltrim()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STR1="$1"

	if [ ! -z "${STR1}" ]; then
		echo "${STR1##+([[:space:]])}"
	else
		echo $HINT
	fi
}

function rtrim()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STR1="$1"

	if [ ! -z "${STR1}" ]; then
		echo "${STR1%%+([[:space:]])}"
	else
		echo $HINT
	fi
}

function trim()
{
	HINT="Usage: ${FUNCNAME[0]} <string>"
	STR1="$1"

	if [ ! -z "${STR1}" ]; then
		STR1=`ltrim "${STR1}"`
		STR1=`rtrim "${STR1}"`
		echo "${STR1}"
	else
		echo $HINT
	fi
}
```

```bash
# 其實在參數傳遞時就會移除 SPACE，如果沒有注意細節是發現不了的
$ ABC="    abc    "
$ echo [${ABC}]
[ abc ]
$ echo ["${ABC}"]
[    abc    ]

$ echo [`ltrim "${ABC}"`]
[abc ]
$ echo ["`ltrim "${ABC}"`"]
[abc    ]

$ echo [`rtrim "${ABC}"`]
[ abc]
$ echo ["`rtrim "${ABC}"`"]
[    abc]

$ echo [`trim "${ABC}"`]
[abc]
$ echo ["`trim "${ABC}"`"]
[abc]

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

# update link files
sed --follow-symlinks "s|PJ_BUILD_DIR|d" *.conf
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

> for openwrt

```bash
logread -f -e helloworld 2>/dev/null
```

#### /var/log/syslog

```bash
#alias logman-syslog="tail -f /var/log/syslog"
function logman-syslog()
{
	DO_COMMAND="(tail -f /var/log/syslog)"
	eval-it "$DO_COMMAND"
}

function logman-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <tag>"
	LOGGER_TAG=$1

	if [ ! -z "${LOGGER_TAG}" ]; then
		LOGGER_COLOR="| awk '{gsub(/\^\[/,\"\x1b\"); print}'"
		LOGREAD=`which logread`
		LOGREAD_ARG=" [ ! -z '${LOGREAD}' ] "
		[ -z "$LOGREAD" ] || LOGREAD_ARG="(logread -f -e ${LOGGER_TAG} 2>/dev/null;) || (logread -f ${LOGGER_COLOR} | grep ${LOGGER_TAG} 2>/dev/null)"
		DO_COMMAND="${LOGREAD_ARG} || (tail -f /var/log/syslog ${LOGGER_COLOR} | grep '${LOGGER_TAG}:')"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

function logman-cat()
{
	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1=$1

	if [ ! -z "$FILE1" ]; then
		LOGGER_COLOR="| awk '{gsub(/\^\[/,\"\x1b\"); print}'"

		DO_COMMAND="(cat $FILE1 ${LOGGER_COLOR})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

#### /var/log/auth.log

```bash
#alias logman-auth="tail -f -n 60 /var/log/auth.log"
function logman-auth()
{
	HINT="Usage: ${FUNCNAME[0]} <lines>"
	LINES1=$1

	if [ ! -z "${LINES1}" ]; then
		DO_COMMAND="(tail -f -n ${LINES1} /var/log/auth.log)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
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
function avahi-123()
{
	HINT="Usage: ${FUNCNAME[0]} <terminate>"
	TERMINATE1="$1"

	if [ ! -z "${TERMINATE1}" ]; then
		DO_COMMAND="(avahi-browse -r -t ${TERMINATE1})"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}

#alias avahi-hnap="avahi-browse -r -t _dhnap._tcp"
function avahi-hnap()
{
	avahi-123 _dhnap._tcp
}

#alias avahi-zwave="avahi-browse -r -t _z-wave._udp"
function avahi-zwave()
{
	avahi-123 _z-wave._udp
}

#alias avahi-hap="avahi-browse -r -t _hap._tcp"
function avahi-hap()
{
	avahi-123 _hap._tcp
}

#alias avahi-mydlink="avahi-browse -r -t _dcp._tcp"
function avahi-mydlink()
{
	avahi-123 _dcp._tcp
}

#alias avahi-http="avahi-browse -r -t _http._tcp"
function avahi-http()
{
	avahi-123 _http._tcp
}

#alias avahi-ssh="avahi-browse -r -t _ssh._tcp"
function avahi-ssh()
{
	avahi-123 _ssh._tcp
}

#alias avahi-print="avahi-browse -r -t _printer._tcp"
function avahi-print()
{
	avahi-123 _printer._tcp
}
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

```bash
function ifconfig-mac()
{
	HINT="Usage: ${FUNCNAME[0]} <iface>"
	IFACE="$1"

	if [ ! -z "$IFACE" ]; then
		MAC_ADDR=$(ifconfig $IFACE | grep 'ether' | awk -F ' ' '{print $2}' | sed s'|:||g')
		MAC_ADDR=${MAC_ADDR^^}
		echo $MAC_ADDR
	else
		echo $HINT
	fi
}
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

#### nc - arbitrary TCP and UDP connections and listens

> client and server

```bash
# server
$ nc -l -p 12345

# client
$ nc 127.0.0.1 12345
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

#### socat - Multipurpose relay (SOcket CAT)

```bash
# a TCP server, echo mode
$ socat TCP-LISTEN:12345,fork EXEC:/bin/cat
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

arp -a
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
		DO_COMMAND="(ss -tnul | grep -E 'LISTEN|UNCONN' | grep $WATCH_PORT)"
		eval-it "$DO_COMMAND"
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
> - **open|filtered**. The port state is open or filtered. Nmap cannot determine which due to network conditions.ifconfig-mac
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
$ timedatectl
               Local time: 四 2025-02-27 16:15:52 CST
           Universal time: 四 2025-02-27 08:15:52 UTC
                 RTC time: 四 2025-02-27 08:15:52
                Time zone: Asia/Taipei (CST, +0800)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no

# 列出時區
$ timedatectl list-timezones

# 設定時區 Asia/Taipei
$ sudo timedatectl set-timezone Asia/Taipei
```

# 10. Service Handler

#### journalctl - Query the systemd journal

```bash
sudo journalctl -xefu snapd

# check the last log
sudo journalctl -xe
```

```bash
function systemctl-journal()
{
	HINT="Usage: ${FUNCNAME[0]} <SERVICE>"
	SERVICE1=$1

	if [ ! -z "$SERVICE1" ]; then
		DO_COMMAND="(sudo journalctl -xefu $SERVICE1)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```

#### service - run a System V init script

> - 舊的 SysVinit 時代使用的工具。
> -  本質上只是呼叫 `/etc/init.d/<service>` 腳本。

```bash
$ service --status-all
 [ + ]  acct
 [ + ]  acpid
 [ - ]  alsa-utils
 [ - ]  anacron
 [ + ]  apache2
...

$ ll /etc/init.d/
$ service apache2 status
$ service apache2 restart
```

#### supervisor - monitor and control a number of processes on UNIX-like operating systems

> minfds: 系統可用的 **file descriptors (檔案描述符)** 數量。
>
> 對應 ulimit -n
>
> 因為每個程式可能會開 socket、pipe、log 檔，fd 不夠會導致 supervisor 自己或子進程失敗。

> minprocs: 系統允許的 **最大 process 數量**（per user process limit）。
>
> 對應 ulimit -u
>
> 避免啟動後因為 process slot ( cat /proc/sys/kernel/pid_max )不夠，spawn child 全部失敗。

```bash
$ sudo apt-get --yes install supervisor
$ pip install --upgrade supervisor
$ supervisord  --version

# 新增 group - supervisor
# 將使用者加入 supervisor
$ sudo groupadd supervisor
$ sudo usermod -aG supervisor `whoami`

# 指定 chown group - supervisor
$ sudo vi /etc/supervisor/supervisord.conf
[unix_http_server]
chmod=0770
chown=root:supervisor
[supervisord]
minfds=1048576
minprocs=1048576
[include]
files = /etc/supervisor/conf.d/*.conf /work/IoT/supervisor/*.conf

$ sudo systemctl restart supervisor

$ vi /work/IoT/supervisor/uv123.conf
[program:uv123-0001]
command=/work/rootfs/bin/uv_123
priority=10
autostart=true
autorestart=true
startretries=1
stdout_syslog=true
stderr_syslog=true

[program:uv123-0002]
command=/work/rootfs/bin/uv_123
priority=10
autostart=true
autorestart=true
startretries=1
stdout_syslog=true
stderr_syslog=true

# 重新載入
$ supervisorctl reread
$ supervisorctl update
```

#### systemctl - Control the systemd system and service manager

> - 屬於 `systemd`，現代 Linux（Ubuntu 16.04+、CentOS 7+、Debian 8+）的標準 init system。
> - 它操作的是 **unit files**（通常在 `/lib/systemd/system/` 或 `/etc/systemd/system/`）。
> - 提供更多功能（啟動順序、依賴管理、重啟策略、日誌整合…）。

```bash
systemctl list-units
systemctl is-enabled apache2.service
systemctl is-active apache2.service
systemctl restart apache2.service

systemctl status sshd
systemctl start sshd
systemctl enable sshd
systemctl disable sshd
systemctl stop sshd
systemctl kill sshd
systemctl restart sshd

systemctl cat sshd

systemctl status dbus.service
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

```bash
function systemctl-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <SERVICE> <COMMAND>"
	SERVICE1=$1
	COMMAND2=$2

	if [ ! -z "$SERVICE1" ] && [ ! -z "$COMMAND2" ]; then
		DO_COMMAND="(systemctl $COMMAND2 $SERVICE1)"
		eval-it "$DO_COMMAND"
	else
		echo [${FUNCNAME[0]} $SERVICE1 $COMMAND2]
		echo
		echo $HINT
	fi
}

function systemctl-status()
{
	HINT="Usage: ${FUNCNAME[0]} <SERVICE>"
	SERVICE1=$1

	if [ ! -z "$SERVICE1" ]; then
		systemctl-ex ${SERVICE1} is-active
		systemctl-ex ${SERVICE1} is-enabled
		systemctl-ex ${SERVICE1} is-failed
		systemctl-ex ${SERVICE1} status
	else
		echo $HINT
	fi
}

function systemctl-list()
{
	DO_COMMAND="(systemctl list-units --all)"
	eval-it "$DO_COMMAND"
}

function systemctl-help()
{
	HINT="Usage: ${FUNCNAME[0]} <SERVICE>"
	SERVICE1=$1
	[ ! -z "$SERVICE1" ] || SERVICE1="avahi-daemon"

	echo
	echo "systemctl list-units"
	echo "systemctl list-units --all"
	echo "systemctl list-units --all --state=inactive"
	echo "systemctl daemon-reload"
	echo "systemctl list-unit-files --type service -all"
	echo ""
	echo "SERVICE1=$SERVICE1"
	echo "systemctl status ${SERVICE1}.service"
	echo "systemctl is-active ${SERVICE1}.service"
	echo "systemctl is-failed ${SERVICE1}.service"
	echo "systemctl restart ${SERVICE1}.service"
	echo
}

alias systemctl-avahi="systemctl-ex avahi-daemon"
alias systemctl-cups="systemctl-ex cups"
alias systemctl-list-files="systemctl list-unit-files --type service -all"
alias systemctl-nfs="systemctl-ex nfs-kernel-server"
alias systemctl-rsyslog="systemctl-ex rsyslog"
alias systemctl-smbd="systemctl-ex smbd"
alias systemctl-ssh="systemctl-ex ssh"
alias systemctl-tftpd="systemctl-ex tftpd-hpa"
alias systemctl-vsftpd="systemctl-ex vsftpd"
alias systemctl-asterisk="systemctl-ex asterisk"
```

```bash
$ systemctl-ex snapd status
● snapd.service - Snap Daemon
     Loaded: loaded (/lib/systemd/system/snapd.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2024-08-03 06:07:45 CST; 3 days ago
TriggeredBy: ● snapd.socket
   Main PID: 33262 (snapd)
      Tasks: 11 (limit: 19077)
     Memory: 16.0M
     CGroup: /system.slice/snapd.service
             └─33262 /usr/lib/snapd/snapd
```

# 11. Debug Handler

#### valgrind - a suite of tools for debugging and profiling programs

```bash
valgrind --tool=memcheck --leak-check=full --show-reachable=yes -s ./demo_000

sudo -E valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./ir_daemon -d 2 -s /mnt -i eth0
```

```bash
function valgrind-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <prog-and-args>..."
	PROG_AND_ARGS="$*"

	#echo "PROG_AND_ARGS=$PROG_AND_ARGS"
	if [ ! -z "$PROG_AND_ARGS" ]; then
		DO_COMMAND="(valgrind --tool=memcheck --leak-check=full --show-reachable=yes -s $PROG_AND_ARGS)"
		eval-it "$DO_COMMAND"
	else
		echo $HINT
	fi
}
```
```bash
$ valgrind-ex ./demo_000
[(valgrind --tool=memcheck --leak-check=full --show-reachable=yes -s ./demo_000)]
==9900== Memcheck, a memory error detector
==9900== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==9900== Using Valgrind-3.15.0 and LibVEX; rerun with -h for copyright info
==9900== Command: ./demo_000
==9900==
[9900/9900] app_loop:46 - (TAG: demo_000, pid: 9900)
[9900/9900] app_loop:50 - (cksum: 1398)
[9900/9900] app_loop:52 - (cksum: 22044)
[9900/9900] main:156 - Bye-Bye !!!
==9900==
==9900== HEAP SUMMARY:
==9900==     in use at exit: 0 bytes in 0 blocks
==9900==   total heap usage: 1,820 allocs, 1,820 frees, 529,152 bytes allocated
==9900==
==9900== All heap blocks were freed -- no leaks are possible
==9900==
==9900== For lists of detected and suppressed errors, rerun with: -s
==9900== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
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

$ dpkg -l |grep hwe
ii  linux-generic-hwe-20.04                       5.15.0.117.127~20.04.1                      amd64        Complete Generic Linux kernel and headers
ii  linux-headers-generic-hwe-20.04               5.15.0.117.127~20.04.1                      amd64        Generic Linux kernel headers
ii  linux-hwe-5.11-headers-5.11.0-46              5.11.0-46.51~20.04.1                        all          Header files related to Linux kernel version 5.11.0
ii  linux-hwe-5.13-headers-5.13.0-52              5.13.0-52.59~20.04.1                        all          Header files related to Linux kernel version 5.13.0
ii  linux-hwe-5.15-headers-5.15.0-116             5.15.0-116.126~20.04.1                      all          Header files related to Linux kernel version 5.15.0
ii  linux-hwe-5.15-headers-5.15.0-117             5.15.0-117.127~20.04.1                      all          Header files related to Linux kernel version 5.15.0
ii  linux-hwe-5.8-headers-5.8.0-63                5.8.0-63.71~20.04.1                         all          Header files related to Linux kernel version 5.8.0
ii  linux-image-generic-hwe-20.04                 5.15.0.117.127~20.04.1                      amd64        Generic Linux kernel image
ii  virtualbox-guest-dkms-hwe                     6.1.50-dfsg-1~ubuntu1.20.04.1               all          x86 virtualization solution - guest addition module source for dkms
```

#### ldconfig - configure dynamic linker run-time bindings

```bash
$ ldconfig -p|grep libmpc
        libmpcdec.so.6 (libc6,x86-64) => /lib/x86_64-linux-gnu/libmpcdec.so.6
        libmpc.so.3 (libc6,x86-64) => /lib/x86_64-linux-gnu/libmpc.so.3
```

#### rpm - RPM Package Manager

```bash
$ sudo rpm -ivh new-package.rpm

$ sudo rpm -e mplayer

# 測試移除
$ sudo rpm -e mplayer --test

# 不管相依性
$ sudo rpm -e mplayer --nodeps
```

#### snap - Tool to interact with snaps

> 建議使用 apt-get；
>
> snapd using too much CPU 此狀況一直存在。因為不確定移除 snapd 和其安裝之套件會不會造成系統整個當機

```bash
sudo systemctl stop snapd.socket
sudo systemctl stop snapd
sudo systemctl stop snapd.seeded.service

sudo systemctl status snapd.socket
sudo systemctl status snapd
sudo systemctl status snapd.seeded.service

sudo systemctl disable snapd.socket
sudo systemctl disable snapd
sudo systemctl disable snapd.seeded.service
```

# 13. System Handler

#### free - Display amount of free and used memory in the system

> | TITLE      | DESCRIPTION                                                  |      |
> | ---------- | ------------------------------------------------------------ | ---- |
> | total      | Total installed memory (MemTotal and SwapTotal in /proc/meminfo)<br>實體的記憶體空間 |      |
> | used       | Used memory (calculated as total - free - buffers - cache)<br>已經使用的記憶體空間 |      |
> | free       | Unused memory (MemFree and SwapFree in /proc/meminfo)<br>未使用的記憶體空間 |      |
> | shared     | Memory used (mostly) by tmpfs (Shmem in /proc/meminfo)<br>共享的記憶體空間 |      |
> | buffers    | Memory used by kernel buffers (Buffers in /proc/meminfo)     |      |
> | cache      | Memory used by the page cache and slabs (Cached and SReclaimable in /proc/meminfo) |      |
> | buff/cache | Sum of buffers and cache                                     |      |
> | available  | Estimation of how much memory is available for starting new applications, without  swapping.  Unlike  the data provided by the cache or free fields, this field takes into account page cache and also that not all reclaimable memory slabs will be reclaimed due to items being  in  use  (MemAvailable  in  /proc/meminfo, available on kernels 3.14, emulated on kernels 2.6.27+, otherwise the same as free)<br>available = free + cache (可清除) |      |

```bash
$ alias free-mem="free -hwt"

$ free-mem
              total        used        free      shared     buffers       cache   available
Mem:          7.8Gi       640Mi       4.6Gi        11Mi       684Mi       1.8Gi       6.8Gi
Swap:         2.0Gi          0B       2.0Gi
Total:        9.8Gi       640Mi       6.6Gi

$ sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

$ free-mem
              total        used        free      shared     buffers       cache   available
Mem:          7.8Gi       615Mi       6.8Gi        11Mi       5.0Mi       355Mi       6.9Gi
Swap:         2.0Gi          0B       2.0Gi
Total:        9.8Gi       615Mi       8.8Gi

# 每秒刷新一次
$ free-mem -s1

$ echo 3 > /proc/sys/vm/drop_caches
```

#### htop - process manager

> [你一定用過 htop，但你有看懂每個欄位嗎？](https://medium.com/starbugs/do-you-understand-htop-ffb72b3d5629)

```bash
$ sudo snap install htop

$ sudo apt install -y htop
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

$ uname -r
5.15.0-117-generic
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

```bash
$ cat /proc/sys/vm/swappiness
60
# to set vm.swappiness to 20 until the next reboot, when it will be reset to its default value
$ sysctl vm.swappiness=20

$ sudo vi /etc/sysctl.conf
# add
vm.swappiness=20

$ sudo sysctl -p
```

#### /proc/sys/vm/drop_caches

```bash
# clear pagecache
sync; echo 1 > /proc/sys/vm/drop_caches

# clear dentries and inodes
sync; echo 2 > /proc/sys/vm/drop_caches

# clear pagecache, dentries and inodes
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

#### [/proc/[pid]/statm](/proc/[pid]/statm)

>Provides information about memory usage, measured in pages.
>
>The columns are:
>
>| Field    | Content                                                      |
>| -------- | ------------------------------------------------------------ |
>| size     | total program size (pages) <br>(same as VmSize in /proc/[pid]/status) |
>| resident | size of memory portions (pages) <br>(same as VmRSS in /proc/[pid]/status) |
>| shared   | number of pages that are shared <br>(i.e. backed by a file, same as RssFile+RssShmem in status) |
>| trs      | number of pages that are 'code' <br>(not including libs; broken, includes data segment) |
>| lrs      | number of pages of library<br>(always 0 on 2.6)              |
>| drs      | number of pages of data/stack<br>(including libs; broken, includes library text) |
>| dt       | number of dirty pages<br>(always 0 on 2.6)                   |

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

#### gzip, gunzip, zcat - compress or expand files

```bash
# decompress
gzip -d helloworld.gz
gzip -dk helloworld.gz

gunzip helloworld.gz

# compress
$ gzip -k helper_vi.md
$ ll helper_vi.md*
-rwxrwxr-x 1 lanka lanka 4155  八   6 08:15 helper_vi.md*
-rwxrwxr-x 1 lanka lanka 1872  八   6 08:15 helper_vi.md.gz*

```

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

# 18 Power Handler

#### acpi - Shows battery status and other ACPI information

```bash
$ sudo apt install acpi

$ acpi -i
Battery 0: Unknown, 78%
Battery 0: design capacity 5000 mAh, last full capacity 5000 mAh = 100%

$ acpi -iab
Battery 0: Unknown, 78%
Battery 0: design capacity 5000 mAh, last full capacity 5000 mAh = 100%
Adapter 0: on-line
```

#### upower - UPower command line tool

```bash
$ upower --dump
Device: /org/freedesktop/UPower/devices/line_power_AC
  native-path:          AC
  power supply:         yes
  updated:              廿廿四年八月二日 (週五) 七時39分十八秒 (940 seconds ago)
  has history:          no
  has statistics:       no
  line-power
    warning-level:       none
    online:              yes
    icon-name:          'ac-adapter-symbolic'

Device: /org/freedesktop/UPower/devices/battery_BAT0
  native-path:          BAT0
  vendor:               innotek
  model:                1
  serial:               0
  power supply:         yes
  updated:              廿廿四年八月二日 (週五) 七時53分十九秒 (99 seconds ago)
  has history:          yes
  has statistics:       yes
  battery
    present:             yes
    rechargeable:        yes
    state:               charging
    warning-level:       none
    energy:              39 Wh
    energy-empty:        0 Wh
    energy-full:         50 Wh
    energy-full-design:  50 Wh
    energy-rate:         0 W
    voltage:             10 V
    percentage:          78%
    capacity:            100%
    icon-name:          'battery-full-charging-symbolic'

Device: /org/freedesktop/UPower/devices/DisplayDevice
  power supply:         yes
  updated:              廿廿四年八月二日 (週五) 七時39分十八秒 (940 seconds ago)
  has history:          no
  has statistics:       no
  battery
    present:             yes
    state:               charging
    warning-level:       none
    energy:              39 Wh
    energy-full:         50 Wh
    energy-rate:         0 W
    percentage:          78%
    icon-name:          'battery-full-charging-symbolic'

Daemon:
  daemon-version:  0.99.11
  on-battery:      no
  lid-is-closed:   no
  lid-is-present:  no
  critical-action: HybridSleep
```

# 19. Others Handler

#### alias - define or display aliases

```bash
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

unalias la
```

#### command - execute a simple command

```bash
$ command -v ls
alias ls='ls --color=auto'

$ command -V ls
ls is aliased to `ls --color=auto'
```

#### locale - get locale-specific information

```bash
$ sudo vi /etc/default/locale
#  File generated by update-locale
LANG="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"

$ sudo locale-gen en_US.UTF-8
$ sudo update-locale LC_ALL=en_US.UTF-8

$ sudo update-locale LC_TIME=\"en_US.UTF-8\"
```

#### man - an interface to the system reference manuals

```bash
man ls
```

#### parallel - build and execute shell command lines from standard input in parallel

> 平行處理

```bash
$ sudo apt install -y parallel
$ seq 0 100 | parallel -j 10 '. ~/.bash_aliases; echo "==> {}"'
```

#### seq - print a sequence of numbers

```bash
$ seq 1 3
1
2
3
$ seq 1 2 10
1
3
5
7
9
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

#### type - write a description of command type

```bash
$ type ls
ls is aliased to `ls --color=auto'
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

> 請參考 [helper_vi.md](https://github.com/lankahsu520/HelperX/blob/master/helper_vi.md) - vi/vim helper.

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

# 21. Shared object

## 21.1. Object dependencies

#### file - determine file type

```bash
$ file ./libssl.so
./libssl.so: symbolic link to libssl.so.1.1

$ file /bin/curl
/bin/curl: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=96cc5c71a0343e9de8f3574c90dee265ccae1201, for GNU/Linux 3.2.0, stripped
```

#### ldd - print shared object dependencies

```bash
$ ldd ./libssl.so
./libssl.so: /lib/x86_64-linux-gnu/libcrypto.so.1.1: version `OPENSSL_1_1_1k' not found (required by ./libssl.so)
        linux-vdso.so.1 (0x00007fb5abc33000)
        libcrypto.so.1.1 => /lib/x86_64-linux-gnu/libcrypto.so.1.1 (0x00007fb5ab8a2000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fb5ab87f000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb5ab68d000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fb5ab687000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fb5abc35000)
```

#### nm - list symbols from object files

```bash
$ nm ./libssl.so
0000000000030720 t add_ca_name
000000000004ab30 t add_custom_ext_intern
000000000004acc0 t add_old_custom_ext.constprop.0
00000000000759e0 r application_traffic.23486
                 U ASN1_ANY_it@@OPENSSL_1_1_0
                 U ASN1_item_d2i@@OPENSSL_1_1_0
                 U ASN1_item_free@@OPENSSL_1_1_0
                 U ASN1_item_i2d@@OPENSSL_1_1_0
...
```

#### objdump - display information from object files

```bash
$ objdump -x ./libssl.so

$ objdump -T ./libssl.so

$ objdump -p ./libssl.so
```

#### readelf - display information about ELF files

```bash
$ readelf -d ./libssl.so

Dynamic section at offset 0x8cd40 contains 33 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libcrypto.so.1.1]
 0x0000000000000001 (NEEDED)             Shared library: [libpthread.so.0]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000e (SONAME)             Library soname: [libssl.so.1.1]
 0x0000000000000010 (SYMBOLIC)           0x0
 0x000000000000001d (RUNPATH)            Library runpath: [/work/rootfs/lib]
...
```

## 21.2. pkg-config

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
	HINT="Usage: ${FUNCNAME[0]} <file>"
	FILE1=$1

	if [ ! -z "$FILE1" ]; then
		pkg-config --list-all | grep ${FILE1}
	else
		echo $HINT
	fi
}
```

```bash
$ pkg-find openssl
openssl                             OpenSSL - Secure Sockets Layer and cryptography libraries and tools
libevent_openssl                    libevent_openssl - libevent_openssl adds openssl-based TLS support to libevent
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

```bash
$ pkg-config-ex openssl
[pkg-config --cflags openssl]

[pkg-config --libs openssl]
-lssl -lcrypto
[pkg-config --modversion openssl]
1.1.1f
[pkg-config --print-requires openssl]
libssl
libcrypto
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
function streamlink-export()
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

> [yt-dlp-youtube-oauth2](https://github.com/coletdjnz/yt-dlp-youtube-oauth2)

```bash
$ pip install --upgrade yt-dlp

#ERROR: [youtube] : Sign in to confirm you’re not a bot. This helps protect our community. Learn more
$ python3 -m pip install -U https://github.com/coletdjnz/yt-dlp-youtube-oauth2/archive/refs/heads/master.zip
```

```bash
function yt-dlp-export()
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

# 24. Application

## 24.1. Opera

```bash
$ sudo sh -c 'echo "deb [arch=amd64] https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera-stable.list'
$ wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
$ sudo apt update
$ sudo apt install -y opera-stable
```

# Appendix

# I. Study

## I.1. [Linux 教程](https://www.runoob.com/linux/linux-tutorial.html)

## I.2. [Ubuntu Linux 安裝、使用 ClamAV 防毒軟體 clamscan 掃毒指令教學與範例](https://officeguide.cc/linux-clamav-antivirus-clamscan-installation-configuration-tutorial-examples/)

## I.3. [SwapFaq](https://help.ubuntu.com/community/SwapFaq)

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
