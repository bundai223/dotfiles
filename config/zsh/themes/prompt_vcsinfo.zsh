# Show vcsinfo PROMPT.
# https://github.com/yonchu/dotfiles/blob/master/.zsh/themes/yonchu-2lines.zsh-theme

# バージョン管理の状態に合わせた表示
autoload -Uz vcs_info
precmd_theme () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd precmd_theme

symbol_clock='⌚'
vcs_symbol_branch='' # ' '
vcs_symbol_stash=''
vcs_symbol_ahead='↑'
vcs_symbol_behind='↓'
vcs_symbol_clean='✔ '

BRANCH="%F{white}${vcs_symbol_branch}%b%f%"
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

# hooks 設定
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
  # git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
  # (.git ディレクトリ内にいるときは呼び出さない)
  # .git ディレクトリ内では git status --porcelain などがエラーになるため
  function +vi-git-hook-begin() {
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
      # 0以外を返すとそれ以降のフック関数は呼び出されない
      return 1
    fi

    return 0
  }


  # untracked ファイル表示
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

  # リモートとの差分表示
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

    local ahead=0
    ahead=$(command echo ${revlist} \
      | grep '>' \
      | wc -l \
      | tr -d ' ')

    local behind
    ((behind = ${diffCommit} - ${ahead}))

    # misc () に追加
    if [[ "$ahead" -gt 0 ]] ; then
      #hook_com[misc]+="%F{red}a%f%F{white}${ahead}%f"
      hook_com[misc]+="%F{red}${vcs_symbol_ahead}%f%F{white}${ahead}%f"
    fi
    if [[ "$behind" -gt 0 ]] ; then
      #hook_com[misc]+="%F{blue}b%f%F{white}${behind}%f"
      hook_com[misc]+="%F{blue}${vcs_symbol_behind}%f%F{white}${behind}%f"
    fi
  }

  # stash 件数表示
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
      hook_com[misc]+="%F{yellow}${vcs_symbol_stash}%f %F{white}${stash}%f"
    fi
  }
fi

# メインの関数
function _update_vcs_info_msg() {
  local -a messages
  local prompt

  LANG=en_US.UTF-8 vcs_info

  # vcs_info で何も取得していない場合はプロンプトを表示しない
  prompt=""

  if [[ -n ${vcs_info_msg_0_} ]]; then
    # vcs_info で情報を取得した場合
    # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
    # それぞれ緑、黄色、赤で表示する
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "${vcs_info_msg_0_}:" )
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
    [[ -n "$vcs_info_msg_1_" ]] || messages+=( "%F{green}${vcs_symbol_clean}%f" )
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

    prompt="[${(j::)messages}]"
    #        # 間にスペースを入れて連結する
    #        prompt="${(j: :)messages}"
  fi

  # echo "$prompt [${symbol_clock}%*]"
  echo "$prompt"
}

# add-zsh-hook precmd _update_vcs_info_msg

# %# : 一般ユーザなら%、スーパーユーザなら#
# %H : ホスト名
# %m : ホスト名のうち最初のドットの前まで
# %d : カレントディレクトリのパス
# %~ : カレントディレクトリのパス(ホームの場合~)
# %n : ユーザ名
# %D : 年月日
# %* : 時分秒
setopt PROMPT_SUBST
PROMPT='%{${fg[green]}%}${USER}@${HOST%%.*}%{${reset_color}%} %{${fg[yellow]}%}%~%{${reset_color}%} $(_update_vcs_info_msg)
%{$reset_color%}%(!.#.$)%{$reset_color%} '

