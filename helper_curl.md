# [cURL](https://curl.se)
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

> curl is used in command lines or scripts to transfer data. curl is also **libcurl**, used in cars, television sets, routers, printers, audio equipment, mobile phones, tablets, medical devices, settop boxes, computer games, media players and is the Internet transfer engine for countless software applications in over *twenty billion installations*.
>
> curl is used daily by virtually every Internet-using human on the globe.

## 1.1. Install astyle

```bash
$ sudo apt-get update
$ sudo apt-get --yes curl
$ curl --version
curl 7.68.0 (x86_64-pc-linux-gnu) libcurl/7.68.0 OpenSSL/1.1.1f zlib/1.2.11 brotli/1.0.7 libidn2/2.2.0 libpsl/0.21.0 (+libidn2/2.2.0) libssh/0.9.3/openssl/zlib nghttp2/1.40.0 librtmp/2.3
Release-Date: 2020-01-08
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: AsynchDNS brotli GSS-API HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP UnixSockets

```

# 2. Simple

```bash
$ curl https://www.google.com.tw -o www.google.com.tw.html
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 21353    0 21353    0     0   239k      0 --:--:-- --:--:-- --:--:--  239k
$ cat www.google.com.tw.html


```

# 3. General Commands

#### -A, --user-agent <name> Send User-Agent <name> to server

> 指定 User Agent

```bash
$ curl --user-agent "LibVLC/3.0.4 (LIVE555 Streaming Media v2016.11.28)" https://lankahsu520.com
```

#### -b, --cookie <data|filename> Send cookies from string/file

> 代入 cookie

```bash
$ curl --cookie "email=lankahsu@gmail.com" https://lankahsu520.com
```

#### -C, --continue-at <offset> Resumed transfer offset

> 用於續傳檔案，但伺服器端也要提供此功能

```bash
$ curl -C - -O http://releases.ubuntu.com/focal/ubuntu-20.04.6-desktop-amd64.iso
```

#### -d, --data <data>   HTTP POST data

```bash
$ curl -X POST -d @getAll.json @https://lankahsu520.com/request -o response.json
```

#### -L, --location      Follow redirects

> 允許該網址進行跳轉的動作

```bash
$ curl -L http://google.com

$ curl http://google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
```

#### -o, --output <file> Write to file instead of stdout

> 指定儲存的檔案名稱

#### -O, --remote-name   Write output to a file named as the remote file

> 使用 server 端的名稱為儲存的檔案名稱

```bash
$ curl https://www.google.com.tw -o www.google.com.tw.html

# 使用 ubuntu-20.04.6-desktop-amd64.iso 為儲存的檔案名稱
$ curl -C - -O http://releases.ubuntu.com/focal/ubuntu-20.04.6-desktop-amd64.iso
```

#### --trace-ascii <file> Like --trace, but without hex output

```bash
curl --trace-ascii log.txt https://www.google.com.tw
```

#### -u, --user <user:password> Server user and password

```bash
$ curl --user lankahsu520:lankahsu520 http://www.example.com/api/resources
```

#### -v, --verbose       Make the operation more talkative

> 顯示更多訊息，方便 Debug

```bash
$ curl -v https://www.google.com.tw -o www.google.com.tw.html
```

#### -w, --write-out <format> Use output FORMAT after completion

| ID                      | NAME           |
| ----------------------- | -------------- |
| CURLINFO_RESPONSE_CODE  | http_code      |
| CURLINFO_TOTAL_TIME     | time_total     |
| CURLINFO_REDIRECT_COUNT | num_redirects  |
| CURLINFO_REDIRECT_URL   | redirect_url   |
| CURLINFO_SPEED_DOWNLOAD | speed_download |
| CURLINFO_SPEED_UPLOAD   | speed_upload   |
| CURLINFO_CONTENT_TYPE   | content_type   |
| CURLINFO_SIZE_DOWNLOAD  | size_download  |
| CURLINFO_SIZE_UPLOAD    | size_upload    |
| CURLINFO_PRIMARY_IP     | remote_ip      |
| CURLINFO_PRIMARY_PORT   | remote_port    |

