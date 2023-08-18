# Template
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

# 1.  [GCC Command Options](https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html)

## 1.1. [Options to Request or Suppress Warnings](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html)

#### A. [-Wall, -W](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wall)

> 顯示所有警告

> 強力建議使用

#### B. [-Wformat-truncation](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wformat-truncation)

> 警告有時無可避免，但建議使用 snprintf or asprintf

```bash
json_api.c:342:33: warning: ‘__builtin___snprintf_chk’ output may be truncated before the last format character [-Wformat-truncation=]
  342 |      SAFE_SPRINTF_EX(topic_new, "%s/%s", topic, key_found);
      |                                 ^~~~~~~

```

> topic_new: 1024
> topic: 1024
> key_found: pointer

> Level 1 of -Wformat-truncation enabled by -Wformat employs a conservative approach that warns only about calls to bounded functions whose return value is unused and that will most likely result in output truncation.

```bash
CFLAGS+=-Wformat-truncation=0
```

#### C. [-Wno-implicit-function-declaration](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wimplicit-function-declaration)

> 不建議使用，請 include 相對應的 Header File

```bash
statex_api.c:231:3: warning: implicit declaration of function ‘queuex_thread_stop’; did you mean ‘dbusx_thread_stop’? [-Wimplicit-function-declaration]
  231 |   queuex_thread_stop(statex_req->statex_q);
      |   ^~~~~~~~~~~~~~~~~~
      |   dbusx_thread_stop

```

```bash
CFLAGS+=-Wno-implicit-function-declaration
```

#### D. [-Wno-int-conversion](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wno-int-conversion)

> <font color="red">禁止使用</font>

```bash
statex_api.c:215:23: warning: assignment to ‘QueueX_t *’ {aka ‘struct QueueX_Struct *’} from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
  215 |  statex_req->statex_q = queuex_thread_init(name, MAX_OF_QSTATEX, sizeof(StateXPuck_t), statex_q_exec_cb, statex_q_free_cb);

```

```bash
CFLAGS+=-Wno-int-conversion
```

## 1.2. [Options for Debugging Your Program](https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html)

#### A. [-g](https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html#index-g)

> 建議使用，將來有利使用 gdb 進行 debug

```bash
$ gdb ./demo_123
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.1) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./demo_123...
(No debugging symbols found in ./demo_123)
(gdb)

```

```bash
CFLAGS+=-g
```

## 1.3. [Options for Code Generation Conventions](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html)

#### A. [-fPIC](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html#index-fPIC)

>編譯 shared library 時，請一定要加上

```bash
Building lib (shared): libutilx9.so
g++  -shared  -L/work/codebase/lankahsu520/utilx9/install/github_/lib -Wl,-rpath,/work/rootfs/lib -L./ -Wl,-soname,libutilx9.so.2 -o libutilx9.so.2.0.1 chainX_api.o clist_api.o led_api.o proc_table_api.o queuex_api.o multicast_api.o statex_api.o thread_api.o cronx_api.o utilx9.o crc16.o crc32alg.o internet-collect.o  usbX_api.o json_api.o mqtt_api.o lws_api.o curl_api.o rtp_api.o uv_api.o dbusx_api.o
/usr/bin/ld: lws_api.o: relocation R_X86_64_PC32 against symbol `dbg_more' can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: final link failed: bad value
collect2: error: ld returned 1 exit status

