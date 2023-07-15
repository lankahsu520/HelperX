# GitLab and CI/CD
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

# 1. Communicate with GitLab

## 1.1. [Use SSH keys to communicate with GitLab](https://docs.gitlab.com/ee/user/ssh.html)

### 1.1.1. Generate an SSH key pair for a FIDO/U2F hardware security key

```bash
ssh-keygen -t rsa -b 2048 -C lankahsu520

mkdir ~/.ssh/gitlab_520
mv id_rsa ~/.ssh/gitlab_520
mv id_rsa.pub ~/.ssh/gitlab_520

```
```bash
cat ~/.ssh/gitlab_520/id_rsa.pub

```

### 1.1.2. Add an SSH key to your GitLab account

#### A. [Login](https://gitlab.com/users/sign_in/)

#### B. [SSH Keys](https://gitlab.com/-/profile/keys)

```bash
Edit profile -> SSH Keys

Add an SSH key:
Title:
Expiration date:
```

### 1.1.3. Use different accounts on a single GitLab instance

```bash
vi ~/.ssh/config

Host gitlab.com-520
	Hostname gitlab.com
		PreferredAuthentications publickey
		IdentityFile ~/.ssh/gitlab_520/id_rsa
```

### 1.1.4. Verify that you can connect

```bash
ssh -Tvvv git@gitlab.com-520
```

## 1.2. [Use Personal Access Tokens](https://gitlab.com/-/profile/personal_access_tokens)

```bash
Edit profile -> Access Tokens

Token name:
Select scopes:
	read_repository
	write_repository

```

# 2. Repository

## 2.1. [startup](https://gitlab.com/lankahsu/startup)

### 2.1.1. Use SSH key ( Host Alias - gitlab.com-520 )

```bash
git@gitlab.com:lankahsu/startup.git

to

git@gitlab.com-520:lankahsu/startup.git
```

```bash
git clone git@gitlab.com-520:lankahsu/startup.git

```

### 2.1.2. Use Personal access tokens

```bash
export PJ_GITLAB_PERSONAL_TOKEN="glpat-lanka520"
git clone https://gitlab-ci-token:${PJ_GITLAB_PERSONAL_TOKEN}@gitlab.com/lankahsu/startup.git

```

### 2.1.3. Files

#### A. .gitlab-ci.yml
```mermaid
flowchart LR
	test[test]

```
```yml
# 縮排請用 space，勿用tab
# 排先後順序
image: registry.gitlab.com/lankahsu/dockerx:1.0.0

stages:
  - test

test_job:
  stage: test
  only:
    - main
  script:
    - echo ">> CI_PROJECT_NAME:" ${CI_PROJECT_NAME}
    - echo ">> CI_COMMIT_REF_NAME:" ${CI_COMMIT_REF_NAME}
    - echo ">> CI_BUILD_NAME:" ${CI_BUILD_NAME}
    - export > export_${CI_BUILD_NAME}.log
  when: manual
```



## 2.2. [helloworld](https://gitlab.com/lankahsu/helloworld)

### 2.2.1. Use SSH key ( Host Alias - gitlab.com-520 )

```bash
git@gitlab.com:lankahsu/helloworld.git

to

git@gitlab.com-520:lankahsu/helloworld.git
```

```bash
git clone git@gitlab.com-520:lankahsu/helloworld.git

```

### 2.2.2. Use Personal access tokens

```bash
export PJ_GITLAB_PERSONAL_TOKEN="glpat-lanka520"
git clone https://gitlab-ci-token:${PJ_GITLAB_PERSONAL_TOKEN}@gitlab.com/lankahsu/helloworld.git

```
### 2.2.3. Files

#### A. .gitlab-ci.yml

```mermaid
flowchart LR
	download[download]
	build[build]
	test[test]
	release[release]

	download --> build --> test --> release

```

