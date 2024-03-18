#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 {all|ssl|install}"
NOW_t=`date +"%Y%m%d%H%M%S"`
PWD=`pwd`

ACTION=$1

#IS_INTERACTIVE="-des3"
IS_ECHO="0"
IS_QUIT=0

SAVE_PATH="ca"
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
	printf "$HINT"; datetime_fn ""; exit 1
	exit 1
}

ssl_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "rm -rf $PJ_PREFIX/$SAVE_PATH"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "mkdir -p $PJ_PREFIX/$SAVE_PATH"

	# () -> ./ca/mqtt.ca.key
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl genrsa $IS_INTERACTIVE -out $CERT_CA_KEY $CERT_BITS"

	# (./ca/mqtt.ca.key + ssl_ca_mqtt-srv.conf) -> ./ca/mqtt.ca
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl req -new -x509 -days $CERT_DAYS -key $CERT_CA_KEY -out $CERT_CA -config $CERT_CA_CONF"
}

install_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "ls -al ./$SAVE_PATH"

	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo cp -avr $CERT_CA $WORK_PATH"
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
	die_fn "$HINT"

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