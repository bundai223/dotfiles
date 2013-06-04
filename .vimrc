
"--------------------------------------
" vimの基本的な設定
"--------------------------------------
scriptencoding utf-8
set nocompatible

" 文字エンコード
set encoding=utf-8
set fileencoding=utf-8
" こいつのせいで<C-o>などでのジャンプがおかしくなってた
" 原因はよくわからない
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set fileformat=unix
set fileformats=dos,unix

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
autocmd FileType * setlocal formatoptions-=ro

" シンボリックなファイルを編集するとリンクが消されてしまうことがあったので
" 参照先を変数に上書き
let $MYVIMRC="~/github/dotfiles/.vimrc"
let $MYGVIMRC="~/github/dotfiles/.gvimrc"

" 分割方向を指定
set splitbelow
"set splitright

set completeopt=menu,preview
" Goのpath
if $GOROOT != ''
    set runtimepath+=$GOROOT/misc/vim
    exe "set runtimepath+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
endif


"--------------------------------------
" 基本的な設定
"--------------------------------------
if has('unix')
    let $USERNAME=$USER
endif

" 履歴の保存
"if has('persistent_undo' )
"    set undodir=~/.vim/undo
"    set undofile
"endif

" Leaderを設定
"let mapleader=' '
if has('mac')
    map _ <Leader>
endif

"--------------------------------------
" 検索
"--------------------------------------
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
"--------------------------------------
" 行番号表示
"set number
set relativenumber
" tab 行末spaceを表示
set list
set listchars=tab:^\ ,trail:~

" ハイライトのオン
if &t_Co > 2 || has('gui_running')
    syntax on
endif

" 挿入モード時にステータスラインの色を変更
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

if has('unix') && !has('gui_running')
  " ubuntuなどESC後にすぐ反映されない対策
  inoremap <silent> <ESC> <ESC>
endif

"--------------------------------------
" vim script
"--------------------------------------

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

" 変数の中身を表示
command! -nargs=+ Vars PP filter(copy(g:), 'v:key =~# "^<args>"')

" *.hを作成するときにインクルードガードを作成する
au BufNewFile *.h call InsertHeaderHeader()
au BufNewFile *.cpp call InsertFileHeader()

function! IncludeGuard()
    let fl = getline(1)
    if fl =~ "^#if"
        return
    endif
"    let gatename = substitute(toupper(expand("%:t")), "??.", "_", "g")
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

" カーソルを指定位置に移動
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


"--------------------------------------
" プラグイン

