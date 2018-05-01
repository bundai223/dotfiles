
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'wget'

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
when 'fedora', 'redhat', 'amazon'
  package 'wget'
  package 'ncurses-devel'

  #!/bin/bash
  # VERSION=5.4.2
  # WORKDIR=work_zsh
  #
  # install_zsh()
  # {
  #   which zsh 2>/dev/null 1>$2 && return
  #
  #   sudo yum -y install wget ncurses-devel
  #
  #   cur=$(pwd)
  #   mkdir -p ${WORKDIR}
  #   cd ${WORKDIR}
  #
  #   wget -O zsh-${VERSION}.tar.gz http://sourceforge.net/projects/zsh/files/zsh/${VERSION}/zsh-${VERSION}.tar.gz/download
  #   tar fx zsh-${VERSION}.tar.gz
  #   cd zsh-${VERSION}
  #   ./configure --prefix=/usr
  #   make
  #   sudo make install
  #
  #   cd ${cur}
  #   rm -rf ${WORKDIR}
  # }
  #
  # install_zsh

when 'osx', 'darwin'
  package 'zsh'
when 'arch'
when 'opensuse'
else
end

