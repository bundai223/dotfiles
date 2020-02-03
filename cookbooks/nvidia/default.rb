include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  execute 'mhwd -a pci nonfree 0300'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end

