set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8


let s:conf_root = expand('~/.config/nvim')
let s:repos_path = expand('~/repos')
let s:bundles_path = s:conf_root . '/bundles'
let s:dotfiles_path = s:repos_path . '/github.com/bundai223/dotfiles'
let s:backupdir = s:conf_root . '/backup'
let s:swapdir = s:conf_root . '/swp'
let s:undodir = s:conf_root . '/undo'

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

" Common setting {{{

" 変数を読み込む
if filereadable(expand('~/.vimrc_local_env'))
  source ~/.vimrc_local_env
endif


" help日本語・英語優先
"set helplang=ja,en
set helplang=en
" カーソル下の単語をhelp
set keywordprg =:help

" こいつのせいで<C-o>などでのジャンプがおかしくなってた
" 原因はよくわからない
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
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


" シンボリックなファイルを編集するとリンクが消されてしまうことがあったので
" 参照先を変数に上書き
let $MYVIMRC='~/.config/nvim/init.vim'
let $MYZSHRC=$DOTFILES.'/.zshrc'
let $MYTMUX_CONF=$DOTFILES.'/.tmux.conf'

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

" }}}

" Command mode{{{
" Complection setting command mode.
" When first tab, complete match part.
" After second tab, complete 候補 in order.
set wildmode=longest:full,full
set wildmenu
" }}}

" History {{{
" history num
set history=10000

if has('persistent_undo' )
  let &undodir=s:undodir
  set undofile
endif
" }}}

" Indent {{{
" Use space indent of tab to make indent
set expandtab

" Width of tab
set tabstop=2

" How many spaces to each indent level
set shiftwidth=2

" <>などでインデントする時にshiftwidthの倍数にまるめる
set shiftround

" 補完時に大文字小文字の区別なし
set infercase
"testing now {{{
" Automatically adjust indent
set autoindent

" Automatically indent when insert a new line
set smartindent
" }}}

" バッファを閉じる代わりに隠す
set hidden

" 新しく開く代わりにすでに開いているバッファを使用する
set switchbuf=useopen

set smarttab

" ▽スリーンベルを無効化

set t_vb=
set novisualbell
" }}}

" Search {{{
"
"virtualモードの時にスターで選択位置のコードを検索するようにする"
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

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

" }}}

" VimScript {{{

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
" }}}

" カレントパスをクリップボードにコピー {{{
command! CopyCurrentPath :call s:copy_current_path()
"nnoremap <C-\> :<C-u>CopyCurrentPath<CR>

function! s:copy_current_path()
  if has('win32')
    let @*=substitute(expand('%:p'), '\\/', '\\', 'g')
  else
    let @*=expand('%:p')
  endif
endfunction
" }}}

" カーソルを指定位置に移動 {{{
"展開後 <Cursor> 位置にカーソルが移動する
"nnoremap <expr> <A-p> s:_(":%s/<Cursor>/ほむ/g")
"nnoremap <expr> <A-p> ":%s//ほむ/g\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>"
function! s:move_cursor_pos_mapping(str, ...)
  let left = get(a:, 1, '<Left>')
  let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), '')
  return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! s:_(str)
  return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction

" コマンド版
"Nnoremap <A-o> :%s/<Cursor>/マミ/g
command! -nargs=* MoveCursorPosMap execute <SID>move_cursor_pos_mapping(<q-args>)
command! -nargs=* Nnoremap MoveCursorPosMap nnoremap <args>
" }}}

" }}}

" Common key mapping {{{

" Countinuous number input.
" nnoremap <silent> co :ContinuousNumber <C-a><CR>
" vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" Leaderを設定
" 参考: http://deris.hatenablog.jp/entry/2013/05/02/192415
noremap [myleader] <nop>
map <Space> [myleader]
"noremap map \ , "もとのバインドをつぶさないように

if has('macunix')
  let mapleader = '_'
endif

" 有効な用途が見えるまであけとく
noremap s <nop>
noremap S <nop>
noremap <C-s> <nop>
noremap <C-S> <nop>

" Easy to esc
inoremap <C-g> <Esc>
nnoremap <C-g> <Esc>
vnoremap <C-g> <Esc>
cnoremap <C-g> <Esc>


" Easy to cmd mode
nnoremap ; :
vnoremap ; :
nnoremap : q:i
vnoremap : q:i

