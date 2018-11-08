define :yay do
  name = params[:name]

  execute "#{sudo(node[:user])} yay -S --noconfirm #{name}" do
    not_if "yay -Q #{name}"
  end
end

execute 'pacman -Syy --noconfirm'
execute 'pacman -Syu --noconfirm'
package 'base-devel'
package 'openssh'
package 'libxml2'
package 'libxslt'
package 'fcitx-im'
package 'fcitx-configtool'
package 'fcitx-skk'
package 'skk-jisyo'

include_cookbook('yay')
# yay "buttercup-desktop"
# yay "dropbox"
# yay "hfsprogs"
# yay "cerebro"
# yay "zeal"

include_role('base')
