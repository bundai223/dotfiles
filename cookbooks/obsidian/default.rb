include_recipe 'dependency.rb'

version = '0.9.4'
appname = 'Obsidian'

user = node[:user]

case node[:platform]
when 'arch'
  yay 'obsidian-appimage'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  appimage_url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v#{version}/Obsidian-#{version}.AppImage"

  install_appimage appname do
    user user
    url appimage_url
    version version
  end
when 'opensuse'
else
  # nothing
end
