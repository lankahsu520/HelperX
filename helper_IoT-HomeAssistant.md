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
> 一些網路的介紹，可以直接查看以下連結。

> 這邊有個小故事
>
> 同事研究 Home Assistant 後，跑來說「Home Assistant 一定要裝在`伺服器`上」，而他對`伺服器`的想法還停留在〝效能要很好，很貴的機器。〞，而我反問「你不是裝在Raspberry Pi 」，他當場啞口無言。

## 1.1. [Home Assistant](https://www.home-assistant.io)

> 官方網站

## 1.2. [維基百科] [Home Assistant](https://en.wikipedia.org/wiki/Home_Assistant)

> **Home Assistant** is [free and open-source software](https://en.wikipedia.org/wiki/Free_and_open-source_software) used for [home automation](https://en.wikipedia.org/wiki/Home_automation). It serves both as a [smart home hub](https://en.wikipedia.org/wiki/Smart_home_hub) and an [integration platform](https://en.wikipedia.org/wiki/Integration_platform), allowing users to control or automate [smart home](https://en.wikipedia.org/wiki/Smart_home) devices.

## 1.3. [XiaoMi](https://github.com/XiaoMi)/[ha_xiaomi_home](https://github.com/XiaoMi/ha_xiaomi_home)

> Xiaomi Home Integration is an integrated component of Home Assistant supported by Xiaomi official. It allows you to use Xiaomi IoT smart devices in Home Assistant.

# 2. Start up

## 2.1. Install

###  2.1.1. [Raspberry Pi](https://www.home-assistant.io/installation/raspberrypi)

## 2.2. Run

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

# 3. Integrations

> 這邊就是大家期待的，綁定手邊的設備，不限定廠商，只要與 Home Assistant 有合作的。

> Settings -> Devices & services

<img src="./images/HomeAssistant0101.png" alt="HomeAssistant0101" style="zoom:33%;" />

## 3.1. [Sensibo](https://sensibo.com)

### 3.1.1. Install

#### A. Discovered

> click `Sensibo`

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

### 3.2.1. Install

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

# Appendix

# I. Study

## I.1. [Home Assistant 智能家居](https://www.youtube.com/playlist?list=PLhIaxXZ92HbBYk5lXMgL9LEb8PrOqpXml)

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

