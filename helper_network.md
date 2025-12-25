# Network (IP base)
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

> 筆記 only。

# 2. TCP/IP 四層架構 vs OSI七層架構

> 網路上很多教學，可以幫助大家。你可以不用深入了解，有概念即可。
>
> 這邊要提醒要踏入此業的同仁，要先搞清楚 socket、listen、connect、read 和 write 等簡單操作和資料流。

> 遇到了幾位，請他們畫出簡單的 HTTP 時序圖都不會。

```mermaid
sequenceDiagram
	participant Chrome as Chrome
	participant HTTP as HTTP Server
	participant API as RD API

	Chrome->>HTTP: request
	HTTP->>API: run
	API->>HTTP: result
	HTTP->>Chrome: response
```

# 3. IPv4 vs IPv6

> IPv6 和 IPv4 是不相容的！
>
> IPv6 和 IPv4 是不相容的！
>
> IPv6 和 IPv4 是不相容的！

> 當初為了解決 IPv4 數量不足的問題，而推出 IPv6。但是 ISP 這端並沒有“義務”提供 IPv6，這就造成IPv6的推展不足。

```mermaid
flowchart LR
	subgraph Home[Home]
		Modem[ADSL Modem]
		Router[Router<br> IPv4-on, IPv6-off]
		PC
		Phone
		
		PC <--> Router <--> Modem
		Phone <--> Router
		TV <--> Router
	end

	subgraph ISP[Internet Service Provider]
	
	end
	
	Modem <--> ISP -..-x ipv6.google.com
	

```

> 基本上終端使用者的設備都已經有支援 IPv6，只差在 Router 開啟 IPv6 的功能。
>
> 網路很多 Q&A 都是請各位回去查看終端設備，完全沒有提及 Router 和 ISP 的問題。

> 要解決此問題，就要看看當初是申請 ADSL 動態 IP，則只要更動終端使用者的 Router。
>
> 但是使用固定 IP 的情狀下，就得跟 ISP 申請 + 更動終端使用者的 Router。

# 4. Service Discovery

> 此章節利用 ChatGPT 進行整理

## 4.1. Protocol

> 以下是常用的協定，用於瀏覽和解析在區域網中註冊的任何系統或服務。大家不要再自己刻了。

> `224.0.0.X` 和 `FF02::/16` 都屬於「**本地鏈路多播**（Link-local Multicast）」，不會被路由器轉發。

> Wireshark 解析，filrer
>
> ip.dst == 239.255.255.250 or ip.dst == 224.0.0.251 or ip.dst == 224.0.0.252
>
> ipv6.dst == ff02::c or ipv6.dst == ff02::fb or ipv6.dst == ff02::1:3

| 協定名稱                                           | 傳輸層 | Multicast/Broadcast IP     | 通訊埠 | 用途／常見設備                    |
| -------------------------------------------------- | ------ | -------------------------- | ------ | --------------------------------- |
| **SSDP**<br>Simple Service Discovery               | UDP    | 239.255.255.250, FF02::C   | 1900   | UPnP（智慧電視、NAS、路由器）     |
| **WS-Discovery**<br>Web Services Dynamic Discovery | UDP    | 239.255.255.250, FF02::C   | 3702   | Windows 裝置、影印機、IP CAM、IoT |
|                                                    |        |                            |        |                                   |
| **mDNS**<br>Multicast DNS                          | UDP    | 224.0.0.251, FF02::FB      | 5353   | Bonjour（Apple 裝置、Linux 系統） |
| **Avahi (Linux mDNS)**<br>Linux 的 mDNS 實作       | UDP    | 224.0.0.251, FF02::FB      | 5353   | Linux、Raspberry Pi、IoT          |
|                                                    |        |                            |        |                                   |
| **LLMNR**<br>Link-Local Multicast Name Res.        | UDP    | 224.0.0.252, FF02::1:3     | 5355   | Windows 裝置名稱解析              |
| **NetBIOS**<br>NetBIOS Name Service                | UDP    | 224.0.0.1                  | 137    | Windows SMB 檔案分享發現          |
|                                                    |        |                            |        |                                   |
| **DHCP Discover**<br>DHCP 發現封包                 | UDP    | 255.255.255.255            | 67,68  | 設備開機找 DHCP server            |
| **NBNS**<br>NetBIOS Name Service                   | UDP    | 255.255.255.255, 224.0.0.1 | 137    | 舊式 Windows 名稱廣播             |

## 4.2. Use Case

| 應用情境             | 協定                           |
| -------------------- | ------------------------------ |
| Apple 裝置發現       | mDNS（Bonjour）                |
| Windows 網芳         | NetBIOS, LLMNR, WS-Discovery   |
| Linux IoT / Zeroconf | Avahi, mDNS                    |
| Printer 發現         | WS-Discovery, mDNS, SNMP       |
| 家用路由器廣播       | SSDP + mDNS                    |
| 工控設備（PLC, HMI） | WS-Discovery, PROFINET, OPC UA |

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