""" neobundle
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim

    call neobundle#rc(expand('~/.bundle'))
endif

" repository
" Color
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/newspaper.vim'
NeoBundle 'w0ng/vim-hybrid'

" language
" C++
NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload': {'filetypes': ['cpp']} }
NeoBundleLazy 'vim-scripts/opengl.vim', { 'autoload': {'filetypes': ['cpp']} }

NeoBundleLazy 'Rip-Rip/clang_complete', { 'autoload': {'filetypes': ['cpp']} }
let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)
    let g:neocomplcache_force_overwrite_completefunc=1
    let g:clang_complete_auto   = 0
    let g:clang_auto_select     = 0
    let g:clang_use_library     = 1
    if has('win32')
        " exp)  let g:clang_exec        = 'C:\path\to\clang.exe'
        "       let g:clang_library_path= 'C:\path\to\(libclang.dll)'
        "       let g:clang_user_options= '2> NUL || exit 0"'
        let g:my_clang_bin_path = 'D:\Home\tool\clang\bin\'
        let g:clang_exec        = g:my_clang_bin_path.'clang.exe'
        let g:clang_library_path= g:my_clang_bin_path
        let g:clang_user_options= '2> NUL || exit 0"'

    elseif has('mac')
        " exp)  let g:clang_exec        = 'C:\path\to\clang'
        "       let g:clang_library_path= 'C:\path\to\(libclang.so)'
        "       let g:clang_user_options= '2> NUL || exit 0"'
        let g:clang_exec        = 'clang'
        let g:clang_library_path= '/usr/lib/'
        let g:clang_user_options= '2>/dev/null || exit 0"'

    elseif has('unix')
        " exp)  let g:clang_exec        = 'C:\path\to\clang'
        "       let g:clang_library_path= 'C:\path\to\(libclang.so)'
        "       let g:clang_user_options= '2> NUL || exit 0"'
        let g:clang_exec        = ''
        let g:clang_library_path= ''
        let g:clang_user_options= '2>/dev/null || exit 0"'

    endif

    let g:neocomplcache_max_list= 1000
endfunction

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
NeoBundleLazy 'davidhalter/jedi', { 'autoload': {'filetypes': ['python']} }
NeoBundleLazy 'davidhalter/jedi-vim', { 'autoload': {'filetypes': ['python']} }

" Haxe
"NeoBundleLazy 'jdonaldson/vaxe'

" shader
NeoBundleLazy 'vim-scripts/glsl.vim', { 'autoload': {'filetypes': ['glsl']} }
"NeoBundleLazy 'bundai223/FX-HLSL', { 'autoload': {'filetypes': ['fx']} }


" utl
"NeoBundle 'tyru/coolgrep.vim'
"NeoBundle 'kien/ctrlp.vim'
"NeoBundle 't9md/vim-quickhl'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'mattn/webapi-vim'
"NeoBundle 'mattn/learn-vimscript'
"NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'osyo-manga/vim-reanimate'
NeoBundle 'Shougo/vinarise'
NeoBundle 'Shougo/neocomplcache'
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
\    'autoload' : {'commands' : ['VimFilerBufferDir'] },
\}
let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer=1
    let g:vimfiler_safe_mode_by_default=0
endfunction

" vimshell
NeoBundleLazy 'Shougo/vimshell', {
\    'autoload' : {'commands' : ['VimShell'] },
\}
let s:bundle = neobundle#get('vimshell')
function! s:bundle.hooks.on_source(bundle)
    if has('win32')
        let g:vimshell_interactive_cygwin_path='c:/cygwin/bin'
    endif
    let g:vimshell_user_prompt = '$USERNAME . "@" . hostname() . " " . fnamemodify(getcwd(), ":~")'
    let g:vimshell_prompt='$ '
    let g:vimshell_split_command="split"
    
    let g:vimshell_vimshrc_path = expand('~/github/dotfiles/.vimshrc')
endfunction

" unite
NeoBundleLazy 'Shougo/unite.vim',{
\    'autoload' : {'commands' : ['Unite', 'UniteWithBufferDir'] },
\}
let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
    " 入力モードで開始
    let g:unite_enable_start_insert=1
endfunction

NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'bundai223/unite-outline-sources'
NeoBundle 'bundai223/unite-picktodo'

" private snippet
NeoBundle 'bundai223/mysnip'
NeoBundle 'bundai223/myvim_dict'

NeoBundleLazy 'tyru/restart.vim'

NeoBundleLazy 'thinca/vim-singleton'
let s:bundle = neobundle#get('vim-singleton')
function! s:bundle.hooks.on_source(bundle)
    " singletonを有効に
    call singleton#enable()
endfunction


filetype plugin on
filetype indent on

""" Restart Vim
if has('gui')
  nnoremap <silent> rs : <C-u> Restart <CR>
endif

""" vimshell
nnoremap <silent> vs : <C-u> VimShell<CR>


""" neocomplcache
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'  : '',
    \ 'vimshell' : '~/.vimshell_hist',
    \ 'cpp'      : '~/.bundle/myvim_dict/cpp.dict',
    \ 'squirrel' : '~/.bundle/myvim_dict/squirrel.dict',
    \ }

