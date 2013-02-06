"--------------------------------------
" basic setting
"--------------------------------------
" テキスト設定
if has('win')
    setlocal encoding=cp932
    setlocal fileformats=dos,unix
endif

" インデントの設定
setl autoindent
"setl smartindent
setl cindent
setl cinwords=if,else,for,foreach,while,class

" tabの設定
setl tabstop=4
setl expandtab
setl shiftwidth=4
setl softtabstop=4

