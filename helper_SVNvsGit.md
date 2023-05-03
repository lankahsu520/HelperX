# SVN vs. Git
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

# 1. Repository

#### svn

```mermaid
flowchart LR
	subgraph Local
		SVN-Tracked[SVN Tracked]
		SVN-Untracked[SVN Untracked]
	end
	subgraph Remote
		SVN-Remote[SVN Remote Repository]
	end
	SVN-Tracked --> |ci|SVN-Remote
	SVN-Remote --> |up|SVN-Tracked
	SVN-Remote --> |co|SVN-Tracked
	
	SVN-Untracked --> |add|SVN-Tracked
	SVN-Tracked --> |revert|SVN-Tracked
	SVN-Tracked --> |revert|SVN-Untracked
```
> SVN：沒有所謂的 Local Repository。需要一個 SVN Server 擺放 Repository。
```bash
# to set the default editor
$ export SVN_EDITOR=vim
```

#### git

```mermaid
flowchart LR
	subgraph Local
		Git-Local[Git Local Repository]
		Git-Staging[Git Staging]
		Git-Working[Git Working]

		Git-Untracked[Git Untracked]
	end
	subgraph Remote
		Git-Remote[Git Remote Repository]
	end

	Git-Untracked --> |add|Git-Staging
	Git-Staging --> |restore / restore --staged| Git-Untracked

	Git-Working --> |add|Git-Staging
	Git-Staging --> |restore / restore --staged| Git-Working
	
	Git-Staging --> |commit|Git-Local
  Git-Local --> |push|Git-Remote
	Git-Remote --> |pull|Git-Local
  Git-Remote --> |clone|Git-Local
```
> Git：分別存在 Remote Repository 和 Local Repository。
```bash
$ git config –global user.name "name"
$ git config –global user.email "email address"

$ git config --global user.email "lankahsu@gmail.com"
$ git config --global user.name "Lanka Hsu"


# Create an empty Git repository or reinitialize an existing one
$ mkdir HelloWorld
$ cd HelloWorld
$ git init

# to set the default editor
$ export GIT_EDITOR=vim

$ git config --global core.editor "vim"

```

## 1.1. Branch

#### svn cp

> svn 基本上沒有 git branch 的概念，那要如何實作相同的功能，就用不同目錄來代表。如 svnroot/trunk/xbox、svnroot/brancees/xbox-b1。
>
> 也因此 svn 可以擷取單一目錄，不用抓取整個 repository，也因此省下不少時間！
>
> 

#### git branch

```bash
# the current
$ git branch

# list all
$ git branch -a
$ git branch -r

# delete
$ git branch -d new-branch
# force to delete
$ git branch -D new-branch
# rename
$ git branch -m new-branch new-branch1
```

#### git checkout
```bash
# List all branch
$ git branch -a

# switch to new-branch (exist)
$ git checkout new-branch

# create branch
$ git checkout -b new-branch
$ git checkout -b new-branch origin

# List all tag
$ git tag
# switch to tag
$ git checkout 1.0.0
# switch back
$ git switch -
```

#### git switch

```bash
$ git switch -c hardknott remotes/origin/hardknott
```

## 1.2. Tag

#### svn cp

> svn 基本上沒有 git tag 的概念，那要如何實作相同的功能，就用不同目錄來代表。如 svnroot/trunk/xbox、svnroot/tags/xbox-v1。
>
> 也因此 svn 可以擷取單一目錄，不用抓取整個 repository，也因此省下不少時間！
>
> 另外因為是不同目錄代表，所以可以繼續延伸開發。不像 Git tag 在定錨後就不能進版。

#### git tag

```bash
# Create, list, delete or verify a tag object signed with GPG
# list
$ git tag

# create
$ git tag -a v1.1.0
$ git push origin v1.1.0

# delete
$ git tag -d v1.1.0
$ git push --delete origin v1.1.0

```
## 1.3. Git Local Repository

```bash
#** 四個狀態 **
Untracked files

Working directory
	Changes not staged for commit
		$ git checkout -- *
Staging area
	Changes to be committed
		$ git reset
Repository
	Committed
		$ git reset --hard HEAD
```

### 注意！注意！注意！

