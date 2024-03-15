# OpenSSL

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

# 1. [OpenSSL](https://github.com/openssl/openssl)

> OpenSSL is a robust, commercial-grade, full-featured Open Source Toolkit for the TLS (formerly SSL), DTLS and QUIC (currently client side only) protocols.

# 2. Create certificates

## 2.1. [Self-signed certificate](https://en.wikipedia.org/wiki/Self-signed_certificate)

> 自簽署（Self-signed）的 SSL 憑證，未經過第三方機構的核可，提供“加密”連線的效果。

### 2.1.1. Generate a keypair using OpenSSL

#### A. Create step by step

```bash
# ca
$ openssl genrsa  -out /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca.key 2048
$ openssl req -new -x509 -days 3650 -key /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca.key -out /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca -config /work/IoT/mqtt/certSelf-signed/certDefines/mqtt/ca.conf

# server
$ openssl genrsa -out /work/IoT/mqtt/certSelf-signed/install/srv/mqtt_srv.key 2048
$ openssl req -new -out /work/IoT/mqtt/certSelf-signed/install/srv/mqtt_srv.csr -key /work/IoT/mqtt/certSelf-signed/install/srv/mqtt_srv.key -config /work/IoT/mqtt/certSelf-signed/certDefines/mqtt/server.conf
$ openssl x509 -req -in /work/IoT/mqtt/certSelf-signed/install/srv/mqtt_srv.csr -CA /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca -CAkey /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca.key -CAcreateserial -out /work/IoT/mqtt/certSelf-signed/install/srv/mqtt_srv.crt -days 3650 -extfile /work/IoT/mqtt/certSelf-signed/certDefines/mqtt/alt.ext

# client
$ openssl genrsa -out /work/IoT/mqtt/certSelf-signed/install/client/mqtt_beex.key 2048
$ openssl req -new -out /work/IoT/mqtt/certSelf-signed/install/client/mqtt_beex.csr -key /work/IoT/mqtt/certSelf-signed/install/client/mqtt_beex.key -config /work/IoT/mqtt/certSelf-signed/certDefines/mqtt/client.conf
$ openssl x509 -req -in /work/IoT/mqtt/certSelf-signed/install/client/mqtt_beex.csr -CA /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca -CAkey /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.ca.key -CAserial /work/IoT/mqtt/certSelf-signed/install/ca/mqtt.srl -out /work/IoT/mqtt/certSelf-signed/install/client/mqtt_beex.crt -days 3650 -extfile /work/IoT/mqtt/certSelf-signed/certDefines/mqtt/alt.ext
```

#### B. Create using shell scripts - [certSelf-signed](https://github.com/lankahsu520/HelperX/blob/master/OpenSSL/certSelf-signed)

