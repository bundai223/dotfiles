package 'git'
package 'go'

execute "install yay" do
  command <<-EOL
    ls yay >/dev/null || git clone https://aur.archlinux.org/yay.git
    chown #{node[:user]}:#{node[:group]} yay
    cd yay
    #{run_as(node[:user], 'makepkg -si --noconfirm')}
    cd ../
    rm -rf yay
  EOL
end
