include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  include_cookbook('yay')

  yay 'fcitx-im'
  yay 'fcitx-configtool'
  yay 'fcitx-skk'
  yay 'skk-jisyo'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'fcitx'
  package 'fcitx-skk'
  package 'libskk-dev'
  package 'qtbase5-dev'
  package 'libfcitx-qt5-dev'
  package 'skkdic'
when 'opensuse'
else
end
