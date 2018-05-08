set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

let g:racer_cmd = expand("~/.cargo/bin/racer")
" let $RUST_SRC_PATH #terminal上で設定しているはず
"

let s:conf_root       = expand('~/.config/nvim')
let s:repos_path      = expand('~/repos')
let g:pub_repos_path  = s:repos_path . '/github.com/bundai223'
let s:priv_repos_path = s:repos_path . '/bitbucket.org/bundai223'
let s:dotfiles_path   = g:pub_repos_path . '/dotfiles'
let s:backupdir       = s:conf_root . '/backup'
let s:swapdir         = s:conf_root . '/swp'
let s:undodir         = s:conf_root . '/undo'
let s:plugin_dir      = s:conf_root . '/dein'
let s:dein_dir        = s:plugin_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein_toml       = g:pub_repos_path . '/dotfiles/config/nvim/dein.toml'
let g:memo_dir        = s:priv_repos_path . '/private-memo'

function! MkDir(dirpath)
  if !isdirectory(a:dirpath)
    call mkdir(a:dirpath, "p")
  endif
endfunction
call MkDir(s:conf_root)
call MkDir(s:repos_path)
call MkDir(s:backupdir)
call MkDir(s:swapdir)
call MkDir(s:undodir)

" help日本語・英語優先
"set helplang=ja,en
set helplang=en
" カーソル下の単語をhelp
set keywordprg =:help

set fileformat=unix
set fileformats=unix,dos


" バックアップファイルの設定
let &backupdir=s:backupdir
set backup
let &directory=s:swapdir
set swapfile

" クリップボードを使用する
set clipboard=unnamed

" Match pairs setting.
set matchpairs=(:),{:},[:],<:>

" 改行時の自動コメントをなしに
augroup MyAutoCmd
  autocmd FileType * setlocal formatoptions-=o
augroup END

" 分割方向を指定
set splitbelow
"set splitright

" BS can delete newline or indent
set backspace=indent,eol,start
let vim_indent_cont=6 " ' '*6+'\'+' ' →実質8sp

set completeopt=menu,preview
" 補完でプレビューしない
"set completeopt=menuone,menu

" C-a, C-xでの増減時の設定
set nrformats=hex

" Default comment format is nothing
" Almost all this setting override by filetype setting
" e.g. cpp: /*%s*/
"      vim: "%s
set commentstring=%s

if has('vim_starting')
  " Goのpath
  if $GOROOT != ''
    set runtimepath+=$GOROOT/misc/vim
    "set runtimepath+=$GOPATH/src/github.com/nsf/gocode/vim
  endif

  let &runtimepath .= ',' . s:conf_root
  let &runtimepath .= ',' . s:conf_root . '/after'
  if has('win32')
  else
    " 自前で用意したものへの path
    set path=.,/usr/include,/usr/local/include
  endif
endif

if has('unix')
  let $USERNAME=$USER
endif

" Select last pasted.
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" History
set history=10000

if has('persistent_undo' )
  let &undodir=s:undodir
  set undofile
endif

" Indent
set expandtab

" Width of tab
set tabstop=2

" How many spaces to each indent level
set shiftwidth=2

" <>などでインデントする時にshiftwidthの倍数にまるめる
set shiftround

" 補完時に大文字小文字の区別なし
set infercase

" Automatically adjust indent
set autoindent

" Automatically indent when insert a new line
set smartindent
set smarttab

" スリーンベルを無効化

set t_vb=
set novisualbell

" Search
" Match words with ignore upper-lower case
set ignorecase

" Don't think upper-lower case until upper-case input
set smartcase

" Incremental search
set incsearch

" Highlight searched words
set hlsearch

" http://cohama.hateblo.jp/entry/20130529/1369843236
" Auto complete backslash when input slash on search command(search by slash).
cnoremap <expr> / (getcmdtype() == '/') ? '\/' : '/'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Expand 単語境界入力
" https://github.com/cohama/.vim/blob/master/.vimrc
cnoremap <C-w> <C-\>eToggleWordBounds(getcmdtype(), getcmdline())<CR>
function! ToggleWordBounds(type, line)
  if a:type == '/' || a:type == '?'
    if a:line =~# '^\\<.*\\>$'
      return substitute(a:line, '^\\<\(.*\)\\>$', '\1', '')
    else
      return '\<' . a:line . '\>'
    endif

  elseif a:type == ':'
    " s || %sの時は末尾に連結したり削除したり
    if a:line =~# 's/.*' || a:line =~# '%s/.*'
      if a:line =~# '\\<\\>$'
        return substitute(a:line, '\\<\\>$', '\1', '')
      else
        return a:line . '\<\>'
      endif
    else
      return a:line
    endif

  else
    return a:line
  endif
