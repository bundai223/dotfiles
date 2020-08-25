case node[:platform]
when 'arch'
  include_cookbook 'yay'

  yay 'cpanminus'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'libssl-dev'
  package 'cpanminus'
when 'opensuse'
else
end
