# tmux

# tmux起動
tmux_start()
{
  if ! type tmux >/dev/null 2>&1; then
    echo 'Error: tmux command not found' 2>&1
    return 1
  fi

  if [ -n "$TMUX" ]; then
    # echo "Error: tmux session has been already attached" 2>&1
    return 1
  fi

  if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -v attached > /dev/null 2>&1; then
    # detached session exists
    tmux -2 attach -d && echo "tmux attached session "
  else
    if [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null) ) ]]; then
      # on OS X force tmux's default command to spawn a shell in the user's namespace
      tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
      tmux -2 -f <(echo "$tmux_config") new-session $* && echo "tmux created new session supported OS X"
    else
      tmux -2 new-session $* && echo "tmux created new session"
    fi
  fi
}

tmux_multissh()
{
  session=multi-ssh-`date +%s`
  window=multi-ssh

  if [ -z "$TMUX" ]; then
    tmux_start -d -n $window -s $session
  fi
#   tmux rename-window $window

  ### 各ホストにsshログイン
  # 最初の1台はsshするだけ
  tmux send-keys "ssh $1" C-m
  shift

  pane_num=$#
  layout=tiled
  if [ $pane_num -lt 6 ]; then
    layout=even-vertical
  fi
  # 残りはpaneを作成してからssh
  for i in $*;do
    tmux split-window
    tmux send-keys "ssh $i" C-m
    tmux select-layout $layout
  done

  ### 最初のpaneを選択状態にする
  tmux select-pane -t 0

  ### paneの同期モードを設定
  tmux set-window-option synchronize-panes on

  tmux attach -t $session
}


#if [ -n "$TMUX" ]; then
#  _tmux_pane_preexec() {
#    tmux select-pane -T "local: ${1%% *}"
#  }
#  add-zsh-hook preexec _tmux_pane_preexec
#fi
