case node[:platform]
when 'arch'
  include_cookbook 'yay'
  package 'automake'
  package 'autoconf'
when 'osx', 'darwin'
when 'fedora', 'redhat', 'amazon'
  execute 'install gnu global' do
    command <<-EOCMD
      VERSION=6.6.3

      TMP=tmp_global
      P=$(pwd)
      mkdir $TMP
      cd $TMP

      wget http://tamacom.com/global/global-${VERSION}.tar.gz
      tar xfz global-${VERSION}.tar.gz
      cd global-${VERSION}
      ./configure
      make
      sudo make install

      # clean up
      cd $P
      rm -rf $TMP
    EOCMD
  end
when 'debian', 'ubuntu', 'mint'
when 'opensuse'
else
end