> 從上可以知道 Git 有四個狀態，感覺上管理的很有制度，但是如果 Working <--> Staging 變動過多，就算只有“你”一位修改人員，之後 commit、push 和 pull時，也會發生衝突！
>
> 所以要小心！再小心！

> 另外 Git 使用中有所謂的 Index，這個反而會讓使用者有困擾。
>
> 我們應該把事情簡單化，將 Git 的使用方式同化為  SVN Tracked 和 SVN Untracked。

# 2. General Commands

## 2.1. Clone a repository into a new directory

#### svn co

```bash
$ svn co http://trac-vbx/svnroot/trunk/xbox xbox-123

# to get the special folder - test 
$ svn co http://trac-vbx/svnroot/trunk/xbox/test xbox-test

# with username
$ svn co --username lanka http://trac-vbx/svnroot/trunk/xbox/test
```

#### git clone

```bash
$ git clone http://trac-vbx/gitroot/xbox xbox-123
$ git clone --recurse-submodules http://trac-vbx/gitroot/xbox xbox-456

# to get the special branch - test
$ git clone -b test http://trac-vbx/gitroot/xbox xbox-test

```

## 2.2. Record changes to the repository

#### svn ci

```bash
$ svn ci ./
or
$ svn commit ./
```

#### git commit and git push

```bash
$ git commit ./
# Update remote refs along with associated objects.
$ git push ./

# 不建議使用，要就一起上，Not pushed + most recent commit
git commit --amend ./s

```

## 2.3. Fetch from and integrate with another repository or a local branch

#### svn up

```bash
$ svn up
```

#### git pull

```bash
$ git pull
```

## 2.4. Add file contents to the index

#### svn add

```bash
$ svn add helloworld.c
```

#### git add

```bash
$ git add helloworld.c
```

## 2.5. Remove files from the working tree and from the index

#### svn rm

```bash
$ svn rm helloworld.c
```

#### git rm

```bash
$ git rm helloworld.c
```

## 2.6. Move an item in a working copy

#### svn mv

```bash
$ svn mv helloworld.c helloworld_bak.c
```

#### git mv

```bash
$ git mv helloworld.c helloworld_bak.c
```

## 2.7. Copy files and directories in a working copy or repository

#### svn cp

```bash
$ svn cp helloworld.c helloworld_cp.c
```

#### git ??

```bash
```

# 3. Show difference, log

## 3.1. Show the working tree status

#### svn status

```bash
$ svn status

# don't print unversioned items
$ svn st -q

# disregard default and svn:ignore and svn:global-ignores property ignores
$ svn status --no-ignore
```

#### git status

```bash
$ git status
```

## 3.2. Show changes between commits, commit and working tree

#### svn diff

```bash
$ svn diff

# show history
$ svn diff -r2600
```

#### git diff

```bash
$ git diff
```

#### git show

```bash
$ git show

# show history
$ git show HEAD
$ git show 366aace
```

## 3.3. Show commit logs

#### svn log

```bash
$ svn log | more
```

#### git log

```bash
$ git log
$ git log --oneline
```

## 3.4. Ignore Files

#### svn:ignore

```bash
$ svn propedit svn:ignore .
# enter your ignore files
```

#### svn:global-ignores
```bash
$ svn propedit svn:global-ignores .
# 測試過好像沒什麼效果
```

#### .gitignore

```bash
$ touch .gitignore
$ vi .gitignore
# enter your ignore files
```

# 4. Advanced Commands

## 4.1. Restore working tree files

#### svn revert

```mermaid
flowchart LR
	SVN-Untracked --> |add|SVN-Tracked 
	SVN-Tracked  --> |revert|SVN-Tracked
	SVN-Tracked  --> |revert|SVN-Untracked
```

```bash
$ svn revert helloworld_cp.c 
```

#### git restore or ? checkout

```mermaid
flowchart LR
	subgraph Local
		Git-Staging[Git Staging]
		Git-Working[Git Working]

		Git-Untracked[Git Untracked]
	end

	Git-Untracked --> |add|Git-Staging
	Git-Staging --> |restore / restore --staged| Git-Untracked

	Git-Working --> |add|Git-Staging
	Git-Staging --> |restore / restore --staged| Git-Working

```

