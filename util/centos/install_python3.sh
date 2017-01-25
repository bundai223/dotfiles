#!/usr/bin/env bash
cd /tmp
python_version=3.5.0
wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
tar xzf Python-${python_version}.tgz
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
cd Python-${python_version}
./configure --prefix=/usr/local/python
make
sudo make install

sudo ln -s /usr/local/python/bin/python3 /usr/local/bin/python3
sudo ln -s /usr/local/python/bin/pip3 /usr/local/bin/pip3
