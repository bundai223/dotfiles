#!/usr/bin/env bash
BASEPATH=/usr/src
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip

cd $BASEPATH
git clone https://github.com/neovim/neovim.git
cd neovim
if [ -e build ]; then
  rm -r build
fi
make clean
make CMAKE_BUILD_TYPE=Release
make && make install
