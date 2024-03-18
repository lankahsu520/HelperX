#!/bin/sh

RUN_SH=`basename $0`
RUN_SH_REALPATH=`realpath $0`
RUN_SH_DIR=`dirname $RUN_SH_REALPATH`
HINT="$0 {all|ssl|install}"
NOW_t=`date +"%Y%m%d%H%M%S"`
PWD=`pwd`

ACTION=$1

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
	datetime_fn "$@"; datetime_fn ""
	exit 1
}

ssl_fn()
{
	echo "==> call gencert_ca.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_ca.sh ssl"
	echo
	echo "==> call gencert_srv.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_srv.sh ssl"
	echo
	echo "==> call gencert_client.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_client.sh ssl"
}

install_fn()
{
	echo "==> call gencert_ca.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_ca.sh install"
	echo
	echo "==> call gencert_srv.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_srv.sh install"
	echo
	echo "==> call gencert_client.sh ..."
	eval_fn "${FUNCNAME[0]}:${LINENO}" "$RUN_SH_DIR/gencert_client.sh install"
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