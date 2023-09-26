# Software Enginner X9 (in C)

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

# 1. How to Become a Software Engineer

> 以下是幾個 milestones，有志者可以先朝著這些前進。

## 1.1. HelloWorld

> 先從一個簡單的 HelloWorld 開始

```mermaid
flowchart LR
	Start([Start])
	SelectEditor{{Select Editor - vim}}
	SelectCompiler{{Select Compiler - gcc}}
 	HelloWorld.c[/Get HelloWorld.c/]
 	Compile[Compile the code - gcc]
 	HelloWorld[/binary - HelloWorld/]
  Run[Run HelloWorld]
  End([End])
	
	Start-->SelectEditor-->SelectCompiler
	SelectCompiler-->HelloWorld.c
	HelloWorld.c-->Compile-->HelloWorld
	HelloWorld-->Run-->End
```

## 1.2. Study C language

```mermaid
flowchart LR
	Start([Start])
	Buy{{Buy a C book, E-Book 要找最簡單 step by step類別}}
 	Study[Study]
  End([End])
	
	Start-->Buy-->Study
	Study-->End
```

## 1.3. Add more the Debugging Messages

> 學會加入 Debugging Messages。

```mermaid
flowchart LR
	Start([Start])
	codes[/main.c + *.c/]
	debug[Add more the Debugging Messages]
	main[/binary - main/]
  Run[Run main]
  End([End])
	
	Start-->codes-->debug
	debug-->|gcc|main-->Run-->End
```

## 1.4. Learn make, cmake or meson

>此時寫程式已經不是問題了；將程式分類，存放在不同檔案裏，並學習軟體工具來自動化編譯程式。
```mermaid
flowchart LR
	Start([Start])
	
	codes[/main.c + *.c/]
	make[make]
	cmake[cmake]
	meson[meson]

	main[/binary - main/]
  Run[Run main]
  End([End])
	
	Start-->codes
	codes-->make-->|gcc|main
	codes-->cmake-->|gcc|main
	codes-->meson-->|gcc|main
	main-->Run-->End

```

## 1.5. Static/Shared libraries

>將程式內容分類，儲存成不同檔案後，再打包成 Static/Shared libraries

```mermaid
flowchart LR
	Start([Start])
	
	codes[/*.c/]
	main.c[/main.c/]

	Static[/Static libraries/]
	Shared[/Shared libraries/]
	main.o[/main object/]

	main[/binary - main/]
  Run[Run main]
  End([End])
	
	Start-->codes
	Start-->main.c
	
	codes-->|gcc|Static --> |link|main
	codes-->|gcc|Shared --> |link|main
	main.c-->|gcc|main.o --> |link|main

	main-->Run-->End

```

## 1.6. Search Sample Codes

> 先弄清楚該程式目的或意圖，是要存取檔案、抓取圖片、例行工作、或是要進行計算等。
>
> 然後至網路上尋找（以前網路沒這麼發達時，看文件後自己慢慢刻，不然就是要問前輩，然後寫過的程式要當下次的範本）

```mermaid
flowchart LR
	Start([Start])
	
	Caculate[Caculate]
	ClientServer[Client / Server]
	Database[Access Database]
	File[File I/O]
	IPC[Interprocess Communication]
	Network[Access Network]
	Routine[Routine]
	Others[...]

	Sample[Search Sample Codes]
	Study[Study the Sample Codes]

	End([End])
	
	Start-->Caculate-->Sample
	Start-->ClientServer-->Sample
	Start-->Database-->Sample
	Start-->File-->Sample
	Start-->IPC-->Sample
	Start-->Network-->Sample
	Start-->Routine-->Sample
	Start-->Others-->Sample

	Sample-->Study-->End
```

## 1.7. Link with Open-source

>隨著需求增加，並不需要每個程式都要自己寫，可至網路尋找 Open-source。

