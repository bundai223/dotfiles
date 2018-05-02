ghq_path()
{
  repo=${1}
  root_path=$(ghq root ${repo})
  ghq list ${repo} | xargs -Isub_path echo ${root_path}/sub_path
}