```bash
$ curl -X PUT https://www.google.com.tw -o www.google.com.tw.html -w "(CURLINFO_RESPONSE_CODE: %{http_code}, CURLINFO_TOTAL_TIME: %{time_total}, CURLINFO_REDIRECT_COUNT: %{num_redirects}, CURLINFO_REDIRECT_URL: %{redirect_url})\n"

(CURLINFO_RESPONSE_CODE: 405, CURLINFO_TOTAL_TIME: 0.122825, CURLINFO_REDIRECT_COUNT: 0, CURLINFO_REDIRECT_URL: )

```

#### -X, --request <command> Specify request command to use

> 支援何種 request，取決於 server 端

```bash
$ curl -X GET https://www.google.com.tw -o www.google.com.tw.html
$ curl -X POST
$ curl -X PUT
$ curl -X DELETE
$ curl -X PATCH
$ curl -X OPTIONS
$ curl -X HEAD
```

# 4. HTTP Request

## 4.1. Query String

```bash
$ curl https://lankahsu520.com/login?email=lankahsu@gmail.com
```

## 4.2. Form

```bash
$ curl -X POST --data "email=lankahsu@gmail.com" https://lankahsu520.com/login
```

## 4.3. Upload File

```bash
$ curl -X POST -F 'file=@./README.md' https://lankahsu520.com/upload
```

## 4.4. [RESTful API](https://zh.wikipedia.org/zh-tw/表现层状态转换)

> REST 本身就是基於 HTTP 上的應用；只要知道基本精神就行，因為怎麼使用還要取決於 server 端。

```bash
# 獲取全學資料
$ curl -X GET "https://example.com/resources"
# 獲取一年1班的資料
$ curl -X GET "https://example.com/resources/class1-1"
# 獲取三年2班的資料
$ curl -X GET "htt ps://example.com/resources/class3-2"
# 獲取三年2班，1號資料
$ curl -X GET "https://example.com/resources/class3-2/1"
```

