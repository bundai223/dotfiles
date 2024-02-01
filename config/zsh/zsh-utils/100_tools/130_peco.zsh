# peco

peco_find_ext() {
  find . -name '*.'$1 | $FILTER_CMD
}

# peco_ssh() {
#   ls_sshhost | p ssh
# }
#
peco_history() {
  history -E 1 | $FILTER_CMD | awk '{c="";for(i=4;i<=NF;i++) c=c $i" "; print c}'
}

peco_gitmodified() {
  git status --short | $FILTER_CMD | sed s/"^..."//
}
