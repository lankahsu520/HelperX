# [Python](https://www.python.org)
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

>Python 很好用的程式語言。
>
>此篇不討論如何撰寫 Python 的程式，而是當使用或變動系統的 Python 時，可能發生的問題。

> [維基百科](https://zh.wikipedia.org/zh-tw/Python) **Python**（英國發音：[/ˈpaɪθən/](https://zh.wikipedia.org/wiki/Help:英語國際音標)；美國發音：[/ˈpaɪθɑːn/](https://zh.wikipedia.org/wiki/Help:英語國際音標)），是一種廣泛使用的[直譯式](https://zh.wikipedia.org/wiki/直譯語言)、[進階](https://zh.wikipedia.org/wiki/高級語言)和[通用](https://zh.wikipedia.org/wiki/通用编程语言)的[程式語言](https://zh.wikipedia.org/wiki/编程语言)。Python支援多種程式設計範式，包括結構化、程序式、反射式、物件導向和函數式程式設計。它擁有[動態型別系統](https://zh.wikipedia.org/wiki/類型系統)和[垃圾回收](https://zh.wikipedia.org/wiki/垃圾回收_(計算機科學))功能，能夠自動管理記憶體使用，並且其本身擁有一個巨大而廣泛的標準庫。它的語言結構以及[物件導向](https://zh.wikipedia.org/wiki/面向对象程序设计)的方法，旨在幫助程式設計師為小型的和大型的專案編寫邏輯清晰的程式碼。

# 2. Normal Install

> python3 & pip3 需要共生共存，兩邊的版本要一致。

```bash
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.6 LTS
Release:        20.04
Codename:       focal
```

```bash
$ sudo apt update
$ sudo apt upgrade

# install default version
$ sudo apt install -y python3
$ sudo apt install -y python3-dev

$ sudo apt install python3-venv

# install pip3
$ sudo apt install -y python3-pip

```

# 3. Check python

```bash
$ python3 --version
Python 3.8.10

$ pip3 --version
pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)

$ virtualenv --version
virtualenv 20.24.7 from /home/lanka/.local/lib/python3.8/site-packages/virtualenv/__init__.py

```

```bash
$ which python3
/usr/bin/python3

$ ll /usr/bin/*python3*
-rwxr-xr-x 1 root root     387  三   4  2020 /usr/bin/ipython3*
lrwxrwxrwx 1 root root       9  七  14  2022 /usr/bin/python3 -> python3.8*
-rwxr-xr-x 1 root root 5494584  五  26  2023 /usr/bin/python3.8*
lrwxrwxrwx 1 root root      33  五  26  2023 /usr/bin/python3.8-config -> x86_64-linux-gnu-python3.8-config*
lrwxrwxrwx 1 root root      16  三  13  2020 /usr/bin/python3-config -> python3.8-config*
-rwxr-xr-x 1 root root     384  一  25  2023 /usr/bin/python3-futurize*
-rwxr-xr-x 1 root root     388  一  25  2023 /usr/bin/python3-pasteurize*
-rwxr-xr-x 1 root root    1797  八   6  2019 /usr/bin/python3-unidiff*
-rwxr-xr-x 1 root root    3241  五  26  2023 /usr/bin/x86_64-linux-gnu-python3.8-config*
lrwxrwxrwx 1 root root      33  三  13  2020 /usr/bin/x86_64-linux-gnu-python3-config -> x86_64-linux-gnu-python3.8-config*
```

# 4. Upgrade python

> 當系統已經安裝很多的 packages 後，<font color="red">不建議升級系統的 python</font>，因為
>
> a. python 本身的變動性很大，常存在<font color="red">向下不相容</font>。
>
> b. python 套件和 python 的版本過度相依。
>
> c. python 套件的開發很快，但是生命週期也短。有可能 3.8 還存在，但是之後就不再更新。
>
> d. python 套件本身引用過多的套件時，當一個套件升級失敗就有可能造成整個系統混亂。
>
> e. /usr/lib/python3/dist-packages 裏的更新問題。
>
> f. 更改 python 後 pip3 有可能不能用。

>但是事情總是要解決，建議參考使用 Virtual Environment。

## 4.1. Add apt-repository

```bash
$ sudo apt update
$ sudo apt -y upgrade

$ sudo apt install -y software-properties-common

$ sudo add-apt-repository ppa:deadsnakes/ppa

```

## 4.2. Upgrade

### 4.2.1. Install Special Version

```bash
$ sudo apt install -y python3.12

# 建議留下來，不要移除
$ sudo apt remove -y python3.8

```

```bash
# upgrade pip3
$ pip3 install --upgrade pip
# or
$ python3 -m pip install --upgrade pip

# upgrade setup tools
$ pip3 install wheel setuptools pip --upgrade
```
- Fail

```bash
# Please don't do these
$ sudo apt remove --purge python3-apt
$ sudo apt autoclean
$ sudo apt install -y python3-apt
$ sudo apt install -y python3.12-distutils
$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
$ sudo python3.12 get-pip.py
```

### 4.2.2. Use update-alternatives

> 這邊使用 update-alternatives 進行系統調整。

```bash
# 3.8.10 -> 3.12
$ sudo update-alternatives --config python3
update-alternatives: error: no alternatives for python3

# --install <link> <name> <path> <priority>
$ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
$ sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

$ sudo update-alternatives --config python3
There are 2 choices for the alternative python3 (providing /usr/bin/python3).

  Selection    Path                 Priority   Status
------------------------------------------------------------
  0            /usr/bin/python3.8    2         auto mode
  1            /usr/bin/python3.12   1         manual mode
* 2            /usr/bin/python3.8    2         manual mode

Press <enter> to keep the current choice[*], or type selection number:1

# or
$ sudo update-alternatives --set python3 /usr/bin/python3.12
```

```bash
# to check again
$ ll /usr/bin/*python3*
```

# 5. Run on Virtual Environment

>建立一個獨立的開發環境，如前章節有提到，現有能穩定執行的套件，不見得匹配最新的的 python3。
>

## 5.1. Create A Virtual Environment

```bash
# install python3 Virtual Environment
$ pip3 install virtualenv
```
#### A. 3.12

```bash
$ sudo apt install -y python3.12
$ which python3.12
/usr/bin/python3.12

$ mkdir -p /work/bin/python/3.12
$ cd /work/bin/python/3.12; virtualenv --python=python3.12 .
$ cd /work/bin/python/3.12; tree -L 2 ./
./
├── bin
│   ├── activate
│   ├── activate.csh
│   ├── activate.fish
│   ├── activate.nu
│   ├── activate.ps1
│   ├── activate_this.py
│   ├── pip
│   ├── pip3
│   ├── pip-3.12
│   ├── pip3.12
│   ├── python -> /usr/bin/python3.12
│   ├── python3 -> python
│   └── python3.12 -> python
├── lib
│   └── python3.12
└── pyvenv.cfg

3 directories, 14 files

```
#### b. 3.9

```bash
$ sudo apt install -y python3.9
$ which python3.9
/usr/bin/python3.9

$ mkdir -p /work/bin/python/3.9
$ cd /work/bin/python/3.9; virtualenv --python=python3.9 .
$ cd /work/bin/python/3.9; tree -L 2 ./
./
├── bin
│   ├── activate
│   ├── activate.csh
│   ├── activate.fish
│   ├── activate.nu
│   ├── activate.ps1
│   ├── activate_this.py
│   ├── pip
│   ├── pip3
│   ├── pip-3.9
│   ├── pip3.9
│   ├── python -> /usr/bin/python3.9
│   ├── python3 -> python
│   ├── python3.9 -> python
│   ├── wheel
│   ├── wheel3
│   ├── wheel-3.9
│   └── wheel3.9
├── lib
│   └── python3.9
└── pyvenv.cfg

3 directories, 18 files

```


## 5.2. Enter Virtual Environment

```bash
$ . /work/bin/python/3.12/bin/activate
(3.12) $ pip3 list
Package Version
------- -------
pip     23.3.1

```

><font color="red">環境變數將會被影響</font>
>
>PS1="(3.12) \\[\\e]0;\\u@\\h: \\w\\a\\]\${debian_chroot:+(\$debian_chroot)}\\u@\\h:\\w\\\$ "
>
>PATH="/work/python/3.12/bin:/home/lanka/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
>
>VIRTUAL_ENV="/work/python/3.12"
>
>VIRTUAL_ENV_PROMPT="3.12"

#### A. 3.12

```bash
$ python --version
Python 3.12.0
$ pip3 --version
pip 23.3.1 from /work/bin/python/3.12/lib/python3.12/site-packages/pip (python 3.12)

```

## 5.3. Leave Virtual Environment

```bash
(3.12) $ deactivate

```

# 6. Run with PYTHONPATH

## 6.1. Install requirements.txt

```bash
$ export PYTHON_LIB=`pwd`
$ pip3 install --target ${PYTHON_LIB}/python -r requirements.txt
```

- requirements.txt

```bash
$ cat requirements.txt
boto3==1.26.123

#https://pypi.org/project/netifaces/
netifaces==0.11.0

```

## 6.2. Run

```bash
$ PYTHONPATH=${PYTHON_LIB}/python ./helloworld
```

# 7. pip3

- [PyPI – the Python Package Index · PyPI](https://pypi.org)

## 7.1. Install packages

```bash
$ pip3 install markdown

# for special version
$ pip3 install meson==1.3.0

$ pip3 list
Package  Version
-------- -------
Markdown 3.5.1
meson    1.3.0
pip      23.3.1

$ cmake --version
cmake version 3.16.3

```

## 7.2. Upgrade packages

#### A. outdated

```bash
# list the outdated packages
$ pip3 list -o

# upgrade all of the outdated packages
$ pip3 list -o | cut -f1 -d' ' | xargs -n1 pip3 install -U
```
#### B.  uninstall

```bash
$ pip3 uninstall meson
```

#### C. upgrade

```bash
$ pip3 install --upgrade meson
$ pip3 install --upgrade markdown
$ pip3 install --upgrade cmake
```

# 8. Packages

> 列出常用的
>
> [PyPI – the Python Package Index · PyPI](https://pypi.org)

#### -  [boto3](https://pypi.org/project/boto3/)
>AWS SDK，看關操作請見 [awsP9](https://github.com/lankahsu520/awsP9)
>
> [PyPi]  Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for Python, which allows Python developers to write software that makes use of services like Amazon S3 and Amazon EC2. You can find the latest, most up to date, documentation at our doc site, including a list of services that are supported.

#### -  [cmake](https://pypi.org/project/cmake/)

>一個構建工具，看關操作請見 [makeXcmakeXmesonXgn](https://github.com/lankahsu520/makeXcmakeXmesonXgn)
>
>[PyPi]  [CMake](http://www.cmake.org/) is used to control the software compilation process using simple platform and compiler independent configuration files, and generate native makefiles and workspaces that can be used in the compiler environment of your choice.
>
>The suite of CMake tools were created by Kitware in response to the need for a powerful, cross-platform build environment for open-source projects such as ITK and VTK.

#### -  [meson](https://pypi.org/project/meson/)

> 一個構建工具，看關操作請見 [makeXcmakeXmesonXgn](https://github.com/lankahsu520/makeXcmakeXmesonXgn)
>
> [PyPi] Meson is a cross-platform build system designed to be both as fast and as user friendly as possible. It supports many languages and compilers, including GCC, Clang, PGI, Intel, and Visual Studio. Its build definitions are written in a simple non-Turing complete DSL

#### -  [ninja](https://pypi.org/project/ninja/)

> 一個構建工具，看關操作請見 [makeXcmakeXmesonXgn](https://github.com/lankahsu520/makeXcmakeXmesonXgn)
>
> [PyPi]  [Ninja](http://www.ninja-build.org/) is a small build system with a focus on speed.

# Appendix

# I. Study

# II. Debug

## II.1. g-ir-scanner ... distutils.errors.DistutilsExecError: command '-I/work/codebase/xbox/xbox_123/install/ubuntu/include' failed with exit status 1 

> 網路上找不到合適的解決方式，不過 g-ir-scanner 非必須，先移除之。

```bash
$ g-ir-scanner --version
g-ir-scanner 1.64.1

$ sudo apt remove gobject-introspection

$ g-ir-scanner --version
Command 'g-ir-scanner' not found, but can be installed with:

sudo apt install gobject-introspection

```

## II.2. ImportError: cannot import name 'six' from 'pkg_resources.extern' (/usr/lib/python3/dist-packages/pkg_resources/extern/__init__.py)

>pip3 和 python3 版本要匹配。

```bash
$ pip3 --version
Traceback (most recent call last):
  File "/usr/bin/pip3", line 6, in <module>
    from pkg_resources import load_entry_point
  File "/usr/lib/python3/dist-packages/pkg_resources/__init__.py", line 57, in <module>
    from pkg_resources.extern import six
ImportError: cannot import name 'six' from 'pkg_resources.extern' (/usr/lib/python3/dist-packages/pkg_resources/extern/__init__.py)

```

# III. Glossary

# IV. Tool Usage

## IV.1. virtualenv Usage

```bash
$ virtualenv --help
usage: virtualenv [--version] [--with-traceback] [-v | -q] [--read-only-app-data] [--app-data APP_DATA] [--reset-app-data] [--upgrade-embed-wheels] [--discovery {builtin}] [-p py] [--try-first-with py_exe]
                  [--creator {builtin,cpython3-posix,venv}] [--seeder {app-data,pip}] [--no-seed] [--activators comma_sep_list] [--clear] [--no-vcs-ignore] [--system-site-packages] [--symlinks | --copies] [--no-download | --download]
                  [--extra-search-dir d [d ...]] [--pip version] [--setuptools version] [--wheel version] [--no-pip] [--no-setuptools] [--no-wheel] [--no-periodic-update] [--symlink-app-data] [--prompt prompt] [-h]
                  dest

optional arguments:
  --version                     display the version of the virtualenv package and its location, then exit
  --with-traceback              on failure also display the stacktrace internals of virtualenv (default: False)
  --read-only-app-data          use app data folder in read-only mode (write operations will fail with error) (default: False)
  --app-data APP_DATA           a data folder used as cache by the virtualenv (default: /home/lanka/.local/share/virtualenv)
  --reset-app-data              start with empty app data folder (default: False)
  --upgrade-embed-wheels        trigger a manual update of the embedded wheels (default: False)
  -h, --help                    show this help message and exit

verbosity:
  verbosity = verbose - quiet, default INFO, mapping => CRITICAL=0, ERROR=1, WARNING=2, INFO=3, DEBUG=4, NOTSET=5

  -v, --verbose                 increase verbosity (default: 2)
  -q, --quiet                   decrease verbosity (default: 0)

discovery:
  discover and provide a target interpreter

  --discovery {builtin}         interpreter discovery method (default: builtin)
  -p py, --python py            interpreter based on what to create environment (path/identifier) - by default use the interpreter where the tool is installed - first found wins (default: [])
  --try-first-with py_exe       try first these interpreters before starting the discovery (default: [])

creator:
  options for creator builtin

  --creator {builtin,cpython3-posix,venv}
                                create environment via (builtin = cpython3-posix) (default: builtin)
  dest                          directory to create virtualenv at
  --clear                       remove the destination directory if exist before starting (will overwrite files otherwise) (default: False)
  --no-vcs-ignore               don't create VCS ignore directive in the destination directory (default: False)
  --system-site-packages        give the virtual environment access to the system site-packages dir (default: False)
  --symlinks                    try to use symlinks rather than copies, when symlinks are not the default for the platform (default: True)
  --copies, --always-copy       try to use copies rather than symlinks, even when symlinks are the default for the platform (default: False)

seeder:
  options for seeder app-data

  --seeder {app-data,pip}       seed packages install method (default: app-data)
  --no-seed, --without-pip      do not install seed packages (default: False)
  --no-download, --never-download
                                pass to disable download of the latest pip/setuptools/wheel from PyPI (default: True)
  --download                    pass to enable download of the latest pip/setuptools/wheel from PyPI (default: False)
  --extra-search-dir d [d ...]  a path containing wheels to extend the internal wheel list (can be set 1+ times) (default: [])
  --pip version                 version of pip to install as seed: embed, bundle, none or exact version (default: bundle)
  --setuptools version          version of setuptools to install as seed: embed, bundle, none or exact version (default: bundle)
  --wheel version               version of wheel to install as seed: embed, bundle, none or exact version (default: bundle)
  --no-pip                      do not install pip (default: False)
  --no-setuptools               do not install setuptools (default: False)
  --no-wheel                    do not install wheel (default: False)
  --no-periodic-update          disable the periodic (once every 14 days) update of the embedded wheels (default: False)
  --symlink-app-data            symlink the python packages from the app-data folder (requires seed pip>=19.3) (default: False)

activators:
  options for activation scripts

  --activators comma_sep_list   activators to generate - default is all supported (default: bash,cshell,fish,nushell,powershell,python)
  --prompt prompt               provides an alternative prompt prefix for this environment (value of . means name of the current working directory) (default: None)

config file /home/lanka/.config/virtualenv/virtualenv.ini missing (change via env var VIRTUALENV_CONFIG_FILE)

```

## IV.2. update-alternatives Usage

```bash
$ update-alternatives --help
Usage: update-alternatives [<option> ...] <command>

Commands:
  --install <link> <name> <path> <priority>
    [--slave <link> <name> <path>] ...
                           add a group of alternatives to the system.
  --remove <name> <path>   remove <path> from the <name> group alternative.
  --remove-all <name>      remove <name> group from the alternatives system.
  --auto <name>            switch the master link <name> to automatic mode.
  --display <name>         display information about the <name> group.
  --query <name>           machine parseable version of --display <name>.
  --list <name>            display all targets of the <name> group.
  --get-selections         list master alternative names and their status.
  --set-selections         read alternative status from standard input.
  --config <name>          show alternatives for the <name> group and ask the
                           user to select which one to use.
  --set <name> <path>      set <path> as alternative for <name>.
  --all                    call --config on all alternatives.

<link> is the symlink pointing to /etc/alternatives/<name>.
  (e.g. /usr/bin/pager)
<name> is the master name for this link group.
  (e.g. pager)
<path> is the location of one of the alternative target files.
  (e.g. /usr/bin/less)
<priority> is an integer; options with higher numbers have higher priority in
  automatic mode.

Options:
  --altdir <directory>     change the alternatives directory.
  --admindir <directory>   change the administrative directory.
  --log <file>             change the log file.
  --force                  allow replacing files with alternative links.
  --skip-auto              skip prompt for alternatives correctly configured
                           in automatic mode (relevant for --config only)
  --quiet                  quiet operation, minimal output.
  --verbose                verbose operation, more output.
  --debug                  debug output, way more output.
  --help                   show this help message.
  --version                show the version.
  
```

## IV.3. pip3 Usage

```bash
$ pip3 --help

Usage:
  pip3 <command> [options]

Commands:
  install                     Install packages.
  download                    Download packages.
  uninstall                   Uninstall packages.
  freeze                      Output installed packages in requirements format.
  list                        List installed packages.
  show                        Show information about installed packages.
  check                       Verify installed packages have compatible dependencies.
  config                      Manage local and global configuration.
  search                      Search PyPI for packages.
  wheel                       Build wheels from your requirements.
  hash                        Compute hashes of package archives.
  completion                  A helper command used for command completion.
  debug                       Show information useful for debugging.
  help                        Show help for commands.

General Options:
  -h, --help                  Show help.
  --isolated                  Run pip in an isolated mode, ignoring environment variables and user configuration.
  -v, --verbose               Give more output. Option is additive, and can be used up to 3 times.
  -V, --version               Show version and exit.
  -q, --quiet                 Give less output. Option is additive, and can be used up to 3 times (corresponding to WARNING, ERROR, and CRITICAL logging levels).
  --log <path>                Path to a verbose appending log.
  --proxy <proxy>             Specify a proxy in the form [user:passwd@]proxy.server:port.
  --retries <retries>         Maximum number of retries each connection should attempt (default 5 times).
  --timeout <sec>             Set the socket timeout (default 15 seconds).
  --exists-action <action>    Default action when a path already exists: (s)witch, (i)gnore, (w)ipe, (b)ackup, (a)bort.
  --trusted-host <hostname>   Mark this host or host:port pair as trusted, even though it does not have valid or any HTTPS.
  --cert <path>               Path to alternate CA bundle.
  --client-cert <path>        Path to SSL client certificate, a single file containing the private key and the certificate in PEM format.
  --cache-dir <dir>           Store the cache data in <dir>.
  --no-cache-dir              Disable the cache.
  --disable-pip-version-check
                              Don't periodically check PyPI to determine whether a new version of pip is available for download. Implied with --no-index.
  --no-color                  Suppress colored output
  --no-python-version-warning
                              Silence deprecation warnings for upcoming unsupported Pythons.

```

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

