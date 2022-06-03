if node['is_wsl']
  execute 'sudo apt purge -y ebtables' do
    command <<-EOL
      sudo rm /var/lib/dpkg/info/ebtables.prerm
      sudo apt purge -y ebtables
    EOL

    only_if 'test -e /var/lib/dpkg/info/ebtables.prerm'
  end
end

execute 'sudo apt purge -y nano' do
  only_if 'which nano'
end

# include_cookbook 'genie' if node['is_wsl']
execute 'sudo apt update'
execute 'sudo apt upgrade -y'

# for nokogiri for rails
package 'build-essential'
package 'apt-file'

package 'patch'
# package 'ruby-dev'
package 'zlib1g-dev'
package 'liblzma-dev'
package 'libxml2-dev'
# package 'python-fontforge'
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

include_role('base')

execute 'locale-gen ja_JP.UTF-8'

# if node[:is_wsl]
#   execute 'remove libpulse0'  do
#     command <<-EOL
#     sudo apt purge -y libpulse0
#     EOL
#   end
# end