```yml
# 縮排請用 space，勿用tab
# 排先後順序
# download -> build -> test -> release
image: registry.gitlab.com/lankahsu/dockerx:1.0.0

stages:
  - download
  - build
  - test
  - release

# 首先宣告 job 的名稱
download_job:
  # 宣告此 job 屬於哪一個 stage 
  stage: download
  # 限制只有 develop branch 會執行此 job
  only:
    - develop
    - main
  # 最後是此 job 要執行哪些動作
  script:
    - echo ">> ${CI_BUILD_NAME} ..."
    #- echo ${CI_PROJECT_DIR} > /work/gitlab-runner/${CI_PROJECT_NAME}.dir
    - (mkdir -p install; export > ./install/export_${CI_BUILD_NAME}.log; )
    - git clone https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/lankahsu/startup
    - mv startup/confs ./
  artifacts:
    name: "${CI_PROJECT_NAME}_${CI_COMMIT_REF_NAME}_${CI_BUILD_NAME}"
    paths:
      - ./install
      - ./confs

build_job:
  stage: build
  only:
    - develop
    - main
  dependencies:
    - download_job
  script:
    - echo ">> ${CI_BUILD_NAME} ..."
    - (. confs/gitlab.conf; export > ./install/export_${CI_BUILD_NAME}.log; make install; make romfs; )
  artifacts:
    # 下載時的檔案名稱
    name: "${CI_PROJECT_NAME}_${CI_COMMIT_REF_NAME}_${CI_BUILD_NAME}"
    # ./install 資料夾底下有未被 GIT 追蹤的檔案，也將進行保留
    #untracked: true
    paths:
      - ./rootfs
      - ./install
      - ./confs
    # 不包含
    #exclude:
    #  - ./install/DUMMY
    expire_in: 1 week

test_job:
  stage: test
  only:
    - develop
    - main
  script:
    - echo ">> ${CI_BUILD_NAME} ..."
    - (export > ./install/export_${CI_BUILD_NAME}.log; ls -al ./roofs/lib; export LD_LIBRARY_PATH=`pwd`/roofs/lib; ./rootfs/bin/helloworld; )

release_job:
  stage: release
  only:
    - develop
    - main
  script:
    - echo ">> ${CI_BUILD_NAME} ..."
    - (export > ./install/export_${CI_BUILD_NAME}.log; )

```



## 2.3. [DockerX](https://gitlab.com/lankahsu/dockerx)

### 2.3.1. Use SSH key ( Host Alias - gitlab.com-520 )

```bash
git@gitlab.com:lankahsu/dockerx.git

to

git@gitlab.com-520:lankahsu/dockerx.git
```

```bash
git clone git@gitlab.com-520:lankahsu/dockerx.git

```

### 2.3.2. Use Personal access tokens

```bash
export PJ_GITLAB_PERSONAL_TOKEN="glpat-lanka520"
git clone https://gitlab-ci-token:${PJ_GITLAB_PERSONAL_TOKEN}@gitlab.com/lankahsu/dockerx.git

```
### 2.3.3. Files

#### A. .gitlab-ci.yml

##### ~~A.1. for specific runner~~

```mermaid
flowchart LR
	build[build]

```

```yml
stages:
  - build

build_job:
  stage: build
  only:
    - main
  before_script:
    - echo ${CI_JOB_TOKEN} | docker login ${CI_REGISTRY} -u ${CI_REGISTRY_USER} --password-stdin ${CI_REGISTRY}
    #- echo ${CI_REGISTRY_PASSWORD} | docker login ${CI_REGISTRY} -u ${CI_REGISTRY_USER} --password-stdin ${CI_REGISTRY}
  script:
    - echo ">> ${CI_BUILD_NAME} ..."
    #- export > /work/gitlab-runner/export_${CI_BUILD_NAME}.log
    - export > export_${CI_BUILD_NAME}.log
    - docker build -t $CI_REGISTRY_IMAGE:1.0.0 .
    - docker push $CI_REGISTRY_IMAGE:1.0.0
  when: manual

```

##### A.2. for docker:dind

