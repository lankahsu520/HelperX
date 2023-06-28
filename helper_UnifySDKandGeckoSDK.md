# [Unify SDK](https://github.com/SiliconLabs/UnifySDK) and [Gecko SDK](https://github.com/SiliconLabs/gecko_sdk/)
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

> 從 [Unify SDK](https://github.com/SiliconLabs/UnifySDK) 和 [Gecko SDK](https://github.com/SiliconLabs/gecko_sdk/) 的簡介中，都只會知道都是 Silicon Labs 發佈出來，為了開發 IoT 開發套件。但是個別扮演什麼角色，除非你熟讀所有文件，不然無法分辨。
>
> 這邊先大膽的假設：
>
> Unify SDK 主要偏重於開發 Linux user mode，以 service (daemon) 存在。而使用者開發的程式要如何與之溝，還需開發者去研究。
>
> Gecko SDK 就是用於開發 MCU 的開發套件。

# 2. [UnifySDK](https://github.com/SiliconLabs/UnifySDK)

> This SDK contains non-embedded applications developed by Silicon Labs. The Host SDK is the main source for Silicon Labs customers who are working with Linux based applications in conjunction with Silicon Labs products.

![unify_host_sdk](./images/unify_host_sdk.png)

## 2.1. [Unify Framework](https://siliconlabs.github.io/UnifySDK/doc/UnifySDK.html)

>A powerful IoT gateway framework that supports multiple wireless protocols.
>
>??? 目前還不是很清楚溝通方式

## 2.2. [Multiprotocol Host Software](https://siliconlabs.github.io/UnifySDK/doc/multiprotocol.html)

> A collection of host software for simultaneously running multiple protocol stacks on the host. Using a single radio co-processor, you can run Zigbee, OpenThread, and Bluetooth.
>
> 這邊最熟悉的就是 BlueZ，一般都是用 D-Bus 與之溝通。

### 2.2.1. [CPC Daemon](https://siliconlabs.github.io/UnifySDK/applications/cpcd/readme_user.html)

# 3. [GeckoSDK](https://github.com/SiliconLabs/gecko_sdk/)

> The Gecko SDK (GSDK) combines Silicon Labs wireless software development kits (SDKs) and Gecko Platform into a single, integrated package. The GSDK is your primary tool for developing in the Silicon Labs IoT Software ecosystem.

# Appendix

# I. Study

## I.1. [Unify Host SDK](https://siliconlabs.github.io/UnifySDK/doc/introduction.html)

> This documentation is for the [latest release of the Unify Host SDK](https://github.com/SiliconLabs/UnifySDK/releases/latest).
>
> The Unify Host SDK contains non-embedded applications developed by Silicon Labs.

## I.2. [Unify Software Development Kit (SDK)](https://www.silabs.com/developers/unify-sdk?tab=overview)

> Unify SDK simplifies IoT infrastructure development including gateways, access points, hubs, bridges, and application processor-based end products.

## I.3. [Gecko Platform](https://docs.silabs.com/gecko-platform/4.3/platform-overview/)

> Gecko Platform is the common foundation for the Gecko SDK Suite.

## I.4. [Zigbee stack layers](https://www.digi.com/resources/documentation/Digidocs/90002002/Content/Reference/r_zb_stack.htm?TocPath=zigbee%20networks%7C_____3)

![dwg_zigbee_stack_layers_549x350](./images/dwg_zigbee_stack_layers_549x350.png)

| Zigbee layer | Descriptions                                                 |
| ------------ | ------------------------------------------------------------ |
| ZDO          | Application layer that provides device and service discovery features and advanced network management capabilities. |
| APS (AF)     | Application layer that defines various addressing objects including profiles, clusters, and endpoints. |
| Network      | Adds routing capabilities that allows RF data packets to traverse multiple devices (multiple hops) to route data from source to destination (peer to peer). |
| MAC          | Manages RF data transactions between neighboring devices (point to point). The MAC includes services such as transmission retry and acknowledgment management, and collision avoidance techniques (CSMA-CA). |
| PHY          | Defines the physical operation of the Zigbee device including receive sensitivity, channel rejection, output power, number of channels, chip modulation, and transmission rate specifications. Most Zigbee applications operate on the 2.4 GHz ISM band at a 250 kb/s data rate. See the IEEE 802.15.4 specification for details. |



# II. Debug

# III. Glossary

#### CPC-D,

> The Co-Processor Daemon (CPCd) enables users to have multiple stack protocols interact with a secondary processor over a shared physical link using multiple endpoints.

#### Gecko Platform

> 一般我們稱公板為 Board - Gecko Board。也就是 Silicon 的開發公板，名字稱為 Gecko 壁虎。

#### [NCP, Network Co-Processor](https://openthread.io/platforms/co-processor#network_co-processor_ncp)

> From ChatGPT，軟體層
>
> NCP是一個專門處理網路通信的處理器。它通常用於網絡設備（如路由器、交換機、網絡伺服器等）或網絡介面卡中。NCP負責處理網絡協議、數據封包的轉發、路由、處理等功能。它能夠處理不同層次的網絡協議，如IP（Internet Protocol）、TCP（Transmission Control Protocol）、UDP（User Datagram Protocol）等，並確保數據在網絡中的正確傳遞。

#### NWK, Network layer

#### [RCP, Radio Co-Processor](https://openthread.io/platforms/co-processor#radio_co-processor_rcp) 

>From ChatGPT, 硬體層
>
>RCP是一個專門處理無線通信的處理器。它通常用於行動設備（如智能手機、平板電腦等）或無線通信模組中。RCP負責處理無線訊號的傳輸、接收、調製和解調製等功能。它能夠與無線網路（如蜂窩網絡、Wi-Fi、藍牙等）進行通信，使設備能夠連接到網絡，進行數據的傳輸和接收。

#### XXX Gecko XXX Microcontroller

> 就是Silicon 的 Gecko 模組。

# IV. Tool Usage

## IV.1. 
# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

