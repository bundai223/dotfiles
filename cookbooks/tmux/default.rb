include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  execute 'install tmux' do
    command <<-EOL
      VERSION=2.7
      WORKDIR=work_tmux

      cur=$(pwd)
      mkdir -p ${WORKDIR}
      cd ${WORKDIR}

      wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
      tar fx tmux-${VERSION}.tar.gz
      cd tmux-${VERSION}
      ./configure --prefix=/usr/local
      make
      sudo make install

      cd ${cur}
      rm -rf ${WORKDIR}
    EOL

    not_if 'test -e /usr/local/bin/tmux'
  end
when 'osx', 'darwin'
  package 'tmux'
when 'arch'
  package 'tmux'
when 'opensuse'
else
end
