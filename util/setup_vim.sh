#! /bin/bash
# https://gist.github.com/jdewit/9818870
#sudo aptitude -y remove vim

sudo aptitude -y install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev


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

