scriptencoding utf-8

" Common setting {{{

" 変数を読み込む
if filereadable(expand('~/.vimrc_local_env'))
  source ~/.vimrc_local_env
endif


" help日本語・英語優先
"set helplang=ja,en
set helplang=en
" カーソル下の単語をhelp/Users/daiji/labo/dotfiles/.vimrc
set keywordprg =:help

" 文字エンコード
set encoding=utf-8
set fileencoding=utf-8
" こいつのせいで<C-o>などでのジャンプがおかしくなってた
" 原因はよくわからない
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set fileformat=unix
set fileformats=unix,dos

" バックアップファイルの設定
"set nowritebackup
"set nobackup
set noswapfile

" クリップボードを使用する
set clipboard=unnamed

" Match pairs setting.
set matchpairs=(:),{:},[:],<:>

" 改行時の自動コメントをなしに
set formatoptions-=ro

" シンボリックなファイルを編集するとリンクが消されてしまうことがあったので
" 参照先を変数に上書き
let $MYVIMRC=$DOTFILES."/.vimrc"
let $MYGVIMRC=$DOTFILES."/.gvimrc"

" 分割方向を指定
set splitbelow
"set splitright

" BS can delete newline or indent
set backspace=indent,eol,start

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
    set rtp+=$GOROOT/misc/vim
    "set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
  endif

  if has('win32')
    set rtp+=~/.vim
    set rtp+=~/.vim/after
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
  set undodir=~/.vim/undo
  set undofile
endif
" }}}

" Indent {{{
" Use space indent of tab to make indent
set expandtab

" Width of tab
set tabstop=4

" How many spaces to each indent level
set shiftwidth=4

"testing now {{{
" Automatically adjust indent
set autoindent

" Automatically indent when insert a new line
set smartindent
" }}}
"
set smarttab
" }}}

" Search {{{

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

" }}}

" VimScript {{{

" filetype 調査
" :verbose :setlocal filetype?
"
" Set encoding when open file {{{
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Utf16 edit<bang> ++enc=utf-16 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>
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
"nnoremap <expr> <A-p> _(":%s/<Cursor>/ほむ/g")
"nnoremap <expr> <A-p> ":%s//ほむ/g\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>"
function! s:move_cursor_pos_mapping(str, ...)
  let left = get(a:, 1, "<Left>")
  let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
  return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
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
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" Leaderを設定
" 参考: http://deris.hatenablog.jp/entry/2013/05/02/192415
noremap [myleader] <nop>
map <Space> [myleader]
"noremap map \ , "もとのバインドをつぶさないように

if has('win32')
else
  let mapleader = "_"
endif

" 有効な用途が見えるまであけとく
noremap s <nop>
noremap S <nop>
noremap <C-s> <nop>
noremap <C-S> <nop>

" Easy to esc
noremap [easy_to_esc] <nop>
if has('mac')
  inoremap <C-]> <Esc>
  nnoremap <C-]> <Esc>
  vnoremap <C-]> <Esc>
  cnoremap <C-]> <Esc>
else
  inoremap <C-\> <Esc>
  nnoremap <C-\> <Esc>
  vnoremap <C-\> <Esc>
  cnoremap <C-\> <Esc>
endif


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
nnoremap [myleader]g :e $MYGVIMRC<CR>

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

" 見た目の行移動をやりやすく
nnoremap j  gj
nnoremap k  gk

" 関数単位で移動
noremap <C-p> [[
noremap <C-n> ]]

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

set relativenumber
function! s:norelativenumber()
  augroup restore_op
    autocmd!
    autocmd CursorMoved * setlocal norelativenumber 
    autocmd CursorMoved * augroup restore_op | execute "autocmd!" | execute "augroup END"
    autocmd CursorHold * setlocal norelativenumber 
    autocmd CursorHold * augroup restore_op | execute "autocmd!" | execute "augroup END"
  augroup END
  return ""
endfunction

function! s:ToggleRelativeNumber()
  if &relativenumber
    set norelativenumber
    let &number = exists("b:togglernu_number") ? b:togglernu_number : 1
  else
    let b:togglernu_number = &number
    set relativenumber
  endif
  redraw!  " these two lines required for omap

  return ''
endfunction

nnoremap <silent> [myleader]m :call <SID>ToggleRelativeNumber()<CR>
vnoremap <silent> [myleader]m :<C-U>call <SID>ToggleRelativeNumber()<CR>gv
onoremap <expr> [myleader]m <SID>ToggleRelativeNumber() . <SID>norelativenumber()

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

" Plugins {{{

" NeoBundle path setting {{{
if has('vim_starting')
  set rtp+=~/.vim/neobundle.vim
