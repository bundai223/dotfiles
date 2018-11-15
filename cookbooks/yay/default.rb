case node[:platform]
when 'arch'
  include_cookbook 'git'
  include_cookbook 'go'
  package 'fakeroot'

  execute "install yay" do
    command <<-EOL
      ls yay >/dev/null || git clone https://aur.archlinux.org/yay.git
      chown -R #{node[:user]}:#{node[:group]} yay
      cd yay
      #{run_as(node[:user], 'makepkg -si --noconfirm')}
      cd ../
      rm -rf yay
    EOL

    not_if 'which yay >/dev/null 2>&1'
  end
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
