# remote_file '/etc/pacman.d/archlinux'

# file '/etc/pacman.conf' do
#   action :edit
#   block do |content|
#     if not content =~ /^[archlinuxfr]/i then
#       content << '[archlinuxfr]'
#       content << 'Include = /etc/pacman.d/archlinuxfr'
#     end
#   end
# end

# define :yaourt do
#   name = params[:name]
# 
#   execute "#{sudo(node[:user])} yaourt -S --noconfirm #{name}" do
#     not_if "yaourt -Q #{name}"
#   end
# end

define :yay do
  name = params[:name]

  execute "#{sudo(node[:user])} yay -S --noconfirm #{name}" do
    not_if "yay -Q #{name}"
  end
end

execute 'pacman -Syy --noconfirm'
execute 'pacman -Syu --noconfirm'
include_cookbook('yay')
# package 'yaourt'
yay 'base-devel'
package 'openssh'
package 'libxml2'
package 'libxslt'
package 'fcitx-im'
package 'fcitx-configtool'
package 'fcitx-skk'
package 'skk-jisyo'

# yay "buttercup-desktop"
# yay "dropbox"
# yay "hfsprogs"
# yay "cerebro"
# yay "zeal"

include_role('base')
