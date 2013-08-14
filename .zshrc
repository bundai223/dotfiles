#---------------------------------------------
# ��{�̐ݒ�
#---------------------------------------------
# �ǂ�������̃R�s�y
# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
# �������͑啶���Ƃ�������Ō����ł���
# �啶���͏������Ƌ�ʂ����
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cd�ŕ\�����Ȃ���O�ݒ�
zstyle ':completion:*:*:cd:*' ignored-patterns '.svn|.git'

# �⊮�L��
autoload -Uz compinit
compinit



setopt nobeep               # �r�[�v���Ȃ�
setopt ignore_eof           # C-d�Ń��O�A�E�g���Ȃ�
setopt rm_star_silent       # rm *�Ŋm�F�����Ȃ�
setopt no_auto_param_slash  # �����Ŗ�����/��⊮���Ȃ�
setopt auto_pushd           # cd�������c��


export EDITOR=vim

#---------------------------------------------
# �����̐ݒ�
#---------------------------------------------
# End of lines added by compinstal
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory extendedglob notify

# �d�����闚���͕ۑ����Ȃ�
setopt hist_ignore_dups
# �擪�ɃX�y�[�X������Ɨ���ۑ����Ȃ�
setopt hist_ignore_space

#---------------------------------------------
# �L�[�o�C���h
#---------------------------------------------
# vi��
#
# ��ԉ��ɃX�e�[�^�X�o�[�\���X�N���v�g
#
bindkey -v

# ����\��
# ����������͂̑�����⊮
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

bindkey " " magic-space


alias ls='ls -a'
alias lsl='ls -la'
alias pd=popd

#---------------------------------------------
# �^�[�~�i���̃��[�U�[�\����ݒ�
#---------------------------------------------
# �o�[�W�����Ǘ��̏�Ԃɍ��킹���\��
autoload -Uz vcs_info
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
# ���ۂ̃v�����v�g�̕\���ݒ�
autoload -Uz colors && colors

PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%1v%{${reset_color}%}
%(!.#.$) "

# ���[�J���p�ݒ��ǂݍ���
if [ -f ~/.local_zshrc ]; then
    . ~/.local_zshrc
fi

fpath=(~/.zsh/functions/ $fpath)

# vim�L�[�o�C���h�̃��[�h�ɂ���ē��̓v�����v�g�̐擪�̐F��ύX
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
        PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%1v%{${reset_color}%}
%{$bg_bold[magenta]%}%(!.#.$)%{$reset_color%} "
    ;;
    main|viins)
        PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%1v%{${reset_color}%}
%(!.#.$) "
    ;;
  esac
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

