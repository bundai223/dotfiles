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

git_change_commiter()
{
  # refs) https://git-scm.com/book/ja/v1/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E6%AD%B4%E5%8F%B2%E3%81%AE%E6%9B%B8%E3%81%8D%E6%8F%9B%E3%81%88#%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88%E3%81%AE%E5%88%86%E5%89%B2
  git filter-branch --commit-filter '
    if [ "$GIT_COMMITTER_EMAIL" = "localhost@localhost.jp" ];
    then
      GIT_COMMITTER_NAME="bundai223";
      GIT_AUTHOR_NAME="bundai223";
      GIT_COMMITTER_EMAIL="bundai223@gmail.com";
      GIT_AUTHOR_EMAIL="bundai223@gmail.com";
      git commit-tree "$@";
    else
      git commit-tree "$@";
    fi' HEAD
}
