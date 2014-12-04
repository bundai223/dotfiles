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
autoload -U compinit
compinit -u

# LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# }}}

# 小文字は大文字とごっちゃで検索できる
# 大文字は小文字と区別される
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cdで表示しない例外設定
zstyle ':completion:*:*:cd:*' ignored-patterns '.svn|.git'


setopt nobeep               # ビープ音なし
setopt ignore_eof           # C-dでログアウトしない
setopt no_auto_param_slash  # 自動で末尾に/を補完しない
setopt auto_pushd           # cd履歴を残す

# 個別にパス設定が必要な場合は.zshrc_localで再設定する。

# ローカル用設定を読み込む
if [ -f ${PERSONAL_ZSH_DIR}/.zshrc.antigen ]; then
    source ${PERSONAL_ZSH_DIR}/.zshrc.antigen
fi

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

bindkey $'\e' vi-cmd-mode

# 全履歴表示
function history-all { history -E 1 }

#}}}

# Command line stack {{{
# http://qiita.com/ikm/items/1f2c7793944b1f6cc346
show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack

# }}}

# Key bind {{{
# vi風バインド
bindkey -v

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
#}}}

# Show ls & git status when pressed only enter. {{{
# ref) http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
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
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter
# }}}

# mkdir & cd newdir. {{{
function mkcddir() {
    eval dirpath=$"$#"
    mkdir ${@} && cd $dirpath
}
# }}}

# Alias {{{
alias SU='sudo -H -s'
alias ls='ls -FG'
alias lsl='ls -lFG'
alias lsdir='ls -FG | grep /'
alias lsfile='ls -FG | grep -v /'
alias pd=popd

alias ocaml='rlwrap ocaml'

alias reload_zshrc='source ~/.zshrc'

alias find-vimbackup='find **/*~'

# silver searcher
alias ag='ag -S'

alias g='git'

# git {{{
alias gittaglist="git for-each-ref --sort=-taggerdate --format='%(taggerdate:short) %(tag) %(taggername) %(subject)' refs/tags"
alias gf=git-flow
# }}}

alias -s html=chrome
alias -s rb=ruby
alias -s py=python

alias -g LL='| less'
alias -g HH='| head'
alias -g TT='| tail'
alias -g GG='| grep'
alias -g WW='| wc'
alias -g SS='| sed'
alias -g AA='| awk'
alias -g WW='| wc'
alias -g XX='| xargs'

alias ssh="cat ~/.ssh/conf.d/*.conf > ~/.ssh/config;ssh"
alias scp="cat ~/.ssh/conf.d/*.conf > ~/.ssh/config;scp"
alias git="cat ~/.ssh/conf.d/*.conf > ~/.ssh/config;git"
alias knife="cat ~/.ssh/conf.d/*.conf > ~/.ssh/config;knife"

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

# ローカル用設定を読み込む
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# Prompt setting {{{
# 実際のプロンプトの表示設定
autoload -Uz colors && colors

NORMAL_MODE_PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$bg_bold[magenta]%}%(!.#.$)%{$reset_color%} "

INSERT_MODE_PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$reset_color%}%(!.#.$)%{$reset_color%} "

PROMPT=${INSERT_MODE_PROMPT}

# Set prompt color by vim mode. {{{
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
    auto-fu-init
    update_vi_mode
}

function zle-keymap-select {
    update_vi_mode
}

zle -N zle-line-init
zle -N zle-keymap-select

#}}}

# Show vcsinfo RPROMPT. {{{
# https://github.com/yonchu/dotfiles/blob/master/.zsh/themes/yonchu-2lines.zsh-theme

# バージョン管理の状態に合わせた表示
autoload -Uz vcs_info
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

BRANCH='%F{white}%b%f'
VCS_NAME='%F{gray}(%s)%f'
#
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
# 以下の3つのメッセージをエクスポートする
#   $vcs_info_msg_0_ : 通常メッセージ用 (緑)
#   $vcs_info_msg_1_ : 警告メッセージ用 (黄色)
#   $vcs_info_msg_2_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 3

zstyle ':vcs_info:*' enable git svn hg bzr
# 標準のフォーマット(git 以外で使用)
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats $BRANCH$VCS_NAME
zstyle ':vcs_info:*' actionformats $BRANCH$VCS_NAME '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


