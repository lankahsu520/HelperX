# [Trac](https://trac.edgewall.org)
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

> 用於管理 Git、SVN Repository 等。
>
> <font color="red">有試過在 Ubuntu 20.04 以後的版本安裝過，始終沒有成功過！最終停在 Ubuntu 18.04。最主要的原因是支援的 Python 版本過舊。</font>

> [ChatGPT] Trac 是什麼
>
> - **Trac** 是一個開源、輕量級的 **專案管理與缺陷追蹤系統（Issue Tracker / Project Management Tool）**，最初是為軟體專案設計的。它同時整合了 **版本控制瀏覽、Wiki、Timeline**，適合需要簡單、直接管理程式碼專案的團隊。
>  
> ------
> 
>  ## 📌 主要特色
> 
>  | 功能                       | 說明                                                         |
>   | -------------------------- | ------------------------------------------------------------ |
>   | **版本控制整合**           | 支援 SVN、Git，可瀏覽程式碼、檢視歷史紀錄、Diff              |
>   | **Timeline / Activity**    | 顯示專案所有事件（Issue、提交紀錄、Wiki 變更）               |
>   | **Wiki**                   | 每個專案可建立 Wiki，方便文件化專案資訊                      |
>   | **Issue Tracker / Ticket** | 缺陷追蹤、任務分配、優先級、狀態流程                         |
>   | **多專案管理**             | 雖然不是多專案平台，但可以透過多個 Trac 獨立實例管理多個專案 |
>   | **簡單界面**               | UI 非常簡單、輕量，無需大量資源                              |
>   | **插件擴充**               | 支援多種插件，例如報表、時間追蹤、甘特圖等                   |
> 
> ------
> 
>   ## 📌 適合的使用場景
> 
>   - 使用 **SVN / Git** 並希望輕量管理專案
>   - 需要 **Timeline / Issue / Wiki** 功能，但不需要大型整合平台
>  - 對 UI 不介意簡單、偏向文字導向的操作
>   - 希望快速部署，低維護成本
>
> ------
>
>   ## 📌 Trac 的限制
> 
>   - 對 **多 SCM 系統整合**不如 Allura 或 Redmine 完整
>  - UI 比較老舊，現代感不足
>   - 不適合大型多專案、多人管理的複雜環境
>  - 需要手動安裝或配置插件來支援 Gantt / 日曆等進階功能

# 2. Trac

```mermaid
flowchart LR
	subgraph Host[Host - Ubuntu 18.04]
		subgraph Trac[Trac<br>/work/trac]
		
		end
	end

```

