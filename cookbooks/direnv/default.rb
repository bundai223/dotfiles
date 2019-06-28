case node[:platform]
when 'arch'
  include_cookbook 'yay'

  yay 'direnv'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'direnv'
when 'opensuse'
else
end
