case node[:platform]
when 'arch'
  include_cookbook 'yay'

  yay 'lightdm'
  yay 'lightdm-gtk-greeter'
  yay 'lightdm-webkit2-greeter'
  yay 'lightdm-webkit-theme-aether'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end

service 'lightdm' do
  action [:enable]
end
