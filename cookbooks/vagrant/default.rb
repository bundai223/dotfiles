include_recipe 'dependency.rb'

version = '2.2.5'
arch = 'x86_64'

case node[:platform]
when 'debian', 'mint', 'ubuntu'
  url = "https://releases.hashicorp.com/vagrant/#{version}/vagrant_#{version}_#{arch}.deb"
  filename = "vagrant_#{version}_#{arch}.deb"

  cmds = [
   "curl -O #{url}",
   "dpkg -i #{filename}",
   "rm #{filename}"
  ]

  cmds.each do |cmd|
    execute cmd do
      only_if "which vagrant > /dev/null && vagrant --version | perl -pe 's/Vagrant //' | #{version}"
    end
  end

when 'fedora', 'redhat', 'amazon'

when 'osx', 'darwin'

when 'arch'
  yay 'vagrant'

when 'opensuse'
else
end
