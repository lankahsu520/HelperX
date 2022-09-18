#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 topic body"
PWD=`pwd`

DAEMON="mosquitto_pub"

MQTT_TOPIC_WANT=$1
MQTT_BODY=$2

MQTT_IP=127.0.0.1
MQTT_PORT=1883
MQTT_USER=apple
MQTT_PASS=apple520
MQTT_USER_PASS="-u $MQTT_USER -P $MQTT_PASS"
MQTT_CERT=""
#MQTT_CERT="--cafile /tmp/mqtt.ca --cert /tmp/mqtt_beex.crt --key /tmp/mqtt_beex.key"

MQTT_TOPIC_PREFIX="$MQTT_USER"
MQTT_TOPIC="$MQTT_TOPIC_PREFIX/$MQTT_TOPIC_WANT"
[ "$MQTT_TOPIC" != "" ] && MQTT_TOPIC_ARG="-t '$MQTT_TOPIC'"

MQTT_BODY_ARG="-m '{}'"
[ "$MQTT_BODY" != "" ] && MQTT_BODY_ARG="-m '$MQTT_BODY'"

MQTT_ARG="-h $MQTT_IP -p $MQTT_PORT $MQTT_USER_PASS $MQTT_CER $MQTT_TOPIC_ARG $MQTT_BODY_ARG"

die_fn()
{
	echo $@
	exit 1
}

start_fn()
{
	#** COMMAND **
	DO_COMMAND_EXE="$DAEMON"
	DO_COMMAND="$DO_COMMAND_EXE $MQTT_ARG"

	echo "[$DO_COMMAND]"
	sh -c "$DO_COMMAND"

	return 0
}

showusage_fn()
{
	die_fn "$HINT"

	return 0
}

[ "$MQTT_TOPIC_WANT" != "" ] || showusage_fn

main_fn()
{
	start_fn
}

main_fn

exit 0