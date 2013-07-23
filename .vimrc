
"--------------------------------------
" vim�̊�{�I�Ȑݒ�
"--------------------------------------
scriptencoding utf-8
set nocompatible

" �����G���R�[�h
set encoding=utf-8
set fileencoding=utf-8
" �����̂�����<C-o>�Ȃǂł̃W�����v�����������Ȃ��Ă�
" �����͂悭�킩��Ȃ�
"set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set fileformat=unix
set fileformats=dos,unix

" �o�b�N�A�b�v�t�@�C���̐ݒ�
"set nowritebackup
"set nobackup
set noswapfile

" tab�ŃX�y�[�X��}��
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4

" �N���b�v�{�[�h���g�p����
set clipboard=unnamed,autoselect

" ���s���̎����R�����g���Ȃ���
autocmd FileType * setlocal formatoptions-=ro

" �V���{���b�N�ȃt�@�C����ҏW����ƃ����N��������Ă��܂����Ƃ��������̂�
" �Q�Ɛ��ϐ��ɏ㏑��
let $MYVIMRC="~/labo/dotfiles/.vimrc"
let $MYGVIMRC="~/labo/dotfiles/.gvimrc"

" �����������w��
set splitbelow
"set splitright

set completeopt=menu,preview
" Go��path
if $GOROOT != ''
    set runtimepath+=$GOROOT/misc/vim
    exe "set runtimepath+=".globpath($GOPATH, "src/labo.com/nsf/gocode/vim")
endif


"--------------------------------------
" ��{�I�Ȑݒ�
"--------------------------------------
if has('unix')
    let $USERNAME=$USER
endif

" �����̕ۑ�
"if has('persistent_undo' )
"    set undodir=~/.vim/undo
"    set undofile
"endif

" Leader��ݒ�
"let mapleader=' '
if has('mac')
    map _ <Leader>
endif

"--------------------------------------
" ����
"--------------------------------------
" �������啶���������̋�ʂȂ�
" �����������܂ނƂ��͋�ʂ���
set ignorecase
set smartcase
" �������Ō�܂ōs������ŏ��ɖ߂�
set wrapscan
" �C���N�������^���T�[�`
set incsearch
" ���������̋����\��
set hlsearch
" tag�t�@�C���̌����p�X�w��
" �J�����g����e�t�H���_�Ɍ�����܂ł��ǂ�
" tag�̐ݒ�͊e�v���W�F�N�g���Ƃ�setlocal����
set tags=tags;

" �������ʂ��E�C���h�E�^�񒆂�
nnoremap n nzz

" �O��grep�̐ݒ�
set grepprg=grep\ -nH

"--------------------------------------
" �\���̐ݒ�
"--------------------------------------
" �s�ԍ��\��
"set number
set relativenumber
" tab �s��space��\��
set list
set listchars=tab:^\ ,trail:~

" �n�C���C�g�̃I��
if &t_Co > 2 || has('gui_running')
    syntax on
endif

" �}�����[�h���ɃX�e�[�^�X���C���̐F��ύX
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
  " ubuntu�Ȃ�ESC��ɂ������f����Ȃ��΍�
  inoremap <silent> <ESC> <ESC>
endif

"--------------------------------------
" vim script
"--------------------------------------

"" grep���ʂ�quickfix�ɏo��
" **** grep -iHn -R 'target string' target_path | cw ****
" **** vimgrep 'target string' target_path | cw ****
"

" grep
" exp ) :Grep word ./path
"        path���ȗ������ꍇ�̓J�����g����ċA�I��
"command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
"function! s:grep(args)
"    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
"    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
"    if len(getqflist()) != 0 | copen | endif
"endfunction

" filetype ����
" :verbose :setlocal filetype?

" �ϐ��̒��g��\��
command! -nargs=+ Vars PP filter(copy(g:), 'v:key =~# "^<args>"')

" *.h���쐬����Ƃ��ɃC���N���[�h�K�[�h���쐬����
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

" �J�[�\�����w��ʒu�Ɉړ�
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


"--------------------------------------
" �v���O�C��

