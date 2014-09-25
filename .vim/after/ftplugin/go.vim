" :Fmt などで gofmt の代わりに goimports を使う
let g:gofmt_command = 'goimports'

set shiftwidth=4
set noexpandtab
set tabstop=4

" 保存時に :Fmt する
autocmd FileType go autocmd BufWritePre <buffer> Fmt
