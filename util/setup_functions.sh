# エラーなしのmkdir
mkdir_noerror()
{
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

mkln()
{
  src=${1}
  dst=${2}
  if [ ! -e ${src} ]; then
    echo "Not exist source.: ${src}"
    return 1
  fi
  if [ ! -e ${dst} ]; then
    ln -s ${src} ${dst} && echo "Create link:${dst}"
  else
    echo "Already Exists ${dst}"
  fi
}
