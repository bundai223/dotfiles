# !/usr/bin/zsh

# make symbolic link
ln -s ~/labo/dotfiles/.zshrc ~/.zshrc
ln -s ~/labo/dotfiles/.vimrc ~/.vimrc
ln -s ~/labo/dotfiles/.gvimrc ~/.gvimrc

mkdir ~/.vim
ln -s ~/labo/dotfiles/.vim/syntax ~/.vim/syntax
ln -s ~/labo/dotfiles/.vim/ftplugin ~/.vim/ftplugin
ln -s ~/labo/dotfiles/.vim/after ~/.vim/after

cd ~/.vim
git clone https://github.com/Shougo/neobundle.vim.git

