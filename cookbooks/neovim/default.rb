include_recipe 'dependency.rb'

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'software-properties-common'
  execute 'add-apt-repository ppa:neovim-ppa/stable' do
    command <<-EOCMD
      add-apt-repository -y ppa:neovim-ppa/stable
      apt-get update
    EOCMD

    # not_if 'test -e /etc/apt/sources.list.d/neovim-ppa-ubuntu-stable-xenial.list'
    not_if 'ls /etc/apt/sources.list.d | grep neovim'
  end
  package 'neovim'

when 'fedora', 'redhat', 'amazon'
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
    command <<-EOCMD
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
    EOCMD
  end

when 'osx', 'darwin'
  package 'nvim'
when 'arch'
  package 'neovim'
when 'opensuse'
else
end
