### Introduction {{{
#
#  .zshrc
#
#  (in $ZDOTDIR : default $HOME)
#
#  initial setup file for only interective zsh
#  This file is read after .zprofile file is read.
#
#   zshマニュアル(日本語)
#    http://www.ayu.ics.keio.ac.jp/~mukai/translate/zshoptions.html
#
#   autoload
#    -U : ファイルロード中にaliasを展開しない(予期せぬaliasの書き換えを防止)
#    -z : 関数をzsh-styleで読み込む
#
#   typeset
#    -U 重複パスを登録しない
#    -x exportも同時に行う
#    -T 環境変数へ紐付け
#
#   path=xxxx(N-/)
#     (N-/): 存在しないディレクトリは登録しない。
#     パス(...): ...という条件にマッチするパスのみ残す。
#        N: NULL_GLOBオプションを設定。
#           globがマッチしなかったり存在しないパスを無視する
#        -: シンボリックリンク先のパスを評価
#        /: ディレクトリのみ残す
#        .: 通常のファイルのみ残す
#
#************************************************************************** }}}
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

#---------------------------------------------
# 基本の設定
#---------------------------------------------
# ref) http://voidy21.hatenablog.jp/entry/20090902/1251918174

# zsh補完強化 {{{
# http://qiita.com/PSP_T/items/ed2d36698a5cc314557d
# 補完候補のハイライト
zstyle ':completion:*:default' menu select=2
# 補完関数の表示を強化する
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _oldlist _expand _complete _match _prefix _approximate _list
zstyle ':completion:*:messages' format '%F{YELLOW}%d%f'
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d%f'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# path
zstyle ':completion:*:sudo:*' command-path \
  /usr/local/bin \
  /usr/sbin \
  /usr/bin \
  /sbin \
  /bin

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# fpathの設定が終わってから補完有効設定を行う
# ref : http://yonchu.hatenablog.com/entry/20120415/1334506855
# 補完有効
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit -u

typeset -U path PATH

# cdの関連
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

## LS_COLORSを設定しておく
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#
## ファイル補完候補に色を付ける
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 小文字は大文字とごっちゃで検索できる
# 大文字は小文字と区別される
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ディレクトリを切り替える時の色々な補完スタイル
#あらかじめcdpathを適当に設定しておく
cdpath=(~ ~/repos/)
# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion:*:' ignore-parents parent pwd

# 補完で表示しない例外設定
zstyle ':completion:*:*:cd:*' ignored-patterns '.svn|.git'
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?.pyc' '*\~'
# ls,rmはすべてを補完
zstyle ':completion:*:ls:*' ignored-patterns
zstyle ':completion:*:rm:*' ignored-patterns

# aws cli
if (test -e /usr/local/bin/aws_completer); then
  complete -C '/usr/local/bin/aws_completer' aws
fi

# }}}

setopt nobeep               # ビープ音なし
setopt ignore_eof           # C-dでログアウトしない
setopt no_auto_param_slash  # 自動で末尾に/を補完しない
setopt auto_pushd           # cd履歴を残す
setopt pushd_ignore_dups    # 重複cd履歴は残さない

# History setting {{{
# End of lines added by compinstal
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory extendedglob notify
setopt extended_history

# 重複する履歴は保存しない
setopt hist_ignore_dups
# 先頭にスペースがあると履歴保存しない
setopt hist_ignore_space

# history 共有
setopt share_history

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# 古いコマンドと同じものは無視
setopt hist_save_no_dups

# 補完時にヒストリを自動的に展開
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# 全履歴表示
function history-all { history -i 1 }

# 最後に入力した内容を貼り付ける
autoload -Uz smart-insert-last-word
# [a-zA-Z], /, \ のうち少なくとも1文字を含む長さ2以上の単語
zstyle :insert-last-word match '*([[:alpha:]/\\]?|?[[:alpha:]/\\])*'
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word
#}}}

