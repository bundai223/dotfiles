case node[:platform]
when 'arch'
  include_cookbook 'yay'

  yay 'cpanminus'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
