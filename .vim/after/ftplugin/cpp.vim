" cpp setting
if has('win')
    setlocal encoding=cp932
    setlocal fileformats=dos,unix
endif

" ヘッダ・ソースを開く
nnoremap <Leader>h  :<C-u>hide edit %<.h<Return>
nnoremap <Leader>c  :<C-u>hide edit %<.cpp<Return>

NeoBundleSource cpp-vim
NeoBundleSource clang_complete