```bash
$ cd certSelf-signed
$ . confs/mqtt.sh
$ ./sh/gencert_123.sh ssl
==> call gencert_ca.sh ...
20240315112212 gencert_123.sh|ssl_fn:56- [/work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/sh/gencert_ca.sh ssl]
20240315112212 gencert_ca.sh|ssl_fn:54- [rm -rf /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca]
20240315112212 gencert_ca.sh|ssl_fn:55- [mkdir -p /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca]
20240315112212 gencert_ca.sh|ssl_fn:58- [openssl genrsa  -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca.key 2048]
Generating RSA private key, 2048 bit long modulus (2 primes)
.............+++++
...............................................................................................................................................................................................+++++
e is 65537 (0x010001)
20240315112212 gencert_ca.sh|ssl_fn:61- [openssl req -new -x509 -days 3650 -key /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca.key -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca -config /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/certDefines/mqtt/ca.conf]

==> call gencert_srv.sh ...
20240315112212 gencert_123.sh|ssl_fn:59- [/work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/sh/gencert_srv.sh ssl]
20240315112212 gencert_srv.sh|ssl_fn:53- [rm -rf /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv]
20240315112212 gencert_srv.sh|ssl_fn:54- [mkdir -p /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv]
20240315112212 gencert_srv.sh|ssl_fn:57- [openssl genrsa -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv/mqtt_srv.key 2048]
Generating RSA private key, 2048 bit long modulus (2 primes)
................+++++
.........................+++++
e is 65537 (0x010001)
20240315112212 gencert_srv.sh|ssl_fn:60- [openssl req -new -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv/mqtt_srv.csr -key /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv/mqtt_srv.key -config /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/certDefines/mqtt/server.conf]
20240315112212 gencert_srv.sh|ssl_fn:63- [openssl x509 -req -in /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv/mqtt_srv.csr -CA /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca -CAkey /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca.key -CAcreateserial -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/srv/mqtt_srv.crt -days 3650 -extfile /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/certDefines/mqtt/alt.ext]
Signature ok
subject=C = TW, ST = Taiwan, L = Taipei, O = lankahsu520, CN = SERVER, emailAddress = lankahsu@gmail.com
Getting CA Private Key

==> call gencert_client.sh ...
20240315112212 gencert_123.sh|ssl_fn:62- [/work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/sh/gencert_client.sh ssl]
20240315112212 gencert_client.sh|ssl_fn:53- [rm -rf /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client]
20240315112212 gencert_client.sh|ssl_fn:54- [mkdir -p /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client]
20240315112212 gencert_client.sh|ssl_fn:57- [openssl genrsa -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client/mqtt_beex.key 2048]
Generating RSA private key, 2048 bit long modulus (2 primes)
........................................................+++++
...+++++
e is 65537 (0x010001)
20240315112212 gencert_client.sh|ssl_fn:60- [openssl req -new -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client/mqtt_beex.csr -key /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client/mqtt_beex.key -config /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/certDefines/mqtt/client.conf]
20240315112212 gencert_client.sh|ssl_fn:63- [openssl x509 -req -in /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client/mqtt_beex.csr -CA /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca -CAkey /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.ca.key -CAserial /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/ca/mqtt.srl -out /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/install/client/mqtt_beex.crt -days 3650 -extfile /work/codebase/lankahsu520/HelperX/OpenSSL/certSelf-signed/certDefines/mqtt/alt.ext]
Signature ok
subject=C = TW, ST = Taiwan, L = Taipei, O = lankahsu520, CN = CLIENT, emailAddress = lankahsu@gmail.com
Getting CA Private Key
```

### 2.1.2. Check certificate

#### A. Check the modulus of an SSL certificate and key with openssl

```bash
$ cd certSelf-signed/install
$ openssl x509 -noout -modulus -in ./client/mqtt_beex.crt | openssl md5
$ openssl rsa  -noout -modulus -in ./client/mqtt_beex.key | openssl md5
$ openssl req  -noout -modulus -in ./client/mqtt_beex.csr | openssl md5

$ openssl x509 -noout -modulus -in ./srv/mqtt_srv.crt | openssl md5
$ openssl rsa  -noout -modulus -in ./srv/mqtt_srv.key | openssl md5
$ openssl req  -noout -modulus -in ./srv/mqtt_srv.csr | openssl md5

# check match
$ openssl verify -CAfile ./ca/mqtt.ca ./srv/mqtt_srv.crt ./client/mqtt_beex.crt
./srv/mqtt_srv.crt: OK
./client/mqtt_beex.crt: OK
```


# 3. Establishing a Secure Connection

> HOSTNAME=192.168.0.9
> PORT=1883

```bash
$ HOSTNAME=192.168.0.9
$ PORT=1883
$ openssl s_client -connect $HOSTNAME:$PORT \
  -showcerts
```

```bash
$ openssl s_client -connect $HOSTNAME:$PORT \
  -CAfile /work/IoT/mqtt/common/mqtt.ca \
  -cert /work/IoT/mqtt/common/mqtt_beex.crt \
  -key /work/IoT/mqtt/common/mqtt_beex.key \
  -showcerts \
  -tls1_2
```

# Appendix

# I. Study

