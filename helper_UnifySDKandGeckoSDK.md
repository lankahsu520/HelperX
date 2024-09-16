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

> 從 [Unify SDK](https://github.com/SiliconLabs/UnifySDK) 和 [Gecko SDK](https://github.com/SiliconLabs/gecko_sdk/) 的簡介中，都只會知道都是 Silicon Labs 發佈出來，為了開發 IoT 開發套件。
>
> Unify SDK 主要偏重於開發 Linux user mode，以 service (daemon) 存在。而使用者開發的程式要如何與之溝，還需開發者去研究。
>
> Gecko SDK 就是用於開發 MCU 的開發套件。

![unify_host_sdk](./images/unify_host_sdk.png)

## 1.1. Questions

> 以下只是我個人的發想

#### A. How to lower costs  ?  (To minimize the resource utilization of the gateway)

> 從這張圖 (unify_host_sdk.png)，得到一個結論，〝完蛋了！”。
>
> 在系統廠開發這麼多年，一個晶片廠弄出這麼多 services 幹什麼，要跟 Z-Wave 溝通，直接跟 ZPC溝通就好，要跟 ZigBee  溝通，直接跟 ZigPC溝通就好；而且量產的板子，能 lower costs 就儘量偷，會留這麼多RAM 和 FLASH 資源嗎？

#### B. How to disable some services ?

> 把程式弄得這麼複雜，當使用者要 disable 部分 services，是不是整個系統都不能用了？
>
> 真的太複雜了 !!!

#### C. It is hardly to debug.

>接上，既然 xxxPC 和 xxxNCP 的相依性這麼高，應該就它們合成一個，
>
>因為設計是讓開發者著重在 UCL，就讓它們維持黑箱身份。
>
>另外合成一個有個好處，要碼啟動成功，不然就是失敗！不用擔心 xxxPC or xxxNCP 其中一個 service 忘了啟動或是那個 service 有問題。

#### D.  The value of an MQTT Broker on embedded system ?

> MQTT Broker 在嵌入式系統的存在性 ? 嵌入式系統可能有 MQTT client，不見得都能支援 MQTT Broker。

#### E. How to rebuild the prebuild libraries in GeckoSDK ?

>這部分的 source codes ?

## 1.2. Why Not ?

>現在的 mcu 處理能力越來越強，Silicon Labs 應該也要花點心思在將 xxxPC 最小化到能放入 mcu 的系統。

```mermaid
flowchart LR
	classDef SkyBlue fill:#EDF5FF

	subgraph Host1
		SW1
		subgraph UnifyHost1[Unify Host SDK]
    	subgraph ZigbeePCHost1[ZigbeePC]
	      ZigbeeNCPHost1[ZigbeeNCP]
			end
			CPCdHost1[CPCd]
		end
		subgraph RCPHost1
			CPCHost1[CPC]
   		ZigbeeRCPHost1[ZigbeeRCP]
   	end
    SW1<-->|UCL over TCPIP|ZigbeePCHost1<-->CPCdHost1<-->CPCHost1
	end

	subgraph Host2
		SW2[SW2]
		subgraph Unify[Unify Host SDK]
			subgraph UnifyFramework[UnifyFramework]
				UnifyMQTT[UnifyMQTT Broker]
				subgraph ZwavePC
					ZwaveNCP
				end
				subgraph ZigbeePC
					ZigbeeNCP
				end
				subgraph AoxPC
					AoxNCP
				end
      	UnifyMQTT<-->|UCL,MQTT Client|ZigbeePC
      	UnifyMQTT<-->|UCL,MQTT Client|AoxPC
			end
			CPCd
		end
		subgraph Host2RCP
			CPC
			ZwaveRCP
	
			ZigbeeRCP

			AoxRCP
		end
		SW2 <--> |UCL over TCPIP|ZwavePC
		SW2 <--> |UCL over TCPIP|ZigbeePC
		SW2 <--> |UCL over TCPIP|AoxPC

		CPCd<-->ZwaveNCP
		CPCd<-->ZigbeeNCP
		CPCd<-->AoxNCP
		
		CPCd<-->CPC
	end

	subgraph Light["Light (ZigbeeRCP)"]
		ZigbeePCLight[ZigbeePC]
	end
	subgraph Dimmer["Dimmer (ZigbeeRCP)"]
		ZigbeePCDimmer[ZigbeePC]
	end

	SW1 <--> |UCL over TCPIP|ZwavePC
	SW1 <--> |UCL over TCPIP|ZigbeePC
	SW1 <--> |UCL over TCPIP|AoxPC

	ZigbeeRCPHost1 <--> |UCL over Zigbee|ZigbeePCLight
	ZigbeeRCP<-->|UCL over Zigbee|ZigbeePCDimmer

	class Unify SkyBlue
	class UnifyHost1 SkyBlue
```

# 2. [UnifySDK](https://github.com/SiliconLabs/UnifySDK)

> This SDK contains non-embedded applications developed by Silicon Labs. The Host SDK is the main source for Silicon Labs customers who are working with Linux based applications in conjunction with Silicon Labs products.

## 2.1. [Unify Framework](https://siliconlabs.github.io/UnifySDK/doc/UnifySDK.html) == Unified IoT Controller (UIC)

>A powerful IoT gateway framework that supports multiple wireless protocols.
>
>從圖中可以知道，使用都開發之軟體，必需透過 MQTT 與 ZPC, ZigPC, AoXPC 溝通。
>

![unify_host_sdk_framework](./images/unify_host_sdk_framework.png)

### 2.1.1. UCL and MQTT

> Silicon 是把MQTT當成 IPC在用。感覺有點大材小用，不知他們的軟體工程師有沒有考慮到多個電腦或是多個設備之間也會存在 MQTT，這樣不是就得 register Broker*n。
>

```mermaid
flowchart LR
	subgraph PC1
		HelloSW <--> |UCL|MQTT 
		MQTT <--> |UCL|ZPC 
		MQTT <--> |UCL|ZigPC
	end
```
#### A. MQTT * n, ???

```mermaid
flowchart LR
	subgraph PC1
		transleter1 <--> |UCL|MQTT1 
		MQTT1 <--> |UCL|ZPC1 
		MQTT1 <--> |UCL|ZigPC1
	end
	subgraph PC2
		transleter2 <--> |UCL|MQTT2 
		MQTT2 <--> |UCL|ZPC2 
		MQTT2 <--> |UCL|ZigPC2
	end

	MQTT-Lanka <--> | JSON-Lanka | deviceA
  MQTT-Lanka <--> | JSON-Lanka | deviceB
	MQTT-Lanka <--> | JSON-Lanka | transleter1
	MQTT-Lanka <--> | JSON-Lanka | transleter2
```

### 2.1.2. Protocol Controller (Hardware Controller)

> An MQTT client that controls a PHY Radio and translates commands between the UCL and the native language of that PHY. Also known as a PHY Translator.
>
> 這邊可以想像 BlueZ 控制 Bluetooth module or Bluetooth dongle。(這邊說個題外話，目前同一台電腦只能驅動一組 Bluetooth；當電腦 with Bluetooth on board，再插上 Bluetooth dongle 時，有可能造成電腦混亂)

#### A. Z-Wave Protocol Controller ([ZPC User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/zpc/readme_user.html))

#### B. ZigBee Protocol Controller ([ZigPC User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/zigpc/readme_user.html))

#### C. Bluetooth Angle of Arrival/Departure Protocol Controller ([AoXPC User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/aox/applications/aoxpc/readme_user.html))

### 2.1.3. Overview of relations among Unify Applications

|                                                              | [ ZPC](https://siliconlabs.github.io/UnifySDK/applications/zpc/readme_user.md) | [ZigPC](https://siliconlabs.github.io/UnifySDK/applications/zigpc/readme_user.md) | [AoXPC](https://siliconlabs.github.io/UnifySDK/applications/aox/applications/aoxpc/readme_user.md) |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| [UPVL](https://siliconlabs.github.io/UnifySDK/applications/upvl/readme_user.md) | [x]                                                          | [x]                                                          |                                                              |
| [GMS](https://siliconlabs.github.io/UnifySDK/applications/gms/readme_user.md) | [x]                                                          | [x]                                                          |                                                              |
| [NAL](https://siliconlabs.github.io/UnifySDK/applications/nal/readme_user.md) | [x]                                                          | [x]                                                          | [x]                                                          |
| [OTA Image Provider](https://siliconlabs.github.io/UnifySDK/applications/image_provider/readme_user.md) | [x]                                                          | [x]                                                          |                                                              |
| [AoX Positioning](https://siliconlabs.github.io/UnifySDK/applications/aox/applications/positioning/readme_user.md) |                                                              |                                                              | [x]                                                          |
|                                                              |                                                              |                                                              |                                                              |
| [Dev GUI](https://siliconlabs.github.io/UnifySDK/applications/dev_ui/dev_gui/readme_user.md) | [x]                                                          | [x]                                                          | [x]                                                          |
| [UPTICap](https://siliconlabs.github.io/UnifySDK/applications/upti_cap/readme_user.md) | [x]                                                          | [x]                                                          |                                                              |
| [UPTIWriter](https://siliconlabs.github.io/UnifySDK/applications/upti_writer/readme_user.md) | [x]                                                          | [x]                                                          |                                                              |
|                                                              |                                                              |                                                              |                                                              |

### 2.1.4. Services

#### A. The Unify Framework Provisioning List ([UPVL User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/upvl/readme_user.html))

> The UPVL serves the SmartStart Provisioning list to perform SmartStart Security 2 (S2) inclusions and maintains the ucl/SmartStart MQTT topic.

#### B. The Unify Framework Group Manager ([GMS User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/gms/readme_user.html))

> GMS manages groups and bookkeeping between protocol controllers and also publishes group state changes to the ucl/by-group MQTT topic.

#### C. The Unify Name and Location service ([NAL User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/nal/readme_user.html))

> NAL is a helper MQTT component that allows for book-keeping of text names and locations that have been assigned. This functionality allows IoT Services to assign and read back a Name and a Location for each node/endpoint.

#### D. The Unify Framework OTA Image Provider  ([Image Provider User’s Guide](https://siliconlabs.github.io/UnifySDK/applications/image_provider/readme_user.html))

> OTA Image Provider announces OTA images available in OTA storage and publishes OTA binary on request.

#### E. The Unify AoX Positioning Application (AoX [Positioning](https://siliconlabs.github.io/UnifySDK/applications/aox/applications/positioning/readme_user.html) User Guide)

> AoX Positioning application reads configuration and data from AoXPCs and publishes the calculated position of asset tags in the system.

### 2.1.5. IoT Services

> An MQTT client that translates the UCL language into the API of a cloud service or locally running high-level service (e.g., Web UI). This is a translator to a cloud service, not the actual cloud service. An AWS-IoT IoT Service runs on Unify hardware and connects to AWS IoT cloud, for example.

#### A. [Developer GUI](https://siliconlabs.github.io/UnifySDK/applications/dev_ui/dev_gui/readme_user.html)

> The [Developer GUI (dev_gui)](https://siliconlabs.github.io/UnifySDK/applications/dev_ui/dev_gui/readme_user.html)  service is a graphical user interface provided for operating and provisioning IoT devices using UCL. The dev_gui can be used as a reference for basic Unify concepts, such as device provisioning and control. The user interface is provided strictly for test and demonstration purposes only and is not suitable for production.

> After a reboot the Unify Framework Developer GUI can be accessed from a browser at [http://raspberrypi.local:3080](http://raspberrypi.local:3080/).
>
> *Note* that the Unify Framework Developer GUI needs TCP access to the port 3080 and 1337 on the Raspberry Pi.

#### B. [UPTI Cap](https://siliconlabs.github.io/UnifySDK/applications/upti_cap/readme_user.html)

> UPTICap (upti_cap) is an application to communicate with Silicon Labs WSTK adapters. The adapters capture data on the debug channel and publish the captured data as MQTT messages. Application provided strictly for test and demonstration purposes only and is not suitable for production.

#### C. [UPTIWriter](https://siliconlabs.github.io/UnifySDK/applications/upti_writer/readme_user.html)

> UPTIWriter (upti_writer) is an application to receive trace packages captured with *UPTI_CAP* application and save them to a file in [Network Analyzer](https://docs.silabs.com/simplicity-studio-5-users-guide/latest/ss-5-users-guide-tools-network-analyzer/) compatible format. Application provided strictly for test and demonstration purposes only and is not suitable for production.

## 2.2. [Multiprotocol Host Software](https://siliconlabs.github.io/UnifySDK/doc/multiprotocol.html)

> A collection of host software for simultaneously running multiple protocol stacks on the host. Using a single radio co-processor, you can run Zigbee, OpenThread, and Bluetooth.
>
> 這邊最熟悉的就是 BlueZ，一般都是用 D-Bus 與之溝通。

![unify_host_sdk_multiprotocol](./images/unify_host_sdk_multiprotocol.png)

### 2.2.1. Services

#### A. [CPCd, CPC Daemon](https://siliconlabs.github.io/UnifySDK/applications/cpcd/readme_user.html)

> The key host software component at the heart of the multiprotocol architecture is a multiplexer called CPCd (Co-Processor Communication daemon). CPCd runs on the host and acts as a reliable and secure serial transport layer to the RCP over either a UART or SPI serial bus. Each protocol stack running on the host connects to CPCd in order to communicate with the RCP. For more information see the [CPCd page](https://siliconlabs.github.io/UnifySDK/applications/cpcd/readme_user.html).

#### B. [Zigbeed](https://siliconlabs.github.io/UnifySDK/applications/zigbeed/readme_user.html)

> The Zigbee protocol stack runs on the host in a daemon called zigbeed. Zigbeed communicates with an 802.15.4 stack on the RCP via the SPINEL protocol. Zigbeed connects via sockets to CPCd, which transports the SPINEL messages over the serial bus to the RCP. A Zigbee host application connects to Zigbeed via a PTY (pseudo terminal) and communicates using the EZSP protocol. Two host applications are included with the Unify Host SDK: ZigPC, and Z3Gateway. To get started running zigbeed with CPCd, see the [Multiprotocol Setup](https://siliconlabs.github.io/UnifySDK/doc/getting_started_multiprotocol_cpc.html) page.

> <font color="red">[NOTE](https://siliconlabs.github.io/UnifySDK/applications/zigbeed/readme_user.html?highlight=zigbeed+application+only+built): The Zigbeed application is only built for arm32 bit targets using Unify</font>

```mermaid
flowchart LR
	subgraph Host
		subgraph ZigbeeApp[Zigbee App]
			ZigPC
			Z3Gateway
		end
		Zigbeed
		CPCd["CPCd<br>SPINEL"]
		ZigbeeApp<-->|EZSP/ASH over PTY|Zigbeed<-->|sockets?|CPCd
	end
	subgraph RCP
		802.15.4
		Multi-PAN["Multi-PAN or<br> Multi-protocol<br>on EFR32"]
	end
	CPCd <--> |CPC over UART or SPI|RCP
```

#### C. [OTBR, OpenThread Border Router](https://siliconlabs.github.io/UnifySDK/applications/openthread_border_router/readme_user.html)

>The OpenThread Border Router (OTBR) is included in a binary Debian package with the Unify Host SDK. The version included is compiled from the GSDK with CPCd connectivity and multiprotocol capabilities enabled. It communicates to the 802.15.4 RCP using SPINEL via CPCd. It can run alongside zigbeed using the same RCP, provided both networks use the same 802.15.4 channel. To get started running OTBR with CPCd, see the [Multiprotocol Setup](https://siliconlabs.github.io/UnifySDK/doc/getting_started_multiprotocol_cpc.html) page.
>
>There are four OTBR services included in the uic-otbr package:
>- otbr-agent - service to instantiate an OpenThread networking agent
>- otbr-web - service to provide a web UI for configuration and management
>- otbr-firewall - service to implement ingress filtering rules
>- otbr-nat44 - service to allow connections to IPV4 endpoints
>
>These services can be independently controlled, or they can be started and stopped together with the top-level **uic-otbr** service.
```mermaid
flowchart LR
	subgraph Host
		OTBR["OpenThread App (OTBR)"]
		CPCd["CPCd<br>SPINEL"]
		OTBR<-->|sockets?|CPCd
	end
	subgraph RCP
		802.15.4
		Multi-PAN["Multi-PAN or<br> Multi-protocol<br>on EFR32"]
	end
	CPCd <--> |CPC over UART or SPI|RCP
```
#### D. [cpc-hci-bridge](https://siliconlabs.github.io/UnifySDK/applications/cpc-hci-bridge/readme_user.html)

> BlueZ is the official Linux Bluetooth stack. A small utility called the cpc-hci-bridge is provided to connect BlueZ to CPCd so that it can communicate to a BLE link-layer enabled RCP using the HCI protocol. For more information see the [CPC HCI Bridge page](https://siliconlabs.github.io/UnifySDK/applications/cpc-hci-bridge/readme_user.html).
```mermaid
flowchart LR
	subgraph Host
		BlueZ[BlueZ<br>Bluetooth stack]
		cpc-hci-bridge
		CPCd
		BlueZ<-->|HCI over PTY|cpc-hci-bridge<-->|sockets?|CPCd
	end
	subgraph RCP
		Multi-PAN["Multi-PAN or<br> Multi-protocol<br>on EFR32"]
	end
	CPCd <--> |CPC over UART or SPI|RCP
```

## 2.3. Target Host (RPi4 64-BIT) via USB

- [Z-Wave module](https://www.silabs.com/wireless/z-wave) flashed with Z-Wave - NCP Serial API Controller.
- [Zigbee module](https://www.silabs.com/wireless/zigbee) EFR32MG12/EFR32xG22 running NCP for Zigbee or RCP for Multiprotocol
- [Bluetooth module](https://www.silabs.com/wireless/bluetooth) EFR32xG22 running NCP Firmware for AoXPC

## 2.4. Build with Docker Image on Ubuntu (Cross Compilation)

> 官方文件使用 Docker 進行 Cross Compilation；於編譯時相依的套件並未提及，這是很大的敗筆。不知是不是忘了，還是想隱藏什麼。
>
> 因為照著文件很順利的就可以編譯完成，但是這也只是能用在 RPi4 64-BIT。

```bash
$ cd /work/codebase/UUnifySDK-ver_1.3.2/docker

# Build Docker Image
$ ./docker/build_docker.sh arm64 uic_arm64

$ docker images
REPOSITORY   TAG        IMAGE ID       CREATED          SIZE
uic_arm64    latest     df5de72bdb3b   20 minutes ago   5.7GB

$ cd /work/codebase/UnifySDK-ver_1.3.2
$ docker run -it --rm -v $PWD:$PWD -w $PWD uic_arm64:latest
$ mkdir build_xxx
$ cd build_xxx \
	&& cmake \
		-DCMAKE_TOOLCHAIN_FILE=../cmake/arm64_debian.cmake \
		-GNinja \
		..
# Build binaries
$ ninja
# Build Debian Installers (optional)
$ ninja deb

$ ls -al build_xxx/deb-packages/unify_1.3.2_arm64.zip
$ ls -al build_xxx/_CPack_Packages/Linux/DEB
```

# 3. [GeckoSDK](https://github.com/SiliconLabs/gecko_sdk/)

> The Gecko SDK (GSDK) combines Silicon Labs wireless software development kits (SDKs) and Gecko Platform into a single, integrated package. The GSDK is your primary tool for developing in the Silicon Labs IoT Software ecosystem.

## 3.1. Prebuild libraries (without Source codes)

> 請見 V.2. Prebuild libraries  of GeckoSDK

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

## I.5. Unify Specifications

- [1. Unify Architecture Overview](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter01-architecture-overview.html)
- [2. Dotdot ZCL in Unify Framework for Application Level Control](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter02-ZCL-in-uic.html)
- [3. Network Management Commands](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter03-network-management.html)
- [4. Scenario mapping to specific PHYs: Z-Wave, BLE and ZigBee](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter04-scenario-mappings.html)
- [5. Common OTA FW Update Service](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter05-common-ota.html)
- [6. Service Discovery](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter06-service-discovery.html)
- [7. Scene Cluster and the Scene Table](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter07-scenes.html)
- [8. AoX Application](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter08-aox-application.html)
- [9. Binding](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter09-binding.html)
- [10. Name and Location Service](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter10-name-and-location-service.html)
- [11. System Metrics](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter11-system-metrics.html)
- [12. Unify Applications Monitoring](https://siliconlabs.github.io/UnifySDK/doc/unify_specifications/Chapter12-unify-applications-monitoring.html)

## I.6. [AN1333: Running Zigbee, OpenThread, and Bluetooth Concurrently on a Linux Host with a Multiprotocol Co-Processo](https://www.silabs.com/documents/public/application-notes/an1333-concurrent-protocols-with-802-15-4-rcp.pdf)

## I.7. [How to Install Rust and Cargo on Ubuntu and Other Linux Distributions](https://itsfoss.com/install-rust-cargo-ubuntu-linux/)

```bash
$ export RUSTUP_HOME=/opt/rustup-home
$ export CARGO_HOME=/opt/cargo-home

$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# reconnect
$ rustup default stable

```

```bash
# Removing Rust installed the official way
$ rustup self uninstall

```

## I.8. [Rust 程式設計語言](https://rust-lang.tw/book-tw/title-page.html)

# II. Debug

# III. Glossary

#### AGI, 

> Association Group Information

#### AoX,
> Common name for the Angle of Arrival/Departure direction finding technologies

#### CPC-D, CPC Daemon

> The Co-Processor Daemon (CPCd) enables users to have multiple stack protocols interact with a secondary processor over a shared physical link using multiple endpoints.

#### DRL, Device Reset Locally

> 

#### EndPointID, Endpoint

>Endpoints are sub-addresses in unsigned integers of a UNID. Devices without PAN-side support for endpoints use ep0.

#### EZSP, EmberZNet Serial Protocol

>[ChatGPT] 什麼是 EZSP
>
>**EZSP（EmberZNet Serial Protocol）** 是 Silicon Labs（原 Ember）為其 Zigbee 無線網絡產品開發的一種串行通信協議。EZSP 用於主處理器和 Zigbee 網絡協處理器（NCP）之間的通信，讓主處理器能夠控制和管理 Zigbee 網絡，而不用自己處理複雜的 Zigbee 協議棧。
>
>簡單來說，**EZSP** 是一個通訊接口協議，使主處理器可以通過串行接口（如 UART 或 SPI）與 Silicon Labs 的 Zigbee 協處理器通信。
>
>### 1. **EZSP 的作用**：
>
>- **Zigbee 控制**：EZSP 為主處理器提供了一種簡單的方法來控制 Zigbee 協處理器（通常是 Silicon Labs 的芯片）。這意味著主處理器只需要專注於應用邏輯，而 Zigbee 協議棧的處理全部由協處理器負責。
>- **協議棧抽象**：EZSP 提供了對 Zigbee 協議棧的抽象，主處理器可以通過 EZSP 協議發送命令來啟動網絡、加入網絡、管理設備以及處理數據傳輸，而無需了解 Zigbee 協議棧的內部實現。
>- **簡化開發**：使用 EZSP 的系統能夠簡化開發，因為開發者不需要將完整的 Zigbee 協議棧運行在主處理器上，而是通過串行協議來進行操作。這對於嵌入式設備尤其有利，因為 Zigbee 協議棧的複雜性和資源需求可能超過主處理器的能力。
>
>### 2. **EZSP 的工作方式**：
>
>- **串行通信**：EZSP 通過串行通信接口（如 UART 或 SPI）進行操作，主處理器和 Zigbee 協處理器通過這種接口互相發送命令和接收回應。
>- **命令與回應**：EZSP 通過一組命令和回應結構來進行通信。主處理器發送 EZSP 命令來執行各種操作，如啟動 Zigbee 網絡、發送數據或管理設備，協處理器則回應相應的結果或數據。
>- **API 抽象層**：EZSP 定義了一組 API，這些 API 允許開發者訪問和控制協處理器上的 Zigbee 協議棧功能。這些 API 涵蓋了網絡管理、設備控制、數據傳輸等常見操作。
>
>### 3. **EZSP 的主要功能**：
>
>- **網絡管理**：EZSP 允許主處理器啟動和關閉 Zigbee 網絡，配置網絡參數，以及管理網絡中的設備和路由表。
>- **設備控制**：主處理器可以使用 EZSP 來控制網絡中的設備，加入或移除設備，設置設備的角色和屬性等。
>- **數據傳輸**：EZSP 支持通過 Zigbee 網絡發送和接收數據包。它允許應用程序在不同的 Zigbee 節點之間進行數據通信。
>- **安全**：EZSP 提供對 Zigbee 協議中的加密和安全功能的支持，保證網絡中的通信安全。
>
>### 4. **EZSP 的應用場景**：
>
>- **智能家居設備**：EZSP 常用於智能家居設備中，例如智能燈具、門鎖、溫控器等，這些設備通常需要 Zigbee 來進行無線通信。
>- **物聯網網關**：許多物聯網網關使用 EZSP 來與 Zigbee 協處理器通信，以實現與 Zigbee 網絡的連接和控制。
>- **工業自動化**：在工業自動化系統中，EZSP 用於控制 Zigbee 無線網絡中的傳感器和控制器。
>
>### 5. **EZSP 與 Spinel 的對比**：
>
>- **Spinel 協議**：Spinel 是另一種用於主處理器與協處理器之間的通信協議，主要應用於 Thread 網絡。
>- **EZSP 協議**：EZSP 是專為 Zigbee 設計的協議，專注於 Zigbee 網絡的控制和數據傳輸。
>- 兩者的主要區別在於支持的無線網絡技術不同，EZSP 用於 Zigbee，而 Spinel 用於 Thread。
>
>### 總結
>
>**EZSP（EmberZNet Serial Protocol）** 是一個用於主處理器與 Zigbee 協處理器之間的串行通信協議，簡化了對 Zigbee 網絡的控制和管理。它適合物聯網和智能家居等應用場景，幫助開發者輕鬆地控制 Zigbee 設備，而不需要深入了解 Zigbee 協議棧的細節。

#### GMS, Group Management Service

> Group Management Service

#### GW, Gateway

> An IP host connecting two different domains. A Unify Gateway consists of the Unify components and SDK installed on an IP host providing OS functionality and hardware support.

#### Gecko Platform

> 一般我們稱公板為 Board - Gecko Board。也就是 Silicon 的開發公板，名字稱為 Gecko 壁虎。

#### IPC, Inter Process Communication

> 這邊的 IPC 是程序間通訊的機制。不是工業電腦。

#### [NCP, Network Co-Processor](https://openthread.io/platforms/co-processor#network_co-processor_ncp)

> Network Co-processor, eg. a radio connected via USB, which handles PHY/MAC and routing

> [ChatGPT] 什麼是 Network Co-Processor (NCP)
>
> **Network Co-Processor (NCP)** 是指一個專門處理網絡通信任務的處理器，通常用於減輕主處理器的負擔。它獨立於主處理器，專門負責管理網絡協議棧和處理相關的網絡通信，特別是在物聯網 (IoT) 設備中，NCP 被廣泛應用來處理 Zigbee、Thread 或其他無線網絡協議。
>
> ### 1. **NCP 的功能**：
>    - **網絡協議棧處理**：NCP 處理整個網絡協議棧的運行，例如 Zigbee、Thread 或 Bluetooth 等無線網絡協議，主處理器只需要通過簡單的指令與 NCP 交互，而不需要直接處理複雜的網絡協議。
>    - **減輕主處理器負擔**：NCP 幫助將網絡通信的計算和管理工作從主處理器中解放出來，這樣主處理器可以專注於應用層的邏輯處理，如用戶交互或數據處理。
>    - **實現低功耗和高效運行**：NCP 通常在低功耗無線網絡中運行，其設計通常考慮了節能和高效運行，這對於物聯網應用尤其重要。
>
> ### 2. **NCP 的工作原理**：
>    - **主從架構**：NCP 以主從架構運行，主處理器作為主設備，通過串行協議（如 UART 或 SPI）與 NCP 通信。NCP 作為從設備，負責處理所有網絡相關的任務。
>    - **協議接口**：主處理器通過如 EZSP（EmberZNet Serial Protocol）或 Spinel 這樣的協議與 NCP 交互，這些協議用於發送命令、配置網絡參數、傳輸數據和接收回應。
>    - **獨立運行**：NCP 可以獨立運行網絡協議棧，處理網絡的建立、管理、路由等任務。這包括啟動無線網絡、處理設備加入或退出網絡、管理路由表以及處理數據包。
>
> ### 3. **NCP 的應用場景**：
>    - **物聯網 (IoT)**：在 IoT 設備中，NCP 常用來處理 Zigbee、Thread 或 Bluetooth 的通信，這樣主處理器可以專注於應用邏輯和設備控制，而不需要處理複雜的網絡協議。
>    - **智能家居設備**：NCP 常見於智能家居設備中，如智能燈泡、智能插座、溫控器等，這些設備通常需要高效的網絡通信以實現智能控制。
>    - **工業自動化**：在工業環境中，NCP 用於處理無線傳感器網絡中的通信，實現設備之間的數據交換和遠程監控。
>
> ### 4. **NCP vs. SoC（System on Chip）**：
>    - **NCP（Network Co-Processor）**：NCP 只負責處理網絡通信，而不處理應用層的邏輯。主處理器通過與 NCP 通信來控制網絡功能。
>    - **SoC（System on Chip）**：SoC 是一種集成了處理器、存儲器和網絡通信功能於一體的芯片。與 NCP 不同，SoC 可以同時處理應用邏輯和網絡協議棧，因此在某些簡單的應用場景下，SoC 可能不需要獨立的 NCP。
>
> ### 5. **NCP 的優點**：
>    - **分擔工作量**：通過使用 NCP，主處理器不必處理複雜的網絡協議，可以專注於應用層任務，從而提升整體系統的效率。
>    - **簡化開發**：NCP 的使用簡化了開發流程，開發者可以利用 NCP 提供的標準接口與網絡進行通信，而不需要掌握完整的網絡協議。
>    - **可擴展性**：使用 NCP 的系統更具可擴展性，開發者可以隨時升級或更換 NCP 來支持新的網絡協議或技術，而不必大幅修改主處理器的代碼。
>
> ### 總結
> **Network Co-Processor (NCP)** 是一種專門處理網絡協議棧和無線通信的協處理器，常用於物聯網設備中，特別是低功耗無線網絡如 Zigbee 和 Thread。NCP 幫助減輕主處理器的負擔，使其專注於應用邏輯，同時確保網絡通信的高效運行和低功耗需求。

#### NIF,

> Node Information Frame

#### NWK, Network layer

>[ChatGPT] 什麼是 NWK (Network layer) 
>
>**NWK（Network Layer，網絡層）** 是 **Zigbee 協議棧**中的一個層級，負責設備之間的網絡通信、路由、地址分配等功能。它是 Zigbee 通信協議中的一個關鍵組成部分，位於 MAC 層（數據鏈路層）之上，應用層之下。
>
>### 1. **NWK 層的作用**：
>   - **路由功能**：NWK 層的主要功能之一是確保數據在 Zigbee 網絡中的不同設備間有效傳輸。它負責決定數據包應該通過哪條路徑到達目標設備。在網狀網絡（Mesh Network）中，這一功能尤其重要，因為網絡中的節點可能並不直接相鄰，數據包需要通過其他節點進行轉發。
>   - **地址分配**：NWK 層負責為網絡中的每個節點分配網絡地址。每個設備在加入 Zigbee 網絡時，NWK 層會分配一個唯一的網絡地址，用於識別和通信。
>   - **設備加入與離開網絡**：NWK 層管理設備如何加入或離開網絡，處理加入請求、分配地址、更新路由信息等。
>   - **安全**：NWK 層支持網絡安全功能，包括加密數據傳輸，防止未授權的設備加入網絡。
>
>### 2. **NWK 層的主要功能**：
>   - **路由發現**：當網絡中的一個節點想要與另一個節點通信時，NWK 層負責發現合適的路徑。這包括使用路由發現協議來查找數據包應該通過哪些節點進行轉發。
>   - **路由維護**：隨著網絡拓撲的變化（如設備加入或移除），NWK 層會更新和維護網絡中的路由信息，以確保路由的有效性。
>   - **數據傳輸**：NWK 層管理來自應用層的數據包，將它們進行封裝並發送到目標設備，確保數據能夠跨越網絡層進行有效傳遞。
>   - **重傳與錯誤處理**：如果數據包在傳輸過程中丟失，NWK 層可以進行重傳，並提供相應的錯誤處理機制，確保數據的可靠傳輸。
>
>### 3. **NWK 層的組件**：
>   - **網絡地址（Network Address）**：NWK 層為每個加入網絡的節點分配一個 16 位的網絡地址。這個地址與節點的 MAC 地址不同，是網絡中進行數據傳輸的依據。
>   - **路由表（Routing Table）**：NWK 層維護一個路由表，這個表格記錄了網絡中的各個節點及其路由信息，用來確定數據包的傳輸路徑。
>   - **路由發現與維護**：NWK 層負責發現和維護網絡中的路由。當節點之間無法直接通信時，它會發起路由發現過程，找出數據包的最佳傳輸路徑。
>
>### 4. **Zigbee NWK 層的通信過程**：
>   - 當應用層需要發送數據時，數據會被傳送到 NWK 層進行處理。
>   - NWK 層將數據進行封裝，並使用網絡地址來確定目標節點。
>   - 如果目標節點不在直接通信範圍內，NWK 層將使用路由機制通過其他節點轉發數據。
>   - 數據被傳送到目標設備後，NWK 層將數據解封裝並傳送到應用層。
>
>### 5. **Zigbee 的網狀網絡 (Mesh Network)**：
>   - **Mesh Network** 是 Zigbee 中一個重要的特性，NWK 層在這裡發揮了核心作用。在 Mesh 網絡中，每個節點都可以充當中繼節點，協助轉發數據包，從而增加網絡的覆蓋範圍和可靠性。
>   - NWK 層的路由發現和維護功能確保了網絡中不同節點之間的通信，即使某些節點處於無法直接通信的範圍內。
>
>### 6. **NWK 層與其他層的關係**：
>   - **應用層（Application Layer）**：應用層負責處理用戶數據，當應用層生成數據包後，會將它們傳遞給 NWK 層進行路由和轉發。
>   - **MAC 層（Medium Access Control Layer）**：MAC 層負責在物理介質上進行數據傳輸，NWK 層將封裝好的數據包交給 MAC 層，後者通過無線通信介質將數據發送出去。
>
>### 總結
>**NWK（Network Layer）** 是 Zigbee 協議棧中的關鍵層，負責路由、設備管理、地址分配和數據傳輸。它在 Zigbee 的網狀網絡結構中發揮了核心作用，確保設備之間的數據包能夠可靠地通過網絡進行傳輸和交換。 NWK 層的高效管理和路由機制使得 Zigbee 網絡在物聯網和智能家居應用中具有強大的擴展性和可靠性。

#### PAN, Personal Area Network

> The network of end nodes behind a PHY Radio controlled by Unify.

#### PHY, Port Physical Layer

> [維基百科] [PHY](https://zh.wikipedia.org/zh-tw/PHY)
>
> PHY連接一個[數據鏈路層](https://zh.wikipedia.org/wiki/数据链路层)的裝置（[MAC](https://zh.wikipedia.org/wiki/媒體存取控制)）到一個物理媒介，如光纖或銅纜線。典型的PHY包括PCS（Physical Coding Sublayer，物理編碼子層）和PMD（Physical Media Dependent，物理介質相關子層）。PCS對被傳送和接受的資訊加碼和解碼，目的是使接收器更容易恢復訊號。

#### pts, Pseudo Terminal Slave

>[ChatGPT] 什麼是 pts
>
>### **PTS（Pseudo Terminal Slave）** - 在 Linux/Unix 系統中的含義：
>
>- 在 Linux/Unix 系統中，PTS（Pseudo Terminal Slave）是一種虛擬終端設備。當你在系統中打開一個新的終端會話（例如通過 SSH 連接到遠程伺服器或在圖形界面中打開一個新的終端窗口）時，系統會分配一個虛擬終端設備，這個設備以 `/dev/pts/X` 的形式出現，這裡的 X 是一個數字，表示該虛擬終端的編號。
>- PTS 與 **PTM（Pseudo Terminal Master）** 一起工作。當你在系統中與終端進行交互時，PTM 負責管理輸入/輸出的流量，PTS 負責實際執行命令並返回結果。
>- **使用場景**：例如，在 SSH 會話或多個終端窗口中，每個會話都有一個獨立的 PTS 來處理它的輸入和輸出。你可以使用 `who` 或 `w` 命令查看當前系統上哪些用戶通過哪些 PTS 進行操作。

#### pty, Pseudo Terminal

>[ChatGPT]  什麼是 pty (Pseudo Terminal)
>
>**PTY（Pseudo Terminal，虛擬終端）** 是一種模擬終端設備的機制，常用於 Unix 和 Linux 系統中。它允許用戶程序與另一個程序進行交互，就像使用真實終端一樣。通過 PTY，系統可以將一個應用程序的輸入和輸出與另一個程序連接，通常應用於命令行工具、遠程訪問（如 SSH）、終端模擬器等場景。
>
>### 1. **PTY 的基本概念**：
>   - **實際終端（Terminal）**：物理終端設備通常指鍵盤和顯示器的組合，用於與計算機交互。在現代計算機中，物理終端已被虛擬終端所取代。
>   - **虛擬終端（Virtual Terminal）**：模擬物理終端，允許用戶在一個軟件窗口中與系統進行交互。例如，Linux 的 `tty` 是一個典型的終端設備，它讓用戶與 shell 互動。
>   - **Pseudo Terminal（PTY）**：Pseudo Terminal 是一種虛擬設備，模擬一個終端設備的行為。它由兩部分組成：**主設備（Master）** 和 **從設備（Slave）**。主設備通常由程序控制，從設備則由應用程序使用。
>
>### 2. **PTY 的組成與運作**：
>   - **主端（Master）**：主端是一個由操作系統創建的終端接口，通常由控制終端的程序使用。例如，SSH 伺服器或終端模擬器會打開主端。
>   - **從端（Slave）**：從端看起來像一個普通的終端設備，運行在從端的應用程序認為它正與一個真實終端交互，但實際上它與主端程序相連。
>
>   當應用程序向從端發送輸入時，主端能夠接收到該輸入，並將它轉發給控制應用程序；同樣，控制應用程序的輸出也能通過主端發送回從端。這樣，虛擬終端就能模擬實際終端的功能。
>
>### 3. **PTY 的應用場景**：
>   - **終端模擬器**：如 GNOME Terminal、xterm 等終端模擬器使用 PTY 來與 shell 交互。當你在終端中輸入命令時，這些命令通過 PTY 被傳遞給 shell 來處理，然後輸出結果顯示在終端上。
>   - **SSH**：SSH 客戶端和伺服器使用 PTY 來模擬遠程終端。當用戶通過 SSH 連接到遠程計算機時，本地 SSH 客戶端通過 PTY 將用戶的輸入發送到遠程系統，並將遠程系統的輸出顯示在本地終端。
>   - **腳本與自動化工具**：一些自動化工具或腳本會使用 PTY 來模擬用戶的終端操作，這樣它們就可以自動化執行一些需要用戶輸入的命令或交互操作。
>   - **容器與虛擬化**：在容器（如 Docker）或虛擬化環境中，PTY 也經常被用於模擬與內部環境的終端交互。
>
>### 4. **PTY 的工作原理**：
>   1. **創建 PTY**：系統創建一對虛擬終端設備（主端和從端），並分配給需要模擬終端的應用程序。
>   2. **應用程序與 PTY 交互**：主端程序（如終端模擬器或 SSH 伺服器）控制主端，從端則交由需要交互的程序（如 shell 或命令行工具）來使用。
>   3. **數據傳輸**：當用戶在終端輸入命令時，這些輸入通過主端被轉發給從端程序，從端程序的輸出則被發送回主端並顯示在用戶的終端上。
>
>### 5. **常見命令與 PTY**：
>   - `tty`：顯示當前終端的文件名（例如 `/dev/pts/1`），這是系統中使用 PTY 的虛擬終端。
>   - `script`：這個命令可以通過使用 PTY 來錄製終端會話，將用戶的輸入和輸出記錄下來。
>
>### 6. **實際用途中的例子**：
>   - **多用戶環境**：在多用戶系統中，許多不同的用戶會同時打開各自的終端會話，每個會話都對應一個 PTY。這樣，系統可以同時處理多個終端請求，而不需要為每個用戶提供物理終端。
>   - **SSH 連接**：當你通過 SSH 連接遠程伺服器時，系統在遠端創建一個 PTY，這樣你就可以像在本地終端一樣操作遠端伺服器。
>
>### 總結
>**PTY（Pseudo Terminal）** 是一種虛擬終端技術，模擬真實終端的行為，並用於程序之間的交互。它在終端模擬器、SSH、腳本自動化等許多場景中廣泛應用，通過主從架構實現程序與終端之間的通信，使得現代操作系統中的命令行交互變得更加靈活和高效。

#### [RCP, Radio Co-Processor](https://openthread.io/platforms/co-processor#radio_co-processor_rcp) 

>The RCP (Radio Co-Processor) is an embedded application running on a Silicon Labs EFR32 radio chip connected to the host processor via a UART or SPI serial connection. There are different flavors of RCP depending on which protocol stacks are running on the host. The RCP software is distributed with the GSDK. For details on building RCP images for the co-processor, see [AN1333](https://www.silabs.com/documents/public/application-notes/an1333-concurrent-protocols-with-802-15-4-rcp.pdf).

>[ChatGPT] 什麼是 RCP (Radio Co-Processor)
>
>**RCP（Radio Co-Processor，無線協同處理器）** 是一種專門負責無線通信任務的協同處理器，通常與主處理器（Host Processor）協同工作，主要用於處理物聯網（IoT）設備中的無線通信協議。RCP 的設計目的是將無線通信相關的工作從主處理器卸載，以減少主處理器的負擔，提高系統效率和性能。
>
>### 1. **RCP 的工作原理**：
>   - **主處理器與 RCP 的分工**：主處理器負責運行應用層的邏輯和高層次協議，而 RCP 則專門處理低層的無線通信協議，如 PHY（物理層）和 MAC（介質訪問控制層）。這樣的設計允許主處理器專注於應用層，無需關注無線通信的細節。
>   - **通信協議處理**：RCP 通常負責物聯網協議棧中與無線通信相關的部分，例如 IEEE 802.15.4、Thread、Zigbee、BLE（藍牙低功耗）等無線協議的實現。這些協議涉及到的頻譜調度、信道訪問、數據加密和解密等任務都由 RCP 處理。
>
>### 2. **RCP 的應用場景**：
>   - **物聯網設備**：在物聯網設備中，RCP 可以專門處理設備之間的無線通信，這對於低功耗、低帶寬的網絡尤為重要。例如，智能家居設備、傳感器節點、工業自動化設備等。
>   - **Mesh 網絡**：RCP 支持 Mesh 網絡協議，如 Zigbee 和 Thread，它們允許多個設備在無需中央控制器的情況下相互通信。RCP 處理數據包的路由和轉發，從而支持分佈式網絡架構。
>   - **協同處理**：由於 RCP 專門處理無線通信任務，主處理器可以釋放資源，處理更高層次的任務或運行低功耗模式，延長設備的電池壽命。
>
>### 3. **RCP 與 NCP 的區別**：
>   RCP 和 **NCP（Network Co-Processor，網絡協同處理器）** 的概念相似，兩者都是協同處理器，但它們的分工有所不同：
>   - **RCP（Radio Co-Processor）**：專注於處理無線通信協議的物理層和數據鏈路層，負責無線數據的發送與接收。
>   - **NCP（Network Co-Processor）**：不僅處理無線通信協議的低層，還可能處理部分網絡層或應用層的任務，對整個協議棧進行更全面的支持。
>
>### 4. **RCP 的優勢**：
>   - **功耗低**：RCP 通常設計為低功耗芯片，適合物聯網中長時間運行的設備，特別是在電池供電的場景中，減少了系統的總功耗。
>   - **專業化通信處理**：RCP 專門針對無線通信設計，能夠提高通信效率，減少主處理器的運算負擔，從而提高系統的整體性能。
>   - **簡化設計**：通過使用 RCP，設計者可以將複雜的無線通信協議處理卸載到協同處理器，簡化主處理器的設計和開發工作。
>
>### 5. **RCP 相關技術與協議**：
>   - **IEEE 802.15.4**：這是一種針對低速率無線個人區域網絡（LR-WPAN）的標準，常用於 Zigbee 和 Thread 協議中，RCP 通常負責該標準的物理層和 MAC 層處理。
>   - **Thread**：一種基於 IP 的 Mesh 網絡協議，廣泛應用於物聯網設備中，RCP 能夠處理 Thread 協議中的路由、尋址等任務。
>   - **Zigbee**：Zigbee 是一種低功耗、低數據速率的無線通信技術，RCP 在 Zigbee 網絡中負責數據的發送和接收，以及處理網絡的拓撲結構。
>
>### 總結
>**RCP（Radio Co-Processor）** 是一種專門處理無線通信的協同處理器，常用於物聯網設備中。它負責物理層和數據鏈路層的無線通信協議處理，從而減輕主處理器的負擔，提升系統的效率和功耗表現。RCP 在低功耗、Mesh 網絡的物聯網應用中有著廣泛的應用，如 Thread、Zigbee 和 BLE 等協議。

#### Spinel,

>[ChatGPT] 什麼是 Spinel 通信協議
>
>**Spinel 通信協議** 是一種為低功耗無線網絡（特別是針對物聯網 IoT 設備）設計的通訊協議，主要應用於 **Thread 網絡**。它是用來在 **NCP（Network Co-Processor，網絡協處理器）** 和 **主機處理器** 之間進行數據交換的協議。
>
>Thread 網絡是一種基於 IPv6 的低功耗無線通信協議，用於智能家居、智能設備和其他物聯網應用中，Spinel 協議的設計目的是簡化主機和 NCP 之間的通信，並提供輕量且高效的數據傳輸。
>
>### 1. **Spinel 通信協議的用途**：
>
>- **NCP 與主機之間的通信**：Spinel 用於在 Thread 網絡中的 **NCP（如微控制器或無線模塊）** 和主機處理器（如 Raspberry Pi 或嵌入式系統）之間建立通信鏈路。這樣的設置常見於利用外部協處理器來處理網絡協議棧的 IoT 設備中。
>- **管理和控制**：Spinel 協議被用來傳遞各種控制命令和數據，如設置網絡參數、處理數據包、啟動或停止網絡服務等。它能有效地管理網絡中的節點以及進行節點之間的數據傳輸。
>
>### 2. **Spinel 協議的特點**：
>
>- **輕量級**：Spinel 協議設計非常輕量，適合在資源有限的低功耗無線網絡中使用。它旨在最大限度地降低處理器和內存的消耗。
>- **靈活性**：協議能靈活地適應不同的設備配置，支持多種命令類型和參數設置。
>- **易於擴展**：Spinel 的設計考慮了擴展性，能夠根據需求輕鬆添加新功能和命令，這使得它能隨著技術的發展而進行調整。
>
>### 3. **Spinel 的工作原理**：
>
>- **數據包格式**：Spinel 定義了一種數據包格式，用於在主機和 NCP 之間進行消息的編碼和解碼。數據包包括一個命令 ID、屬性和值，用於進行特定的操作或設置參數。
>- **命令與屬性**：Spinel 使用命令來觸發具體的行動，如啟動網絡或發送數據。每個命令都可以攜帶屬性，這些屬性可以是網絡狀態、節點信息、路由表等。
>- **雙向通信**：Spinel 協議支持主機和 NCP 之間的雙向通信，既可以從主機向 NCP 發送控制命令，也可以從 NCP 回傳狀態和數據給主機。
>
>### 4. **應用場景**：
>
>- **智能家居設備**：Spinel 通常用於需要 Thread 網絡支持的智能家居設備中，例如智能燈具、溫控器、門鎖等。
>- **物聯網應用**：Spinel 被設計為適合在低功耗和低延遲需求的物聯網環境中使用。它允許 IoT 設備以高效、節能的方式與網絡進行通信。
>- **分離協處理器架構**：Spinel 使主處理器可以專注於應用層邏輯，而將網絡協議棧的處理委託給 NCP，從而提高系統的整體性能和穩定性。
>
>### 5. **Spinel 協議與 Thread 的關聯**：
>
>- Thread 是一個用於網狀網絡（Mesh Network）的低功耗、基於 IP 的通信協議，主要針對家庭自動化和其他 IoT 應用設計。
>- Spinel 協議作為 Thread 網絡中 NCP 與主機之間的通信橋樑，使得主機可以通過 NCP 控制和管理 Thread 網絡中的設備和數據流量。
>
>### 總結
>
>**Spinel 通信協議** 是一種為低功耗無線網絡設計的高效協議，主要應用於 Thread 網絡中的 NCP 和主機之間的數據交換。它輕量、靈活且易於擴展，適合物聯網應用中的低功耗場景。

#### tty, Teletypewriter

>[ChatGPT] 什麼是 tty (Teletypewriter)
>
>**TTY（Teletypewriter，電傳打字機）** 原本是一種物理設備，用於通過電信線路進行文本通信。在計算機術語中，TTY 指的是終端接口，現代計算機系統使用虛擬的 TTY 來模擬這種終端設備，允許用戶與系統進行文本交互。
>
>### 1. **TTY 的歷史背景**：
>   - **Teletypewriter**（電傳打字機）最初是一種機械設備，用於遠程通信。它通過打字機和電報系統進行消息的輸入和輸出。
>   - 這些設備後來演變成計算機終端，允許用戶與大型計算機進行交互，最早的計算機終端就是基於 TTY 設計的。
>   - 隨著技術發展，物理的 TTY 設備逐漸被軟件模擬的虛擬終端取代，但名稱 TTY 在 Unix 和 Linux 系統中一直沿用至今，作為表示終端接口的代名詞。
>
>### 2. **TTY 在現代系統中的意義**：
>   - **物理 TTY**：指早期的物理終端，如鍵盤和顯示器，它們與主機通過串行線路連接。
>   - **虛擬 TTY**：現代計算機中，TTY 被模擬為虛擬終端。這些虛擬終端允許用戶使用命令行界面與操作系統交互，而不需要物理終端設備。
>
>### 3. **Linux 和 Unix 系統中的 TTY**：
>   在 Linux 和 Unix 系統中，TTY 代表終端設備的抽象，這些終端可以是：
>   - **物理終端**：如在服務器上通過串口連接的控制台終端。
>   - **虛擬終端（Virtual Terminal）**：現代 Linux 系統提供多個虛擬控制台，通常可以通過 `Ctrl + Alt + F1` 到 `Ctrl + Alt + F7` 等組合鍵在不同的虛擬終端間切換，每個虛擬終端都模擬一個獨立的會話。
>   - **模擬終端**：如 GNOME Terminal、xterm 等終端模擬器，它們模擬了 TTY 的行為，允許用戶在圖形界面中打開多個終端會話。
>
>### 4. **TTY 類型**：
>   - **串行終端（Serial TTY）**：通過串行連接的實際物理終端設備。
>   - **虛擬控制台（Virtual Console TTY）**：如 `/dev/tty1` 到 `/dev/tty7`，這些是內建的虛擬終端，可以通過鍵盤快捷鍵切換。
>   - **虛擬終端設備（Pseudo TTY，PTY）**：如 `/dev/pts/1`，這是模擬終端的設備，通常用於終端模擬器和遠程連接（如 SSH）。
>
>### 5. **TTY 的應用**：
>   - **本地終端**：當你在 Linux 系統上登錄時，你可能會使用某個虛擬終端（如 `/dev/tty1`），這是一個標準的 TTY 設備，用於接收輸入和顯示輸出。
>   - **遠程終端**：當通過 SSH 連接到一台遠程伺服器時，伺服器會為這個連接分配一個虛擬的 PTY（Pseudo TTY），這樣用戶可以遠程執行命令並獲得輸出。
>
>### 6. **TTY 相關的命令**：
>   - **`tty`**：這個命令顯示當前終端的名稱。例如，在一個終端中輸入 `tty`，系統會返回當前終端的設備路徑，如 `/dev/tty1` 或 `/dev/pts/1`。
>   - **`stty`**：這個命令用於修改和顯示終端設置，可以控制終端行為，如輸入回顯、行編輯、特殊字符處理等。
>
>### 7. **TTY 和 SSH**：
>   當你使用 SSH 連接遠程主機時，伺服器會創建一個 PTY（Pseudo TTY），模擬一個終端，允許你遠程執行命令。這使得即使不在本地，你仍然可以使用 TTY 與遠程系統進行交互。
>
>### 8. **TTY 在現代環境中的角色**：
>   雖然物理的電傳打字機已經不再使用，但 TTY 這個術語仍然非常重要，特別是在 Unix/Linux 系統中。無論是通過本地虛擬控制台還是遠程 SSH 會話，TTY 都是終端交互的核心。
>
>### 總結
>**TTY（Teletypewriter）** 最初是物理設備，用於早期的遠程文本通信。現在，它作為一個術語，代表了 Unix/Linux 系統中的終端設備或終端接口。無論是本地的虛擬終端還是遠程的終端模擬器，TTY 是用戶與計算機進行命令行交互的重要組件。

#### UAM,

> Unified Attribute Mapping: Filename for the Attribute Mapper language

#### UCL, Unify Controller Language

> The unified command language used as an internal abstraction layer in the Unify Framework.
>
> Silicon 自創的交換格式。
> 基本上我不是把 MQTT 的資料稱為 Language，比較準確的說是資料格式。

#### UIC, Unify IoT Controller
> Old name of the Unify Framework

#### UNID, Unified Node Identifier

>A unified addressing system with a separate sub-namespace for each PHY supported by the Unify Framework. It is a string that uniquely represents a PAN node.

#### Unify, Unify Framework

> The system whose design is described here. Formerly known as Unified IoT  Controller (UIC).

#### UPVL, Unify Provisioning List

>

#### XXX Gecko XXX Microcontroller

> 就是Silicon 的 Gecko 模組。

#### (Z-Wave) LR, (Z-Wave) Long Range

>

# IV. Tool Usage

## IV.1. 
# V. Info

## V.1. dpkg -c *.deb (unify_1.3.2_arm64.zip)

```bash
$
dpkg -c libunify_1.3.2_arm64.deb
dpkg -c libunify-dev_1.3.2_arm64.deb
dpkg -c uic-aoxpc_1.3.2_arm64.deb
dpkg -c uic-bt-host-empty_1.3.2_arm64.deb
dpkg -c uic-cpcd_1.3.2_arm64.deb
dpkg -c uic-cpc-hci-bridge_1.3.2_arm64.deb
dpkg -c uic-dev-gui_1.3.2_arm64.deb
dpkg -c uic-gms_1.3.2_arm64.deb
dpkg -c uic-image-provider_1.3.2_arm64.deb
dpkg -c uic-nal_1.3.2_arm64.deb
dpkg -c uic-otbr_1.3.2_arm64.deb
dpkg -c uic-positioning_1.3.2_arm64.deb
dpkg -c uic-upti-cap_1.3.2_arm64.deb
dpkg -c uic-upti-writer_1.3.2_arm64.deb
dpkg -c uic-upvl_1.3.2_arm64.deb
dpkg -c uic-zigbeed_1.3.2_arm64.deb
dpkg -c uic-zigpc_1.3.2_arm64.deb
dpkg -c uic-zpc_1.3.2_arm64.deb


drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/lib/
-rw-r--r-- root/root 246659408 2023-06-07 18:14 ./usr/lib/libunify.so
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/libunify/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/libunify/copyright


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c libunify-dev_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/include/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/include/uic/
-rw-r--r-- root/root      9231 2023-06-07 18:05 ./usr/include/uic/sl_status.h
-rw-r--r-- root/root      2257 2023-06-07 18:05 ./usr/include/uic/uic_enum.h
-rw-r--r-- root/root      1240 2023-06-07 18:05 ./usr/include/uic/uic_version.h.in
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/lib/
-rw-r--r-- root/root 246659408 2023-06-07 18:14 ./usr/lib/libunify.so
-rw-r--r-- root/root 887490872 2023-06-07 18:14 ./usr/lib/libunify_static.a
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/libunify-dev/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/libunify-dev/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/pkgconfig/
-rw-r--r-- root/root       761 2023-06-07 18:09 ./usr/share/pkgconfig/libunify.pc
-rw-r--r-- root/root       773 2023-06-07 18:09 ./usr/share/pkgconfig/libunify_static.pc


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-aoxpc_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       221 2023-06-07 18:05 ./lib/systemd/system/uic-aoxpc.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root   2548088 2023-06-07 18:14 ./usr/bin/aoxpc
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-aoxpc/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-aoxpc/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/aoxpc/


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-bt-host-empty_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root    442088 2023-06-07 18:10 ./usr/bin/bt_host_empty
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-bt-host-empty/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-bt-host-empty/copyright


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-cpcd_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       224 2023-06-07 18:09 ./lib/systemd/system/uic-cpcd-bind.service
-rw-r--r-- root/root       383 2023-06-07 18:09 ./lib/systemd/system/uic-cpcd.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root   1087792 2023-06-07 18:10 ./usr/bin/cpcd
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/etc/
-rw-r--r-- root/root      3179 2023-06-07 18:07 ./usr/etc/cpcd.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/include/
-rwxr-xr-x root/root     36250 2023-06-07 18:07 ./usr/include/sl_cpc.h
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/lib/
lrwxrwxrwx root/root         0 2023-06-07 18:15 ./usr/lib/libcpc.so -> libcpc.so.3
lrwxrwxrwx root/root         0 2023-06-07 18:15 ./usr/lib/libcpc.so.3 -> libcpc.so.4.2.2.0
-rwxr-xr-x root/root    146712 2023-06-07 18:10 ./usr/lib/libcpc.so.4.2.2.0
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-cpcd/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-cpcd/copyright


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-cpc-hci-bridge_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       375 2023-06-07 18:05 ./lib/systemd/system/uic-cpc-hci-bridge.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root     26560 2023-06-07 18:14 ./usr/bin/cpc-hci-bridge
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-cpc-hci-bridge/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-cpc-hci-bridge/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/cpc-hci-bridge/


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-dev-gui_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       398 2023-06-07 18:05 ./lib/systemd/system/uic-dev-gui-api.service
-rw-r--r-- root/root       377 2023-06-07 18:05 ./lib/systemd/system/uic-dev-gui-client.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root  48089395 2023-06-07 18:13 ./usr/bin/dev-gui-api
-rwxr-xr-x root/root  75763377 2023-06-07 18:13 ./usr/bin/dev-gui-client
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-dev-gui/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-dev-gui/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/dev-gui/
-rw-r--r-- root/root      1411 2023-06-07 18:05 ./var/lib/dev-gui/cert.pem
-rw-r--r-- root/root      1704 2023-06-07 18:05 ./var/lib/dev-gui/key.pem


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-gms_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/uic-gms/
-rw-r--r-- 0/0             553 2023-06-07 18:16 usr/share/doc/uic-gms/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/system/
-rw-r--r-- 0/0             215 2023-06-07 18:16 lib/systemd/system/uic-gms.service
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/bin/
-rwxr-xr-x 0/0         9141056 2023-06-07 18:16 usr/bin/uic-gms


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-image-provider_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/uic-image-provider/
-rw-r--r-- 0/0             564 2023-06-07 18:16 usr/share/doc/uic-image-provider/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/system/
-rw-r--r-- 0/0             231 2023-06-07 18:16 lib/systemd/system/uic-image-provider.service
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/bin/
-rwxr-xr-x 0/0         8897464 2023-06-07 18:16 usr/bin/uic-image-provider


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-nal_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/uic-nal/
-rw-r--r-- 0/0             553 2023-06-07 18:16 usr/share/doc/uic-nal/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/system/
-rw-r--r-- 0/0             256 2023-06-07 18:16 lib/systemd/system/uic-nal.service
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/bin/
-rwxr-xr-x 0/0         9297176 2023-06-07 18:16 usr/bin/uic-nal


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-otbr_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/dbus-1/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/dbus-1/system.d/
-rw-r--r-- root/root       700 2023-06-07 18:09 ./etc/dbus-1/system.d/otbr-agent.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/default/
-rw-r--r-- root/root       195 2023-06-07 18:09 ./etc/default/otbr-agent
-rw-r--r-- root/root       230 2023-06-07 18:09 ./etc/default/uic-otbr
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/system/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/system/otbr-agent.service.d/
-rwxr-xr-x root/root        79 2023-06-07 18:05 ./etc/systemd/system/otbr-agent.service.d/override.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/system/otbr-firewall.service.d/
-rw-r--r-- root/root        31 2023-06-07 18:05 ./etc/systemd/system/otbr-firewall.service.d/override.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/system/otbr-nat44.service.d/
-rw-r--r-- root/root        31 2023-06-07 18:05 ./etc/systemd/system/otbr-nat44.service.d/override.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/systemd/system/otbr-web.service.d/
-rwxr-xr-x root/root       139 2023-06-07 18:05 ./etc/systemd/system/otbr-web.service.d/override.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       413 2023-06-07 18:09 ./lib/systemd/system/otbr-agent.service
-rw-r--r-- root/root       321 2023-06-07 18:09 ./lib/systemd/system/otbr-web.service
-rw-r--r-- root/root       210 2023-06-07 18:09 ./lib/systemd/system/uic-otbr.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/sbin/
-rwxr-xr-x root/root     48120 2023-06-07 18:10 ./usr/sbin/ot-ctl
-rwxr-xr-x root/root  63348616 2023-06-07 18:11 ./usr/sbin/otbr-agent
-rwxr-xr-x root/root   8973176 2023-06-07 18:11 ./usr/sbin/otbr-web
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-otbr/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-otbr/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/frontend/
-rw-r--r-- root/root     22187 2023-06-07 18:09 ./usr/share/otbr-web/frontend/index.html
-rw-r--r-- root/root      4957 2023-06-07 18:09 ./usr/share/otbr-web/frontend/join.dialog.html
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/frontend/res/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/frontend/res/css/
-rw-r--r-- root/root    324180 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/css/angular-material.min.css
-rw-r--r-- root/root    139816 2016-12-21 21:14 ./usr/share/otbr-web/frontend/res/css/material.min.css
-rw-r--r-- root/root     30325 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/css/styles.css
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/frontend/res/img/
-rw-r--r-- root/root      7861 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/android-desktop.png
-rw-r--r-- root/root    345771 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/borderrouter.png
-rw-r--r-- root/root       564 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/favicon.png
-rw-r--r-- root/root     22269 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/icon-info.png
-rw-r--r-- root/root      4639 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/ios-desktop.png
-rw-r--r-- root/root     41210 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/img/openthread_logo.png
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr-web/frontend/res/js/
-rw-r--r-- root/root     26809 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/js/angular-animate.min.js
-rw-r--r-- root/root      4203 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/js/angular-aria.min.js
-rw-r--r-- root/root    427234 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/js/angular-material.min.js
-rw-r--r-- root/root      3223 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/js/angular-messages.min.js
-rw-r--r-- root/root    177368 1985-10-26 16:15 ./usr/share/otbr-web/frontend/res/js/angular.min.js
-rw-r--r-- root/root     34768 2023-06-07 18:09 ./usr/share/otbr-web/frontend/res/js/app.js
-rw-r--r-- root/root    151725 2016-05-05 08:29 ./usr/share/otbr-web/frontend/res/js/d3.min.js
-rw-r--r-- root/root     62491 2016-12-21 21:14 ./usr/share/otbr-web/frontend/res/js/material.min.js
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr/script/
-rwxr-xr-x root/root      3828 2023-06-07 18:09 ./usr/share/otbr/script/_border_routing
-rwxr-xr-x root/root     11681 2023-06-07 18:09 ./usr/share/otbr/script/_dhcpv6_pd
-rwxr-xr-x root/root      3073 2023-06-07 18:09 ./usr/share/otbr/script/_disable_services
-rwxr-xr-x root/root      5683 2023-06-07 18:09 ./usr/share/otbr/script/_dns64
-rwxr-xr-x root/root      2753 2023-06-07 18:09 ./usr/share/otbr/script/_firewall
-rwxr-xr-x root/root      4103 2023-06-07 18:09 ./usr/share/otbr/script/_initrc
-rwxr-xr-x root/root      2321 2023-06-07 18:09 ./usr/share/otbr/script/_ipforward
-rwxr-xr-x root/root      8773 2023-06-07 18:09 ./usr/share/otbr/script/_nat64
-rwxr-xr-x root/root     11973 2023-06-07 18:09 ./usr/share/otbr/script/_network_manager
-rwxr-xr-x root/root      4834 2023-06-07 18:09 ./usr/share/otbr/script/_otbr
-rwxr-xr-x root/root      2374 2023-06-07 18:09 ./usr/share/otbr/script/_rt_tables
-rwxr-xr-x root/root      2679 2023-06-07 18:09 ./usr/share/otbr/script/_sudo_extend
-rwxr-xr-x root/root      3283 2023-06-07 18:09 ./usr/share/otbr/script/_swapfile
-rwxr-xr-x root/root      6103 2023-06-07 18:09 ./usr/share/otbr/script/bootstrap
-rwxr-xr-x root/root      1938 2023-06-07 18:09 ./usr/share/otbr/script/cibuild
-rwxr-xr-x root/root      2448 2023-06-07 18:09 ./usr/share/otbr/script/clang-format
-rwxr-xr-x root/root      2142 2023-06-07 18:09 ./usr/share/otbr/script/clang-format-check
-rwxr-xr-x root/root      2756 2023-06-07 18:09 ./usr/share/otbr/script/cmake-build
-rwxr-xr-x root/root      3988 2023-06-07 18:09 ./usr/share/otbr/script/cmake-build-android
-rwxr-xr-x root/root      2594 2023-06-07 18:09 ./usr/share/otbr/script/console
-rwxr-xr-x root/root      6222 2023-06-07 18:09 ./usr/share/otbr/script/make-pretty
-rwxr-xr-x root/root      3874 2023-06-07 18:09 ./usr/share/otbr/script/otbr-firewall
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/otbr/script/reference-device/
-rwxr-xr-x root/root      5967 2023-06-07 18:09 ./usr/share/otbr/script/reference-device/send_mld_query.py
-rwxr-xr-x root/root      2854 2023-06-07 18:09 ./usr/share/otbr/script/reference-device/send_udp.py
-rwxr-xr-x root/root      3492 2023-06-07 18:09 ./usr/share/otbr/script/server
-rwxr-xr-x root/root      2542 2023-06-07 18:09 ./usr/share/otbr/script/setup
-rwxr-xr-x root/root      9137 2023-06-07 18:09 ./usr/share/otbr/script/standalone_ipv6
-rwxr-xr-x root/root      6009 2023-06-07 18:09 ./usr/share/otbr/script/test
-rwxr-xr-x root/root      2321 2023-06-07 18:09 ./usr/share/otbr/script/update


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-positioning_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       224 2023-06-07 18:05 ./lib/systemd/system/uic-positioning.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root   1967432 2023-06-07 18:14 ./usr/bin/positioning
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-positioning/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-positioning/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/positioning/


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-upti-cap_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/uic-upti-cap/
-rw-r--r-- 0/0             590 2023-06-07 18:16 usr/share/doc/uic-upti-cap/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/
drwxr-xr-x 0/0               0 2023-06-07 18:16 lib/systemd/system/
-rw-r--r-- 0/0             215 2023-06-07 18:16 lib/systemd/system/uic-upti-cap.service
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/bin/
-rwxr-xr-x 0/0         9071952 2023-06-07 18:16 usr/bin/uic-upti-cap


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-upti-writer_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/share/doc/uic-upti-writer/
-rw-r--r-- 0/0             597 2023-06-07 18:16 usr/share/doc/uic-upti-writer/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:16 usr/bin/
-rwxr-xr-x 0/0         8686536 2023-06-07 18:16 usr/bin/uic-upti-writer


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-upvl_1.3.2_arm64.deb
drwxr-xr-x 0/0               0 2023-06-07 18:15 usr/
drwxr-xr-x 0/0               0 2023-06-07 18:15 usr/share/
drwxr-xr-x 0/0               0 2023-06-07 18:15 usr/share/doc/
drwxr-xr-x 0/0               0 2023-06-07 18:15 usr/share/doc/uic-upvl/
-rw-r--r-- 0/0             554 2023-06-07 18:15 usr/share/doc/uic-upvl/copyright
drwxr-xr-x 0/0               0 2023-06-07 18:15 lib/
drwxr-xr-x 0/0               0 2023-06-07 18:15 lib/systemd/
drwxr-xr-x 0/0               0 2023-06-07 18:15 lib/systemd/system/
-rw-r--r-- 0/0             267 2023-06-07 18:15 lib/systemd/system/uic-upvl.service
drwxr-xr-x 0/0               0 2023-06-07 18:15 usr/bin/
-rwxr-xr-x 0/0         9457248 2023-06-07 18:15 usr/bin/uic-upvl


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-zigbeed_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       376 2023-06-07 18:09 ./lib/systemd/system/uic-zigbeed-socat.service
-rw-r--r-- root/root       425 2023-06-07 18:09 ./lib/systemd/system/uic-zigbeed.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root    621584 2023-06-07 18:05 ./usr/bin/Z3Gateway
-rwxr-xr-x root/root   3561416 2023-06-07 18:11 ./usr/bin/zigbeed
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/local/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/local/etc/
-rw-r--r-- root/root      1775 2023-06-07 18:05 ./usr/local/etc/zigbeed.conf
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-zigbeed/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-zigbeed/copyright


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-zigpc_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       260 2023-06-07 18:05 ./lib/systemd/system/uic-zigpc.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxrwxr-x root/root  21506624 2023-06-07 18:14 ./usr/bin/zigpc
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-zigpc/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-zigpc/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/zigpc/


lanka@build20-vbx:/work/codebase/unify_1.3.2_arm64$ dpkg -c uic-zpc_1.3.2_arm64.deb
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/udev/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./etc/udev/rules.d/
-rw-r--r-- root/root       368 2023-06-07 18:05 ./etc/udev/rules.d/99-leds.rules
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./lib/systemd/system/
-rw-r--r-- root/root       253 2023-06-07 18:05 ./lib/systemd/system/uic-zpc.service
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/bin/
-rwxr-xr-x root/root  48503232 2023-06-07 18:15 ./usr/bin/zpc
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/bash-completion/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/bash-completion/completions/
-rw-r--r-- root/root       694 2023-06-07 18:05 ./usr/share/bash-completion/completions/zpc
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/doc/uic-zpc/
-rw-r--r-- root/root       715 2023-06-07 18:05 ./usr/share/doc/uic-zpc/copyright
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/uic/
-rwxr-xr-x root/root      3476 2023-06-07 18:09 ./usr/share/uic/node_identify_rpi4_led.sh
drwxr-xr-x root/root         0 2023-06-07 18:15 ./usr/share/uic/rules/
-rw-r--r-- root/root      2641 2023-06-07 18:05 ./usr/share/uic/rules/BarrierControl_to_Barrier_Operator.uam
-rw-r--r-- root/root      3094 2023-06-07 18:05 ./usr/share/uic/rules/Basic.uam
-rw-r--r-- root/root      1211 2023-06-07 18:05 ./usr/share/uic/rules/CarbonDioxideMeasurement_to_MultilevelSensorCC.uam
-rw-r--r-- root/root      2053 2023-06-07 18:05 ./usr/share/uic/rules/CarbonMonoxideMeasurement_to_MultilevelSensorCC.uam
-rw-r--r-- root/root     11680 2023-06-07 18:05 ./usr/share/uic/rules/ColorControl_to_ColorSwitchCC.uam
-rw-r--r-- root/root      3043 2023-06-07 18:05 ./usr/share/uic/rules/DoorLock_to_DoorLockCC.uam
-rw-r--r-- root/root      3180 2023-06-07 18:05 ./usr/share/uic/rules/ElectricalMeasurement_to_MeterCC.uam
-rw-r--r-- root/root      2976 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_CO_Sensor_Notification_CO_Alarm.uam
-rw-r--r-- root/root      1439 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_DoorWindow_Handle_V1_Alarm_Type.uam
-rw-r--r-- root/root      4036 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_FireSensor_Notification_SmokeAlarm.uam
-rw-r--r-- root/root      1346 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_MotionSensor_Binary_Sensor.uam
-rw-r--r-- root/root      3571 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_MotionSensor_Notification_HomeSecurity.uam
-rw-r--r-- root/root       831 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_MotionSensor_to_AlarmSensor.uam
-rw-r--r-- root/root      3166 2023-06-07 18:05 ./usr/share/uic/rules/IasZone_Water_Sensor_Notification_Water_Sensor.uam
-rw-r--r-- root/root      9274 2023-06-07 18:05 ./usr/share/uic/rules/Identify_to_IndicatorCC.uam
-rw-r--r-- root/root      2243 2023-06-07 18:05 ./usr/share/uic/rules/IlluminanceLevelSensing_to_NotificationCC.uam
-rw-r--r-- root/root      1716 2023-06-07 18:05 ./usr/share/uic/rules/Level.uam
-rw-r--r-- root/root      1958 2023-06-07 18:05 ./usr/share/uic/rules/Level_cluster_simulation.uam
-rw-r--r-- root/root      3327 2023-06-07 18:05 ./usr/share/uic/rules/Level_to_MultilevelSwitchCC.uam
-rw-r--r-- root/root      8325 2023-06-07 18:05 ./usr/share/uic/rules/Metering_to_Meter.uam
-rw-r--r-- root/root      1634 2023-06-07 18:05 ./usr/share/uic/rules/OccupancySensing_to_BinarySensorCC.uam
-rw-r--r-- root/root      5455 2023-06-07 18:05 ./usr/share/uic/rules/OccupancySensing_to_NotificationCC.uam
-rw-r--r-- root/root      1570 2023-06-07 18:05 ./usr/share/uic/rules/OnOff_cluster_simulation.uam
-rw-r--r-- root/root       755 2023-06-07 18:05 ./usr/share/uic/rules/OnOff_to_BasicCC.uam
-rw-r--r-- root/root       999 2023-06-07 18:05 ./usr/share/uic/rules/OnOff_to_BinarySwitchCC.uam
-rw-r--r-- root/root      1462 2023-06-07 18:05 ./usr/share/uic/rules/OnOff_to_MultilevelSwitchCC.uam
-rw-r--r-- root/root       394 2023-06-07 18:05 ./usr/share/uic/rules/PowerConfiguration_to_BatteryCC.uam
-rw-r--r-- root/root      3040 2023-06-07 18:05 ./usr/share/uic/rules/PressureMeasurement_to_MultilevelSensorCC.uam
-rw-r--r-- root/root       849 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_ZDB5100_logic_group_matrix.uam
-rw-r--r-- root/root       560 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_ZRB5120_logic_group_matrix.uam
-rw-r--r-- root/root       723 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_aeotec_multisensor_7.uam
-rw-r--r-- root/root       756 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_agi_data.uam
-rw-r--r-- root/root      1410 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_force_estalish_lifeline.uam
-rw-r--r-- root/root      2120 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_indicator_capabilities.uam
-rw-r--r-- root/root      1006 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_mh3900_thermostat.uam
-rw-r--r-- root/root       826 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_set_wake_up_interval.uam
-rw-r--r-- root/root      1899 2023-06-07 18:05 ./usr/share/uic/rules/Quirks_thermostat_setpoint_capabilities.uam
-rw-r--r-- root/root      1537 2023-06-07 18:05 ./usr/share/uic/rules/RelativeHumidity_to_MultilevelSensorCC.uam
-rw-r--r-- root/root      3738 2023-06-07 18:05 ./usr/share/uic/rules/Scenes.uam
-rw-r--r-- root/root      1465 2023-06-07 18:05 ./usr/share/uic/rules/SoilMoisture_to_MultilevelSensorCC.uam
-rw-r--r-- root/root      1549 2023-06-07 18:05 ./usr/share/uic/rules/TemperatureMeasurement_to_MultilevelSensorCC.uam
-rw-r--r-- root/root     10533 2023-06-07 18:05 ./usr/share/uic/rules/Thermostat.uam
-rw-r--r-- root/root       482 2023-06-07 18:05 ./usr/share/uic/rules/Time_to_MultilevelSensorCC.uam
-rw-r--r-- root/root      1803 2023-06-07 18:05 ./usr/share/uic/rules/pHMeasurement_to_MultilevelSensorCC.uam
-rw-r--r-- root/root      3514 2023-06-07 18:05 ./usr/share/uic/zwave_poll_config.yaml
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/
drwxr-xr-x root/root         0 2023-06-07 18:15 ./var/lib/zpc/

```

## V.2. Prebuild libraries  of GeckoSDK

```bash
lanka@build20-vbx:/work/codebase/GeckoSDK-4.2.2-prebuild-libs$ tree
.
├── app
│   ├── bluetooth
│   │   └── common
│   │       └── cbap_lib
│   │           └── lib
│   │               ├── cbap_CM33_gcc.a
│   │               └── cbap_CM33_iar.a
│   └── mcu_example
│       └── micriumos_webmic
│           └── libs
│               ├── libogg_gcc.a
│               ├── libogg_iar.a
│               ├── libopus_gcc.a
│               └── libopus_iar.a
├── platform
│   ├── CMSIS
│   │   └── libs
│   │       └── GCC
│   │           ├── cortex-m0plus
│   │           │   ├── libCMSISDSPBasicMath.a
│   │           │   ├── libCMSISDSPBayes.a
│   │           │   ├── libCMSISDSPCommon.a
│   │           │   ├── libCMSISDSPComplexMath.a
│   │           │   ├── libCMSISDSPController.a
│   │           │   ├── libCMSISDSPDistance.a
│   │           │   ├── libCMSISDSPFastMath.a
│   │           │   ├── libCMSISDSPFiltering.a
│   │           │   ├── libCMSISDSPInterpolation.a
│   │           │   ├── libCMSISDSPMatrix.a
│   │           │   ├── libCMSISDSPQuaternionMath.a
│   │           │   ├── libCMSISDSPStatistics.a
│   │           │   ├── libCMSISDSPSupport.a
│   │           │   ├── libCMSISDSPSVM.a
│   │           │   └── libCMSISDSPTransform.a
│   │           ├── cortex-m3
│   │           │   ├── libCMSISDSPBasicMath.a
│   │           │   ├── libCMSISDSPBayes.a
│   │           │   ├── libCMSISDSPCommon.a
│   │           │   ├── libCMSISDSPComplexMath.a
│   │           │   ├── libCMSISDSPController.a
│   │           │   ├── libCMSISDSPDistance.a
│   │           │   ├── libCMSISDSPFastMath.a
│   │           │   ├── libCMSISDSPFiltering.a
│   │           │   ├── libCMSISDSPInterpolation.a
│   │           │   ├── libCMSISDSPMatrix.a
│   │           │   ├── libCMSISDSPQuaternionMath.a
│   │           │   ├── libCMSISDSPStatistics.a
│   │           │   ├── libCMSISDSPSupport.a
│   │           │   ├── libCMSISDSPSVM.a
│   │           │   └── libCMSISDSPTransform.a
│   │           ├── cortex-m33
│   │           │   ├── libCMSISDSPBasicMath.a
│   │           │   ├── libCMSISDSPBayes.a
│   │           │   ├── libCMSISDSPCommon.a
│   │           │   ├── libCMSISDSPComplexMath.a
│   │           │   ├── libCMSISDSPController.a
│   │           │   ├── libCMSISDSPDistance.a
│   │           │   ├── libCMSISDSPFastMath.a
│   │           │   ├── libCMSISDSPFiltering.a
│   │           │   ├── libCMSISDSPInterpolation.a
│   │           │   ├── libCMSISDSPMatrix.a
│   │           │   ├── libCMSISDSPQuaternionMath.a
│   │           │   ├── libCMSISDSPStatistics.a
│   │           │   ├── libCMSISDSPSupport.a
│   │           │   ├── libCMSISDSPSVM.a
│   │           │   └── libCMSISDSPTransform.a
│   │           └── cortex-m4
│   │               ├── libCMSISDSPBasicMath.a
│   │               ├── libCMSISDSPBayes.a
│   │               ├── libCMSISDSPCommon.a
│   │               ├── libCMSISDSPComplexMath.a
│   │               ├── libCMSISDSPController.a
│   │               ├── libCMSISDSPDistance.a
│   │               ├── libCMSISDSPFastMath.a
│   │               ├── libCMSISDSPFiltering.a
│   │               ├── libCMSISDSPInterpolation.a
│   │               ├── libCMSISDSPMatrix.a
│   │               ├── libCMSISDSPQuaternionMath.a
│   │               ├── libCMSISDSPStatistics.a
│   │               ├── libCMSISDSPSupport.a
│   │               ├── libCMSISDSPSVM.a
│   │               └── libCMSISDSPTransform.a
│   ├── emdrv
│   │   └── nvm3
│   │       └── lib
│   │           ├── libnvm3_CM0P_gcc.a
│   │           ├── libnvm3_CM0P_iar.a
│   │           ├── libnvm3_CM33_gcc.a
│   │           ├── libnvm3_CM33_iar.a
│   │           ├── libnvm3_CM3_gcc.a
│   │           ├── libnvm3_CM3_iar.a
│   │           ├── libnvm3_CM4_gcc.a
│   │           └── libnvm3_CM4_iar.a
│   ├── middleware
│   │   └── cslib
│   │       └── lib
│   │           ├── libCSLIB_M0_CSEN_gcc.a
│   │           ├── libCSLIB_M0_CSEN_iar7.a
│   │           ├── libCSLIB_M0_CSEN_iar.a
│   │           ├── libCSLIB_M0_gcc.a
│   │           ├── libCSLIB_M0_iar7.a
│   │           ├── libCSLIB_M0_iar.a
│   │           ├── libCSLIB_M3_4_CSEN_gcc.a
│   │           ├── libCSLIB_M3_4_CSEN_iar7.a
│   │           ├── libCSLIB_M3_4_CSEN_iar.a
│   │           ├── libCSLIB_M3_4_gcc.a
│   │           ├── libCSLIB_M3_4_iar7.a
│   │           └── libCSLIB_M3_4_iar.a
│   ├── radio
│   │   └── rail_lib
│   │       └── autogen
│   │           └── librail_release
│   │               ├── librail_config_bgm111a256v2_gcc.a
│   │               ├── librail_config_bgm111a256v2_iar.a
│   │               ├── librail_config_bgm111e256v2_gcc.a
│   │               ├── librail_config_bgm111e256v2_iar.a
│   │               ├── librail_config_bgm113a256v2_gcc.a
│   │               ├── librail_config_bgm113a256v2_iar.a
│   │               ├── librail_config_bgm11s12f256ga_gcc.a
│   │               ├── librail_config_bgm11s12f256ga_iar.a
│   │               ├── librail_config_bgm11s22f256ga_gcc.a
│   │               ├── librail_config_bgm11s22f256ga_iar.a
│   │               ├── librail_config_bgm121a256v2_gcc.a
│   │               ├── librail_config_bgm121a256v2_iar.a
│   │               ├── librail_config_bgm121n256v2_gcc.a
│   │               ├── librail_config_bgm121n256v2_iar.a
│   │               ├── librail_config_bgm123a256v2_gcc.a
│   │               ├── librail_config_bgm123a256v2_iar.a
│   │               ├── librail_config_bgm123n256v2_gcc.a
│   │               ├── librail_config_bgm123n256v2_iar.a
│   │               ├── librail_config_bgm13p22f512ga_gcc.a
│   │               ├── librail_config_bgm13p22f512ga_iar.a
│   │               ├── librail_config_bgm13p22f512ge_gcc.a
│   │               ├── librail_config_bgm13p22f512ge_iar.a
│   │               ├── librail_config_bgm13p32f512ga_gcc.a
│   │               ├── librail_config_bgm13p32f512ga_iar.a
│   │               ├── librail_config_bgm13p32f512ge_gcc.a
│   │               ├── librail_config_bgm13p32f512ge_iar.a
│   │               ├── librail_config_bgm13s22f512ga_gcc.a
│   │               ├── librail_config_bgm13s22f512ga_iar.a
│   │               ├── librail_config_bgm13s22f512gn_gcc.a
│   │               ├── librail_config_bgm13s22f512gn_iar.a
│   │               ├── librail_config_bgm13s32f512ga_gcc.a
│   │               ├── librail_config_bgm13s32f512ga_iar.a
│   │               ├── librail_config_bgm13s32f512gn_gcc.a
│   │               ├── librail_config_bgm13s32f512gn_iar.a
│   │               ├── librail_config_bgm210l022jif_gcc.a
│   │               ├── librail_config_bgm210l022jif_iar.a
│   │               ├── librail_config_bgm210l022jnf_gcc.a
│   │               ├── librail_config_bgm210l022jnf_iar.a
│   │               ├── librail_config_bgm210la22jif_gcc.a
│   │               ├── librail_config_bgm210la22jif_iar.a
│   │               ├── librail_config_bgm210la22jnf_gcc.a
│   │               ├── librail_config_bgm210la22jnf_iar.a
│   │               ├── librail_config_bgm210p022jia_gcc.a
│   │               ├── librail_config_bgm210p022jia_iar.a
│   │               ├── librail_config_bgm210p022jna_gcc.a
│   │               ├── librail_config_bgm210p022jna_iar.a
│   │               ├── librail_config_bgm210p032jia_gcc.a
│   │               ├── librail_config_bgm210p032jia_iar.a
│   │               ├── librail_config_bgm210p032jna_gcc.a
│   │               ├── librail_config_bgm210p032jna_iar.a
│   │               ├── librail_config_bgm210pa22jia_gcc.a
│   │               ├── librail_config_bgm210pa22jia_iar.a
│   │               ├── librail_config_bgm210pa22jna_gcc.a
│   │               ├── librail_config_bgm210pa22jna_iar.a
│   │               ├── librail_config_bgm210pa32jia_gcc.a
│   │               ├── librail_config_bgm210pa32jia_iar.a
│   │               ├── librail_config_bgm210pa32jna_gcc.a
│   │               ├── librail_config_bgm210pa32jna_iar.a
│   │               ├── librail_config_bgm210pb22jia_gcc.a
│   │               ├── librail_config_bgm210pb22jia_iar.a
│   │               ├── librail_config_bgm210pb32jia_gcc.a
│   │               ├── librail_config_bgm210pb32jia_iar.a
│   │               ├── librail_config_bgm220pc22hna_gcc.a
│   │               ├── librail_config_bgm220pc22hna_iar.a
│   │               ├── librail_config_bgm220pc22wga_gcc.a
│   │               ├── librail_config_bgm220pc22wga_iar.a
│   │               ├── librail_config_bgm220sc12wga_gcc.a
│   │               ├── librail_config_bgm220sc12wga_iar.a
│   │               ├── librail_config_bgm220sc22hna_gcc.a
│   │               ├── librail_config_bgm220sc22hna_iar.a
│   │               ├── librail_config_bgm220sc22wga_gcc.a
│   │               ├── librail_config_bgm220sc22wga_iar.a
│   │               ├── librail_config_bgm220sc23hna_gcc.a
│   │               ├── librail_config_bgm220sc23hna_iar.a
│   │               ├── librail_config_bgm240pa22vna_gcc.a
│   │               ├── librail_config_bgm240pa22vna_iar.a
│   │               ├── librail_config_bgm240pa32vna_gcc.a
│   │               ├── librail_config_bgm240pa32vna_iar.a
│   │               ├── librail_config_bgm240pa32vnn_gcc.a
│   │               ├── librail_config_bgm240pa32vnn_iar.a
│   │               ├── librail_config_bgm240pb22vna_gcc.a
│   │               ├── librail_config_bgm240pb22vna_iar.a
│   │               ├── librail_config_bgm240pb32vna_gcc.a
│   │               ├── librail_config_bgm240pb32vna_iar.a
│   │               ├── librail_config_bgm240pb32vnn_gcc.a
│   │               ├── librail_config_bgm240pb32vnn_iar.a
│   │               ├── librail_config_bgm240sa22vna_gcc.a
│   │               ├── librail_config_bgm240sa22vna_iar.a
│   │               ├── librail_config_bgm240sb22vna_gcc.a
│   │               ├── librail_config_bgm240sb22vna_iar.a
│   │               ├── librail_config_bgm241sd22vna_gcc.a
│   │               ├── librail_config_bgm241sd22vna_iar.a
│   │               ├── librail_config_fgm230sa27hgn_gcc.a
│   │               ├── librail_config_fgm230sa27hgn_iar.a
│   │               ├── librail_config_fgm230sb27hgn_gcc.a
│   │               ├── librail_config_fgm230sb27hgn_iar.a
│   │               ├── librail_config_mgm111a256v2_gcc.a
│   │               ├── librail_config_mgm111a256v2_iar.a
│   │               ├── librail_config_mgm111e256v2_gcc.a
│   │               ├── librail_config_mgm111e256v2_iar.a
│   │               ├── librail_config_mgm12p02f1024ga_gcc.a
│   │               ├── librail_config_mgm12p02f1024ga_iar.a
│   │               ├── librail_config_mgm12p02f1024ge_gcc.a
│   │               ├── librail_config_mgm12p02f1024ge_iar.a
│   │               ├── librail_config_mgm12p22f1024ga_gcc.a
│   │               ├── librail_config_mgm12p22f1024ga_iar.a
│   │               ├── librail_config_mgm12p22f1024ge_gcc.a
│   │               ├── librail_config_mgm12p22f1024ge_iar.a
│   │               ├── librail_config_mgm12p32f1024ga_gcc.a
│   │               ├── librail_config_mgm12p32f1024ga_iar.a
│   │               ├── librail_config_mgm12p32f1024ge_gcc.a
│   │               ├── librail_config_mgm12p32f1024ge_iar.a
│   │               ├── librail_config_mgm13p02f512ga_gcc.a
│   │               ├── librail_config_mgm13p02f512ga_iar.a
│   │               ├── librail_config_mgm13p02f512ge_gcc.a
│   │               ├── librail_config_mgm13p02f512ge_iar.a
│   │               ├── librail_config_mgm13p12f512ga_gcc.a
│   │               ├── librail_config_mgm13p12f512ga_iar.a
│   │               ├── librail_config_mgm13p12f512ge_gcc.a
│   │               ├── librail_config_mgm13p12f512ge_iar.a
│   │               ├── librail_config_mgm13s02f512ga_gcc.a
│   │               ├── librail_config_mgm13s02f512ga_iar.a
│   │               ├── librail_config_mgm13s02f512gn_gcc.a
│   │               ├── librail_config_mgm13s02f512gn_iar.a
│   │               ├── librail_config_mgm13s12f512ga_gcc.a
│   │               ├── librail_config_mgm13s12f512ga_iar.a
│   │               ├── librail_config_mgm13s12f512gn_gcc.a
│   │               ├── librail_config_mgm13s12f512gn_iar.a
│   │               ├── librail_config_mgm210l022jif_gcc.a
│   │               ├── librail_config_mgm210l022jif_iar.a
│   │               ├── librail_config_mgm210l022jnf_gcc.a
│   │               ├── librail_config_mgm210l022jnf_iar.a
│   │               ├── librail_config_mgm210la22jif_gcc.a
│   │               ├── librail_config_mgm210la22jif_iar.a
│   │               ├── librail_config_mgm210la22jnf_gcc.a
│   │               ├── librail_config_mgm210la22jnf_iar.a
│   │               ├── librail_config_mgm210p022jia_gcc.a
│   │               ├── librail_config_mgm210p022jia_iar.a
│   │               ├── librail_config_mgm210p022jna_gcc.a
│   │               ├── librail_config_mgm210p022jna_iar.a
│   │               ├── librail_config_mgm210p032jia_gcc.a
│   │               ├── librail_config_mgm210p032jia_iar.a
│   │               ├── librail_config_mgm210p032jna_gcc.a
│   │               ├── librail_config_mgm210p032jna_iar.a
│   │               ├── librail_config_mgm210pa22jia_gcc.a
│   │               ├── librail_config_mgm210pa22jia_iar.a
│   │               ├── librail_config_mgm210pa22jna_gcc.a
│   │               ├── librail_config_mgm210pa22jna_iar.a
│   │               ├── librail_config_mgm210pa32jia_gcc.a
│   │               ├── librail_config_mgm210pa32jia_iar.a
│   │               ├── librail_config_mgm210pa32jna_gcc.a
│   │               ├── librail_config_mgm210pa32jna_iar.a
│   │               ├── librail_config_mgm210pb22jia_gcc.a
│   │               ├── librail_config_mgm210pb22jia_iar.a
│   │               ├── librail_config_mgm210pb32jia_gcc.a
│   │               ├── librail_config_mgm210pb32jia_iar.a
│   │               ├── librail_config_mgm220pc22hna_gcc.a
│   │               ├── librail_config_mgm220pc22hna_iar.a
│   │               ├── librail_config_mgm220sc22hna_gcc.a
│   │               ├── librail_config_mgm220sc22hna_iar.a
│   │               ├── librail_config_mgm240l022rnf_gcc.a
│   │               ├── librail_config_mgm240l022rnf_iar.a
│   │               ├── librail_config_mgm240l022vnf_gcc.a
│   │               ├── librail_config_mgm240l022vnf_iar.a
│   │               ├── librail_config_mgm240pa22vna_gcc.a
│   │               ├── librail_config_mgm240pa22vna_iar.a
│   │               ├── librail_config_mgm240pa32vna_gcc.a
│   │               ├── librail_config_mgm240pa32vna_iar.a
│   │               ├── librail_config_mgm240pa32vnn_gcc.a
│   │               ├── librail_config_mgm240pa32vnn_iar.a
│   │               ├── librail_config_mgm240pb22vna_gcc.a
│   │               ├── librail_config_mgm240pb22vna_iar.a
│   │               ├── librail_config_mgm240pb32vna_gcc.a
│   │               ├── librail_config_mgm240pb32vna_iar.a
│   │               ├── librail_config_mgm240pb32vnn_gcc.a
│   │               ├── librail_config_mgm240pb32vnn_iar.a
│   │               ├── librail_config_mgm240sa22vna_gcc.a
│   │               ├── librail_config_mgm240sa22vna_iar.a
│   │               ├── librail_config_mgm240sb22vna_gcc.a
│   │               ├── librail_config_mgm240sb22vna_iar.a
│   │               ├── librail_config_mgm240sd22vna_gcc.a
│   │               ├── librail_config_mgm240sd22vna_iar.a
│   │               ├── librail_config_zgm130s037hgn1_gcc.a
│   │               ├── librail_config_zgm130s037hgn1_iar.a
│   │               ├── librail_config_zgm130s037hgn_gcc.a
│   │               ├── librail_config_zgm130s037hgn_iar.a
│   │               ├── librail_config_zgm230sa27hgn_gcc.a
│   │               ├── librail_config_zgm230sa27hgn_iar.a
│   │               ├── librail_config_zgm230sa27hnn_gcc.a
│   │               ├── librail_config_zgm230sa27hnn_iar.a
│   │               ├── librail_config_zgm230sb27hgn_gcc.a
│   │               ├── librail_config_zgm230sb27hgn_iar.a
│   │               ├── librail_efr32xg12_gcc_release.a
│   │               ├── librail_efr32xg12_iar_release.a
│   │               ├── librail_efr32xg13_gcc_release.a
│   │               ├── librail_efr32xg13_iar_release.a
│   │               ├── librail_efr32xg14_gcc_release.a
│   │               ├── librail_efr32xg14_iar_release.a
│   │               ├── librail_efr32xg1_gcc_release.a
│   │               ├── librail_efr32xg1_iar_release.a
│   │               ├── librail_efr32xg21_gcc_release.a
│   │               ├── librail_efr32xg21_iar_release.a
│   │               ├── librail_efr32xg22_gcc_release.a
│   │               ├── librail_efr32xg22_iar_release.a
│   │               ├── librail_efr32xg23_gcc_release.a
│   │               ├── librail_efr32xg23_iar_release.a
│   │               ├── librail_efr32xg24_gcc_release.a
│   │               ├── librail_efr32xg24_iar_release.a
│   │               ├── librail_efr32xg25_gcc_release.a
│   │               ├── librail_efr32xg25_iar_release.a
│   │               ├── librail_efr32xg27_gcc_release.a
│   │               ├── librail_efr32xg27_iar_release.a
│   │               ├── librail_efr32xg28_gcc_release.a
│   │               ├── librail_efr32xg28_iar_release.a
│   │               ├── librail_module_efr32xg12_gcc_release.a
│   │               ├── librail_module_efr32xg12_iar_release.a
│   │               ├── librail_module_efr32xg13_gcc_release.a
│   │               ├── librail_module_efr32xg13_iar_release.a
│   │               ├── librail_module_efr32xg14_gcc_release.a
│   │               ├── librail_module_efr32xg14_iar_release.a
│   │               ├── librail_module_efr32xg1_gcc_release.a
│   │               ├── librail_module_efr32xg1_iar_release.a
│   │               ├── librail_module_efr32xg21_gcc_release.a
│   │               ├── librail_module_efr32xg21_iar_release.a
│   │               ├── librail_module_efr32xg22_gcc_release.a
│   │               ├── librail_module_efr32xg22_iar_release.a
│   │               ├── librail_module_efr32xg23_gcc_release.a
│   │               ├── librail_module_efr32xg23_iar_release.a
│   │               ├── librail_module_efr32xg24_gcc_release.a
│   │               ├── librail_module_efr32xg24_iar_release.a
│   │               ├── librail_module_efr32xg25_gcc_release.a
│   │               ├── librail_module_efr32xg25_iar_release.a
│   │               ├── librail_module_efr32xg27_gcc_release.a
│   │               ├── librail_module_efr32xg27_iar_release.a
│   │               ├── librail_module_efr32xg28_gcc_release.a
│   │               ├── librail_module_efr32xg28_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg12_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg12_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg13_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg13_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg14_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg14_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg1_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg1_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg21_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg21_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg22_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg22_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg23_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg23_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg24_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg24_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg25_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg25_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg27_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg27_iar_release.a
│   │               ├── librail_multiprotocol_efr32xg28_gcc_release.a
│   │               ├── librail_multiprotocol_efr32xg28_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg12_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg12_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg13_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg13_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg14_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg14_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg1_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg1_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg21_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg21_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg22_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg22_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg23_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg23_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg24_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg24_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg25_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg25_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg27_gcc_release.a
│   │               ├── librail_multiprotocol_module_efr32xg27_iar_release.a
│   │               ├── librail_multiprotocol_module_efr32xg28_gcc_release.a
│   │               └── librail_multiprotocol_module_efr32xg28_iar_release.a
│   └── service
│       └── sim_eeprom
│           ├── sim_eeprom1
│           │   └── lib
│           │       ├── libsim_eeprom1_CM4_gcc.a
│           │       └── libsim_eeprom1_CM4_iar.a
│           ├── sim_eeprom1_to_sim_eeprom2_upgrade
│           │   └── lib
│           │       ├── libsim_eeprom1_to_sim_eeprom2_upgrade_CM4_gcc.a
│           │       └── libsim_eeprom1_to_sim_eeprom2_upgrade_CM4_iar.a
│           ├── sim_eeprom2
│           │   └── lib
│           │       ├── libsim_eeprom2_CM4_gcc.a
│           │       └── libsim_eeprom2_CM4_iar.a
│           └── sim_eeprom2_to_nvm3_upgrade
│               └── lib
│                   ├── libsim_eeprom2_to_nvm3_upgrade_CM4_gcc.a
│                   └── libsim_eeprom2_to_nvm3_upgrade_CM4_iar.a
├── protocol
│   ├── bluetooth
│   │   ├── bgcommon
│   │   │   └── lib
│   │   │       ├── libbgcommon_efr32xg12_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg12_iar_release.a
│   │   │       ├── libbgcommon_efr32xg13_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg13_iar_release.a
│   │   │       ├── libbgcommon_efr32xg14_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg14_iar_release.a
│   │   │       ├── libbgcommon_efr32xg1_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg1_iar_release.a
│   │   │       ├── libbgcommon_efr32xg21_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg21_iar_release.a
│   │   │       ├── libbgcommon_efr32xg22_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg22_iar_release.a
│   │   │       ├── libbgcommon_efr32xg24_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg24_iar_release.a
│   │   │       ├── libbgcommon_efr32xg27_gcc_release.a
│   │   │       ├── libbgcommon_efr32xg27_iar_release.a
│   │   │       ├── libbgcommon_efr32xg28_gcc_release.a
│   │   │       └── libbgcommon_efr32xg28_iar_release.a
│   │   ├── bgstack
│   │   │   └── ll
│   │   │       └── lib
│   │   │           ├── libbluetooth_controller_efr32xg12_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg12_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg13_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg13_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg14_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg14_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg1_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg1_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg21_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg21_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg22_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg22_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg24_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg24_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg27_gcc_release.a
│   │   │           ├── libbluetooth_controller_efr32xg27_iar_release.a
│   │   │           ├── libbluetooth_controller_efr32xg28_gcc_release.a
│   │   │           └── libbluetooth_controller_efr32xg28_iar_release.a
│   │   ├── bin
│   │   │   └── gatt
│   │   │       └── __pycache__
│   │   │           ├── gatt.cpython-39.pyc
│   │   │           ├── gattdb.cpython-39.pyc
│   │   │           └── gattxml.cpython-39.pyc
│   │   └── lib
│   │       ├── EFR32BG12P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   ├── libbtmesh_model_mbt.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       ├── libbtmesh_model_mbt.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32BG13P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   ├── libbtmesh_model_mbt.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       ├── libbtmesh_model_mbt.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32BG1B
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32BG1P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32BG21
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32BG22
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32BG24
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32BG27
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32FG28
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   └── libbluetooth.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       └── libbluetooth.a
│   │       ├── EFR32MG12P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   ├── libbtmesh_model_mbt.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       ├── libbtmesh_model_mbt.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32MG13P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   ├── libbtmesh_model_mbt.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       ├── libbtmesh_model_mbt.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32MG14P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32MG1P
│   │       │   ├── GCC
│   │       │   │   ├── binapploader_nvm3.o
│   │       │   │   ├── binapploader.o
│   │       │   │   ├── libbluetooth.a
│   │       │   │   └── libpsstore.a
│   │       │   └── IAR
│   │       │       ├── binapploader_nvm3.o
│   │       │       ├── binapploader.o
│   │       │       ├── libbluetooth.a
│   │       │       └── libpsstore.a
│   │       ├── EFR32MG21
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32MG22
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32MG24
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       ├── EFR32MG27
│   │       │   ├── GCC
│   │       │   │   ├── libapploader.a
│   │       │   │   ├── libbluetooth.a
│   │       │   │   ├── libbluetooth_mesh.a
│   │       │   │   ├── libbtmesh_advertiser_deprecated.a
│   │       │   │   ├── libbtmesh_advertiser_extended.a
│   │       │   │   ├── libbtmesh_advertiser_legacy.a
│   │       │   │   ├── libbtmesh_crypto_key_cache.a
│   │       │   │   ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │   │   ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │   │   ├── libbtmesh_model_dfu.a
│   │       │   │   └── libbtmesh_model_mbt.a
│   │       │   └── IAR
│   │       │       ├── libapploader.a
│   │       │       ├── libbluetooth.a
│   │       │       ├── libbluetooth_mesh.a
│   │       │       ├── libbtmesh_advertiser_deprecated.a
│   │       │       ├── libbtmesh_advertiser_extended.a
│   │       │       ├── libbtmesh_advertiser_legacy.a
│   │       │       ├── libbtmesh_crypto_key_cache.a
│   │       │       ├── libbtmesh_crypto_key_cache_dummy.a
│   │       │       ├── libbtmesh_dfu_ncp_fw_list.a
│   │       │       ├── libbtmesh_model_dfu.a
│   │       │       └── libbtmesh_model_mbt.a
│   │       └── EFR32ZG28
│   │           ├── GCC
│   │           │   ├── libapploader.a
│   │           │   └── libbluetooth.a
│   │           └── IAR
│   │               ├── libapploader.a
│   │               └── libbluetooth.a
│   ├── flex
│   │   └── libs
│   │       ├── libconnect-aes-security-library-efr32xg1-gcc.a
│   │       ├── libconnect-aes-security-library-efr32xg1-iar.a
│   │       ├── libconnect-aes-security-library-efr32xg1x-gcc.a
│   │       ├── libconnect-aes-security-library-efr32xg1x-iar.a
│   │       ├── libconnect-aes-security-library-efr32xg2x-gcc.a
│   │       ├── libconnect-aes-security-library-efr32xg2x-iar.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg1-gcc.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg1-iar.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg1x-gcc.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg1x-iar.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg2x-gcc.a
│   │       ├── libconnect-frequency-hopping-library-efr32xg2x-iar.a
│   │       ├── libconnect-packet-queue-library-efr32xg1-gcc.a
│   │       ├── libconnect-packet-queue-library-efr32xg1-iar.a
│   │       ├── libconnect-packet-queue-library-efr32xg1x-gcc.a
│   │       ├── libconnect-packet-queue-library-efr32xg1x-iar.a
│   │       ├── libconnect-packet-queue-library-efr32xg2x-gcc.a
│   │       ├── libconnect-packet-queue-library-efr32xg2x-iar.a
│   │       ├── libconnect-parent-support-library-efr32xg1-gcc.a
│   │       ├── libconnect-parent-support-library-efr32xg1-iar.a
│   │       ├── libconnect-parent-support-library-efr32xg1x-gcc.a
│   │       ├── libconnect-parent-support-library-efr32xg1x-iar.a
│   │       ├── libconnect-parent-support-library-efr32xg2x-gcc.a
│   │       ├── libconnect-parent-support-library-efr32xg2x-iar.a
│   │       ├── libconnect-radio-stream-library-efr32xg1-gcc.a
│   │       ├── libconnect-radio-stream-library-efr32xg1-iar.a
│   │       ├── libconnect-radio-stream-library-efr32xg1x-gcc.a
│   │       ├── libconnect-radio-stream-library-efr32xg1x-iar.a
│   │       ├── libconnect-radio-stream-library-efr32xg2x-gcc.a
│   │       ├── libconnect-radio-stream-library-efr32xg2x-iar.a
│   │       ├── libconnect-stack-common-library-efr32xg1-gcc.a
│   │       ├── libconnect-stack-common-library-efr32xg1-iar.a
│   │       ├── libconnect-stack-common-library-efr32xg1x-gcc.a
│   │       ├── libconnect-stack-common-library-efr32xg1x-iar.a
│   │       ├── libconnect-stack-common-library-efr32xg2x-gcc.a
│   │       ├── libconnect-stack-common-library-efr32xg2x-iar.a
│   │       ├── libconnect-stack-counters-library-efr32xg1-gcc.a
│   │       ├── libconnect-stack-counters-library-efr32xg1-iar.a
│   │       ├── libconnect-stack-counters-library-efr32xg1x-gcc.a
│   │       ├── libconnect-stack-counters-library-efr32xg1x-iar.a
│   │       ├── libconnect-stack-counters-library-efr32xg2x-gcc.a
│   │       └── libconnect-stack-counters-library-efr32xg2x-iar.a
│   ├── openthread
│   │   └── libs
│   │       ├── libsl_openthread_efr32mg1x_gcc.a
│   │       ├── libsl_openthread_efr32mg2x_gcc.a
│   │       ├── libsl_ot_stack_ftd_coap_efr32mg12_gcc.a
│   │       ├── libsl_ot_stack_ftd_coap_efr32mg13_gcc.a
│   │       ├── libsl_ot_stack_ftd_coap_efr32mg21_gcc.a
│   │       ├── libsl_ot_stack_ftd_coap_efr32mg24_gcc.a
│   │       ├── libsl_ot_stack_ftd_efr32mg12_gcc.a
│   │       ├── libsl_ot_stack_ftd_efr32mg13_gcc.a
│   │       ├── libsl_ot_stack_ftd_efr32mg21_gcc.a
│   │       ├── libsl_ot_stack_ftd_efr32mg24_gcc.a
│   │       ├── libsl_ot_stack_mtd_coap_efr32mg12_gcc.a
│   │       ├── libsl_ot_stack_mtd_coap_efr32mg13_gcc.a
│   │       ├── libsl_ot_stack_mtd_coap_efr32mg21_gcc.a
│   │       ├── libsl_ot_stack_mtd_coap_efr32mg24_gcc.a
│   │       ├── libsl_ot_stack_mtd_efr32mg12_gcc.a
│   │       ├── libsl_ot_stack_mtd_efr32mg13_gcc.a
│   │       ├── libsl_ot_stack_mtd_efr32mg21_gcc.a
│   │       ├── libsl_ot_stack_mtd_efr32mg24_gcc.a
│   │       ├── libsl_platform_ftd_dmp_efr32mg12_gcc.a
│   │       ├── libsl_platform_ftd_dmp_efr32mg13_gcc.a
│   │       ├── libsl_platform_ftd_dmp_efr32mg21_gcc.a
│   │       ├── libsl_platform_ftd_dmp_efr32mg24_gcc.a
│   │       ├── libsl_platform_ftd_efr32mg12_gcc.a
│   │       ├── libsl_platform_ftd_efr32mg13_gcc.a
│   │       ├── libsl_platform_ftd_efr32mg21_gcc.a
│   │       ├── libsl_platform_ftd_efr32mg24_gcc.a
│   │       ├── libsl_platform_mtd_dmp_efr32mg12_gcc.a
│   │       ├── libsl_platform_mtd_dmp_efr32mg13_gcc.a
│   │       ├── libsl_platform_mtd_dmp_efr32mg21_gcc.a
│   │       ├── libsl_platform_mtd_dmp_efr32mg24_gcc.a
│   │       ├── libsl_platform_mtd_efr32mg12_gcc.a
│   │       ├── libsl_platform_mtd_efr32mg13_gcc.a
│   │       ├── libsl_platform_mtd_efr32mg21_gcc.a
│   │       └── libsl_platform_mtd_efr32mg24_gcc.a
│   ├── wisun
│   │   └── stack
│   │       ├── libwisun_mac_core_efr32xg1x_gcc.a
│   │       ├── libwisun_mac_core_efr32xg1x_iar.a
│   │       ├── libwisun_mac_core_efr32xg2x_gcc.a
│   │       ├── libwisun_mac_core_efr32xg2x_iar.a
│   │       ├── libwisun_mac_efr32xg1x_gcc.a
│   │       ├── libwisun_mac_efr32xg1x_iar.a
│   │       ├── libwisun_mac_efr32xg2x_gcc.a
│   │       ├── libwisun_mac_efr32xg2x_iar.a
│   │       ├── libwisun_rcp_efr32xg1x_gcc.a
│   │       ├── libwisun_rcp_efr32xg1x_iar.a
│   │       ├── libwisun_rcp_efr32xg2x_gcc.a
│   │       ├── libwisun_rcp_efr32xg2x_iar.a
│   │       ├── libwisun_router_core_efr32xg1x_freertos_gcc_debug.a
│   │       ├── libwisun_router_core_efr32xg1x_freertos_gcc_release.a
│   │       ├── libwisun_router_core_efr32xg1x_freertos_iar_debug.a
│   │       ├── libwisun_router_core_efr32xg1x_freertos_iar_release.a
│   │       ├── libwisun_router_core_efr32xg1x_micriumos_gcc_debug.a
│   │       ├── libwisun_router_core_efr32xg1x_micriumos_gcc_release.a
│   │       ├── libwisun_router_core_efr32xg1x_micriumos_iar_debug.a
│   │       ├── libwisun_router_core_efr32xg1x_micriumos_iar_release.a
│   │       ├── libwisun_router_core_efr32xg2x_freertos_gcc_debug.a
│   │       ├── libwisun_router_core_efr32xg2x_freertos_gcc_release.a
│   │       ├── libwisun_router_core_efr32xg2x_freertos_iar_debug.a
│   │       ├── libwisun_router_core_efr32xg2x_freertos_iar_release.a
│   │       ├── libwisun_router_core_efr32xg2x_micriumos_gcc_debug.a
│   │       ├── libwisun_router_core_efr32xg2x_micriumos_gcc_release.a
│   │       ├── libwisun_router_core_efr32xg2x_micriumos_iar_debug.a
│   │       ├── libwisun_router_core_efr32xg2x_micriumos_iar_release.a
│   │       ├── libwisun_router_efr32xg1x_freertos_gcc_debug.a
│   │       ├── libwisun_router_efr32xg1x_freertos_gcc_release.a
│   │       ├── libwisun_router_efr32xg1x_freertos_iar_debug.a
│   │       ├── libwisun_router_efr32xg1x_freertos_iar_release.a
│   │       ├── libwisun_router_efr32xg1x_micriumos_gcc_debug.a
│   │       ├── libwisun_router_efr32xg1x_micriumos_gcc_release.a
│   │       ├── libwisun_router_efr32xg1x_micriumos_iar_debug.a
│   │       ├── libwisun_router_efr32xg1x_micriumos_iar_release.a
│   │       ├── libwisun_router_efr32xg2x_freertos_gcc_debug.a
│   │       ├── libwisun_router_efr32xg2x_freertos_gcc_release.a
│   │       ├── libwisun_router_efr32xg2x_freertos_iar_debug.a
│   │       ├── libwisun_router_efr32xg2x_freertos_iar_release.a
│   │       ├── libwisun_router_efr32xg2x_micriumos_gcc_debug.a
│   │       ├── libwisun_router_efr32xg2x_micriumos_gcc_release.a
│   │       ├── libwisun_router_efr32xg2x_micriumos_iar_debug.a
│   │       └── libwisun_router_efr32xg2x_micriumos_iar_release.a
│   ├── zigbee
│   │   └── build
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm12-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm13-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm21-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm22-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm24-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm12-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm13-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm21-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm22-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm24-rail
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── binding-table-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── binding-table-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-163k1-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-163k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-283k1-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-283k1-library.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-core-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-library-core.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-sign-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-library-dsa-sign.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-283k1-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify-283k1.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg21-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg22-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg24-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg27-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm12-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm13-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm21-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm22-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm24-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg13p-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg21-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg22-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg27-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm12-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm13-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm21-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm22-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm24-rail
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── cbke-library-dsa-verify-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── cbke-library-dsa-verify.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-mgm12-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-mgm13-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-mgm21-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-mgm22-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-gcc-mgm24-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm12-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm13-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm21-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm22-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm24-rail
│   │       │   └── debug-basic-library.a
│   │       ├── debug-basic-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── debug-basic-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-mgm12-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-mgm13-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-mgm21-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-mgm22-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-gcc-mgm24-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm12-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm13-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm21-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm22-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm24-rail
│   │       │   └── debug-extended-library.a
│   │       ├── debug-extended-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── debug-extended-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm12-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm13-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm21-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm22-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm24-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm12-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm13-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm21-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm22-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm24-rail
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-cpc-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── em260-cpc-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm12-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm13-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm21-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm22-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm24-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm12-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm13-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm21-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm22-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm24-rail
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-spi-util-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── em260-spi-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm12-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm13-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm21-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm22-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm24-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm12-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm13-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm21-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm22-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm24-rail
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-uart-util-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── em260-uart-util-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-mgm12-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-mgm13-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-mgm21-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-mgm22-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-gcc-mgm24-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm12-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm13-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm21-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm22-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm24-rail
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-unix-gcc-simulation-null-arch_i386
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-unix-gcc-simulation-null-arch_x86_64
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-unix-gcc-simulation-null-arm32v7
│   │       │   └── em260-xncp-library.a
│   │       ├── em260-xncp-library-unix-gcc-simulation-null-arm64v8
│   │       │   └── em260-xncp-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm12-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm13-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm21-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm22-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm24-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm12-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm13-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm21-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm22-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm24-rail
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── end-device-bind-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── end-device-bind-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm12-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm13-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm21-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm22-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm24-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm12-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm13-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm21-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm22-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm24-rail
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── gp-library.a
│   │       ├── gp-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── gp-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── gp-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm12-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm13-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm21-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm22-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm24-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm12-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm13-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm21-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm22-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm24-rail
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── install-code-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── install-code-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm12-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm13-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm21-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm22-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm24-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm12-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm13-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm21-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm22-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm24-rail
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── mfglib-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── mfglib-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-mgm12-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-mgm13-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-mgm21-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-mgm22-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-gcc-mgm24-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm12-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm13-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm21-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm22-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm24-rail
│   │       │   └── multi-network-library.a
│   │       ├── multi-network-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── multi-network-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-mgm12-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-mgm13-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-mgm21-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-mgm22-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-gcc-mgm24-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm12-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm13-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm21-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm22-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm24-rail
│   │       │   └── multi-pan-library.a
│   │       ├── multi-pan-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── multi-pan-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-binding-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── ncp-binding-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-cbke-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-cbke-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-unix-gcc-simulation-null-arch_i386
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-unix-gcc-simulation-null-arch_x86_64
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-unix-gcc-simulation-null-arm32v7
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-gp-library-unix-gcc-simulation-null-arm64v8
│   │       │   └── ncp-gp-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-mfglib-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── ncp-mfglib-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-pro-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── ncp-pro-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-unix-gcc-simulation-null-arch_i386
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-unix-gcc-simulation-null-arch_x86_64
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-unix-gcc-simulation-null-arm32v7
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-source-route-library-unix-gcc-simulation-null-arm64v8
│   │       │   └── ncp-source-route-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-mgm12-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-mgm13-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-mgm21-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-mgm22-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-gcc-mgm24-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm12-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm13-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm21-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm22-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm24-rail
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-unix-gcc-simulation-null-arch_i386
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-unix-gcc-simulation-null-arch_x86_64
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-unix-gcc-simulation-null-arm32v7
│   │       │   └── ncp-zll-library.a
│   │       ├── ncp-zll-library-unix-gcc-simulation-null-arm64v8
│   │       │   └── ncp-zll-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-mgm12-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-mgm13-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-mgm21-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-mgm22-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-gcc-mgm24-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm12-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm13-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm21-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm22-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm24-rail
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-unix-gcc-simulation-null-arch_i386
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-unix-gcc-simulation-null-arch_x86_64
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-unix-gcc-simulation-null-arm32v7
│   │       │   └── packet-validate-library.a
│   │       ├── packet-validate-library-unix-gcc-simulation-null-arm64v8
│   │       │   └── packet-validate-library.a
│   │       ├── phy-native-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── phy-native-library.a
│   │       ├── phy-native-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── phy-native-library.a
│   │       ├── phy-native-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── phy-native-library.a
│   │       ├── phy-native-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── phy-native-library.a
│   │       ├── phy-native-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── phy-native-library.a
│   │       ├── phy-native-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── phy-native-library.a
│   │       ├── phy-pro2plus-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── phy-pro2plus-library.a
│   │       ├── phy-pro2plus-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── phy-pro2plus-library.a
│   │       ├── phy-pro2plus-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── phy-pro2plus-library.a
│   │       ├── phy-pro2plus-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── phy-pro2plus-library.a
│   │       ├── phy-pro2plus-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── phy-pro2plus-library.a
│   │       ├── phy-pro2plus-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── phy-pro2plus-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm12-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm13-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm21-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm22-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm24-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm12-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm13-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm21-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm22-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm24-rail
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── source-route-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── source-route-library.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm12-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm13-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm21-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm22-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm24-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg21-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg22-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg24-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg27-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm12-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm13-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm21-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm22-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm24-rail
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-leaf-stack-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zigbee-pro-leaf-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm12-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm13-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm21-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm22-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm24-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg21-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg22-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg24-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg27-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm12-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm13-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm21-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm22-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm24-rail
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-router-stack-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zigbee-pro-router-stack.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm12-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm13-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm21-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm22-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm24-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg21-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg22-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg24-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg27-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm12-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm13-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm21-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm22-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm24-rail
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-alt-mac-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zigbee-pro-stack-alt-mac.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-railgb-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg12p-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg13p-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg21-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg22-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-dualrail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg24-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-efr32mg27-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm12-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm12-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm13-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm13-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm21-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm21-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm22-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm22-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm24-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-gcc-mgm24-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-rail_mux
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-rail_mux-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-pro-stack-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── zigbee-pro-stack.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg12p-railgb
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg24-dualrail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm12-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm13-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm21-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm22-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm24-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-railgb
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-railgb-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-railgb-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-dualrail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-dualrail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-dualrail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm12-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm13-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm21-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm22-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm24-rail
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zigbee-r22-support-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │       │   └── zigbee-r22-support-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg12p-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg13p-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg21-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg22-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg24-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg27-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm12-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm13-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm21-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm22-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm24-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-gcc-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg12p-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg12p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg12p-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg13p-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg13p-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg13p-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg21-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg21-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg22-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg22-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg24-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg24-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg27-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg27-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-efr32mg27-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm12-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm12-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm12-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm13-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm13-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm13-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm21-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm21-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm21-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm22-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm22-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm22-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm24-rail
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm24-rail-ember_multi_network_stripped-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-cortexm3-iar-mgm24-rail-stack_protection
│   │       │   └── zll-library.a
│   │       ├── zll-library-unix-gcc-simulation-null-arch_i386-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-unix-gcc-simulation-null-arch_x86_64-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       ├── zll-library-unix-gcc-simulation-null-arm32v7-ember_multi_network_stripped
│   │       │   └── zll-library.a
│   │       └── zll-library-unix-gcc-simulation-null-arm64v8-ember_multi_network_stripped
│   │           └── zll-library.a
│   └── z-wave
│       ├── platform
│       │   └── SiliconLabs
│       │       └── PAL
│       │           └── lib
│       │               ├── libzpal_efr32zg14p231f256gm32.a
│       │               ├── libzpal_efr32zg14p731f256gm32.a
│       │               ├── libzpal_efr32zg23a010f512gm40.a
│       │               ├── libzpal_efr32zg23a010f512gm48.a
│       │               ├── libzpal_efr32zg23a020f512gm40.a
│       │               ├── libzpal_efr32zg23a020f512gm48.a
│       │               ├── libzpal_efr32zg23b010f512im40.a
│       │               ├── libzpal_efr32zg23b010f512im48.a
│       │               ├── libzpal_efr32zg23b011f512im40.a
│       │               ├── libzpal_efr32zg23b020f512im40.a
│       │               ├── libzpal_efr32zg23b020f512im48.a
│       │               ├── libzpal_efr32zg23b021f512im40.a
│       │               ├── libzpal_efr32zg28a110f1024gm48.a
│       │               ├── libzpal_efr32zg28a110f1024gm68.a
│       │               ├── libzpal_efr32zg28a112f1024gm48.a
│       │               ├── libzpal_efr32zg28a112f1024gm68.a
│       │               ├── libzpal_efr32zg28a120f1024gm48.a
│       │               ├── libzpal_efr32zg28a120f1024gm68.a
│       │               ├── libzpal_efr32zg28a122f1024gm48.a
│       │               ├── libzpal_efr32zg28a122f1024gm68.a
│       │               ├── libzpal_efr32zg28b310f1024im48.a
│       │               ├── libzpal_efr32zg28b310f1024im68.a
│       │               ├── libzpal_efr32zg28b312f1024im48.a
│       │               ├── libzpal_efr32zg28b312f1024im68.a
│       │               ├── libzpal_efr32zg28b320f1024im48.a
│       │               ├── libzpal_efr32zg28b320f1024im68.a
│       │               ├── libzpal_efr32zg28b322f1024im48.a
│       │               ├── libzpal_efr32zg28b322f1024im68.a
│       │               ├── libzpal_zgm130s037hgn1.a
│       │               ├── libzpal_zgm130s037hgn.a
│       │               ├── libzpal_zgm230sa27hgn.a
│       │               ├── libzpal_zgm230sa27hnn.a
│       │               ├── libzpal_zgm230sb27hgn.a
│       │               └── libzpal_zgm230sb27hnn.a
│       └── ZWave
│           └── lib
│               ├── libZWaveController_700s.a
│               ├── libZWaveController_800s.a
│               ├── libZWaveControllerPortable_700s.a
│               ├── libZWaveControllerPortable_800s.a
│               ├── libZWaveSlave_700s.a
│               └── libZWaveSlave_800s.a
└── util
    └── silicon_labs
        └── aox
            └── lib
                └── gcc
                    └── release
                        ├── libaox_static_darwin_x86_64.a
                        ├── libaox_static_linux_aarch64.a
                        ├── libaox_static_linux_armv7l.a
                        ├── libaox_static_linux_x86_64.a
                        └── libaox_static_windows_x86_64.a

2455 directories, 3216 files

```



# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

