# [GitHub](https://docs.github.com)
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

# 1. Communicate with GitHub

## 1.1. Use SSH keys to communicate with GitHub

## 1.2. [Use Personal Access Tokens](https://github.com/settings/tokens)

```mermaid
flowchart LR
	Settings[Settings]
	Developer[Developer settings]
	Personal[Personal access tokens]
	Tokens["Tokens (classic)"]
	Generate["Generate new token (classic)"]
	Settings-->Developer-->Personal-->Tokens-->Generate

```
### 1.2.1. Create a new Token

>Note: 名稱或註記
>Expiration: 設定期限
>Select scopes: 設定存取範圍，一般選擇 repo 就可
>
>選項設定完成後，按下 Generate token。

![GitHub_token01](./images/GitHub_token01.png)
> 請記下，如 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

![GitHub_token01](./images/GitHub_token02.png)

### 1.2.2. Use the new Token

#### A. Select a repository and get the url

> https://github.com/lankahsu520/HelperX.git

#### B. Apply the new Token

> https://{USERNAME}:{TOKEN}/{ORIGINAL-URL}
>
> https://lankahsu520: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@github.com/lankahsu520/HelperX.git

#### C. Git clone the repository 

```bash
$ git clone https://lankahsu520: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@github.com/lankahsu520/HelperX.git
$ cd HelperX
$ git pull
```

#### D. Replace the Token at the Local Folder

> 當 Token過期，請建立新的Token 如 ghp_e8DfhkewlDgfjwefohmfGofklj23sfljohfF

```bash
$ cd HelperX
$ git remote set-url origin https://lankahsu520:ghp_e8DfhkewlDgfjwefohmfGofklj23sfljohfF@github.com/lankahsu520/HelperX.git
```

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

