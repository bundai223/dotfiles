include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  yay 'exfat-utils'
  yay 'ntfs-3g'
  yay 'ifuse'
  yay 'usbmuxd'
  yay 'libplist'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
