
" 関数にsyntax
syntax match CFunctionName /[a-zA-Z_]\w*\s*\(\(\[[^]]*\]\s*\)\?(\s*[^\*]\)\@=/
syntax match CFunctionName /\*\s*[a-zA-Z_]\w*\s*\(\(\[\]\s*\)\?)\s*(\)\@=/
hi CFunctionName guifg=#aa0000
"hi CFunctionName guifg=#ff0000" guibg=#ffff00 
