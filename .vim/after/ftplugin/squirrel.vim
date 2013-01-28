" cpp setting
if has('win')
    setlocal encoding=cp932
    setlocal fileformats=dos,unix
endif

" インデントの設定
setl autoindent
setl smartindent
setl cinwords=if,else,for,foreach,while,class

" tabの設定
" タブ文字はspace8で展開
" 実際のインデントはspace4文字
setl tabstop=4
setl expandtab
setl shiftwidth=4
setl softtabstop=4