endfunction

" Auto escape input
cnoremap <C-\> <C-\>eAutoEscape(getcmdtype(), getcmdline())<CR>
function! AutoEscape(type, line)
  if a:type == '/' || a:type == '?'
    return substitute(a:line, '/', '\\/', 'g')
  else
    return a:line
  endif
endfunction

" tagファイルの検索パス指定
" カレントから親フォルダに見つかるまでたどる
" tagの設定は各プロジェクトごともsetlocalする
set tags+=tags;

" 外部grepの設定
set grepprg=grep\ -nH

augroup MyAutoCmd
  " make, grep などのコマンド後に自動的にQuickFixを開く
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep cwindow

  " QuickFixおよびHelpでは q でバッファを閉じる
  autocmd FileType help,qf nnoremap <buffer> q <C-w>c
augroup END

" filetype 調査
" :verbose :setlocal filetype?
"
" Set encoding when open file {{{
command! Utf8 edit ++enc=utf-8 %
command! Utf16 edit ++enc=utf-16 %
command! Cp932 edit ++enc=cp932 %
command! Euc edit ++enc=eucjp %

command! Unix edit ++ff=unix %
command! Dos edit ++ff=dos %

" Copy current path.
command! CopyCurrentPath :call s:copy_current_path()
"nnoremap <C-\> :<C-u>CopyCurrentPath<CR>

function! s:copy_current_path()
  if has('win32')
    let @*=substitute(expand('%:p'), '\\/', '\\', 'g')
  else
    let @*=expand('%:p')
  endif
endfunction

" Json Formatter
command! JsonFormat :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1


" Leaderを設定
" 参考: http://deris.hatenablog.jp/entry/2013/05/02/192415
noremap [myleader] <nop>
map <Space> [myleader]
"noremap map \ , "もとのバインドをつぶさないように

" 有効な用途が見えるまであけとく
noremap s <nop>
noremap S <nop>
noremap <C-s> <nop>
noremap <C-S> <nop>

" Invalidate that don't use commands
nnoremap ZZ <Nop>
" exモード？なし
nnoremap Q <Nop>

" 矯正のために一時的に<C-c>無効化
inoremap <C-c> <Nop>
nnoremap <C-c> <Nop>
vnoremap <C-c> <Nop>
cnoremap <C-c> <Nop>

" Easy to esc
inoremap <C-g> <Esc>
nnoremap <C-g> <Esc>
vnoremap <C-g> <Esc>
cnoremap <C-g> <Esc>
tnoremap <silent> <Esc> <C-\><C-n>


" Easy to cmd mode
" nnoremap ; :
" vnoremap ; :
" nnoremap : q:i
" vnoremap : q:i

" Easy to help
nnoremap [myleader]h :<C-u>vert bel help<Space>
nnoremap [myleader]H :<C-u>vert bel help<Space><C-r><C-w><CR>

" カレントパスをバッファに合わせる
nnoremap <silent>[myleader]<Space> :<C-u>lcd %:h<CR>:pwd<CR>

" Quick splits
nnoremap [myleader]_ :sp<CR>
nnoremap [myleader]<Bar> :vsp<CR>

" Delete line end space|tab.
nnoremap [myleader]s<Space> :%s/ *$//g<CR>
"nnoremap [myleader]s<Space> :%s/[ |\t]*$//g<CR>

" Yank to end
nnoremap Y y$

" C-y Paste when insert mode
inoremap <C-y> <C-r>*

" BS act like normal backspace
nnoremap <BS> X

" tab
nnoremap tn :<C-u>tabnew<CR>
nnoremap te :<C-u>tabnew +edit `=tempname()`<CR>
nnoremap tc :<C-u>tabclose<CR>

" 関数単位で移動
nmap <C-p> [[
nmap <C-n> ]]

" Toggle 0 and ^
nnoremap <expr>0 col('.') == 1 ? '^' : '0'
nnoremap <expr>^ col('.') == 1 ? '^' : '0'

" highlight off
nnoremap <silent>[myleader]/ :noh <CR>

" 検索結果をウインドウ真ん中に
nnoremap n nzzzv
nnoremap N Nzzzv


if &compatible
  set nocompatible
endif
if &runtimepath !~# '/dein.vim'
  call MkDir(s:plugin_dir)

  if !isdirectory(s:dein_dir)
    execute '!curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer_dein.sh'
    execute '!sh installer_dein.sh '. s:plugin_dir
    execute '!rm installer_dein.sh'

  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, 'p')
  " set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
