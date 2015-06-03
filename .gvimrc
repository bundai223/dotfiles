"---------------------------------
" 見た目の設定
"---------------------------------
"---------------------------------
" ウインドウなどの設定
"---------------------------------
" 表示行数
"" 縦
"set lines=60
"" 横
"set columns=124

" gvimのツールバーなどの設定
set guioptions-=T "ツールバーなし
set guioptions-=m "メニューバーなし
set guioptions-=r "右スクロールバーなし
set guioptions-=R
set guioptions-=l "左スクロールバーなし
set guioptions-=L
set guioptions-=b "下スクロールバーなし

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
"   set guifont=Ricty\ Regular:h14
  set guifont=Sauce\ Code\ Powerline:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

"---------------------------------
" vim script
"---------------------------------
" full screen
nnoremap <F11> : call ToggleFullScreen()<CR>
function! ToggleFullScreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    simalt ~r
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    simalt ~x
  endif
endfunction

" ローカル設定を読み込む
if filereadable(expand('~/.gvimrc_local'))
    source ~/.gvimrc_local
endif

if has('vim_starting')
  colorscheme solarized
  set bg=dark
endif

let g:lightline.colorscheme='solarized'

