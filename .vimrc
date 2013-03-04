
"--------------------------------------
" vimの基本的な設定
"--------------------------------------
scriptencoding utf-8
set nocompatible

" 文字エンコード
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
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
autocmd FileType * setlocal formatoptions-=ro

" シンボリックなファイルを編集するとリンクが消されてしまうことがあったので
" 参照先を変数に上書き
let $MYVIMRC="~/github/dotfiles/.vimrc"
let $MYGVIMRC="~/github/dotfiles/.gvimrc"

" ローカル設定を読み込む
if filereadable($HOME.'/.my_local_vimrc')
    source $HOME/.my_local_vimrc
endif

" 分割方向を指定
set splitbelow
"set splitright

"--------------------------------------
" 基本的な設定
"--------------------------------------
if has('unix')
    let $USERNAME=$USER
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
" tagの設定は各プロジェクトごとにsetlocalするべき
" tagファイルの検索パス指定
" カレントから親フォルダに見つかるまでたどる
"set tags=tags;

" 検索結果をウインドウ真ん中に
nnoremap n nzz

" 外部grepの設定
set grepprg=grep\ -nH

"--------------------------------------
" 表示の設定
"--------------------------------------
" 行番号表示
set number
" tab 行末spaceを表示
set list
set listchars=tab:^\ ,trail:~

