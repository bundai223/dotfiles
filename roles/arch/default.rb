# https://wiki.archlinux.org/index.php/tmpfs
# The tmpfs can also be temporarily resized without the need to reboot, for example when a large compile job needs to run soon. In this case, run:
execute 'mount -o remount,size=4G,noatime /tmp'

update_package
package 'base-devel'
package 'openssh'
package 'libxml2'
package 'libxslt'
package 'fcitx-im'
package 'fcitx-configtool'
package 'fcitx-skk'
package 'skk-jisyo'

include_role('base')

include_cookbook('yay')
# yay 'buttercup-desktop'
# yay 'dropbox'
# yay 'hfsprogs'
# yay 'cerebro'
# yay 'zeal'
yay 'xsel'
