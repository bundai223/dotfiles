case node[:platform]
when 'arch'
  include_cookbook 'yay'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  # include_cookbook 'appimage_setting'
  package 'snapd'
when 'opensuse'
else
end
