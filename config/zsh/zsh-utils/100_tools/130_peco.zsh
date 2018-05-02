# peco

# cd git repository
cd_repos() {
  cd $(ghq list -p | peco)
}

peco_find_ext() {
  find . -name '*.'$1 | peco
}

peco_ssh() {
  ssh $(ls_sshhost | peco)
}

peco_history() {
  history -E 1 | peco | awk '{c="";for(i=4;i<=NF;i++) c=c $i" "; print c}'
}

peco_gitmodified() {
  git status --short | peco | sed s/"^..."//
}

# http://k0kubun.hatenablog.com/entry/2014/07/06/033336
alias -g B='`git branch | peco | sed -e "s/^\*[ ]*//g"`'
alias -g BR='`git branch -r | peco | sed -e "s/^\*[ ]*//g"`'
alias -g BALL='`git branch -a | peco | sed -e "s/^\*[ ]*//g"`'
alias -g T='`git tag | peco`'
alias -g C='`git log --oneline | peco | sed -e "s/^.*\* *\([a-f0-9]*\) .*/\1/g" -e "s/^[\|/ ]*$//g"`'
# alias -g C='`git log --oneline | peco | cut -d" " -f1`'
alias -g CALL='`git log --decorate --branches --all --graph --oneline --all | peco | sed -e "s/^.*\* *\([a-f0-9]*\) .*/\1/g" -e "s/^[\|/ ]*$//g"`'
alias -g F='`git ls-files | peco`'
# alias -g K='`bundle exec kitchen list | tail -n +2 | peco | cut -d" " -f1`'
# alias -g P='`docker ps | tail -n +2 | peco | cut -d" " -f1`'
alias -g R='`git reflog | peco | cut -d" " -f1`'
# alias -g V='`vagrant box list | peco | cut -d" " -f1`'
#
alias -g TM='`tmux list-sessions`'
alias -g HIST='`peco_history`'
