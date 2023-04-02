# MarkDown
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

# 1. 段落

## 1.1. 標題

# Header 1

## Header 2

### Header 3

#### Header 4

##### Header 5

## 1.2. 清單

### 1.2.1. 無序清單

-   Red
-   Green
-   Blue

```
-   Red
-   Green
-   Blue
```

### 1.2.2. 有序清單

1. Red
2. Green
3. Blue

```
1. Red
2. Green
3. Blue
```
### 1.2.3. 工作清單
- [x] Task A
- [ ] Task B
- [ ] Task C
```
- [x] Task A
- [ ] Task B
- [ ] Task C
```

## 1.3. 引言

> 這是引言

```
> 這是引言

```

## 1.4. 程式碼區塊

```
程式碼區塊
```

````
```
程式碼區塊
```
````

## 1.5. 分格線
***
---

```
***
---
```

## 1.6. 註腳

> 這邊示範註腳[^註腳1]

[^註腳1]:請寫下註腳的描述
```
[^註腳1]

[^註腳1]:請寫下註腳的描述
```

## 1.7. 參考連結

> 參考連結 [google][1]

[1]: http://www.google.com	"Google"

```
[google][1]

[1]: http://www.google.com	"Google"

```
# 2. 表格

| ID         | NAME      | Desc |
| ---------- | --------- | ---- |
| A123456789 | Lanka Hsu | Boss |
| A888888888 | Mary      | Wife |
|            |           |      |

# 3. 格式

> **粗體**
```
**粗體**
```

> *斜體*
```
*斜體*
```

> <u>底線</u>

```
<u>底線</u>
```

> `程式碼`

```
`程式碼`
```

> ~~刪除線~~

```
~~刪除線~~
```

> <!--註解-->

```
<!--註解-->
```

