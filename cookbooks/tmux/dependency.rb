case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'build-essential'
  package 'wget'
  package 'automake'
  package 'libevent-dev'
  package 'libncurses-dev'

when 'fedora', 'redhat', 'amazon'
  package 'ncurses-devel'
  package 'libevent'
  package 'libevent-devel'
  #package 'libevent-headers'

when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
