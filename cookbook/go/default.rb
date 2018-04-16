
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'software-properties-common'
  execute 'add-apt-repository ppa:longsleep/golang-backports' do
    run_command 'apt-get update'
  end
  package 'golang-go'

when 'fedora', 'redhat', 'amazon'
  # #!/bin/bash
  # VERSION=1.9.2
  # OS=linux
  # ARCH=amd64
  # WORKDIR=work_go

  # install_go()
  # {
  #   which go 2>/dev/null 1>$2 && return

  #   cur=$(pwd)
  #   mkdir -p ${WORKDIR}
  #   cd ${WORKDIR}

  #   tgz=go${VERSION}.${OS}-${ARCH}.tar.gz
  #   wget https://redirector.gvt1.com/edgedl/go/${tgz}
  #   sudo tar -C /usr/local -xzf ${tgz}

  #   cd ${cur}
  #   rm -rf ${WORKDIR}

  #   echo '* Please set path'
  #   echo 'export PATH=$PATH:/usr/local/go/bin'
  # }

  # install_go

when 'osx', 'darwin'
when 'arch'
when 'opensuse'
else
end
