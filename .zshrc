#---------------------------------------------
# 基本の設定
#---------------------------------------------
# 色の定義
# ref) http://voidy21.hatenablog.jp/entry/20090902/1251918174
local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$

## どっかからのコピペ
## The following lines were added by compinstall
#zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' menu select=2
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' verbose true

# zsh補完強化 {{{
# http://qiita.com/PSP_T/items/ed2d36698a5cc314557d
# 補完候補のハイライト
zstyle ':completion:*:default' menu select=2
# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

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

fpath=(~/tool/zsh-completions/src(N-/) ${fpath})
fpath=(~/.zsh/my-completions(N-/) ${fpath})

# fpathの設定が終わってから補完有効設定を行う
# ref : http://yonchu.hatenablog.com/entry/20120415/1334506855
# 補完有効
autoload -Uz compinit
compinit

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
#setopt rm_star_silent       # rm *で確認ださない
setopt no_auto_param_slash  # 自動で末尾に/を補完しない
setopt auto_pushd           # cd履歴を残す


export EDITOR=vim

# History setting {{{
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
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter
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

# Alias {{{
alias ls="ls -FG"
alias lsl="ls -lFG"
alias lsdir="ls -FG | grep /"
alias lsfile="ls -FG | grep -v /"
alias pd=popd

alias reload_zshrc="source ~/.zshrc"

alias find-vimbackup="find **/*~"

if [[ $OSTYPE == darwin* ]]; then
    alias rm="~/tool/osx-mv2trash/bin/mv2trash"
    alias rm-vimbackup="find **/*~| xargs ~/tool/osx-mv2trash/bin/mv2trash"
fi

# git {{{
alias gittaglist="git for-each-ref --sort=-taggerdate --format='%(taggerdate:short) %(tag) %(taggername) %(subject)' refs/tags"
alias gitflow=git-flow
# }}}

alias -s html=chrome
alias -s rb=ruby
alias -s py=python

alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
alias -g W='| wc'
alias -g X='| xargs'

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
#}}}

# ローカル用設定を読み込む
if [ -f ~/.zshrc_local ]; then
    . ~/.zshrc_local
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
function zle-line-init zle-keymap-select {
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
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


if is-at-least 4.3.10; then
    # git 用のフォーマット
    # git のときはステージしているかどうかを表示
    zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
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
    # pullしていないcommit(behind)を↑ ahead↓ behindという形式で表示する。
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
            hook_com[misc]+="%F{red}↑ %F{white}${ahead}%f"
        fi
        if [[ "$behind" -gt 0 ]] ; then
            hook_com[misc]+="%F{blue}↓ %F{white}${behind}%f"
        fi
    }
    #}}}

    # マージしていない件数表示 {{{
    #
    # master 以外のブランチにいる場合に、
    # 現在のブランチ上でまだ master にマージしていないコミットの件数を
    # (mN) という形式で misc (%m) に表示
    function +vi-git-nomerge-branch() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" == "master" ]]; then
            # master ブランチの場合は何もしない
            return 0
        fi

        local nomerged
        nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

        if [[ "$nomerged" -gt 0 ]] ; then
            # misc (%m) に追加
            hook_com[misc]+="(m${nomerged})"
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
            hook_com[misc]+=":S${stash}"
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
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        # 間にスペースを入れて連結する
        prompt="${(j: :)messages}"
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
    alias tmux='tmux attach || tmux new-session \; source-file ~/.tmux/session'
else
    alias tmux-basicpane='tmux source-file ~/.tmux/session'
    alias tmux-sshpane='tmux source-file ~/.tmux/utility/session_ssh'
    alias tmux-end='tmux kill-session'
fi

# Auto start tmux {{{
# ref) http://d.hatena.ne.jp/tyru/20100828/run_tmux_or_screen_at_shell_startup
is_screen_running() {
    # tscreen also uses this varariable.
    [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
    [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
    [ ! -z "$PS1" ]
}
resolve_alias() {
    cmd="$1"
    while whence "$cmd" >/dev/null 2>/dev/null && [ "$(whence "$cmd")" != "$cmd" ]
    do
        cmd=$(whence "$cmd")
    done
    echo "$cmd"
}


#if ! is_screen_or_tmux_running && shell_has_started_interactively; then
##    for cmd in tmux tscreen screen; do
#    for cmd in tmux; do
#        if whence $cmd >/dev/null 2>/dev/null; then
#            #which $cmd
#            $(resolve_alias "$cmd")
#            break
#        fi
#    done
#fi
# }}}

#}}}

# for z {{{
# http://d.hatena.ne.jp/naoya/20130108/1357630895

if [[ $OSTYPE == darwin* ]]; then
    . `brew --prefix`/etc/profile.d/z.sh
else
    . ~/tool/z/z.sh
fi
precmd () {
   z --add "$(pwd -P)"
}

# }}}

