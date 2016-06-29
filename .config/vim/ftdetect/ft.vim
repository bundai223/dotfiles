"=============================================================
"
"
"
"=============================================================
" my local setting files
au BufNewFile,BufRead .zshrc* setl filetype=zsh
au BufNewFile,BufRead .vimrc* setl filetype=vim
au BufNewFile,BufRead .gvimrc* setl filetype=vim
au BufNewFile,BufRead .tmux.conf setl filetype=tmux

" direct x shader file
au BufNewFile,BufRead *.fx setl filetype=fx
" opengl shader file
au BufNewFile,BufRead *.vsh setl filetype=glsl
au BufNewFile,BufRead *.fsh setl filetype=glsl
au BufNewFile,BufRead *.gsh setl filetype=glsl
au BufNewFile,BufRead *.vertexshader setl filetype=glsl
au BufNewFile,BufRead *.fragmentshader setl filetype=glsl

" squirrel script
au BufNewFile,BufRead *.nut setl filetype=squirrel

" go lang
au BufNewFile,BufRead *.go setl filetype=go

" markdown(not modula2)
au BufNewFile,BufRead *.md setl filetype=markdown

" git
au BufNewFile,BufRead .gitconfig* setl filetype=gitconfig

" groovy
au BufNewFile,BufRead *.gradle setl filetype=groovy

" ruby
au BufNewFile,BufRead Vagrantfile setl filetype=ruby

" tool
au BufNewFile,BufRead *.uml setl filetype=plantuml
au BufNewFile,BufRead *nginx.conf setl filetype=nginx commentstring=#%s
au BufNewFile,BufRead td-agent.conf setl filetype=fluentd

" shell
autocmd BufNewFile *.sh 0r ~/.config/vim/bundles/vim-template/template/template.sh

" ruby
autocmd BufNewFile *.rb 0r ~/.config/vim/bundles/vim-template/template/template.rb

" python
autocmd BufNewFile *.py 0r ~/.config/vim/bundles/vim-template/template/template.py

" cpp
autocmd BufNewFile *.h 0r ~/.config/vim/bundles/vim-template/template/template.h
autocmd BufNewFile *.cpp 0r ~/.config/vim/bundles/vim-template/template/template.cpp
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

