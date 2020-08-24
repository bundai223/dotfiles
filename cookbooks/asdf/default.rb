include_recipe 'dependency.rb'

case node[:platform]
when 'arch'
  yay 'asdf-vm'

  file "/etc/profile.d/asdf.sh" do
    content 'source /opt/asdf-vm/asdf.sh'
    not_if "test -e /etc/profile.d/asdf.sh"
    mode '777'
  end
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
