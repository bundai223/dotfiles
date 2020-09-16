set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

" 不可視文字の表示
set list
" tab: »-
" 行末の空白: ･
" ノーブレークスペース: ⍽
" 画面の右側に文字があるとき: »
" 画面の左側に文字があるとき: «
set listchars=tab:»-,trail:･,nbsp:⍽,extends:»,precedes:«
set showtabline=2

set termguicolors " terminalでもTrue Colorを使えるようにする
set pumblend=10

set textwidth=0

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

let g:racer_cmd = expand("~/.cargo/bin/racer")
" let $RUST_SRC_PATH #terminal上で設定しているはず
"

let s:conf_root            = expand('~/.config/nvim')
let s:repos_path           = expand('~/repos')
let g:pub_repos_path       = s:repos_path . '/github.com/bundai223'
let g:priv_repos_path      = s:repos_path . '/gitlab.com/bundai223'
let g:dotfiles_path        = g:pub_repos_path . '/dotfiles'
let g:dotfiles_config_path = g:dotfiles_path . '/config'
let s:backupdir            = s:conf_root . '/backup'
let s:swapdir              = s:conf_root . '/swp'
let s:undodir              = s:conf_root . '/undo'
let g:plugin_dir           = s:conf_root . '/dein'
let s:dein_dir             = g:plugin_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein_toml            = g:pub_repos_path . '/dotfiles/config/nvim/dein.toml'
let g:memo_dir             = g:priv_repos_path . '/private-memo'
let g:outher_package_path = s:conf_root . '/tools'

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
set keywordprg=:help

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
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript
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

" w!! でスーパーユーザーとして保存
cmap w!! w !sudo tee > /dev/null %

" History
set history=10000

if has('persistent_undo' )
  let &undodir=s:undodir
  set undofile
endif

set virtualedit=block " visualモードで文字がなくてもカーソル移動可能

" Indent
set expandtab    " indent use space
set tabstop=2    " Width of tab
set shiftwidth=2 " How many spaces to each indent level
set shiftround   " <>などでインデントする時にshiftwidthの倍数にまるめる
set infercase    " 補完時に大文字小文字の区別なし
set autoindent   " Automatically adjust indent
set smartindent  " Automatically indent when insert a new line
set smarttab     " hoge

" スリーンベルを無効化
set t_vb=
set novisualbell

" Search
set ignorecase " Match words with ignore upper-lower case
set smartcase " Don't think upper-lower case until upper-case input
set incsearch " Incremental search
set inccommand= "split " 置換のプレビュー無効に " TODO: どれかのプラグインに問題あり
set hlsearch " Highlight searched words

" http://cohama.hateblo.jp/entry/20130529/1369843236
" Auto complete backslash when input slash on search command(search by slash).
cnoremap <expr> / (getcmdtype() == '/') ? '\/' : '/'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Expand 単語境界入力
" https://github.com/cohama/.vim/blob/master/.vimrc
cnoremap <C-W> <C-\>eToggleWordBounds(getcmdtype(), getcmdline())<CR>
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
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
else
  set grepprg=grep\ -nH
endif

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
map \ [myleader]
let mapleader = "\<Space>"
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

" Easy to help
nnoremap <leader>h :<C-u>vert bel help<Space>
nnoremap <leader>H :<C-u>vert bel help<Space><C-r><C-w><CR>

" カレントパスをバッファに合わせる
nnoremap <silent><leader>cd :<C-u>lcd %:h<CR>:pwd<CR>

nnoremap <silent><leader>te :term<CR>

" Quick splits
nnoremap <silent><leader>_ :sp<CR>
nnoremap <silent><leader><Bar> :vsp<CR>

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
nnoremap <silent><leader>/r :noh <CR>

" 検索結果をウインドウ真ん中に
nnoremap n nzzzv
nnoremap N Nzzzv

" バッファ移動
nnoremap <silent> bp :bprevious<CR>
nnoremap <silent> bn :bnext<CR>

" untab
inoremap <S-Tab> <C-D>

if &compatible
  set nocompatible
endif
if &runtimepath !~# '/dein.vim'
  call MkDir(g:plugin_dir)

  if !isdirectory(s:dein_dir)
    execute '!curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer_dein.sh'
    execute '!sh installer_dein.sh '. g:plugin_dir
    execute '!rm installer_dein.sh'

  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, 'p')
  " set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
endif

if dein#load_state(expand(s:dein_dir))
  call dein#begin(expand(g:plugin_dir))

  call dein#add('tpope/vim-fugitive')
  call dein#load_toml(g:dein_toml, {})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" vimprocをを先にインストール
if dein#check_install(['vimproc.vim'])
  call dein#install(['vimproc.vim'])
endif

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

  "autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  autocmd FileType vue setlocal iskeyword+=$
  autocmd FileType vue setlocal iskeyword+=-

  autocmd BufNewFile,BufRead *.gb setl filetype=goby
  autocmd FileType vue syntax sync fromstart

  autocmd FileType python setl tabstop=8
  autocmd FileType python setl softtabstop=4
  autocmd FileType python setl shiftwidth=4
  autocmd FileType python setl expandtab
augroup END

" memo
if !isdirectory(g:memo_dir)
  execute '!ghq get -p gitlab.com:bundai223/private-memo.git'
endif

augroup MyAutoCmd
  autocmd FileType changelog setlocal modelines=0
  autocmd FileType changelog setlocal nomodeline
  autocmd FileType changelog setlocal textwidth=0
augroup END

if system('uname -a | grep -i Microsoft') != ""
  let g:clipboard = {
        \   'name': 'myClipboard',
        \   'copy': {
        \      '+': 'win32yank.exe -i',
        \      '*': 'win32yank.exe -i',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

" for changelog memo
let g:changelog_dateformat = '%Y-%m-%d'
let g:changelog_username   = 'bundai223  <bundai223@gmail.com>'

" termのバッファ名をプロセス名に変更する設定
autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | execute ":file term" . b:terminal_job_pid . "/" . b:term_title

" 開発中plugin設定
" set runtimepath+=~/repos/github.com/bundai223/denite-changelog-memo.nvim

set isfname+={,}

