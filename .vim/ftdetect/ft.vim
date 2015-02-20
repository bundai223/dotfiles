"=============================================================
"
"
"
"=============================================================
" my local setting files
au BufNewFile,BufRead .zshrc_local set filetype=zsh
au BufNewFile,BufRead .vimrc_local set filetype=vim
au BufNewFile,BufRead .gvimrc_local set filetype=vim
au BufNewFile,BufRead .tmux.conf set filetype=tmux

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

" groovy
au BufNewFile,BufRead *.gradle set filetype=groovy

" ruby
au BufNewFile,BufRead Vagrantfile set filetype=ruby

" PlantUML
au BufNewFile,BufRead *.uml set filetype=plantuml

" nginx
au BufNewFile,BufRead *nginx.conf set filetype=nginx

" Setting newfile setting
" shell {{{
au BufNewFile *.sh call InsertShellShebang()

function! InsertShellShebang()
  normal! gg
  execute "normal! i#!/usr/bin/env bash\<CR>"
  execute "normal! 0D"
endfunction
" }}}

" ruby {{{
au BufNewFile *.rb call InsertRubyFileEncoding()

function! InsertRubyFileEncoding()
  normal! gg
  execute "normal! i#!/usr/bin/env ruby\<CR>"
  execute "normal! 0Di# coding: utf-8\<CR>"
endfunction
" }}}

" python {{{
au BufNewFile *.py call InsertPython3FileEncoding()

function! InsertPython3FileEncoding()
  normal! gg
  execute "normal! i#!/usr/bin/env python3\<CR>"
  execute "normal! 0Di# -*- coding: utf-8 -*-\<CR>"
endfunction
" }}}

" *.hを作成するときにインクルードガードを作成する {{{
au BufNewFile *.h call InsertCppHeaderHeader()
au BufNewFile *.cpp call InsertCppSourceHeader()

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

function! InsertCppSourceHeader()
  let filename = expand("%:t")
  normal! gg
  execute "normal! i//**********************************************************************\<CR>"
  execute "normal! i//! @file   " . filename . "\<CR>"
  execute "normal! i//! @brief  describe\<CR>"
  execute "normal! i//**********************************************************************\<CR>"
endfunction

function! InsertCppHeaderHeader()
  call IncludeGuard()
  call InsertCppSourceHeader()
endfunction
" }}}


