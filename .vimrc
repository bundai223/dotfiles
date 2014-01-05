
" Basic setting {{{

scriptencoding utf-8
set nocompatible

" help���{��E�p��D��
set helplang=ja,en
" �J�[�\�����̒P���help
set keywordprg =:help

" �����G���R�[�h
set encoding=utf-8
set fileencoding=utf-8
" �����̂�����<C-o>�Ȃǂł̃W�����v�����������Ȃ��Ă�
" �����͂悭�킩��Ȃ�
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set fileformat=unix
set fileformats=unix,dos

" �o�b�N�A�b�v�t�@�C���̐ݒ�
"set nowritebackup
"set nobackup
set noswapfile

" �N���b�v�{�[�h���g�p����
set clipboard=unnamed,autoselect

" ���s���̎����R�����g���Ȃ���
set formatoptions-=ro

" �V���{���b�N�ȃt�@�C����ҏW����ƃ����N��������Ă��܂����Ƃ��������̂�
" �Q�Ɛ��ϐ��ɏ㏑��
let $MYVIMRC=$DOTFILES."/.vimrc"
let $MYGVIMRC=$DOTFILES."/.gvimrc"

" �����������w��
set splitbelow
"set splitright

" BS can delete newline or indent
set backspace=indent,eol,start

set completeopt=menu,preview
" �⊮�Ńv���r���[���Ȃ�
"set completeopt=menuone,menu

" Default comment format is nothing
" Almost all this setting override by filetype setting
" e.g. cpp: /*%s*/
"      vim: "%s
set commentstring=%s

if has('vim_starting')
  " Go��path
  if $GOROOT != ''
    set rtp+=$GOROOT/misc/vim
    set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
  endif

  if has('win32')
    set rtp+=~/.vim
    set rtp+=~/.vim/after
  else
    " ���O�ŗp�ӂ������̂ւ� path
    set path=.,/usr/include,/usr/local/include
  endif
endif

if has('unix')
  let $USERNAME=$USER
endif

" Leader��ݒ�
if has('mac')
  map _ <Leader>
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

" tag�t�@�C���̌����p�X�w��
" �J�����g����e�t�H���_�Ɍ�����܂ł��ǂ�
" tag�̐ݒ�͊e�v���W�F�N�g���Ƃ�setlocal����
set tags=tags;

" �O��grep�̐ݒ�
set grepprg=grep\ -nH

" }}}

" �\���̐ݒ� {{{

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
" tab �s��space��\��
"set listchars=tab:^\ ,trail:~
set listchars=tab:^\ ,trail:~,extends:>,precedes:<,nbsp:%

" always show tab
set showtabline=2

" fix zenkaku char's width
set ambiwidth=double

" �ĕ`��R�}���h���s���͂Ȃ�
set lazyredraw

" �n�C���C�g�̃I��
syntax on

" statusline��ɕ\�� for airline
set laststatus=2

" }}}

" VimScript {{{

" filetype ����
" :verbose :setlocal filetype?
"
" Set encoding when open file {{{
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Utf16 edit<bang> ++enc=utf-16 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>
" }}}

" �J�����g�p�X���N���b�v�{�[�h�ɃR�s�[ {{{
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

" �J�[�\�����w��ʒu�Ɉړ� {{{
"�W�J�� <Cursor> �ʒu�ɃJ�[�\�����ړ�����
"nnoremap <expr> <A-p> _(":%s/<Cursor>/�ق�/g")
"nnoremap <expr> <A-p> ":%s//�ق�/g\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>\<Left>"
function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

function! _(str)
    return s:move_cursor_pos_mapping(a:str, "\<Left>")
endfunction

" �R�}���h��
"Nnoremap <A-o> :%s/<Cursor>/�}�~/g
command! -nargs=* MoveCursorPosMap execute <SID>move_cursor_pos_mapping(<q-args>)
command! -nargs=* Nnoremap MoveCursorPosMap nnoremap <args>
" }}}
" }}}

" Plugins {{{

if has('vim_starting')
  set rtp+=~/.vim/neobundle.vim

  call neobundle#rc(expand('~/.vim/.bundle'))
endif

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


" textobj
NeoBundle 'tpope/vim-surround'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
"NeoBundle 'rhysd/vim-textobj-word-column'

" utl
NeoBundle 'koron/codic-vim'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kana/vim-submode'
NeoBundle 'tyru/caw.vim'
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
NeoBundle 'mattn/webapi-vim'
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
NeoBundleLazy 'Shougo/vimfiler', {
            \   'autoload' : {'commands' : ['VimFilerBufferDir'] },
            \ }
