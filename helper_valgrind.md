# [Valgrind](https://valgrind.org)
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

> [Valgrind](https://valgrind.org) is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile your programs in detail. You can also use Valgrind to build new tools.
>
> The Valgrind distribution currently includes seven production-quality tools: a memory error detector, two thread error detectors, a cache and branch-prediction profiler, a call-graph generating cache and branch-prediction profiler, and two different heap profilers. It also includes an experimental SimPoint basic block vector generator. It runs on the following platforms: X86/Linux, AMD64/Linux, ARM/Linux, ARM64/Linux, PPC32/Linux, PPC64/Linux, PPC64LE/Linux, S390X/Linux, MIPS32/Linux, MIPS64/Linux, X86/Solaris, AMD64/Solaris, ARM/Android (2.3.x and later), ARM64/Android, X86/Android (4.0 and later), MIPS32/Android, X86/FreeBSD, AMD64/FreeBSD, X86/Darwin and AMD64/Darwin (Mac OS X 10.12).

> [維基百科] [Valgrind](https://zh.wikipedia.org/zh-tw/Valgrind)
>
> **Valgrind**是一款用於記憶體除錯、[記憶體流失](https://zh.wikipedia.org/wiki/内存泄漏)檢測以及[效能分析](https://zh.wikipedia.org/wiki/性能分析)的[軟體開發工具](https://zh.wikipedia.org/wiki/软件开发工具)。Valgrind這個名字取自[北歐神話](https://zh.wikipedia.org/wiki/北欧神话)中[英靈殿](https://zh.wikipedia.org/wiki/英灵殿)的入口。

## 1.1. Install valgrind

```bash
$ sudo apt-get update
$ sudo apt-get -y install valgrind
$ valgrind --version
valgrind-3.15.0

```

# 2. [Which Kind Error](https://valgrind.org/docs/manual/faq.html#faq.deflost)

## 2.1. definitely lost

> your program is leaking memory -- fix those leaks!

> <font color="red">出現這問題，就一定要解決！</font>

## 2.2. indirectly lost

> your program is leaking memory in a pointer-based structure. (E.g. if the root node of a binary tree is "definitely lost", all the children will be "indirectly lost".) If you fix the "definitely lost" leaks, the "indirectly lost" leaks should go away.

> 發生在記憶體記摽宣告後又進行位移，這部分的錯誤，不見得一定要解決。

## 2.3. possibly lost

> your program is leaking memory, unless you're doing unusual things with pointers that could cause them to point into the middle of an allocated block; see the user manual for some possible causes. Use `--show-possibly-lost=no` if you don't want to see these reports.

> <font color="red">出現這問題，就一定要解決！</font>

## 2.4. still reachable

> your program is probably ok -- it didn't free some memory it could have. This is quite common and often reasonable. Don't use `--show-reachable=yes` if you don't want to see these reports.

> 都是發生在程式結束時未釋放記憶體，有時發生在 share lib，所以不見得可以進行修改。
>
> <font color="red">但還是建議要先找到問題點，查看前後文分析。</font>

## 2.5. suppressed

> a leak error has been suppressed. There are some suppressions in the default suppression files. You can ignore suppressed errors.

# 3. How to Check

## 3.1. Exmaples

#### A. [demo_valgrind.c](https://github.com/lankahsu520/utilx9/blob/main/demo_valgrind.c)

```bash
$ valgrind \
 --tool=memcheck \
 --leak-check=full \
 --show-leak-kinds=all \
 --trace-children=yes \
 -s \
 ./demo_valgrind
```

##### A.1. log

```bash
==38351== Memcheck, a memory error detector
==38351== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==38351== Using Valgrind-3.15.0 and LibVEX; rerun with -h for copyright info
==38351== Command: ./demo_valgrind
==38351==
[38351/38351] definitely_lost_fn:52 - call SAFE_CALLOC ... (size: 128)
[38351/38351] indirectly_lost_fn:73 - call JSON_ARY_APPEND_OBJ_INDIRECTLY ... (size: 6)
[38351/38351] possibly_lost_fn:106 - call member_create ... (count: 2, size: 72)
[38351/38351] still_reachable_fn:118 - call SAFE_CALLOC ... (reachable, size: 512)
[38351/38351] main:244 - Bye-Bye !!!
==38351==
==38351== HEAP SUMMARY:
==38351==     in use at exit: 750 bytes in 5 blocks
==38351==   total heap usage: 1,310 allocs, 1,305 frees, 106,692 bytes allocated
==38351==
==38351== 6 bytes in 1 blocks are indirectly lost in loss record 1 of 5
==38351==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==38351==    by 0x48D0B14: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.11.1)
==38351==    by 0x48D345C: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.11.1)
==38351==    by 0x10942C: indirectly_lost_fn (demo_valgrind.c:74)
==38351==    by 0x10942C: app_loop (demo_valgrind.c:131)
==38351==    by 0x10942C: main (demo_valgrind.c:242)
==38351==
==38351== 38 (32 direct, 6 indirect) bytes in 1 blocks are definitely lost in loss record 2 of 5
==38351==    at 0x483B7F3: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==38351==    by 0x48D342E: ??? (in /usr/lib/x86_64-linux-gnu/libjansson.so.4.11.1)
==38351==    by 0x10942C: indirectly_lost_fn (demo_valgrind.c:74)
==38351==    by 0x10942C: app_loop (demo_valgrind.c:131)
==38351==    by 0x10942C: main (demo_valgrind.c:242)
==38351==
==38351== 72 bytes in 1 blocks are possibly lost in loss record 3 of 5
==38351==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==38351==    by 0x1094C2: member_create (demo_valgrind.c:99)
==38351==    by 0x1094C2: possibly_lost_fn (demo_valgrind.c:107)
==38351==    by 0x1094C2: app_loop (demo_valgrind.c:135)
==38351==    by 0x1094C2: main (demo_valgrind.c:242)
==38351==
==38351== 128 bytes in 1 blocks are definitely lost in loss record 4 of 5
==38351==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==38351==    by 0x1093CB: definitely_lost_fn (demo_valgrind.c:53)
==38351==    by 0x1093CB: app_loop (demo_valgrind.c:127)
==38351==    by 0x1093CB: main (demo_valgrind.c:242)
==38351==
==38351== 512 bytes in 1 blocks are still reachable in loss record 5 of 5
==38351==    at 0x483DD99: calloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==38351==    by 0x10954C: still_reachable_fn (demo_valgrind.c:119)
==38351==    by 0x10954C: app_loop (demo_valgrind.c:139)
==38351==    by 0x10954C: main (demo_valgrind.c:242)
==38351==
==38351== LEAK SUMMARY:
==38351==    definitely lost: 160 bytes in 2 blocks
==38351==    indirectly lost: 6 bytes in 1 blocks
==38351==      possibly lost: 72 bytes in 1 blocks
==38351==    still reachable: 512 bytes in 1 blocks
==38351==         suppressed: 0 bytes in 0 blocks
==38351==
==38351== ERROR SUMMARY: 3 errors from 3 contexts (suppressed: 0 from 0)

```

#### B. [uv_000.c](https://github.com/lankahsu520/utilx9/blob/main/uv_000.c)

```bash
$ valgrind \
 --tool=memcheck \
 --leak-check=full \
 --show-leak-kinds=all \
 --trace-children=yes \
 -s \
 ./uv_000
```

##### B.1. log

```bash
==44145== Memcheck, a memory error detector
==44145== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==44145== Using Valgrind-3.15.0 and LibVEX; rerun with -h for copyright info
==44145== Command: ./uv_000
==44145==
[44145/44145] timer_1sec_loop:37 - kick async every 1 second.
[44145/44145] async_loop:84 - __________ Enter __________
[44145/44145] async_loop:96 - (*data: 4)
[44145/44145] timer_1sec_loop:37 - kick async every 1 second.
[44145/44145] async_loop:84 - __________ Enter __________
[44145/44145] async_loop:96 - (*data: 3)
[44145/44145] timer_1sec_loop:37 - kick async every 1 second.
[44145/44145] async_loop:84 - __________ Enter __________
[44145/44145] async_loop:96 - (*data: 2)
[44145/44145] timer_1sec_loop:37 - kick async every 1 second.
[44145/44145] async_loop:84 - __________ Enter __________
[44145/44145] async_loop:96 - (*data: 1)
[44145/44145] timer_1sec_loop:37 - kick async every 1 second.
[44145/44145] async_loop:84 - __________ Enter __________
[44145/44145] main:247 - Bye-Bye !!!
==44145==
==44145== HEAP SUMMARY:
==44145==     in use at exit: 128 bytes in 1 blocks
==44145==   total heap usage: 1,302 allocs, 1,301 frees, 105,928 bytes allocated
==44145==
==44145== 128 bytes in 1 blocks are still reachable in loss record 1 of 1
==44145==    at 0x483B723: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==44145==    by 0x483E017: realloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
==44145==    by 0x49F8444: uv__io_start (in /usr/lib/x86_64-linux-gnu/libuv.so.1.0.0)
==44145==    by 0x4A017A8: uv_signal_init (in /usr/lib/x86_64-linux-gnu/libuv.so.1.0.0)
==44145==    by 0x49FE3D3: uv_loop_init (in /usr/lib/x86_64-linux-gnu/libuv.so.1.0.0)
==44145==    by 0x49F695B: uv_default_loop (in /usr/lib/x86_64-linux-gnu/libuv.so.1.0.0)
==44145==    by 0x1095BC: app_loop (uv_000.c:119)
==44145==    by 0x1095BC: main (uv_000.c:245)
==44145==
==44145== LEAK SUMMARY:
==44145==    definitely lost: 0 bytes in 0 blocks
==44145==    indirectly lost: 0 bytes in 0 blocks
==44145==      possibly lost: 0 bytes in 0 blocks
==44145==    still reachable: 128 bytes in 1 blocks
==44145==         suppressed: 0 bytes in 0 blocks
==44145==
==44145== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)

```

##### B.2. Solve

```c
static void app_loop(void)
{
  ...
	SAFE_UV_LOOP_RUN(uv_loop);
	//SAFE_UV_LOOP_CLOSE(uv_loop);
	SAFE_UV_LOOP_CLOSE_VALGRIND(uv_loop);
	...
}
```

## 3.2. Problems Collection

### 3.2.1. \*** stack smashing detected ***: terminated

```bash
$ valgrind --tool=exp-sgcheck ./uv_000
```

### 3.2.2. Glib memory leak

```bash
$ G_SLICE=all G_DEBUG=gc-friendly \
 valgrind \
 --tool=memcheck \
 --show-reachable=yes \
 --show-leak-kinds=definite \
 --suppressions=/usr/share/glib-2.0/valgrind/glib.supp \
 ./uv_000
```

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. valgrind Usage

```bash
$ valgrind --help
usage: valgrind [options] prog-and-args

  tool-selection option, with default in [ ]:
    --tool=<name>             use the Valgrind tool named <name> [memcheck]

  basic user options for all Valgrind tools, with defaults in [ ]:
    -h --help                 show this message
    --help-debug              show this message, plus debugging options
    --version                 show version
    -q --quiet                run silently; only print error msgs
    -v --verbose              be more verbose -- show misc extra info
    --trace-children=no|yes   Valgrind-ise child processes (follow execve)? [no]
    --trace-children-skip=patt1,patt2,...    specifies a list of executables
                              that --trace-children=yes should not trace into
    --trace-children-skip-by-arg=patt1,patt2,...   same as --trace-children-skip=
                              but check the argv[] entries for children, rather
                              than the exe name, to make a follow/no-follow decision
    --child-silent-after-fork=no|yes omit child output between fork & exec? [no]
    --vgdb=no|yes|full        activate gdbserver? [yes]
                              full is slower but provides precise watchpoint/step
    --vgdb-error=<number>     invoke gdbserver after <number> errors [999999999]
                              to get started quickly, use --vgdb-error=0
                              and follow the on-screen directions
    --vgdb-stop-at=event1,event2,... invoke gdbserver for given events [none]
         where event is one of:
           startup exit valgrindabexit all none
    --track-fds=no|yes        track open file descriptors? [no]
    --time-stamp=no|yes       add timestamps to log messages? [no]
    --log-fd=<number>         log messages to file descriptor [2=stderr]
    --log-file=<file>         log messages to <file>
    --log-socket=ipaddr:port  log messages to socket ipaddr:port

  user options for Valgrind tools that report errors:
    --xml=yes                 emit error output in XML (some tools only)
    --xml-fd=<number>         XML output to file descriptor
    --xml-file=<file>         XML output to <file>
    --xml-socket=ipaddr:port  XML output to socket ipaddr:port
    --xml-user-comment=STR    copy STR verbatim into XML output
    --demangle=no|yes         automatically demangle C++ names? [yes]
    --num-callers=<number>    show <number> callers in stack traces [12]
    --error-limit=no|yes      stop showing new errors if too many? [yes]
    --exit-on-first-error=no|yes exit code on the first error found? [no]
    --error-exitcode=<number> exit code to return if errors found [0=disable]
    --error-markers=<begin>,<end> add lines with begin/end markers before/after
                              each error output in plain text mode [none]
    --show-error-list=no|yes  show detected errors list and
                              suppression counts at exit [no]
    -s                        same as --show-error-list=yes
    --keep-debuginfo=no|yes   Keep symbols etc for unloaded code [no]
                              This allows saved stack traces (e.g. memory leaks)
                              to include file/line info for code that has been
                              dlclose'd (or similar)
    --show-below-main=no|yes  continue stack traces below main() [no]
    --default-suppressions=yes|no
                              load default suppressions [yes]
    --suppressions=<filename> suppress errors described in <filename>
    --gen-suppressions=no|yes|all    print suppressions for errors? [no]
    --input-fd=<number>       file descriptor for input [0=stdin]
    --dsymutil=no|yes         run dsymutil on Mac OS X when helpful? [yes]
    --max-stackframe=<number> assume stack switch for SP changes larger
                              than <number> bytes [2000000]
    --main-stacksize=<number> set size of main thread's stack (in bytes)
                              [min(max(current 'ulimit' value,1MB),16MB)]

  user options for Valgrind tools that replace malloc:
    --alignment=<number>      set minimum alignment of heap allocations [16]
    --redzone-size=<number>   set minimum size of redzones added before/after
                              heap blocks (in bytes). [16]
    --xtree-memory=none|allocs|full   profile heap memory in an xtree [none]
                              and produces a report at the end of the execution
                              none: no profiling, allocs: current allocated
                              size/blocks, full: profile current and cumulative
                              allocated size/blocks and freed size/blocks.
    --xtree-memory-file=<file>   xtree memory report file [xtmemory.kcg.%p]

  uncommon user options for all Valgrind tools:
    --fullpath-after=         (with nothing after the '=')
                              show full source paths in call stacks
    --fullpath-after=string   like --fullpath-after=, but only show the
                              part of the path after 'string'.  Allows removal
                              of path prefixes.  Use this flag multiple times
                              to specify a set of prefixes to remove.
    --extra-debuginfo-path=path    absolute path to search for additional
                              debug symbols, in addition to existing default
                              well known search paths.
    --debuginfo-server=ipaddr:port    also query this server
                              (valgrind-di-server) for debug symbols
    --allow-mismatched-debuginfo=no|yes  [no]
                              for the above two flags only, accept debuginfo
                              objects that don't "match" the main object
    --smc-check=none|stack|all|all-non-file [all-non-file]
                              checks for self-modifying code: none, only for
                              code found in stacks, for all code, or for all
                              code except that from file-backed mappings
    --read-inline-info=yes|no read debug info about inlined function calls
                              and use it to do better stack traces.
                              [yes] on Linux/Android/Solaris for the tools
                              Memcheck/Massif/Helgrind/DRD only.
                              [no] for all other tools and platforms.
    --read-var-info=yes|no    read debug info on stack and global variables
                              and use it to print better error messages in
                              tools that make use of it (Memcheck, Helgrind,
                              DRD) [no]
    --vgdb-poll=<number>      gdbserver poll max every <number> basic blocks [5000]
    --vgdb-shadow-registers=no|yes   let gdb see the shadow registers [no]
    --vgdb-prefix=<prefix>    prefix for vgdb FIFOs [/tmp/vgdb-pipe]
    --run-libc-freeres=no|yes free up glibc memory at exit on Linux? [yes]
    --run-cxx-freeres=no|yes  free up libstdc++ memory at exit on Linux
                              and Solaris? [yes]
    --sim-hints=hint1,hint2,...  activate unusual sim behaviours [none]
         where hint is one of:
           lax-ioctls lax-doors fuse-compatible enable-outer
           no-inner-prefix no-nptl-pthread-stackcache fallback-llsc none
    --fair-sched=no|yes|try   schedule threads fairly on multicore systems [no]
    --kernel-variant=variant1,variant2,...
         handle non-standard kernel variants [none]
         where variant is one of:
           bproc android-no-hw-tls
           android-gpu-sgx5xx android-gpu-adreno3xx none
    --merge-recursive-frames=<number>  merge frames between identical
           program counters in max <number> frames) [0]
    --num-transtab-sectors=<number> size of translated code cache [32]
           more sectors may increase performance, but use more memory.
    --avg-transtab-entry-size=<number> avg size in bytes of a translated
           basic block [0, meaning use tool provided default]
    --aspace-minaddr=0xPP     avoid mapping memory below 0xPP [guessed]
    --valgrind-stacksize=<number> size of valgrind (host) thread's stack
                               (in bytes) [1048576]
    --show-emwarns=no|yes     show warnings about emulation limits? [no]
    --require-text-symbol=:sonamepattern:symbolpattern    abort run if the
                              stated shared object doesn't have the stated
                              text symbol.  Patterns can contain ? and *.
    --soname-synonyms=syn1=pattern1,syn2=pattern2,... synonym soname
              specify patterns for function wrapping or replacement.
              To use a non-libc malloc library that is
                  in the main exe:  --soname-synonyms=somalloc=NONE
                  in libxyzzy.so:   --soname-synonyms=somalloc=libxyzzy.so
    --sigill-diagnostics=yes|no  warn about illegal instructions? [yes]
    --unw-stack-scan-thresh=<number>   Enable stack-scan unwind if fewer
                  than <number> good frames found  [0, meaning "disabled"]
                  NOTE: stack scanning is only available on arm-linux.
    --unw-stack-scan-frames=<number>   Max number of frames that can be
                  recovered by stack scanning [5]
    --resync-filter=no|yes|verbose [yes on MacOS, no on other OSes]
              attempt to avoid expensive address-space-resync operations
    --max-threads=<number>    maximum number of threads that valgrind can
                              handle [500]

  user options for Memcheck:
    --leak-check=no|summary|full     search for memory leaks at exit?  [summary]
    --leak-resolution=low|med|high   differentiation of leak stack traces [high]
    --show-leak-kinds=kind1,kind2,.. which leak kinds to show?
                                            [definite,possible]
    --errors-for-leak-kinds=kind1,kind2,..  which leak kinds are errors?
                                            [definite,possible]
        where kind is one of:
          definite indirect possible reachable all none
    --leak-check-heuristics=heur1,heur2,... which heuristics to use for
        improving leak search false positive [all]
        where heur is one of:
          stdstring length64 newarray multipleinheritance all none
    --show-reachable=yes             same as --show-leak-kinds=all
    --show-reachable=no --show-possibly-lost=yes
                                     same as --show-leak-kinds=definite,possible
    --show-reachable=no --show-possibly-lost=no
                                     same as --show-leak-kinds=definite
    --xtree-leak=no|yes              output leak result in xtree format? [no]
    --xtree-leak-file=<file>         xtree leak report file [xtleak.kcg.%p]
    --undef-value-errors=no|yes      check for undefined value errors [yes]
    --track-origins=no|yes           show origins of undefined values? [no]
    --partial-loads-ok=no|yes        too hard to explain here; see manual [yes]
    --expensive-definedness-checks=no|auto|yes
                                     Use extra-precise definedness tracking [auto]
    --freelist-vol=<number>          volume of freed blocks queue     [20000000]
    --freelist-big-blocks=<number>   releases first blocks with size>= [1000000]
    --workaround-gcc296-bugs=no|yes  self explanatory [no].  Deprecated.
                                     Use --ignore-range-below-sp instead.
    --ignore-ranges=0xPP-0xQQ[,0xRR-0xSS]   assume given addresses are OK
    --ignore-range-below-sp=<number>-<number>  do not report errors for
                                     accesses at the given offsets below SP
    --malloc-fill=<hexnumber>        fill malloc'd areas with given value
    --free-fill=<hexnumber>          fill free'd areas with given value
    --keep-stacktraces=alloc|free|alloc-and-free|alloc-then-free|none
        stack trace(s) to keep for malloc'd/free'd areas       [alloc-and-free]
    --show-mismatched-frees=no|yes   show frees that don't match the allocator? [yes]

  Extra options read from ~/.valgrindrc, $VALGRIND_OPTS, ./.valgrindrc

  Memcheck is Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
  Valgrind is Copyright (C) 2000-2017, and GNU GPL'd, by Julian Seward et al.
  LibVEX is Copyright (C) 2004-2017, and GNU GPL'd, by OpenWorks LLP et al.

  Bug reports, feedback, admiration, abuse, etc, to: www.valgrind.org.

```

# Author

> Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