```bash
$ git restore helloworld_cp.c
$ git restore --staged helloworld_cp.c

$ git checkout -- *
```

## 4.2. Manage set of tracked repositories (change the url of repositorie)

#### svn relocate

```bash
# to check the repository root URL 
$ svn info

$ svn relocate http://trac-vbx/svnroot/trunk/xbox
```

#### svn switch

```bash
# to check the repository root URL 
$ svn info

$ svn switch http://trac-vbx/svnroot/trunk/xbox
```

#### git remote

```bash
# to check the repository root name
$ git remote
origin

# to check the repository root URL
$ git remote -v

$ git remote set-url origin http://trac-vbx/gitroot/xbox
```

## 4.3. Roll back

```mermaid
flowchart LR

	121 --> 122 --> 123 --> 124
	124 --> |Roll back|123
```

#### svn merge

```bash
# Undo a committed change
SVN_LAST=`svn info 2>/dev/null | grep 'Last Changed Rev' | cut -d':' -f2 | awk '{print $1}'`
svn merge -c -${SVN_LAST} .

svn ci ./
```

#### git reset

```bash
$ git reset --hard xxxxxx
$ git reset --hard ORIG_HEAD

# back 2*committed
$ git reset HEAD^^

# back 3*committed
$ git reset HEAD~3

$ git push -f
```

## 4.4. Merge
```mermaid
flowchart LR

	subgraph master
		M119 --> M121--> M122 --> M123 --> M124 --> M126
	end
	subgraph curr
		B120 --> B125 --> B???
	end
	M119--> B120
	M121 --> B???
	M122 --> B???
	M123 --> B???
	M124 --> B???
```
```mermaid
flowchart LR

	subgraph master
		M119 --> M121--> M122 --> M123 --> M124 --> M126
	end
	subgraph curr
		B120 --> B125 --> B???
	end
	M119--> B120

	M122 --> B???

```
#### svn merge


```bash
# Merge a range of changes
$ svn merge -r 121:124 http://trac-vbx/svnroot/trunk/xbox ./
$ svn ci ./
```


```bash
# Merge one specific change
$ svn merge -c 122 ./
$ svn ci ./
```

```bash
# Remove svn:mergeinfo
$ svn propget svn:mergeinfo --depth=infinity | grep -v "^/" | grep -v "^\." | cut -d- -f1 | xargs svn propdel svn:mergeinfo

$ svn ci ./
```

#### git merge

```bash
$ git checkout curr
Switched to branch 'curr'

# master -> curr
$ git merge master
# 儘量使用這個，可保留分支線形，比較好閱讀
$ git merge --no-ff master
```
```bash
# Merge one specific change
$ git cherry-pick 122
```

## 4.5. Show what revision and author last modified each line of a file

#### svn blame


```bash
$ svn blame helper_SVNvsGit.md
```

#### git blame

```bash
$ git blame helper_SVNvsGit.md
```

# 5. Server with apache2

## 5.1. apache2

#### A. sites-available/*.conf

```bash
# enable the svn site configuration
$ sudo vi /etc/apache2/sites-available/svn.conf
$ sudo a2ensite svn.conf

$ sudo htpasswd -c /work_svnroot/.htpasswd lanka

# enable the git site configuration
$ sudo vi /etc/apache2/sites-available/git.conf
$ sudo a2ensite git.conf

$ sudo htpasswd -c /work_gitroot/.htpasswd lanka

# apache2 reload
$ systemctl reload apache2

```

##### A.1. [git.conf](./SVNvsGit/git.conf)

```conf
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
	#<LocationMatch /gitroot/.*\.git>
	#	Dav On
	#	AuthType Basic
	#	AuthName "Git Verification"
	#	AuthUserFile /work_gitroot/authz
	#	Require valid-user
	#</LocationMatch>

	<Location /gitroot/gitroot.git>
		AuthType Basic
		AuthName "Git Repository - /gitroot"
		AuthUserFile /work_gitroot/.htpasswd
		Require valid-user
	</Location>
```

##### A.2. [svn.conf](./SVNvsGit/svn.conf)

