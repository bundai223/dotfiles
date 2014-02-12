#---------------------------------------------
# 基本の設定
#---------------------------------------------

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

# git clone https://github.com/zsh-users/zsh-completions.git
# ln -s ~/tool/zsh-completions/src ~/.zsh/zsh-completions
fpath=(~/.zsh/zsh-completions(N-/) ${fpath})
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
setopt rm_star_silent       # rm *で確認ださない
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

#}}}

# Alias {{{
alias ls='ls -a'
alias lsl='ls -la'
alias pd=popd

alias -s html=chrome
alias -s rb=ruby
alias -s py=python

#}}}

# ローカル用設定を読み込む
if [ -f ~/.local_zshrc ]; then
    . ~/.local_zshrc
fi

# Prompt setting {{{
# 実際のプロンプトの表示設定
autoload -Uz colors && colors

PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "

# vimキーバインドのモードによって入力プロンプトの先頭の色を変更 {{{
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
        PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%{$bg_bold[magenta]%}%(!.#.$)%{$reset_color%} "
    ;;
    main|viins)
        PROMPT="%{${fg[green]}%}${USER}@${HOST%%.*} %{${fg[yellow]}%}%~%{${reset_color}%}
%(!.#.$) "
    ;;
  esac
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#}}}

# Show vcsinfo RPROMPT. {{{
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
                                            git-nomerge-branch \
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

    # push していないコミットの件数表示 {{{
    #
    # リモートリポジトリに push していないコミットの件数を
    # pN という形式で misc (%m) に表示する
    function +vi-git-push-status() {
        # zstyle formats, actionformats の2番目のメッセージのみ対象にする
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" != "master" ]]; then
            # master ブランチでない場合は何もしない
            return 0
        fi

        # push していないコミット数を取得する
        local ahead
        ahead=$(command git rev-list origin/master..master 2>/dev/null \
            | wc -l \
            | tr -d ' ')

        if [[ "$ahead" -gt 0 ]]; then
            # misc (%m) に追加
            hook_com[misc]+="(p${ahead})"
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
fi
alias tmux-startpane='tmux source-file ~/.tmux/session'

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
#    for cmd in tmux tscreen screen; do
#        if whence $cmd >/dev/null 2>/dev/null; then
#            which $cmd
#            $(resolve_alias "$cmd")
#            break
#        fi
#    done
#fi
#}}}

#}}}

# for z {{{
# http://d.hatena.ne.jp/naoya/20130108/1357630895
. `brew --prefix`/etc/profile.d/z.sh
precmd () {
   z --add "$(pwd -P)"
}

# }}}

