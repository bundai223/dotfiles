
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'tmux'

when 'fedora', 'redhat', 'amazon'
  # #!/bin/bash
  # VERSION=2.6
  # WORKDIR=work_tmux

  # install_tmux()
  # {
  #   which tmux 2>/dev/null 1>$2 && return

  #   sudo yum -y install wget gcc libevent-devel ncurses-devel

  #   cur=$(pwd)
  #   mkdir -p ${WORKDIR}
  #   cd ${WORKDIR}

  #   wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz 
  #   tar fx tmux-${VERSION}.tar.gz
  #   cd tmux-${VERSION}
  #   ./configure --prefix=/usr
  #   make
  #   sudo make install

  #   cd ${cur}
  #   rm -rf ${WORKDIR}
  # }

  # install_tmux
when 'osx', 'darwin'
  package 'tmux'
when 'arch'
when 'opensuse'
else
end