```conf
	<Location /svnroot>
		DAV svn
		SVNPath /work_svnroot/svnroot
		AuthType Basic
		AuthName "SVN Repository - /svnroot"
		AuthUserFile /work_svnroot/.htpasswd
		AuthzSVNAccessFile /work_svnroot/authz
		Require valid-user
	</Location>
```

#### B. ports.conf

```bash
$ sudo vi /etc/apache2/ports.conf
```

#### C. enable Apache modules

```bash
$ sudo apt-get install libapache2-mod-python
$ sudo a2enmod python

# enable Apache mod_env, mod_cgi, mod_alias, mod_rewrite, ... modules
$ sudo a2enmod env cgi alias rewrite dav dav_svn dav_fs

```

#### D. restart apache2

```bash
$ sudo service apache2 restart
```

## 5.2. Git Server

#### A. Add User and Group

```bash
$ sudo addgroup git
$ sudo usermod -G git -a www-data
$ sudo usermod -G git -a lanka
```

#### B. Create Repository - [git-create-repo.sh](./SVNvsGit/git-create-repo.sh)

```bash
$ cd /work_gitroot
$ ./git-create-repo.sh gitroot.git
$ ll
drwxrwxr-x  7 www-data git    4096 十一 28 14:56 gitroot.git/

# Please make sure group is git
```

#### C.  git clone

```bash
$ git clone http://trac-vbx/gitroot/gitroot.git

# save the specified Git credentials in the “.git/config”
$ git config credential.helper store
```

## 5.3. SVN Server

#### A. Add User and Group

```bash
$ sudo addgroup subversion
$ sudo usermod -G subversion -a www-data
$ sudo usermod -G subversion -a lanka
```

#### B. Create Repository - [svn-create-repo.sh](./SVNvsGit/svn-create-repo.sh)

```bash
$ cd /work_svnroot
$ ./svn-create-repo.sh svnroot
$ ll
drwxrwxr-x  7 www-data www-data 4096 十一 28 17:05 svnroot/

```

#### C. Authz

```bash
$ sudo vi /work_svnroot/authz
```

```authz
[groups]
administrators = lanka
developers = lanka
releaser = lanka
viewers =

[/]
@administrators = rw
@developers =
@releaser =
@viewers =

[svnroot:/]
@administrators = rw
@developers = rw
@releaser =
@viewers =
```

#### D.  svn co

```bash
$ svn co http://trac-vbx/svnroot
$ svn co --username lanka http://trac-vbx/svnpi
```

# 6. Special

## 6.1. SVN

#### A. [Chapter 4. Branching and Merging](https://svnbook.red-bean.com/en/1.7/svn.branchmerge.summary.html)

```mermaid
flowchart LR
	subgraph svn
			svn_xbox[trunk/xbox]
			svn_beex[trunk/beex]
			svn_utilx9[trunk/utilx9]
	end

	subgraph svnnew-include
			svnnew_xbox[trunk/xbox]	
	end

	svn --> |include-trunk/xbox|svnnew-include
	subgraph svnnew-exclude
			svnnew_beex[trunk/beex]
			svnnew_utilx9[trunk/utilx9]
	end

	svn --> |exclude-trunk/xbox|svnnew-exclude

```

```bash
$ ls -al 
drwxrwxrwx 12 lanka    lanka            4096  八  22 13:18 ./
drwxr-xr-x 30 root     root             4096  八  12 06:19 ../
drwx------  2 root     root            16384  一   6  2021 lost+found/
drwxrwxrwx  6 www-data www-data         4096  一   3  2019 svn/
-rwxrwxr-x  1 lanka    lanka           52072  八  22 13:16 svndumpsanitizer*

```

##### A.1. **[svndumpsanitizer](https://github.com/dsuni/svndumpsanitizer)**

```bash
$ git clone https://github.com/dsuni/svndumpsanitizer.git
$ cd svndumpsanitizer
$ gcc svndumpsanitizer.c -o svndumpsanitizer
$ ./svndumpsanitizer --help
```

##### A.2. generate history

###### A.2.1. dump 

```bash
export SVN_NAME_SRC=svn
export SVN_DUMP_SOURCE_FILE="./dump_svn_20220822"

svnadmin dump $SVN_NAME_SRC > $SVN_DUMP_SOURCE_FILE
```

###### A.2.2. filter