```mermaid
flowchart LR
	build[build]

```

```yml
image: docker
services:
  - docker:dind

stages:
  - build

build_job:
  stage: build
  only:
    - main
  before_script:
    - echo ${CI_JOB_TOKEN} | docker login ${CI_REGISTRY} -u ${CI_REGISTRY_USER} --password-stdin
  script:
    - docker build -t $CI_REGISTRY_IMAGE:1.0.0 .
    - docker push $CI_REGISTRY_IMAGE:1.0.0
  when: manual

```

#### B. Dockerfile

```dockerfile
# docker build -t="ubuntu:22.04v1" .
# ubuntu 22.04
FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install \
            cmake \
            pkg-config \
            meson \
            ninja-build \
            gio-2.0 \
            git \
            lsb-release \
            -y

# dash -> bash
RUN cd /bin && rm sh; ln -s bash sh

# mkdir /work; cd /work
WORKDIR /work
# cp -avr * /work
#ADD . /work

#CMD ls -al

# open port:9981
EXPOSE 9981

RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove --purge

```

# ~~3. Specific Runners~~ (Don't use this !!! It is hard to debug when you run pipeline. )

```mermaid
flowchart LR
	GitLab([GitLab])

	subgraph Host[Host - Ubuntu 20.04.4 LTS]
		subgraph Container[gitlab-runner]
			shell
		end
	end

	GitLab --> |CI/CD|shell

```

## ~~3.1. Install~~

### ~~3.1.1. [Install GitLab Runner manually on GNU/Linux](https://docs.gitlab.com/runner/install/linux-manually.html#using-binary-file)~~

#### ~~A. download~~

```bash
# Linux x86-64
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"

# Linux x86
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-386"

# Linux arm
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm"

# Linux arm64
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm64"

# Linux s390x
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-s390x"

# Linux ppc64le
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-ppc64le"
   
# Linux x86-64 FIPS Compliant
sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64-fips"

```
#### ~~B. Give it permissions to execute~~

```bash
sudo chmod +x /usr/local/bin/gitlab-runner
```

#### ~~C. Create a GitLab CI user~~

```bash
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/sh
```

#### ~~D. gitlab-runner Install~~

```bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
```

#### ~~E. Uninstall~~

```bash
sudo gitlab-runner uninstall
sudo rm -rf /usr/local/bin/gitlab-runner
sudo userdel gitlab-runner
sudo rm -rf /home/gitlab-runner/
```

### ~~3.1.2. or apt-get install/remove~~

#### ~~A. Install~~

```bash
sudo apt install gitlab-runner

mkdir -p /work/gitlab-runner
chmod 777 /work/gitlab-runner
```

#### ~~B. Uninstall~~

```bash
sudo apt remove gitlab-runner
rm -rf /var/opt/gitlab
pkill -f gitlab

rm -rf /opt/gitlab
rm -rf /etc/gitlab
rm -rf /var/opt/gitlab

```

## ~~3.2. Register runner - Settings / [CI/CD](https://gitlab.com/lankahsu/startup/-/settings/ci_cd)~~

### ~~3.2.1. Shared runners~~
~~![Pipelinefailing](./images/GitLab_Pipelinefailing.png)~~

#### ~~A. 很重要！很重要！很重要！~~

- ~~如果沒有完成 Validate account，就只能使用 Specific runners。~~
- ~~就算之後於 Container Registry 有建立新的 container，也無法使用。~~

### ~~3.2.2. Specific runners / Registration token~~

#### ~~A. 很重要！很重要！很重要！~~

- ~~於實際操作後，常發生 gitlab-runner 無法正常連結，卻沒有任何錯誤訊息。~~

- ~~就算連上線後，進行 CI/CD 時，常常看不到錯誤訊息。~~

#### ~~B. Disable shared runners for this project~~

~~![Disable_shared_runners_for_this_project](./images/GitLab_Disable_shared_runners_for_this_project.png)~~

#### ~~C. Register runner~~

