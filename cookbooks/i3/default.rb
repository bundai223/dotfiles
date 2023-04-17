include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  package 'i3'
  package 'i3status'
  package 'i3lock'
  package 'suckless-tools'
  package 'feh'
  package 'compton'
  package 'lxappearance'
  # package 'qt4-qtconfig'
  package 'pasystray'
  package 'paprefs'
  package 'pavumeter'
  package 'pulseaudio-module-zeroconf'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