```bash
export SVN_DUMP_FILTER=""
export SVN_DUMP_FILTER="$SVN_DUMP_FILTER trunk/xbox"

```

###### A.2.3. include/exclude

```bash
export SVN_DUMP_FILTER_FILE_INCLUDE="./dump_svn_20220822include"

./svndumpsanitizer \
	--infile $SVN_DUMP_SOURCE_FILE \
	--outfile $SVN_DUMP_FILTER_FILE_INCLUDE \
	--include $SVN_DUMP_FILTER \
	--drop-empty

```

```bash
export SVN_DUMP_FILTER_FILE_EXCLUDE="./dump_svn_20220822exclude"

./svndumpsanitizer \
	--infile $SVN_DUMP_SOURCE_FILE \
	--outfile $SVN_DUMP_FILTER_FILE_EXCLUDE \
	--exclude $SVN_DUMP_FILTER \
	--drop-empty

```

##### A.3. create new repository

###### A.3.1. include

```mermaid
flowchart LR
	subgraph svn
			svn_xbox[trunk/xbox]
			svn_beex[trunk/beex]
			svn_utilx9[trunk/utilx9]
	end

	subgraph svnnew-include
			svnnew_xbox[trunk/xbox]	
	end

	svn --> |include-trunk/xbox|svnnew-include

```

```bash
export SVN_DUMP_FILTER_FILE_INCLUDE="./dump_svn_20220822include"
export SVN_NAME_DST=svnnew-include

svnadmin create $SVN_NAME_DST
svnadmin load --ignore-uuid $SVN_NAME_DST < $SVN_DUMP_FILTER_FILE_INCLUDE
sudo chown -R www-data:www-data $SVN_NAME_DST

sudo chmod -R 775 $SVN_NAME_DST
sudo chmod -R 777 $SVN_NAME_DST/db

```

###### A.3.2. exclude

```mermaid
flowchart LR
	subgraph svn
			svn_xbox[trunk/xbox]
			svn_beex[trunk/beex]
			svn_utilx9[trunk/utilx9]
	end

	subgraph svnnew-exclude
			svnnew_beex[trunk/beex]
			svnnew_utilx9[trunk/utilx9]
	end

	svn --> |exclude-trunk/xbox|svnnew-exclude
```

```bash
export SVN_DUMP_FILTER_FILE_EXCLUDE="./dump_svn_20220822exclude"
export SVN_NAME_DST=svnnew-exclude

svnadmin create $SVN_NAME_DST
svnadmin load --ignore-uuid $SVN_NAME_DST < $SVN_DUMP_FILTER_FILE_EXCLUDE
sudo chown -R www-data:www-data $SVN_NAME_DST

sudo chmod -R 775 $SVN_NAME_DST
sudo chmod -R 777 $SVN_NAME_DST/db

```

##### A.4. ? Merge repository - include (main) + exclude

```mermaid
flowchart LR
	subgraph svnnew-include-new
			svn_xbox[trunk/xbox]
			svn_beex[trunk/beex]
			svn_utilx9[trunk/utilx9]
	end

	subgraph svnnew-include
			svnnew_xbox[trunk/xbox]	
	end

	subgraph svnnew-exclude
			svnnew_beex[trunk/beex]
			svnnew_utilx9[trunk/utilx9]
	end

	svnnew-include --> svnnew-include-new
	svnnew-exclude --> svnnew-include-new
```

```bash
svnadmin load --parent-dir svnnew-include < $SVN_DUMP_FILTER_FILE_EXCLUDE

```

#### B. [svn:externals](https://svnbook.red-bean.com/zh/1.6/svn.advanced.externals.html)

```bash
# http://trac-vbx/svnroot/trunk/xbox
$ svn propedit svn:externals ./
```
```bash
../helloworld

# 相對於設置 svn:externals 屬性的目錄的 URL。
# http://trac-vbx/svnroot/trunk/helloworld
```
```bash
^/branches/helloworld

# 相對於設置 svn:externals 屬性的版本庫的根。
# http://trac-vbx/svnroot/branches/helloworld
```

```bash
//build20-vbx/svnroot/trunk/helloworld

# 相對於設置 svn:externals 屬性的目錄的 URL 的方案。
# http:build20-vbx/svnroot/branches/helloworld
```

