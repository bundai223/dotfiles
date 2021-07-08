include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  yay 'conky-lua-nv'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'conky-all'

  package 'conky-manager'
  package 'conky-manager-extra'
when 'opensuse'
else
end