```bash
export PJ_GITLAB_REGISTRATION_TOKEN="lanka520"
export PJ_GITLAB_REGISTRATION_URL="https://gitlab.com/"

sudo gitlab-runner register \
	--url ${PJ_GITLAB_REGISTRATION_URL} \
	--registration-token ${PJ_GITLAB_REGISTRATION_TOKEN}

```
~~![Specific_runners](./images/GitLab_Specific_runners.png)~~

#### ~~D. /etc/gitlab-runner/config.toml~~

```toml
# https://docs.gitlab.com/runner/configuration/advanced-configuration.html
# Limits how many jobs can run concurrently, across all registered runners. Each [[runners]] section can define its own limit, but this value sets a maximum for all of those values combined. For example, a value of 10 means no more than 10 jobs can run concurrently. 0 is forbidden. If you use this value, the runner process exits with a critical error.
concurrent = 4
check_interval = 0

# debug, info, warn, error, fatal, and panic
log_level = "info"

# Specifies the log format. Options are runner, text, and json. This setting has lower priority than the format set by command-line argument --log-format. The default value is runner.
log_format = "text"

[[runners]]
  name = "build20-vbx"
  url = "https://gitlab.com/"
  token = "lanka520"
  executor = "shell"
  [runners.cache]

```

# 4. New Docker Image - use CI/CD

## 4.1. Select Runner

### ~~4.1.1. for specific runner~~

```mermaid
flowchart LR
	GitLab([GitLab])
	CICD[CI/CD]
	Container([Container Registry])
	runner([Runner build20-vbx,shell])
	
	build[docker build]
	push[docker push]

	GitLab --> CICD --> |build_job| runner --> build--> push -->Container

```
#### ~~A. Assign user docker~~

```bash
sudo usermod -aG docker gitlab-runner

sudo -H -u gitlab-runner docker info

```
### 4.1.2. for docker:dind (use DockerX to build a new docker)


```mermaid
flowchart LR
	GitLab([GitLab])
	CICD[CI/CD]
	Container([Container Registry])
	runner([GitLab Shared Runner])
	
	build[docker build]
	push[docker push]

	GitLab --> CICD --> |build_job| runner --> build--> push -->Container

```

#### A. .gitlab-ci.yml

```yml
image: docker
services:
  - docker:dind

```

## 4.2. Docker Password

### ~~4.2.1 CI_REGISTRY_PASSWORD~~

#### ~~A.  [Settings](https://gitlab.com/lankahsu/dockerx/edit) / [Repository](https://gitlab.com/lankahsu/dockerx/-/settings/repository) / Deploy tokens~~

```
Name: lanka-dockerx
Username:
```

![Deploy_tokens](./images/GitLab_Deploy_tokens00.png)

![Deploy_tokens01](./images/GitLab_Deploy_tokens01.png)

#### ~~B. [Settings](https://gitlab.com/lankahsu/dockerx/edit) / [CI/CD](https://gitlab.com/lankahsu/dockerx/-/settings/ci_cd) / Variables~~

![Variables](./images/GitLab_Variables.png)

### 4.2.2. CI_JOB_TOKEN

## 4.3. [CI/CD](https://gitlab.com/lankahsu/dockerx/-/pipelines) / [Pipelines](https://gitlab.com/lankahsu/dockerx/-/pipelines) / Run pipeline

## 4.4. [Packages & Registries](https://gitlab.com/lankahsu/dockerx/-/packages) / [Container Registry](https://gitlab.com/lankahsu/dockerx/container_registry)

![container_registry](./images/GitLab_container_registry.png)

```bash
registry.gitlab.com/lankahsu/dockerx
registry.gitlab.com/lankahsu/dockerx:1.0.0
```

# 5. CI/CD vs. Simple Shell Scripts

## 5.1. CI/CD

### 5.1.1. Developer

```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	CICD[CI/CD]
	Release[Release]
	Error[Error Reporting]

	Developer --> |push|GitLab --> |trigger|CICD --> |passed| Release
	CICD --> |failed| Error
```
#### 5.1.2. Developer and Reviewer

