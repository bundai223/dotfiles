"---------------------------------
" 見た目の設定
"---------------------------------
" colorscheme solarized
colorscheme molokai

set cursorline

"---------------------------------
" ウインドウなどの設定
"---------------------------------
" 表示行数
"起動時フルスクリーン
if has('win32')
	au GUIEnter * simalt ~x
elseif has('unix')
	" 縦
	set lines=40
	" 横
	set columns=124
endif


" 自動折り返しなし
set nowrap

if has('win32')
	set guioptions-=T
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
  set guifont=Osaka－等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif

