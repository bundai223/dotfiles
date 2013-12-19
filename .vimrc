
"--------------------------------------
" vimの基本的な設定

scriptencoding utf-8
set nocompatible

" help日本語・英語優先
set helplang=ja,en
" カーソル下の単語をhelp
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

" tabでスペースを挿入
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

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

" backspaceでなんでも消せるように
set backspace=indent,eol,start

set completeopt=menu,preview
" 補完でプレビューしない
"set completeopt=menuone,menu

" fold設定
set foldenable
set foldmethod=marker

" Goのpath
if $GOROOT != ''
  set rtp+=$GOROOT/misc/vim
  set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
endif

if has('unix')
  let $USERNAME=$USER
endif

if has('win32')
  set rtp+=~/.vim
  set rtp+=~/.vim/after
else
  " 自前で用意したものへの path
  set path=.,/usr/include,/usr/local/include
endif

" 履歴の保存
if has('persistent_undo' )
  set undodir=~/.vim/undo
  set undofile
endif

" Leaderを設定
"let mapleader=' '
if has('mac')
  map _ <Leader>
endif

"--------------------------------------
" 検索

" 検索時大文字小文字の区別なし
" ただし両方含むときは区別する
set ignorecase
set smartcase
" 検索を最後まで行ったら最初に戻る
set wrapscan
" インクリメンタルサーチ
set incsearch
" 検索文字の強調表示
set hlsearch
" tagファイルの検索パス指定
" カレントから親フォルダに見つかるまでたどる
" tagの設定は各プロジェクトごともsetlocalする
set tags=tags;

" 検索結果をウインドウ真ん中に
nnoremap n nzz

" 外部grepの設定
set grepprg=grep\ -nH

"--------------------------------------
" 表示の設定

"起動時のメッセージを消す
"set shortmess& shortmess+=I

" 行番号表示
set number
set relativenumber
" tab 行末spaceを表示
set list
set listchars=tab:^\ ,trail:~

" 再描画コマンド実行中はなし
set lazyredraw

" ハイライトのオン
if &t_Co > 2 || has('gui_running')
  syntax on
endif

" statusline常に表示 for airline
set laststatus=2

" 一定時間カーソルを移動しないとカーソルラインを表示 {{{
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
set nocursorline
" }}}

"--------------------------------------
" vim script

"" grep結果をquickfixに出力
" **** grep -iHn -R 'target string' target_path | cw ****
" **** vimgrep 'target string' target_path | cw ****
"

" grep
" exp ) :Grep word ./path
"        pathを省略した場合はカレントから再帰的に
"command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
"function! s:grep(args)
"    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
"    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
"    if len(getqflist()) != 0 | copen | endif
"endfunction

" filetype 調査
" :verbose :setlocal filetype?

" *.hを作成するときにインクルードガードを作成する {{{
au BufNewFile *.h call InsertHeaderHeader()
au BufNewFile *.cpp call InsertFileHeader()

function! IncludeGuard()
  let fl = getline(1)
  if fl =~ "^#if"
    return
  endif
   let gatename = substitute(toupper(expand("%:t")), "??.", "_", "g")
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  normal! gg
  execute "normal! i#ifndef _" . gatename . "_INCLUDED_"
  execute "normal! o#define _" . gatename .  "_INCLUDED_\<CR>\<CR>\<CR>\<CR>"
  execute "normal! Go#endif // _" . gatename . "_INCLUDED_\<CR>"
  4
endfunction

function! InsertFileHeader()
  let filename = expand("%:t")
  normal! gg
  execute "normal! i//**********************************************************************\<CR>"
  execute "normal! i//! @file   " . filename . "\<CR>"
  execute "normal! i//! @brief  describe\<CR>"
  execute "normal! i//**********************************************************************\<CR>"
endfunction

function! InsertHeaderHeader()
  call IncludeGuard()
  call InsertFileHeader()
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

"--------------------------------------
" pluginプラグイン
" plugin のバインドは<Space>ということにしてみよう