endif

if dein#load_state(expand(s:dein_dir))
  call dein#begin(expand(s:plugin_dir))

  call dein#add('tpope/vim-fugitive')
  call dein#load_toml(g:dein_toml, {})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

""" racer
set hidden

augroup MyAutoCmd
  autocmd BufNewFile,BufRead *_spec.rb setl filetype=ruby.rspec
  autocmd FileType ruby setlocal iskeyword+=?

  autocmd FileType ruby setlocal dictionary+=~/.config/nvim/dein/repos/github.com/pocke/dicts/ruby.dict
  autocmd FileType javascript,ruby setlocal dictionary+=~/.config/nvim/dein/repos/github.com/pocke/dicts/jquery.dict
augroup END

" memo
if !isdirectory(g:memo_dir)
  execute '!ghq get -p bitbucket.org:bundai223/private-memo.git'
endif

augroup MyAutoCmd
  autocmd FileType changelog setlocal modelines=0
  autocmd FileType changelog setlocal nomodeline
augroup END


""" lightline
let s:colorscheme = 'wombat'
if !empty($COLORSCHEME)
  let s:colorscheme = $COLORSCHEME
endif
let g:lightline = {
      \ 'colorscheme': s:colorscheme,
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\u20b1", 'right': "\ue0b3" },
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'plugin', 'paste' ],
      \     [ 'fugitive', 'filename' ],
      \     [ 'pwd' ]
      \   ],
      \   'right': [
      \     ['lineinfo', 'syntax_check'],
      \     ['percent'],
      \     ['charcode', 'fileformat', 'fileencoding', 'filetype']
      \   ]
      \ },
      \ 'component_function': {
      \   'mode': 'MyMode',
      \   'plugin': 'MySpPlugin',
      \   'fugitive': 'MyFugitive',
      \   'gitgutter': 'MyGitgutter',
      \   'filename': 'MyFilename',
      \   'pwd': 'MyPwd',
      \   'charcode': 'MyCharCode',
      \   'fileformat': 'MyFileformat',
      \   'fileencoding': 'MyFileencoding',
      \   'filetype': 'MyFiletype'
      \ },
      \ 'conponent_expand': {
      \   'syntax_check': 'qfstatusline#Update',
      \ },
      \ 'conponent_type': {
      \   'syntax_check': 'error',
      \ },
      \}

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &readonly ? '⭤'  : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return
        \ fname =~ '__Gundo' ? '' :
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != MyModified() ? ' ' . MyModified() : '') .
        \ '' != fname ? fname : '[No Name]')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? '⭠ '._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyGitgutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction
function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MySpPlugin()
  let fname = expand('%:t')
  return  winwidth(0) <= 60 ? '' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ ''
endfunction

function! MyPwd()
  if winwidth(0) > 60
    " $HOMEは'~'表示の方が好きなので置き換え
    let s:homepath = expand('~')
    return substitute(getcwd(), expand('~'), '~', '')
  else
    return ''
  endif
endfunction


function! MyCharCode()
  if winwidth('.') <= 70
    return ''
  endif

  " Get the output of :ascii
  redir => ascii
  silent! ascii
  redir END

  if match(ascii, 'NUL') != -1
    return 'NUL'
  endif

  " Zero pad hex values
  let nrformat = '0x%02x'

  let encoding = (&fenc == '' ? &enc : &fenc)

  if encoding == 'utf-8'
    " Zero pad with 4 zeroes in unicode files
    let nrformat = '0x%04x'
  endif

  " Get the character and the numeric value from the return value of :ascii
  " This matches the two first pieces of the return value, e.g.
  " "<F>  70" => char: 'F', nr: '70'
  let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

  " Format the numeric value
  let nr = printf(nrformat, nr)

  return "'". char ."' ". nr
endfunction

if system('uname -a | grep Microsoft') != ""
  let g:clipboard = {
        \   'name': 'myClipboard',
        \   'copy': {
        \      '+': 'win32yank.exe -i',
        \      '*': 'win32yank.exe -i',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o',
        \      '*': 'win32yank.exe -o',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

if has('unix')
  if !has('gui_running')
    colorscheme desert
  endif
endif

" for changelog memo
let g:changelog_dateformat = '%Y-%m-%d'
let g:changelog_username   = 'Daiji NISHIMURA <bundai223@gmail.com>'

" set runtimepath+=~/repos/github.com/bundai223/denite-changelog-memo.nvim