```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	CICD[CI/CD]
	Release[Release]
	Error[Error Reporting]

	Developer --> |push|GitLab --> |trigger|CICD --> |passed| Reviewer --> Release
	CICD --> |failed| Error
```
#### 5.1.3. Developer, Reviewer and Releaser

```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	CICD[CI/CD]
	Release[Release]
	Error[Error Reporting]

	Developer --> |push|GitLab --> |trigger|CICD --> |passed| Reviewer --> Releaser --> Release
	CICD --> |failed| Error
```

## 5.2.  Simple Shell Scripts

### 5.2.1. Developer
```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	ShellScripts[Simple Shell Scripts]


	Developer --> |push|GitLab 
	Developer --> |run|ShellScripts --> |passed| Release
	ShellScripts --> |failed| Error
```
### 5.2.2. Developer and Reviewer
```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	ShellScripts([Simple Shell Scripts])

	Developer --> |push|GitLab 
	Developer --> |run|ShellScripts --> |passed|Reviewer --> Release
	ShellScripts --> |failed| Error
```
### 5.2.3. Developer, Reviewer and Releaser
```mermaid
flowchart LR
	GitLab([GitLab])
	Developer([Developer])
  Reviewer([Reviewer])
	Releaser([Releaser])

	ShellScripts[Simple Shell Scripts]

	Developer --> |push|GitLab
	Developer --> |run|ShellScripts --> |passed|Reviewer --> Releaser --> Release
	ShellScripts --> |failed| Error
```
# 6. Best Cross-Platform Developers （Embedded System）

- 會不會安裝 ubuntu 或其它常見開發環境？會！
- 會不會寫 Shell Scripts？會！
- 會不會寫 Makefile？會！
- 會不會 porting Open-source？會！
- 會不會寫 C？會！

# 7. CI/CD is useful ?

- 如章節 3.3. ，在選擇 runners 時，如果選擇 GitLab 提供的環境，那〝一定〞有可能跟發佈的環境有所不同，另外收費問題不在此次討論。
- 如上，反之使用自建 runners，就必須安裝 gitlab-runner，將等同於安裝一個木馬程式在自家的電腦上。
- 續談系統環境問題，語言和系統的相依性將會影響 runners 的複雜度；像是一些前端程式就很適合使用 GitLab 內建 runners；而 cross platform 就要確保 runners 的內涵。
- 很難debug！〝- ln -s ${CI_PROJECT_DIR} /work/gitlab-runner〞試試這行吧！
- .gitlab-ci.yml 這是誰要負責撰寫。最後還不是 Developer 在寫。
- 既然都已經有能力自建環境（章節 6），何需再創建 runner。
- 從章節 5中，如果你是相信 CI/CD 能縮短專案時程，為什麼 Simple Shell Scripts 就不值得相信？
- 在一定規模的公司裏，常有 Releaser的角色，把關最後發佈的工作，所以啊~應該很難將release 的工作列入CI/CD中。
- 最後就是觸發時機，難道每次 commit 後就進行嗎？如果只是加個註解呢？
- 有考慮到版本控管（如 git、svn）是多人同時上線，誰要當最後的觸發者？

# Appendix

# I. Study

## I.1. [GitLab: 建立第一條 CI/CD Pipeline](https://ithelp.ithome.com.tw/articles/10219427)

## I.2. [GitLab CI 之 Runner 的 Executor 該如何選擇？](https://chengweichen.com/2021/03/gitlab-ci-executor.html)

## I.3. [Gitlab-CI 入門實作教學 - 單元測試篇](https://nick-chen.medium.com/gitlab-ci-入門筆記-單元測試篇-156455e2ad9f)

## I.4. [Gitlab-CI 入門實作 — 自動化部署篇](https://nick-chen.medium.com/教學-gitlab-ci-入門實作-自動化部署篇-ci-cd-系列分享文-cbb5100a73d4)