```

```bash
CFLAGS+=-fPIC
```

# 2. gdb

## 2.1. 範例 ./demo_000

#### A. 進入 gdb

```bash
$ gdb ./demo_000
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.1) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./demo_000...
(gdb)
```

#### B. (gdb) b xxx；設置斷點，指定 function-main

```bash
(gdb) b main
Breakpoint 1 at 0x1240: file demo_000.c, line 144.
```

#### C. (gdb) run；開始運行

```bash
(gdb) r
Starting program: /work/codebase/lankahsu520/utilx9/demo_000
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main (argc=1, argv=0x7fffffff9178) at demo_000.c:144
144     {
```

#### D. (gdb) list；顯示目前運行前、後的代碼

```bash
(gdb) list
139                     }
140             }
141     }
142
143     int main(int argc, char *argv[])
144     {
145             app_ParseArguments(argc, argv);
146             app_signal_register();
147             atexit(app_exit);
148
```

#### F.  (gdb) b xxx；設置斷點，指定行數

```bash
(gdb) b 145
Breakpoint 4 at 0x55555555526a: file demo_000.c, line 145.
(gdb) b 146
Breakpoint 3 at 0x5555555552af: file demo_000.c, line 146.
(gdb) b 147
Breakpoint 4 at 0x555555555313: file demo_000.c, line 147.
(gdb) b 149
Breakpoint 5 at 0x55555555531f: file demo_000.c, line 149.

```

#### G.  (gdb) info b；查看目前的斷點

```bash
(gdb) info b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000555555555240 in main at demo_000.c:144
        breakpoint already hit 1 time
2       breakpoint     keep y   0x000055555555526a in app_ParseArguments at demo_000.c:145
3       breakpoint     keep y   0x00005555555552af in app_signal_register at demo_000.c:146
4       breakpoint     keep y   0x0000555555555313 in main at demo_000.c:147
5       breakpoint     keep y   0x000055555555531f in app_loop at demo_000.c:149

```

#### H. (gdb) del xxx；移除特定的斷點

```bash
(gdb) del 4
```

#### I. (gdb) clear xxx；移除該行 or function 的斷點

```bash
(gdb) clear 146
```

#### J.  (gdb) continue；繼續執行，將執行至下一個斷點

```bash
(gdb) c
Continuing.

Breakpoint 2, app_ParseArguments (argv=0x7fffffff9178, argc=1) at demo_000.c:145
145             app_ParseArguments(argc, argv);
```

#### K. (gdb) step；繼續執行，跳轉至 function

```bash
(gdb) s
126             while((opt = getopt_long (argc, argv, short_options, long_options, &option_index)) != -1)
(gdb) list
121
122     static void app_ParseArguments(int argc, char **argv)
123     {
124             int opt;
125
126             while((opt = getopt_long (argc, argv, short_options, long_options, &option_index)) != -1)
127             {
128                     switch (opt)
129                     {
130                             case 'd':

```

#### L. (gdb) next；繼續執行

```bash
(gdb) n
main (argc=1, argv=0x7fffffff9178) at demo_000.c:146
146             app_signal_register();
```

#### M. (gdb) p xxx；印出變數

```bash
(gdb) p argc
$1 = 1
(gdb) p dbg_more
$2 = 2
(gdb) p argv
$3 = (char **) 0x7fffffff9178
(gdb) p argv[0]
$4 = 0x7fffffffa12d "/work/codebase/lankahsu520/utilx9/demo_000"
```

#### N. (gdb) set xxx=???；修改變數的值

```bash
(gdb) set dbg_more=3
(gdb) p dbg_more
$5 = 3

```

#### O. (gdb) info locals；查看 local 變數

```bash
(gdb) info locals
__FUNCTION__ = "main"
```

#### P.  (gdb) continue；繼續執行，將執行至下一個斷點

```bash
(gdb) c
Continuing.

Breakpoint 5, app_loop () at demo_000.c:154
154             app_loop();
```

#### Q. (gdb) quit；離開 gdb

```bash
(gdb) q
A debugging session is active.

        Inferior 1 [process 57186] will be killed.

Quit anyway? (y or n) y
```

## 2.2. TUI (Text User Interface)

#### A. 進入 gdb

```bash
$ gdb ./demo_000
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.1) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./demo_000...
(gdb)

```

#### B. 按下 **Ctrl+x+a**

![gdb01](./images/gdb01.png)

#### C. 按下 **Ctrl+l**，刷新螢幕

# Appendix

# I. Study

## I.1. [GCC Command Options](https://gcc.gnu.org/onlinedocs/gcc/Invoking-GCC.html)

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. [gcc](https://gcc.gnu.org) Usage

```bash
$ gcc --help
Usage: gcc [options] file...
Options:
  -pass-exit-codes         Exit with highest error code from a phase.
  --help                   Display this information.
  --target-help            Display target specific command line options.
  --help={common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[,...].
                           Display specific types of command line options.
  (Use '-v --help' to display command line options of sub-processes).
  --version                Display compiler version information.
  -dumpspecs               Display all of the built in spec strings.
  -dumpversion             Display the version of the compiler.
  -dumpmachine             Display the compiler's target processor.
  -print-search-dirs       Display the directories in the compiler's search path.
  -print-libgcc-file-name  Display the name of the compiler's companion library.
  -print-file-name=<lib>   Display the full path to library <lib>.
  -print-prog-name=<prog>  Display the full path to compiler component <prog>.
  -print-multiarch         Display the target's normalized GNU triplet, used as
                           a component in the library path.
  -print-multi-directory   Display the root directory for versions of libgcc.
  -print-multi-lib         Display the mapping between command line options and
                           multiple library search directories.
  -print-multi-os-directory Display the relative path to OS libraries.
  -print-sysroot           Display the target libraries directory.
  -print-sysroot-headers-suffix Display the sysroot suffix used to find headers.
  -Wa,<options>            Pass comma-separated <options> on to the assembler.
  -Wp,<options>            Pass comma-separated <options> on to the preprocessor.
  -Wl,<options>            Pass comma-separated <options> on to the linker.
  -Xassembler <arg>        Pass <arg> on to the assembler.
  -Xpreprocessor <arg>     Pass <arg> on to the preprocessor.
  -Xlinker <arg>           Pass <arg> on to the linker.
  -save-temps              Do not delete intermediate files.
  -save-temps=<arg>        Do not delete intermediate files.
  -no-canonical-prefixes   Do not canonicalize paths when building relative
                           prefixes to other gcc components.
  -pipe                    Use pipes rather than intermediate files.
  -time                    Time the execution of each subprocess.
  -specs=<file>            Override built-in specs with the contents of <file>.
  -std=<standard>          Assume that the input sources are for <standard>.
  --sysroot=<directory>    Use <directory> as the root directory for headers
                           and libraries.
  -B <directory>           Add <directory> to the compiler's search paths.
  -v                       Display the programs invoked by the compiler.
  -###                     Like -v but options quoted and commands not executed.
  -E                       Preprocess only; do not compile, assemble or link.
  -S                       Compile only; do not assemble or link.
  -c                       Compile and assemble, but do not link.
  -o <file>                Place the output into <file>.
  -pie                     Create a dynamically linked position independent
                           executable.
  -shared                  Create a shared library.
  -x <language>            Specify the language of the following input files.
                           Permissible languages include: c c++ assembler none
                           'none' means revert to the default behavior of
                           guessing the language based on the file's extension.

Options starting with -g, -f, -m, -O, -W, or --param are automatically
 passed on to the various sub-processes invoked by gcc.  In order to pass
 other options on to these processes the -W<letter> options must be used.

For bug reporting instructions, please see:
<file:///usr/share/doc/gcc-9/README.Bugs>.

```

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

