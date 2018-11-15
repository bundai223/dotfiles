include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  execute 'compile zsh' do
    command <<-EOL
      VERSION=5.5.1
      WORKDIR=work_zsh

      cur=$(pwd)
      mkdir -p ${WORKDIR}
      cd ${WORKDIR}

      wget -O zsh-${VERSION}.tar.gz http://sourceforge.net/projects/zsh/files/zsh/${VERSION}/zsh-${VERSION}.tar.gz/download
      tar fx zsh-${VERSION}.tar.gz
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

