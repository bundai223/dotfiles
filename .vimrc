" Common setting {{{

" 変数を読み込む
if filereadable(expand('~/.my_local_vimrc_env'))
    source ~/.my_local_vimrc_env
endif

scriptencoding utf-8
set nocompatible

" help日本語・英語優先
set helplang=ja,en
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
set clipboard=unnamed,autoselect

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

" Default comment format is nothing
" Almost all this setting override by filetype setting
" e.g. cpp: /*%s*/
"      vim: "%s
set commentstring=%s

if has('vim_starting')
  " Goのpath
  if $GOROOT != ''
    set rtp+=$GOROOT/misc/vim
    set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
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

" tagファイルの検索パス指定
" カレントから親フォルダに見つかるまでたどる
" tagの設定は各プロジェクトごともsetlocalする
set tags=tags;

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
nnoremap <C-\> :<C-u>CopyCurrentPath<CR>
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

" Leaderを設定
" 参考: http://deris.hatenablog.jp/entry/2013/05/02/192415
noremap [myleader] <nop>
map <Space> [myleader]
"noremap map \ , "もとのバインドをつぶさないように

if has('mac')
  let mapleader = "_"
endif


" Easy to esc
imap <C-@> <C-[>
nmap <C-@> <C-[>
vmap <C-@> <C-[>
cmap <C-@> <C-[>

" Easy to cmd mode
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Reload
nnoremap <F5> :source %<CR>

" 直前のバッファに移動
nnoremap <Leader>b :b#<CR>

" Insert date
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" Easy to help
"nnoremap <C-u> :<C-u>help<Space>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" カレントパスをバッファに合わせる
nnoremap <silent><Leader><Space> :<C-u>cd %:h<CR>:pwd<CR>

" Quick splits
nnoremap [myleader]_ :sp<CR>
nnoremap [myleader]<Bar> :vsp<CR>

" Insert space in normal mode
"nnoremap <C-l> i<Space><Esc><Right>
"nnoremap <C-h> i<Space><Esc>

" Copy and paste {{{
" Yank to end
nnoremap Y y$

" C-y Paste when insert mode
inoremap <C-y> <C-r>*

" BS act like normal backspace
nnoremap <BS> X

" }}}

" Tab moving {{{
nnoremap gn :<C-u>tabnew<CR>
nnoremap ge :<C-u>tabnew +edit `=tempname()`<CR>
"nnoremap ge :<C-u>tabedit<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT

" }}}

" Cursor moving {{{
" 空行単位で移動
nnoremap <C-j> }
nnoremap <C-k> {
vnoremap <C-j> }
vnoremap <C-k> {

" nnoremap <C-w><C-j> <C-w>+
" nnoremap <C-w><C-k> <C-w>+
" nnoremap <C-w><C-h> <C-w>>
" nnoremap <C-w><C-l> <C-w><

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
nnoremap <Leader>/ :noh <CR>

" 置換
nnoremap <expr> <Leader>s _(":s/<Cursor>//g")
nnoremap <expr> <Leader>S _(":%s/<Cursor>//g")

" 検索結果をウインドウ真ん中に
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" Fold moving {{{
noremap [fold] <nop>
nmap [myleader] [fold]

" Move fold
noremap [fold]j zj
noremap [fold]k zk

" Move fold begin line
noremap [fold]n ]z
noremap [fold]p [z

" Fold open and close
noremap [fold]c zc
noremap [fold]o zo
noremap [fold]a za

" All fold close
noremap [fold]m zM

" Other fold close
noremap [fold]i zMzv

" Make fold
noremap [fold]r zR
noremap [fold]f zf
"}}}

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

  call neobundle#rc(expand('~/.vim/.bundle'))
endif

" }}}

" Neobundle list {{{

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


" Haxe
"NeoBundleLazy 'jdonaldson/vaxe'

" shader
NeoBundleLazy 'vim-scripts/glsl.vim', {
            \   'autoload': {'filetypes': ['glsl']}
            \ }
"NeoBundleLazy 'bundai223/FX-HLSL', {
            \   'autoload': {'filetypes': ['fx']}
            \ }

" MarkDown
NeoBundleLazy 'rcmdnk/vim-markdown', {
            \   'autoload' : {'filetypes': ['markdown']}
            \ }
NeoBundleLazy 'kannokanno/previm', {
            \   'autoload' : {'filetypes': ['markdown']}
            \ }


" textobj
NeoBundle 'tpope/vim-surround'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'osyo-manga/vim-textobj-multitextobj'

" utl
NeoBundle 'fuenor/qfixhowm'

NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/TweetVim'
NeoBundle 'koron/codic-vim'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/eskk.vim'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'deris/vim-rengbang'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'osyo-manga/vim-reunions'
NeoBundle 'osyo-manga/vim-watchdogs', {
        \   'autoload' : {'commands' : ['WatchdogsRun'] },
        \ }

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'thinca/vim-ref'
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

" unite
NeoBundleLazy 'Shougo/unite.vim',{
            \   'autoload' : {'commands' : ['Unite', 'UniteWithBufferDir'] },
            \ }

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
if has('mac')
  NeoBundle 'choplin/unite-spotlight'
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
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/newspaper.vim'
NeoBundle 'w0ng/vim-hybrid'

"NeoBundleLazy 'itchyny/calendar.vim', {
"            \   'autoload' : {'commands' : ['Calendar'] },
"            \ }
"
"" Calendar {{{
"let s:bundle = neobundle#get('calendar')
"function! s:bundle.hooks.on_source(bundle)
"  let g:calendar_google_calendar=1
"endfunction

" }}}

" molokai {{{
let s:bundle = neobundle#get('molokai')
function! s:bundle.hooks.on_source(bundle)
  " Color scheme setting {{{
  set t_Co=256
"  let g:molokai_original = 1
"  let g:rehash256 = 1

"  set background=dark
  colorscheme molokai

  " IMEの状態でカーソル色変更 {{{
  " colorschemeでの設定を上書きするため
  " colorschemeより後で記述
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

  " }}}

  " ハイライトのオン
  syntax on

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
if has('win32')
  call singleton#enable()
endif
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

" Vim-markdown {{{
let s:bundle = neobundle#get('vim-markdown')
function! s:bundle.hooks.on_source(bundle)
  let g:vim_markdown_folding_disabled=1
endfunction
" }}}

" eskk {{{
let s:bundle = neobundle#get('eskk.vim')
function! s:bundle.hooks.on_source(bundle)
  let g:eskk_dictionary = '~/.skk-jisyo'

  if has('mac')
  	let g:eskk_large_dictionary = "~/Library/Application\ Support/AquaSKK/SKK-JISYO.L"
  elseif has('win32') || has('win64')
  	let g:eskk_large_dictionary = "~/SKK_JISYO.L"
  else
  endif

  let g:eskk_debug = 0
  let g:eskk_egg_like_newline = 1
  let g:eskk_revert_henkan_style = "okuri"
  let g:eskk_enable_completion = 0
endfunction

" }}}

" }}}

filetype plugin indent on

" Plugin setting {{{

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

nmap [myleader]h <Plug>(quickhl-manual-this)
xmap [myleader]h <Plug>(quickhl-manual-this)
nmap [myleader]H <Plug>(quickhl-manual-reset)
xmap [myleader]H <Plug>(quickhl-manual-reset)
"nmap [myleader]j <Plug>(quickhl-match)

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
nnoremap <silent> [myleader]vs : <C-u> VimShell<CR>

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
    \ }

" Define keyword.
let g:neocomplete#keyword_patterns = get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
"imap <expr><CR> (neocomplete#smart_close_popup())."\<Plug>(physical_key_CR)"
"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return neocomplete#smart_close_popup() . "\<CR>"
"endfunction
" <TAB>: completion.
inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

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
"let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'
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
" ファイル一覧
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]d :<C-u>Unite -input=/Home/labo/dotfiles/. -buffer-name=dotfiles file<CR>
" ファイルいっぱい列挙
"nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=history file_mru<CR>
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=multi file_mru file buffer<CR>
" アウトライン
"nnoremap <silent> [unite]o :<C-u>Unite -vertical -winwidth=30 -buffer-name=outline -no-quit -wrap outline<CR>
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -no-quit -wrap outline<CR>
" todo
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=todo -no-quit picktodo<CR>
" グレップ
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
" スニペット探し
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=snippet snippet<CR>
nnoremap <silent> [unite]su :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
" NeoBundle更新
nnoremap <silent> [unite]nb :<C-u>Unite -buffer-name=neobundle neobundle/update:all -auto-quit -keep-focus -log<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffer buffer<CR>
" Color Scheme
nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>
" source 一覧
nnoremap <silent> [unite]s :<C-u>Unite source -vertical<CR>

" alignta(visual)
vnoremap <silent> [unite]aa :<C-u>Unite alignta:arguments<CR>
vnoremap <silent> [unite]ao :<C-u>Unite alignta:options<CR>

" qfixhowm
nnoremap <silent> [unite]q :<C-u>Unite qfixhowm/new qfixhowm:nocache -hide-source-names<CR>

" UniteBufferの復元
nnoremap <silent> [unite]r :<C-u>UniteResume<CR>
" }}}

" vimfiler {{{
nnoremap <silent> [myleader]vf : <C-u> VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

" }}}

" gtags {{{
"nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
"nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
"nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>

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

" vim-airline で表示してほしくない場合は 0 を設定して下さい。
let g:airline#extensions#anzu#enabled = 0

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

" line number relative
set relativenumber

" show invisible chars
set list
" tab 行末spaceを表示
"set listchars=tab:^\ ,trail:~
set listchars=tab:^\ ,trail:~,extends:>,precedes:<,nbsp:%

" always show tab
set showtabline=2

" fix zenkaku char's width
set ambiwidth=double

" 再描画コマンド実行中はなし
set lazyredraw

" statusline常に表示 for airline
set laststatus=2

set cursorline

" 自動折り返しなし
set nowrap

" }}}

" Toggle tmux status bar {{{
"if !has('gui_running') && $TMUX !=# ''
"  augroup Tmux
"    autocmd!
"    autocmd VimEnter,VimLeave * silent !tmux set status
"  augroup END
"endif
" }}}

" ローカル設定を読み込む
if filereadable(expand('~/.my_local_vimrc'))
    source ~/.my_local_vimrc
endif


