"--------------------------------------
" basic setting
"--------------------------------------
"includeまで補完するとめちゃくちゃおもいので除外
"setlocal complete=.,w,b,u,t


"--------------------------------------
" keybind
"--------------------------------------
" ヘッダファイルとソースファイルを入れ替える
nnoremap <C-a> :<C-u>CppHpp<CR>

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


