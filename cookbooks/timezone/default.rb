include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  execute 'timedatectl set-timezone Asia/Tokyo'
  execute 'timedatectl set-ntp True'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
