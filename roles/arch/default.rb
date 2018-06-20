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

execute 'pacman -Syy'
execute 'pacman -Syu'
package 'yaourt'
execute 'yaourt -S --noconfirm \'base-devel\''
package 'openssh'
package 'libxml2'
package 'libxslt'
package 'fcitx-im'
package 'fcitx-configtool'
package 'fcitx-skk'
package 'skk-jisyo'

execute 'yaourt -S --noconfirm buttercup-desktop'
execute 'yaourt -S --noconfirm dropbox'
execute 'yaourt -S --noconfirm hfsprogs'
execute 'yaourt -S --noconfirm cerebro'
execute 'yaourt -S --noconfirm zeal'

include_role('base')