endif

" }}}

call neobundle#begin(expand('~/.vim/.bundle'))
" Neobundle plugin list {{{

" Language
" C++
NeoBundleLazy 'vim-jp/cpp-vim', {
      \   'autoload': {'filetypes': ['cpp']}
      \ }
NeoBundleLazy 'vim-scripts/opengl.vim', {
      \   'autoload': {'filetypes': ['cpp']}
      \ }
NeoBundleFetch 'Rip-Rip/clang_complete'
" NeoBundleLazy 'Rip-Rip/clang_complete', {
"            \   'autoload': {'filetypes': ['cpp']}
"            \ }
" NeoBundleFetch 'osyo-manga/vim-marching'
NeoBundleLazy 'osyo-manga/vim-marching', {
      \   'autoload': {'filetypes': ['cpp']}
      \ }

" C#
NeoBundleLazy 'nosami/Omnisharp', {
      \   'autoload': {'filetypes': ['cs']},
      \   'build': {
      \     'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
      \     'mac': 'xbuild server/OmniSharp.sln',
      \     'unix': 'xbuild server/OmniSharp.sln',
      \   }
      \ }

" Python
NeoBundleLazy 'davidhalter/jedi-vim', {
      \   'autoload': {'filetypes': ['python']}
      \ }

" Haskell
" indent
NeoBundleLazy 'kana/vim-filetype-haskell', {
      \   'autoload': {'filetypes': ['haskell']}
      \ }
" hilight
NeoBundleLazy 'dag/vim2hs', {
      \   'autoload': {'filetypes': ['haskell']}
      \ }
" reference
NeoBundleLazy 'ujihisa/ref-hoogle', {
      \   'autoload': {'filetypes': ['haskell']}
      \ }
NeoBundleLazy 'eagletmt/ghcmod-vim', {
      \   'autoload': {'filetypes': ['haskell']}
      \ }
NeoBundleLazy 'eagletmt/neco-ghc', {
      \   'autoload': {'filetypes': ['haskell']}
      \ }
NeoBundle 'ujihisa/unite-haskellimport'


" shader
NeoBundleLazy 'vim-scripts/glsl.vim', {
      \   'autoload': {'filetypes': ['glsl']}
      \ }
"NeoBundleLazy 'bundai223/FX-HLSL', {
      \   'autoload': {'filetypes': ['fx']}
      \ }

" MarkDown
NeoBundleLazy 'kannokanno/previm', {
      \   'autoload' : {'filetypes': ['markdown']}
      \ }

" tmux
NeoBundleLazy 'zaiste/tmux.vim', {
      \   'autoload': {'filetypes': ['tmux']}
      \ }

" Ocaml
NeoBundleLazy 'cohama/the-ocamlspot.vim', {
      \   'autoload' : {'filetypes' : ['ocaml']}
      \ }

" Golang
NeoBundleLazy 'vim-jp/vim-go-extra', {
      \   'autoload' : {'filetypes' : ['go']}
      \ }

" Nginx
NeoBundleLazy 'vim-scripts/nginx.vim', {
      \   'autoload' : {'filetypes' : ['nginx']}
      \ }


" textobj
NeoBundle 'tpope/vim-surround'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'osyo-manga/vim-textobj-multitextobj'

" utility
NeoBundle 'mattn/emmet-vim' " html ?
NeoBundle 'mattn/gist-vim'
NeoBundle 'fuenor/qfixhowm'

NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/TweetVim'
NeoBundle 'koron/codic-vim'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'kana/vim-arpeggio'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/eskk.vim'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'deris/vim-rengbang'
NeoBundleFetch 'osyo-manga/vim-gift'
NeoBundleFetch 'osyo-manga/vim-automatic'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'osyo-manga/vim-reunions'
NeoBundle 'osyo-manga/vim-watchdogs', {
      \   'autoload' : {'commands' : ['WatchdogsRun'] },
      \ }

NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'gregsexton/gitv'
NeoBundle 'cohama/agit.vim'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'airblade/vim-gitgutter'
"NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'thinca/vim-scall'
NeoBundle 'thinca/vim-singleton' , {
      \   'gui' : 1
      \ }
NeoBundle 'tyru/restart.vim'
NeoBundle 'tyru/capture.vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'Shougo/vinarise'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'windows': 'nmake -f Make_msvc.mak nodebug=1',
      \     'mac'    : 'make -f make_mac.mak',
      \     'unix'   : 'make -f make_unix.mak',
      \   },
      \ }
NeoBundleLazy 'Shougo/vimfiler', {
      \   'autoload' : {'commands' : ['VimFilerBufferDir'] },
      \ }
