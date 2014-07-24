#! /bin/bash
sudo aptitude -y remove vim

sudo aptitude -y install build-dep gettext tcl-dev lua5.2 liblua5.2-dev ruby-dev python3-dev

# Get sourcecode.
ghq get https://vim.googlecode.com/hg/vim
cd ~/repos/vim.googlecode.com/hg/vim


