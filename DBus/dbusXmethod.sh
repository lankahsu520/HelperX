#!/bin/sh

[ "$BLUEZX_STRING" != "" ] && DBUS_STRING="string:$BLUEZX_STRING"
[ "$BLUEZX_ARRAY" != "" ] && DBUS_ARRAY="array:$BLUEZX_ARRAY"
[ "$BLUEZX_DICT" != "" ] && DBUS_DICT="dict:$BLUEZX_DICT"

[ "$BLUEZX_OBJPATH" != "" ] && DBUS_OBJPATH="objpath:$BLUEZX_OBJPATH"

export DBUS_REPLY="--print-reply --reply-timeout=5000"

#** DBUS **
DBUS_DEST="--dest=$DBUS_DEST_XXX"
DBUS_PATH="$DBUS_PATH_XXX"
DBUS_METHOD="$DBUS_M_IFAC_XXX.$DBUS_METHOD_XXX"

DBUS_BODY="$DBUS_STRING $DBUS_ARRAY $DBUS_DICT"

#** GDBUS **
GDBUS_DEST="--dest $DBUS_DEST_XXX"
# this is PATH, not the same objpath:
GDBUS_PATH="--object-path $DBUS_PATH_XXX"
GDBUS_METHOD="--method $DBUS_M_IFAC_XXX.$DBUS_METHOD_XXX"

[ "$BLUEZX_COMMAND" != "" ] && GDBUS_BODY="$BLUEZX_COMMAND"

#** COMMAND **
DO_COMMAND_EXE="dbus-send"
if [ "$DO_COMMAND_EXE" = "gdbus" ]; then
	DO_COMMAND="gdbus call --system $GDBUS_DEST $GDBUS_PATH $GDBUS_METHOD $GDBUS_BODY"
else
	DO_COMMAND="dbus-send --system $DBUS_REPLY --type=method_call $DBUS_DEST $DBUS_PATH $DBUS_METHOD $DBUS_OBJPATH $DBUS_BODY"
fi

echo "[$DO_COMMAND]"
sh -c "$DO_COMMAND"
