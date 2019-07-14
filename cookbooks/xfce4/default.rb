include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  package 'xfce4'

  yay 'zafiro-icon-theme-git'
  yay 'nordic-theme-git'
  yay 'xfce4-goodies'
  yay 'gvfs'
  yay 'ffmpegthumbnailer'
  yay 'tumbler'
  yay 'file-roller'

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
