#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 topic body"
PWD=`pwd`

DAEMON="mosquitto_pub"

PJ_MQTT_TOPIC_WANT=$1
PJ_MQTT_BODY=$2

PJ_MQTT_IP=127.0.0.1
PJ_MQTT_PORT=1883
PJ_MQTT_USER=apple
PJ_MQTT_PASS=apple520
PJ_MQTT_USER_PASS="-u $PJ_MQTT_USER -P $PJ_MQTT_PASS"
PJ_MQTT_CERT=""
#PJ_MQTT_CERT="--cafile /tmp/mqtt.ca --cert /tmp/mqtt_beex.crt --key /tmp/mqtt_beex.key"

PJ_MQTT_TOPIC_PREFIX="$PJ_MQTT_USER"
PJ_MQTT_TOPIC="$PJ_MQTT_TOPIC_PREFIX/$PJ_MQTT_TOPIC_WANT"
[ "$PJ_MQTT_TOPIC" != "" ] && PJ_MQTT_TOPIC_ARG="-t '$PJ_MQTT_TOPIC'"

PJ_MQTT_BODY_ARG="-m '{}'"
[ "$PJ_MQTT_BODY" != "" ] && PJ_MQTT_BODY_ARG="-m '$PJ_MQTT_BODY'"

PJ_MQTT_ARG="-h $PJ_MQTT_IP -p $PJ_MQTT_PORT $PJ_MQTT_USER_PASS $PJ_MQTT_CER $PJ_MQTT_TOPIC_ARG $PJ_MQTT_BODY_ARG"

die_fn()
{
	echo $@
	exit 1
}

start_fn()
{
	#** COMMAND **
	DO_COMMAND_EXE="$DAEMON"
	DO_COMMAND="$DO_COMMAND_EXE $PJ_MQTT_ARG"

	echo "[$DO_COMMAND]"
	sh -c "$DO_COMMAND"

	return 0
}

showusage_fn()
{
	die_fn "$HINT"

	return 0
}

[ "$PJ_MQTT_TOPIC_WANT" != "" ] || showusage_fn

main_fn()
{
	start_fn
}

main_fn

exit 0