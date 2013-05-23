"---------------------------------
" �����ڂ̐ݒ�
"---------------------------------
colorscheme molokai

" IME�̏�ԂŃJ�[�\���F�ύX
" colorscheme�ł̐ݒ���㏑�����邽��
" colorscheme����ŋL�q
"IME��Ԃɉ������J�[�\���F��ݒ�
if has('multi_byte_ime')
  highlight Cursor guifg=Black guibg=#cccccc gui=bold
  highlight CursorIM guifg=NONE guibg=Violet gui=bold
endif

" �S�p�X�y�[�X��\��
highlight ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=red
au BufNew,BufRead * match ZenkakuSpace /�@/

set cursorline

"---------------------------------
" �E�C���h�E�Ȃǂ̐ݒ�
"---------------------------------
" �\���s��
"" �c
"set lines=60
"" ��
"set columns=124


" �����܂�Ԃ��Ȃ�
set nowrap


" gvim�̃c�[���o�[�Ȃǂ̐ݒ�
set guioptions-=T "�c�[���o�[�Ȃ�
set guioptions-=m "���j���[�o�[�Ȃ�
set guioptions-=r "�E�X�N���[���o�[�Ȃ�
set guioptions-=R
set guioptions-=l "���X�N���[���o�[�Ȃ�
set guioptions-=L
set guioptions-=b "���X�N���[���o�[�Ȃ�

if has('mac')
    set transparency=25
endif
"---------------------------------
" �t�H���g�ݒ�:
"---------------------------------
if has('win32')
  " Windows�p
  set guifont=MS_Gothic:h10:cSHIFTJIS
  " �s�Ԋu�̐ݒ�
  set linespace=1
  " �ꕔ��UCS�����̕��������v�����Č��߂�
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
"  set guifont=Osaka�|����:h14
  set guifont=Ricty Regular:h12
elseif has('xfontset')
  " UNIX�p (xfontset���g�p)
  set guifontset=a14,r14,k14
endif

"---------------------------------
" vim script
"---------------------------------
" full screen
nnoremap <F11> : call ToggleFullScreen()<CR>
function! ToggleFullScreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    simalt ~r
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    simalt ~x
  endif
endfunction

" neobundle
NeoBundleSource restart.vim
NeoBundleSource vim-singleton

" ���[�J���ݒ��ǂݍ���
if filereadable(expand('~/.my_local_gvimrc'))
    source ~/.my_local_gvimrc
endif

