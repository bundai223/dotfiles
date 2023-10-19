version = '5.7.1'

include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  execute 'compile zsh' do
    command <<-EOL
      VERSION=#{version}
      WORKDIR=work_zsh

      cur=$(pwd)
      mkdir -p ${WORKDIR}
      cd ${WORKDIR}

      wget -O zsh-${VERSION}.tar.xz http://sourceforge.net/projects/zsh/files/zsh/${VERSION}/zsh-${VERSION}.tar.xz/download
      tar fx zsh-${VERSION}.tar.xz
      cd zsh-${VERSION}
      ./configure --prefix=/usr/local
      make
      sudo make install

      cd ${cur}
      rm -rf ${WORKDIR}
    EOL

    not_if 'test -e /usr/local/bin/zsh'
  end
when 'osx', 'darwin'
  package 'zsh'
when 'arch'
  package 'zsh'

  execute 'ln -s /usr/bin/zsh /usr/local/bin/zsh' do
    not_if 'test -e /usr/local/bin/zsh'
  end
when 'opensuse'
else
end

file '/etc/shells' do
  action :edit
  not_if 'grep /usr/local/bin/zsh /etc/shells > /dev/null'
  block do |content|
    content << '/usr/local/bin/zsh'
  end
end

file '/etc/zprofile' do
  content <<EOCONTENT
for i in /etc/profile.d/*.sh ; do
    [ -r $i ] && source $i
done
EOCONTENT
  not_if 'test -e /etc/zprofile'
  mode '644'
end