" Reload
nnoremap <F5> :source %<CR>

" 直前のバッファに移動
nnoremap [myleader]b :b#<CR>

" Insert date
inoremap <C-d>d <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <C-d>t <C-R>=strftime('%H:%M')<CR>

" Easy to help
nnoremap [myleader]h :<C-u>vert bel help<Space>
nnoremap [myleader]H :<C-u>vert bel help<Space><C-r><C-w><CR>

" MYVIMRC
nnoremap [myleader]v :e $MYVIMRC<CR>
nnoremap [myleader]z :e $MYZSHRC<CR>
nnoremap [myleader]t :e $MYTMUX_CONF<CR>

" カレントパスをバッファに合わせる
nnoremap <silent>[myleader]<Space> :<C-u>lcd %:h<CR>:pwd<CR>

" Quick splits
nnoremap [myleader]_ :sp<CR>
nnoremap [myleader]<Bar> :vsp<CR>

" Delete line end space|tab.
nnoremap [myleader]s<Space> :%s/ *$//g<CR>
"nnoremap [myleader]s<Space> :%s/[ |\t]*$//g<CR>

" Copy and paste {{{
" Yank to end
nnoremap Y y$

" C-y Paste when insert mode
inoremap <C-y> <C-r>*

" BS act like normal backspace
nnoremap <BS> X

" }}}

" Tab moving {{{
nnoremap tn :<C-u>tabnew<CR>
nnoremap te :<C-u>tabnew +edit `=tempname()`<CR>
nnoremap tc :<C-u>tabclose<CR>

" }}}

" Cursor moving {{{
" Move window.
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" 関数単位で移動
nmap <C-p> [[
nmap <C-n> ]]

" Toggle 0 and ^
nnoremap <expr>0 col('.') == 1 ? '^' : '0'
nnoremap <expr>^ col('.') == 1 ? '^' : '0'

" }}}

" Search and replace {{{
" 検索ハイライトをオフ
nnoremap <silent>[myleader]/ :noh <CR>

" 置換
nnoremap <expr> sl _(":s/<Cursor>//")
nnoremap <expr> sg _(":s/<Cursor>//g")
nnoremap <expr> Sg _(":%s/<Cursor>//")
nnoremap <expr> Sl _(":%s/<Cursor>//g")

" 検索結果をウインドウ真ん中に
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" Fold moving {{{
noremap [fold] <nop>
nmap [myleader] [fold]

" Move fold
nnoremap [fold]j zj
nnoremap [fold]k zk

" Move fold begin line
nnoremap [fold]n ]z
nnoremap [fold]p [z

" Fold open and close
nnoremap [fold]c zc
nnoremap [fold]o zo
nnoremap [fold]a za

" All fold close
nnoremap [fold]m zM

" Other fold close
nnoremap [fold]i zMzv

" Make fold
nnoremap [fold]r zR
nnoremap [fold]f zf
"}}}

" Toggle relative line numbers {{{
"

function! s:ToggleRelativeNumber()
  if &relativenumber
    set norelativenumber
    let &number = exists('b:togglernu_number') ? b:togglernu_number : 1
  else
    let b:togglernu_number = &number
    set relativenumber
  endif
  redraw!  " these two lines required for omap

  return ''
endfunction

nnoremap <silent> [myleader]m :call <SID>ToggleRelativeNumber()<CR>
vnoremap <silent> [myleader]m :<C-U>call <SID>ToggleRelativeNumber()<CR>gv

" }}}

" Invalidate that don't use commands
nnoremap ZZ <Nop>
" exモード？なし
nnoremap Q <Nop>

" 矯正のために一時的に<C-c>無効化
inoremap <C-c> <Nop>
nnoremap <C-c> <Nop>
vnoremap <C-c> <Nop>
cnoremap <C-c> <Nop>

" }}}

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

"" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.config/nvim/dein.toml'
  let s:lazy_toml = '~/.config/nvim/dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif
" プラグインの追加・削除やtomlファイルの設定を変更した後は
" 適宜 call dein#update や call dein#clear_stateを呼んでください。
" そもそもキャッシュしなくて良いならload_state/save_stateを呼ばないようにしてください。

""" vimprocだけは最初にインストールしてほしい
"if dein#check_install(['vimproc'])
"  call dein#install(['vimproc'])
"endif
" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif
" }}}