> Trac 1.4
>
> - [Python](https://www.python.org/), version ≥ 2.7 and < 3.0 (note that we dropped the support for Python 2.6 in this release)
> - [setuptools](https://pypi.org/project/setuptools), version ≥ 0.6
> - [Jinja2](https://pypi.org/project/Jinja2), version ≥ 2.9.3

> Trac 1.5
>
> - [Python](https://www.python.org/), version >= 3.5
> - [setuptools](https://pypi.org/project/setuptools), version > 5.6
> - [Jinja2](https://pypi.org/project/Jinja2), version >= 2.9.3

## 2.1. Install

### 2.1.1. Step by Step

> 大致的命令如下，適用於
>
>  Ubuntu 18.04 LTS
>
> Python 2.7
>
> Trac 1.2.4

#### A. initenv

```bash
$ sudo apt-get install trac
$ pip install multipart

#** 設定安裝環境 **
$ export MYPROJECT_TRACDIR=/work/trac
$ export MYPROJECT_ADMIN=lanka

$ trac-admin $MYPROJECT_TRACDIR initenv

#** 設定目錄 Owner & 讀寫權限 **
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/conf
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/db
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/htdocs
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/log
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/plugins
sudo cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/templates
```

#### B. authz

```bash
#** 新增使用者帳號 **
$ htpasswd -c $MYPROJECT_TRACDIR/.htpasswd $MYPROJECT_ADMIN
$ cat $MYPROJECT_TRACDIR/conf/.htpasswd

#** 設定管理者帳號 **
$ trac-admin $MYPROJECT_TRACDIR permission add $MYPROJECT_ADMIN TRAC_ADMIN

$ sudo vi $MYPROJECT_TRACDIR/conf/authz
[groups]
administrators = lanka
developers = lanka
newbie = mary
releaser = lanka
viewers =

[svnxbox:/]
@administrators = rw
@developers =
@newbie =
@releaser =
@viewers =

[svnopt:/]
@administrators = rw
@developers =
@newbie =
@releaser =
@viewers =

[gitroot:/]
@administrators = rw
@developers =
@newbie =
@releaser =
@viewers =
```

#### C. [Plugin](https://trac.edgewall.org/wiki/PluginList)

```bash
#** Plugin **
# 這裏就會失敗
sudo easy_install https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.5.0
sudo easy_install https://trac-hacks.org/svn/tracwysiwygplugin/0.12
sudo easy_install https://trac-hacks.org/svn/svnauthzadminplugin/1.0
sudo easy_install https://trac-hacks.org/svn/markdownmacro/trunk

# 改用 python setup.py
PJ_PYTHON_BIN=python
PJ_PYTHON_VER=2.7

svn co https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.5.0 /tmp/acct_mgr \
    && cd /tmp/acct_mgr && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python${PJ_PYTHON_VER}/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

svn co https://trac-hacks.org/svn/tracwysiwygplugin/0.12 /tmp/tracwysiwygplugin \
    && cd /tmp/tracwysiwygplugin && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python${PJ_PYTHON_VER}/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

svn co https://trac-hacks.org/svn/svnauthzadminplugin/1.0 /tmp/svnauthzadminplugin \
    && cd /tmp/svnauthzadminplugin && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python${PJ_PYTHON_VER}/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

```

#### D. trac.ini

```bash
$ sudo vi $MYPROJECT_TRACDIR/conf/trac.ini

[ticket]
restrict_owner = enabled

[account-manager]
force_passwd_change = true
htpasswd_file = /work/trac/conf/.htpasswd
htpasswd_hash_type = crypt
#password_file = /work/svn/conf/passwd
#password_format = htpasswd
#password_store = SvnServePasswordStore
password_file = /work/trac/.htpasswd
password_store = HtPasswdStore
Password_format = htpasswd
persistent_sessions = False
refresh_passwd = False
verify_email = False

[components]
tracopt.ticket.deleter = enabled
tracwysiwyg.wysiwygmodule = enabled
acct_mgr.admin.accountmanageradminpanel = enabled
acct_mgr.api.accountmanager = enabled
acct_mgr.guard.accountguard = enabled
acct_mgr.htfile.htpasswdstore = enabled
acct_mgr.macros.accountmanagerwikimacros = enabled
acct_mgr.notification.accountchangelistener = enabled
acct_mgr.notification.accountchangenotificationadminpanel = enabled
acct_mgr.pwhash.htdigesthashmethod = enabled
acct_mgr.pwhash.htpasswdhashmethod = enabled
acct_mgr.register.basiccheck = enabled
acct_mgr.register.bottrapcheck = enabled
acct_mgr.register.emailcheck = enabled
acct_mgr.register.emailverificationmodule = enabled
acct_mgr.register.regexpcheck = enabled
acct_mgr.register.registrationmodule = enabled
acct_mgr.register.usernamepermcheck = enabled
acct_mgr.svnserve.svnservepasswordstore = enabled
acct_mgr.web_ui.accountmodule = enabled
acct_mgr.web_ui.resetpwstore = enabled

# 如果要使用apache 的登入方式，請將下面兩項對調
acct_mgr.web_ui.loginmodule = enabled
trac.web.auth.loginmodule = disabled

$ sudo chown -R www-data: $MYPROJECT_TRACDIR
$ sudo chmod -R 775 $MYPROJECT_TRACDIR
```

#### E. Apache - trac.conf

```bash
$ sudo vi /etc/apache2/sites-available/trac.conf

	<Location /trac>
		SetHandler mod_python
		PythonInterpreter main_interpreter
		PythonHandler trac.web.modpython_frontend
		PythonOption TracEnv /work/trac
		PythonOption TracEnvParentDir /work/trac
		PythonOption TracUriRoot /trac
		# PythonOption TracEnvIndexTemplate /work/trac/templates/index-template.html
		PythonOption TracLocale en_US.UTF8
		PythonOption PYTHON_EGG_CACHE /tmp
		PythonDebug on
		Order allow,deny
		Allow from all
	</Location>

$ sudo vi /etc/apache2/ports.conf
# 設定 port

#** 啟動 **
$ sudo apt-get install libapache2-mod-python
$ sudo a2enmod python

# enable Apache mod_env, mod_cgi, mod_alias, mod_rewrite, ... modules
$ sudo a2enmod env cgi alias rewrite dav dav_fs

# enable the trac site configuration
$ sudo a2ensite trac.conf
$ sudo service apache2 restart

$ service apache2 reload
```

### 2.1.2. Install  trac with docker

#### A. Check Files

```bash
$ tree -L 3 Docker-trac/
Docker-trac/
├── compose
│   ├── dbusX.conf
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── supervisord.conf
│   └── trac_banner.png
├── conf
│   ├── authz
│   ├── org
│   │   ├── trac.ini
│   │   └── trac.ini.sample
│   ├── trac.ini
│   └── trac.ini.sample
├── repositories
│   └── svn-create-repo.sh
└── sites-available
    ├── svn.conf
    └── trac.conf

5 directories, 13 files
```

#### B. Build and Run

> 會用到的參數有
>
> MYPROJECT_ADMIN: lanka
> MYPROJECT_ADMIN_PASS: 123456
> MYPROJECT_TRACDIR: /var/trac
> MYPROJECT_NAME: lanka520

```bash
$ cd Docker-trac/compose
$ docker compose up -d --build
$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
trac520      latest    1e1ca31269c9   5 seconds ago   611MB

$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
a8509207be1d   trac520   "/usr/bin/supervisor…"   18 seconds ago   Up 16 seconds   0.0.0.0:9981->80/tcp, :::9981->80/tcp   hello-trac
```

#### C. Create an SVN repostory

> 這邊建議進入 container 後再建立，因為有 db 版本的問題

```bash
$ docker exec -it hello-trac /bin/bash

root@a8509207be1d:/# REPO_NAME=svn123
root@a8509207be1d:/# cd /var/trac/repositories; ./svn-create-repo.sh $REPO_NAME
root@a8509207be1d:/var/trac/repositories# tree -L 2 ./
./
├── svn123
│   ├── conf
│   ├── db
│   ├── format
│   ├── hooks
│   ├── locks
│   └── README.txt
└── svn-create-repo.sh

5 directories, 3 files
```

```bash
cat /var/log/apache2/access.log
cat /var/log/apache2/error.log
```

## 2.6. Showtime

> http://127.0.0.1:80/trac

> 如果用 Docker
>
> http://127.0.0.1:9981/trac

<img src="./images/VCS-Trac0001.png" alt="VCS-Trac0001" style="zoom: 50%;" />

### 2.6.1. Log

```bash
cat /var/trac/log/trac.log

cat /var/log/apache2/access.log
cat /var/log/apache2/error.log

```

### 2.6.2. trac-admin

```bash
trac-admin /var/trac repository list

trac-admin /var/trac repository add svn123 /var/trac/repositories/svn123 svn
trac-admin /var/trac repository resync 'svn123'

```

### 2.6.3. docker

```bash
docker compose up -d --build

docker exec -it hello-trac /bin/bash

docker-stopall; docker-rmexited; sleep 1; docker-rmimage trac520
```



# 3. Repositories

```mermaid
flowchart LR
	subgraph Host[Host - Ubuntu 18.04]
		Trac[Trac<br>/work/trac]

		svnopt[svnopt - /work_svnopt/svnopt]

		svnxbox[svnxbox - /work_xbox/svnxbox]
		
		gitroot[gitroot - /work_gitroot/gitroot.git]
	end

```

## 3.1. Add Repositories

#### A. trac.ini

```bash
$ sudo vi /work/trac/conf/trac.ini
[repositories]
.alias = svnxbox
.sync_per_request = true

svnxbox.dir = /work_xbox/svnxbox/
svnxbox.hidden = false
svnxbox.sync_per_request = true
svnxbox.type = svn
svnxbox.url = http://127.0.0.1/svnxbox

svnopt.dir = /work_svnopt/svnopt
svnopt.hidden = false
svnopt.sync_per_request = true
svnopt.type = svn
svnopt.url = http://127.0.0.1/svnopt
```

#### B. Apache - svn.conf

```bash
$ sudo vi /etc/apache2/sites-available/svn.conf
<Location /svnxbox>
  DAV svn
  SVNPath /work_xbox/svnxbox
  AuthType Basic
  AuthName "SVN Repository - /svnxbox"
  AuthUserFile /work/trac/.htpasswd
  AuthzSVNAccessFile /work/trac/conf/authz
  Require valid-user
</Location>
<Location /svnopt>
  DAV svn
  SVNPath /work_svnopt/svnopt
  AuthType Basic
  AuthName "SVN Repository - /svnopt"
  AuthUserFile /work/trac/.htpasswd
  AuthzSVNAccessFile /work/trac/conf/authz
  Require valid-user
</Location>
```

#### C. Apache - git.conf

```bash
$ sudo vi /etc/apache2/sites-available/git.conf
SetEnv GIT_PROJECT_ROOT /work_gitroot
SetEnv GIT_HTTP_EXPORT_ALL

ScriptAlias /gitroot /usr/lib/git-core/git-http-backend/

Alias /gitroot /work_gitroot
<Directory /usr/lib/git-core>
  Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
  AllowOverride None
  Require all granted
</Directory>
<Directory /work_gitroot>
  Options Indexes FollowSymLinks MultiViews
  AllowOverride None
  Require all granted
</Directory>

<Location /gitroot/gitroot.git>
  AuthType Basic
  AuthName "Git Repository - /gitroot"
  #AuthUserFile /work_gitroot/authz
  AuthUserFile /work/trac/.htpasswd
  Require valid-user
</Location>
```

## 3.2. Download Repositories

```bash
# svn
$ svn co http://127.0.0.1/svnopt

# git
$ git clone http://127.0.0.1/gitroot/gitroot.git
```

# Footnote

[^1]:
[^2]:

# Appendix

# I. Study

# II. Debug

## II.1. ubuntu 18.04

```bash
sudo apt-get install python-setuptools

#sudo apt-get install python python-babel
sudo apt-get install trac

#sudo easy_install Trac
#sudo easy_install Babel

ubuntu 16 -> 18時會出現錯誤
https://trac.edgewall.org/wiki/TracUpgrade#UpdatetheTracCode
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python-setuptools
sudo apt-get install python-pip

E: You must put some 'deb-src' URIs in your sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt update

sudo apt-get remove libapache2-mod-python libapache2-mod-wsgi
sudo apt-get build-dep libapache2-mod-python libapache2-mod-wsgi
```

## II.2. Trac Upgrade

```bash
sudo pip install --upgrade Trac
sudo trac-admin /work/trac upgrade
sudo trac-admin /work/trac wiki upgrade
```

## II.3. repository resync

```bash
sudo trac-admin /work/trac repository resync 'svnxbox'
sudo trac-admin /work/trac repository resync 'svnopt'

sudo service apache2 restart
```

## II.4. ModuleNotFoundError: No module named 'svn'

```bash
cat /var/trac/log/trac.log

$ apt-get install -y python-subversion
apt-get install -y libapache2-mod-wsgi-py3

apt-cache search svn | grep python3
apt-get install -y python3-svn
apt-get install -y python3-vcstools


python3 - <<'EOF'
from svn import fs, repos, core, delta
print("SVN Python bindings OK:", core.SVN_VER_MAJOR, core.SVN_VER_MINOR)
EOF
```



# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

