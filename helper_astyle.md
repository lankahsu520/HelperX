# [astyle](https://astyle.sourceforge.net)
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

> Artistic Style is a source code indenter, formatter, and beautifier for the C, C++, C++/CLI, Objective‑C, C# and Java programming languages. Written in C++, it can be used from the command line or incorporated as a library in another program. Options can be entered from the command line or from an option file. The library version can be called from programs written in languages other that C++.

## 1.1. Install astyle

```bash
$ sudo apt-get update
$ sudo apt-get --yes astyle
$ astyle --version
Artistic Style Version 3.1

```

# 2. Simple

```bash
$ astyle demo_123.c
Formatted  /work/codebase/lankahsu520/utilx9/demo_123.c

$ astyle --style=gnu --indent=tab demo_123.c
```

## 2.1. style=Lanka

```bash
$ astyle --style=gnu --indent=tab -jU demo_123.c; \
	astyle --indent=tab -jU -S demo_123.c
Formatted  /work/codebase/lankahsu520/utilx9/demo_123.c
Formatted  /work/codebase/lankahsu520/utilx9/demo_123.c

$ astyle-ex demo_123.c
Formatted  /work/codebase/lankahsu520/utilx9/demo_123.c
Formatted  /work/codebase/lankahsu520/utilx9/demo_123.c
```

# 3. General Commands

#### -  Brace Style Options
```bash
# --style=gnu  OR  -A7
# GNU style formatting/indenting.
# Broken braces, indented blocks.
$ astyle --style=gnu demo_123.c

# --style=linux  OR  --style=knf  OR  -A8
# Linux style formatting/indenting.
# Linux braces, minimum conditional indent is one-half indent.
$ astyle --style=linux demo_123.c

# --style=google  OR  -A14
# Google style formatting/indenting.
# Attached braces, indented class modifiers.
$ astyle --style=google demo_123.c
```

#### - Formatting Options
```bash
# --add-braces  OR  -j
# Add braces to unbraced one line conditional statements.
# 添加大托號
$ astyle -j demo_123.c
```

#### - Indentation Options
```bash
# --indent-switches  OR  -S
# Indent 'switch' blocks, so that the inner 'case XXX:'
# headers are indented in relation to the switch block.
$ astyle -S demo_123.c

# --indent-cases  OR  -K
# Indent case blocks from the 'case XXX:' headers.
# Case statements not enclosed in blocks are NOT indented.
$ astyle -K demo_123.c
```

#### - Padding Options

```bash
# Insert space padding around parenthesis on the inside only
# --pad-paren-in  OR  -D
$ astyle -D demo_123.c

# Remove unnecessary space padding around parenthesis.
# --unpad-paren  OR  -U
$ astyle -U demo_123.c
```

#### - Tab Options

```bash
# --indent=tab  OR  --indent=tab=#  OR  -t  OR  -t#
# Indent using tab characters, assuming that each
# indent is # spaces long. Not specifying # will result
# in a default assumption of 4 spaces per indent.
$ astyle --indent=tab demo_123.c

# --indent=force-tab-x=#  OR  -xT#
# Allows the tab length to be set to a length that is different
# from the indent length. This may cause the indentation to be
# a mix of both spaces and tabs. This option sets the tab length.
# 2 spaces -> 1 tab
$ astyle --indent=force-tab-x=2 demo_123.c

# --indent=spaces=#  OR  -s#
# Indent using # spaces per indent. Not specifying #
# will result in a default of 4 spaces per indent.
# 4 spaces per indent
$ astyle --indent=spaces=4 demo_123.c
```

# Appendix

# I. Study

## I.1. [astyle 使用教學](https://hackmd.io/@paul90317/astyle)

## I.2. [Astyle中文格式说明 （for C/C++/JAVA等Format）](https://blog.csdn.net/xsophiax/article/details/100574565)

# II. Debug

# III. Glossary

# IV. Tool Usage

