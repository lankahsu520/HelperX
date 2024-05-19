# Amazon X9

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

>記得在電影“功夫之王”中，因為古代人來到現代，錯把免治馬桶當飲水機。將這情境搬至現在，就好像叫一位完全沒有使用過電腦的人，請他去 google，他有可能連 google 是什麼都不知道 ，要他如何是好。
>
>這邊研究 AWS (Amazon) 的服務時，也是有相同的問題。就算得到相對應的 Developer Guide，拜讀且照著步驟操作，也會有瞎子摸象的感受！
>
>因此得到一個結論，它們都過於跳躍式，名稱混用且常與一般生活不同，像 dashboard、console 、stack、object 等，如果沒有經驗或是一些概念，真的會被搞混。而最重要的是沒有“正確”的連結和圖片。反而詢問 [ChatGPT](https://openai.com/blog/chatgpt) 得到的結果比 Guide裏的步驟還漂亮。
>
>本篇算是引言，算是我剛入雲端時遇到的心得，目前還在努力學習。
>
>或許在不久的將來，我的想法又會改變。

# 1. Confused about operating the Eclipse editor

> 為什麼提到 Eclipse，why ? 
>
> 我開始接觸AWS 時，是先用aws cli (操作 S3)、ec2 和 KVS WebRTC SDK in C。這些對於身為 Embedded Engineer 只要一個 ssh 視窗，並且了解網路協定和資料流，就能操控所有東西，情況看似美好。
>
> 但是當要接觸其它AWS Services 時，每個操作都有  UI，然後一篇篇的使用手冊。這讓我想到去開發某一系統，需要安裝 Eclipse，第一步當然就是先去抓取該軟體，然後遵循了 blog or 手冊解說，一步步進行安裝，但還是有可能 50% 失敗！這中間有可能遠端 Server 已經停止更新了、plugin(s)  version 不同、安裝的先後順序不對，而最慘的是抓錯了 Eclipse 軟體。
>

# 2. What happened ?

## 2.1. Too mamy user guides

> 就字面上說的，就是太多使用手冊。有 administration guide、user guide、developer guide 和 [Amazon Web Services](https://aws.amazon.com) 等，每個都在講一件事，然後文件跳來跳去的，最後又跳回原點。

## 2.2. [Amazon Web Services](https://aws.amazon.com) vs. [Amazon Developers](https://developer.amazon.com)

> 這是兩個不同的網址！
>
> 詢問過那些號稱雲端工師時，居然回「不知道也」

## 2.3. XXX Services vs. XXX Services SDK

> 有什麼不同，網頁又說不清楚。
>
> 這邊提到的 SDK又跟一般所知有所不同，說真的依我目前的功力，暫時分不清楚！

## 2.4. Where is Dashboard or Console ?

> 每個 Services 都要用到 UI，而且都很 AI。
>
> 自知沒有這麼聰明，拜讀手冊後，還是不知 Dashboard or Console 在何處？ （當然我知道 **[Services by category](https://ap-northeast-1.console.aws.amazon.com/console/services?region=ap-northeast-1#)** 去找尋）為什麼手冊完全沒有連結呢？

## 2.5. Step by Step ?

> 每個 Services 都要用到 UI，舉 Lambda為例，Create function -> create a test event…。為什麼沒有圖示說明呢？

# 3. 改變態度和習慣

## 3.1. 先學繪圖，還是先學 Photoshop ?

>是先學繪圖，才去學使用 Photoshop；還是學了 Photoshop，再去學繪圖。
>
>如果是 AWS，個人覺得比較傾向像是學Photoshop，再學繪圖。
>
>（這邊只是舉例，並不適用從事繪圖人員）

```mermaid
flowchart LR
	Start([Start])
	
	學繪圖[學繪圖]
	學Photoshop[學Photoshop]

	End([End])
	
	Start-->學Photoshop-->學繪圖-->End

```

## 3.2. 程式語言不再是重點

>雖然不是重點，但是還是要會！

## 3.3. 電腦基本常識要融會慣通

>就舉 HTTP的運作方式，很多人都是似懂非懂。HTTP是可以“同時”雙向傳輸的（非無線電，比較像電話），這很多人都誤解。
>
>HTTP 是架在 Socket 之上的。
>
>一個網頁，瀏覽器其實在背景執行了多條連線。
>
>強行使用 Token 會比密碼更安全？
>
>密碼壓一次不安全，就壓二次？

## 3.4. 其它

> 因為我是雲端初學者，正在努力…

# 4. From ChatGPT
>要成為雲端工程師，您需要掌握以下技能：
>
>1. 基本的計算機科學知識，包括資料結構和演算法、作業系統、網路和資料庫。
>2. 雲端計算基礎知識，包括公有雲、私有雲、混合雲等雲服務模型以及與之相關的概念，如虛擬化、容器化和自動化。
>3. 學習雲平台和工具，如AWS、Azure、Google Cloud等公有雲平台，以及Kubernetes、Docker等雲原生工具。
>4. 了解基本的編程語言，如Python、Java、Go等，以及相應的SDK和API，以便使用雲服務和工具。
>5. 學習基於雲端的架構和設計，包括服務定位、彈性、安全性和可擴展性等。
>
>以下是一些可以幫助您成為雲端工程師的步驟：
>
>1. 學習雲端計算的基礎知識，包括雲服務模型、雲計算架構、虛擬化等。
>2. 研究不同的雲平台和工具，例如AWS、Azure、Google Cloud等，並了解它們提供的不同服務和工具。
>3. 學習使用雲服務的基本編程技能，如Python、Java、Go等，並了解雲服務的SDK和API。
>4. 實踐使用雲平台和工具，例如在AWS或Azure上創建虛擬機、儲存桶、伺服器等。
>5. 學習雲安全和網路安全知識，例如身份驗證和訪問控制、資料加密等。
>6. 參加雲計算社區和活動，與其他雲端工程師交流經驗和知識。
>7. 獲取相關的證書，例如AWS證書、Azure證書等，以證明您具備雲端工程師的技能和知識。
>
>最重要的是，不斷學習和實踐，並保持對新技術和工具的開放心態，這是成為一名優秀的雲端工程師所必需的。


# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage


# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
