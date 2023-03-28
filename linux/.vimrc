set nocp                "指定 VIM 工作在不兼容模

"https://magiclen.org/vimrc/
syntax enable          "程式碼語法高亮功能

"set autoindent         "自動縮排有「autoindent」、「smartindent」和「cindent」
set backspace=2         "可隨時用倒退鍵刪除
set bg=dark             "顯示不同的底色色調
"set expandtab          "輸入 tab 都會被轉換成 space
set hlsearch            "搜尋結果高亮提示
set mouse-=a            "「n」為一般模式；「v」為視覺模式；「i」為插入模式；「c」為命令列模式；「a」為所有模式
set noexpandtab         "關閉vim的TAB擴展功能
set nowrap              "指定不換行
set nu                  "可以在每一行的最前面顯示行號啦！
set ruler               "右下角顯示游標座標
set shiftwidth=2        "自動縮排對齊間隔數
set showmode            "在底部顯示目前使用的操作模式是一般、插入、取代還是選取模式
set tabstop=2           "縮排間隔數
set softtabstop=2

" Reopen the last edited position in files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
