
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'avahi-daemon'
  package 'avahi-utils'
  package 'libnss-mdns'

  # for wsl
  service 'dbus' do
    action [:start, :enable]
    not_if "#{node[:is_wsl]}"
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

unless node[:is_wsl]
  service 'avahi-daemon' do
    action [:start, :enable]
  end
end
