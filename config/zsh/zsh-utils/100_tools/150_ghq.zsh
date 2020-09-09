ghq_path()
{
  repo=${1}
  root_path=$(ghq root ${repo})
  ghq list ${repo} | xargs -Isub_path echo ${root_path}/sub_path
}

cd_repos()
{
  pth=$(ghq list --full-path | sed "s#${HOME}#~#"| $FILTER_CMD | sed "s#~#${HOME}#")
  if [ -n "$pth" ]; then
    eval "cd $pth"
  fi
}