```bash
/svnhello/trunk/helloworld

# 相對於設置 svn:externals 屬性的服務器的根 URL。
# http://trac-vbx/svnhello/trunk/helloworld
```

#### C. svn:executable

```bash
find * -name "*.exe" | xargs svn propset svn:executable on
find * -name "*.bat" | xargs svn propset svn:executable on
find * -name "*.dll" | xargs svn propset svn:executable on
```

#### D. propdel

```bash
svn propdel svn:global-ignores
svn propdel svn:ignore
svn propdel svn:externals
```

## 6.2. Git

#### A. Prune tracking branches not on the remote

```mermaid
flowchart LR
	subgraph Current
		subgraph Current-Local
			Current-main
			Current-test1
			Current-test2
		end
		subgraph Current-Remote
			Current-origin/main[remotes/origin/HEAD]
  	  end
	end
	subgraph Target
		subgraph Target-Local
			Target-main
		end
		subgraph Target-Remote
			Target-origin/main[remotes/origin/HEAD]
		end
	end
	Current --> Target
```

```bash
$ git remote prune origin
```

# 7. Others ???

```bash
# Cleanup unnecessary files and optimize the local repository
$ git gc --prune=now #清除 git reflog

# Stash the changes in a dirty working directory away
# 不常用，會忘掉。不要用
git stash -u
git stash list
git stash pop
git stash clear
```

# Appendix

# I. Study

## I.1. SVN

#### A. [版本控制工具 SVN – 常用的基本指令 / 狀態表示](https://eeepage.info/svn-usage/)

#### B. [SVN 基本指令教學](https://blog.longwin.com.tw/2007/07/svn_tutorial_2007/)

## I.2. Git

#### A. [Git 初學筆記 - 指令操作教學](https://blog.longwin.com.tw/2009/05/git-learn-initial-command-2009/)

#### B. [連猴子都能懂的Git入門指南](https://backlog.com/git-tutorial/tw/)

#### C. [GIT教學](https://kingofamani.gitbooks.io/git-teach/content/)

#### D. [[ 狀況題 ] 如何徹底將檔案從 Git 中移除？](https://mtr04-note.coderbridge.io/2020/08/09/about-git-deletefile/)

```bash
$ git filter-branch -f --tree-filter "rm -f helloworld_bak.c"
$ rm .git/refs/original/refs/heads/master
$ git reflog expire --all --expire=now
$ git fsck --unreachable
$ git gc --prune=now
$ git fsck
$ git push -f
```

#### E. [Configure Git Server with HTTP on Ubuntu](https://linuxhint.com/git_server_http_ubuntu/)

# II. Debug

## II.1. svn: E170013: Unable to connect to a repository at URL 'https:..'

```bash
$ rm -f ~/.subversion/auth/svn.simple/*
```

# III. Glossary

# IV. Tool Usage

## IV.1. svn Usage

```bash
$ svn help
usage: svn <subcommand> [options] [args]
Subversion command-line client.
Type 'svn help <subcommand>' for help on a specific subcommand.
Type 'svn --version' to see the program version and RA modules,
     'svn --version --verbose' to see dependency versions as well,
     'svn --version --quiet' to see just the version number.

Most subcommands take file and/or directory arguments, recursing
on the directories.  If no arguments are supplied to such a
command, it recurses on the current directory (inclusive) by default.

Available subcommands:
   add
   auth
   blame (praise, annotate, ann)
   cat
   changelist (cl)
   checkout (co)
   cleanup
   commit (ci)
   copy (cp)
   delete (del, remove, rm)
   diff (di)
   export
   help (?, h)
   import
   info
   list (ls)
   lock
   log
   merge
   mergeinfo
   mkdir
   move (mv, rename, ren)
   patch
   propdel (pdel, pd)
   propedit (pedit, pe)
   propget (pget, pg)
   proplist (plist, pl)
   propset (pset, ps)
   relocate
   resolve
   resolved
   revert
   status (stat, st)
   switch (sw)
   unlock
   update (up)
   upgrade

(Use '-v' to show experimental subcommands.)

Subversion is a tool for version control.
For additional information, see http://subversion.apache.org/

```