NeoBundleLazy 'Shougo/vimshell', {
            \   'autoload' : {'commands' : ['VimShell'] },
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
NeoBundle 'osyo-manga/unite-fold'
NeoBundle 'osyo-manga/unite-quickrun_config'
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


" marching
let s:bundle = neobundle#get('vim-marching')
function! s:bundle.hooks.on_source(bundle)
  " �񓯊��ł͂Ȃ��ē��������ŕ⊮����
  let g:marching_backend = "clang_command"
  "let g:marching_backend = "sync_clang_command"
  
  " �I�v�V�����̐ݒ�
  " ����� clang �̃R�}���h�ɓn�����
  "let g:marching_clang_command_option="-std=c++1y"
  
  
  " neocomplete.vim �ƕ��p���Ďg�p����ꍇ
  " neocomplete.vim ���g�p����Ύ����⊮�ɂȂ�
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
  " ���̓��[�h�ŊJ�n
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

filetype plugin indent on


" vital
let g:V = vital#of('vital')

" foldCC
set foldtext=FoldCCtext()
set fillchars=vert:\l
set foldcolumn=2

" Over vim
" ������Ƃ��₵��
" http://leafcage.hateblo.jp/
"cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ? 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'

cnoreabb <expr>s getcmdtype()==':' && getcmdline()=~'^s' ? '%s/<C-r>=Eat_whitespace(''\s\\|;\\|:'')<CR>' : 's'
function! Eat_whitespace(pat)
  let c = nr2char(getchar(0))
  if c=~a:pat
    return ''
  elseif c=~'\r'
    return ''
  end
  return c
endfunction


""" quickhl {{{
let g:quickhl_manual_enable_at_startup = 1

nmap <Space>h <Plug>(quickhl-manual-this)
xmap <Space>h <Plug>(quickhl-manual-this)
nmap <Space>H <Plug>(quickhl-manual-reset)
xmap <Space>H <Plug>(quickhl-manual-reset)
"nmap <Space>j <Plug>(quickhl-match)
"""}}}

