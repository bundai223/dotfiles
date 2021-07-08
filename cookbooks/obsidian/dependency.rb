case node[:platform]
when 'arch'
  include_cookbook 'yay'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  include_cookbook 'appimage_setting'
when 'opensuse'
else
end
