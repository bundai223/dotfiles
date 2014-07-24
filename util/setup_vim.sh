#! /bin/bash
sudo aptitude -y remove vim

sudo aptitude -y install build-dep gettext tcl-dev lua5.2 liblua5.2-dev ruby-dev python3-dev

# Get sourcecode.
ghq get https://code.google.com/p/vim
cd ~/repos/code.google.com/p/vim


