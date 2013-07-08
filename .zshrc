#---------------------------------------------
# 基本の設定
#---------------------------------------------
# どっかからのコピペ
# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
# 小文字は大文字とごっちゃで検索できる
# 大文字は小文字と区別される
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cdで表示しない例外設定
zstyle ':completion:*:*:cd:*' ignored-patterns '.svn|.git'

# 補完有効
autoload -Uz compinit
compinit



setopt nobeep               # ビープ音なし
setopt ignore_eof           # C-dでログアウトしない
setopt rm_star_silent       # rm *で確認ださない
setopt no_auto_param_slash  # 自動で末尾に/を補完しない
setopt auto_pushd           # cd履歴を残す


export EDITOR=vim

#---------------------------------------------
# 履歴の設定
#---------------------------------------------
# End of lines added by compinstal
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory extendedglob notify

# 重複する履歴は保存しない
setopt hist_ignore_dups
# 先頭にスペースがあると履歴保存しない
setopt hist_ignore_space

#---------------------------------------------
# キーバインド
#---------------------------------------------
# vi風
#
# 一番下にステータスバー表示スクリプト
#
bindkey -v

# 履歴表示
# 履歴から入力の続きを補完
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

bindkey " " magic-space


alias ls='ls -a'
alias lsl='ls -la'
alias pd=popd

#---------------------------------------------
# ターミナルのユーザー表示を見慣れた感じに設定
#---------------------------------------------
autoload -Uz colors && colors
#PS1="[${USER}@${HOST%%.*} %1~]%(!.#.$) "

PS1="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "


# ローカル用設定を読み込む
if [ -f ~/.local_zshrc ]; then
    . ~/.local_zshrc
fi

fpath=(~/.zsh/functions/ $fpath)

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
      PS1="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$bg_bold[magenta]%}%(!.#.$)%{$reset_color%} "
    ;;
    main|viins)
      PS1="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "
    ;;
  esac
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