""" neobundle
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim

    call neobundle#rc(expand('~/.bundle'))
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
NeoBundle 'h1mesuke/vim-alignta'
"NeoBundle 'tyru/coolgrep.vim'
"NeoBundle 'kien/ctrlp.vim'
"NeoBundle 't9md/vim-quickhl'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'mattn/webapi-vim'
"NeoBundle 'mattn/learn-vimscript'
"NeoBundle 'vim-scripts/gtags.vim'
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

NeoBundle 'kana/vim-smartinput'
NeoBundle 'kana/vim-smartchr'

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


NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'bundai223/unite-outline-sources'
NeoBundle 'bundai223/unite-picktodo'

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


"""
let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)
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
endfunction

let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
    let g:vimfiler_as_default_explorer=1
    let g:vimfiler_safe_mode_by_default=0
endfunction

let s:bundle = neobundle#get('vimshell')
function! s:bundle.hooks.on_source(bundle)
    if has('win32')
        let g:vimshell_interactive_cygwin_path='c:/cygwin/bin'
    endif
    let g:vimshell_user_prompt = '$USERNAME . "@" . hostname() . " " . fnamemodify(getcwd(), ":~")'
    let g:vimshell_prompt='$ '
    let g:vimshell_split_command="split"
    
    let g:vimshell_vimshrc_path = expand('~/labo/dotfiles/.vimshrc')
endfunction

let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle)
    " ���̓��[�h�ŊJ�n
    let g:unite_enable_start_insert=1
endfunction

filetype plugin on
filetype indent on

" vital
let g:V = vital#of('vital')

if has('gui')
    " restart
    nnoremap <silent> rs : <C-u> Restart <CR>

    " singleton
    call singleton#enable()
endif

""" vimshell
nnoremap <silent> vs : <C-u> VimShell<CR>


""" neocomplete
" disable AutoComplPop
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default'  : '',
    \ 'vimshell' : '~/.vimshell_hist',
    \ 'cpp'      : '~/.bundle/myvim_dict/cpp.dict',
    \ 'squirrel' : '~/.bundle/myvim_dict/squirrel.dict',
    \ }

" Define keyword.
let g:neocomplete#keyword_patterns = get(g:, 'neocomplete#keyword_patterns', {})
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
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
let g:neocomplete#sources#omni#input_patterns.squirrel  = '[^.[:d:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs        = '[^.]\.\%(\u\{2,}\)\?'
let g:neocomplete#sources#omni#input_patterns.go        = '[^.]\.\%(\u\{2,}\)\?'


""" neosnippet
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
let g:neosnippet#snippets_directory='~/.bundle/mysnip'



""" unite
" <Space>��unite�̃L�[��
nnoremap [unite] <Nop>
nmap <Space> [unite]

" source
" �t�@�C���ꗗ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]d :<C-u>Unite -input=/Home/labo/dotfiles/. -buffer-name=dotfiles file<CR>
" ����
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=history file_mru<CR>
" �A�E�g���C��
nnoremap <silent> [unite]o :<C-u>Unite -vertical -winwidth=30 -buffer-name=outline -no-quit outline<CR>
" todo
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=todo -no-quit picktodo<CR>
" �O���b�v
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=grep -no-quit grep<CR>
" �X�j�y�b�g�T��
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=snippet neosnippet/user<CR>
" NeoBundle�X�V
"nnoremap <silent> [unite]nb :<C-u>Unite -buffer-name=neobundle neobundle/install:!<CR>
nnoremap <silent> [unite]nb :<C-u>Unite -buffer-name=neobundle neobundle/update:all -auto-quit -keep-focus -log<CR>
" �o�b�t�@�ꗗ
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffer buffer<CR>
" Color Scheme
nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=colorscheme -auto-preview colorscheme<CR>
" source �ꗗ
nnoremap <silent> [unite]s :<C-u>Unite source -vertical<CR>

" UniteBuffer�̕���
nnoremap <silent> [unite]r :<C-u>UniteResume<CR>


""" vimfiler
"nnoremap <silent> vf : <C-u> VimFilerExplorer %:h<CR>
nnoremap <silent> vf : <C-u> VimFilerBufferDir -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

""" gtags
nmap     <silent> <Leader>gt  : <C-u>Gtags<Space>
nmap     <silent> <Leader>gtr : <C-u>Gtags -r<Space>
nnoremap <silent> <Leader>gtc : <C-u>GtagsCursor<CR>