# Command line stack
# http://qiita.com/ikm/items/1f2c7793944b1f6cc346
show_buffer_stack() {
  POSTDISPLAY="
  stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack


# Key bind
bindkey -e # emacs風バインド

# bindkey -v # vi風バインド
# bindkey $'\e' vi-cmd-mode

# 履歴表示
# 履歴から入力の続きを補完
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

bindkey " " magic-space

# コマンドラインスタックをviバインドで使用できるように
setopt noflowcontrol
bindkey '^Q' show_buffer_stack

#########################################
# Show ls & git status when pressed only enter.
function ls_and_git_status() {
  echo
  ls -FG
  # ls_abbrev
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    echo
    echo -e "\e[0;33m--- git status ---\e[0m"
    git status -sb
  fi

  echo
  echo
}

# expand global aliases by space
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
# globalias() {
#   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
#     zle _expand_alias
#     # zle expand-word
#   fi
#   zle self-insert
# }
#
# zle -N globalias
#
# bindkey " " globalias
#
# function expand_alias() {
#   zle _expand_alias
#   zle expand-word
# }

# Enter時のコールバック
# ref) http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
function do_enter() {
  # 何か入力があればそれを実行して終わり
  if [ -n "$BUFFER" ]; then
    # expand_alias
    zle accept-line
    return 0
  fi

  # emptyでreturn key入力時は
  #   ls
  #   git status
  # してあげる
  ls_and_git_status

  zle reset-prompt
  return 0
}

zle -N do_enter
bindkey '^m' do_enter


#########################################
# Alias
if [[ $OSTYPE != darwin* ]]; then
  open() {
    which xdg-open > /dev/null 2>&1 && xdg-open $@
    which gnome-open > /dev/null 2>&1 && gnome-open $@
    echo $@ # TODO: not implement
  }
fi

p() {
  local pecoopts=()
  while [[ "$#" -gt 0 ]]; do case $1 in
    -*) pecoopts+=($1);;
    *) break;;
  esac; shift; done

  $FILTER_CMD $pecoopts | while read LINE; do $@ $LINE; done
}

alias ls='colorls'
alias ls_font='fc-list'
alias o='git ls-files | p open'
alias c='ghq list -p | p cd'
alias h='history -i'; compdef h=history
alias l='ls -FG'; compdef l=ls
alias ll='ls -lFG'; compdef ll=ls
alias la='ls -lFGa'; compdef la=ls
alias pd=popd; compdef pd=popd
alias history='history -i'

alias ocaml='rlwrap ocaml'

alias reload_zshrc='source ~/.zshrc'

alias find-vimbackup='find **/*~'

# vim
# alias nv='nvimalter'
# alias nvim='nvimalter'
# alias vim='nvimalter'
# alias v='nvimalter'

# silver searcher
alias ag='ag -S'

# docker
alias d='docker'; compdef d=docker
alias dc='UID=$(id -u) GID=$(id -g) docker compose'
alias docker_rm_images='docker images -qf dangling=true | xargs docker rmi'
alias docker_rm_containers='docker ps -aqf status=exited | xargs docker rm -v' # rm with volumes
alias docker_rm_volumes='docker volume ls -qf dangling=true | xargs docker volume rm'
alias docker_rm_compose_containers='docker compose rm -fv'

function dcattach() {
  service=$1
  container_name=$(docker compose ps ${service} | sed '1d' | awk '{print $1}')

  how_to_detach=$(cat << EOUSAGE
Attaching: ${container_name}!
How to Detach: Ctrl+P, Ctrl+Q
EOUSAGE
)
  echo $how_to_detach

  if [ -n "$TMUX" ]; then
    # paneを新規で開いてattach
    # 抜けたらpane閉じてみる
    # tmux split-window -v -c "#{pane_current_path}"
    tmux select-pane -T "🐳 ${container_name}: C+p,C+q"
    docker attach $container_name

    tmux select-pane -T $(hostname)
  else
    docker attach $container_name
  fi
}

