# !/bin/bash

#-----------------------------------------
# zsh setting
#ln -s ~/labo/dotfiles/.zshrc ~/.zshrc

#-----------------------------------------
# vim setting
VIMRC=~/.vimrc
GVIMRC=~/.gvimrc
DOT_VIM=~/.vim
NEOBUNDLE=$DOT_VIM/.bundle
# create vimrc
if [ ! -e $VIMRC ]; then
    echo "\" vimrc">$VIMRC
    echo "if filereadable(expand(\$DOTFILES.'/.vimrc'))">>$VIMRC
    echo "    source \$DOTFILES/.vimrc">>$VIMRC
    echo "endif">>$VIMRC
else
    echo "Already Exist $VIMRC"
fi
# create gvimrc
if [ ! -e $GVIMRC ]; then
    echo "\" gvimrc">$GVIMRC
    echo "if filereadable(expand(\$DOTFILES.'/.gvimrc'))">>$GVIMRC
    echo "    source \$DOTFILES/.gvimrc">>$GVIMRC
    echo "endif">>$GVIMRC
else
    echo "Already Exist $GVIMRC"
fi

if [ ! -d $DOT_VIM ]; then
    mkdir $DOT_VIM
fi

#ln -s ~/labo/dotfiles/.vim/syntax ~/.vim/syntax
#ln -s ~/labo/dotfiles/.vim/ftplugin ~/.vim/ftplugin
#ln -s ~/labo/dotfiles/.vim/after ~/.vim/after

# neobundleがないとvimのプラグインとってこれないので先にゲット
cd $DOT_VIM
#git clone https://github.com/Shougo/neobundle.vim.git