```mermaid
flowchart LR
	Start([Start])
	
	open[/Open-source/]
	codes[/*.c/]
	main.c[/main.c/]

	Static[/Static libraries/]
	Shared[/Shared libraries/]
	main.o[/main object/]

	main[/binary - main/]
  Run[Run main]
  End([End])
	
	Start-->codes
	Start-->main.c
	Start-->open

	open-->|gcc|Static
	open-->|gcc|Shared
	codes-->|gcc|Static --> |link|main
	codes-->|gcc|Shared --> |link|main
	main.c-->|gcc|main.o --> |link|main

	main-->Run-->End
```

# 2. 培養態度和習慣

> 這幾項，我跟某些人說了n次，他們還是做不到

#### A. 導入版本控管

> 網路上免錢的有GitHub 和 GitLab。
>
> 另外也可以自建 git  或 svn server。

#### B. 設立里程碑 （milestone），並用版本（version）來區格

>這對專案管理很重要，可幫助預估時間，事後可以分析那些部分延遲。
>
>曾有個學霸跑來嗆我，東西都還沒做，就訂這麼多版本，這東西是什麼鬼啊！經過我一番的解釋，他還是相當不屑。
>
>我很平庸，不是學霸，至於你覺得有道理，就參考看看。
>
>這裏還有個隱藏的能力，就是預估。

#### C. 寫文件

>身為一個人，建議善用 MarkDown 記錄相關筆記，少用 doc。

#### D. copy-paste

>當你的樣本夠多時，寫程式真的就是不斷的 copy-paste。
>
>版權的問題，算是很大的課題，這邊就不討論。

# 3. Know-how

> 基本常識、技能要補足。

#### A. 作業系統 OS 的基本概念

> 這邊不是要你深入特定 OS的操作和設定。而是要去清楚 OS 管理整個電腦、硬體資源，而我們要如何跟 OS 獲取相對應的資源。

#### B. Thread、Mutex 和 Semaphore

> 這些其實在 OS 中有提到，不過特別拉出成一個項目，是因為後面寫程式時很常用到。

#### C. 同步（synchronous）、 非同步 （asynchronous）、並行（Parallel）和序列（Sequential）

> 要了解這些是什麼。不然跟人家討論合作時，會被認為知識水平過低。

#### D. 堆疊（Stack）& 佇列（Queue）

>要知道資料存放和取用的順序，這些常與並行、序列共用。
>
>像是存取RS232時，放入Queue再處理，就能解決掉包和系統卡住等問題。

#### E. [OSI模型](https://zh.wikipedia.org/zh-tw/OSI模型)

> 因為現在已經是網路的時代，建議要了解其基本概要。

#### F. [Network socket](https://en.wikipedia.org/wiki/Network_socket) 

>也因為是網路時代，就要知道什麼是 Socket。這個很重要，一定要搞清楚！
>
>不管 HTTP、FTP、WebSocket 等都是從其衍生出來。我曾有問過一位Web UI的設計者，關於 Client / Server 的概念，結果得到的答案是一無所知，那更不可能討論 MQTT、WebSocket 等協定。

# 3. From ChatGPT
> 成為軟件工程師需要以下步驟：
>
> 1. 學習編程語言和計算機科學基礎知識。有許多在線課程和教程可供選擇，如Codecademy、Udemy、Coursera等。您可以選擇學習流行的編程語言，如Java、Python、JavaScript等。
>
> 2. 通過練習編程來提高自己的技能。編寫小型項目，例如編寫游戲、制作網站或移動應用程序等，以實踐所學知識。
>
> 3. 參加編程社區活動。例如，加入GitHub社區並與其他開發人員協作，了解其他人是如何解決問題的。
>
> 4. 獲得學位或證書。雖然學位或證書並不是成為軟件工程師的必要條件，但它們可以證明您具備必要的知識和技能。例如，您可以獲得計算機科學學位或編程證書。
>
> 5. 在實際項目中獲得經驗。通過在實際項目中工作，您可以獲得實際的編程經驗，了解如何與客戶合作，並學習如何處理現實世界的編程挑戰。
>
> 6. 不斷學習和更新技能。技術在不斷發展，因此您需要不斷學習和更新自己的技能，以保持競爭力並適應新的編程技術和工具。
>
> 最重要的是，成為軟件工程師需要持續學習、實踐和不斷更新自己的技能。與其他開發人員和專業人士互動，分享經驗和知識，並積極參與開發社區和項目。

