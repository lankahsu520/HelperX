# Be An Embedded Engineer

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

# 0. 序

## 0.1. 勤作筆記

### 0.1.1. 做到那，寫到那

### 0.1.2. 失敗、錯誤也得記錄下來

### 0.1.3. Step by Step

> 邏輯要清楚，條理的記下來，雖不是寫論文，但應對要自如。

```mermaid
flowchart LR
json1([json1])
json2([json2])
json3([txt3])
json4([json4])
json5([json5])
json6([json6])
jsonA([jsonA])
cmd1[cmd1]
cmd2[cmd2]
cmd3[cmd3]
cmd4[cmd4]
cmd5[cmd5]
cmd6[cmd6]
cmdA[cmdA]

subgraph v1
  cmd1 --> json1
  cmd2 --> json2
  cmd3 --> json3
  cmdA --> jsonA
end

json1-->cmd4
json2-->cmd4
json3-->cmd5

subgraph v2
  cmd4 --> json4
	cmd5 --> json5
end

json4-->cmd6
json5-->cmd6

subgraph v3
  cmd6 --> json6
end

```

## 0.2. 善用版本控管工具

### 0.2.1. 所有記錄一定要納入版本控管

### 0.2.2. 懂得設定斷點，不用整個專案完成才上傳

## 0.3. 軟體工程師

```doc
從收到板子+SDK，

整理 codebase
進到版本控管
編譯流程
軟體開毃、測試
版本升級、發佈

```



# <span style="color:red">Week 1 - Monday </span>

> 先設置電腦開發環境

# 1. building machine 

## 1.1. Host Win10
### 1.1.1. [VirtualBox](https://www.virtualbox.org) (可選擇 VMware)

#### A.1. Disk

| TYPE            | SIZE  |
| --------------- | ----- |
| OS (/)          | 128GB |
| work (/dev/sdc) | 512GB |
| opt (/dev/sdb) | 128GB |


#### A.2. [VirtualBox 橋接網路介面](https://yuhao-kuo.github.io/blog/2017/12/26/virtualbox-bridge-network/)
#### A.3. [VPN not working on VirtualBox](https://windowsreport.com/vpn-not-working-on-virtualbox/)

### 1.1.2. 新增印表機

#### A. [網路印表機設定方式，win7/win10新增步驟手把手教學](https://www.aurora.com.tw/oa/oa-solutions/0j057402783054915831)

## 1.2. Client [ubuntu 20.04](https://www.ubuntu-tw.org/modules/tinyd0/) (建議選用 20.04)

### 1.2.1. bash，很重要，不然將來的*.sh會無法執行

```bash
/bin$ ll /bin/sh
lrwxrwxrwx 1 root root 4  九  10  2021 /bin/sh -> bash*

$ sudo chmod 777 /opt
```

### 1.2.2. SSH Server

### 1.2.3. svn & git client

```bash
$ sudo apt-get --yes install subversion-tools
$ sudo apt-get --yes install subversion
```

### 1.2.4. make , cmake, automake, autoconf, meson, ninja-build

### 1.2.5. gcc, g++ 

### 1.2.6. [Ubuntu 20.04.1安裝Samba伺服器及配置](https://www.gushiciku.cn/pl/ggev/zh-tw)

### 1.2.7. [Share files with NFS Ubuntu server and Windows 10 client](https://imperioweb.net/en/share-files-nfs-ubuntu-server-windows-10-client)

### 1.2.8. [GNU / Linux 各種壓縮與解壓縮指令](http://note.drx.tw/2008/04/command.html)

- tar.gz
- ~~zip (不要使用，因為在linux 下不符合權限管理)~~

### 1.2.9 檔案目錄

```bash
\ -> /
```

### 1.2.10. Linux 學習 1

```bash
alias
apt-get
cat
cd
chmod
chown
cp
cut
date
diff
echo
export
find
grep
ifconfig
kill
ls
man
mkdir
mount
mv
patch
ping
pwd
rm
rmdir
scp
sed
sudo
tail
tree
xargs
vi

```

