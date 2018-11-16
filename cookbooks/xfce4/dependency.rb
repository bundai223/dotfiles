case node[:platform]
when 'arch'
  package 'xorg-server'
  package 'xorg-xinit'
  package 'xorg-xclock'
  package 'xterm'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
