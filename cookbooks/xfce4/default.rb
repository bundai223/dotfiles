include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  package 'xfce4'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
