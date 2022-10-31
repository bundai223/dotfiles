case node[:platform]
when 'arch'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
  execute 'install session-manager plugin' do
    command <<~EOCMD
      curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
      sudo yum install -y session-manager-plugin.rpm
      sudo session-manager-plugin.rpm
    EOCMD
  end

when 'debian', 'ubuntu', 'mint'
  execute 'install session-manager plugin' do
    command <<~EOCMD
      curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
      sudo dpkg -i session-manager-plugin.deb
      sudo rm session-manager-plugin.deb
    EOCMD
  end
when 'opensuse'
else
end