## I.5. [Configuration of your builds with .gitlab-ci.yml](https://www.perforce.com/manuals/gitswarm/ci/yaml/README.html)

# II. Debug

## III.1. remote: GitLab: You are not allowed to force push code to a protected branch on this project.

> 當 rollback 操作時，強制 push 時
> 1. 進到 https://gitlab.com ，點選該 Project
> 2. [Settings] -> [Respository] -> [Protected branches / Expand] -> [Unprotect]

```bash
$ git reset --hard 6338f92
$ git push -f
Total 0 (delta 0), reused 0 (delta 0)
remote: GitLab: You are not allowed to force push code to a protected branch on this project.

```

# III. Glossary

# IV. Tool Usage

## IV.1. gitlab-runner Usage

```bash
$ sudo gitlab-runner
ERRO[0000] Docker executor: prebuilt image helpers will be loaded from /var/lib/gitlab-runner.
NAME:
   gitlab-runner - a GitLab Runner

USAGE:
   gitlab-runner [global options] command [command options] [arguments...]

VERSION:
   11.2.0 (11.2.0)

AUTHOR:
   GitLab Inc. <support@gitlab.com>

COMMANDS:
     exec                  execute a build locally
     list                  List all configured runners
     run                   run multi runner service
     register              register a new runner
     install               install service
     uninstall             uninstall service
     start                 start service
     stop                  stop service
     restart               restart service
     status                get status of a service
     run-single            start single runner
     unregister            unregister specific runner
     verify                verify all registered runners
     artifacts-downloader  download and extract build artifacts (internal)
     artifacts-uploader    create and upload build artifacts (internal)
     cache-archiver        create and upload cache artifacts (internal)
     cache-extractor       download and extract cache artifacts (internal)
     help, h               Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                      debug mode [$DEBUG]
   --log-level value, -l value  Log level (options: debug, info, warn, error, fatal, panic)
   --cpuprofile value           write cpu profile to file [$CPU_PROFILE]
   --help, -h                   show help
   --version, -v                print the version

```

# V. .gitlab-ci.yml

#### A.  [`.gitlab-ci.yml` keyword reference **(FREE)**](https://gitlab.fdimatelec.fr/help/ci/yaml/index)

#### B. a template

```yml
# This file is a template, and might need editing before it works on your project.
# This is a sample GitLab CI/CD configuration file that should run without any modifications.
# It demonstrates a basic 3 stage CI/CD pipeline. Instead of real tests or scripts,
# it uses echo commands to simulate the pipeline execution.
#
# A pipeline is composed of independent jobs that run scripts, grouped into stages.
# Stages run in sequential order, but jobs within stages run in parallel.
#
# For more information, see: https://docs.gitlab.com/ee/ci/yaml/index.html#stages
#
# You can copy and paste this template into a new `.gitlab-ci.yml` file.
# You should not add this template to an existing `.gitlab-ci.yml` file by using the `include:` keyword.
#
# To contribute improvements to CI/CD templates, please follow the Development guide at:
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Getting-Started.gitlab-ci.yml

stages:          # List of stages for jobs, and their order of execution
  - build
  - test
  - deploy

build-job:       # This job runs in the build stage, which runs first.
  stage: build
  script:
    - echo "Compiling the code..."
    - echo "Compile complete."

unit-test-job:   # This job runs in the test stage.
  stage: test    # It only starts when the job in the build stage completes successfully.
  script:
    - echo "Running unit tests... This will take about 60 seconds."
    - sleep 60
    - echo "Code coverage is 90%"

lint-test-job:   # This job also runs in the test stage.
  stage: test    # It can run at the same time as unit-test-job (in parallel).
  script:
    - echo "Linting code... This will take about 10 seconds."
    - sleep 10
    - echo "No lint issues found."

deploy-job:      # This job runs in the deploy stage.
  stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
  script:
    - echo "Deploying application..."
    - echo "Application successfully deployed."

```

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