>ChatGPT 算是 google 大神的進階版，相當不錯的工具。雖好用，但是還是要靠自己學習，不然有些知識會很不完整。

# Appendix

# I. Study

# II. Debug

# III. Glossary

#### GOPS, Giga Operations per second

>[ChatGPT]
>
>"GOPS" 是 "Giga Operations per Second" 的縮寫，意思是每秒十億（1,000,000,000）次操作。這是一個衡量計算機系統或硬體設備性能的指標，通常用於描述計算能力、處理速度或操作執行速度。
>
>"GOPS" 的使用情境可能包括：
>
>1. **中央處理器（CPU）性能：** 常常用來表示一個 CPU 每秒鐘能夠執行的指令數目。較高的 GOPS 值通常表示更高的計算能力。
>2. **圖形處理器（GPU）性能：** 用於衡量 GPU 在處理圖形或並行計算工作時的效能。在遊戲和機器學習等應用中，GOPS 是一個重要的性能評估標準。
>3. **網絡設備性能：** 在網絡硬體中，GOPS 可以用於表示每秒處理的封包數或網絡流量。
>4. 
>5. **儲存設備性能：** 在硬碟驅動器（HDD）或固態硬碟（SSD）等儲存設備中，GOPS 可用於描述每秒執行的讀寫操作數目。
>6. **計算任務的效能：** 在科學計算、數值模擬或大數據處理等領域，GOPS 可以表示每秒執行的計算操作數，用於評估計算任務的效能。
>
>總之，GOPS 是一個用於衡量各種計算或操作的速度或效能的單位，它的值越高，通常表示相應的系統或硬體設備性能越強大。這是在評估許多計算機和硬體性能方面的重要指標之一。

#### SDK, Software Development Kit

>一句話，就是協助軟體工程師開發的資源和工具。
>
>[ChatGPT]
>
>SDK 是 "Software Development Kit"（軟體開發工具包）的縮寫，它是一組工具、函式庫、文檔和示例程式碼的集合，用於協助軟體開發人員創建特定平台、框架或應用程式的軟體。SDK 旨在簡化和加速軟體開發過程，提供必要的資源和工具，以便開發人員可以有效地設計、開發和測試軟體。
>
>以下是 SDK 的一些常見特點和用途：
>
>1. **函式庫和 API：** SDK 包含函式庫和應用程式編程介面（API），使開發人員可以訪問特定平台或框架的功能。這些函式庫和 API 提供了一組預先定義的函數和類，可以用於實現特定任務。
>2. **開發工具：** SDK 包括用於編譯、除錯和測試代碼的工具，如編譯器、集成開發環境（IDE）、模擬器和調試器。
>3. **示例程式碼：** SDK 提供示例程式碼，開發人員可以參考這些範例來了解如何使用 SDK 中的功能。
>4. **文檔和教程：** SDK 通常包括詳細的技術文檔、API 文件和教程，以幫助開發人員學習如何使用 SDK 中的工具和資源。
>5. **模擬和測試環境：** 一些 SDK 包括模擬和測試環境，讓開發人員可以在模擬的環境中測試應用程式，而無需實際硬體或軟體。
>6. **支援多平台：** 一些 SDK 設計為支援多個操作系統或硬體平台，使開發人員能夠跨平台開發應用程式。
>
>SDK 可以用於各種不同的應用，包括移動應用程式開發、網頁開發、遊戲開發、嵌入式系統開發、物聯網（IoT）應用程式開發等。它們通常由平台或框架的提供者提供，以協助開發人員在特定環境中創建高質量的軟體。

# IV. Tool Usage


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
