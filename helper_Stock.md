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

# 1. 股票撮合

> 成交價到底取決於誰？買價？賣價？還是其他？

> **價格優先**：買單中價格高者優先；賣單中價格低者優先。
>
> **時間優先**：價格相同時，先送進交易所的委託優先成交。

## 1.1. 基本撮合規則

### 1.1.1. 簡易狀況

| 買           | 賣          | 成交價 |
| ------------ | ----------- | ------ |
| 100          | 110         | 未成交 |
| 100          | 100         | 100    |
| 100          | 90 (先掛單) | 90     |
| 100 (先掛單) | 90          | 100    |

### 1.1.2. 優選<font color="green">低賣</font>價格（先買最便宜的）

| 買                               | 賣                            | 成交價 |
| -------------------------------- | ----------------------------- | ------ |
| 100 × 10<br>99  × 20<br>98  × 30 | 103 × 6<br>102 × 8<br>101 × 5 | 未成交 |

> 這時你下<font color="red">買</font> 105 × 14，
>
> 你將依序吃掉 101 x 5 -> 102 x 8 -> 103 x 2

### 1.1.3. 優選<font color="red">高買</font>價格（先賣給出高價）

| 買                               | 賣                            | 成交價 |
| -------------------------------- | ----------------------------- | ------ |
| 100 × 10<br>99  × 20<br>98  × 30 | 103 × 6<br>102 × 8<br>101 × 5 | 未成交 |

> 這時你下<font color="green">賣</font> 90 × 14，
>
> 你將依序吃掉 100 x 10 -> 99 x 4

## 1.2. 鎖跌停（委賣很多、委買沒有）

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

## 1.3. 鎖漲停（委買很多、委賣沒有）

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

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

