
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'software-properties-common'

  execute 'add apt repository' do
    command <<-EOL
      add-apt-repository -y ppa:git-core/ppa
      apt update
    EOL

    not_if 'ls /etc/apt/sources.list.d | grep git'
  end

  package 'git'

when 'fedora', 'redhat', 'amazon'
  package 'wget'
  package 'curl-devel'
  package 'expat-devel'
  package 'gettext-devel'
  package 'openssl-devel'
  package 'zlib-devel'
  package 'perl-ExtUtils-MakeMaker'
  package 'autoconf'

  execute 'install git' do
    command <<-EOL
      #!/bin/bash
      VERSION=2.17.1
      WORKDIR=work_git

      cur=$(pwd)
      mkdir -p ${WORKDIR}
      cd ${WORKDIR}

      wget https://www.kernel.org/pub/software/scm/git/git-${VERSION}.tar.gz
      tar fx git-${VERSION}.tar.gz
      cd git-${VERSION}
      make configure
      ./configure --prefix=/usr/local
      make all
      sudo make install

      cd ${cur}
      rm -rf ${WORKDIR}
    EOL
    not_if 'test -e /usr/local/bin/git'
  end

when 'osx', 'darwin'
  package 'git'
when 'arch'
  package 'git'
when 'opensuse'
else
end
