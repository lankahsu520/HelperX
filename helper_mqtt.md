# 1. mosquitto
## 1.1. Install
```bash
sudo add-apt-repository ppa:mosquitto-dev/mosquitto-ppa

sudo apt-get update

sudo apt-get install mosquitto
sudo apt-get install mosquitto-clients

mosquitto -v

```

## 1.2. Run

### 1.2.1. Service

```bash
sudo systemctl status mosquitto.service

sudo systemctl stop mosquitto.service
sudo systemctl start mosquitto.service

sudo systemctl restart mosquitto.service

journalctl -xe
```

### 1.2.2. Daemon

```bash
/usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf

sudo cat /var/log/mosquitto/mosquitto.log
```

## 1.3. Configuration

### 1.3.1. /etc/mosquitto/mosquitto.conf
```bash
$ ps -aux | grep mosquitto
mosquit+    1077  0.0  0.0  28108  5644 ?        Ssl  14:06   0:04 /usr/sbin/mosquitto -c /etc/mosquitto/mosquitto.conf

```

```bash
$ cat /etc/mosquitto/mosquitto.conf
# Place your local configuration in /etc/mosquitto/conf.d/
#
# A full description of the configuration file is at
# /usr/share/doc/mosquitto/examples/mosquitto.conf.example

pid_file /var/run/mosquitto.pid

persistence true
persistence_location /var/lib/mosquitto/

log_dest file /var/log/mosquitto/mosquitto.log

include_dir /etc/mosquitto/conf.d

```

```bash
$ ll /etc/mosquitto/conf.d
total 12
drwxr-xr-x 2 root root 4096  七  14 22:46 ./
drwxr-xr-x 5 root root 4096  七  14 22:46 ../
-rw-r--r-- 1 root root  142  三   3  2020 README

```

### 1.3.2. /etc/mosquitto/passwd

```bash
$ sudo mosquitto_passwd -c /etc/mosquitto/passwd lanka 

$ sudo mosquitto_passwd -b /etc/mosquitto/passwd apple apple520

$ cat /etc/mosquitto/passwd

```

### 1.3.3. /etc/mosquitto/acl

```bash
$ sudo vi /etc/mosquitto/acl

```

```bash
user lanka
topic #
topic $SYS/#

user apple
topic apple/#

```

### 1.3.4. /etc/mosquitto/conf.d/default.conf

```bash
$ sudo vi /etc/mosquitto/conf.d/default.conf

```
```
# 設定帳號密碼檔案
password_file /etc/mosquitto/passwd
acl_file /etc/mosquitto/acl

# 禁止匿名登入
#allow_anonymous false
allow_anonymous false

#listener 3881
listener 1883
protocol mqtt
#cafile /etc/mosquitto/certs/mqtt.ca
#keyfile /etc/mosquitto/certs/mqtt_srv.key
#certfile /etc/mosquitto/certs/mqtt_srv.crt

require_certificate false

# WS
listener 8083
protocol websockets
#cafile /etc/mosquitto/certs/mqtt.ca
#keyfile /etc/mosquitto/certs/mqtt_srv.key
#certfile /etc/mosquitto/certs/mqtt_srv.crt

#require_certificate true

```

# 2. Test

#### Topic

```
a/b/c/d
+/b/c/d
a/+/c/d
a/+/+/d
+/+/+/+

#
a/#
a/b/#
a/b/c/#
+/b/c/#
```

##### userid/methodid/macid/uuid/nodeid/epid

#### Subscriber

##### mqtt_sub.sh

```bash
./mqtt_sub.sh '+/080027A1F836/+/+/+/#'

```
#### Publisher

##### mqtt_pub.sh

```bash
./mqtt_pub.sh "1/080027A1F836/CCC3F3BB/2/0/0001000C" '{"name":"Motion Sensor","val":"idle"}'
./mqtt_pub.sh "1/080027A1F836/CCC3F3BB/2/0/0001000C" ''{"name":"Motion Sensor","val":"idle"}'

#** adding ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/1/0/00000002" '{}'
#** removing ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/1/0/00000003" '{}'
#** aborting ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/1/0/00000004" '{}'
#** reseting ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/1/0/00000008" '{}'
#** switch ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/2/0/00092501" '{"tgt_val":255}'
./mqtt_pub.sh "1/080027A1F836/FDFD818A/2/0/00092501"'{"toggle":1}'

#** dimmer ** 
./mqtt_pub.sh "1/080027A1F836/FDFD818A/3/0/00092601"'{"dur":5,"tgt_val":0}'
{"toggle":1}

./mqtt_pub.sh "2/080027A1F836/FDFD818A" '{}'

```
# 3. Cert

```bash
openssl x509 -noout -modulus -in mqtt_beex.crt | openssl md5
openssl rsa  -noout -modulus -in mqtt_beex.key | openssl md5
openssl x509 -noout -modulus -in mqtt.ca | openssl md5

```



# Appendix

## I. Study

- [樹莓派安裝 Mosquitto 輕量級 MQTT Broker 教學，連接各種物聯網設備](https://blog.gtwang.org/iot/raspberry-pi/raspberry-pi-mosquitto-mqtt-broker-iot-integration/)
- [MQTT教學（一）：認識MQTT](https://swf.com.tw/?p=1002)
- [MQTT(三)CONNECT Message](http://blog.maxkit.com.tw/2014/02/mqttconnect-message.html)
- [MQTT(四)PUBLISH Message](http://blog.maxkit.com.tw/2014/02/mqttpublish-message.html)
- [如何在Ubuntu 16.04上安装和保护Mosquitto MQTT消息传递代理](https://www.howtoing.com/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-ubuntu-16-04/)
- [Mosquitto ACL -Configuring and Testing MQTT Topic Restrictions](http://www.steves-internet-guide.com/topic-restriction-mosquitto-configuration/)

