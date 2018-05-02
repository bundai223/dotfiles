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


include_role('base')
