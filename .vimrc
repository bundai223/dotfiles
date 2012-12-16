
"--------------------------------------
" vimの基本的な設定
"--------------------------------------
scriptencoding cp932
set nocompatible

" 文字エンコード
set encoding=utf-8
" set fileformat=unix
set fileformats=unix,dos

" バックアップファイルの設定
"set nowritebackup
"set nobackup
"set noswapfile

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
let $MYVIMRC="$HOME/github/dotfiles/.vimrc"
let $MYGVIMRC="$HOME/github/dotfiles/.gvimrc"

" ローカル設定を読み込む
if filereadable($HOME.'.my_local_vimrc')
    source $HOME/.my_local_vimrc
endif

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

" 起動時に前回の編集箇所から再開
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

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
set tags=tags;

" 検索結果をウインドウ真ん中に
nnoremap n nzz

"--------------------------------------
" 表示の設定
"--------------------------------------
" 行番号表示
set number
" tab 行末spaceを表示
set list
set listchars=tab:^\ ,trail:~

" ハイライトのオン
if &t_Co > 2 || has('gui_running')
    syntax on
endif

"--------------------------------------
" キーバインド
"--------------------------------------
" map <Nul> <C-Space>
" map! <Nul> <C-Space>

" vimスクリプトを再読み込み
nnoremap <F8> :source %<CR>
" ZZで全保存・全終了らしいので不可に
nnoremap ZZ <Nop>

" 補完呼び出し
" imap <C-Space> <C-x><C-n>

" 直前のバッファに移動
nnoremap <Leader>b :b#<CR>

" ヘッダ・ソースを開く
nnoremap <Leader>h  :<C-u>hide edit %<.h<Return>
nnoremap <Leader>c  :<C-u>hide edit %<.cpp<Return>

" 日付マクロ
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" 連番マクロ
nnoremap <silent> co:ContinuousNumbers <C-a><CR>
vnoremap <silent> ca:ContinuousNumbers <C-a><CR>
vnoremap <silent> cx:ContinuousNumbers <C-x><CR>

" help補助
nnoremap <C-h> :<C-u>help<Space>

" マーク・レジスタなど確認
nnoremap <Leader>m :<C-u>marks<CR>
nnoremap <Leader>r :<C-u>registers<CR>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" ヤンクした単語で置換
nnoremap <silent> ciy ciw<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy ce<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap gy '0P

" 移動系
inoremap <Leader>a  <Home>
inoremap <C-e>      <End>

" 切り取り
inoremap <C-d>      <Del>

" 最後に変更した修正を選択
nnoremap gc  '[v']

" 画面分割
nnoremap <silent> <C-x>1    :only<CR>
nnoremap <silent> <C-x>2    :sp<CR>
nnoremap <silent> <C-x>3    :vsp<CR>

" tags-and-searches関連
" タグに飛んだりもとったり
nnoremap t  <Nop>
" nnoremap tt <C-]> "これはこのままでいいかな
nnoremap tj :<C-u>tag<CR>
nnoremap tp :<C-u>pop<CR>
"nnoremap tl :<C-u>tags<CR>
nnoremap <Leader>t :<C-u>tags<CR>

"--------------------------------------
" vim script
"--------------------------------------
" 差分
" 現バッファとの差分
"command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" 指定バッファとの差分
"command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif

" grep
" exp ) :Grep word ./path
"        pathを省略した場合はカレントから再帰的に
"command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
"function! s:grep(args)
"    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
"    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
"    if len(getqflist()) != 0 | copen | endif
"endfunction

" 連番マクロ用
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor


"--------------------------------------
" プラグイン
"--------------------------------------
if has('win32')
  """ Restart Vim
  nnoremap <silent> rs : <C-u> Restart <CR>
endif

""" vimshell
if has('win32')
	let g:vimshell_interactive_cygwin_path='c:/cygwin/bin'
endif
let g:vimshell_prompt=$USERNAME.'% '
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_split_command="split"
nnoremap <silent> vs : <C-u> VimShell <CR>

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
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" スニペット
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

""" clang_complete
let g:neocomplcache_force_overwrite_completefunc=1
let g:clang_complete_auto=1
let g:clang_use_library=1
if has('win32')
	let g:clang_exec="$HOME/tool/clang/bin/clang.exe"
	let g:clang_library_path="$HOME/tool/clang/bin/"
endif

let g:neocomplcache_max_list=1000



""" unite
" 入力モードで開始
let g:unite_enable_start_insert=1


" source
" バッファ一覧
nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
" 履歴
nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
" 常用
nnoremap <silent> <Leader>uu :<C-u>Unite buffer file_mru<CR>
" アウトライン
nnoremap <silent> <Leader>uo :<C-u>Unite outline<CR>
" タグ
nnoremap <silent> <Leader>ut :<C-u>Unite tag/include<CR>
" グレップ
nnoremap <silent> <Leader>ug :<C-u>Unite grep<CR>
" スニペット探し
nnoremap <silent> <Leader>us :<C-u>Unite snippet<CR>
" NeoBundle更新
nnoremap <silent> <Leader>uneo :<C-u>Unite neobundle/install:!<CR>


""" vimfiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0

nnoremap <silent> vf : <C-u> VimFiler <CR>

""" ref-vim
nmap <Leader>ra :<C-u>Ref alc<Space>
nmap <Leader>rr :<C-u>Ref refe<Space>
" 表示する行数
let g:ref_alc_start_linenumber = 39
" 文字化けしたので文字コード設定
let g:ref_alc_encoding = 'Shift-JIS'

""" gtags
nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>

""" neobundle
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim.git
    set runtimepath+=~/.vim

    call neobundle#rc(expand('~/.bundle'))
endif

NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neosnippet.git'
if has('win32')
  NeoBundle 'tyru/restart.vim.git'
endif
NeoBundle 'Rip-Rip/clang_complete.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/vinarise.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 't9md/vim-quickhl.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'h1mesuke/unite-outline.git'
NeoBundle 'tsukkee/unite-tag.git'
NeoBundle 'thinca/vim-ref.git'
NeoBundle 'thinca/vim-localrc.git'
NeoBundle 'mattn/vimplenote-vim.git'
NeoBundle 'mattn/webapi-vim.git'
NeoBundle 'mattn/learn-vimscript.git'
NeoBundle 'daisuzu/unite-gtags.git'
NeoBundle 'davidhalter/jedi.git'
NeoBundle 'davidhalter/jedi-vim.git'
" Dart
NeoBundle 'vim-scripts/Dart.git'
" Graphic
NeoBundle 'vim-scripts/opengl.vim.git'
NeoBundle 'vim-scripts/glsl.vim.git'
NeoBundle 'bundai223/FX-HLSL.git'
" private snippet
NeoBundle 'bundai223/mysnip.git'


filetype plugin on
filetype indent on


"--------------------------------------
" ファイルタイプ
"--------------------------------------
au BufRead,BufNewFile *.fx     set filetype=fx


