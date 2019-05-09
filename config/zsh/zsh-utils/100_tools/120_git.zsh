# git

# Generate .gitignore
git-gen_ignore() {
  curl https://www.gitignore.io/api/$@
}

# Remove non tracked file.(like tortoiseSVN)
# Equal 'git clean -f'
git-rm_untracked()
{
  git status --short|grep '^??'|sed 's/^...//'|xargs rm -r
}

git-revert_stash()
{
  git stash show ${@} -p | git apply -R
}

# 指定のユーザ名のリポジトリをpullする
git_pull_all()
{
  if [ $# -eq 0 ]; then
    echo "usage"
    echo " git_pull_all [username]"
    return 1
  fi

  username=$1
  CURDIR=`pwd`
  ERROR_LIST=()
  for repo in $(ghq list -p | grep $username); do
    cd $repo
    hostname=$(basename $(cd ../..;pwd))
    reposname=$(basename $(pwd))
    echo "$hostname:$username/$reposname"
    git pull --rebase 1>/dev/null 2>&1
    if [ $? -ne 0 ]; then
      ERROR_LIST=(${ERROR_LIST[@]} $hostname:$username/$reposname)
    fi
  done

  if [ ${#ERROR_LIST[@]} -eq 0 ]; then
  else
    echo
    echo "==== error repositories ===="
    for error_repo in $ERROR_LIST; do
      echo $error_repo
    done
  fi
  cd $CURDIR
}

git_status_normalize()
{
  local localBranch=$(git rev-parse --abbrev-ref HEAD)
  local remoteBranch=${$(git rev-parse --verify ${localBranch}@{upstream} \
    --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  # 追従ブランチなければなし
  if [[ ${remoteBranch} == "" ]]; then
    return 0
  fi

  local revlist=$(git rev-list --left-right ${remoteBranch}...HEAD 2>/dev/null)

  if [[ ${revlist} == "" ]]; then
    # 空の場合は差分なし
    print "${fg[green]}✔ ${fg[white]}"
    return 0
  fi

  local diffCommit=$(echo ${revlist} \
    | wc -l \
    | tr -d ' ')

  # TODO: 文字列を一行ごとに評価したいがうまいこと分割できてない
  # とりあえずちょいとムダ目に分割して評価してる
  local commitlist=${(z)revlist}
  echo "$commitlist"

  local ahead=0
  for commit in ${commitlist}; do
    if [[ "${commit}" == ">" ]]; then
      ((ahead = ahead + 1))
    fi
  done

  local behind
  ((behind = ${diffCommit} - ${ahead}))
  echo "${diffCommit} ↑ $ahead, ↓ $behind"

  # misc () に追加
  if [[ "$ahead" -gt 0 ]] ; then
    print "${fg[red]}↑ ${fg[white]}${ahead}"
  fi
  if [[ "$behind" -gt 0 ]] ; then
    print "${fg[blue]}↓ ${fg[white]}${behind}"
  fi
}

git_stash_status()
{
  local stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  if [[ "${stash}" -gt 0 ]]; then
    # misc (%m) に追加
    print "${fg[yellow]}⚑ ${fg[white]}${stash}"
  fi
}

git_status_all()
{
  if [ $# -eq 0 ]; then
    echo "usage"
    echo " git_status_all [search word]"
    return 1
  fi

  CURDIR=$(pwd)
  search_word=$1

  for repo in $(ghq list -p | grep $search_word); do
    cd $repo
    hostname=$(basename $(cd ../..;pwd))
    reposname=$(basename $(pwd))

    git fetch 1>/dev/null 2>&1
    linenum=$(git status --short | wc -l)
    echo "$linenum $hostname:$username/$reposname"
    cd $CURDIR
  done
}
