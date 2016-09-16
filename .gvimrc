"---------------------------------
" 見た目の設定
"---------------------------------
"---------------------------------
" ウインドウなどの設定
"---------------------------------
" gvimのツールバーなどの設定
set guioptions-=T "ツールバーなし
" set guioptions-=m "メニューバーなし
" set guioptions-=r "右スクロールバーなし
" set guioptions-=R
" set guioptions-=l "左スクロールバーなし
" set guioptions-=L
" set guioptions-=b "下スクロールバーなし

if has('mac')
    set transparency=0
endif
"---------------------------------
" フォント設定:
"---------------------------------
if has('win32')
  " Windows用
  set guifont=MS_Gothic:h10:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  " set guifont=Sauce\ Code\ Powerline:h14
  " set guifontwide=Sauce\ Code\ Powerline:h14

  " set guifont=Ricty\ Regular:h14
  " set guifontwide=Ricty\ Regular:h14
  " set guifont=Ricty\ Diminished\ For\ Powerline:h14
  " set guifontwide=Ricty\ Diminished\ For\ Powerline:h14
  "
  set guifont=Ricty\ Diminished\ Discord\ For\ Powerline:h14
  set guifontwide=Ricty\ Diminished\ Discord\ For\ Powerline:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

"---------------------------------
" vim script
"---------------------------------
" ローカル設定を読み込む
if filereadable(expand('~/.gvimrc_local'))
    source ~/.gimrc_local
endif

if has('vim_starting')
"   colorscheme solarized
  colorscheme hybrid
  set bg=dark
endif

" let g:lightline.colorscheme='solarized'
let g:lightline.colorscheme='hybrid'

