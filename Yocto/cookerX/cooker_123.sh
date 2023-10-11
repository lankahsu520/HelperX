#!/bin/sh

HINT="$0 {all|cook|build|dry-run|generate|shell|clean|distclean|update|init|ls|pull}"
HINT+="\nExample:"
HINT+="\n\t init + update + generate + cook, check: $0 all"
HINT+="\n\t init + update + generate + cook: $0 cook"
HINT+="\n\t build: $0 build"
PWD=`pwd`

ACTION=$1

RUN_SH=`basename $0`

[ "$PJ_YOCTO_MACHINE" != "" ] || export PJ_YOCTO_MACHINE="raspberrypi3"
[ "$PJ_YOCTO_TARGET" != "" ] || export PJ_YOCTO_TARGET="pi3"

BUILD_START_STRING=`date +%Y%m%d%H%M%S`
BUILD_END_STRING=`date +%Y%m%d%H%M%S`

[ -d builds ] || (mkdir -p builds;)
LOG="$PWD/builds/build_log_$BUILD_START_STRING.txt"
LOG_ARG=">> $LOG"
TEE_ARG=""
[ "$LOG" != "" ] && TEE_ARG="| tee -a $LOG"

INTERACTIVE=""

COOKER_MENU="$PJ_COOKER_MENU_DIR/$PJ_COOKER_MENU"
COOKER_VERBOSE="-v"
#COOKER_DRY="-n"

BUILD_SCRIPT="build-script.sh"

datetime_fn()
{
	PROMPT=$1
	#NOW_t=`date +"%Y%m%d %T"`
	NOW_t=`date +"%Y%m%d %H%M%S"`
	#DO_COMMAND="echo \"$NOW_t - $PROMPT\" $TEE_ARG"
	sh -c "echo \"$NOW_t - $PROMPT\" $TEE_ARG"

	return 0
}

die_fn()
{
	#echo $@
	[ "$@" = "$HINT" ] && echo -e "$@" && exit 1
	datetime_fn "$@"
	exit 1
}

do_command_fn()
{
	DO_COMMAND=$1
	datetime_fn "[$DO_COMMAND]"
	sh -c "$DO_COMMAND"
}

ls_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "
	do_command_fn "ls -al builds/build-$PJ_YOCTO_TARGET/tmp/deploy/images/$PJ_YOCTO_MACHINE"
}

pull_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "
	do_command_fn "(cd $PJ_COOKER_MENU_DIR; git pull;)"
}

distclean_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "
	do_command_fn "rm -rf builds/build-*"
}

cfg_fn()
{
	#datetime_fn "${FUNCNAME[0]} ... "

	[ -f .cookerconfig_bak ] || (cp .cookerconfig .cookerconfig_bak;)

	export YOCTO_DOWNLOADS=`realpath $PJ_YOCTO_DOWNLOADS`
	export YOCTO_SSTATE=`realpath $PJ_YOCTO_SSTATE`
	jq . .cookerconfig_bak | jq ".menu=\"`pwd`/$PJ_COOKER_MENU_DIR/$PJ_COOKER_MENU\"" | jq ".[\"layer-dir\"]=\"$PJ_YOCTO_LAYERS\"" | jq ".[\"build-dir\"]=\"$PJ_YOCTO_BUILDS\"" | jq ".[\"sstate-dir\"]=\"$YOCTO_SSTATE\"" | jq ".[\"dl-dir\"]=\"$YOCTO_DOWNLOADS\"" | jq -c . > .cookerconfig

	return 0
}

clean_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker clean"

	return 0
}

update_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker update"

	return 0
}

init_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker $COOKER_DRY $COOKER_VERBOSE init $COOKER_MENU"

	return 0
}

cook_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker $COOKER_DRY $COOKER_VERBOSE cook $COOKER_MENU $PJ_YOCTO_TARGET"

	return 0
}

build_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker $COOKER_DRY $COOKER_VERBOSE build $PJ_YOCTO_TARGET"

	return 0
}

dry_run_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker --dry-run cook $COOKER_MENU $PJ_YOCTO_TARGET > $BUILD_SCRIPT; chmod  +x  $BUILD_SCRIPT"
	sed -i --follow-symlinks "s|env bash -c source|source|g" $BUILD_SCRIPT

	return 0
}

generate_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker generate"

	return 0
}

shell_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker shell $PJ_YOCTO_TARGET"

	return 0
}

all_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	do_command_fn "cooker cook $COOKER_MENU"

	return 0
}

showusage_fn()
{
	die_fn "$HINT"

	return 0
}

exit_fn()
{
	datetime_fn "${FUNCNAME[0]} ... "

	return 0
}

[ "$ACTION" != "" ] || showusage_fn

main_fn()
{
	cfg_fn

	case $ACTION in
		all)
			all_fn
		;;
		shell)
			shell_fn
		;;
		cook)
			cook_fn
		;;
		build)
			build_fn
		;;
		dry-run)
			dry_run_fn
		;;
		generate)
			generate_fn
		;;
		update)
			update_fn
		;;
		init)
			init_fn
		;;
		clean)
			clean_fn
		;;
		distclean)
			distclean_fn
		;;
		ls)
			ls_fn
		;;
		pull)
			pull_fn
		;;
		*)
			showusage_fn
		;;
	esac
}

#trap "trap_ctrlc" 2
main_fn

exit_fn
exit 0
