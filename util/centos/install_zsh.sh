# !/bin/bash

work_dir=/usr/src
cd $work_dir
version=5.3.1
zshdir=zsh-${version}
wget http://downloads.sourceforge.net/project/zsh/zsh/${version}/${zshdir}.tar.gz
tar xfz ${zshdir}.tar.gz
cd ${zshdir}
./configure
make && make install
