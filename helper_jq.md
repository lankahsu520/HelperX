# [jq](https://devdocs.io/jq/)
[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]
[![GitHub watchers][watchers-image]][watchers-image]

[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues
[watchers-image]: https://img.shields.io/github/watchers/lankahsu520/HelperX.svg
[watchers-url]: https://github.com/lankahsu520/HelperX/watchers

# 1. Overview

> jq - Command-line JSON processor

## 1.1. Install jq

```bash
$ sudo apt-get update
$ sudo apt-get --yes install jq
$ jq --version
jq-1.6

```

# 2. A json file from [helper_AWS-CLI.md](https://github.com/lankahsu520/HelperX/blob/master/helper_AWS-CLI.md)

```bash
$ aws dynamodb scan --table-name Music
```

- [Music.json](./AWS/Music.json)

```json
{"Items":[{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"1"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Call Me Today"}},{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}},{"AlbumTitle":{"S":"Album123"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"mouse"},{"S":"tiger"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka"}},{"AlbumTitle":{"S":"Lanka520"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"cat"},{"S":"mouse"},{"S":"stoat"},{"S":"snake"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka520520"}},{"AlbumTitle":{"S":"Songs About Life"},"Awards":{"S":"10"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"Happy Day"}},{"AlbumTitle":{"S":"Another Album Title"},"Awards":{"S":"8"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"PartiQL Rocks"}}],"Count":6,"ScannedCount":6,"ConsumedCapacity":null}

```

```bash
JSON_ABC='{"a":1,"b":2,"c":3,"k":11,"d":4,"e":5,"f":6,"g":7,"p":16,"h":8,"i":9,"j":10,"l":12,"m":13,"u":21,"n":14,"o":15,"v":22,"q":17,"r":18,"s":19,"t":20,"w":23,"x":24,"y":25,"z":26}'

JKEY_COUNT=Count
JVAL_COUNT=6
JKEY_SCANNEDCOUNT=ScannedCount
JKEY_CONSUMEDCAPACITY=ConsumedCapacity

JKEY_ITEMS=Items
JKEY_ALBUMTITLE=AlbumTitle
```

# 3. General Commands

#### - Print formatted JSON

```bash
# from file
$ jq . ./AWS/Music.json
or
# from pipe
$ cat ./AWS/Music.json | jq .

$ echo JSON_ABC | jq -c .

```

```bash
# format *.json ->  *.json-bak
#** jq Handler **
function jqformater()
{
	HINT="Usage: ${FUNCNAME[0]} <file>\nExample:\n	${FUNCNAME[0]} *.json"
	FILE1="$*"

	if [ ! -z "$FILE1" ]; then
		for file in $FILE1; do
			DO_COMMAND="(jq . $file > $file-new ;)"
			echo "[$DO_COMMAND]"
			sh -c "$DO_COMMAND"
		done
	else
		echo -e $HINT
	fi
}
```

#### - A Particular Field

```bash
$ jq '.Count' ./AWS/Music.json
6
$ jq '.["ScannedCount"]' ./AWS/Music.json
6
$ jq '.ConsumedCapacity' ./AWS/Music.json
null

```

#### - Pass System Environment Variable(s)

>```
> --arg name value:
>
>           This  option  passes a value to the jq program as a predefined variable. If you run jq
>           with --arg foo bar, then $foo is available in the program and  has  the  value  "bar".
>           Note that value will be treated as a string, so --arg foo 123 will bind $foo to "123".
>```
>
>```
>--argjson name JSON-text:
>
>           This option passes a JSON-encoded value to the jq program as a predefined variable. If
>           you run jq with --argjson foo 123, then $foo is available in the program and  has  the
>           value 123.
>```

```bash
$ jq --arg X $JKEY_COUNT '.[$X]' ./AWS/Music.json
6

# parse as integer
$ jq -c --arg X $JKEY_COUNT --argjson Y $JVAL_COUNT '. | select(.[$X]==$Y)' ./AWS/Music.json
{"Items":[{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"1"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Call Me Today"}},{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}},{"AlbumTitle":{"S":"Album123"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"mouse"},{"S":"tiger"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka"}},{"AlbumTitle":{"S":"Lanka520"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"cat"},{"S":"mouse"},{"S":"stoat"},{"S":"snake"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka520520"}},{"AlbumTitle":{"S":"Songs About Life"},"Awards":{"S":"10"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"Happy Day"}},{"AlbumTitle":{"S":"Another Album Title"},"Awards":{"S":"8"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"PartiQL Rocks"}}],"Count":6,"ScannedCount":6,"ConsumedCapacity":null}

# parse as integer
$ JVAL_NUMBER=10
$ echo $JSON_ABC | jq -c --argjson X $JVAL_NUMBER '.[] | select(.==$X)'
10

$ jq '."'"$JKEY_SCANNEDCOUNT"'"' ./AWS/Music.json
6
$ jq --arg X $JKEY_SCANNEDCOUNT '.[$X]' ./AWS/Music.json
6

$ jq --arg X $JKEY_CONSUMEDCAPACITY '.[$X]' ./AWS/Music.json
null

$ jq --arg X $JKEY_ITEMS --arg Y $JKEY_ALBUMTITLE'.[$X].[].[$Y]' ./AWS/Music.json

```

#### - Compact Output  [ --compact-output / -c ]

>--compact-output / -c:
>
>      By default, jq pretty-prints JSON output.  Using  this  option  will  result  in  more
>      compact output by instead putting each JSON object on a single line.

```bash
# compact output
$ jq -c '.Items' ./AWS/Music.json
[{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"1"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Call Me Today"}},{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}},{"AlbumTitle":{"S":"Album123"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"mouse"},{"S":"tiger"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka"}},{"AlbumTitle":{"S":"Lanka520"},"Awards":{"S":"1"},"Sponsor":{"L":[{"S":"dog"},{"S":"cat"},{"S":"mouse"},{"S":"stoat"},{"S":"snake"}]},"Artist":{"S":"Lanka"},"SongTitle":{"S":"Lanka520520"}},{"AlbumTitle":{"S":"Songs About Life"},"Awards":{"S":"10"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"Happy Day"}},{"AlbumTitle":{"S":"Another Album Title"},"Awards":{"S":"8"},"Artist":{"S":"Acme Band"},"SongTitle":{"S":"PartiQL Rocks"}}]

```

#### - Null Field(s)

```bash
$ jq '.NotFound' ./AWS/Music.json
null

$ jq -c '.Items[].NotFound' ./AWS/Music.json
null
null
null
null
null
null

```

#### - Print raw strings [ --raw-output / -r ]

>```
>--raw-output / -r:
>
>           With this option, if the filter´s result is a string then it will be written  directly
>           to  standard output rather than being formatted as a JSON string with quotes. This can
>           be useful for making jq filters talk to non-JSON-based systems.
>```

```bash
$ jq -c '.Items[0].AlbumTitle.S' ./AWS/Music.json
"Somewhat Famous"

$ jq -cr '.Items[0].AlbumTitle.S' ./AWS/Music.json
Somewhat Famous

```

#### - In sorted order [ --sort-keys / -S ]

> ```
> --sort-keys / -S:
>            Output the fields of each object with the keys in sorted order.
> ```

```bash
$ echo '{"z":26,"b":2,"c":3,"k":11,"d":4,"e":5,"x":24}' | jq -cS
{"b":2,"c":3,"d":4,"e":5,"k":11,"x":24,"z":26}

$ echo $JSON_ABC | jq -cS .
{"a":1,"b":2,"c":3,"d":4,"e":5,"f":6,"g":7,"h":8,"i":9,"j":10,"k":11,"l":12,"m":13,"n":14,"o":15,"p":16,"q":17,"r":18,"s":19,"t":20,"u":21,"v":22,"w":23,"x":24,"y":25,"z":26}

```

#### - Delete Field(s) [ del ]

> ```
> del(path_expression)
>        The builtin function del removes a key and its corresponding value from an object.
> ```

```bash
$ echo '{"z":26,"b":2,"c":3,"k":11,"d":4,"e":5,"x":24}' | jq -cS '. | del(.b,.c)'
{"d":4,"e":5,"k":11,"x":24,"z":26}

```

# 4. Handle Array

## 4.1. Item(s)

#### - A object of Items[?]

```bash
$ jq -c '.Items[1]' ./AWS/Music.json
{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}}

$ JKEY_ITEMS=Items
$ jq -c --arg X $JKEY_ITEMS '.[$X][1]' ./AWS/Music.json
```

#### - List AlbumTitle(s) of Items[?]

```bash
$ jq -c '.Items[].AlbumTitle' ./AWS/Music.json
{"S":"Somewhat Famous"}
{"S":"Somewhat Famous"}
{"S":"Album123"}
{"S":"Lanka520"}
{"S":"Songs About Life"}
{"S":"Another Album Title"}

$ JKEY_ITEMS=Items
$ JKEY_ALBUMTITLE=AlbumTitle
$ jq -c --arg X $JKEY_ITEMS --arg Y $JKEY_ALBUMTITLE '.[$X][] | .[$Y]' ./AWS/Music.json
```
```bash
$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json
"Somewhat Famous"
"Somewhat Famous"
"Album123"
"Lanka520"
"Songs About Life"
"Another Album Title"

$ jq -c --arg X $JKEY_ITEMS --arg Y $JKEY_ALBUMTITLE '.[$X][] | .[$Y].S' ./AWS/Music.json
```

```bash
# just retrieve one
$ jq -c '.Items[2].AlbumTitle' ./AWS/Music.json
{"S":"Album123"}

$ JKEY_ALBUMTITLE=AlbumTitle
$ jq -c --arg X $JKEY_ITEMS --arg Y $JKEY_ALBUMTITLE '.[$X][2] | .[$Y].S' ./AWS/Music.json

$ jq -c '.Items[2]."AlbumTitle"."S"' ./AWS/Music.json
"Album123"
$ jq -c --arg X $JKEY_ITEMS --arg Y $JKEY_ALBUMTITLE '.[$X][2] | .[$Y].S' ./AWS/Music.json

```

#### - Print as  a large array [ --slurp/-s ]

>```
>--slurp/-s:
>
>           Instead of running the filter for each JSON object in the input, read the entire input
>           stream into a large array and run the filter just once.
>```

```bash
$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json | jq -cs '.'
["Somewhat Famous","Somewhat Famous","Album123","Lanka520","Songs About Life","Another Album Title"]

$ jq -c '[.Items[].AlbumTitle.S]' ./AWS/Music.json
["Somewhat Famous","Somewhat Famous","Album123","Lanka520","Songs About Life","Another Album Title"]

```

## 4.2. functions

#### - [add](https://devdocs.io/jq/index#add)

> The filter `add` takes as input an array, and produces as output the elements of the array added together. This might mean summed, concatenated or merged depending on the types of the elements of the input array - the rules are the same as those for the `+` operator (described above).
>
> If the input is an empty array, `add` returns `null`.

```bash
# 當 localIce.candidateType=="srflx" 時，列出 duration
$ jq -c '.[] | select(.localIce.candidateType=="srflx" ) | .duration' ./AWS/kvsStreamingSession.json
21
11
3
16
7

# 當 localIce.candidateType=="srflx" 時，將 duration 放入一陣列
$ jq -c '[.[] | select(.localIce.candidateType=="srflx") | .duration]' ./AWS/kvsStreamingSession.json
[21,11,3,16,7]

# 當 localIce.candidateType=="srflx" 時，將 duration 放入一陣列，並將陣列的值加總
$ jq -c '[.[] | select(.localIce.candidateType=="srflx") | .duration] | add' ./AWS/kvsStreamingSession.json
58

$ jq -c '[.[] | select(.localIce.candidateType=="relay" or .localIce.candidateType=="relay" ) | .duration ]' ./AWS/kvsStreamingSession.json
[6]
```

#### - Pickup n~m (1:3=1,2; 0:1=1)

```bash
$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json | jq -cs '.[1:3]'
["Somewhat Famous","Album123"]

$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json  | jq -cs '.[0:1]'
["Somewhat Famous"]

# last one [-1:]
$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json | jq -cs '.[-1:]'
```

#### - [select(boolean_expression)](https://devdocs.io/jq/index#select)

>The function `select(f)` produces its input unchanged if `f` returns true for that input, and produces no output otherwise.
>
>     注意：所列印的層級在 select 之前決定，下面的範例是從 Items 開始

```bash
$ jq -c '.Items[] | select(.AlbumTitle.S=="Somewhat Famous")' ./AWS/Music.json
{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"1"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Call Me Today"}}
{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}}

$ jq -c '[.Items[] | select(.AlbumTitle.S=="Somewhat Famous")]' ./AWS/Music.json
[{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"1"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Call Me Today"}},{"AlbumTitle":{"S":"Somewhat Famous"},"Awards":{"S":"2"},"Artist":{"S":"No One You Know"},"SongTitle":{"S":"Howdy"}}]
```
#### - [unique, unique_by(path_exp)](https://devdocs.io/jq/index#unique-unique_by)

>The `unique` function takes as input an array and produces an array of the same elements, in sorted order, with duplicates removed.
>
>The `unique_by(path_exp)` function will keep only one element for each value obtained by applying the argument. Think of it as making an array by taking one element out of every group produced by `group`.

```bash
$ jq -c '.Items[].AlbumTitle.S' ./AWS/Music.json | jq -cs 'unique_by(.)'
["Album123","Another Album Title","Lanka520","Somewhat Famous","Songs About Life"]

$ jq -c '[.Items[].AlbumTitle.S] | unique_by(.)' ./AWS/Music.json
["Album123","Another Album Title","Lanka520","Somewhat Famous","Songs About Life"]
```

# Appendix

# I. Study

## I.1. [jq 實戰教學](https://myapollo.com.tw/blog/jq-by-example/)

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. [jq](https://manpages.ubuntu.com/manpages/xenial/man1/jq.1.html) Usage

```bash
$ jq --help
jq - commandline JSON processor [version 1.6]

Usage:  jq [options] <jq filter> [file...]
        jq [options] --args <jq filter> [strings...]
        jq [options] --jsonargs <jq filter> [JSON_TEXTS...]

jq is a tool for processing JSON inputs, applying the given filter to
its JSON text inputs and producing the filter's results as JSON on
standard output.

The simplest filter is ., which copies jq's input to its output
unmodified (except for formatting, but note that IEEE754 is used
for number representation internally, with all that that implies).

For more advanced filters see the jq(1) manpage ("man jq")
and/or https://stedolan.github.io/jq

Example:

        $ echo '{"foo": 0}' | jq .
        {
                "foo": 0
        }

Some of the options include:
  -c               compact instead of pretty-printed output;
  -n               use `null` as the single input value;
  -e               set the exit status code based on the output;
  -s               read (slurp) all inputs into an array; apply filter to it;
  -r               output raw strings, not JSON texts;
  -R               read raw strings, not JSON texts;
  -C               colorize JSON;
  -M               monochrome (don't colorize JSON);
  -S               sort keys of objects on output;
  --tab            use tabs for indentation;
  --arg a v        set variable $a to value <v>;
  --argjson a v    set variable $a to JSON value <v>;
  --slurpfile a f  set variable $a to an array of JSON texts read from <f>;
  --rawfile a f    set variable $a to a string consisting of the contents of <f>;
  --args           remaining arguments are string arguments, not files;
  --jsonargs       remaining arguments are JSON arguments, not files;
  --               terminates argument processing;

Named arguments are also available as $ARGS.named[], while
positional arguments are available as $ARGS.positional[].

See the manpage for more options.

```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