NeoBundleLazy 'Shougo/vimshell', {
      \   'autoload' : {'commands' : ['VimShell', 'VimShellPop'] },
      \ }
NeoBundle 'LeafCage/foldCC'

" Cursor move
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'Lokaltog/vim-easymotion'

NeoBundleLazy 'supermomonga/jazzradio.vim', { 'depends' : [ 'Shougo/unite.vim' ] }

" unite
NeoBundleLazy 'Shougo/unite.vim',{
      \   'autoload' : {'commands' : ['Unite', 'UniteWithBufferDir'] },
      \ }
if has('mac')
  NeoBundle 'rizzatti/dash.vim' " for dash.app
endif

" unite source
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'osyo-manga/unite-fold'
NeoBundle 'osyo-manga/unite-quickrun_config'
NeoBundle 'osyo-manga/unite-qfixhowm'
NeoBundle 'bundai223/unite-outline-sources'
NeoBundle 'bundai223/unite-picktodo'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'tsukkee/unite-tag'
"NeoBundle 'bundai223/unite-find'
if has('mac')
  NeoBundle 'choplin/unite-spotlight'
  NeoBundle 'itchyny/dictionary.vim'
endif

"=====================================
" private snippet
NeoBundle 'bundai223/mysnip'
NeoBundle 'bundai223/myvim_dict'

"=====================================
" other
NeoBundle 'vim-jp/vital.vim'
NeoBundle 'vim-jp/vimdoc-ja'

"=====================================
" Color Scheme
NeoBundleFetch 'bundai223/vim-colors-solarized'
NeoBundleLazy 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/newspaper.vim'
NeoBundle 'w0ng/vim-hybrid'


" }}}
call neobundle#end()

filetype plugin indent on

" Plugin setting {{{

" Load on_source
" clever-f {{{
let s:bundle = neobundle#get('clever-f.vim')
function! s:bundle.hooks.on_source(bundle)
  nmap [myleader]f <Plug>(clever-f-reset)
  let g:clever_f_use_migemo = 1
endfunction

" }}}

" easymotion {{{
let s:bundle = neobundle#get('vim-easymotion')
function! s:bundle.hooks.on_source(bundle)
"  " ホームポジションに近いキーを使う
"  let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
"  " 「;」 + 何かにマッピング
"  let g:EasyMotion_leader_key="s"
"  " 1 ストローク選択を優先する
"  let g:EasyMotion_grouping=1
"  " カラー設定変更
"  hi EasyMotionTarget ctermbg=none ctermfg=red
"  hi EasyMotionShade  ctermbg=none ctermfg=blue
endfunction

" }}}

" solarized {{{
let s:bundle = neobundle#get('vim-colors-solarized')
function! s:bundle.hooks.on_source(bundle)
  "let g:solarized_visibility="high"

  " colorschemeでの設定を上書きするため
  " colorschemeより後で記述
  " solarized darkでのgitgutter表示調整
  highlight GitGutterAdd ctermfg=green guifg=darkgreen
  highlight GitGutterChange ctermfg=yellow guifg=darkyellow
  highlight GitGutterDelete ctermfg=red guifg=darkred
  highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

endfunction
"}}}

" marching {{{
let s:bundle = neobundle#get('vim-marching')
function! s:bundle.hooks.on_source(bundle)
  " 非同期ではなくて同期処理で補完する
  let g:marching_backend = "clang_command"
  "let g:marching_backend = "sync_clang_command"

  " オプションの設定
  " これは clang のコマンドに渡される
  "let g:marching_clang_command_option="-std=c++1y"


  " neocomplete.vim と併用して使用する場合
  " neocomplete.vim を使用すれば自動補完になる
  let g:marching_enable_neocomplete = 1

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

  imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)
endfunction

" clang_complete
let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)

  let g:clang_auto_select     = 0
  let g:clang_use_library     = 1
  " exp)  let g:clang_exec        = 'C:\path\to\clang.exe'
  "       let g:clang_library_path= 'C:\path\to\(libclang.dll)'
  "       let g:clang_user_options= '2> NUL || exit 0"'
  if has('win32')
    let g:clang_complete_auto = 0
    let g:clang_exec          = 'clang'
    "let g:clang_library_path  = 'D:\Home\tool\clang\bin\'
    let g:clang_user_options  = '2> NUL || exit 0"'

  elseif has('mac')
    let g:clang_complete_auto = 1
    let g:clang_exec          = 'clang'
    let g:clang_library_path  = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
    let g:clang_user_options  = '2>/dev/null || exit 0"'

  elseif has('unix')
    let g:clang_complete_auto = 1
    let g:clang_exec          = '/usr/bin/clang'
    let g:clang_library_path  = '/usr/local/lib/'
    let g:clang_user_options  = '2>/dev/null || exit 0"'

  endif
