#!/bin/sh

FILENAME_INPUT=$1
[ ! -z "$FILENAME_INPUT" ] || FILENAME_INPUT="devices.txt"
[ ! -f "$FILENAME_INPUT" ] && echo "Please input the source file !!!" && exit 1
FILENAME_OUTPUT=`basename $FILENAME_INPUT | sed 's/\.[^.]*$//'`".json"

# 將 Windows CRLF 轉成 LF，避免 \r 造成提早換行
sed 's/\r$//' $FILENAME_INPUT |
awk '
  # trim function
  function trim(s) {
    sub(/^[ \t]+/, "", s)
    sub(/[ \t]+$/, "", s)
    return s
  }

  BEGIN { idx = 0 }

  {
    line = trim($0)

    # detect separator: 一行只含 "-" 就當成新的物件開始
    if (line ~ /^-+$/) {
      idx++
      next
    }

    # parse KEY: VALUE
    if (match(line, /^([A-Za-z0-9 _-]+):[ \t]*(.*)$/, m)) {
      key = m[1]
      val = m[2]
      printf "%d.%s=%s\n", idx, key, val
    }
  }
' |
jq -Rn '
  [ inputs
    | capture("(?<idxkey>[^=]+)=(?<val>.*)")
    | .idxkey as $k
    | .val as $v
    | ($k | split(".")) as $p
    | { idx: ($p[0] | tonumber), key: $p[1], val: $v }
  ]
  | group_by(.idx)
  | map( map({ (.key): .val }) | add )
' > $FILENAME_OUTPUT

jq -r 'def fmt: @text; ( "IP\tTOKEN\tID\tMODEL" ), ( .[] | "\(.IP)\t\(.TOKEN)\t\(.ID)\t\(.MODEL)" )' $FILENAME_OUTPUT | column -t
