# zsh

filename()
{
  # equal basename
  echo ${${1}##*/}
}

parentpath()
{
  # equal dirname
  echo ${${1}%/*}
}

ext()
{
  echo ${${1}##*.}
}

filename_wo_ext()
{
  echo ${${1}%.*}
}

spinner() {
  chars='/-\|'

  while :; do
    for (( i=0; i<${#chars}; i++ )); do
      usleep 300000
      echo -en "${chars:$i:1}" "\r"
    done
  done
}
