# %# : 一般ユーザなら%、スーパーユーザなら#
# %H : ホスト名
# %m : ホスト名のうち最初のドットの前まで
# %d : カレントディレクトリのパス
# %~ : カレントディレクトリのパス(ホームの場合~)
# %n : ユーザ名
# %D : 年月日
# %* : 時分秒
NORMAL_MODE_PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*}%{${reset_color}%} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$bg_bold[magenta]%}%(!.#.$)%{$reset_color%} "

INSERT_MODE_PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*}%{${reset_color}%} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$reset_color%}%(!.#.$)%{$reset_color%} "

PROMPT=${INSERT_MODE_PROMPT}

# Set prompt color by vim mode.
function update_vi_mode () {
  case $KEYMAP in
    vicmd)
      PROMPT=${NORMAL_MODE_PROMPT}
      ;;
    main|viins)
      PROMPT=${INSERT_MODE_PROMPT}
      ;;
  esac
  zle reset-prompt
}

function zle-line-init {
  # auto-fu-init
  update_vi_mode
}

function zle-keymap-select {
  update_vi_mode
}

zle -N zle-line-init
zle -N zle-keymap-select


