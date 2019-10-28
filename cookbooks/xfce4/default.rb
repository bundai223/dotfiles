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

  yay 'xsel' # clipboard
  # terminal
  yay 'terminator'
  yay 'lxterminal'
  yay 'gtk-engine-murrine'

  yay 'udisks2'
  yay 'udevil'

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
