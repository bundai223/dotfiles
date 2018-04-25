
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'zsh'

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

execute "add zplug" do
  command <<-EOL
    ghq get zplug/zplug
  EOL
end
