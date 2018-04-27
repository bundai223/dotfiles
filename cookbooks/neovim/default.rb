
case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'software-properties-common'
  execute 'add-apt-repository ppa:neovim-ppa/stable' do
    command <<-EOL
      add-apt-repository -y ppa:neovim-ppa/stable'
      apt-get update
    EOL

    not_if 'ls /etc/source.list.d | grep neovim'
  end
  package 'python-dev'
  package 'python-pip'
  package 'python3-dev'
  package 'python3-pip'
  package 'neovim'

when 'fedora', 'redhat'
  package 'epel-release'

  execute 'add yum repository' do
    command <<-EOL
      curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo
    EOL
  end

  package 'neovim'

when 'amazon'
  package 'libtool'
  package 'autoconf'
  package 'automake'
  package 'cmake'
  package 'gcc'
  package 'gcc-c++'
  package 'make'
  package 'pkgconfig'
  package 'unzip'

  execute 'install neovim' do
    command <<-EOL
      BASEPATH=/usr/src
      cd $BASEPATH

      git clone https://github.com/neovim/neovim.git
      cd neovim
      if [ -e build ]; then
        rm -r build
      fi
      make clean
      make CMAKE_BUILD_TYPE=Release
      make && sudo make install
    EOL
  end

when 'osx', 'darwin'
  package 'nvim'
when 'arch'
when 'opensuse'
else
end

execute 'install gem package' do
  command <<-EOL
    gem install neovim
  EOL
end

execute 'install python package' do
  command <<-EOL
    pip3 install --upgrade neovim
    pip install --upgrade neovim
  EOL
end
