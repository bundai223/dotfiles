case node[:platform]
when 'arch'
  include_cookbook 'yay'

  yay 'bluez'
  yay 'bluez-utils'

  service 'bluetooth' do
    action [:start, :enable]
  end

  yay 'blueman-git'

when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
