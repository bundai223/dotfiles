include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  raise NotImplementedError
when 'osx', 'darwin'
  raise NotImplementedError
when 'fedora', 'redhat', 'amazon'
  raise NotImplementedError
when 'debian', 'ubuntu', 'mint'
  execute 'add-apt-repository ppa:wslutilities/wslu'
  execute 'apt update -y'
  package 'wslu'
when 'opensuse'
  raise NotImplementedError
else
  raise NotImplementedError
end
