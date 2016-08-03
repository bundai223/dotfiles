#!/usr/bin/env bash
vim_config=${XDG_CONFIG_HOME}/vim
nvim_config=${XDG_CONFIG_HOME}/nvim
dotfiles=~/repos/github.com/bundai223/dotfiles
mkdir -p $nvim_config
mkdir -p $nvim_config/swp
mkdir -p $nvim_config/backup
mkdir -p $nvim_config/undo

set -eu
ln -s ${dotfiles}/nvim/dein.toml ${nvim_config}/dein.toml
ln -s ${dotfiles}/nvim/dein_lazy.toml ${nvim_config}/dein_lazy.toml
ln -s ${dotfiles}/nvim/init.vim ${nvim_config}/init.vim