""" smartinput{{{
let g:smartinput_no_default_key_mappings = 1

" <CR>��smartinput�̏����t���̕����w�肷���
call smartinput#map_to_trigger( 'i', '<Plug>(physical_key_CR)', '<CR>', '<CR>')
imap <CR> <Plug>(physical_key_CR)

" ���s���ɍs���X�y�[�X���폜����
call smartinput#define_rule({
\   'at': '\s\+\%#',
\   'char': '<CR>',
\   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
\   })

" �΂ɂȂ���̂̓��́B���ʂȋ󔒂͍폜
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

" external omni func
"let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'
" }}}

""" neosnippet {{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" Tab�ŃX�j�y�b�g�I�� Space�őI�𒆃X�j�y�b�g�W�J
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
" <Space>��unite�̃L�[��
nnoremap [unite] <Nop>
nmap <Space> [unite]

" source
" �t�@�C���ꗗ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]d :<C-u>Unite -input=/Home/labo/dotfiles/. -buffer-name=dotfiles file<CR>
" �t�@�C�������ς���
"nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=history file_mru<CR>
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=multi file_mru file buffer<CR>
" �A�E�g���C��
"nnoremap <silent> [unite]o :<C-u>Unite -vertical -winwidth=30 -buffer-name=outline -no-quit -wrap outline<CR>
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -no-quit -wrap outline<CR>
" todo
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=todo -no-quit picktodo<CR>
" �O���b�v
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
" �X�j�y�b�g�T��
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=snippet snippet<CR>
nnoremap <silent> [unite]su :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
" NeoBundle�X�V
nnoremap <silent> [unite]nb :<C-u>Unite -buffer-name=neobundle neobundle/update:all -auto-quit -keep-focus -log<CR>
" �o�b�t�@�ꗗ
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffer buffer<CR>
" Color Scheme
nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>
" source �ꗗ
nnoremap <silent> [unite]s :<C-u>Unite source -vertical<CR>

""" alignta(visual)
vnoremap <silent> [unite]aa :<C-u>Unite alignta:arguments<CR>
vnoremap <silent> [unite]ao :<C-u>Unite alignta:options<CR>


" UniteBuffer�̕���
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
" �ϐ��̒��g��\��
command! -nargs=+ GlobalVars PP filter(copy(g:), 'v:key =~# "^<args>"')
command! -nargs=+ BufVars PP filter(copy(b:), 'v:key =~# "^<args>"')
" }}}

""" caw {{{
nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)
" }}}

""" quickrun {{{
" vimproc�ŋN��
" �o�b�t�@����Ȃ����
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


"" <Space>q�ŋ����I��
"nnoremap <expr><silent><Space>q quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"""}}}

""" anzu {{{
" " echo statusline to search index
" " n �� N �̑���Ɏg�p���܂��B
" nmap n <Plug>(anzu-n)
" nmap N <Plug>(anzu-N)
" nmap * <Plug>(anzu-star)
" nmap # <Plug>(anzu-sharp)
"
" " �X�e�[�^�X���� statusline �ւƕ\������
" set statusline=%{anzu#search_status()}

" vim-airline �ŕ\�����Ăق����Ȃ��ꍇ�� 0 ��ݒ肵�ĉ������B
let g:airline#extensions#anzu#enabled = 0

" ���������g�p�����
" �ړ���ɃX�e�[�^�X�����R�}���h���C���ւƏo�͂��s���܂��B
" statusline ���g�p�������Ȃ��ꍇ�͂��������g�p���ĉ������B
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

" }}}

" Basic key mapping {{{

" ESC�����₷��
imap <C-@> <C-[>
nmap <C-@> <C-[>
vmap <C-@> <C-[>
cmap <C-@> <C-[>

" �R�}���h���[�h�ɓ���₷��
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" �ēǂݍ���
nnoremap <F5> :source %<CR>

" ���O�̃o�b�t�@�Ɉړ�
nnoremap <Leader>b :b#<CR>

" Insert date
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" Easy to help
nnoremap <C-u> :<C-u>help<Space>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" �J�����g�p�X���o�b�t�@�ɍ��킹��
nnoremap <silent><Leader><Space> :<C-u>cd %:h<CR>:pwd<CR>

" Quick splits
nnoremap _ :sp<CR>
nnoremap <Bar> :vsp<CR>

" Insert space in normal mode
nnoremap <C-l> i<Space><Esc><Right>
nnoremap <C-h> i<Space><Esc>

" Copy and paste {{{
" �s���܂Ń����N
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
" ��s�P�ʂňړ�
nnoremap <C-j> }
nnoremap <C-k> {
vnoremap <C-j> }
vnoremap <C-k> {

" �����ڂ̍s�ړ������₷��
nnoremap j  gj
nnoremap k  gk

" �֐��P�ʂňړ�
noremap <C-p> [[
noremap <C-n> ]]

" Toggle 0 and ^
nnoremap <expr>0 col('.') == 1 ? '^' : '0'
nnoremap <expr>^ col('.') == 1 ? '^' : '0'
" }}}

" Search and replace {{{
" �����n�C���C�g���I�t
nnoremap <Leader>/ :noh <CR>

" �u��
nnoremap <expr> <Leader>s _(":s/<Cursor>//g")
nnoremap <expr> <Leader>S _(":%s/<Cursor>//g")

" �������ʂ��E�C���h�E�^�񒆂�
nnoremap n nzzzv
nnoremap N Nzzzv
" }}}

" Fold moving {{{
noremap [fold] <nop>
nmap <Leader> [fold]

" Move fold
noremap [fold]j zj
noremap [fold]k zk

" Move fold begin line
noremap [fold]n ]z
noremap [fold]p [z

" Fold open and close
noremap [fold]h zc
noremap [fold]l zo
noremap [fold]a za

" All fold close
noremap [fold]m zM

" Other fold close
noremap [fold]i zMzv

" Make fold
noremap [fold]r zR
noremap [fold]f zf
"}}}

" �g��Ȃ��}�b�s���O�Ȃ���
" ZZ�őS�ۑ��E�S�I��
" ZQ�ŕۑ��Ȃ��E�S�I��
nnoremap ZZ <Nop>
"nnoremap ZQ <Nop> "�����o�b�t�@�ŕK�v
" ex���[�h�H�Ȃ�
nnoremap Q <Nop>

" }}}

" C++ {{{
" *.h���쐬����Ƃ��ɃC���N���[�h�K�[�h���쐬���� {{{
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

" header��source�����ւ��� {{{
command! -nargs=0 CppHpp :call <SID>cpp_hpp()
function! s:cpp_hpp()
    let cpps = ['cpp', 'cc', 'cxx', 'c']
    let hpps = ['hpp', 'h']
    let ext  = expand('%:e')
    let base = expand('%:r')

    " �\�[�X�t�@�C���̂Ƃ�
    if count(cpps,ext) != 0
        for hpp in hpps
            if filereadable(base.'.'.hpp)
                execute 'edit '.base.'.'.hpp
                return
            endif
        endfor
    endif

    " �w�b�_�t�@�C���̂Ƃ�
    if count(hpps,ext) != 0
        for cpp in cpps
            if filereadable(base.'.'.cpp)
                execute 'edit '.base.'.'.cpp
                return
            endif
        endfor
    endif

    " �Ȃ���� Unite �Ō���
    if executable('mdfind') && has('mac')
        execute "Unite spotlight -input=".base
    elseif executable('locate')
        execute "Unite locate -input=".base
    else
        echoerr "not found"
    endif

endfunction
" }}}

" }}}

" ���[�J���ݒ��ǂݍ���
if filereadable(expand('~/.my_local_vimrc'))
    source ~/.my_local_vimrc
endif