""" textobj-multiblock
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)

""" smart chr
" ���Z�q�̊Ԃɋ󔒂�����
inoremap <buffer><expr> < search('^#include\%#', 'bcn')? ' <': smartchr#one_of(' < ', ' << ', '<')
inoremap <buffer><expr> > search('^#include <.*\%#', 'bcn')? '>': smartchr#one_of(' > ', ' >> ', '>')
inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
inoremap <buffer><expr> - smartchr#one_of(' - ', '--', '-')
inoremap <buffer><expr> / smartchr#one_of(' / ', '// ', '/')
" *�̓|�C���^�Ŏg���̂ŁA�󔒂͂���Ȃ�
inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
inoremap <buffer><expr> , smartchr#one_of(', ', ',')
" 3�����Z�q�̏ꍇ�́A���̂݋󔒂�����
inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

" =�̏ꍇ�A�P���ȑ�����r���Z�q�Ƃ��ē��͂���ꍇ�͑O��ɃX�y�[�X�������B
" �������Z����Ƃ��Ă̓��͂̏ꍇ�́A���O�̃X�y�[�X���폜����=�����
inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>%\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
				\ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
				\ : smartchr#one_of(' = ', ' == ', '=')

" ���L�̕����͘A�����Č���邱�Ƃ��܂�Ȃ̂ŁA��񑱂��ē��͂�������s����
inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
" �u->�v�͓��͂��Â炢�̂ŁA..�Œu����
inoremap <buffer><expr> . smartchr#loop('.', '->', '...')
" �s�擪�ł�@���͂ŁA�v���v���Z�X���ߕ������
inoremap <buffer><expr> @ search('^\(#.\+\)\?\%#','bcn')? smartchr#one_of('#define', '#include', '#ifdef', '#endif', '@'): '@'

inoremap <buffer><expr> " search('^#include\%#', 'bcn')? ' "': '"'
" if�������(�͎����ŊԂɋ󔒂�����
inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('

"--------------------------------------
" �L�[�o�C���h

" ESC���ȒP��
imap <C-j> <C-[>
nmap <C-j> <C-[>
vmap <C-j> <C-[>
cmap <C-j> <C-[>

" vim�X�N���v�g���ēǂݍ���
nnoremap <F8> :source %<CR>

" ZZ�őS�ۑ��E�S�I���炵���̂ŕs��
nnoremap ZZ <Nop>

" �⊮�Ăяo��
" imap <C-Space> <C-x><C-n>

" ���O�̃o�b�t�@�Ɉړ�
nnoremap <Leader>b :b#<CR>

" ���t�}�N��
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" �A�ԃ}�N��
" <C-a>�ŉ��Z
" <C-x>�Ō��Z
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor
nnoremap <silent> co : ContinuousNumber <C-a><CR>
vnoremap <silent> <C-a> : ContinuousNumber <C-a><CR>
vnoremap <silent> <C-x> : ContinuousNumber <C-x><CR>

" help�⏕
nnoremap <C-h> :<C-u>help<Space>

" �}�[�N�E���W�X�^�Ȃǈꗗ
" �g��Ȃ�
"nnoremap <Leader>M :<C-u>marks<CR>
"nnoremap <Leader>R :<C-u>registers<CR>
"nnoremap <Leader>B :<C-u>buffers<CR>
"nnoremap <Leader>T :<C-u>tags<CR>

" MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>g :e $MYGVIMRC<CR>

" �����N�����P��Œu��
nnoremap <silent>ciy  ciw<C-r>0<Esc>:let@/=@1<CR>:noh<CR>
nnoremap <silent>cy   ce <C-r>0<Esc>:let@/=@1<CR>:noh<CR>

" �ړ��n
inoremap <Leader>a  <Home>
inoremap <Leader>e  <End>
nnoremap <Leader>a  <Home>
nnoremap <Leader>e  <End>

" �^�u�֘A
nnoremap <Leader>n :<C-u>tabnew<CR>
nnoremap <C-g>l  gt
nnoremap <C-g>h  gT

" �֐��P�ʂňړ�
noremap <C-p> [[
noremap <C-n> ]]

" �J�����g�p�X���o�b�t�@�ɍ��킹��
nnoremap <silent><Leader><Space> :<C-u>cd %:h<CR>:pwd<CR>

" �u��
nnoremap <expr> <Leader>s _(":s/<Cursor>//g")
nnoremap <expr> <Leader>S _(":%s/<Cursor>//g")

" ���[�J���ݒ��ǂݍ���
if filereadable(expand('~/.my_local_vimrc'))
    source ~/.my_local_vimrc
endif

