

# IoT 物聯網

# 1. Overview - [維基百科](https://zh.wikipedia.org/zh-tw/物联网)
> **物聯網**（英語：Internet of Things，簡稱**IoT**）是一種計算裝置、機械、數位機器相互關聯的系統，具備[通用唯一辨識碼](https://zh.wikipedia.org/wiki/通用唯一辨識碼)（UID），並具有通過網路傳輸數據的能力，無需人與人、或是人與裝置的互動

## 1.1. Path vs Language

> 這個主題很重要！一堆人搞不清什麼是協定、什麼是語言等。
>
> 本章節將會用生活化的方式介紹

### 1.1.1. Path

#### A. 人與人

>人與人的接觸有 e-mail、SMS、phone、kiss、eye contact 等等

```mermaid
flowchart LR

Lanka[Lanka]
Mary[Mary]
Lanka <--> |e-mail|Mary
Lanka <--> |SMS|Mary
Lanka <--> |phone|Mary
Lanka <--> |kiss|Mary
Lanka <--> |eye contact|Mary

```

#### B. MtoM

>從圖中，目前市面上常看到的連結方式有 Ethernet、Wi-Fi、BLE等

```mermaid
flowchart LR

Lanka[Lanka's PC]
Mary[Mary's PC]
Lanka <--> |Ethernet|Mary
Lanka <--> |Wi-Fi|Mary
Lanka <--> |BLE|Mary
Lanka <--> |Zigbee|Mary
Lanka <--> |Thread|Mary
Lanka <--> |Z-Wave|Mary
```

### 1.1.2. Language

#### A. 人與人

```mermaid
flowchart LR

Lanka[Lanka]
Mary[Mary]
Lanka <--> |e-mail / 中文|Mary
Lanka <--> |SMS / 中文|Mary
Lanka <--> |phone / 國語|Mary
Lanka <--> |kiss / 唾液|Mary
Lanka <--> |eye contact / 眼神|Mary

```

#### B. MtoM

>這個圖相當的重要。Ethernet 和 Wi-Fi  是我們平常所說的網路系統，在此系統中都是base on TCP/IP  “架構” 下亙聯亙通。而這邊你只要把它視為某種 “語言” 即可。
>
>Zigbee 是一個很好的例子，在 Zigbee 3.0 發佈前存在著 Zigbee 1.2 or 更舊的版本，當兩方雖然都是說著  Zigbee 1.2  “語言” 時，就好像一位說 “英文”，而一位說 “中文”，是沒有辦法溝通的；而至 Zigbee 3.0 統一其 “語言“，達到所謂的亙聯亙通，就如使用 “英文“ 為共通話言。（雖然 Zigbee 3.0 號稱已經統一了，實際愮情形還有待大家去發現）

```mermaid
flowchart LR

Lanka[Lanka's PC]
Mary[Mary's PC]
Lanka <--> |Ethernet / TCP/IP|Mary
Lanka <--> |Wi-Fi / TCP/IP|Mary
Lanka <--> |"BLE (2.4 GHz) / BLE"|Mary
Lanka <--> |"Zigbee (2.4 GHz) / Zigbee 3.0"|Mary
Lanka <--> |"Thread (2.4 GHz) / Thread"|Mary
Lanka <--> |"Z-Wave (Sub-1 GHz) / Z-Wave"|Mary
```

## 1.2. Gateway vs. Router

```mermaid
flowchart LR
	subgraph Office["Central Office"]
		subgraph GatewayO[Gateway]
			PhoneO[PhoneGW]
		end
	end
	subgraph Modem["ADSL Modem"]
		subgraph RouterM[Router]
			RouterWiFiM[Wifi]
			RouterLanM[Ethernet]
		end
		subgraph GatewayM[Gateway]
    	PhoneM[PhoneGW]
		end
    PhoneM<-->RouterM
	end
	subgraph A["Wireless Router Archer AX50"]
		subgraph RouterA[Router]
			RouterWiFiA[Wifi]
			RouterLanA[Ethernet]
		end
		subgraph GatewayA[Gateway]
			ZigbeeGWA[ZigbeeGW]
			ThreadGWA[ThreadGW]
		end
		GatewayA<-->RouterA
	end

PC[PC]
Phone[Phone]
Zigbee[Zigbee]
Thread[Thread]

Zigbee <--> |Zigbee|ZigbeeGWA
Thread <--> |Thread|ThreadGWA

PC <--> |Ethernet|RouterLanA
Phone <--> |Wi-Fi|RouterWiFiA

RouterM <--> |Ethernet|RouterA

PhoneO <--> |phone line|PhoneM
```
#### A. Gateway

> 於不同協定間交換資料

#### B. Router

>於不用通路但是使用相同的協定間交換資料

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