" Define keyword.
let g:neocomplcache_keyword_patterns = get(g:, 'neocomplcache_keyword_patterns', {})
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" force omni pattern
let g:neocomplcache_force_omni_patterns = get(g:, 'neocomplcache_force_omni_patterns', {})
let g:neocomplcache_force_omni_patterns.ruby      = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_force_omni_patterns.php       = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c         = '[^.[:d:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp       = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.squirrel  = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.cs        = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplcache_force_omni_patterns.go        = '[^.]\.\%(\u\{2,}\)\?'


""" neosnippet
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
let g:neosnippet#snippets_directory='~/.bundle/mysnip'



""" unite

" source
" バッファ一覧
nnoremap <silent> <Leader>ub :<C-u>Unite -buffer-name=buffer buffer<CR>
" ファイル一覧
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Leader>ud :<C-u>Unite -input=/Home/github/dotfiles/. -buffer-name=dotfiles file<CR>
" レジスタ一覧
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
" 履歴
nnoremap <silent> <Leader>um :<C-u>Unite -buffer-name=history file_mru<CR>
" アウトライン
nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -winwidth=30 -buffer-name=outline -no-quit outline<CR>
"nnoremap <silent> <Leader>ut :<C-u>Unite -vertical -winwidth=30 -buffer-name=todo -no-quit picktodo<CR>
nnoremap <silent> <Leader>ut :<C-u>Unite -buffer-name=todo -no-quit picktodo<CR>
" グレップ
nnoremap <silent> <Leader>ug :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
" スニペット探し
nnoremap <silent> <Leader>us :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
" NeoBundle更新
nnoremap <silent> <Leader>un :<C-u>Unite -buffer-name=neobundle neobundle/install:!<CR>
" Color Scheme
nnoremap <silent> <Leader>uc :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>


""" vimfiler
"nnoremap <silent> vf : <C-u> VimFilerExplorer %:h<CR>
nnoremap <silent> vf : <C-u> VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

""" gtags
nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>

""" reanimate
nnoremap <Space>s :<C-u>ReanimateSave<Space>
nnoremap <Space>l :<C-u>ReanimateLoad<Space>
nnoremap <Space>L :<C-u>ReanimateLoadLatest<Space>

"--------------------------------------
" キーバインド

" ESCを簡単に
imap <C-j> <C-[>
nmap <C-j> <C-[>
vmap <C-j> <C-[>
cmap <C-j> <C-[>

" vimスクリプトを再読み込み
nnoremap <F8> :source %<CR>

" ZZで全保存・全終了らしいので不可に
nnoremap ZZ <Nop>

" 補完呼び出し
" imap <C-Space> <C-x><C-n>

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
nnoremap <C-h> :<C-u>help<Space>

" マーク・レジスタなど一覧
" 使わない
"nnoremap <Leader>M :<C-u>marks<CR>
"nnoremap <Leader>R :<C-u>registers<CR>
"nnoremap <Leader>B :<C-u>buffers<CR>
"nnoremap <Leader>T :<C-u>tags<CR>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" ヤンクした単語で置換
nnoremap <silent>ciy  ciw<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap <silent>cy   ce <C-r>0<Esc>:let@/=@1<CR>:noh<CR>

" 移動系
inoremap <Leader>a  <Home>
inoremap <Leader>e  <End>
nnoremap <Leader>a  <Home>
nnoremap <Leader>e  <End>

" タブ関連
nnoremap <Leader>n :<C-u>tabnew<CR>
nnoremap <C-g>l  gt
nnoremap <C-g>h  gT

" 関数単位で移動
noremap <C-p> [[
noremap <C-n> ]]

" カレントパスをバッファに合わせる
nnoremap <silent><Space><Space> :<C-u>cd %:h<CR>:pwd<CR>

" 置換
nnoremap <expr> <Leader>s _(":s/<Cursor>//g")
nnoremap <expr> <Leader>S _(":%s/<Cursor>//g")

" ローカル設定を読み込む
if filereadable(expand('~/.my_local_vimrc'))
    source ~/.my_local_vimrc
endif

