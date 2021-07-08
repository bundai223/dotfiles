include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  yay 'global'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'global'
when 'opensuse'
else
end
