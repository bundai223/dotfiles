include_recipe 'dependency.rb'

define :neovim_make_install do
  execute 'install neovim' do
    command <<-EOCMD
      BASEPATH=/usr/src
      cd $BASEPATH

      git clone https://github.com/neovim/neovim.git
      cd neovim
      git pull
      if [ -e build ]; then
        rm -r build
      fi
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

  neovim_make_install :install

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

  neovim_make_install :install

when 'osx', 'darwin'
  package 'nvim'
when 'arch'
  package 'neovim'
when 'opensuse'
else
end
