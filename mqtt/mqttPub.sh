#!/bin/sh

# mosquitto_pub -h 127.0.0.1 -p 1883 -u apple -P apple520     -t 'apple/1/080027A1F836/CCC3F3BB/2/0/0001000C' -m '{name:Motion Sensor,val:idle}'
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

now_fn()
{
	NOW_t=`date +"%Y%m%d%H%M%S"`
	return $NOW_t
}

datetime_fn()
{
	PROMPT=$1

	if [ "${PROMPT}" = "" ]; then
		echo
	else
		now_fn
		DO_COMMAND_NOW="echo \"$NOW_t ${RUN_SH}|${PROMPT}\" $TEE_ARG"; sh -c "$DO_COMMAND_NOW"
	fi

	return 0
}

eval_fn()
{
	DO_COMMAND="$2"
	datetime_fn "$1- [$DO_COMMAND]"
	eval ${DO_COMMAND}
}

die_fn()
{
	datetime_fn "$@"; datetime_fn ""
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
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$DO_COMMAND_EXE $MQTT_ARG"

	return 0
}

showusage_fn()
{
	printf "$HINT"; datetime_fn ""; exit 1

	return 0
}

[ "$MQTT_TOPIC_WANT" != "" ] || showusage_fn

main_fn()
{
	start_fn
}

main_fn

exit 0