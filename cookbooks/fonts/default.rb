case node[:platform]
when 'arch'
  include_cookbook 'yay'
  yay 'noto-fonts-emoji'
  yay 'nerd-fonts-complete'

when 'osx', 'darwin'
  # not implemented
when 'fedora', 'redhat', 'amazon'
  # not implemented
when 'debian', 'ubuntu', 'mint'
  package 'fonts-firacode'
  package 'fonts-noto-cjk'
  package 'fonts-noto-cjk-extra'
when 'opensuse'
  # not implemented
else
end
