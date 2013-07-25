"--------------------------------------
" basic setting
"--------------------------------------
"if has('win')
"    setlocal encoding=cp932
"    setlocal fileformats=dos,unix
"endif
setlocal complete=.,w,b,u,t


"--------------------------------------
" keybind
"--------------------------------------
" ヘッダ・ソースを開く
"nnoremap <Leader>h :<C-u>hide edit %<.h<Return>
"nnoremap <Leader>c :<C-u>hide edit %<.cpp<Return>

" ヘッダファイルとソースファイルを入れ替える
nnoremap <C-c> :<C-u>CppHpp<CR>
" 関数単位で移動
"noremap <C-p> [[?^?s*$<CR>jz<CR>
"noremap <C-n> /^?s*$<CR>]]?^?s*$<CR>jz<CR>


"--------------------------------------
" script
"--------------------------------------
" 選択範囲をifdef
vnoremap #z :call InsertIfZero()<CR>
vnoremap #d :call InsertIfdef()<CR>
vnoremap #n :call InsertIfndef()<CR>

function! InsertIfZero() range
  call append(a:firstline-1, "#if 0")
  call append(a:lastline+1, "#endif // #if 0")
endfunction
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


" C++マクロ展開
function! CppRegion() range
  exe "'<,'>!sh " . expand("~/labo/dotfiles/util/cppregion.sh") . " " . expand("%") . " " . a:firstline . " " . a:lastline 
endfunction


