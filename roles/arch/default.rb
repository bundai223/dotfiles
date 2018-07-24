remote_file '/etc/pacman.d/archlinux'

file '/etc/pacman.conf' do
  action :edit
  block do |content|
    if not content =~ /^[archlinuxfr]/i then
      content << '[archlinuxfr]'
      content << 'Include = /etc/pacman.d/archlinuxfr'
    end
  end
end

define :yaourt do
  name = params[:name]

  execute "#{sudo(node[:user])} yaourt -S --noconfirm #{name}" do
    not_if "yaourt -Q #{name}"
  end
end

execute 'pacman -Syy'
execute 'pacman -Syu'
package 'yaourt'
yaourt 'base-devel'
package 'openssh'
package 'libxml2'
package 'libxslt'
package 'fcitx-im'
package 'fcitx-configtool'
package 'fcitx-skk'
package 'skk-jisyo'

yaourt "buttercup-desktop"
yaourt "dropbox"
yaourt "hfsprogs"
yaourt "cerebro"
yaourt "zeal"

include_role('base')
