case node[:platform]
when 'debian', 'ubuntu', 'mint', 'fedora', 'redhat', 'amazon'
  # package 'ctags'

  package 'libjansson-dev'
  get_repo 'universal-ctags/ctags'

  execute 'install ctags' do
    command <<-EOL
      set -eu
      WORKDIR=#{node[:home]}/repos/github.com/universal-ctags/ctags

      cur=$(pwd)
      cd ${WORKDIR}

      ./autogen.sh
      ./configure
      make
      sudo make install
    EOL
    not_if 'test -e /usr/local/bin/ctags'
  end

when 'osx', 'darwin'
  #package 'universal-ctags/universal-ctags/universal-ctags'
  package 'ctags'
when 'arch'
  package 'ctags'
when 'opensuse'
else
end