endfunction
"}}}

" vimfiler {{{
let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer=1
  let g:vimfiler_safe_mode_by_default=0

  " Disable default keymap.
  "let g:vimfiler_no_default_key_mappings=1

  " Not write statusline.
  let g:vimfiler_force_overwrite_statusline=0
endfunction
"}}}

" vimshell {{{
let s:bundle = neobundle#get('vimshell')
function! s:bundle.hooks.on_source(bundle)
  if has('win32')
    let g:vimshell_interactive_cygwin_path='c:/cygwin/bin'
  endif
  let g:vimshell_user_prompt = '$USERNAME . "@" . hostname() . " " . fnamemodify(getcwd(), ":~")'
  let g:vimshell_prompt='$ '
  "let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
  let g:vimshell_split_command="split"

  let g:vimshell_vimshrc_path = expand($DOTFILES.'/.vimshrc')
endfunction
"}}}

" unite {{{
let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
  " 入力モードで開始
  let g:unite_enable_start_insert=1
  let g:unite_source_grep_max_candidates=1000

  " Not write statusline.
  let g:unite_force_overwrite_statusline=0

  " For silver searcher.
  " Use ag in unite grep source.
  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
    \ '--line-numbers --nocolor --nogroup --hidden --smart-case --ignore ' .
    \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
  endif
endfunction

" }}}

" unite-qfixhowm {{{
let s:bundle = neobundle#get('unite-qfixhowm')
function! s:bundle.hooks.on_source(bundle)
  " How to open new memo
  let g:unite_qfixhowm_new_memo_cmd = "tabnew"

  call unite#custom_source('qfixhowm', 'sorters', ['sorter_qfixhowm_updatetime', 'sorter_reverse'])

endfunction

" }}}

" singleton {{{
let s:bundle = neobundle#get('vim-singleton')
function! s:bundle.hooks.on_source(bundle)
  call singleton#enable()
endfunction
"}}}

" restart {{{
let s:bundle = neobundle#get('restart.vim')
function! s:bundle.hooks.on_source(bundle)
  nnoremap <silent> rs : <C-u> Restart <CR>
endfunction
"}}}

" Watchdogs {{{
let s:bundle = neobundle#get('vim-watchdogs')
function! s:bundle.hooks.on_source(bundle)
  call watchdogs#setup(g:quickrun_config)
endfunction
" }}}

" eskk {{{
let s:bundle = neobundle#get('eskk.vim')
function! s:bundle.hooks.on_source(bundle)
  set imdisable
  let g:eskk#dictionary = {
  \	'path': "~/repos/github.com/bundai223/dotfiles/util/SKK-JISYO.L",
  \	'sorted': 1,
  \	'encoding': 'euc-jp',
  \}

  if has('mac')
    let g:eskk#large_dictionary = {
    \	'path': "~/Library/Application\ Support/AquaSKK/SKK-JISYO.L",
    \	'sorted': 1,
    \	'encoding': 'euc-jp',
    \}
  elseif has('win32') || has('win64')
    let g:eskk#large_dictionary = {
    \	'path': "~/SKK_JISYO.L"
    \	'sorted': 1,
    \	'encoding': 'euc-jp',
    \}
  else
  endif

  let g:eskk_debug = 0
  let g:eskk_egg_like_newline = 1
  let g:eskk_revert_henkan_style = "okuri"
  let g:eskk_enable_completion = 0
endfunction

" }}}

" submode {{{
let s:bundle = neobundle#get('vim-submode')
function! s:bundle.hooks.on_source(bundle)
  " let g:submode_timeout = 0
  " TELLME: The above setting do not work.
  " Use the following instead of above.
  let g:submode_timeoutlen = 1000000

  let g:submode_keep_leaving_key=1

  " http://d.hatena.ne.jp/thinca/20130131/1359567419
  " https://gist.github.com/thinca/1518874
  " Window size mode.{{{
  call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
  call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
  call submode#map('winsize', 'n', '', '>', '<C-w>>')
  call submode#map('winsize', 'n', '', '<', '<C-w><')
  call submode#map('winsize', 'n', '', '+', '<C-w>+')
  call submode#map('winsize', 'n', '', '-', '<C-w>-')
  " }}}

  " Tab move mode.{{{
  call submode#enter_with('tabmove', 'n', '', 'gt', 'gt')
  call submode#enter_with('tabmove', 'n', '', 'gT', 'gT')
  call submode#map('tabmove', 'n', '', 't', 'gt')
  call submode#map('tabmove', 'n', '', 'T', 'gT')
  " }}}