" 全角スペースを表示
highlight ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=red
au BufNew,BufRead * match ZenkakuSpace /　/

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
" キーバインド
"--------------------------------------
" ESCを簡単に
imap <C-j> <C-[>
nmap <C-j> <C-[>
vmap <C-j> <C-[>

" vimスクリプトを再読み込み
nnoremap <F8> :source %<CR>

" ZZで全保存・全終了らしいので不可に
nnoremap ZZ <Nop>

" コマンドラインモード誤動作させがちなのでなし
nnoremap q: <Nop>

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
vnoremap <silent> ca : ContinuousNumber <C-a><CR>
vnoremap <silent> cx : ContinuousNumber <C-x><CR>

" help補助
nnoremap <C-h> :<C-u>help<Space>

" マーク・レジスタなど一覧
nnoremap <Leader>M :<C-u>marks<CR>
nnoremap <Leader>R :<C-u>registers<CR>
nnoremap <Leader>B :<C-u>buffers<CR>
nnoremap <Leader>T :<C-u>tags<CR>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" ヤンクした単語で置換
nnoremap <silent>ciy  ciw<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap <silent>cy   ce <C-r>0<Esc>:let@/=@1<CR>:noh<CR>

" 移動系
inoremap <Leader>a  <Home>
inoremap <Leader>e  <End>

" タブ関連
nnoremap <Leader>n :<C-u>tabnew<CR>
nnoremap t  gt
nnoremap T  gT

" 関数単位で移動
noremap <C-p> [[
noremap <C-n> ]]

" カレントパスをバッファに合わせる
nnoremap <Space><Space> :<C-u>cd %:h<CR>

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

" マクロ展開
"function! CppRegion() range
"  let beginmark='---beginning_of_cpp_region'
"  let endmark='---end_of_cpp_region'
"  exe a:firstline . "," . a:lastline ."!sed -e '" . a:firstline . "i\\\\" . nr2char(10) . beginmark . "' -e '" . a:lastline . "a\\\\".nr2char(10).endmark."' " .expand("%") . "|cpp -C|sed -ne '/" . beginmark . "/,/" .endmark . "/p'"
"endfunction

"--------------------------------------
" プラグイン
"--------------------------------------
if has('gui')
  """ Restart Vim
  nnoremap <silent> rs : <C-u> Restart <CR>
endif

""" vimshell
if has('win32')
	let g:vimshell_interactive_cygwin_path='c:/cygwin/bin'
endif
"let g:vimshell_user_prompt='"(" . getcwd() . ") --- (" . $USERNAME . "@" . hosetname() . ")"'
"let g:vimshell_user_prompt = '$USERNAME . " " . '
let g:vimshell_user_prompt = '$USERNAME . "@" . hostname() . " " . fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt='$ '
"let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
"let g:vimshell_prompt=$USERNAME.'% '
let g:vimshell_split_command="split"
"let g:vimshell_popup_command=""
"let g:vimshell_popup_height="split"

"let g:vimshell_vimshrc_path = '~hub/dotfiles/.vimshrc'
let g:vimshell_vimshrc_path = expand('~hub/dotfiles/.vimshrc')

"nnoremap <silent> vs : <C-u> VimShell -popup <CR>
nnoremap <silent> vs : <C-u> VimShell<CR>
nnoremap <silent> vc : <C-u> VimShellBufferDir<CR>


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
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme'   : $HOME.'/.gosh_completions',
    \ 'cpp'      : $HOME.'/.bundle/myvim_dict/cpp.dict',
    \ 'squirrel' : $HOME.'/.bundle/myvim_dict/squirrel.dict',
    \ }

" Define keyword.
let g:neocomplcache_keyword_patterns = get(g:, 'neocomplcache_keyword_patterns', {})
" if !exists('g:neocomplcache_keyword_patterns')
"     let g:neocomplcache_keyword_patterns = {}
" endif
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

" Enable heavy omni completion.
"let g:neocomplcache_omni_patterns = get(g:, 'neocomplcache_omni_patterns', {})
""if !exists('g:neocomplcache_omni_patterns')
""  let g:neocomplcache_omni_patterns = {}
""endif
"let g:neocomplcache_omni_patterns.ruby      = '[^. *\t]\.\h\w*\|\h\w*::'
""autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php       = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplcache_omni_patterns.c         = '[^.[:d:] *\t]\%(\.\|->\)'
"let g:neocomplcache_omni_patterns.cpp       = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'
"let g:neocomplcache_omni_patterns.squirrel  = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'

" force omni pattern
let g:neocomplcache_force_omni_patterns = get(g:, 'neocomplcache_force_omni_patterns', {})
"if !exists('g:neocomplcache_force_omni_patterns')
"  let g:neocomplcache_force_omni_patterns = {}
"endif
let g:neocomplcache_force_omni_patterns.ruby      = '[^. *\t]\.\h\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_force_omni_patterns.php       = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c         = '[^.[:d:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp       = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.squirrel  = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'


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


""" clang_complete
let g:neocomplcache_force_overwrite_completefunc=1
let g:clang_complete_auto   = 0
let g:clang_auto_select     = 0
let g:clang_use_library     = 1
if has('win32')
    " exp)  let g:clang_exec        = 'C:\path\to\clang.exe'
    "       let g:clang_library_path= 'C:\path\to\(libclang.dll)'
    "       let g:clang_user_options= '2> NUL || exit 0"'
"    let g:clang_exec        = 'D:\Home\tool\clang\bin\clang.exe'
"    let g:clang_library_path= 'D:\Home\tool\clang\bin\'
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



""" unite
" 入力モードで開始
let g:unite_enable_start_insert=1


" source
" バッファ一覧
nnoremap <silent> <Leader>ub :<C-u>Unite -buffer-name=buffer buffer<CR>
" ファイル一覧
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
" 履歴
nnoremap <silent> <Leader>um :<C-u>Unite -buffer-name=history file_mru<CR>
" アウトライン
nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -winwidth=30 -buffer-name=outline -no-quit outline<CR>
" タグ
"nnoremap <silent> <Leader>ut :<C-u>Unite -buffer-name=tag tag<CR>
" グレップ
nnoremap <silent> <Leader>ug :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
" スニペット探し
nnoremap <silent> <Leader>us :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
" NeoBundle更新
nnoremap <silent> <Leader>un :<C-u>Unite -buffer-name=neobundle neobundle/install:!<CR>
" Color Scheme
nnoremap <silent> <Leader>uc :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>





""" vimfiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0

nnoremap <silent> vf : <C-u> VimFilerExplorer<CR>
nnoremap <silent> vfh : <C-u> VimFilerExplorer ~/<CR>
"nnoremap <silent> vf : <C-u> VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit $HOME<CR>

""" ref-vim
"nmap <Leader>ra :<C-u>Ref alc<Space>
"nmap <Leader>rr :<C-u>Ref refe<Space>
"" 表示する行数
"let g:ref_alc_start_linenumber = 39
"" 文字化けしたので文字コード設定
"let g:ref_alc_encoding = 'Shift-JIS'

""" gtags
nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>

""" reanimate
nnoremap <Space>s :<C-u>ReanimateSave<Space>
nnoremap <Space>l :<C-u>ReanimateLoad<Space>
nnoremap <Space>L :<C-u>ReanimateLoadLatest<Space>

""" tagbar
let g:tagbar_left=1
let g:tagbar_width=30

nnoremap <Leader>t :<C-u>TagbarToggle<CR>

""" neobundle
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim

    call neobundle#rc(expand('~/.bundle'))
endif

if has('gui')
  NeoBundle 'tyru/restart.vim'
  NeoBundle 'thinca/vim-singleton'
endif
NeoBundle 'tyru/coolgrep.vim'
NeoBundle 'kien/ctrlp.vim'
"NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
NeoBundle 'tpope/vim-surround'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'rhysd/clever-f.vim'
"NeoBundle 'tsukkee/unite-tag'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-prettyprint'
"NeoBundle 'mattn/vimplenote-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/learn-vimscript'
"NeoBundle 'daisuzu/unite-gtags'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'osyo-manga/vim-reanimate'
" private snippet
NeoBundle 'bundai223/mysnip'
NeoBundle 'bundai223/myvim_dict'
" 言語別
" C++
NeoBundleLazy 'vim-jp/cpp-vim'
NeoBundleLazy 'Rip-Rip/clang_complete'
" Graphic
"NeoBundleLazy 'vim-scripts/opengl.vim'
NeoBundleLazy 'vim-scripts/glsl.vim'
"NeoBundleLazy 'bundai223/FX-HLSL'
" Python
NeoBundleLazy 'davidhalter/jedi'
NeoBundleLazy 'davidhalter/jedi-vim'
" Dart
"NeoBundleLazy 'vim-scripts/Dart'
" Color
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'altercation/solarized'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'vim-scripts/newspaper.vim'
NeoBundle 'w0ng/vim-hybrid'





filetype plugin on
filetype indent on

" singletonを有効に
if has('gui')
	call singleton#enable()
endif

