#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 topic body"
PWD=`pwd`

DAEMON="mosquitto_pub"

MQTT_TOPIC_WANT=$1
MQTT_BODY=$2
[ ! -z "$2" ] || MQTT_BODY="{}"

MQTT_HOST="127.0.0.1"
MQTT_HOST_ARG=""
MQTT_PORT="1883"
MQTT_PORT_ARG=""

MQTT_USER="apple"
MQTT_USER_ARG="" #-u $USER
MQTT_PASS="apple520"
MQTT_PASS_ARG="" #-P $PASS
MQTT_CLIENTID=""
MQTT_CLIENTID_ARG="" #-i $CLIENTID

MQTT_CERT_PATH=""
MQTT_CERT_PATH_ARG=""
MQTT_CAFILE="mqtt.ca"
MQTT_CAFILE_ARG=""
MQTT_CERT="mqtt_beex.crt"
MQTT_CERT_ARG=""
MQTT_CERT_KEY="mqtt_beex.key"
MQTT_CERT_KEY_ARG=""
MQTT_AUTH_ARG=""

MQTT_TOPIC_PREFIX="$MQTT_USER"
MQTT_TOPIC="$MQTT_TOPIC_PREFIX/$MQTT_TOPIC_WANT"

MQTT_ARG=""

die_fn()
{
	echo $@
	exit 1
}

arguments_fn()
{
	[ "$MQTT_HOST" != "" ] && MQTT_HOST_ARG="-h $MQTT_HOST"
	[ "$MQTT_PORT" != "" ] && MQTT_PORT_ARG="-p $MQTT_PORT"

	[ "$MQTT_USER" != "" ] && MQTT_USER_ARG="-u $MQTT_USER"
	[ "$MQTT_PASS" != "" ] && MQTT_PASS_ARG="-P $MQTT_PASS"
	[ "$MQTT_CLIENTID" != "" ] && MQTT_CLIENTID_ARG="-i $MQTT_CLIENTID"

	[ "$MQTT_CAFILE" != "" ] && [ "$MQTT_CERT_PATH" != "" ] && MQTT_CAFILE_ARG="--cafile $MQTT_CERT_PATH/$MQTT_CAFILE"
	[ "$MQTT_CERT" != "" ] && [ "$MQTT_CERT_PATH" != "" ] && MQTT_CERT_ARG="--cert $MQTT_CERT_PATH/$MQTT_CERT"
	[ "$MQTT_CERT_KEY" != "" ] && [ "$MQTT_CERT_PATH" != "" ] && MQTT_CERT_KEY_ARG="--key $MQTT_CERT_PATH/$MQTT_CERT_KEY"

	MQTT_AUTH_ARG="$MQTT_USER_ARG $MQTT_PASS_ARG $MQTT_CLIENTID_ARG $MQTT_CAFILE_ARG $MQTT_CERT_ARG $MQTT_CERT_KEY_ARG"

	[ "$MQTT_TOPIC" != "" ] && MQTT_TOPIC_ARG="-t '$MQTT_TOPIC'"

	[ "$MQTT_BODY" != "" ] && MQTT_BODY_ARG="-m '$MQTT_BODY'"

	MQTT_ARG="$MQTT_HOST_ARG $MQTT_PORT_ARG $MQTT_AUTH_ARG $MQTT_TOPIC_ARG $MQTT_BODY_ARG"

	return 0
}

start_fn()
{
	arguments_fn

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