""" neobundle {{{
filetype off

if has('vim_starting')
  set rtp+=~/.vim/neobundle.vim

  call neobundle#rc(expand('~/.vim/.bundle'))
endif

" repository
"=====================================
" language
" C++
NeoBundleLazy 'vim-jp/cpp-vim', {
            \   'autoload': {'filetypes': ['cpp']}
            \ }
NeoBundleLazy 'vim-scripts/opengl.vim', {
            \   'autoload': {'filetypes': ['cpp']}
            \ }
NeoBundleLazy 'Rip-Rip/clang_complete', {
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
NeoBundleLazy 'davidhalter/jedi', {
            \   'autoload': {'filetypes': ['python']}
            \ }
NeoBundleLazy 'davidhalter/jedi-vim', {
            \   'autoload': {'filetypes': ['python']}
            \ }

" Ruby
NeoBundleLazy 'alpaca-tc/vim-endwise.git', {
            \   'autoload': {'filetypes': ['ruby']}
            \ }
NeoBundleLazy 'edsono/vim-matchit', {
            \   'autoload': {'filetypes': ['ruby']}
            \ }

" Haxe
"NeoBundleLazy 'jdonaldson/vaxe'

" shader
NeoBundleLazy 'vim-scripts/glsl.vim', {
            \   'autoload': {'filetypes': ['glsl']}
            \ }
"NeoBundleLazy 'bundai223/FX-HLSL', {
            \   'autoload': {'filetypes': ['fx']}
            \ }


"=====================================
" textobj
NeoBundle 'tpope/vim-surround'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock'

"=====================================
" utl
NeoBundle 'kana/vim-smartinput'
NeoBundle 'tyru/caw.vim'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'deris/vim-rengbang'
NeoBundle 'osyo-manga/vim-anzu'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'tyru/open-browser.vim'

NeoBundle 'bling/vim-airline'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs', {
        \   'autoload' : {'commands' : ['WatchdogsRun'] },
        \ }
NeoBundle 'Shougo/vinarise'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimproc', {
        \   'build': {
        \     'windows': 'nmake -f Make_msvc.mak nodebug=1',
        \     'mac'    : 'make -f make_mac.mak',
        \     'unix'   : 'make -f make_unix.mak',
        \   },
        \ }

" vimfiler
NeoBundleLazy 'Shougo/vimfiler', {
            \   'autoload' : {'commands' : ['VimFilerBufferDir'] },
            \ }
" vimshell
NeoBundleLazy 'Shougo/vimshell', {
            \   'autoload' : {'commands' : ['VimShell'] },
            \ }

" unite
NeoBundleLazy 'Shougo/unite.vim',{
            \   'autoload' : {'commands' : ['Unite', 'UniteWithBufferDir'] },
            \ }

" unite source
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-build'
NeoBundle 'osyo-manga/unite-fold'
NeoBundle 'osyo-manga/unite-quickrun_config'
NeoBundle 'bundai223/unite-outline-sources'
NeoBundle 'bundai223/unite-picktodo'
if has('mac')
  NeoBundle 'choplin/unite-spotlight'
endif

NeoBundleLazy 'tyru/restart.vim', {
            \   'gui' : 1,
            \   'autoload' : {
            \     'commands' : 'Restart'
            \  }
            \ }

NeoBundle 'thinca/vim-singleton' , {
        \   'gui' : 1
        \ }

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
    let g:my_clang_bin_path   = 'D:\Home\tool\clang\bin\'
    let g:clang_exec          = g:my_clang_bin_path.'clang.exe'
    let g:clang_library_path  = g:my_clang_bin_path
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

" vimfiler
let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer=1
  let g:vimfiler_safe_mode_by_default=0
endfunction

" vimshell
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

" unite
let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
  " 入力モードで開始
  let g:unite_enable_start_insert=1
  let g:unite_source_grep_max_candidates=1000
endfunction

" singleton
let s:bundle = neobundle#get('vim-singleton')
function! s:bundle.hooks.on_source(bundle)
  call singleton#enable()
endfunction
if has('win32')
  call singleton#enable()
endif

" restart
let s:bundle = neobundle#get('restart.vim')
function! s:bundle.hooks.on_source(bundle)
  nnoremap <silent> rs : <C-u> Restart <CR>
endfunction

" Watchdogs
let s:bundle = neobundle#get('vim-watchdogs')
function! s:bundle.hooks.on_source(bundle)
  call watchdogs#setup(g:quickrun_config)
endfunction
" }}}

filetype plugin on
filetype indent on


" vital
let g:V = vital#of('vital')

""" smartinput{{{
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

"""}}}

""" vimshell {{{
nnoremap <silent> <Space>vs : <C-u> VimShell<CR>
" }}}

""" neocomplete {{{
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

" force omni pattern
let g:neocomplete#sources#omni#input_patterns = get(g:, 'neocomplete#sources#omni#input_patterns', {})
"let g:neocomplete#sources#omni#input_patterns.ruby      = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.ruby      = ''
let g:neocomplete#sources#omni#input_patterns.python    = ''
let g:neocomplete#sources#omni#input_patterns.php       = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.c         = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.cpp       = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.cs        = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#sources#omni#input_patterns.go        = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#sources#omni#input_patterns.squirrel  = '[^.]\.\%(\u\{2,}\)\?'
" }}}

""" neosnippet {{{
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

""" unite {{{
" <Space>をuniteのキーに
nnoremap [unite] <Nop>
nmap <Space> [unite]

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

""" alignta(visual)
vnoremap <silent> [unite]aa :<C-u>Unite alignta:arguments<CR>
vnoremap <silent> [unite]ao :<C-u>Unite alignta:options<CR>


" UniteBufferの復元
nnoremap <silent> [unite]r :<C-u>UniteResume<CR>
" }}}

""" vimfiler {{{
"nnoremap <silent> vf : <C-u> VimFilerExplorer %:h<CR>
nnoremap <silent> <Space>vf : <C-u> VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>
" }}}

""" gtags {{{
"nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
"nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
"nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>
" }}}

""" textobj-multiblock {{{
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)
" }}}

""" alignta {{{
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

""" PrettyPrint {{{
" 変数の中身を表示
command! -nargs=+ GlobalVars PP filter(copy(g:), 'v:key =~# "^<args>"')
command! -nargs=+ BufVars PP filter(copy(b:), 'v:key =~# "^<args>"')
" }}}

""" caw {{{
nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)
" }}}

""" quickrun {{{
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

"""}}}

""" anzu {{{
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

"""}}}

""" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"""}}}

"--------------------------------------
" key mapping

" ESC押しやすく
imap <C-c> <C-[>
nmap <C-c> <C-[>
vmap <C-c> <C-[>
cmap <C-c> <C-[>

" コマンドモードに入りやすく
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" カーソル移動
" 空行単位で移動
" C-jがかぶってる…Escを別のにしたい
nnoremap <C-j> }
nnoremap <C-k> {
vnoremap <C-j> }
vnoremap <C-k> {

" 見た目の行移動をやりやすく
nnoremap j  gj
nnoremap k  gk
nnoremap gj j
nnoremap gk k

" 再読み込み
nnoremap <F5> :source %<CR>

" 使わないマッピングなしに
" ZZで全保存・全終了
" ZQで保存なし・全終了
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
" exモード？なし
nnoremap Q <Nop>

" 直前のバッファに移動
nnoremap <Leader>b :b#<CR>

" 日付マクロ
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" 連番マクロ
" <C-a>で加算
" <C-x>で減算
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor
nnoremap <silent> co : ContinuousNumber <C-a><CR>
vnoremap <silent> <C-a> : ContinuousNumber <C-a><CR>
vnoremap <silent> <C-x> : ContinuousNumber <C-x><CR>

" help補助
nnoremap <C-u> :<C-u>help<Space>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" ヤンクした単語で置換
nnoremap <silent>ciy  ciw<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap <silent>cy   ce <C-r>0<Esc>:let@/=@1<CR>:noh<CR>

" C-yでクリップボード貼り付け
inoremap <C-y> <C-r>*

" 移動系
inoremap <Leader>a  <Home>
inoremap <Leader>e  <End>
nnoremap <Leader>a  <Home>
nnoremap <Leader>e  <End>

" タブ関連
nnoremap gn :<C-u>tabnew<CR>
nnoremap ge :<C-u>tabedit<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT

" 関数単位で移動
noremap <C-p> [[
noremap <C-n> ]]

" 検索ハイライトをオフ
nnoremap <Leader>/ :noh <CR>

" カレントパスをバッファに合わせる
nnoremap <silent><Leader><Space> :<C-u>cd %:h<CR>:pwd<CR>

" カレントパスをクリップボードにコピー
command! CopyCurrentPath :call s:copy_current_path()
nnoremap <C-\> :<C-u>CopyCurrentPath<CR>
function! s:copy_current_path()
    if has('win32')
        let @*=substitute(expand('%:p'), '\\/', '\\', 'g')
    else
        let @*=expand('%:p')
    endif
endfunction

" エンコーディング指定オープン
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Utf16 edit<bang> ++enc=utf-16 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>

" 置換
nnoremap <expr> <Leader>s _(":s/<Cursor>//g")
nnoremap <expr> <Leader>S _(":%s/<Cursor>//g")

" 括弧を入力
" smartinputでよきに計らう必要あり
"inoremap ( ( 
"inoremap { { 
"inoremap [ [ 
"inoremap , , 

" C++ {{{
" headerとsourceを入れ替える
command! -nargs=0 CppHpp :call <SID>cpp_hpp()
function! s:cpp_hpp()
    let cpps = ['cpp', 'cc', 'cxx', 'c']
    let hpps = ['hpp', 'h']
    let ext  = expand('%:e')
    let base = expand('%:r')

    " ソースファイルのとき
    if count(cpps,ext) != 0
        for hpp in hpps
            if filereadable(base.'.'.hpp)
                execute 'edit '.base.'.'.hpp
                return
            endif
        endfor
    endif

    " ヘッダファイルのとき
    if count(hpps,ext) != 0
        for cpp in cpps
            if filereadable(base.'.'.cpp)
                execute 'edit '.base.'.'.cpp
                return
            endif
        endfor
    endif

    " なければ Unite で検索
    if executable('mdfind') && has('mac')
        execute "Unite spotlight -input=".base
    elseif executable('locate')
        execute "Unite locate -input=".base
    else
        echoerr "not found"
    endif

endfunction

" }}}

" ローカル設定を読み込む
if filereadable(expand('~/.my_local_vimrc'))
    source ~/.my_local_vimrc
endif

