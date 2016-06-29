" basic setting
"includeまで補完するとめちゃくちゃおもいので除外
"setlocal complete=.,w,b,u,t


" keybind
" ヘッダファイルとソースファイルを入れ替える
nnoremap <Leader>s :<C-u>CppHpp<CR>


" script"{{{
" 選択範囲をifdef"{{{
vnoremap iz :call InsertIfZero()<CR>
vnoremap id :call InsertIfdef()<CR>
vnoremap in :call InsertIfndef()<CR>

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
"}}}

" C++マクロ展開 {{{
function! CppRegion() range
  exe "'<,'>!sh " . expand("~/labo/dotfiles/util/cppregion.sh") . " " . expand("%") . " " . a:firstline . " " . a:lastline 
endfunction
" }}}

" headerとsourceを入れ替える {{{
command! -nargs=0 CppHpp :call <SID>cpp_hpp()
function! s:cpp_hpp()
    let cpps = ['cpp', 'cc', 'cxx', 'c']
    let hpps = ['hpp', 'h']
    let ext  = expand('%:e')
    let base = expand('%:r')

    " ソースファイルのとき
    if count(cpps,ext) != 0
        for hpp in hpps
            if filereadable(base.'.'.hpp)
                execute 'edit '.base.'.'.hpp
                return
            endif
        endfor
    endif

    " ヘッダファイルのとき
    if count(hpps,ext) != 0
        for cpp in cpps
            if filereadable(base.'.'.cpp)
                execute 'edit '.base.'.'.cpp
                return
            endif
        endfor
    endif

    " なければ Unite で検索
    if executable('mdfind') && has('mac')
        execute "Unite spotlight -input=".base
    elseif executable('locate')
        execute "Unite locate -input=".base
    else
        echoerr "not found"
    endif

endfunction
" }}}
"}}}

