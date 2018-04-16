usage()
{
  echo "usage:"
  echo "  sh gituser.sh [repos_dir]"
}

DIR=$(cd . && pwd)

while [ "$1" != "" ]; do
  if [ -d $1 ]; then
    target_dir=$1
    cd $target_dir
    git config --local user.name "bundai223"
    git config --local user.email "bundai223@gmail.com"
  fi

  cd $DIR
  shift
done
