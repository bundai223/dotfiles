case node[:platform]
when 'arch'
  package 'graphviz'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
