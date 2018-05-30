execute 'apt purge -y ebtables' do
  command <<-EOL
    rm /var/lib/dpkg/info/ebtables.prerm
    apt purge -y ebtables
  EOL

  only_if 'uname -a | grep Microsoft'
  only_if 'test -e /var/lib/dpkg/info/ebtables.prerm'
end

execute 'apt purge -y nano' do
  only_if 'which nano'
end

execute 'apt update'
execute 'apt upgrade -y'

include_role('base')

# for nokogiri for rails
package 'build-essential'
package 'apt-file'
package 'sysv-rc-conf'

package 'patch'
package 'ruby-dev'
package 'zlib1g-dev'
package 'liblzma-dev'
package 'libxml2-dev'
package 'python-fontforge'
package 'cmake'
package 'libboost-all-dev'
package 'libicu-dev'
# package 'python-dev'


# locale
#package 'language-pack-ja'

package 'x11-apps'
package 'x11-utils'
package 'x11-xserver-utils'
package 'fonts-ipafont'
execute 'locale-gen ja_JP.UTF-8'

execute 'remove libpulse0'  do
  command <<-EOL
    apt purge -y libpulse0
  EOL

  only_if 'uname -a | grep Microsoft'
end