# git
# alias g='git'
function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}
compdef g=git
alias gittaglist="git for-each-ref --sort=-taggerdate --format='%(taggerdate:short) %(tag) %(taggername) %(subject)' refs/tags"
alias gf='git flow'; compdef gf=git-flow

# docker
# System Manager pluginとの連携ができないのでawsはdockerやめる
# function aws() {
#   docker run -e AWS_PROFILE=$AWS_PROFILE -e AWS_REGION=$AWS_REGION -it --rm -v $(pwd):/aws -v ~/.aws:/root/.aws amazon/aws-cli $@
# }
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
# alias hadolint="docker run -i --rm hadolint/hadolint"
alias marp='docker run --rm --init -v $(pwd):/workdir -w /workdir -e LANG=$LANG -p 8080:8080 marpteam/marp-cli'
alias mysql='mycli'
alias owasp='docker run -v $(pwd):/zap/wrk/:rw -t --rm owasp/zap2docker-stable zap-baseline.py ' # -t https://coupa-staging-nowaf.ai-q.biz/XkEgFLFJHaHUZn_pxeQn/contact/top -r testreport.html
alias pandoc='docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/core'
alias gixy='docker run --rm -v $(pwd):/workdir -w /workdir yandex/gixy'
alias dive='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v  "$(pwd)":"$(pwd)" -w "$(pwd)" -v "$HOME/.dive.yaml":"$HOME/.dive.yaml" wagoodman/dive:latest'

# filetype
alias -s html=chrome
alias -s rb=ruby
alias -s py=python

# global alias
alias -g LL='| less'
alias -g HH='| head'
alias -g TT='| tail'
alias -g GG='| grep'
alias -g WW='| wc'
alias -g SS='| sed'
alias -g AA='| awk'
alias -g WW='| wc'
alias -g XX='| xargs'
alias -g PP='| peco'

# http://k0kubun.hatenablog.com/entry/2014/07/06/033336
# git branchはsortしたら*でちょうどいいところに来た
# 次点は git branch | sed -n '/\*/=' とか
alias -g B='`git branch | sort -r | $FILTER_CMD | sed -e "s/^\*[ ]*//g"`'
alias -g BR='`git branch -r | sort -r | $FILTER_CMD| sed -e "s/^\*[ ]*//g"`'
alias -g BALL='`git branch -a | sort -r | $FILTER_CMD| sed -e "s/^\*[ ]*//g"`'
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

