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

