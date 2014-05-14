" for java setting

" indent
setlocal noexpandtab

setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4

setlocal include=^import

" TODO: メンバーへ移動を実装したい
" public/protected/private or 関数宣言の正規表現で簡易的に
"nnoremap <silent> <buffer> <C-p> :call <SID>del_entry()<CR>
"nnoremap <silent> <buffer> <C-n> :call <SID>del_entry()<CR>
"
"function! s:del_entry()
"endfunction
