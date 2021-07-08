# peco

peco_find_ext() {
  find . -name '*.'$1 | $FILTER_CMD
}

peco_ssh() {
  ls_sshhost | p ssh
}

peco_history() {
  history -E 1 | $FILTER_CMD | awk '{c="";for(i=4;i<=NF;i++) c=c $i" "; print c}'
}

peco_gitmodified() {
  git status --short | $FILTER_CMD | sed s/"^..."//
}

# http://k0kubun.hatenablog.com/entry/2014/07/06/033336
alias -g B='`git branch | $FILTER_CMD | sed -e "s/^\*[ ]*//g"`'
alias -g BR='`git branch -r | $FILTER_CMD| sed -e "s/^\*[ ]*//g"`'
alias -g BALL='`git branch -a | $FILTER_CMD| sed -e "s/^\*[ ]*//g"`'
alias -g T='`git tag | $FILTER_CMD`'
alias -g C='`git log --oneline | $FILTER_CMD| sed -e "s/^.*\* *\([a-f0-9]*\) .*/\1/g" -e "s/^[\|/ ]*$//g"`'
# alias -g C='`git log --oneline | $FILTER_CMD| cut -d" " -f1`'
alias -g CALL='`git log --decorate --branches --all --graph --oneline --all | $FILTER_CMD| sed -e "s/^.*\* *\([a-f0-9]*\) .*/\1/g" -e "s/^[\|/ ]*$//g"`'
alias -g F='`git ls-files | $FILTER_CMD`'
# alias -g K='`bundle exec kitchen list | tail -n +2 | $FILTER_CMD| cut -d" " -f1`'
# alias -g P='`docker ps | tail -n +2 | $FILTER_CMD| cut -d" " -f1`'
alias -g R='`git reflog | $FILTER_CMD| cut -d" " -f1`'
# alias -g V='`vagrant box list | $FILTER_CMD| cut -d" " -f1`'
#
alias -g TM='`tmux list-sessions`'
alias -g HIST='`peco_history`'
