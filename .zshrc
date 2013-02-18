# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
# zstyle :compinstall filename '/home/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstal
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt appendhistory extendedglob notify
bindkey -e
# End of lines configured by zsh-newuser-install

autoload colors
colors
#export PROMPT="%B%{${fg[red]}%}[%n@%m] %/
#%# %{${reset_color}%}%b"
PS1="[${USER}@${HOST%%.*} %1~]%(!.#.$) " 

alias ls='ls -G'

# local setting load
if [ -f ~/.local_zshrc ]; then
    . ~/.local_zshrc
fi


