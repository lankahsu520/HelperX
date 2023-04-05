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
> 詢問過那些號稱雲端工師時，居然說「不知道這是不同網址」

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

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage


# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.