```bash
# 建立三年2班，1號的名稱
$ curl -X POST -H "Content-Type: application/json" -d '{"name":"Jack"}' "https://example.com/resources/class3-2/1"

# 取代三年2班，1號的名稱
$ curl -X POST -H "Content-Type: application/json" -d '{"name":"Tom"}' "https://example.com/resources/class3-2/1"

# 刪除三年2班，1號的資料
$ curl -X DELETE "https://example.com/resources/class3-2/1"
```

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. [curl](https://manpages.ubuntu.com/manpages/trusty/man1/curl.1.html) Usage

```bash
$ curl --help
Usage: curl [options...] <url>
     --abstract-unix-socket <path> Connect via abstract Unix domain socket
     --alt-svc <file name> Enable alt-svc with this cache file
     --anyauth       Pick any authentication method
 -a, --append        Append to target file when uploading
     --basic         Use HTTP Basic Authentication
     --cacert <file> CA certificate to verify peer against
     --capath <dir>  CA directory to verify peer against
 -E, --cert <certificate[:password]> Client certificate file and password
     --cert-status   Verify the status of the server certificate
     --cert-type <type> Certificate file type (DER/PEM/ENG)
     --ciphers <list of ciphers> SSL ciphers to use
     --compressed    Request compressed response
     --compressed-ssh Enable SSH compression
 -K, --config <file> Read config from a file
     --connect-timeout <seconds> Maximum time allowed for connection
     --connect-to <HOST1:PORT1:HOST2:PORT2> Connect to host
 -C, --continue-at <offset> Resumed transfer offset
 -b, --cookie <data|filename> Send cookies from string/file
 -c, --cookie-jar <filename> Write cookies to <filename> after operation
     --create-dirs   Create necessary local directory hierarchy
     --crlf          Convert LF to CRLF in upload
     --crlfile <file> Get a CRL list in PEM format from the given file
 -d, --data <data>   HTTP POST data
     --data-ascii <data> HTTP POST ASCII data
     --data-binary <data> HTTP POST binary data
     --data-raw <data> HTTP POST data, '@' allowed
     --data-urlencode <data> HTTP POST data url encoded
     --delegation <LEVEL> GSS-API delegation permission
     --digest        Use HTTP Digest Authentication
 -q, --disable       Disable .curlrc
     --disable-eprt  Inhibit using EPRT or LPRT
     --disable-epsv  Inhibit using EPSV
     --disallow-username-in-url Disallow username in url
     --dns-interface <interface> Interface to use for DNS requests
     --dns-ipv4-addr <address> IPv4 address to use for DNS requests
     --dns-ipv6-addr <address> IPv6 address to use for DNS requests
     --dns-servers <addresses> DNS server addrs to use
     --doh-url <URL> Resolve host names over DOH
 -D, --dump-header <filename> Write the received headers to <filename>
     --egd-file <file> EGD socket path for random data
     --engine <name> Crypto engine to use
     --etag-save <file> Get an ETag from response header and save it to a FILE
     --etag-compare <file> Get an ETag from a file and send a conditional request
     --expect100-timeout <seconds> How long to wait for 100-continue
 -f, --fail          Fail silently (no output at all) on HTTP errors
     --fail-early    Fail on first transfer error, do not continue
     --false-start   Enable TLS False Start
 -F, --form <name=content> Specify multipart MIME data
     --form-string <name=string> Specify multipart MIME data
     --ftp-account <data> Account data string
     --ftp-alternative-to-user <command> String to replace USER [name]
     --ftp-create-dirs Create the remote dirs if not present
     --ftp-method <method> Control CWD usage
     --ftp-pasv      Use PASV/EPSV instead of PORT
 -P, --ftp-port <address> Use PORT instead of PASV
     --ftp-pret      Send PRET before PASV
     --ftp-skip-pasv-ip Skip the IP address for PASV
     --ftp-ssl-ccc   Send CCC after authenticating
     --ftp-ssl-ccc-mode <active/passive> Set CCC mode
     --ftp-ssl-control Require SSL/TLS for FTP login, clear for transfer
 -G, --get           Put the post data in the URL and use GET
 -g, --globoff       Disable URL sequences and ranges using {} and []
     --happy-eyeballs-timeout-ms <milliseconds> How long to wait in milliseconds for IPv6 before trying IPv4
     --haproxy-protocol Send HAProxy PROXY protocol v1 header
 -I, --head          Show document info only
 -H, --header <header/@file> Pass custom header(s) to server
 -h, --help          This help text
     --hostpubmd5 <md5> Acceptable MD5 hash of the host public key
     --http0.9       Allow HTTP 0.9 responses
 -0, --http1.0       Use HTTP 1.0
     --http1.1       Use HTTP 1.1
     --http2         Use HTTP 2
     --http2-prior-knowledge Use HTTP 2 without HTTP/1.1 Upgrade
     --http3         Use HTTP v3
     --ignore-content-length Ignore the size of the remote resource
 -i, --include       Include protocol response headers in the output
 -k, --insecure      Allow insecure server connections when using SSL
     --interface <name> Use network INTERFACE (or address)
 -4, --ipv4          Resolve names to IPv4 addresses
 -6, --ipv6          Resolve names to IPv6 addresses
 -j, --junk-session-cookies Ignore session cookies read from file
     --keepalive-time <seconds> Interval time for keepalive probes
     --key <key>     Private key file name
     --key-type <type> Private key file type (DER/PEM/ENG)
     --krb <level>   Enable Kerberos with security <level>
     --libcurl <file> Dump libcurl equivalent code of this command line
     --limit-rate <speed> Limit transfer speed to RATE
 -l, --list-only     List only mode
     --local-port <num/range> Force use of RANGE for local port numbers
 -L, --location      Follow redirects
     --location-trusted Like --location, and send auth to other hosts
     --login-options <options> Server login options
     --mail-auth <address> Originator address of the original email
     --mail-from <address> Mail from this address
     --mail-rcpt <address> Mail to this address
 -M, --manual        Display the full manual
     --max-filesize <bytes> Maximum file size to download
     --max-redirs <num> Maximum number of redirects allowed
 -m, --max-time <seconds> Maximum time allowed for the transfer
     --metalink      Process given URLs as metalink XML file
     --negotiate     Use HTTP Negotiate (SPNEGO) authentication
 -n, --netrc         Must read .netrc for user name and password
     --netrc-file <filename> Specify FILE for netrc
     --netrc-optional Use either .netrc or URL
 -:, --next          Make next URL use its separate set of options
     --no-alpn       Disable the ALPN TLS extension
 -N, --no-buffer     Disable buffering of the output stream
     --no-keepalive  Disable TCP keepalive on the connection
     --no-npn        Disable the NPN TLS extension
     --no-progress-meter Do not show the progress meter
     --no-sessionid  Disable SSL session-ID reusing
     --noproxy <no-proxy-list> List of hosts which do not use proxy
     --ntlm          Use HTTP NTLM authentication
     --ntlm-wb       Use HTTP NTLM authentication with winbind
     --oauth2-bearer <token> OAuth 2 Bearer Token
 -o, --output <file> Write to file instead of stdout
 -Z, --parallel      Perform transfers in parallel
     --parallel-immediate Do not wait for multiplexing (with --parallel)
     --parallel-max  Maximum concurrency for parallel transfers
     --pass <phrase> Pass phrase for the private key
     --path-as-is    Do not squash .. sequences in URL path
     --pinnedpubkey <hashes> FILE/HASHES Public key to verify peer against
     --post301       Do not switch to GET after following a 301
     --post302       Do not switch to GET after following a 302
     --post303       Do not switch to GET after following a 303
     --preproxy [protocol://]host[:port] Use this proxy first
 -#, --progress-bar  Display transfer progress as a bar
     --proto <protocols> Enable/disable PROTOCOLS
     --proto-default <protocol> Use PROTOCOL for any URL missing a scheme
     --proto-redir <protocols> Enable/disable PROTOCOLS on redirect
 -x, --proxy [protocol://]host[:port] Use this proxy
     --proxy-anyauth Pick any proxy authentication method
     --proxy-basic   Use Basic authentication on the proxy
     --proxy-cacert <file> CA certificate to verify peer against for proxy
     --proxy-capath <dir> CA directory to verify peer against for proxy
     --proxy-cert <cert[:passwd]> Set client certificate for proxy
     --proxy-cert-type <type> Client certificate type for HTTPS proxy
     --proxy-ciphers <list> SSL ciphers to use for proxy
     --proxy-crlfile <file> Set a CRL list for proxy
     --proxy-digest  Use Digest authentication on the proxy
     --proxy-header <header/@file> Pass custom header(s) to proxy
     --proxy-insecure Do HTTPS proxy connections without verifying the proxy
     --proxy-key <key> Private key for HTTPS proxy
     --proxy-key-type <type> Private key file type for proxy
     --proxy-negotiate Use HTTP Negotiate (SPNEGO) authentication on the proxy
     --proxy-ntlm    Use NTLM authentication on the proxy
     --proxy-pass <phrase> Pass phrase for the private key for HTTPS proxy
     --proxy-pinnedpubkey <hashes> FILE/HASHES public key to verify proxy with
     --proxy-service-name <name> SPNEGO proxy service name
     --proxy-ssl-allow-beast Allow security flaw for interop for HTTPS proxy
     --proxy-tls13-ciphers <list> TLS 1.3 ciphersuites for proxy (OpenSSL)
     --proxy-tlsauthtype <type> TLS authentication type for HTTPS proxy
     --proxy-tlspassword <string> TLS password for HTTPS proxy
     --proxy-tlsuser <name> TLS username for HTTPS proxy
     --proxy-tlsv1   Use TLSv1 for HTTPS proxy
 -U, --proxy-user <user:password> Proxy user and password
     --proxy1.0 <host[:port]> Use HTTP/1.0 proxy on given port
 -p, --proxytunnel   Operate through an HTTP proxy tunnel (using CONNECT)
     --pubkey <key>  SSH Public key file name
 -Q, --quote         Send command(s) to server before transfer
     --random-file <file> File for reading random data from
 -r, --range <range> Retrieve only the bytes within RANGE
     --raw           Do HTTP "raw"; no transfer decoding
 -e, --referer <URL> Referrer URL
 -J, --remote-header-name Use the header-provided filename
 -O, --remote-name   Write output to a file named as the remote file
     --remote-name-all Use the remote file name for all URLs
 -R, --remote-time   Set the remote file's time on the local output
 -X, --request <command> Specify request command to use
     --request-target Specify the target for this request
     --resolve <host:port:address[,address]...> Resolve the host+port to this address
     --retry <num>   Retry request if transient problems occur
     --retry-connrefused Retry on connection refused (use with --retry)
     --retry-delay <seconds> Wait time between retries
     --retry-max-time <seconds> Retry only within this period
     --sasl-authzid <identity>  Use this identity to act as during SASL PLAIN authentication
     --sasl-ir       Enable initial response in SASL authentication
     --service-name <name> SPNEGO service name
 -S, --show-error    Show error even when -s is used
 -s, --silent        Silent mode
     --socks4 <host[:port]> SOCKS4 proxy on given host + port
     --socks4a <host[:port]> SOCKS4a proxy on given host + port
     --socks5 <host[:port]> SOCKS5 proxy on given host + port
     --socks5-basic  Enable username/password auth for SOCKS5 proxies
     --socks5-gssapi Enable GSS-API auth for SOCKS5 proxies
     --socks5-gssapi-nec Compatibility with NEC SOCKS5 server
     --socks5-gssapi-service <name> SOCKS5 proxy service name for GSS-API
     --socks5-hostname <host[:port]> SOCKS5 proxy, pass host name to proxy
 -Y, --speed-limit <speed> Stop transfers slower than this
 -y, --speed-time <seconds> Trigger 'speed-limit' abort after this time
     --ssl           Try SSL/TLS
     --ssl-allow-beast Allow security flaw to improve interop
     --ssl-no-revoke Disable cert revocation checks (Schannel)
     --ssl-reqd      Require SSL/TLS
 -2, --sslv2         Use SSLv2
 -3, --sslv3         Use SSLv3
     --stderr        Where to redirect stderr
     --styled-output Enable styled output for HTTP headers
     --suppress-connect-headers Suppress proxy CONNECT response headers
     --tcp-fastopen  Use TCP Fast Open
     --tcp-nodelay   Use the TCP_NODELAY option
 -t, --telnet-option <opt=val> Set telnet option
     --tftp-blksize <value> Set TFTP BLKSIZE option
     --tftp-no-options Do not send any TFTP options
 -z, --time-cond <time> Transfer based on a time condition
     --tls-max <VERSION> Set maximum allowed TLS version
     --tls13-ciphers <list> TLS 1.3 ciphersuites (OpenSSL)
     --tlsauthtype <type> TLS authentication type
     --tlspassword   TLS password
     --tlsuser <name> TLS user name
 -1, --tlsv1         Use TLSv1.0 or greater
     --tlsv1.0       Use TLSv1.0 or greater
     --tlsv1.1       Use TLSv1.1 or greater
     --tlsv1.2       Use TLSv1.2 or greater
     --tlsv1.3       Use TLSv1.3 or greater
     --tr-encoding   Request compressed transfer encoding
     --trace <file>  Write a debug trace to FILE
     --trace-ascii <file> Like --trace, but without hex output
     --trace-time    Add time stamps to trace/verbose output
     --unix-socket <path> Connect through this Unix domain socket
 -T, --upload-file <file> Transfer local FILE to destination
     --url <url>     URL to work with
 -B, --use-ascii     Use ASCII/text transfer
 -u, --user <user:password> Server user and password
 -A, --user-agent <name> Send User-Agent <name> to server
 -v, --verbose       Make the operation more talkative
 -V, --version       Show version number and quit
 -w, --write-out <format> Use output FORMAT after completion
     --xattr         Store metadata in extended file attributes
```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

