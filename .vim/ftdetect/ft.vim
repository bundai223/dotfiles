"=============================================================
"
"
"
"=============================================================
" my local setting files
au BufNewFile,BufRead .zshrc_local set filetype=zsh
au BufNewFile,BufRead .vimrc_local set filetype=vim
au BufNewFile,BufRead .gvimrc_local set filetype=vim

" direct x shader file
au BufNewFile,BufRead *.fx set filetype=fx
" opengl shader file
au BufNewFile,BufRead *.vsh set filetype=glsl
au BufNewFile,BufRead *.fsh set filetype=glsl
au BufNewFile,BufRead *.gsh set filetype=glsl
au BufNewFile,BufRead *.vertexshader set filetype=glsl
au BufNewFile,BufRead *.fragmentshader set filetype=glsl

" squirrel script
au BufNewFile,BufRead *.nut set filetype=squirrel

" go lang
au BufNewFile,BufRead *.go set filetype=go

" markdown(not modula2)
au BufNewFile,BufRead *.md set filetype=markdown
" git
au BufNewFile,BufRead .gitconfig_local set filetype=gitconfig

" Setting newfile setting
" shell {{{
au BufNewFile *.sh call Insert_Shell_Shebang()

function! Insert_Shell_Shebang()
  normal! gg
  execute "normal! i#! /bin/bash\<CR>"
  execute "normal! 0D"
endfunction
" }}}

" ruby {{{
au BufNewFile *.rb call Insert_Ruby_FileEncoding()

function! Insert_Ruby_FileEncoding()
  normal! gg
  execute "normal! i#! /usr/bin/ruby\<CR>"
  execute "normal! 0Di# coding: utf-8\<CR>"
endfunction
" }}}

" *.hを作成するときにインクルードガードを作成する {{{
au BufNewFile *.h call Insert_Cpp_HeaderHeader()
au BufNewFile *.cpp call Insert_Cpp_SourceHeader()

function! IncludeGuard()
  let fl = getline(1)
  if fl =~ "^#if"
    return
  endif
   let gatename = substitute(toupper(expand("%:t")), "??.", "_", "g")
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  normal! gg
  execute "normal! i#ifndef _" . gatename . "_INCLUDED_"
  execute "normal! o#define _" . gatename .  "_INCLUDED_\<CR>\<CR>\<CR>\<CR>"
  execute "normal! Go#endif // _" . gatename . "_INCLUDED_\<CR>"
  4
endfunction

function! Insert_Cpp_SourceHeader()
  let filename = expand("%:t")
  normal! gg
  execute "normal! i//**********************************************************************\<CR>"
  execute "normal! i//! @file   " . filename . "\<CR>"
  execute "normal! i//! @brief  describe\<CR>"
  execute "normal! i//**********************************************************************\<CR>"
endfunction

function! Insert_Cpp_HeaderHeader()
  call IncludeGuard()
  call Insert_Cpp_SourceHeader()
endfunction
" }}}


