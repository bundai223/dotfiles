#! /bin/bash
# https://gist.github.com/jdewit/9818870
sudo apt-get -y remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common

sudo apt-get -y build-dep vim-gnome
sudo aptitude -y install liblua5.1-dev luajit libluajit-5.1-dev python-dev ruby-dev libperl-dev mercurial libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev

# Get sourcecode.
ghq get https://code.google.com/p/vim
cd ~/repos/code.google.com/p/vim/src
make distclean

./configure --with-features=huge \
    --enable-rubyinterp \
    --enable-largefile \
    --disable-netbeans \
    --enable-pythoninterp \
    --with-python-config-dir=/usr/lib/python2.7/config \
    --enable-perlinterp \
    --enable-luainterp=dynamic \
    --with-luajit \
    --enable-gui=auto \
    --enable-fail-if-missing \
    --with-lua-prefix=/usr \
    --enable-multibyte \
    --enable-cscope 
make
sudo make install
