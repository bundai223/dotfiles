include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  yay 'rainbarf'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
