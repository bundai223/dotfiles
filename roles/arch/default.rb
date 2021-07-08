# https://wiki.archlinux.org/index.php/tmpfs
# The tmpfs can also be temporarily resized without the need to reboot, for example when a large compile job needs to run soon. In this case, run:
# execute 'mount -o remount,size=4G,noatime /tmp'


include_cookbook('yay')
yay 'genie-systemd' if node['is_wsl']
include_cookbook('locale')

include_cookbook('yay')

update_package

package 'base-devel'
yay 'downgrader'
package 'openssh'
package 'libxml2'
package 'libxslt'

include_role('base')

# yay 'buttercup-desktop'
# yay 'dropbox'
# yay 'hfsprogs'
# yay 'cerebro'
# yay 'zeal'
yay 'httpie'
yay 'inotify-tools'
execute 'yarn global add vue-cli' do
  user node[:user]
end

yay 'ntp'
service 'ntpd' do
  action [:start, :enable]
end
yay 'thefuck'
yay 'atool'
