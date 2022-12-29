# [Yocto](https://www.yoctoproject.org)
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

# 1.  [Yocto Project](https://www.yoctoproject.org/software-overview/)

## 1.1. [Yocto計劃](https://zh.m.wikipedia.org/zh-tw/Yocto計劃)

> Yocto計畫主要由三個元件組成：
>
> BitBake：讀取組態檔與處方檔（recipes)並執行，組態與建置所指定的應用程式或者系統檔案映像檔。
>
> OpenEmbedded-Core：由基礎layers所組成，並為處方檔（recipes)，layers與classes的集合：這些要素都是在OpenEmbedded系統中共享使用的。
>
> Poky：是一個參考系統。是許多案子與工具的集合，用來讓使用者延伸出新的發行版（Distribution)

## 1.2. 使用心得

>編譯很花時間，至少2小時（手邊是有intel i9-11980HK）以上 ~ 1天 or 2天都有可能。
>
>很佔空間，至少要留個100G。
>
>還有你要先決定 Poky要抓那一版本（branch 和 rev），相對應的 meta-openembedded 和硬體相依性比較高的 meta-raspberrypi 你也要決定版本（branch 和 rev）。就算所有需要的軟體都集齊了，最後也編譯完了，最後能不能開機也是問題！
>
>如果你不是晶片供應商（如聯發科），而只是一位 embedded engineer，聯發科領多少錢，而我們領不到他們的一半，甚至連破百萬都沒有；卻要幫他們組一包可以編譯的環境，這情何以堪。
>
>BB 的語法太靈活，shellscript 的支援度不高；我們寫程式的時間都不夠了，還要學習這奇怪的語法。
>
>在編譯時一定要上網！就算你已經編譯成功，而且已經下載過，還是會報失敗。
>
>yocto 的版本變動很快，或許今年允許的 class 或語法，明年就不能用了。就連google 大神也救不了，因為新的東西，還要等有心人把踩到的狗屎寫出來。

# 2. bb helper

## 2.1. utils - [layers/poky/bitbake/lib/bb/utils.py](layers/poky/bitbake/lib/bb/utils.py)

#### def contains(variable, checkvalues, truevalue, falsevalue, d):

```bb
"""Check if a variable contains all the values specified.

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'x11', '${X11DEPENDS}', '', d)}"

PACKAGECONFIG = "${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11', '', d)}"

ENDIANNESS_GCC = "${@bb.utils.contains("LE_UBOOT_FOR_ARMBE_TARGET", "1", "-mlittle-endian", "", d)}"
ENDIANNESS_LD = "${@bb.utils.contains("LE_UBOOT_FOR_ARMBE_TARGET", "1", "-EL", "", d)}"

CFLAGS += "${@bb.utils.contains('SELECTED_OPTIMIZATION', '-Og', '-DXXH_NO_INLINE_HINTS', '', d)}"

```

#### def filter(variable, checkvalues, d):

```bb
"""Return all words in the variable that are present in the checkvalues.

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'x11', d)}"

```

# 2. Others

## 2.1. BB_ENV_EXTRAWHITE

```bb
ERROR: Variable BB_ENV_EXTRAWHITE has been renamed to BB_ENV_PASSTHROUGH_ADDITIONS
ERROR: Variable BB_ENV_EXTRAWHITE from the shell environment has been renamed to BB_ENV_PASSTHROUGH_ADDITIONS
ERROR: Exiting to allow enviroment variables to be corrected

```

## 2.2. [BB_ENV_PASSTHROUGH_ADDITIONS](https://docs.yoctoproject.org/bitbake/dev/bitbake-user-manual/bitbake-user-manual-ref-variables.html#term-BB_ENV_PASSTHROUGH_ADDITIONS)

```mermaid
flowchart LR
	ubuntu[ubuntu env]
	yocto[yocto env]

	ubuntu --> |BB_ENV_PASSTHROUGH_ADDITIONS| yocto

```

```bb
BB_ENV_PASSTHROUGH_ADDITIONS="ALL_PROXY BBPATH_EXTRA BB_LOGCONFIG BB_NO_NETWORK BB_NUMBER_THREADS BB_SETSCENE_ENFORCE BB_SRCREV_POLICY DISTRO FTPS_PROXY FTP_PROXY GIT_PROXY_COMMAND HTTPS_PROXY HTTP_PROXY MACHINE NO_PROXY PARALLEL_MAKE SCREENDIR SDKMACHINE SOCKS5_PASSWD SOCKS5_USER SSH_AGENT_PID SSH_AUTH_SOCK STAMPS_DIR TCLIBC TCMODE all_proxy ftp_proxy ftps_proxy http_proxy https_proxy no_proxy"

```

```bash
$ export BB_EXTRA_SRCREV="AUTOINC"
$ export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} BB_EXTRA_SRCREV"

```

```bb
SRCREV = "${@bb.utils.contains('BB_EXTRA_SRCREV','AUTOINC','${AUTOREV}','${SRCREV_RELEASE}',d)}"

or

SRCREV = "${@'${AUTOREV}' if d.getVar('BB_EXTRA_SRCREV', 'AUTOINC') \
         else '${SRCREV_RELEASE}'}"
```

# Appendix

# I. Study

#### A. [Yocto計劃](https://zh.m.wikipedia.org/zh-tw/Yocto計劃)

# II. Debug


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

