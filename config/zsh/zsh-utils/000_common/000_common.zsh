
# 数値の合計
sum() {
  if [ -p /dev/stdin ]; then
    args=$(cat -)
  else
    args=$*
  fi

  _num=0
  for i in $args; do
    _num=$((_num+$i))
  done
  echo $_num
}


ls_sshhost() {
  awk '
  tolower($1)=="host" {
  for (i=2; i<=NF; i++) {
    if ($i !~ "[*?]") {
      print $i
    }
  }
}
' ~/.ssh/config | sort
}

ls_ip() {
  LANG=C ifconfig | grep 'inet ' | awk '{print $2;}' | cut -d: -f2
  #LANG=C ifconfig | grep 'inet addr' | awk '{print $2;}' | cut -d: -f2
}

os_version() {
  VERSION_FILE_ARRAY=(\
    '/etc/redhat-release' \
    '/etc/fedora-release' \
    '/etc/debian_version' \
    '/etc/turbolinux-release' \
    '/etc/SuSE-release' \
    '/etc/mandriva-release' \
    '/etc/vine-release' \
    '/etc/issue' \
    )

  if [ 'Darwin' = $(uname) ]; then
    sw_vers
  else
    for file in $VERSION_FILE_ARRAY; do
      if [ -e $file ]; then
        cat $file; break
      fi
    done
  fi
}

# tmux上でsshした際に対象のホスト名に応じてpaneの色を変える
ssh() {
  # tmux起動時
  if [[ -n $(printenv TMUX) ]] ; then
    h=$1
    # 接続先ホスト名に応じて背景色を切り替え
    if [[ `echo $h | grep 'prod-'` ]] ; then
      tmux select-pane -P 'fg=red'
      # tmux select-pane -P 'fg=white'
      # tmux select-pane -P 'bg=blue'
    elif [[ `echo $h | grep 'dev-'` ]] ; then
      tmux select-pane -P 'fg=yellow'
    elif [[ `echo $h | sed 's/^.*@//g' | grep '[0-9.]*'` ]] ; then
      tmux select-pane -P 'fg=green'
      # tmux select-pane -P 'fg=white'
      # tmux select-pane -P 'bg=green'
    fi
    # 通常通りssh続行
    command ssh $@
    # デフォルトの背景色に戻す
    tmux select-pane -P 'default'

  else
    command ssh $@
  fi
}

# mkdir & cd newdir.
function mkcddir() {
  eval dirpath=$"$#"
  mkdir ${@} && cd $dirpath
}

function grepall() { git ls-files | xargs grep -l $1 }
function sedall()  { grepall $1 | xargs sed -i "s/$1/$2/g" }
function renameall() { git ls-files | grep $1 | while read LINE; do mv $LINE `echo $LINE | sed s/$1/$2/g`; done }
