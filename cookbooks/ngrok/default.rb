
case node[:platform]
when 'arch'
  include_cookbook 'yay'
  yay 'ngrok'

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
