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
when 'opensuse'
else
end
