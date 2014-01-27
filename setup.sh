# !/bin/bash

DOTFILES=~/labo/dotfiles

#-----------------------------------------
# zsh setting
ln -s ${DOTFILES}/.zshrc ~/.zshrc

#-----------------------------------------
# vim setting
VIMRC=~/.vimrc
GVIMRC=~/.gvimrc
DOT_VIM=~/.vim
NEOBUNDLE=${DOT_VIM}/.bundle
# create vimrc
if [ ! -e $VIMRC ]; then
    echo "\" vimrc">${VIMRC}
    echo "if filereadable(expand('${DOTFILES}/.vimrc'))">>${VIMRC}
    echo "    source ${DOTFILES}/.vimrc">>${VIMRC}
    echo "endif">>${VIMRC}
else
    echo "Already Exist ${VIMRC}"
fi
# create gvimrc
if [ ! -e ${GVIMRC} ]; then
    echo "\" gvimrc">${GVIMRC}
    echo "if filereadable(expand('${DOTFILES}/.gvimrc'))">>${GVIMRC}
    echo "    source ${DOTFILES}/.gvimrc">>${GVIMRC}
    echo "endif">>${GVIMRC}
else
    echo "Already Exist ${GVIMRC}"
fi

if [ ! -d ${DOT_VIM} ]; then
    mkdir ${DOT_VIM}
fi

ln -s ${DOTFILES}/.vim/syntax ${DOT_VIM}/syntax
ln -s ${DOTFILES}/.vim/ftplugin ${DOT_VIM}/ftplugin
ln -s ${DOTFILES}/.vim/after ${DOT_VIM}/after

# neobundleがないとvimのプラグインとってこれないので先にゲット
cd $DOT_VIM
git clone https://github.com/Shougo/neobundle.vim.git

