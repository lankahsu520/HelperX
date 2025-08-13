# IoT [Home Assistant](https://www.home-assistant.io)

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

> Home Assistant 是一款開源的家庭自動化平台，強調本地控制與隱私保護。由全球熱衷創客與 DIY 愛好者所推動與維護，非常適合在 Raspberry Pi 或本地伺服器上執行。
>
> 它是一個輔助工具，是讓現有的環境下，整合成一個方便的 UI 環境，讓您能夠輕鬆地管理和控制各種智慧設備，讓它們可以協同作業。

> 這邊有個小故事
>
> 同事研究 Home Assistant 後，跑來說「Home Assistant 一定要裝在`伺服器`上」，而他對`伺服器`的想法還停留在〝效能要很好，很貴的機器。〞，而我反問「你不是裝在Raspberry Pi 」，他當場啞口無言。

> 一些網路的介紹，可以直接查看以下連結。

## 1.1. [Home Assistant](https://www.home-assistant.io)

> 官方網站

## 1.2. [維基百科] [Home Assistant](https://en.wikipedia.org/wiki/Home_Assistant)

> **Home Assistant** is [free and open-source software](https://en.wikipedia.org/wiki/Free_and_open-source_software) used for [home automation](https://en.wikipedia.org/wiki/Home_automation). It serves both as a [smart home hub](https://en.wikipedia.org/wiki/Smart_home_hub) and an [integration platform](https://en.wikipedia.org/wiki/Integration_platform), allowing users to control or automate [smart home](https://en.wikipedia.org/wiki/Smart_home) devices.

## 1.3. [XiaoMi](https://github.com/XiaoMi)/[ha_xiaomi_home](https://github.com/XiaoMi/ha_xiaomi_home)

> Xiaomi Home Integration is an integrated component of Home Assistant supported by Xiaomi official. It allows you to use Xiaomi IoT smart devices in Home Assistant.

# 2. Start up

## 2.1. [Install](https://www.home-assistant.io/installation)
>  這是官網提供的教學，說它是 install 教學，應該不算。
>
>  該內容是要求使用者下載 image 裝在虛擬機上。雖說是給 DIY 愛好者，但是…
>
>  - 有人不知什麼是虛擬機。
>- 只想在現有系統上執行，少一層虛擬機的耗能。
>  - 如使用 Raspberry Pi，不想再另外準備一張SDCARD（已經打照好遊戲機，就不能在上面附加嗎？）。

> [Installation](https://www.home-assistant.io/installation/)
>
> - [Home Assistant Green ](https://support.nabucasa.com/hc/en-us/categories/24638797677853-Home-Assistant-Green)
> - [Home Assistant Yellow ](https://support.nabucasa.com/hc/en-us/categories/24734575925149-Home-Assistant-Yellow)
> - [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi)
> - [ODROID](https://www.home-assistant.io/installation/odroid)
> - [Generic x86-64](https://www.home-assistant.io/installation/generic-x86-64)
> - [Linux](https://www.home-assistant.io/installation/linux)
> - [macOS](https://www.home-assistant.io/installation/macos)
> - [Windows](https://www.home-assistant.io/installation/windows)
> - [Other systems](https://www.home-assistant.io/installation/alternative)

## 2.2. Showtime

> http://192.168.31.62:8123

### 2.2.1. Main

<img src="./images/HomeAssistant0001.png" alt="HomeAssistant0001" style="zoom:33%;" />

### 2.2.2. CREATE MY SMART HOME

#### A. Create user

<img src="./images/HomeAssistant0002.png" alt="HomeAssistant0002" style="zoom:33%;" />

#### B. Home location

<img src="./images/HomeAssistant0003.png" alt="HomeAssistant0003" style="zoom:33%;" />

#### C. Help us help you

<img src="./images/HomeAssistant0004.png" alt="HomeAssistant0004" style="zoom:33%;" />

#### D. We found compatible devices!

<img src="./images/HomeAssistant0005.png" alt="HomeAssistant0005" style="zoom:33%;" />

### 2.2.2. My Home
<img src="./images/HomeAssistant0006.png" alt="HomeAssistant0006" style="zoom:33%;" />

## 2.3. homeassistant.service

### 2.3.1. Start and Stop

```bash
systemctl status homeassistant.service
systemctl stop homeassistant.service
```

### 2.3.2. Status

```bash
systemctl start homeassistant.service
```

```bash
$  cat /usr/lib/systemd/system/homeassistant.service
[Unit]
Description=Home Assistant
After=network.target

Requires=root.mount
After=root.mount

[Service]
Type=simple
User=homeassistant

PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /root/.homeassistant
ExecStartPre=/bin/chown homeassistant:homeassistant /root/.homeassistant

ExecStart=/usr/bin/hass --skip-pip -c "/root/.homeassistant"
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### 2.3.3. Log

> 因為這邊的設定目錄是指向 /root/.homeassistant

```bash
$ cat /root/.homeassistant/home-assistant.log
```

# 3. Integrations

> 這邊就是大家期待的，綁定手邊的設備，不限定廠商，只要與 Home Assistant 有合作的。
>
> 如果在裏面能找到的，就代表官網已經內建，基本上就可以使用！如果有發生錯誤時，請記得去查看 Log。

> Settings -> Devices & services

<img src="./images/HomeAssistant0101.png" alt="HomeAssistant0101" style="zoom:33%;" />

## 3.1. [Sensibo](https://sensibo.com)

> [Sensibo](https://www.home-assistant.io/integrations/sensibo)
>
> The **Sensibo** integration integrates [Sensibo](https://sensibo.com/) devices into Home Assistant.

### 3.1.1. Setup

#### A.  Search Integrations

> key in : Sensibo

<img src="./images/HomeAssistant0102.png" alt="HomeAssistant0102" style="zoom:33%;" />

#### B. API key*

> enter API key*:

> 如果不知 API key，請至以下官網申請；這邊不示範相關步驟。
>
> Request a API Key from [Sensibo API Portal](https://home.sensibo.com/login?next=/me/api)

<img src="./images/HomeAssistant0103.png" alt="HomeAssistant0103" style="zoom:50%;" />

#### C. Found device

<img src="./images/HomeAssistant0104.png" alt="HomeAssistant0104" style="zoom: 50%;" />

### 3.1.2. Overview

<img src="./images/HomeAssistant0105.png" alt="HomeAssistant0105" style="zoom:33%;" />

## 3.2. [ONVIF](https://www.onvif.org)

> [ONVIF](https://www.home-assistant.io/integrations/onvif)
>
> The ONVIF camera integration allows you to use an [ONVIF](https://www.onvif.org/) Profile S conformant device in Home Assistant. This requires the [`ffmpeg` integration](https://www.home-assistant.io/integrations/ffmpeg/) to be already configured.

### 3.2.1. Setup

#### A. Search Integrations

> key in : ONVIF

<img src="./images/HomeAssistant0201.png" alt="HomeAssistant0201" style="zoom:33%;" />

<img src="./images/HomeAssistant0202.png" alt="HomeAssistant0202" style="zoom: 50%;" />

#### B. Search automatically

<img src="./images/HomeAssistant0203.png" alt="HomeAssistant0203" style="zoom: 50%;" />

<img src="./images/HomeAssistant0204.png" alt="HomeAssistant0204" style="zoom: 50%;" />

#### C. Configure ONVIF device

<img src="./images/HomeAssistant0205.png" alt="HomeAssistant0205" style="zoom: 50%;" />

<img src="./images/HomeAssistant0206.png" alt="HomeAssistant0207" style="zoom:50%;" />

### 3.1.2. Overview

> 其它相關功能，請自行研究

<img src="./images/HomeAssistant0208.png" alt="HomeAssistant0208" style="zoom:33%;" />

## 3.3. [Tuya](https://www.tuya.com)

> [Tuya](https://www.home-assistant.io/integrations/tuya)
>
> The Tuya integration integrates all Powered by Tuya devices you have added to the Tuya Smart and Tuya Smart Life apps.
>
> All Home Assistant platforms are supported by the Tuya integration, except the lock and remote platform.

> [How to Install Smart Life Integration (Beta)](https://developer.tuya.com/en/docs/iot/Smart_Life_Integration?id=Kd0gk9baikbb7)
>
> This topic describes how to install and use the Smart Life integration for Home Assistant.

### 3.3.1. Get User Code

#### A. SmartLife APP

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0301.png" alt="HomeAssistant0301" style="zoom: 25%;" />

#### B. Setting

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0302.png" alt="HomeAssistant0302" style="zoom:25%;" />

#### C. Account and Security

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0303.png" alt="HomeAssistant0303" style="zoom:25%;" />

#### D. User Code

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0304.png" alt="HomeAssistant0304" style="zoom:25%;" />

### 3.2.2. Setup

#### A. Search Integrations

> key in : tuya

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0305.png" alt="HomeAssistant0305" style="zoom:33%;" />

#### B. Enter your Smart Life or Tuya Smart user code

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0306.png" alt="HomeAssistant0306" style="zoom: 50%;" />

#### C. Scan QR-code

> Please use `SmartLife APP` scan the QR-code

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0307.png" alt="HomeAssistant0307" style="zoom:50%;" />

#### D. Configure Tuya devices

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0308.png" alt="HomeAssistant0308" style="zoom: 50%;" />

### 3.3.3. Overview

<img src="T:/codebase/lankahsu520/HelperX/images/HomeAssistant0309.png" alt="HomeAssistant0309" style="zoom: 33%;" />

# 4. Home Assistant Community Store (HACS)

> 就是軟體商店。非內建，而且需要與個人的 [GitHub](https://github.com) 帳號綁定（GitHub 不是 open 嗎？）。
>
> 如果知道 Home Assistant 的運作方式，其實就可以跳過帳號綁定這步驟。

> [HACS](https://www.hacs.xyz)
>
> The Home Assistant Community Store (HACS) is a custom integration that provides a UI to manage custom elements in [Home Assistant](https://www.home-assistant.io/).
>
> What HACS can do:
>
> - Help you discover new custom elements.
> - Help you download new custom elements.
> - Manage (update/remove) custom elements.
> - Publish your own custom element repository and create shortcuts to repositories or issue trackers.

## 4.1. Install HACS

### 4.1.1. Start using HACS

> https://www.hacs.xyz
>
> 點選 `Start using HACS`

<img src="./images/HomeAssistant4001.png" alt="HomeAssistant4001" style="zoom: 33%;" />

### 4.1.2. [Download HACS](https://www.hacs.xyz/docs/use/download/download/)

> 點選 `Download HACS`

<img src="./images/HomeAssistant4002.png" alt="HomeAssistant4002" style="zoom:33%;" />

> 點選後就會有二種方式進行安裝，如果該主機能使用 SSH 或是 TREMINAL，建議使用 `Run the HACS download script`

#### A. [OS/Supervised](https://www.hacs.xyz/docs/use/download/download/#to-download-hacs-ossupervised)

> 點選 `my link.`

<img src="./images/HomeAssistant4003.png" alt="HomeAssistant4003" style="zoom:33%;" />

> 更新自己主機的 IP:PORT

<img src="./images/HomeAssistant4005.png" alt="HomeAssistant4005" style="zoom:33%;" />

> 之後會跳轉到登入畫面。

>  如果發生以下狀況，就是無法使用此方式，請至下章節繼續。
>
>  ```log
>  This redirect is not supported by your Home Assistant installation. It needs either the Home Assistant Operating System or Home Assistant Supervised installation method. For more information, see the documentation.
>  ```

<img src="./images/HomeAssistant4006.png" alt="HomeAssistant4006" style="zoom:33%;" />

#### B. Run the HACS download script

<img src="./images/HomeAssistant4004.png" alt="HomeAssistant4004" style="zoom:33%;" />

> 這個要進到作業系統進行操作

```bash
$ wget -O - https://get.hacs.xyz | bash -
```

> 它的工作大概如下

```bash
# 設定檔案存於 /root/.homeassistant
$ mkdir -p /root/.homeassistant/custom_components
$ cd /root/.homeassistant/custom_components
$ wget https://github.com/hacs/integration/releases/latest/download/hacs.zip
$ unzip hacs.zip -d hacs
$ rm hacs.zip

$ systemctl restart homeassistant.service
```

### 4.1.2. Setup

#### A. Search Integrations

> key in : hacs

<img src="./images/HomeAssistant4011.png" alt="HomeAssistant4011" style="zoom: 50%;" />

#### B. Acknowledge the questions

<img src="./images/HomeAssistant4012.png" alt="HomeAssistant4012" style="zoom: 33%;" />

#### C. Get the Key

> 得到 key 之後，點選 https://github.com/login/device

<img src="./images/HomeAssistant4013.png" alt="HomeAssistant4013" style="zoom: 50%;" />

#### D. Binding with GitHub

> 登入後，就會進行綁定

<img src="./images/HomeAssistant4014.png" alt="HomeAssistant4014" style="zoom: 33%;" />

> 輸入之前得到的 Key

<img src="./images/HomeAssistant4015.png" alt="HomeAssistant4015" style="zoom: 33%;" />

<img src="./images/HomeAssistant4016.png" alt="HomeAssistant4016" style="zoom: 33%;" />

<img src="./images/HomeAssistant4017.png" alt="HomeAssistant4017" style="zoom: 33%;" />

#### D. Configure HACS

<img src="./images/HomeAssistant4018.png" alt="HomeAssistant4018" style="zoom: 33%;" />

### 4.1.3. Overview

> 點選 `HACS`

<img src="./images/HomeAssistant4019.png" alt="HomeAssistant4019" style="zoom: 33%;" />

## 4.2. custom_components

> 因為這邊的設定目錄是指向 /root/.homeassistant

```bash
$ tree -L 1 /root/.homeassistant/custom_components
/root/.homeassistant/custom_components
`-- hacs

2 directories, 0 files
```

# Appendix

# I. Study

## I.1. [Home Assistant 智能家居](https://www.youtube.com/playlist?list=PLhIaxXZ92HbBYk5lXMgL9LEb8PrOqpXml)

## I.2. [2025 Home Assistant 入坑完全指南 – SMART HOME 智慧家庭 EP 7](https://neiltw.com/ultimate-home-assistant-beginners-guide)

## I.3. [Home Assistant 必裝外掛 HACS 安裝步驟詳解 – Home Assistant 手把手教學 EP 17](https://neiltw.com/hacs-install-guide)

# II. Debug

## II.1. No module named `xxxx`

```log
2025-08-13 00:54:18.784 WARNING (MainThread) [homeassistant.bootstrap] Skipping pip installation of required modules. This may cause issues
2025-08-13 00:54:50.902 ERROR (MainThread) [homeassistant.config_entries] Error occurred loading flow for integration xiaomi_miio: No module named 'miio'
```

```bash
# 使用 pip 安裝
$ pip install python-miio
# 使用 pip 安裝特定版本
$ pip install python-miio==0.5.12
```

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