endfunction

" }}}

" vim-arpeggio {{{
if neobundle#tap('vim-arpeggio')
  function! neobundle#tapped.hooks.on_source(bundle)
    call arpeggio#load() " arpeggioをこのvimrc内で有効にする。
    "Arpeggiomap fj <C-[>
  endfunction
  call neobundle#untap()
endif

"}}}

" vim-airline {{{
if neobundle#tap('vim-airline')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:airline_linecolumn_prefix = ''
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#branch#enabled = 0
    let g:airline#extensions#readonly#enabled = 0
    let g:airline_section_b =
          \ '%{airline#extensions#branch#get_head()}' .
          \ '%{""!=airline#extensions#branch#get_head()?("  " . g:airline_left_alt_sep . " "):""}' .
          \ '%{airline#extensions#readonly#get_mark()}' .
          \ '%t%( %M%)'
    let g:airline_section_c = ''
    let s:sep = " %{get(g:, 'airline_right_alt_sep', '')} "
    let g:airline_section_x =
          \ '%{strlen(&fileformat)?&fileformat:""}'.s:sep.
          \ '%{strlen(&fenc)?&fenc:&enc}'.s:sep.
          \ '%{strlen(&filetype)?&filetype:"no ft"}'
    let g:airline_section_y = '%3p%%'
    let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
    let g:airline_inactive_collapse = 0
    function! AirLineForce()
      let g:airline_mode_map.__ = ''
      let w:airline_render_left = 1
      let w:airline_render_right = 1
    endfunction
    augroup AirLineForce
      autocmd!
      autocmd VimEnter * call add(g:airline_statusline_funcrefs, function('AirLineForce'))
    augroup END
  endfunction
  call neobundle#untap()
endif

"}}}

" jazzradio {{{
" ref) http://blog.supermomonga.com/articles/vim/jazzradio-vim-released.html
" brew install mplayer / sudo apt-get install -y mplayer
" :JazzradioUpdateChannels

if neobundle#tap('jazzradio.vim')
  call neobundle#config({
        \   'autoload' : {
        \     'unite_sources' : [
        \       'jazzradio'
        \     ],
        \     'commands' : [
        \       'JazzradioUpdateChannels',
        \       'JazzradioStop',
        \       {
        \         'name' : 'JazzradioPlay',
        \         'complete' : 'customlist,jazzradio#channel_id_complete'
        \       }
        \     ],
        \     'function_prefix' : 'jazzradio'
        \   }
        \ })
endif
" }}}

" Dash.app {{{
if neobundle#tap('dash.vim')
  function! neobundle#tapped.hooks.on_source(bundle)
    function! s:dash(...)
        if len(a:000) == 1 && len(a:1) == 0
            echomsg 'No keyword'
        else
            let ft = &filetype
            if &filetype == 'python'
                let ft = 'py'
                let ft = ft.'2'
            endif
            let ft = ft.':'
            let word = len(a:000) == 0 ? input('Keyword: ', ft.expand('<cword>')) : ft.join(a:000, ' ')
            call system(printf("open dash://'%s'", word))
        endif
    endfunction

    command! -nargs=* Dash call <SID>dash(<f-args>)

    nnoremap [myleader]d :call <SID>dash(expand('<cword>'))<CR>
  endfunction
endif

"}}}