- [【Linux】linux/ubuntu/mac 基礎終端機 (terminal) 指令 & 基礎知識總整理，初學者/新手 必須知道的基礎指令 & 基礎知識大全（持續更新）](https://www.wongwonggoods.com/linux/linux_basic/linux-ubuntu-terminal-basic/)
- [第十二章、學習 Shell Scripts](https://linux.vbird.org/linux_basic/centos7/0340bashshell-scripts.php)
- [Ubuntu 教學](https://www.arthurtoday.com/p/ubuntu-tutorial.html)

### 1.2.11. Linux 學習 2

```bash
avahi-browse
crontab
nslookup
service
systemctl
valgrind
```



# 2. [LambdaHello](https://github.com/lankahsu520/LambdaHello)

> 簡單的測試，看看會不會查尋檔案，找到對應的入口

## 2.1. Find Entry Function

> 找出程式進入點

```bash
??
```



# <span style="color:red">Week 2 - Monday ~ Week 4 - Friday </span>

> 這幾周最主要是建立 Cross Compile 的概念

# 3. Target

## 3.1. Raspberry Pi

> 安裝和啟動 PI

### 3.1.1. Raspberry Pi OS (ImageP)

- [Raspberry_Pi](https://jasonblog.github.io/note/raspberry_pi/index.html)



# 4. Building embedded Linux systems

## 4.1. Yocto (ImageY) 
### 4.1.1. Toolchains (ToolY)
### 4.1.2. 不要列入版本控管
```bash
builds
```

## 4.2. Buildroot (ImageB)
### 4.2.1. Toolchains  (ToolB)
### 4.2.2. 不要列入版本控管
```bash
output
```
## 4.3. OpenWRT (ImageO)

### 4.3.1. Toolchains  (ToolO)
- [Cross compiling](https://openwrt.org/docs/guide-developer/toolchain/crosscompile)
### 4.3.2. 不要列入版本控管
```bash
bin
build_dir
tmp
```



# <span style="color:red">Week 5 - Monday ~ Week 6 - Friday</span>

> 開始程式寫作，因為是 Embedded Engineer，所以用 C 為主。

# 5. HelloWorld with Toolchains (write in C)

## 5.1. 程式碼規則

```
縮排：tab (2 spaces)

不縮排：
#ifdef
#endi

{ 置前：
if 
{
}

if, while等，不使用單行表示，一定要用{}
```

## 5.2. 測試列表
|              | ubuntu | ImageP | ImageY | ImageB | ImageO |
| ------------ | ------ | ------ | ------ | ------ | ------ |
| GCC (ubuntu) | OK     | FAIL   | FAIL   | FAIL   | FAIL   |
| GCC (pi)     | FAIL   | OK     |        |        |        |
| ToolY        |        |        |        |        |        |
| ToolB        |        |        |        |        |        |
| ToolO        |        |        |        |        |        |



# 6. HelloWorld use a shared library

## 6.1. shared library - open/read/write a file



# 7. HelloWorld with Build system

## 7.1. make

## 7.2. cmake

## 7.3. meson

## 7.4. shellscript



#  8. Valgrind & HelloWorld (ubuntu only)

- [C語言的記憶體洩漏(Memory Leak)偵測 - Valgrind](http://blog.yslin.tw/2014/03/c-valgrind.html)

## 8.1. 正常操作模式

## 8.2. 修改程式，故意不free、存取未配置的記憶體空間等



# 9. HelloWorld with Exception handling (ubuntu only)

## 9.1. kill

```
SIGHUP 1 Hangup detected on controlling terminal or death of controlling process
SIGQUIT 3 Quit from keyboard
SIGKILL 9 Kill signal
SIGTERM 15 Termination signal
SIGUSR1
SIGUSR2
```

## 9.2. Catch Ctrl+C

## 9.3. exit function

#### A. [atexit](http://tw.gitbook.net/c_standard_library/c_function_atexit.html)

## 9.4. free function



# <span style="color:red">Week 7 - Monday ~ Week 7 - Friday</span>

> 加強一些網路的基本概念和應用。

# 10.  TCP client/server, thread (write in C)

## 10.1. Server*1 + Client *3

#### A. [libuv](https://github.com/libuv/libuv)



# 11. [Wireshark](https://www.wireshark.org)

## 11.1. Base 10. 監聽自己寫的Client/Server

## 11.2. A simple Web Server (any language, 自由選擇) + Browser

#### A. python

```bash
$ python -m SimpleHTTPServer

```

#### B. 其它語言

```bash

```

## 11.3. mDNS

```bash
$ avahi-browse -r -t _printer._tcp
$ avahi-browse -r -t _http._tcp
$ avahi-browse -r -t _ssh._tcp
```



# <span style="color:red">Week 8 - Monday ~ Week 8 - Friday</span>

> 針對常會使用的功能進行訓綀。
# 12. json 操作 - [jansson](https://github.com/akheron/jansson)

> 請使用此 [utilx9](https://github.com/lankahsu520/utilx9) 寫出程式碼
>
> git clone https://github.com/lankahsu520/utilx9.git

```json
{
	staff: [{
			"Last Name": "Hsu",
			"First Name": "Lanka"
		}, {
			"Last Name": "Hsu",
			"First Name": "Mary"
		}
	]
	office: {
		"GUI number": "08449449"
	}
}

請完成
add, delete, update
save to file, load from file
```

# 13. DBUS 操作 client/server (write in C)

> 請使用此 [utilx9](https://github.com/lankahsu520/utilx9) 寫出程式碼
>
> git clone https://github.com/lankahsu520/utilx9.git

```bash
# 監聽
$ sudo dbus-monitor --system
```

## 13.1. Signal

```mermaid
flowchart LR
	P-A .-> |D-Bus| P-B
	P-A .-> |D-Bus| P-C	
	P-A .-> |D-Bus| P-D
```

```mermaid
sequenceDiagram
	participant A as A
	participant B as B

	A->>B: signal, destination=(null destination) path=/com/github/lankahsu520 interface=com.github.lankahsu520 member=command<br>string "hello"
```

```c
if (payload)
{
	DBG_WN_LN("(payload: %s)", payload);
	dbusx_signal_str(dbusx_ctx_get(), DBUS_S_IFAC_YK_UP_FORMATTER_NOTIF, DBUS_S_NAME_ZIP, payload);
}
```

## 13.2. Method

```mermaid
flowchart LR
	P-A .-> |D-Bus| P-B
	P-A .-> |D-Bus| P-C	
	P-A .-> |D-Bus| P-D
```


```mermaid
sequenceDiagram
	participant A as A
	participant B as B

	A->>B: method call, destination=com.github.lankahsu520 path=/com/github/lankahsu520 interface=com.github.lankahsu520 member=command<br>string "hello"
	B->>A: method return,<br>string "Got !!!"
```

	char *msg = NULL;
	SAFE_ASPRINTF(msg, QUERY_FILENAME_SERVER_XML "?" QUERY_KEY_SETFORSCAN);
	if (msg)
	{
		char *retStr = dbusx_method_str2str(dbusx_ctx_get(), DBUS_DEST_YK_P2P_DAEMON, DBUS_M_IFAC_YK_P2P_DAEMON_COMMAND, DBUS_METHOD_COMMAND, msg, TIMEOUT_OF_DBUS_P2P);
		DBG_IF_LN("(msg: %s, retStr: %s)", msg, retStr);
		SAFE_FREE(retStr);
	
		SAFE_FREE(msg);
	}


# 14. 報告

## 14.1. 以上的項目是如何起頭，查找的方式和key word。

## 14.2. 有遇到什麼困難，解決方式。

## 14.3. 搜集回來的資料，不管對與錯，之後的處置方式，留存和出處。

## 14.4. 程式和軟體的操作。

## 14.5. 文件的建立和導讀。



# 15. Mind

## 15.1. Hardware

```mermaid
mindmap
	Platform
		Bootloader
			BIOS
				UEFI
			Uboot
		Operating system
			Windows
			Linux
			macOS
		Processor
			[32-bit]
			[64-bit]
		Endianness
			[Big-Endian]
			[Little-Endian]
		Architecture
			ARM
			MIPS
			X86
			MCU
		Connecter
			TTY
			USB
			I2C
			I2S
			GPIO
		Disk
			Flash
			SSD
			SD card
			Dual Images
```

## 15.2. Software

```mermaid
mindmap
	Platform
		SDK
		System integration
			Yocto
			Buildroot
			OpenWRT
		Language
			C, C++
			Python
			Node.js
			cargo/rustc
			Clang
		Compiler
			Cross
			Native
			[libxxx-dev]
		Build tools
			make
			cmake
			meson
			Python
			Perl
			Shell script
			Ninja
			npm
		Runtime dependency
			library

```

# Appendix

# I. Study

> 參考資料和網址

## I.1. [GitHub](https://github.com)

> 善用網路上的資源

## I.2. [GitLab](https://about.gitlab.com)

> 善用網路上的資源

## I.3. [SVN vs. Git](https://github.com/lankahsu520/HelperX/blob/master/helper_SVNvsGit.md)

> 版本控管的基本操作一定要知道，不記得上網查。但是不能不會，也不要奢望別人會教你。

```bash
$ SVN_USER=mary
$ svn co --username $SVN_USER http://xxx/xxx/$SVN_USER

# commit and push
$ svn ci

# update, pull
$ svn up

# add file(s)
$ svn add
$ svn add --no-ignore

# changed files
$ svn st -q

# not under version control
$ svn status | grep -e ^?
```

## I.4. [Byte Ordering on Big Endian and Little Endian Platforms](https://www.sfu.ca/sasdoc/sashtml/lrcon/z0920443.htm)

![endianness](./images/endianness.jpg)

# II. Debug

> 遇到的問題和解決方法

# III. Glossary 

> 專有名詞和解釋

#### EVK, Evaluation Kit

>一句話，樣品或開發板。
>
>[ChatGPT]
>
>"EVK" 是 "Evaluation Kit"（評估套件）的縮寫。評估套件是一種硬體和軟體組合，旨在協助開發人員、工程師或製造商評估、測試和開發新的硬體或軟體產品。EVK 可能包含特定硬體設備、開發板、擴展模組、軟體工具和文檔，以協助使用者在特定領域或應用中進行評估和開發。
>
>EVK 的主要用途包括：
>
>1. **產品評估：** 開發人員可以使用 EVK 來評估新的硬體或軟體產品的性能、功能和適用性。這有助於決定是否值得進一步開發和生產該產品。
>2. **原型開發：** EVK 可用於快速原型開發。開發人員可以使用提供的硬體和軟體工具來建立概念驗證原型。
>3. **驅動程式開發：** 如果 EVK 包含特定的硬體設備，開發人員可以使用它來開發硬體驅動程式或軟體應用程式，以支援這些設備。
>4. **性能測試：** EVK 可用於進行性能測試和基準測試，以確保硬體或軟體在特定工作條件下運行正常。
>5. **教育和培訓：** 學術機構、培訓機構和工程團隊可以使用 EVK 來教授和培訓人員，使他們熟悉特定技術或產品。
>6. **開發環境：** EVK 提供了一個開發環境，開發人員可以在其中編寫、測試和調試軟體代碼。
>
>EVK 可能用於各種不同的應用，包括嵌入式系統、物聯網（IoT）設備、通訊設備、半導體元件和軟體開發。它們通常由硬體或軟體供應商提供，以幫助客戶評估並開發相關產品。 EVK 在簡化開發過程、節省時間和成本方面發揮重要作用。

#### HDK, Hardware Development Kit

> 一句話，就是協助硬體工程師開發的資源和工具。
>
> [ChatGPT]
>
> Hardware Development Kit（硬體開發套件，縮寫為HDK）是一種工具套件，用於協助硬體工程師和製造商設計、開發和測試硬體產品。這些套件通常包括一系列的硬體和軟體資源，以協助開發人員在硬體領域中進行評估、原型開發和產品製造。
>
> 以下是一些硬體開發套件（HDK）的常見特點和元件：
>
> 1. **原型板（Development Board）：** HDK 可能包含特定用途的原型板，這些原型板通常設計用於測試硬體電路和元件。它們提供了一個實驗室，允許工程師快速測試和驗證他們的硬體設計。
> 2. **電子元件：** HDK 可能提供各種電子元件，如處理器、儲存器、傳感器、連接器等，這些元件可以用於構建原型和硬體設計。
> 3. **設計工具：** HDK 包括用於硬體設計的軟體工具，如電路設計軟體、布局工具、原理圖軟體等，這些工具有助於設計硬體電路。
> 4. **軟體支援：** 有時 HDK 包括與硬體相關的軟體支援，例如驅動程式、示例程式碼、操作系統映像等，以協助開發人員編寫和測試軟體。
> 5. **文檔：** HDK 提供了詳細的技術文檔、用戶指南和參考資料，以幫助工程師了解和使用硬體套件。
> 6. **示例項目：** HDK 可能包括示例項目或應用程式，以展示如何使用硬體和軟體資源來實現特定功能。
>
> HDK 的目標是簡化和加速硬體產品的開發過程，並確保它們符合特定的要求和標準。這些套件通常由硬體製造商、半導體公司或硬體設計公司提供，以協助客戶設計和開發各種硬體產品，包括嵌入式系統、通訊設備、儀器儀表、消費電子產品等。

#### SDK, Software Development Kit

>一句話，就是協助軟體工程師開發的資源和工具。
>
>[ChatGPT]
>
>SDK 是 "Software Development Kit"（軟體開發工具包）的縮寫，它是一組工具、函式庫、文檔和示例程式碼的集合，用於協助軟體開發人員創建特定平台、框架或應用程式的軟體。SDK 旨在簡化和加速軟體開發過程，提供必要的資源和工具，以便開發人員可以有效地設計、開發和測試軟體。
>
>以下是 SDK 的一些常見特點和用途：
>
>1. **函式庫和 API：** SDK 包含函式庫和應用程式編程介面（API），使開發人員可以訪問特定平台或框架的功能。這些函式庫和 API 提供了一組預先定義的函數和類，可以用於實現特定任務。
>2. **開發工具：** SDK 包括用於編譯、除錯和測試代碼的工具，如編譯器、集成開發環境（IDE）、模擬器和調試器。
>3. **示例程式碼：** SDK 提供示例程式碼，開發人員可以參考這些範例來了解如何使用 SDK 中的功能。
>4. **文檔和教程：** SDK 通常包括詳細的技術文檔、API 文件和教程，以幫助開發人員學習如何使用 SDK 中的工具和資源。
>5. **模擬和測試環境：** 一些 SDK 包括模擬和測試環境，讓開發人員可以在模擬的環境中測試應用程式，而無需實際硬體或軟體。
>6. **支援多平台：** 一些 SDK 設計為支援多個操作系統或硬體平台，使開發人員能夠跨平台開發應用程式。
>
>SDK 可以用於各種不同的應用，包括移動應用程式開發、網頁開發、遊戲開發、嵌入式系統開發、物聯網（IoT）應用程式開發等。它們通常由平台或框架的提供者提供，以協助開發人員在特定環境中創建高質量的軟體。

# IV. Tool Usage

> 相關執行程式的參數

## IV.1. 編輯器 c, c++, etc 

### IV.1.1. [Notepad++](https://notepad-plus-plus.org/downloads/v8.3.3/)

- [Notepad++ Plugins JSON viewer for Javascript](https://pclevin.blogspot.com/2018/01/notepad-plugins-json-viewer-for.html)

### IV.1.2. [Source Insight](https://www.sourceinsight.com)

## IV.2. 比較軟體 merge
- [Code Compare](https://www.devart.com/codecompare/?utm_medium=application&utm_campaign=fromapp_CodeCompare&utm_source=AboutForm)

## IV.3. SSH Client
- [MobaXterm](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjRqOOJpO_2AhWFyIsBHaptD80QFnoECBcQAQ&url=https%3A%2F%2Fmobaxterm.mobatek.net%2Fdownload.html&usg=AOvVaw1KdgWg-XLXLUD5WTdf0WWV)

## IV.4. Markdown

- [Typora — a markdown editor, markdown reader.](https://typora.io/)
- [typora 画流程图、时序图(顺序图)、甘特图](https://www.runoob.com/note/47651)
- [About Mermaid](https://mermaid-js.github.io/mermaid/#/?id=about-mermaid)

## IV.5. [DIVVY](https://mizage.com/windivvy/) - 分割視窗

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
