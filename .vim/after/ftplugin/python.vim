"--------------------------------------
" basic setting
"--------------------------------------
" インデントの設定
setl autoindent
"setl smartindent
setl cindent
setl cinwords=if,elif,else,for,while,try,except,finally,def,class

" tabの設定
" タブ文字はspace8で展開
" 実際のインデントはspace4文字
setl tabstop=8
setl expandtab
setl shiftwidth=4
setl softtabstop=4


"--------------------------------------
" plugin
"--------------------------------------
""" neobundle
NeoBundleSource jedi.git
NeoBundleSource jedi-vim.git

