case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'wget'
when 'fedora', 'redhat', 'amazon'
  package 'wget'
  package 'ncurses-devel'
when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end

