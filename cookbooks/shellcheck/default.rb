case node[:platform]
when 'arch'
  package 'shellcheck'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
  package 'shellcheck'
when 'opensuse'
else
end