## I.1. [密碼學/Generate a keypair using OpenSSL](https://zh.wikibooks.org/zh-tw/密码学/Generate_a_keypair_using_OpenSSL)

## I.2. [建立/購買 SSL 憑證](https://docs.gandi.net/zh-hant/ssl/create/index.html)

## I.3. [如何使用 OpenSSL 簽發中介 CA](https://blog.davy.tw/posts/use-openssl-to-sign-intermediate-ca/)

# II. Debug

## II.1. error 18 at 0 depth lookup: self signed certificate

>當 OpenSSL 從 1.1.1g 升級至 1.1.1h 時，ca 和 client、server 的 commonName 必須要有差異。

```bash
$ cd certSelf-signed/install
$ openssl verify -CAfile ./ca/mqtt.ca ./srv/mqtt_srv.crt ./client/mqtt_beex.crt
error 18 at 0 depth lookup: self signed certificate
error mqtt_srv.crt: verification failed

error 18 at 0 depth lookup: self signed certificate
error mqtt_beex.crt: verification failed
```

#### A. [The certificate was misidentified as a self-signed certificate #19095](https://github.com/openssl/openssl/issues/19095)

#### B. [Broken certificate verification since 3.1.1 / openssl 1.1.1h #5540](https://github.com/pyca/cryptography/issues/5540)

> OpenSSL Error[0]: error:1416F086:SSL routines:tls_process_server_certificate:certificate verify failed

# III. Glossary

# IV. Tool Usage

## IV.1. [openssl](https://manpages.ubuntu.com/manpages/focal/en/man1/openssl.1ssl.html) Usage

```bash
$ openssl help
Standard commands
asn1parse         ca                ciphers           cms
crl               crl2pkcs7         dgst              dhparam
dsa               dsaparam          ec                ecparam
enc               engine            errstr            gendsa
genpkey           genrsa            help              list
nseq              ocsp              passwd            pkcs12
pkcs7             pkcs8             pkey              pkeyparam
pkeyutl           prime             rand              rehash
req               rsa               rsautl            s_client
s_server          s_time            sess_id           smime
speed             spkac             srp               storeutl
ts                verify            version           x509

Message Digest commands (see the `dgst' command for more details)
blake2b512        blake2s256        gost              md4
md5               rmd160            sha1              sha224
sha256            sha3-224          sha3-256          sha3-384
sha3-512          sha384            sha512            sha512-224
sha512-256        shake128          shake256          sm3

Cipher commands (see the `enc' command for more details)
aes-128-cbc       aes-128-ecb       aes-192-cbc       aes-192-ecb
aes-256-cbc       aes-256-ecb       aria-128-cbc      aria-128-cfb
aria-128-cfb1     aria-128-cfb8     aria-128-ctr      aria-128-ecb
aria-128-ofb      aria-192-cbc      aria-192-cfb      aria-192-cfb1
aria-192-cfb8     aria-192-ctr      aria-192-ecb      aria-192-ofb
aria-256-cbc      aria-256-cfb      aria-256-cfb1     aria-256-cfb8
aria-256-ctr      aria-256-ecb      aria-256-ofb      base64
bf                bf-cbc            bf-cfb            bf-ecb
bf-ofb            camellia-128-cbc  camellia-128-ecb  camellia-192-cbc
camellia-192-ecb  camellia-256-cbc  camellia-256-ecb  cast
cast-cbc          cast5-cbc         cast5-cfb         cast5-ecb
cast5-ofb         des               des-cbc           des-cfb
des-ecb           des-ede           des-ede-cbc       des-ede-cfb
des-ede-ofb       des-ede3          des-ede3-cbc      des-ede3-cfb
des-ede3-ofb      des-ofb           des3              desx
rc2               rc2-40-cbc        rc2-64-cbc        rc2-cbc
rc2-cfb           rc2-ecb           rc2-ofb           rc4
rc4-40            seed              seed-cbc          seed-cfb
seed-ecb          seed-ofb          sm4-cbc           sm4-cfb
sm4-ctr           sm4-ecb           sm4-ofb
```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

