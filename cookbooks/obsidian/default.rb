include_recipe 'dependency.rb'

version = '1.1.16'
appname = 'Obsidian'

user = node[:user]

case node[:platform]
when 'arch'
  yay 'obsidian-appimage'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  execute "snap install --classic obsidian"
when 'opensuse'
else
  # nothing
end
