
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'avahi-daemon'

  # for wsl
  service 'dbus' do
    action [:start, :enable]
    not_if 'uname -a | grep Microsoft'
  end
when 'fedora', 'redhat', 'amazon'
  package 'avahi'
  package 'nss-mdns'
when 'osx', 'darwin'
when 'arch'
  package 'avahi'
  package 'nss-mdns'
when 'opensuse'
else
end

service 'avahi-daemon' do
  action [:start, :enable]
  not_if 'uname -a | grep Microsoft'
end
