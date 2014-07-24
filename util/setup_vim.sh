#! /bin/bash
#sudo aptitude -y remove vim

sudo aptitude -y install build-dep gettext tcl-dev lua5.2 liblua5.2-dev ruby-dev python3-dev

# Get sourcecode.
#ghq get https://code.google.com/p/vim
#cd ~/repos/code.google.com/p/vim

./configure --with-features=huge \
--disable-selinux \
--enable-largefile \
--enable-luainterp \
--with-luajit \
--enable-perlinterp \
--enable-pythoninterp \
--enable-python3interp \
--enable-tclinterp \
--enable-rubyinterp \
--enable-cscope \
--enable-multibyte \
--enable-gui \
--enable-fail-if-missing

