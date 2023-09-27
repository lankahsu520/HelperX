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
### 1.1.1. Generating a new SSH key on ubuntu

```bash
$ cd ~/.ssh
$ mkdir lankahsu520
$ ssh-keygen -t rsa -b 4096 -C "lankahsu@gmail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/lanka/.ssh/id_rsa): /home/lanka/.ssh/lankahsu520/id_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/lanka/.ssh/lankahsu520/id_rsa
Your public key has been saved in /home/lanka/.ssh/lankahsu520/id_rsa.pub


$ ll /home/lanka/.ssh/lankahsu520/*
-rw------- 1 lanka lanka 3381  九  27 10:02 /home/lanka/.ssh/lankahsu520/id_rsa
-rw-r--r-- 1 lanka lanka  744  九  27 10:02 /home/lanka/.ssh/lankahsu520/id_rsa.pub

```

> Edit config of .ssh on ubuntu

```bash
$ vi ~/.ssh/config

Host lankahsu520
	Hostname github.com
	IdentityFile ~/.ssh/lankahsu520/id_rsa

$ cat /home/lanka/.ssh/lankahsu520/id_rsa.pub
ssh-rsa lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520lankahsu520== lankahsu@gmail.com

```

### 1.1.2. New SSH key

```mermaid
flowchart LR
	Settings[Settings]
	SSH[SSH and GPG keys]
	New[New SSH Key]
	Tokens["Tokens (classic)"]
	Generate["Generate new token (classic)"]
	Settings-->SSH-->New-->Tokens-->Generate

```

![GitHub_ssh01](./images/GitHub_ssh01.png)

> a new SSH key

![GitHub_ssh02](./images/GitHub_ssh02.png)

### 1.1.3. Use the new SSH key

#### A. Select a repository and get the url

> https://github.com/lankahsu520/HelperX.git

#### B. Use the new Host - lankahsu520

> ssh://git:{Host}/{ORIGINAL-URL}
>
> ssh://git@lankahsu520/lankahsu520/HelperX.git

#### C. Git clone the repository 

```bash
$ git clone ssh://git@lankahsu520/lankahsu520/HelperX.git
$ cd HelperX
$ git pull
```

#### D. Replace the Token at the Local Folder

> 當 Token過期，請建立新的Token 如 ghp_e8DfhkewlDgfjwefohmfGofklj23sfljohfF

```bash
$ cd HelperX
$ git remote set-url origin https://lankahsu520:ghp_e8DfhkewlDgfjwefohmfGofklj23sfljohfF@github.com/lankahsu520/HelperX.git
```

# 

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
>
>Expiration: 設定期限
>
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

