#! /bin/sh
tmux_version=2.2
pwd=$(pwd)
work_dir=/tmp

sudo yum -y install ncurses-devel
# libevent
cd ${work_dir}
wget http://sourceforge.net/projects/levent/files/latest/download
tar -xvf download
cd libevent-2.0.22-stable
./configure && make
sudo make install

# libeventを認識させる
sudo echo "/usr/local/lib">/etc/ld.so.conf.d/libevent.conf
sudo ldconfig
if [ $(arch) == "i686" ]; then
  # 32bit用
  sudo ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib/libevent-2.0.so.5
else
  # 64bit用
  sudo ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
fi
cd $pwd

# tmuxをインストール
cd ${work_dir}
wget https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz
tar xvf tmux-${tmux_version}.tar.gz
cd tmux-${tmux_version}
./configure && make
sudo make install