if is-at-least 4.3.10; then
    # git 用のフォーマット
    # git のときはステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats $BRANCH$VCS_NAME '%c%u%m'
    zstyle ':vcs_info:git:*' actionformats $BRANCH$VCS_NAME '%c%u%m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
    zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
fi

# hooks 設定 {{{
if is-at-least 4.3.11; then
    # git のときはフック関数を設定する

    # formats '(%s)-[%b]' '%c%u %m' , actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
    # のメッセージを設定する直前のフック関数
    # 今回の設定の場合はformat の時は2つ, actionformats の時は3つメッセージがあるので
    # 各関数が最大3回呼び出される。
    zstyle ':vcs_info:git+set-message:*' hooks \
                                            git-hook-begin \
                                            git-untracked \
                                            git-push-status \
                                            git-diff-remote \
                                            git-stash-count

    # フックの最初の関数
    # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする {{{
    # (.git ディレクトリ内にいるときは呼び出さない)
    # .git ディレクトリ内では git status --porcelain などがエラーになるため
    function +vi-git-hook-begin() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
            # 0以外を返すとそれ以降のフック関数は呼び出されない
            return 1
        fi

        return 0
    }
    #}}}

    # untracked ファイル表示 {{{
    #
    # untracked ファイル(バージョン管理されていないファイル)がある場合は
    # unstaged (%u) に ? を表示
    function +vi-git-untracked() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if command git status --porcelain 2> /dev/null \
            | awk '{print $1}' \
            | command grep -F '??' > /dev/null 2>&1 ; then

            # unstaged (%u) に追加
            hook_com[unstaged]+='?'
        fi
    }
    #}}}

    # リモートとの差分表示 {{{
    #
    # 現在のブランチ上でまだpushしていないcommit(ahead)、
    # pullしていないcommit(behind)を↑ahead↓behindという形式で表示する。
    function +vi-git-diff-remote() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local localBranch
        localBranch=${hook_com[branch]}
        local remoteBranch
        remoteBranch=${$(git rev-parse --verify ${localBranch}@{upstream} \
                --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

        # 追従ブランチなければなし
        if [[ ${remoteBranch} == "" ]]; then
            return 0
        fi

        local revlist
        revlist=$(command git rev-list --left-right ${remoteBranch}...HEAD 2>/dev/null)
        if [[ ${revlist} == "" ]]; then
            # 空の場合は処理終わり
            return 0
        fi

        local diffCommit
        diffCommit=$(command echo ${revlist} \
            | wc -l \
            | tr -d ' ')

        # TODO: 文字列を一行ごとに評価したいがうまいこと分割できてない
        # とりあえずちょいとムダ目に分割して評価してる
        local commitlist
        commitlist=${(z)revlist}

        local ahead=0
        for commit in ${commitlist}; do
            if [[ "${commit}" == ">" ]]; then
                ((ahead = ahead + 1))
            fi
        done

        local behind
        ((behind = ${diffCommit} - ${ahead}))

        # misc () に追加
        if [[ "$ahead" -gt 0 ]] ; then
            #hook_com[misc]+="%F{red}a%f%F{white}${ahead}%f"
            hook_com[misc]+="%F{red}↑ %f%F{white}${ahead}%f"
        fi
        if [[ "$behind" -gt 0 ]] ; then
            #hook_com[misc]+="%F{blue}b%f%F{white}${behind}%f"
            hook_com[misc]+="%F{blue}↓ %f%F{white}${behind}%f"
        fi
    }
    #}}}

    # stash 件数表示 {{{
    #
    # stash している場合は :SN という形式で misc (%m) に表示
    function +vi-git-stash-count() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local stash
        stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
        if [[ "${stash}" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+="%F{yellow}⚑%f %F{white}${stash}%f"
        fi
    }
    #}}}

fi

# メインの関数 {{{
function _update_vcs_info_msg() {
    local -a messages
    local prompt

    LANG=en_US.UTF-8 vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        # vcs_info で何も取得していない場合はプロンプトを表示しない
        prompt=""
    else
        # vcs_info で情報を取得した場合
        # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
        # それぞれ緑、黄色、赤で表示する
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "${vcs_info_msg_0_}:" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] || messages+=( "%F{green}✔ %f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        prompt="[${(j::)messages}]"
#        # 間にスペースを入れて連結する
#        prompt="${(j: :)messages}"
    fi

    RPROMPT="$prompt"
}
#}}}
add-zsh-hook precmd _update_vcs_info_msg

#}}}

#}}}

#}}}

# for tmux {{{
# Pane split on startup
# ref) http://qiita.com/ken11_/items/1304c2eecc2657ac6265
if [ $SHLVL = 1 ]; then
    alias t='tmux attach || tmux new-session \; source-file ~/.tmux/session'
    alias t-newsession='\tmux new-session \; source-file ~/.tmux/session'
else
    alias t='tmux'
    alias t-source='tmux source-file'
    alias t-basicpane='tmux source-file ~/.tmux/session'
    alias t-2='tmux splitw -h'
    alias t-3='tmux source-file ~/.tmux/utility/session_normal3'
    alias t-4='tmux source-file ~/.tmux/utility/session_4'
    alias t-kw='tmux kill-window'
    alias t-ks='tmux kill-session'
fi

# tmux 自動起動 {{{
if [ -z "$TMUX" -a -z "$STY" ]; then
    if type tmuxx >/dev/null 2>&1; then
        tmuxx
    elif type tmux >/dev/null 2>&1; then
        if tmux has-session && tmux list-sessions | /usr/bin/grep -qE '.*]$'; then
            tmux attach && echo "tmux attached session "
        else
            tmux new-session && echo "tmux created new session"
        fi
    elif type screen >/dev/null 2>&1; then
        screen -rx || screen -D -RR
    fi
fi
#}}}

#}}}

# for z {{{
# http://d.hatena.ne.jp/naoya/20130108/1357630895

if [[ $OSTYPE == darwin* ]]; then
    . `brew --prefix`/etc/profile.d/z.sh
else
    . ~/repos/github.com/rupa/z/z.sh
fi
precmd () {
   z --add "$(pwd -P)"
}

# }}}

# Generate .gitignore
function gen_gitignore() {
    curl https://www.gitignore.io/api/$@
}

# Remove non tracked file.(like tortoiseSVN)
function git_rm_untrackedfile()
{
    git status --short|grep '^??'|sed 's/^...//'|xargs rm -r
#    pathlist=(`git status --short|grep '^??'|sed 's/^...//'`)
#    for rmpath in ${pathlist}; do
#        if [ $rmpath != "" ]; then
#          rm ./$rmpath
#        fi
#    done
}

function git_stash_revert()
{
    git stash show ${@} -p
    #git stash show ${@} -p | git apply -R
}

# create .local.vimrc
function local_vimrc_create()
{
    if [[ "" == ${1} ]]; then
        echo "usage : local_vimrc_create /path/to/target"
        return
    fi

    echo "Create local vimrc file."
    if [ -d ${1} ]; then
        dirpath=`cd ${1}&&pwd`
        filename=".local.vimrc"
        filepath="${dirpath}/${filename}"

        if [ -f ${filepath} ]; then
            echo "*Error* Already exist file. : ${filepath}"
        else
            echo "\" .local.vimrc">${filepath}
            echo "let \$PROJECT_ROOT=expand(\"${dirpath}\")">>${filepath}
            echo "lcd \$PROJECT_ROOT">>${filepath}

            echo "Done. : ${filepath}"
        fi
    else
        echo "*Error* Not find directory. : ${1}"
    fi
}

# cd git repository
function cdrepos() {
    cd $(ghq list -p | peco)
}

function peco_find_ext() {
    find . -name '*.'$1 | peco
}

function ls_sshhost() {
    cat ~/.ssh/config | grep "^Host" | sed s/"^Host "//
}

function peco_ssh() {
    hostname=$(ls-sshhost | peco)
    echo $hostname
    ssh $hostname
}

function peco_gitmodified() {
    git status --short | peco | sed s/"^..."//
}

function git_pullall() {
    for repo in $(ghq list -p | grep $1); do
        echo $repo
        cd $repo
        git pull --rebase
    done
}

function listup_ip() {
    LANG=C ifconfig | grep 'inet ' | awk '{print $2;}' | cut -d: -f2
    #LANG=C ifconfig | grep 'inet addr' | awk '{print $2;}' | cut -d: -f2
}

# OPAM configuration
. ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


