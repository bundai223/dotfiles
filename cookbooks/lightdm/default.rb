case node[:platform]
when 'arch'
  package 'lightdm'
  package 'lightdm-gtk-greeter'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end

service 'lightdm' do
  action [:start, :enable]
end
