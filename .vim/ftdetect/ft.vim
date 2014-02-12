"=============================================================
"
"
"
"=============================================================
" my local setting files
au BufNewFile,BufRead *.local_zshrc set filetype=zsh
au BufNewFile,BufRead *.local_vimrc *.local_gvimrc set filetype=vim

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

" Setting newfile setting
" ruby {{{
au BufNewFile *.rb call InsertFileEncoding()

function! InsertFileEncoding()
  normal! gg
  execute "normal! i#! /usr/bin/ruby\<CR>"
  execute "normal! i# coding: utf-8\<CR>"
endfunction
" }}}

" *.hを作成するときにインクルードガードを作成する {{{
au BufNewFile *.h call InsertHeaderHeader()
au BufNewFile *.cpp call InsertFileHeader()

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

function! InsertFileHeader()
  let filename = expand("%:t")
  normal! gg
  execute "normal! i//**********************************************************************\<CR>"
  execute "normal! i//! @file   " . filename . "\<CR>"
  execute "normal! i//! @brief  describe\<CR>"
  execute "normal! i//**********************************************************************\<CR>"
endfunction

function! InsertHeaderHeader()
  call IncludeGuard()
  call InsertFileHeader()
endfunction
" }}}


