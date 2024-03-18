#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 {all|ssl|install}"
NOW_t=`date +"%Y%m%d%H%M%S"`
PWD=`pwd`

ACTION=$1

IS_ECHO="0"
IS_QUIT=0

SAVE_PATH="client"
SAVE_PATH_ARG=""
WORK_PATH="/etc/mosquitto/certs"
WORK_PATH_ARG=""

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

ssl_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "rm -rf $PJ_PREFIX/$SAVE_PATH"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "mkdir -p $PJ_PREFIX/$SAVE_PATH"

	# () -> ./client/mqtt_beex.key
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl genrsa -out $CERT_CLI_KEY $CERT_BITS"

	# (./client/mqtt_beex.key + ssl_ca_mqtt-beex.conf) -> ./client/mqtt_beex.csr
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl req -new -out $CERT_CLI_CSR -key $CERT_CLI_KEY -config $CERT_CLI_CONF"

	# (./client/mqtt_beex.csr, ./ca/mqtt.ca, ./ca/mqtt.ca.key, ./ca/mqtt.srl + ssl_mqtt-alt.ext) -> ./client/mqtt_beex.crt
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl x509 -req -in $CERT_CLI_CSR -CA $CERT_CA -CAkey $CERT_CA_KEY -CAserial $CERT_CA_SRL -out $CERT_CLI_CERT -days $CERT_DAYS -extfile $CERT_EXT"
}

install_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "ls -al ./$SAVE_PATH"
}

srv_fn()
{
	return 0
}

all_fn()
{
	ssl_fn
	install_fn
	srv_fn
}

showusage_fn()
{
	printf "$HINT"; datetime_fn ""; exit 1

	return 0
}

trap_ctrlc()
{
	echo "Ctrl-C caught ..."
 
	[ -z $INTERACTIVE ] || stop_fn
}

[ "$ACTION" != "" ] || showusage_fn

main_fn()
{
	case $ACTION in
		all)
			all_fn
		;;
		ssl)
			ssl_fn
		;;
		install)
			install_fn
		;;
		srv)
			srv_fn
		;;
		*)
			showusage_fn
		;;
	esac
}

trap "trap_ctrlc" 2
main_fn

exit 0