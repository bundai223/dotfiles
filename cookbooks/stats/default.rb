include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'sysstat'
when 'opensuse'
else
end

