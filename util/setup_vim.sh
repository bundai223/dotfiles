#! /bin/bash
#sudo aptitude -y remove vim

sudo aptitude -y install build-dep gettext tcl-dev lua5.1 liblua5.1-dev luajit libluajit-5.1 ruby-dev python3-dev libpearl


# Get sourcecode.
#ghq get https://code.google.com/p/vim
cd ~/repos/code.google.com/p/vim/src
make distclean

./configure --with-features=huge \
--disable-selinux \
--enable-largefile \
--enable-luainterp \
--with-luajit \
--with-lua-prefix=/usr \
--enable-perlinterp \
--enable-pythoninterp \
--enable-python3interp \
--enable-tclinterp \
--enable-rubyinterp \
--enable-cscope \
--enable-multibyte \
--enable-gui \
--enable-fail-if-missing

