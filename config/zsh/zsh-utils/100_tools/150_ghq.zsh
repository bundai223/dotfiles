ghq_path()
{
  repo=${1}
  root_path=$(ghq root ${repo})
  ghq list ${repo} | xargs -Isub_path echo ${root_path}/sub_path
}

cd_repos()
{
  if [ -n "$1" ]; then
    pth=$(ghq list --full-path | sed "s#${HOME}#~#"| $FILTER_CMD -q $1 | sed "s#~#${HOME}#") # fzf -q querystring
  else
    pth=$(ghq list --full-path | sed "s#${HOME}#~#"| $FILTER_CMD | sed "s#~#${HOME}#")
  fi
  if [ -n "$pth" ]; then
    eval "cd $pth"
  fi
}