# alias v="vagrant"
function va() {
  if [[ $# -gt 0 ]]; then
    vagrant "$@"
  else
    vagrant status
  fi
}
alias v_restart="vagrant halt; vagrant up"

if [[ -f ~/repos/github.com/dylanaraps/neofetch/neofetch ]]; then
  alias neofetch='~/repos/github.com/dylanaraps/neofetch/neofetch'
fi
## man zshall
# ref) http://qiita.com/yuyuchu3333/items/67630d597c7700a51b95
# zman [search word]
zman() {
  if [[ -n $1 ]]; then
    PAGER="less -g -s '+/"$1"'" man zshall
    echo "Search word: $1"
  else
    man zshall
  fi
}

# zsh 用語検索
# http://qiita.com/mollifier/items/14bbea7503910300b3ba
zwman() {
  zman "^       $1"
}

# zsh フラグ検索
zfman() {
  local w='^'
  w=${(r:8:)w}
  w="$w${(r:7:)1}|$w$1(\[.*\].*)|$w$1:.*:|$w$1/.*/.*"
  zman "$w"
}

# Man colorfull
function man (){
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    LANG=C \
    man "$@"
}
#}}}

# ctrl + x -> d
# 日付挿入
function print_date() {
  zle -U `date "+%Y%m%d"`
}
zle -N print_date
bindkey "^Xd" print_date

# neovim-remoteでneovimのカレントディレクトリを移動
function nvcd (){
  nvr -c "cd $(realpath $@)"
}

# 3秒以上かかる処理の後にtimeコマンドの結果を表示してくれる
REPORTTIME=3

# Ctrl+wでパス一段づつ削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# for tmux {{{
# Pane split on startup
# ref) http://qiita.com/ken11_/items/1304c2eecc2657ac6265
alias t='tmux_start'
alias tm='tmux_multissh'
#}}}

# plugin
# ローカル用設定を読み込む
if [ -f ${PERSONAL_ZSH_DIR}/.zshrc.plugin ]; then
  source ${PERSONAL_ZSH_DIR}/.zshrc.plugin
fi

# Load utility scripts. {{{
# utils_dir=~/repos/github.com/bundai223/dotfiles/config/zsh/zsh-utils
# source ~/repos/github.com/bundai223/dotfiles/config/zsh/zsh-utils/scripts/functions.zsh
# source_scripts_in_tree $utils_dir
# }}}

# Prompt setting {{{
# 実際のプロンプトの表示設定
autoload -Uz colors && colors

# prompt
# http://tegetegekibaru.blogspot.com/2012/08/zsh_2.html
# if [ -n "$TMUX" ]; then
#   # tmux連携用のprompt
#   PROMPT="%{${bg[blue]%}%}%{${fg[black]}%} %n %{${bg[white]}%}%{${fg[blue]}%}%{${bg[white]}%}%{${fg[black]}%} %c %{${reset_color}%}%{${fg[white]}%}%{${reset_color}%} $%{${reset_color}%}%{${fg[white]}%} %{${reset_color}%} "
# else
#   source ${PERSONAL_ZSH_DIR}/themes/prompt_vcsinfo.zsh
#   #source ${PERSONAL_ZSH_DIR}/themes/prompt_cygwin.zsh   # prompt
#   #source ${PERSONAL_ZSH_DIR}/themes/rprompt_vcsinfo.zsh # rprompt
# fi

# source ~/.local/lib/python3.10/site-packages/powerline/bindings/zsh/powerline.zsh
# export PIP_SITE_LOCATION=$(pip show -f powerline-status | grep Location | awk '{print $2}')
source ${PIP_SITE_LOCATION}/powerline/bindings/zsh/powerline.zsh

#}}}

# for z
# http://d.hatena.ne.jp/naoya/20130108/1357630895
_Z_DATA=~/.config/zsh/z/.z
if [[ $OSTYPE == darwin* ]]; then
  . `brew --prefix`/etc/profile.d/z.sh
else
  . ~/repos/github.com/rupa/z/z.sh
fi
# precmd_z () {
#   z --add "$(pwd -P)"
# }
# add-zsh-hook precmd precmd_z


if [ -n "$TMUX" ]; then
  # tmux用powerlineのcwd更新
  update_tmux_cwd() {
    tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD"
  }
  add-zsh-hook chpwd update_tmux_cwd
fi

# OPAM configuration
# . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# direnv
which direnv >/dev/null && eval "$(direnv hook zsh)"

[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor

# profiler utility
function zsh-profiler() {
  ZSHRC_PROFILE=1 zsh -i -c zprof
}

# 配下のdirectoryに移動するcd
alias cdd='source $(which cdd_cmd)'

cd_repos() {
  if [ -n "$1" ]; then
    pth=$(ghq list --full-path | sed "s#${HOME}#~#"| fzf -q $1 | sed "s#~#${HOME}#") # fzf -q querystring
    # pth=$(ghq list --full-path | sed "s#${HOME}#~#"| peco --query $1 | sed "s#~#${HOME}#") # fzf -q querystring
  else
    pth=$(ghq list --full-path | sed "s#${HOME}#~#"| $FILTER_CMD | sed "s#~#${HOME}#")
  fi
  if [ -n "$pth" ]; then
    eval "cd $pth"
  fi
}

# https://qiita.com/Rasukarusan/items/61f435bf899dc99d7e79#%E3%82%AB%E3%83%AC%E3%83%B3%E3%83%88%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E3%82%92finder%E3%81%A7%E9%96%8B%E3%81%8Foo%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89
alias myip='curl ifconfig.io -4'

alias tenki='curl -4 http://wttr.in/kanagawa'
