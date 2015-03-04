"=============================================================
"
"
"
"=============================================================
" my local setting files
au BufNewFile,BufRead .zshrc* set filetype=zsh
au BufNewFile,BufRead .vimrc* set filetype=vim
au BufNewFile,BufRead .gvimrc* set filetype=vim
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
au BufNewFile,BufRead .gitconfig* set filetype=gitconfig

" groovy
au BufNewFile,BufRead *.gradle set filetype=groovy

" ruby
au BufNewFile,BufRead Vagrantfile set filetype=ruby

" PlantUML
au BufNewFile,BufRead *.uml set filetype=plantuml

" nginx
au BufNewFile,BufRead *nginx.conf set filetype=nginx

" shell
autocmd BufNewFile *.sh 0r ~/.vim/.bundle/vim-template/template/template.sh

" ruby
autocmd BufNewFile *.rb 0r ~/.vim/.bundle/vim-template/template/template.rb

" python
autocmd BufNewFile *.py 0r ~/.vim/.bundle/vim-template/template/template.py

" cpp
autocmd BufNewFile *.h 0r ~/.vim/.bundle/vim-template/template/template.h
autocmd BufNewFile *.cpp 0r ~/.vim/.bundle/vim-template/template/template.cpp
" *.hを作成するときにインクルードガードを作成する
" au BufNewFile *.h call InsertCppHeaderHeader()
" au BufNewFile *.cpp call InsertCppSourceHeader()
" 
" function! IncludeGuard()
"   let fl = getline(1)
"   if fl =~ "^#if"
"     return
"   endif
"    let gatename = substitute(toupper(expand("%:t")), "??.", "_", "g")
"   let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
"   normal! gg
"   execute "normal! i#ifndef _" . gatename . "_INCLUDED_"
"   execute "normal! o#define _" . gatename .  "_INCLUDED_\<CR>\<CR>\<CR>\<CR>"
"   execute "normal! Go#endif // _" . gatename . "_INCLUDED_\<CR>"
"   4
" endfunction
" 
" function! InsertCppSourceHeader()
"   let filename = expand("%:t")
"   normal! gg
"   execute "normal! i//**********************************************************************"
"   execute "normal! o//! @file   " . filename
"   execute "normal! o//! @brief  describe"
"   execute "normal! o//**********************************************************************"
" endfunction
" 
" function! InsertCppHeaderHeader()
"   call IncludeGuard()
"   call InsertCppSourceHeader()
" endfunction

