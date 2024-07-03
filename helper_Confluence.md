# [Confluence](https://www.atlassian.com/software/confluence)
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

>就是文件管理系統，相較於使用 Google Drive，一樣有共同編輯的功能，但是少了檔案的概念。
>
>本篇主要是嘗試使用此系統，配合個人的使用習慣，將遇到的相關問題記錄下來而已。

> [維基百科](https://zh.wikipedia.org/zh-tw/Confluence) **Confluence** 是一款建基於網路企業[維基](https://zh.wikipedia.org/wiki/維基) (collaboration software) 的軟體，由澳洲軟體公司艾特萊森[Atlassian](https://zh.wikipedia.org/wiki/Atlassian)所開發，[[1\]](https://zh.wikipedia.org/zh-tw/Confluence#cite_note-1) 使用[Java](https://zh.wikipedia.org/wiki/Java)編寫，並於2004年推出。Confluence 獨立軟體內建Tomcat網頁瀏覽器與[hsql](https://zh.wikipedia.org/wiki/HSQLDB)資料庫，同時也支援其他資料庫[[2\]](https://zh.wikipedia.org/zh-tw/Confluence#cite_note-2)。
>
> 開發公司在市場上將Confluence定位為[企業軟體](https://zh.wikipedia.org/wiki/企業軟體)，可做為公司內部使用軟體或於[SaaS](https://zh.wikipedia.org/wiki/SaaS)或於[AWS](https://zh.wikipedia.org/wiki/亞馬遜雲端運算服務)上使用[[3\]](https://zh.wikipedia.org/zh-tw/Confluence#cite_note-3)[[4\]](https://zh.wikipedia.org/zh-tw/Confluence#cite_note-4)。

# 2. Confluence

>請自行使用個人帳號建立並登入，這樣才有管理者權限。它提供30天的免費試用。
>
>這邊為什麼建議個人建立，因為如果使用公司建立的空間，如果遇到權限的問題，在網頁是不會有任何提示的，而你將無從解決。

## 2.1. My Home

![Confluence010101](./images/Confluence010101.png)

### 2.1.1. Change Language & Region

#### A. Manage Account

![Confluence010102](./images/Confluence010102.png)

#### B. Account preferences

![Confluence010103](./images/Confluence010103.png)

### 2.1.2. Atlassian Homepage

> go to Atlassian Homepage

#### A. YOUR APPS

![Confluence010201](./images/Confluence010201.png)

#### B. G'day, Lanka Hsu

![Confluence010202](./images/Confluence010202.png)

### 2.1.3. Invite Person

#### A. Administration

![Confluence010301](./images/Confluence010301.png)

#### B. Manage users of Confluence

![Confluence010302](./images/Confluence010302.png)

#### C. Invite users
![Confluence010303](./images/Confluence010303.png)

#### D. Input Email
![Confluence010304](./images/Confluence010304.png)

#### E. Users

![Confluence010305](./images/confluence010305.png)

#### F. Groups

![Confluence010306](./images/Confluence010306.png)

#### G. confluence-users-lankahsu

![Confluence010307](./images/Confluence010307.png)

### 2.1.4. Remove User

####  A. Select User

![Confluence010401](./images/Confluence010401.png)

#### B. Remove User

![Confluence010402](./images/Confluence010402.png)

#### C. Confirm
![Confluence010403](./images/Confluence010403.png)

![Confluence010404](./images/Confluence010404.png)

## 2.2. Spaces

### 2.2.1. Create a space

#### A. Create a space

![Confluence020101](./images/Confluence020101.png)

#### B. Choose a template

> 說真的，有時功能太多，反而會造成選擇障礙。
>
> 選擇最簡單的 Blank

![Confluence020102](./images/Confluence020102.png)

#### C. Personalize your space

![Confluence020103](./images/Confluence020103.png)

#### C. HelloWorld space

![Confluence020104](./images/Confluence020104.png)

### 2.2.2. List spaces

#### A. View all spaces

![Confluence020201](./images/Confluence020201.png)

#### B. Spaces - star this space

![Confluence020202](./images/Confluence020202.png)

### 2.2.3. Remove a space

#### A. Space settings

![Confluence020301](./images/Confluence020301.png)

#### B. Send this space to trash

![Confluence020302](./images/Confluence020302.png)

## 2.3. Contents

### 2.3.1. Create a Page

#### A. Create

![Confluence030101](./images/Confluence030101.png)

#### B. Rename

![Confluence030102](./images/Confluence030102.png)

#### C. Input your name

![Confluence030102a](./images/Confluence030102a.png)

#### D. 1stLove Page

![Confluence030104](./images/Confluence030104.png)

## 2.4. Apps

>當編輯 Page 時，如果要使用 mermaid 畫圖時，需使用 Confluence 的 Macro 功能（或稱 *embedded* function）。

>而 Macro 是需要使用者另行安裝 Apps（或稱 Plugins）來滿足需求。值得注意的是，有些 Apps 要額外收錢。

### 2.4.1. Admin vs. User

> 請先確定使用者的權限

#### A. Admin

![Confluence040101](./images/Confluence040101.png)

#### B. User

![Confluence040102](./images/Confluence040102.png)

### 2.4.2. Markdown for Confluence - Markdown Editor in Confluence

> Native Markdown Editor adds alternative editor that supports Markdown in Confluence

#### A. Find new apps

![Confluence040201](./images/Confluence040201.png)

#### B. Search

![Confluence040202](./images/Confluence040202.png)

#### C. Get app

![Confluence040203](./images/Confluence040203.png)

#### D. App requested

![Confluence040204](./images/Confluence040204.png)

#### E. Email

![Confluence040205](./images/Confluence040205.png)

#### F. View app request (admin)

![Confluence040206](./images/Confluence040206.png)

#### G. Manage app requests (admin)

![Confluence040207](./images/Confluence040207.png)

#### H. Get app (admin)

![Confluence040208](./images/Confluence040208.png)

#### I. Manage app (admin)

![Confluence040209](./images/Confluence040209.png)

#### J. User-installed apps (admin)

![Confluence040210](./images/Confluence040210.png)

#### K. Edit 1stLove Page

![Confluence040211](./images/Confluence040211.png)

### 2.4.3. Mermaid Charts & Diagrams for Confluence

> Mermaid macro 

![Confluence040301](./images/Confluence040301.png)

### 2.4.4. Mermaid Diagrams for Confluence

> Mermaid macro 

![Confluence040401](./images/Confluence040401.png)

# Appendix

# I. Study

## I.1. [更好的網頁開發流程：學會運用 Confluence, Airtable, Jira 與 Abstract](https://medium.com/as-a-product-designer/a-better-web-development-workflow-confluence-airtable-jira-abstract-zh-24fc8d5b8329)

## I.2. [Atlassian Marketplace](https://marketplace.atlassian.com)

# II. Debug

## II.1. [How can I uninstall an app before the end of the trial period?](https://community.atlassian.com/t5/Confluence-questions/How-can-I-uninstall-an-app-before-the-end-of-the-trial-period/qaq-p/2335282)

# III. Glossary

# IV. Tool Usage

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

