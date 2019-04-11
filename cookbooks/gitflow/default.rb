
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'git-flow'

when 'fedora', 'redhat', 'amazon'
  package 'git-flow'
when 'osx', 'darwin'
when 'arch'
  include_cookbook 'yay'

  yay 'gitflow-avh'
when 'opensuse'
else
end

include_cookbook 'ghq'
get_repo 'bobthecow/git-flow-completion'