## IV.2. git Usage

```bash
$ git help
usage: git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone             Clone a repository into a new directory
   init              Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add               Add file contents to the index
   mv                Move or rename a file, a directory, or a symlink
   restore           Restore working tree files
   rm                Remove files from the working tree and from the index
   sparse-checkout   Initialize and modify the sparse-checkout

examine the history and state (see also: git help revisions)
   bisect            Use binary search to find the commit that introduced a bug
   diff              Show changes between commits, commit and working tree, etc
   grep              Print lines matching a pattern
   log               Show commit logs
   show              Show various types of objects
   status            Show the working tree status

grow, mark and tweak your common history
   branch            List, create, or delete branches
   commit            Record changes to the repository
   merge             Join two or more development histories together
   rebase            Reapply commits on top of another base tip
   reset             Reset current HEAD to the specified state
   switch            Switch branches
   tag               Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch             Download objects and refs from another repository
   pull              Fetch from and integrate with another repository or a local branch
   push              Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.

```

## IV.3. bash

#### A. ~/.bash_aliases

##### A.1. SVN

```bash
#** svn **
export SVN_EDITOR=vim

alias svn-up="svn up"

alias svn-diff="svn diff $*"
alias svn-diff2file="svn diff $* > /tmp/diff"

alias svn-stq="svn st -q"
alias svn-new="svn status | grep -e ^?"
alias svn-st="svn status --no-ignore"

alias svn-external="svn propedit svn:externals"

alias svn-blame="svn blame"

alias svn-log="svn log | perl -l40pe 's/^-+/\n/'"

alias svn-revision="svn info 2>/dev/null | grep Revision | cut -d' ' -f2"

function svn-rm()
{
	svn st | grep '^!' | awk '{$1=""; print " --force \""substr($0,2)"@\"" }' | xargs svn delete
}

function svn-add()
{
	svn status | grep -e ^? | awk '{$1=""; print "\""substr($0,2)"\"" }' | xargs svn add
}

function svn-rollback()
{
	SVN_LAST=`svn info 2>/dev/null | grep 'Last Changed Rev' | cut -d':' -f2 | awk '{print $1}'`
	svn merge -c -${SVN_LAST} .
}

function svn-revert()
{
	HINT="Usage: ${FUNCNAME[0]} <files>"
	FILES="$*"

	if [ ! -z "$FILES" ]; then
		svn revert $FILES
	else
		echo $HINT
	fi
}
```

##### A.2. Git

```bash
#** git **
export GIT_EDITOR=vim

alias git-push="git push"
alias git-pull="git pull"

alias git-diff="git diff HEAD $*"
alias git-diff2file="git diff HEAD $* > /tmp/diff"

alias git-st="git status $*"

alias git-blame="git blame"

alias git-log="git log --oneline"

alias git-rev="git log --oneline 2>/dev/null | cut -d' ' -f1 | head -n1"

alias git-remote="git remote"
alias git-seturl="git remote set-url origin"

#清除 git reflog
alias git-reflog="git gc --prune=now"

function git-addchangs()
{
	#git ls-files . -m
	#git diff --name-only | git add
	git status --porcelain | grep ' M'| awk '{$1=""; print "  \""substr($0,2)"\"" }' | xargs git add
}

function git-adduntracked()
{
	#git ls-files . -m
	#git diff --name-only | git add
	git status --porcelain | grep '??'| awk '{$1=""; print "  \""substr($0,2)"\"" }' | xargs git add
}

function git-revertchanges()
{
	HINT="Usage: ${FUNCNAME[0]} <files>"
	FILES="$*"
	[ ! -z "$FILES" ] || FILES="./"

	git restore --staged $FILES
}

function git-revert()
{
	HINT="Usage: ${FUNCNAME[0]} <files>"
	FILES="$*"
	[ ! -z "$FILES" ] || FILES="./"

	git checkout -- $FILES
}

alias git-branch="git branch"

function git-checkoutb()
{
	HINT="Usage: ${FUNCNAME[0]} <branch-name>"
	BRANCH_NAME=$1

	if [ ! -z "$BRANCH_NAME" ]; then
		git checkout $BRANCH_NAME
	else
		echo $HINT
	fi
}
```


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