" automatic {{{
if neobundle#tap('vim-automatic')
  function! neobundle#tapped.hooks.on_source(bundle)
    nnoremap <silent> <plug>(quit) :<C-u>q<cr>
    function! s:my_temporary_window_init(config, context)
      nmap <buffer> <C-[> <plug>(quit)
    endfunction

    let g:automatic_default_match_config = {
          \   'is_open_other_window' : 1,
          \ }
    let g:automatic_default_set_config = {
          \   'height' : '60%',
          \   'move' : 'bottom',
          \   'apply' : function('s:my_temporary_window_init')
          \ }
    let g:automatic_config = [
          \   { 'match' : { 'buftype' : 'help' } },
          \   { 'match' : { 'bufname' : '^.vimshell' } },
          \   { 'match' : { 'bufname' : '^.unite' } },
          \   {
          \     'match' : {
          \       'filetype' : '\v^ref-.+',
          \       'autocmds' : [ 'FileType' ]
          \     }
          \   },
          \   {
          \     'match' : {
          \       'bufname' : '\[quickrun output\]',
          \     },
          \     'set' : {
          \       'height' : 8,
          \     }
          \   },
          \   {
          \     'match' : {
          \       'autocmds' : [ 'CmdwinEnter' ]
          \     },
          \     'set' : {
          \       'is_close_focus_out' : 1,
          \       'unsettings' : [ 'move', 'resize' ]
          \     },
          \   }
          \ ]
  endfunction

  call neobundle#untap()
endif

"}}}


" Load not on_source
" switch.vim {{{
let g:variable_style_switch_definitions = [
        \   {
        \     '\<[a-z0-9]\+_\k\+\>': {
        \       '_\(.\)': '\U\1'
        \     },
        \     '\<[a-z0-9]\+[A-Z]\k\+\>': {
        \       '\([A-Z]\)': '_\l\1'
        \     },
        \     '=': {
        \       '==': '!='
        \     },
        \     '!': {
        \       '!=': '=='
        \     },
        \   }
        \ ]
nnoremap [myleader]+ :call switch#Switch(g:variable_style_switch_definitions)<CR>
nnoremap [myleader]- :Switch<CR>

" }}}

"VimでGitk的なツール
" Gitv
let g:Gitv_DoNotMapCtrlKey = 1

" Agit
" 自動で差分の更新をしないようにする。
let g:agit_enable_auto_show_commit = 0

" vim-gitgutter
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" lightline.vim {{{
      "\ 'colorscheme': 'wombat',
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'plugin', 'paste' ],
      \     [ 'fugitive', 'gitgutter', 'filename' ],
      \     [ 'pwd' ]
      \   ],
      \   'right': [
      \     ['lineinfo', 'syntastic'],
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
      \   'syntastic': 'SyntasticStatuslineFlag',
      \   'charcode': 'MyCharCode',
      \   'fileformat': 'MyFileformat',
      \   'fileencoding': 'MyFileencoding',
      \   'filetype': 'MyFiletype'
      \ },
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &readonly ? 'x'  : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%') ? expand('%') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
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
  return  winwidth(0) <= 60 ? '' :
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

" }}}

" vital {{{
let g:V = vital#of('vital')

" }}}

" foldCC {{{
set foldtext=FoldCCtext()
set fillchars=vert:\l
set foldcolumn=2

" }}}

" Over vim {{{
" ちょっとあやしい
" http://leafcage.hateblo.jp/
"cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'

"}}}

" quickhl {{{
let g:quickhl_manual_enable_at_startup = 1

nmap <Leader>h <Plug>(quickhl-manual-this)
xmap <Leader>h <Plug>(quickhl-manual-this)
nmap <Leader>H <Plug>(quickhl-manual-reset)
xmap <Leader>H <Plug>(quickhl-manual-reset)
"nmap <Leader>j <Plug>(quickhl-match)

"}}}

" smartinput{{{
let g:smartinput_no_default_key_mappings = 1

" <CR>をsmartinputの処理付きの物を指定する版
call smartinput#map_to_trigger( 'i', '<Plug>(physical_key_CR)', '<CR>', '<CR>')
imap <CR> <Plug>(physical_key_CR)

" 改行時に行末スペースを削除する
call smartinput#define_rule({
      \   'at': '\s\+\%#',
      \   'char': '<CR>',
      \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
      \   })

" 対になるものの入力。無駄な空白は削除
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({ 'at': '\%#',    'char': '(', 'input': '(<Space>', })
call smartinput#define_rule({ 'at': '( *\%#', 'char': ')', 'input': '<BS>)', })
call smartinput#define_rule({ 'at': '\%#',    'char': '{', 'input': '{<Space>', })
call smartinput#define_rule({ 'at': '{ *\%#', 'char': '}', 'input': '<BS>}', })
call smartinput#define_rule({ 'at': '\%#',    'char': '[', 'input': '[<Space>', })
call smartinput#define_rule({ 'at': '[ *\%#', 'char': ']', 'input': '<BS>]', })

"}}}

" vimshell {{{
nnoremap <silent> <Leader>s : <C-u> VimShell<CR>

" }}}

" neocomplete {{{
" disable AutoComplPop
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default'  : '',
      \ 'vimshell' : '~/.vimshell_hist',
      \ 'cpp'      : '~/.vim/.bundle/myvim_dict/cpp.dict',
      \ 'squirrel' : '~/.vim/.bundle/myvim_dict/squirrel.dict',
      \ 'groovy'   : '~/.vim/.bundle/myvim_dict/gradle.dict',
      \ 'gitcommit': '~/.vim/.bundle/myvim_dict/gitcommit.dict',
      \ }

" Define keyword.
let g:neocomplete#keyword_patterns = get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#mappings()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" omni pattern
let g:neocomplete#sources#omni#input_patterns = get(g:, 'neocomplete#sources#omni#input_patterns', {})
"let g:neocomplete#sources#omni#input_patterns.ruby      = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby      = ''
let g:neocomplete#sources#omni#input_patterns.php       = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.go        = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#sources#omni#input_patterns.squirrel  = '[^.]\.\%(\u\{2,}\)\?'