> 超連結
>
> [HelperX](https://github.com/lankahsu520/HelperX)

```
[HelperX](https://github.com/lankahsu520/HelperX)
```
> 圖片
> ![macOS_12_Monterey](./images/macOS_12_Monterey.png)
```
![macOS_12_Monterey](./images/macOS_12_Monterey.png)
```

# 4. [特殊特元](https://chukaml.tripod.com/linguistics/charCode/)

> AT&amp;T
>

```
AT&amp;T
```

> 4 &lt; 5

```
4 &lt; 5
```

>&copy;
```
&copy;
```

# 5. [Mermaid](https://mermaid.js.org/)

## 5.1. [Gantt diagrams](https://mermaid.js.org/syntax/gantt.html)

> 以下內容取自於 https://mermaid.js.org/syntax/gantt.html

#### A. A Gantt Diagram

```mermaid
gantt
	title A Gantt Diagram (2023-03-29)

	%%dateFormat HH:mm
	%%axisFormat %H:%M
	%%tickInterval 1h
	dateFormat  YYYY-MM-DD
	axisFormat %-m/%-d
	tickInterval 1day

	%% (`excludes` accepts specific dates in YYYY-MM-DD format, days of the week ("sunday") or "weekends", but not the word "weekdays".)
	excludes weekends saturday,sunday, 2023-02-27, 2023-02-28
	excludes weekends saturday,sunday, 2023-04-03, 2023-04-04, 2023-04-05
	excludes weekends saturday,sunday, 2023-05-01

	section SPEC
		read spec1 (crit/done): crit, done, spec1, 2023-03-29, 2023-03-31
		read spec2 (crit/active): crit, active, spec2, after spec1, 2d
		read spec3 (crit/): crit, spec3, after spec2, 1d
		report (milestone): milestone, active, SPEC-end, after spec3, 1d
	section TODO
		Todo A (/done): done, todo1, after SPEC-end, 3d
		Todo B (/active): active, todo2, after SPEC-end, 2d
		Todo C (/): todo3, after todo1 todo2, 48h
		Todo B (/): todo4, after todo3, 96h

```

#### B. Input date format[#](https://mermaid.js.org/syntax/gantt.html#input-date-format)

The default input date format is `YYYY-MM-DD`. You can define your custom `dateFormat`.

```
dateFormat YYYY-MM-DD
```

The following formatting options are supported:

```
Input       Example             Description:
YYYY        2014                4 digit year
YY          14                  2 digit year
Q           1..4                Quarter of year. Sets month to first month in quarter.
M MM        1..12               Month number
MMM MMMM    January..Dec        Month name in locale set by moment.locale()
D DD        1..31               Day of month
Do          1st..31st           Day of month with ordinal
DDD DDDD    1..365              Day of year
X           1410715640.579      Unix timestamp
x           1410715640579       Unix ms timestamp
H HH        0..23               24 hour time
h hh        1..12               12 hour time used with a A.
a A         am pm               Post or ante meridiem
m mm        0..59               Minutes
s ss        0..59               Seconds
S           0..9                Tenths of a second
SS          0..99               Hundreds of a second
SSS         0..999              Thousandths of a second
Z ZZ        +12:00              Offset from UTC as +-HH:mm, +-HHmm, or Z
```

More info in: https://momentjs.com/docs/#/parsing/string-format/

#### C. Output date format on the axis[#](https://mermaid.js.org/syntax/gantt.html#output-date-format-on-the-axis)

The default output date format is `YYYY-MM-DD`. You can define your custom `axisFormat`, like `2020-Q1` for the first quarter of the year 2020.

```
axisFormat  %Y-%m-%d
```

The following formatting strings are supported:

```
%a - abbreviated weekday name.
%A - full weekday name.
%b - abbreviated month name.
%B - full month name.
%c - date and time, as "%a %b %e %H:%M:%S %Y".
%d - zero-padded day of the month as a decimal number [01,31].
%e - space-padded day of the month as a decimal number [ 1,31]; equivalent to %_d.
%H - hour (24-hour clock) as a decimal number [00,23].
%I - hour (12-hour clock) as a decimal number [01,12].
%j - day of the year as a decimal number [001,366].
%m - month as a decimal number [01,12].
%M - minute as a decimal number [00,59].
%L - milliseconds as a decimal number [000, 999].
%p - either AM or PM.
%S - second as a decimal number [00,61].
%U - week number of the year (Sunday as the first day of the week) as a decimal number [00,53].
%w - weekday as a decimal number [0(Sunday),6].
%W - week number of the year (Monday as the first day of the week) as a decimal number [00,53].
%x - date, as "%m/%d/%Y".
%X - time, as "%H:%M:%S".
%y - year without century as a decimal number [00,99].
%Y - year with century as a decimal number.
%Z - time zone offset, such as "-0700".
%% - a literal "%" character.
```

More info in: https://github.com/d3/d3-time-format/tree/v4.0.0#locale_format

#### D. Axis ticks[#](https://mermaid.js.org/syntax/gantt.html#axis-ticks)

The default output ticks are auto. You can custom your `tickInterval`, like `1day` or `1week`.

```
tickInterval 1day
```

The pattern is:

```
/^([1-9][0-9]*)(minute|hour|day|week|month)$/
```

More info in: https://github.com/d3/d3-time#interval_every

## 5.2. Flowchart

### 5.2.1. Sample

```mermaid
flowchart TD

%% TB - top to bottom
%% this is a comment; Start --> Process --> End
	Start([起始點])
	register{{註冊 signal}}
	input[/輸入名稱/]
	isboss{Is it the boss ?}
	Process[程序]
	Manual[\建立工作報告/]
	Subroutine[[子程序]]
	Database[(SQL)]
	print[/print Hello Boss !!/]

	AlternateProcess(替代流程 Plan B)
	End([結束點]) 

	Start-->|流程線|register-->input-->isboss-->|yes|print--> End
	
	isboss-->|no|Process-->Subroutine-->Manual--> End
	Subroutine-->Database
	input..-> AlternateProcess --> End

```

### 5.2.2. [Flowchart Symbols Defined](https://www.breezetree.com/articles/excel-flowchart-shapes/)

> 以下引言取自於 https://www.breezetree.com/articles/excel-flowchart-shapes/

#### A. Process / Operation Symbols

##### A.1. Process

> Show a Process or action step. This is the most common symbol in both process flowcharts and process maps.

```mermaid
flowchart TD
	Process[程序]
```
```
Process[程序]
```

##### A.2. Subroutine

> A Predefined Process symbol is a marker for another process step or series of process flow steps that are formally defined elsewhere. This shape commonly depicts sub-processes (or subroutines in programming flowcharts). If the sub-process is considered "known" but not actually defined in a process procedure, work instruction, or some other process flowchart or documentation, then it is best not to use this symbol since it implies a formally defined process.

```mermaid
flowchart TD
	Subroutine[[子程序]]
```
```
Subroutine[[子程序]]
```
##### A.3. Alternate Process

> As the shape name suggests, this flowchart symbol is used when the process flow step is an alternate to the normal process step. Flow lines into an alternate process flow step are typically dashed.

```mermaid
flowchart TD
	AlternateProcess(替代流程 Plan B)
```

```
AlternateProcess(替代流程 Plan B)
```

##### A.4. Delay

> The Delay flowchart symbol depicts any waiting period that is part of a process. Delay shapes are common in process mapping.

##### A.5. Preparation

> As the names states, any process step that is a Preparation process flow step, such as a set-up operation.
>
> 前置作業，一般多為安裝、設定

```mermaid
flowchart TD
	register{{註冊 signal}}
```

```
register{{註冊 signal}}
```

##### A.6. Manual Operation

> Manual Operations flowchart shapes show which process steps are not automated. In data processing flowcharts, this data flow shape indicates a looping operation along with a loop limit symbol (which is not supported by Microsoft Office, but a Manual Operation symbol rotated 180° will do the trick.)
>
> 非自動化，需人工參與

```mermaid
flowchart TD
	 Manual[\建立工作報告/]
```

```
Manual[\建立工作報告/]
```

#### B. Branching and Control of Flow Symbols

##### B.1. Flow Line (Arrow, Connector)

> Flow line connectors show the direction that the process flows.

```mermaid
flowchart LR
	 A-->B
```

```
A-->B
```

##### B.2. Terminator (Terminal Point, Oval)

> Terminators show the start and stop points in a process. When used as a Start symbol, terminators depict a *trigger action* that sets the process flow into motion.

```mermaid
flowchart TD
	Start([起始點])
	End([結束點]) 
```

```
Start([起始點])
End([結束點]) 

```

##### B.3. Decision

>Indicates a question or branch in the process flow. Typically, a Decision flowchart shape is used when there are 2 options (Yes/No, No/No-Go, etc.)

```mermaid
flowchart TD
	isboss{Is it the boss ?}
```

```
isboss{Is it the boss ?} 
```

##### B.4. Connector (Inspection)

>**Flowchart**: In flowcharts, this symbol is typically small and is used as a Connector to show a jump from one point in the process flow to another. Connectors are usually labeled with capital letters (A, B, AA) to show matching jump points. They are handy for avoiding flow lines that cross other shapes and flow lines. They are also handy for jumping to and from a sub-processes defined in a separate area than the main flowchart.
>**Process Mapping**: In process maps, this symbol is full sized and shows an Inspection point in the process flow.
>
>*[Just to confuse things further, some people will use a circle to indicate an operation and a square to indicate an inspection. That's why it's important to include a symbol key in the flowchart.]*

```mermaid
flowchart TD
	Connector((Connector))
```

```
# 這個跟預期的完全不同，暫不要使用
Connector((Connector))

```

#### C. Flow Line (Arrow, Connector)

> Flow line connectors show the direction that the process flows.

##### C.1. Simple

```mermaid
flowchart LR
	A-->|arrow head|B
	C---|open link|D
	E-.->|Dotted link|F
	G ==>|Thick link|H

  I --o J
	K --x L
```

```
A-->|arrow head|B
C---|open link|D
E-.->|Dotted link|F
G==>|Thick link|H
I~~~J
I --o J
K --x L
```

##### C.2. Multi directional arrows

```mermaid
flowchart LR
	A o--o B
	B <--> C
	C x--x D

```

```
A o--o B
B <--> C
C x--x D
```

##### C.3. Chaining of links

```mermaid
flowchart LR
	A -- text --> B -- text2 --> C
	a --> b & c--> d
	
```

```
A -- text --> B -- text2 --> C

a --> b & c--> d

```

```mermaid
flowchart LR
	X & Y--> Z & W

	A --> C
	A --> D
	B --> C
	B --> D
```

```
X & Y--> Z & W

A --> C
A --> D
B --> C
B --> D
```

#### D. Subgraphs

```mermaid
flowchart LR
	subgraph aws
		ec2
		DynamoDB
	end

	subgraph pc
		ssh
	end
	
	pc ---> |network|aws
	ssh --> ec2 --> |aws cli|DynamoDB
```

```
flowchart LR
	subgraph aws
		ec2
		DynamoDB
	end

	subgraph pc
		ssh
	end
	
	pc ---> |network|aws
	ssh --> ec2 --> |aws cli|DynamoDB
```

#### E. Others

```mermaid
flowchart TD
	asymmetric>an asymmetric shape]
	
	ParallelogramAlt[\Parallelogram alt\]
	
	Trapezoid[/Trapezoid\]
	
	Dcircle(((Double circle)))
```

```
asymmetric>an asymmetric shape]

ParallelogramAlt[\Parallelogram alt\]

Trapezoid[/Trapezoid\]

Dcircle(((Double circle)))
```

#### X. [Interaction](https://mermaid.js.org/syntax/flowchart.html#interaction)

> 這一部分，基本上不常用，也不應該用！
>
> Flowchart 原本就是要表達某些順序、意圖等，不是要給大家來亙動的。



```mermaid
flowchart LR
	A-->B
	B-->C
	C-->D
	click A callback "Tooltip for a callback"
	click B "https://www.github.com" "This is a tooltip for a link"
	click C call callback() "Tooltip for a callback"
	click D href "https://www.github.com" "This is a tooltip for a link"
```

```
flowchart LR
    A-->B
    B-->C
    C-->D
    click A callback "Tooltip for a callback"
    click B "https://www.github.com" "This is a tooltip for a link"
    click C call callback() "Tooltip for a callback"
    click D href "https://www.github.com" "This is a tooltip for a link"
```
```mermaid
flowchart LR
    A-->B
    B-->C
    C-->D
    D-->E
    click A "https://www.github.com" _blank
    click B "https://www.github.com" "Open this in a new tab" _blank
    click C href "https://www.github.com" _blank
    click D href "https://www.github.com" "Open this in a new tab" _blank
```

```
flowchart LR
	A-->B
	B-->C
	C-->D
	D-->E
	click A "https://www.github.com" _blank
	click B "https://www.github.com" "Open this in a new tab" _blank
	click C href "https://www.github.com" _blank
	click D href "https://www.github.com" "Open this in a new tab" _blank
```

#### Y. [Styling a node](https://mermaid.js.org/syntax/flowchart.html#styling-a-node)

> 讓圖示的樣式有所改變

##### F.1. Style

```mermaid
flowchart LR
    id1(Start)-->id2(Stop)
    style id1 fill:#f9f,stroke:#333,stroke-width:4px
    style id2 fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
```

```
flowchart LR
    id1(Start)-->id2(Stop)
    style id1 fill:#f9f,stroke:#333,stroke-width:4px
    style id2 fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
```

##### F.2. Class

```mermaid
flowchart LR
    A:::someclass --> B --> C

		classDef default fill:#f3f,stroke:#333,stroke-width:4px;
    classDef someclass fill:#f96
```

```
flowchart LR
    A:::someclass --> B --> C

		classDef default fill:#f3f,stroke:#333,stroke-width:4px;
    classDef someclass fill:#f96
```

##### F.3. [Css classes](https://mermaid.js.org/syntax/flowchart.html#css-classes)

> 這部分，試不出有什麼效果

```mermaid
flowchart LR
    A-->B[AAA<span>BBB</span>]
    B-->D
    class A cssClass
```

```
flowchart LR
    A-->B[AAA<span>BBB</span>]
    B-->D
    class A cssClass
```

##### F.4. [Basic support for fontawesome](https://mermaid.js.org/syntax/flowchart.html#basic-support-for-fontawesome)

```mermaid
flowchart TD
    B["fab:fa-twitter for peace"]
    B-->C[fa:fa-ban forbidden]
    B-->D(fa:fa-spinner)
    B-->E(A fa:fa-camera-retro perhaps?)
```

```
flowchart TD
    B["fab:fa-twitter for peace"]
    B-->C[fa:fa-ban forbidden]
    B-->D(fa:fa-spinner)
    B-->E(A fa:fa-camera-retro perhaps?)
```

#### Z. [Configuration](https://mermaid.js.org/syntax/flowchart.html#configuration)

> 只是寫個文件，沒有必要去設定。

### 5.2.3. Flowchart Orientation

> Possible FlowChart orientations are:
>
> - TB - top to bottom
> - TD - top-down/ same as top to bottom
> - BT - bottom to top
> - RL - right to left
> - LR - left to right

# Appendix

# I. Study

#### A. [Mermaid](https://mermaid.js.org/)

#### B. [mermaid-js](https://github.com/mermaid-js)/[mermaid](https://github.com/mermaid-js/mermaid)

#### C. [Markdown 语法・简明版](https://keatonlao.gitee.io/a-study-note-for-markdown/syntax/)
#### D. [Markdown文件](https://markdown.tw)

#### E. [adrai](https://github.com/adrai)/[flowchart.js](https://github.com/adrai/flowchart.js)

#### F. [MarkDown flow流程图示例](https://www.jianshu.com/p/f28c94cf1204)

#### G [typora 画流程图、时序图(顺序图)、甘特图](https://www.runoob.com/note/47651)

#### H. [超文本標示語言的字元代碼（Character Codes in HTML）](https://chukaml.tripod.com/linguistics/charCode/)

#### I. [HTML特殊字符編碼](https://www.ifreesite.com/html-entities.htm)

# II. Debug

# III. Glossary

# IV. Tool Usage

# V. Tools

## V.1. [typora](https://typora.io)

# Author

Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

[HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

