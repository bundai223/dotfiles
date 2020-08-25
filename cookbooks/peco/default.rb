
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'peco'
  package 'fzf'
when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
  package 'peco'
  package 'fzf'

when 'arch'
  include_cookbook 'yay'

  yay 'peco'
when 'opensuse'
else
end