" force omni pattern
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns = get(g:, 'neocomplete#force_omni_input_patterns', {})
let g:neocomplete#force_omni_input_patterns.python      = '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.cs          = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#force_omni_input_patterns.c           = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#force_omni_input_patterns.cpp         = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#force_omni_input_patterns.objc        = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.objcpp      = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.java        = '\%(\h\w*\|)\)\.\w*'

" external omni func
let g:neocomplete#sources#omni#functions = get(g:, 'neocomplete#sources#omni#functions', {})
let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'
" }}}

" neosnippet {{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" Tabでスニペット選択 Spaceで選択中スニペット展開
"imap <expr><Space> pumvisible() ? neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Space>" : "\<Space>"
"imap <expr><Space> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Space>"
"smap <expr><Space> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Space>"

" For snippet_complete marker
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" path to mysnippet
let g:neosnippet#snippets_directory='~/.vim/.bundle/mysnip'
" }}}

" unite {{{
" <Space>をuniteのキーに
nnoremap [unite] <Nop>
nmap <C-u> [unite]

" source
" unite file
nnoremap <silent> [unite]/   :<C-u>Unite -input=/ -buffer-name=file_root file<CR>
nnoremap <silent> [unite]f   :<C-u>UniteWithBufferDir -buffer-name=file_current file<CR>
nnoremap <silent> [unite]d   :<C-u>Unite -input=~/.vim/ -buffer-name=file_dotfiles file<CR>
nnoremap <silent> [unite]m   :<C-u>Unite -buffer-name=multi file_mru file buffer<CR>
nnoremap <silent> [unite]o   :<C-u>Unite -buffer-name=outline -no-quit -wrap outline<CR>
nnoremap <silent> [unite]t   :<C-u>Unite -buffer-name=todo -no-quit picktodo<CR>
nnoremap <silent> [unite]tw  :<C-u>Unite -buffer-name=tweet tweetvim<CR>
nnoremap <silent> [unite]g   :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
nnoremap <silent> [unite]ns  :<C-u>Unite -buffer-name=snippet neosnippet<CR>
nnoremap <silent> [unite]ens :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
nnoremap <silent> [unite]nb  :<C-u>Unite -buffer-name=neobundle neobundle/update:all -auto-quit -keep-focus -log<CR>
nnoremap <silent> [unite]b   :<C-u>Unite -buffer-name=buffer buffer<CR>
nnoremap <silent> [unite]c   :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>
nnoremap <silent> [unite]s   :<C-u>Unite source -vertical<CR>
nnoremap <silent> [unite]l   :<C-u>Unite locate<CR>
nnoremap <silent> [unite]q   :<C-u>Unite qfixhowm/new qfixhowm:nocache -hide-source-names<CR>

vnoremap <silent> [unite]aa  :<C-u>Unite alignta:arguments<CR>
vnoremap <silent> [unite]ao  :<C-u>Unite alignta:options<CR>

" unite resume
nnoremap <silent> [unite]r   :<C-u>UniteResume<CR>

if has('mac')
  nnoremap <silent> [unite]<Space> :<C-u>Unite spotlite<CR>
endif


autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
endfunction" }}}

" vimfiler {{{
nnoremap <silent> <Leader>f : <C-u> VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

" }}}

" textobj-multiblock {{{
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)

" }}}

" alignta {{{
let g:alignta_default_options   = '<<<0:0'
let g:alignta_default_arguments = '\s'
vnoremap <Leader>al :Alignta<Space>
vnoremap <Leader>aa :Alignta<CR>
vnoremap <Leader>ae :Alignta <<<1 =<CR>
vnoremap <Leader>a= :Alignta <<<1 =<CR>
vnoremap <Leader>a, :Alignta ,<CR>
vnoremap <Leader>a> :Alignta =><CR>

let g:unite_source_alignta_preset_arguments = [
      \ ["Align at '='", '=>\='],
      \ ["Align at ':'", '01 :'],
      \ ["Align at '|'", '|'   ],
      \ ["Align at ')'", '0 )' ],
      \ ["Align at ']'", '0 ]' ],
      \ ["Align at '}'", '}'   ],
      \ ["Align at '>'", '0 >' ],
      \ ["Align at '('", '0 (' ],
      \ ["Align at '['", '0 [' ],
      \ ["Align at '{'", '{'   ],
      \ ["Align at '<'", '0 <' ],
      \ ["Align first spaces", '0 \s/1' ],
      \]

