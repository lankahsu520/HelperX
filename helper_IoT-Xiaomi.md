# IoT Xiaomi

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

> 為什麼會選擇 Xiaomi 建構[智慧居家](https://www.mi.com/tw/product-list/smart-device/?cat_id=2546)，因為價格親民、取得容易、安裝方便（不需電工的知識），另外還有現成的 API 可使用。
>
> 如果個人有使用大陸產品的疑慮，建議可以省略此篇文章。

## 1.1. [Xiaomi Miot Spec: 小米/米家产品库](https://home.miot-spec.com)

## 1.2. [小米 IoT 开发者平台](https://iot.mi.com/)

### 1.2.1. [平台介绍](https://iot.mi.com/v2/new/doc/home)

# 2. Topology

>目前自行建置的設備如下，畢竟錢力有限、時間有限。也因為這樣的情況下，才能當興趣來做。

```mermaid
flowchart LR
	Xiaomi[Xiaomi cloud]

	subgraph myoffice["Office"]
		C400[C400,chuangmi.camera]
	end
	Xiaomi<-->C400

	subgraph myhomea["Home A"]
		gateway[gateway,lumi.gateway.mgl001]
			sensor_motion[sensor_motion,lumi.sensor_motion.v2]
			sensor_switch[sensor_switch,lumi.sensor_switch.v2]
			t700i[T700,k0918.toothbrush.t700i]
			sensor_ht[sensor_ht,miaomiaoce.sensor_ht.t2]
		gateway<-->|zigbee|sensor_motion
		gateway<-->|zigbee|sensor_switch
		gateway<-->|bluetooth|t700i
		gateway<-->|bluetooth|sensor_ht
		
		plug2a1c1[plug,qmi.plug.2a1c1]
		plug[plug,qmi.plug.tw02]
		
	end
	Xiaomi<-->gateway
	Xiaomi<-->plug2a1c1
	Xiaomi<-->plug

	subgraph myhomeb["Home B"]
		C500Pro[C500 Pro,chuangmi.camera with BT gateway]
			light[light,yeelink.light.nl1]
		C500Pro<-->|bluetooth|light
	end

	Xiaomi<-->C500Pro

```


# 3. miiocli

> This library (and its accompanying cli tool, `miiocli`) can be used to control devices using Xiaomi's [miIO](https://github.com/OpenMiHome/mihome-binary-protocol/blob/master/doc/PROTOCOL.md) and MIoT protocols.

> GitHub - [python-miio](https://github.com/rytilahti/python-miio)
>
> PyPI - [python-miio](https://pypi.org/project/python-miio/)

```bash
$ pip install --upgrade python-miio

# genericmiot
$ pip install git+https://github.com/rytilahti/python-miio.git
```

## 3.0. cloud

>因為之後的操作都與 device ID and TOKEN 有關，所以需要先連上 Xiaomi cloud 後鍵入使用者帳號和密碼，查詢相關 devices 訊息。
>
>另外這些資料比較私密，請一定要好好保管。

### 3.0.1. Token

#### A. miiocli cloud

```bash
function xiaomi-cloud()
{
	ARGS="$*"

	DO_COMMAND="(miiocli cloud ${ARGS})"
	eval-it "$DO_COMMAND"
}
```

```bash
$ xiaomi-cloud
[(miiocli cloud )]
Username: 
Password: 
...
```

#### B. Xiaomi-cloud-tokens-extractor

> 這邊另外提供一個方式去抓取 token。

> This tool/script retrieves tokens for all devices connected to Xiaomi cloud and encryption keys for BLE devices.

```bash
$ git clone https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor

$ cd Xiaomi-cloud-tokens-extractor
$ python3 token_extractor.py
Username (email or user ID):
Password:

Server (one of: cn, de, us, ru, tw, sg, in, i2) Leave empty to check all available:
tw

Logging in...
Logged in.

Devices found for server "tw" @ home "12345678901":
...
```

### 3.0.1. IP and Token

```bash
function xiaomi-device-ip()
{
	IP1="$1"
	UNSET2="$2"
	[ "$IP1" != "" ] && export XIAOMI_IP=$IP1

	if [ -z "${UNSET2}" ]; then
		echo "XIAOMI_IP=${XIAOMI_IP}"
	elif [ "${UNSET2}" == "unset" ]; then
		unset XIAOMI_IP
	fi
}

function xiaomi-device-token()
{
	TOKEN1="$1"
	UNSET2="$2"
	[ "$TOKEN1" != "" ] && export XIAOMI_TOKEN=$TOKEN1

	if [ -z "${UNSET2}" ]; then
		echo "XIAOMI_TOKEN=${XIAOMI_TOKEN}"
	elif [ "${UNSET2}" == "unset" ]; then
		unset XIAOMI_TOKEN
	fi
}

function xiaomi-device-id()
{
	ID1="$1"
	UNSET2="$2"
	[ "$ID1" != "" ] && export XIAOMI_ID=$ID1

	if [ -z "${UNSET2}" ]; then
		echo "XIAOMI_ID=${XIAOMI_ID}"
	elif [ "${UNSET2}" == "unset" ]; then
		unset XIAOMI_ID
	fi
}

function xiaomi-device-which()
{
	IP1="$1"
	TOKEN2="$2"
	ID3="$3"
	UNSET4="$4"

	if [ "${IP1}" == "unset" ]; then
		xiaomi-device-ip "" unset
		xiaomi-device-token "" unset
		xiaomi-device-id "" unset
		unset XIAOMI_MODEL
		unset XIAOMI_GENERICMIOT
	else
		xiaomi-device-ip "${IP1}" "${UNSET4}"
		xiaomi-device-token "${TOKEN2}" "${UNSET4}"
		xiaomi-device-id "${ID3}" "${UNSET4}"
		echo "XIAOMI_MODEL=${XIAOMI_MODEL}"
		echo "XIAOMI_GENERICMIOT=${XIAOMI_GENERICMIOT}"
	fi
}
```

```bash
$ xiaomi-device-ip 192.168.0.28
$ xiaomi-device-token 12345678901234567890123456789012
$ xiaomi-device-id 987654321

# or
$ xiaomi-device-which 192.168.0.28 12345678901234567890123456789012 987654321
```

## 3.1. discover

> Discover devices using both handshake and mdns methods.

```bash
$ miiocli discover --help
Usage: miiocli discover [OPTIONS]

  Discover devices using both handshake and mdns methods.

Options:
  --mdns / --no-mdns
  --handshake / --no-handshake
  --network TEXT
  --timeout INTEGER
  --help                        Show this message and exit.
```

```bash
function xiaomi-discover()
{
	ARGS="$*"

	DO_COMMAND="(miiocli discover ${ARGS})"
	eval-it "$DO_COMMAND"
}
```

```bash
$ xiaomi-discover
[(miiocli discover )]
INFO:miio.miioprotocol:Sending discovery to <broadcast> with timeout of 5s..
INFO:miio.miioprotocol:  IP 192.168.0.30 (ID: 52099230) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.33 (ID: 52099633) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.32 (ID: 52099832) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.23 (ID: 52099523) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.26 (ID: 52099626) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.29 (ID: 52099c29) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.28 (ID: 52099b28) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:  IP 192.168.0.31 (ID: 52099231) - token: b'ffffffffffffffffffffffffffffffff'
INFO:miio.miioprotocol:Discovery done
INFO:miio.discovery:Discovering devices with mDNS for 5 seconds..
```

## 3.2. device

```bash
$ miiocli device --help
Usage: miiocli device [OPTIONS] COMMAND [ARGS]...

Options:
  --ip TEXT     [required]
  --token TEXT  [required]
  --model TEXT
  --help        Show this message and exit.

Commands:
  info             Get (and cache) miIO protocol information from the...
  raw_command      Send a raw command to the device.
  test_properties  Helper to test device properties.
```

```bash
function xiaomi-endpoint-piid()
{
	PIID1="$1"
	UNSET2="$2"
	[ "$PIID1" != "" ] && export XIAOMI_PIID=$PIID1

	if [ -z "${UNSET2}" ]; then
		echo "XIAOMI_PIID=${XIAOMI_PIID}"
	elif [ "${UNSET2}" == "unset" ]; then
		unset XIAOMI_PIID
	fi
}

function xiaomi-endpoint-siid()
{
	SIID1="$1"
	UNSET2="$2"
	[ "$SIID1" != "" ] && export XIAOMI_SIID=$SIID1

	if [ -z "${UNSET2}" ]; then
		echo "XIAOMI_SIID=${XIAOMI_SIID}"
	elif [ "${UNSET2}" == "unset" ]; then
		unset XIAOMI_SIID
	fi
}

function xiaomi-endpoint-which()
{
	SIID1="$1"
	PIID2="$2"
	UNSET3="$3"

	if [ "${SIID1}" == "unset" ]; then
		xiaomi-endpoint-siid "" unset
		xiaomi-endpoint-piid "" unset
	else
		xiaomi-endpoint-siid "${SIID1}" "${UNSET3}"
		xiaomi-endpoint-piid "${PIID2}" "${UNSET3}"
	fi
}

function xiaomi-model2endpoint()
{
	HINT="Usage: ${FUNCNAME[0]} <model>"
	MODEL1=$1

	if [ "${MODEL1}" == "qmi.plug.tw02" ]; then
		xiaomi-endpoint-which "2" "1" ""
		#xiaomi-endpoint-which "2" "1" "hidden"
	else
		echo $HINT
	fi
}

function xiaomi-device-helper()
{
	ARGS="$*"

	DO_COMMAND="(miiocli device ${ARGS})"
	eval-it "$DO_COMMAND"
}
```

### 3.2.1. device info

```bash
function xiaomi-device-info()
{
	HINT="Usage: ${FUNCNAME[0]} [ip] [token]"

	xiaomi-device-which "$1" "$2" "" "hidden"

	if [ ! -z "${XIAOMI_IP}" ] && [ ! -z "${XIAOMI_TOKEN}" ]; then
		[ "$XIAOMI_IP" != "" ] && XIAOMI_IP_ARG="--ip $XIAOMI_IP"
		[ "$XIAOMI_TOKEN" != "" ] && XIAOMI_TOKEN_ARG="--token $XIAOMI_TOKEN"

		export XIAOMI_DEVICE_FILE=/tmp/.${FUNCNAME[0]}
		xiaomi-device-helper ${XIAOMI_IP_ARG} ${XIAOMI_TOKEN_ARG} info | tee ${XIAOMI_DEVICE_FILE}

		if [ "$?" == "0" ]; then
			echo "--------------------------------------------------"
			export XIAOMI_MODEL=`grep 'Model' ${XIAOMI_DEVICE_FILE} | cut -d" " -f2`
			export XIAOMI_GENERICMIOT=`grep 'Supported by genericmiot' ${XIAOMI_DEVICE_FILE} | cut -d" " -f4`
			xiaomi-model2endpoint ${XIAOMI_MODEL}
			echo "XIAOMI_MODEL=${XIAOMI_MODEL}"
			echo "XIAOMI_GENERICMIOT=${XIAOMI_GENERICMIOT}"
		fi
	else
		echo $HINT
	fi
}
```

```bash
$ xiaomi-device-info
[(miiocli device --ip 192.168.0.28 --token 12345678901234567890123456789012 info)]
Running command info
Model: qmi.plug.tw02
Hardware version: ESP32C3
Firmware version: 1.0.6
Supported using: GenericMiot
Command: miiocli genericmiot --ip 192.168.0.28 --token 12345678901234567890123456789012
Supported by genericmiot: True
--------------------------------------------------
XIAOMI_SIID=2
XIAOMI_PIID=1
XIAOMI_MODEL=qmi.plug.tw02
XIAOMI_GENERICMIOT=True
```

#### A. [Xiaomi Smart Plug 2](https://home.miot-spec.com/s/qmi.plug.tw02)

> siid: 2
>
> piid: 1

![Xiaomi_qmi.plug.tw02](./images/Xiaomi_qmi.plug.tw02.png)

### 3.2.2. device raw_command

#### A. get_properties

```bash
function xiaomi-device-raw-get()
{
	HINT="Usage: ${FUNCNAME[0]} [ip] [token] [id] [siid] [piid]"

	xiaomi-device-which "$1" "$2" "$3" "hidden"
	xiaomi-endpoint-which "$4" "$5" "hidden"

	if [ ! -z "${XIAOMI_IP}" ] && [ ! -z "${XIAOMI_TOKEN}" ] && [ ! -z "${XIAOMI_ID}" ] && [ ! -z "${XIAOMI_SIID}" ] && [ ! -z "${XIAOMI_PIID}" ]; then
		[ "$XIAOMI_IP" != "" ] && XIAOMI_IP_ARG="--ip $XIAOMI_IP"
		[ "$XIAOMI_TOKEN" != "" ] && XIAOMI_TOKEN_ARG="--token $XIAOMI_TOKEN"

		XIAOMI_RAW="[{'did': '${XIAOMI_ID}', 'siid': ${XIAOMI_SIID}, 'piid': ${XIAOMI_PIID} }]"
		xiaomi-device-helper \
			${XIAOMI_IP_ARG} ${XIAOMI_TOKEN_ARG} \
			raw_command get_properties \
			\"${XIAOMI_RAW}\"
	else
		echo $HINT
	fi
}
```

```bash
$ xiaomi-device-raw-get
[(miiocli device --ip 192.168.0.28 --token 12345678901234567890123456789012 raw_command get_properties "[{'did': '987654321', 'siid': 2, 'piid': 1 }]")]
Running command raw_command
[{'did': '987654321', 'siid': 2, 'piid': 1, 'code': 0, 'value': True}]
```

#### B. set_properties

```bash
function xiaomi-device-raw-set()
{
	HINT="Usage: ${FUNCNAME[0]} <value> [ip] [token] [id]"

	XIAOMI_VALUE="$1"
	xiaomi-device-which "$2" "$3" "$4" "hidden"

	if [ ! -z "${XIAOMI_VALUE}" ] && [ ! -z "${XIAOMI_IP}" ] && [ ! -z "${XIAOMI_TOKEN}" ] && [ ! -z "${XIAOMI_ID}" ]; then
		[ "$XIAOMI_IP" != "" ] && XIAOMI_IP_ARG="--ip $XIAOMI_IP"
		[ "$XIAOMI_TOKEN" != "" ] && XIAOMI_TOKEN_ARG="--token $XIAOMI_TOKEN"

		XIAOMI_RAW="[{'did': '${XIAOMI_ID}', 'siid': 2, 'piid': 1, 'value':${XIAOMI_VALUE} }]"
		xiaomi-device-helper \
			${XIAOMI_IP_ARG} ${XIAOMI_TOKEN_ARG} \
			raw_command set_properties \
			\"${XIAOMI_RAW}\"
	else
		echo $HINT
	fi
}

function xiaomi-device-raw-settrue()
{
	xiaomi-device-raw-set True
}

function xiaomi-device-raw-setfalse()
{
	xiaomi-device-raw-set False
}
```

##### B.1. turn on the device

```bash
# turn on the device
$ xiaomi-device-raw-settrue
[(miiocli device --ip 192.168.0.28 --token 12345678901234567890123456789012 raw_command set_properties "[{'did': '987654321', 'siid': 2, 'piid': 1, 'value':True }]")]
Running command raw_command
[{'did': '987654321', 'siid': 2, 'piid': 1, 'code': 0}]
```

##### B.2. turn off the device

```bash
# turn off the device
$ xiaomi-device-raw-setfalse
[(miiocli device --ip 192.168.0.28 --token 12345678901234567890123456789012 raw_command set_properties "[{'did': '987654321', 'siid': 2, 'piid': 1, 'value':False }]")]
Running command raw_command
[{'did': '987654321', 'siid': 2, 'piid': 1, 'code': 0}]
```

# Appendix

# I. Study

## I.1. [python-miio](https://python-miio.readthedocs.io/en/latest/)

## I.2. [Linux命令行控制小米电源开关](https://blog.csdn.net/yanceylu/article/details/135067812)

## I.3. [[米家]解除台版小米多功能網關遠端控制(TELNET)密碼](https://esisterebbb.blogspot.com/2021/01/telnet.html)

## I.4. [使用 Python 控制米家设备](https://moenew.us/python-miio-use.html)

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. miiocli Usage

```bash
$ miiocli --help
Usage: miiocli [OPTIONS] COMMAND [ARGS]...

Options:
  -d, --debug
  -o, --output [default|json|json_pretty]
  --version                       Show the version and exit.
  --help                          Show this message and exit.

Commands:
  airconditionermiot
  airconditioningcompanion
  airconditioningcompanionmcn02
  airconditioningcompanionv3
  airdehumidifier
  airdogx3
  airfresh
  airfresha1
  airfresht2017
  airhumidifier
  airhumidifierjsq
  airhumidifierjsqs
  airhumidifiermiot
  airhumidifiermjjsq
  airpurifier
  airpurifiermiot
  airqualitymonitor
  airqualitymonitorcgdn1
  alarmclock
  aqaracamera
  ceil
  chuangmicamera
  chuangmiir
  chuangmiplug
  cloud                          Cloud commands.
  cooker
  curtainmiot
  device
  discover                       Discover devices using both handshake...
  dreamevacuum
  fan
  fan1c
  fanleshow
  fanmiot
  fanp5
  fanza5
  g1vacuum
  gateway
  heater
  heatermiot
  huizuo
  huizuolampfan
  huizuolampheater
  huizuolampscene
  miotdevice
  petwaterdispenser
  philipsbulb
  philipseyecare
  philipsmoonlight
  philipsrwread
  philipswhitebulb
  powerstrip
  pwznrelay
  roborockvacuum
  roidmivacuummiot
  scisharecoffee
  toiletlid
  viomivacuum
  walkingpad
  waterpurifier
  waterpurifieryunmi
  wifirepeater
  wifispeaker
  yeelight
  yeelightdualcontrolmodule

```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

