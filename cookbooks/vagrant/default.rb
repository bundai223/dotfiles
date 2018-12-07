include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'mint', 'ubuntu'
  url = 'https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb'
  filename = 'vagrant_2.2.2_x86_64.deb'

  execute "curl -O #{url}"
  execute "dpkg -i #{filename}"
  execute "rm #{filename}"

when 'fedora', 'redhat', 'amazon'

when 'osx', 'darwin'

when 'arch'
  yay 'vagrant'

when 'opensuse'
else
end
