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
# zstyle :compinstall filename '/home/.zshrc'

# �⊮�L��
autoload -Uz compinit
compinit


# �r�[�v���Ȃ�
setopt nobeep

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
bindkey -v

# ����\��
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history

#
# ��ԉ��ɃX�e�[�^�X�o�[�\���X�N���v�g
#

#---------------------------------------------
# �^�[�~�i���̃��[�U�[�\���������ꂽ�����ɐݒ�
#---------------------------------------------
autoload colors
colors
#PS1="[${USER}@${HOST%%.*} %1~]%(!.#.$) "

PS1="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "

alias ls='ls -G'

# ���[�J���p�ݒ��ǂݍ���
if [ -f ~/.local_zshrc ]; then
    . ~/.local_zshrc
fi

fpath=(~/.zsh/functions/ $fpath)



#---------------------------------------------
# Set vi mode status bar
#---------------------------------------------
# Reads until the given character has been entered.
#
readuntil () {
    typeset a
    while [ "$a" != "$1" ]
    do
        read -E -k 1 a
    done
}

#
# If the $SHOWMODE variable is set, displays the vi mode, specified by
# the $VIMODE variable, under the current command line.
# 
# Arguments:
#
#   1 (optional): Beyond normal calculations, the number of additional
#   lines to move down before printing the mode.  Defaults to zero.
#
showmode() {
    typeset movedown
    typeset row

    # Get number of lines down to print mode
    movedown=$(($(echo "$RBUFFER" | wc -l) + ${1:-0}))
    
    # Get current row position
    echo -n "\e[6n"
    row="${${$(readuntil R)#*\[}%;*}"
    
    # Are we at the bottom of the terminal?
    if [ $((row+movedown)) -gt "$LINES" ]
    then
        # Scroll terminal up one line
        echo -n "\e[1S"
        
        # Move cursor up one line
        echo -n "\e[1A"
    fi
    
    # Save cursor position
    echo -n "\e[s"
    
    # Move cursor to start of line $movedown lines down
    echo -n "\e[$movedown;E"
    
    # Change font attributes
    echo -n "\e[1m"
    
    # Has a mode been set?
    if [ -n "$VIMODE" ]
    then
        # Print mode line
        echo -n "-- $VIMODE -- "
    else
        # Clear mode line
        echo -n "\e[0K"
    fi

    # Restore font
    echo -n "\e[0m"
    
    # Restore cursor position
    echo -n "\e[u"
}

clearmode() {
    VIMODE= showmode
}

#
# Temporary function to extend built-in widgets to display mode.
#
#   1: The name of the widget.
#
#   2: The mode string.
#
#   3 (optional): Beyond normal calculations, the number of additional
#   lines to move down before printing the mode.  Defaults to zero.
#
makemodal () {
    # Create new function
    eval "$1() { zle .'$1'; ${2:+VIMODE='$2'}; showmode $3 }"

    # Create new widget
    zle -N "$1"
}

# Extend widgets
makemodal vi-add-eol           INSERT
makemodal vi-add-next          INSERT
makemodal vi-change            INSERT
makemodal vi-change-eol        INSERT
makemodal vi-change-whole-line INSERT
makemodal vi-insert            INSERT
makemodal vi-insert-bol        INSERT
makemodal vi-open-line-above   INSERT
makemodal vi-substitute        INSERT
makemodal vi-open-line-below   INSERT 1
makemodal vi-replace           REPLACE
makemodal vi-cmd-mode          NORMAL

unfunction makemodal