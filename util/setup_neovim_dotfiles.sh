#!/usr/bin/env bash

vim_config=${XDG_CONFIG_HOME}/vim
nvim_config=${XDG_CONFIG_HOME}/nvim
mkdir -p $nvim_config
mkdir -p $nvim_config/swp
mkdir -p $nvim_config/backup
mkdir -p $nvim_config/undo

set -eu
#ls ${vim_config} | xargs -Idir ln -s ${vim_config}/dir ${nvim_config}/dir
#ln -s ~/.vimrc ${nvim_config}/init.vim
dotfiles=~/repos/github.com/bundai223/dotfiles
ln -s ${dotfiles}/nvim/init.vim ${nvim_config}/init.vim