let g:unite_source_alignta_preset_options = [
      \ ["Justify Left",      '<<' ],
      \ ["Justify Center",    '||' ],
      \ ["Justify Right",     '>>' ],
      \ ["Justify None",      '==' ],
      \ ["Shift Left",        '<-' ],
      \ ["Shift Right",       '->' ],
      \ ["Shift Left  [Tab]", '<--'],
      \ ["Shift Right [Tab]", '-->'],
      \ ["Margin 0:0",        '0'  ],
      \ ["Margin 0:1",        '01' ],
      \ ["Margin 1:0",        '10' ],
      \ ["Margin 1:1",        '1'  ],
      \]

" }}}

" PrettyPrint {{{
" 変数の中身を表示
command! -nargs=+ GlobalVars PP filter(copy(g:), 'v:key =~# "^<args>"')
command! -nargs=+ BufVars PP filter(copy(b:), 'v:key =~# "^<args>"')

" }}}

" caw {{{
nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)

" }}}

" quickrun {{{
" vimprocで起動
" バッファが空なら閉じる
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \   "runner" : "vimproc",
      \   "runner/vimproc/updatetime" : 60,
      \   "outputter/buffer/split" : ":botright",
      \   "outputter/buffer/close_on_empty" : 1,
      \}
"let g:quickrun_config = {
"\ "_" : {
"\   "runner" : "vimproc",
"\   "runner/vimproc/updatetime" : 60,
"\   "outputter/buffer/split" : ":botright",
"\   "outputter/buffer/close_on_empty" : 1,
"\ },
"\ "cpp" : {
"\   "type" : "cpp/clang++"
"\ },
"\ "cpp/clangc++": {
"\   "command": "clang++",
"\   "exec": ['%c %o %s -o %s:p:r', '%s:p:r %a'],
"\   "tempfile": '%{tempname()}.cpp',
"\   "hook/sweep/files": ['%S:p:r'],
"\ },
"\}


"" <Space>qで強制終了
"nnoremap <expr><silent><Space>q quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"}}}

" anzu {{{
" " echo statusline to search index
" " n や N の代わりに使用します。
" nmap n <Plug>(anzu-n)
" nmap N <Plug>(anzu-N)
" nmap * <Plug>(anzu-star)
" nmap # <Plug>(anzu-sharp)
"
" " ステータス情報を statusline へと表示する
" set statusline=%{anzu#search_status()}

" こっちを使用すると
" 移動後にステータス情報をコマンドラインへと出力を行います。
" statusline を使用したくない場合はこっちを使用して下さい。
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

"}}}

" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" }}}

" qfixhowm {{{
let howm_dir = '~/.vim/howm'
let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
let howm_fileencoding    = 'utf-8'
let howm_fileformat      = 'unix'

let QFixHowm_Key = 'g'
let QFix_PreviewEnable = 0
let QFix_CursorLine = 0

" }}}

" emmet {{{
let g:user_emmet_leader_key = '<c-e>'

" }}}

" }}}

" }}}

" Looks setting {{{

" Folding {{{
set foldenable

" Explicitly fold begin and end
" e.g. {{{ folding code }}}
set foldmethod=marker

" }}}

" show line number
set number
set relativenumber

" show invisible chars
set list
" tab 行末spaceを表示
set listchars=tab:^\ ,trail:~,extends:>,precedes:<,nbsp:%

" always show tab
set showtabline=2

" fix zenkaku char's width
set ambiwidth=double

" 再描画コマンド実行中はなし
set lazyredraw

" statusline常に表示
set laststatus=2

set cursorline

" 自動折り返しなし
set nowrap

" Color scheme setting {{{
set background=dark
set t_Co=256
colorscheme desert
"colorscheme solarized

" IMEの状態でカーソル色変更 {{{
"IME状態に応じたカーソル色を設定
if has('multi_byte_ime')
  highlight Cursor guifg=Black guibg=#cccccc gui=bold
  highlight CursorIM guifg=NONE guibg=Violet gui=bold
endif
" }}}

" 全角スペースを表示 {{{
highlight ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=red
au BufNew,BufRead * match ZenkakuSpace /　/
" }}}

syntax on
" }}}

" }}}

" Toggle tmux status bar {{{
"if !has('gui_running') && $TMUX !=# ''
"  augroup Tmux
"    autocmd!
"    autocmd VimEnter,VimLeave * silent !tmux set status
"  augroup END
"endif
" }}}

" 取り敢えずここで
if !exists("loaded_matchit")
  source $VIMRUNTIME/macros/matchit.vim
endif

" ローカル設定を読み込む
if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
endif