## IV.1. [astyle](https://manpages.ubuntu.com/manpages/trusty/man1/astyle.1.html) Usage

```bash
$ astyle --help

                     Artistic Style 3.1
                     Maintained by: Jim Pattee
                     Original Author: Tal Davidson

Usage:
------
            astyle [OPTIONS] File1 File2 File3 [...]

            astyle [OPTIONS] < Original > Beautified

    When indenting a specific file, the resulting indented file RETAINS
    the original file-name. The original pre-indented file is renamed,
    with a suffix of '.orig' added to the original filename.

    Wildcards (* and ?) may be used in the filename.
    A 'recursive' option can process directories recursively.
    Multiple file extensions may be separated by a comma.

    By default, astyle is set up to indent with four spaces per indent,
    a maximal indentation of 40 spaces inside continuous statements,
    a minimum indentation of eight spaces inside conditional statements,
    and NO formatting options.

Options:
--------
    This  program  follows  the  usual  GNU  command line syntax.
    Long options (starting with '--') must be written one at a time.
    Short options (starting with '-') may be appended together.
    Thus, -bps4 is the same as -b -p -s4.

Option Files:
-------------
    Artistic Style looks for a default option file and/or a project
    option file in the following order:
    1. The command line options have precedence.
    2. The project option file has precedence over the default file
       o the file name indicated by the --project= command line option.
       o the file named .astylerc or _ astylerc.
       o the file name identified by ARTISTIC_STYLE_PROJECT_OPTIONS.
       o the file is disabled by --project=none on the command line.
    3. The default option file that can be used for all projects.
       o the file path indicated by the --options= command line option.
       o the file path indicated by ARTISTIC_STYLE_OPTIONS.
       o the file named .astylerc in the HOME directory (for Linux).
       o the file name astylerc in the APPDATA directory (for Windows).
       o the file is disabled by --project=none on the command line.
    Long options within the option files may be written without '--'.
    Line-end comments begin with a '#'.

Disable Formatting:
-------------------
    Disable Block
    Blocks of code can be disabled with the comment tags *INDENT-OFF*
    and *INDENT-ON*. It must be contained in a one-line comment.

    Disable Line
    Padding of operators can be disabled on a single line using the
    comment tag *NOPAD*. It must be contained in a line-end comment.

Brace Style Options:
--------------------
    default brace style
    If no brace style is requested, the opening braces will not be
    changed and closing braces will be broken from the preceding line.

    --style=allman  OR  --style=bsd  OR  --style=break  OR  -A1
    Allman style formatting/indenting.
    Broken braces.

    --style=java  OR  --style=attach  OR  -A2
    Java style formatting/indenting.
    Attached braces.

    --style=kr  OR  --style=k&r  OR  --style=k/r  OR  -A3
    Kernighan & Ritchie style formatting/indenting.
    Linux braces.

    --style=stroustrup  OR  -A4
    Stroustrup style formatting/indenting.
    Linux braces.

    --style=whitesmith  OR  -A5
    Whitesmith style formatting/indenting.
    Broken, indented braces.
    Indented class blocks and switch blocks.

    --style=vtk  OR  -A15
    VTK style formatting/indenting.
    Broken, indented braces except for the opening braces.

    --style=ratliff  OR  --style=banner  OR  -A6
    Ratliff style formatting/indenting.
    Attached, indented braces.

    --style=gnu  OR  -A7
    GNU style formatting/indenting.
    Broken braces, indented blocks.

    --style=linux  OR  --style=knf  OR  -A8
    Linux style formatting/indenting.
    Linux braces, minimum conditional indent is one-half indent.

    --style=horstmann  OR  --style=run-in  OR  -A9
    Horstmann style formatting/indenting.
    Run-in braces, indented switches.

    --style=1tbs  OR  --style=otbs  OR  -A10
    One True Brace Style formatting/indenting.
    Linux braces, add braces to all conditionals.

    --style=google  OR  -A14
    Google style formatting/indenting.
    Attached braces, indented class modifiers.

    --style=mozilla  OR  -A16
    Mozilla style formatting/indenting.
    Linux braces, with broken braces for structs and enums,
    and attached braces for namespaces.

    --style=pico  OR  -A11
    Pico style formatting/indenting.
    Run-in opening braces and attached closing braces.
    Uses keep one line blocks and keep one line statements.

    --style=lisp  OR  -A12
    Lisp style formatting/indenting.
    Attached opening braces and attached closing braces.
    Uses keep one line statements.

Tab Options:
------------
    default indent option
    If no indentation option is set, the default
    option of 4 spaces per indent will be used.

    --indent=spaces=#  OR  -s#
    Indent using # spaces per indent. Not specifying #
    will result in a default of 4 spaces per indent.

    --indent=tab  OR  --indent=tab=#  OR  -t  OR  -t#
    Indent using tab characters, assuming that each
    indent is # spaces long. Not specifying # will result
    in a default assumption of 4 spaces per indent.

    --indent=force-tab=#  OR  -T#
    Indent using tab characters, assuming that each
    indent is # spaces long. Force tabs to be used in areas
    AStyle would prefer to use spaces.

    --indent=force-tab-x=#  OR  -xT#
    Allows the tab length to be set to a length that is different
    from the indent length. This may cause the indentation to be
    a mix of both spaces and tabs. This option sets the tab length.

Brace Modify Options:
---------------------
    --attach-namespaces  OR  -xn
    Attach braces to a namespace statement.

    --attach-classes  OR  -xc
    Attach braces to a class statement.

    --attach-inlines  OR  -xl
    Attach braces to class inline function definitions.

    --attach-extern-c  OR  -xk
    Attach braces to an extern "C" statement.

    --attach-closing-while  OR  -xV
    Attach closing while of do-while to the closing brace.

Indentation Options:
--------------------
    --indent-classes  OR  -C
    Indent 'class' blocks so that the entire block is indented.

    --indent-modifiers  OR  -xG
    Indent 'class' access modifiers, 'public:', 'protected:' or
    'private:', one half indent. The rest of the class is not
    indented.

    --indent-switches  OR  -S
    Indent 'switch' blocks, so that the inner 'case XXX:'
    headers are indented in relation to the switch block.

    --indent-cases  OR  -K
    Indent case blocks from the 'case XXX:' headers.
    Case statements not enclosed in blocks are NOT indented.

    --indent-namespaces  OR  -N
    Indent the contents of namespace blocks.

    --indent-after-parens  OR  -xU
    Indent, instead of align, continuation lines following lines
    that contain an opening paren '(' or an assignment '='.

    --indent-continuation=#  OR  -xt#
    Indent continuation lines an additional # indents.
    The valid values are 0 thru 4 indents.
    The default value is 1 indent.

    --indent-labels  OR  -L
    Indent labels so that they appear one indent less than
    the current indentation level, rather than being
    flushed completely to the left (which is the default).

    --indent-preproc-block  OR  -xW
    Indent preprocessor blocks at brace level 0.
    Without this option the preprocessor block is not indented.

    --indent-preproc-cond  OR  -xw
    Indent preprocessor conditional statements #if/#else/#endif
    to the same level as the source code.

    --indent-preproc-define  OR  -w
    Indent multi-line preprocessor #define statements.

    --indent-col1-comments  OR  -Y
    Indent line comments that start in column one.

    --min-conditional-indent=#  OR  -m#
    Indent a minimal # spaces in a continuous conditional
    belonging to a conditional header.
    The valid values are:
    0 - no minimal indent.
    1 - indent at least one additional indent.
    2 - indent at least two additional indents.
    3 - indent at least one-half an additional indent.
    The default value is 2, two additional indents.

    --max-continuation-indent=#  OR  -M#
    Indent a maximal # spaces in a continuation line,
    relative to the previous line.
    The valid values are 40 thru 120.
    The default value is 40.

Padding Options:
----------------
    --break-blocks  OR  -f
    Insert empty lines around unrelated blocks, labels, classes, ...

    --break-blocks=all  OR  -F
    Like --break-blocks, except also insert empty lines
    around closing headers (e.g. 'else', 'catch', ...).

    --pad-oper  OR  -p
    Insert space padding around operators.

    --pad-comma  OR  -xg
    Insert space padding after commas.

    --pad-paren  OR  -P
    Insert space padding around parenthesis on both the outside
    and the inside.

    --pad-paren-out  OR  -d
    Insert space padding around parenthesis on the outside only.

    --pad-first-paren-out  OR  -xd
    Insert space padding around first parenthesis in a series on
    the outside only.

    --pad-paren-in  OR  -D
    Insert space padding around parenthesis on the inside only.

    --pad-header  OR  -H
    Insert space padding after paren headers (e.g. 'if', 'for'...).

    --unpad-paren  OR  -U
    Remove unnecessary space padding around parenthesis. This
    can be used in combination with the 'pad' options above.

    --delete-empty-lines  OR  -xd
    Delete empty lines within a function or method.
    It will NOT delete lines added by the break-blocks options.

    --fill-empty-lines  OR  -E
    Fill empty lines with the white space of their
    previous lines.

    --align-pointer=type    OR  -k1
    --align-pointer=middle  OR  -k2
    --align-pointer=name    OR  -k3
    Attach a pointer or reference operator (*, &, or ^) to either
    the operator type (left), middle, or operator name (right).
    To align the reference separately use --align-reference.

    --align-reference=none    OR  -W0
    --align-reference=type    OR  -W1
    --align-reference=middle  OR  -W2
    --align-reference=name    OR  -W3
    Attach a reference operator (&) to either
    the operator type (left), middle, or operator name (right).
    If not set, follow pointer alignment.

Formatting Options:
-------------------
    --break-closing-braces  OR  -y
    Break braces before closing headers (e.g. 'else', 'catch', ...).
    Use with --style=java, --style=kr, --style=stroustrup,
    --style=linux, or --style=1tbs.

    --break-elseifs  OR  -e
    Break 'else if()' statements into two different lines.

    --break-one-line-headers  OR  -xb
    Break one line headers (e.g. 'if', 'while', 'else', ...) from a
    statement residing on the same line.

    --add-braces  OR  -j
    Add braces to unbraced one line conditional statements.

    --add-one-line-braces  OR  -J
    Add one line braces to unbraced one line conditional
    statements.

    --remove-braces  OR  -xj
    Remove braces from a braced one line conditional statements.

    --break-return-type       OR  -xB
    --break-return-type-decl  OR  -xD
    Break the return type from the function name. Options are
    for the function definitions and the function declarations.

    --attach-return-type       OR  -xf
    --attach-return-type-decl  OR  -xh
    Attach the return type to the function name. Options are
    for the function definitions and the function declarations.

    --keep-one-line-blocks  OR  -O
    Don't break blocks residing completely on one line.

    --keep-one-line-statements  OR  -o
    Don't break lines containing multiple statements into
    multiple single-statement lines.

    --convert-tabs  OR  -c
    Convert tabs to the appropriate number of spaces.

    --close-templates  OR  -xy
    Close ending angle brackets on template definitions.

    --remove-comment-prefix  OR  -xp
    Remove the leading '*' prefix on multi-line comments and
    indent the comment text one indent.

    --max-code-length=#    OR  -xC#
    --break-after-logical  OR  -xL
    max-code-length=# will break the line if it exceeds more than
    # characters. The valid values are 50 thru 200.
    If the line contains logical conditionals they will be placed
    first on the new line. The option break-after-logical will
    cause the logical conditional to be placed last on the
    previous line.

    --mode=c
    Indent a C or C++ source file (this is the default).

    --mode=java
    Indent a Java source file.

    --mode=cs
    Indent a C# source file.

Objective-C Options:
--------------------
    --pad-method-prefix  OR  -xQ
    Insert space padding after the '-' or '+' Objective-C
    method prefix.

    --unpad-method-prefix  OR  -xR
    Remove all space padding after the '-' or '+' Objective-C
    method prefix.

    --pad-return-type  OR  -xq
    Insert space padding after the Objective-C return type.

    --unpad-return-type  OR  -xr
    Remove all space padding after the Objective-C return type.

    --pad-param-type  OR  -xS
    Insert space padding after the Objective-C return type.

    --unpad-param-type  OR  -xs
    Remove all space padding after the Objective-C return type.

    --align-method-colon  OR  -xM
    Align the colons in an Objective-C method definition.

    --pad-method-colon=none    OR  -xP
    --pad-method-colon=all     OR  -xP1
    --pad-method-colon=after   OR  -xP2
    --pad-method-colon=before  OR  -xP3
    Add or remove space padding before or after the colons in an
    Objective-C method call.

Other Options:
--------------
    --suffix=####
    Append the suffix #### instead of '.orig' to original filename.

    --suffix=none  OR  -n
    Do not retain a backup of the original file.

    --recursive  OR  -r  OR  -R
    Process subdirectories recursively.

    --dry-run
    Perform a trial run with no changes made to check for formatting.

    --exclude=####
    Specify a file or directory #### to be excluded from processing.

    --ignore-exclude-errors  OR  -i
    Allow processing to continue if there are errors in the exclude=####
    options. It will display the unmatched excludes.

    --ignore-exclude-errors-x  OR  -xi
    Allow processing to continue if there are errors in the exclude=####
    options. It will NOT display the unmatched excludes.

    --errors-to-stdout  OR  -X
    Print errors and help information to standard-output rather than
    to standard-error.

    --preserve-date  OR  -Z
    Preserve the original file's date and time modified. The time
     modified will be changed a few micro seconds to force a compile.

    --verbose  OR  -v
    Verbose mode. Extra informational messages will be displayed.

    --formatted  OR  -Q
    Formatted display mode. Display only the files that have been
    formatted.

    --quiet  OR  -q
    Quiet mode. Suppress all output except error messages.

    --lineend=windows  OR  -z1
    --lineend=linux    OR  -z2
    --lineend=macold   OR  -z3
    Force use of the specified line end style. Valid options
    are windows (CRLF), linux (LF), and macold (CR).

Command Line Only:
------------------
    --options=####
    --options=none
    Specify a default option file #### to read and use.
    It must contain a file path and a file name.
    'none' disables the default option file.

    --project
    --project=####
    --project=none
    Specify a project option file #### to read and use.
    It must contain a file name only, without a directory path.
    The file should be included in the project top-level directory.
    The default file name is .astylerc or _astylerc.
    'none' disables the project or environment variable file.

    --ascii  OR  -I
    The displayed output will be ascii characters only.

    --version  OR  -V
    Print version number.

    --help  OR  -h  OR  -?
    Print this help message.

    --html  OR  -!
    Open the HTML help file "astyle.html" in the default browser.
    The documentation must be installed in the standard install path.

    --html=####
    Open a HTML help file in the default browser using the file path
    ####. The path may include a directory path and a file name, or a
    file name only. Paths containing spaces must be enclosed in quotes.

    --stdin=####
    Use the file path #### as input to single file formatting.
    This is a replacement for redirection.

    --stdout=####
    Use the file path #### as output from single file formatting.
    This is a replacement for redirection.
```

## IV.2. bash

#### A. ~/.bash_aliases

```bash
#******************************************************************************
#** astyle **
#******************************************************************************
function astyle-ex()
{
	HINT="Usage: ${FUNCNAME[0]} <files>"
	FILES="$*"

	if [ ! -z "$FILES" ]; then
		for FILE in ${FILES}; do
		(
			astyle --style=gnu --indent=tab -jU ${FILE}
			astyle --indent=tab -jU -S ${FILE}
		)
		done
	else
		echo $HINT
	fi
}
```

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

