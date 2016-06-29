augroup ghcmodcheck
  autocmd! BufWritePost <buffer> GhcModCheckAsync
augroup END


setlocal include=^import
setlocal include=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.hs
