# git

# Generate .gitignore
git_gen_ignore() {
  curl https://www.gitignore.io/api/$@
}

# Remove non tracked file.(like tortoiseSVN)
# Equal 'git clean -f'
git_rm_untrackedfile()
{
  git status --short|grep '^??'|sed 's/^...//'|xargs rm -r
}

git_stash_revert()
{
  git stash show ${@} -p | git apply -R
}

# 指定のユーザ名のリポジトリをpullする
git_pull_all()
{
  if [ $# -eq 0 ]; then
    echo "usage"
    echo " git_pullall [username]"
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

git_status_all()
{
  CURDIR=`pwd`
  for dir in $(ls -l | grep '^d' | awk '{print $(NF)}'); do
  cd $dir
  git fetch
  linenum=$(git status --short | wc -l)
  test $linenum -eq 0 || echo $dir $linenum
  cd $CURDIR
  done
}


