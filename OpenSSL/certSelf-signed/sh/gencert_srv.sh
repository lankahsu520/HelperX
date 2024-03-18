#!/bin/sh

RUN_SH=`basename $0`
HINT="$0 {all|ssl|install|srv|info}"
NOW_t=`date +"%Y%m%d%H%M%S"`
PWD=`pwd`

ACTION=$1

IS_ECHO="0"
IS_QUIT=0

SAVE_PATH="srv"
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

	# () -> ./srv/mqtt_srv.key
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl genrsa -out $CERT_SRV_KEY $CERT_BITS"

	# (./srv/mqtt_srv.key + ssl_ca_mqtt-beex.conf) -> ./srv/mqtt_srv.csr
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl req -new -out $CERT_SRV_CSR -key $CERT_SRV_KEY -config $CERT_SRV_CONF"

	# (./srv/mqtt_srv.csr, ./ca/mqtt.ca, ./ca/mqtt.ca.key + ssl_mqtt-alt.ext) -> ./srv/mqtt_srv.crt
	eval_fn "${FUNCNAME[0]}:${LINENO}" "openssl x509 -req -in $CERT_SRV_CSR -CA $CERT_CA -CAkey $CERT_CA_KEY -CAcreateserial -out $CERT_SRV_CERT -days 3650 -extfile $CERT_EXT"
}

install_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "ls -al ./$SAVE_PATH"

	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo cp -avr $CERT_CA $WORK_PATH"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo cp -avr $CERT_SRV_KEY $WORK_PATH"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo cp -avr $CERT_SRV_CERT $WORK_PATH"
}

srv_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "ls -al $WORK_PATH"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo chmod 555 $WORK_PATH/mqtt_srv.key"

	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo systemctl stop mosquitto.service"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo systemctl start mosquitto.service"

	eval_fn "${FUNCNAME[0]}:${LINENO}" "sudo systemctl status mosquitto.service"
}

info_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "cat /etc/mosquitto/mosquitto.conf"

	eval_fn "${FUNCNAME[0]}:${LINENO}" "(cd /etc/mosquitto/conf.d; ls | xargs cat )"
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
		info)
			info_fn
		;;
		*)
			showusage_fn
		;;
	esac
}

trap "trap_ctrlc" 2
main_fn

exit 0