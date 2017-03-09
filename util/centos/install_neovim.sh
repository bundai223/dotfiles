#!/usr/bin/env bash
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip

# BASEPATH=/usr/src
BASEPATH=~/
cd $BASEPATH
src_dir=$BASEPATH/neovim_src
if [ ! -e $src_dir ]; then
  git clone https://github.com/neovim/neovim.git $src_dir
fi
cd $src_dir
git checkout .
git clean -f .
if [ -e build ]; then
  rm -r build
fi
make clean
make CMAKE_BUILD_TYPE=Release
make && sudo make install
