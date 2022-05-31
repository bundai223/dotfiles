include_recipe 'dependency.rb'

def neovim_make_install
  execute 'install neovim' do
    command <<-EOCMD
      BASEPATH=/usr/src
      cd $BASEPATH

      git clone https://github.com/neovim/neovim.git
      git pull
      cd neovim
      if [ -e build ]; then
        rm -r build
      fi
      make clean
      make -j4 CMAKE_BUILD_TYPE=Release
      make && sudo make install
    EOCMD
  end
end

case node[:platform]
when 'debian', 'ubuntu', 'mint'
  package 'ninja-build'
  package 'gettext'
  package 'libtool'
  package 'libtool-bin'
  package 'autoconf'
  package 'automake'
  package 'cmake'
  package 'g++'
  package 'pkg-config'
  package 'unzip'
  package 'curl'
  package 'doxygen'

  neovim_make_install

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

  neovim_make_install

when 'osx', 'darwin'
  package 'nvim'
when 'arch'
  package 'neovim'
when 'opensuse'
else
end
