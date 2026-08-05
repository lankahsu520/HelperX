# Stock (股票)
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

> 這裏不是透過股票技術分析研究過去的**價格**與**成交量**圖表，來預測未來股價走勢的方法。只是提供一些股票的基本常識。

# 2. 股票撮合

> 成交價到底取決於誰？買價？賣價？還是其他？

> **價格優先**：買單中價格高者優先；賣單中價格低者優先。
>
> **時間優先**：價格相同時，先送進交易所的委託優先成交。

## 2.1. 基本撮合規則

### 2.1.1. 簡易狀況

| 買           | 賣          | 成交價 |
| ------------ | ----------- | ------ |
| 100          | 110         | 未成交 |
| 100          | 100         | 100    |
| 100          | 90 (先掛單) | 90     |
| 100 (先掛單) | 90          | 100    |

### 2.1.2. 優選<font color="green">低賣</font>價格（先買最便宜的）

| 買                               | 賣                            | 成交價 |
| -------------------------------- | ----------------------------- | ------ |
| 100 × 10<br>99  × 20<br>98  × 30 | 103 × 6<br>102 × 8<br>101 × 5 | 未成交 |

> 這時你下<font color="red">買</font> 105 × 14，
>
> 你將依序吃掉 101 x 5 -> 102 x 8 -> 103 x 1

### 2.1.3. 優選<font color="red">高買</font>價格（先賣給出高價）

| 買                               | 賣                            | 成交價 |
| -------------------------------- | ----------------------------- | ------ |
| 100 × 10<br>99  × 20<br>98  × 30 | 103 × 6<br>102 × 8<br>101 × 5 | 未成交 |

> 這時你下<font color="green">賣</font> 90 × 14，
>
> 你將依序吃掉 100 x 10 -> 99 x 4

## 2.2. 鎖跌停（委賣很多、委買沒有）

> 鎖跌停發生在賣單>買單，價格已經壓低至跌停價。
>
> 跌停價：90
>
> 委賣 90，10000張

| 買   | 賣                    | 成交價 |
| ---- | --------------------- | ------ |
|      | 90  (10000張, 先掛單) | 未成交 |

> 這時你下<font color="red">買</font> 100 × 14 元，
>
> 你將依序吃掉 90 x 14

## 2.3. 鎖漲停（委買很多、委賣沒有）

> 鎖漲停發生在買單>賣單，價格已經推高至漲停價。
>
> 漲停價：110
>
> 委買 110，10000張

| 買                     | 賣   | 成交價 |
| ---------------------- | ---- | ------ |
| 110  (10000張, 先掛單) |      | 未成交 |

> 這時你下<font color="green">賣</font> 90 × 14，
>
> 你將依序吃掉 110 x 14

# 3. 加權指數

> [臺灣證券交易所發行量加權股價指數成分股暨市值比重](https://www.taifex.com.tw/cht/2/weightedPropertion)

> 這裏用簡單的例子來說明，如果只發行兩隻股票 A 和 B 時

## 3.1. 權重相同

| 證券名稱 | 股價 | 市值佔 大盤比重 |
| -------- | ---- | --------------- |
| A        | 100  | 50%             |
| B        | 100  | 50%             |

> 100 * 0.5 + 100 * 0.5 = 100，加權指數為 100

## 3.2. 權重不同

> 如果當兩隻股票的權重不同時

### 3.2.1. 股價相同

| 證券名稱 | 股價 | 市值佔 大盤比重 |
| -------- | ---- | --------------- |
| A        | 100  | 30%             |
| B        | 100  | 70%             |

> 100 * 0.3 + 100 * 0.7 = 100，加權指數為 100

### 3.2.2. 權重高的股價偏高時

| 證券名稱 | 股價 | 市值佔 大盤比重 |
| -------- | ---- | --------------- |
| A        | 100  | 30%             |
| B        | 1000 | 70%             |

> 100 * 0.3 + 1000 * 0.7 = 730，加權指數為 730

### 3.2.3. 權重高的股價偏低時

| 證券名稱 | 股價 | 市值佔 大盤比重 |
| -------- | ---- | --------------- |
| A        | 100  | 30%             |
| B        | 10   | 70%             |

> 100 * 0.3 + 10 * 0.7 = 37，加權指數為 37

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

