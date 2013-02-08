"--------------------------------------
" basic setting
"--------------------------------------
"if has('win')
"    setlocal encoding=cp932
"    setlocal fileformats=dos,unix
"endif


"--------------------------------------
" keybind
"--------------------------------------
" ヘッダ・ソースを開く
nnoremap <Leader>h :<C-u>hide edit %<.h<Return>
nnoremap <Leader>c :<C-u>hide edit %<.cpp<Return>

" 関数単位で移動
"noremap <C-p> [[?^?s*$<CR>jz<CR>
"noremap <C-n> /^?s*$<CR>]]?^?s*$<CR>jz<CR>


"--------------------------------------
" script
"--------------------------------------
" 選択範囲をifdef
vnoremap #  :call InsertIfdef()<CR>
vnoremap #n :call InsertIfndef()<CR>

function! InsertIfdef() range
	let sym = input("symbol:")
	call append(a:firstline-1, "#ifdef " . sym)
	call append(a:lastline+1, "#endif // " . sym)
endfunction
function! InsertIfndef() range
	let sym = input("symbol:")
	call append(a:firstline-1, "#ifndef " . sym)
	call append(a:lastline+1, "#endif // " . sym)
endfunction


"--------------------------------------
" plugin
"--------------------------------------
""" neobundle
" 言語用プラグインを読み込み
NeoBundleSource cpp-vim
NeoBundleSource opengl.vim
"NeoBundleSource clang_complete

