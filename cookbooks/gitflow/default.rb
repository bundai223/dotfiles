
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'git-flow'

when 'fedora', 'redhat', 'amazon'
  package 'git-flow'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
