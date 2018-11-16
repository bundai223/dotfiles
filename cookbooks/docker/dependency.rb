
case node[:platform]
when 'debian', 'mint'
when 'ubuntu'
  # refs https://docs.docker.com/install/linux/docker-ce/ubuntu/
  package 'apt-transport-https'
  package 'ca-certificates'
  package 'curl'
  package 'software-properties-common'

when 'fedora', 'redhat', 'amazon'
when 'osx', 'darwin'
when 'arch'
  include_cookbook 'yay'
when 'opensuse'
else
end
