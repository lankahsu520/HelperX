#!/bin/bash

RUN_SH=`basename $0`
HINT="$RUN_SH {up|run|exec|down|purge}"

ACTION=$1

DOCKER_NAME=trac
DOCKER_REPOSITORY=trac520
DOCKER_CONTAINER=hello-trac

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

up_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "docker compose up $DOCKER_NAME -d --build"
	return 0

}

run_fn()
{
	eval_fn "${FUNCNAME[0]}:${LINENO}" "docker compose up $DOCKER_NAME -d"
	return 0

}

exec_fn()
{
	#eval_fn "${FUNCNAME[0]}:${LINENO}" "docker exec -it $DOCKER_CONTAINER /bin/bash"
	eval_fn "${FUNCNAME[0]}:${LINENO}" "docker compose exec $DOCKER_NAME bash"

	return 0
}

down_fn()
{
	#eval_fn "${FUNCNAME[0]}:${LINENO}" "docker stop $DOCKER_CONTAINER"
	#eval_fn "${FUNCNAME[0]}:${LINENO}" "docker rm $DOCKER_CONTAINER"
	#sleep 1
	eval_fn "${FUNCNAME[0]}:${LINENO}" "docker compose down"

	return 0
}

purge_fn()
{
	down_fn

	eval_fn "${FUNCNAME[0]}:${LINENO}" "docker rmi $DOCKER_REPOSITORY"

	return 0
}

showusage_fn()
{
	printf "$HINT"; datetime_fn ""; exit 1

	return 0
}

main_fn()
{
	case $ACTION in
		up)
			up_fn
		;;
		run)
			run_fn
		;;
		exec)
			exec_fn
		;;
		down)
			down_fn
		;;
		purge)
			purge_fn
		;;
		*)
			showusage_fn
		;;
	esac
}

main_fn

exit 0