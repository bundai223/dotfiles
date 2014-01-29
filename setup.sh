# !/bin/bash

DOTFILES_ENTITY_PATH=~/labo/dotfiles
DOTFILES_PATH=~

#-----------------------------------------
# Create symbolic link to dotfiles
DOTFILE_NAMES_ARRAY=\
(\
 .zshrc\
 .vimrc\
 .gvimrc\
)
for dotfile in ${DOTFILE_NAMES_ARRAY[@]}; do
    if [ ! -e ${DOTFILES_PATH}/${dotfile} ]; then
        ln -s ${DOTFILES_ENTITY_PATH}/${dotfile} ${DOTFILES_PATH}/${dotfile}
        echo "Create complete ${dotfile}"
    else
        echo "Already Exist ${dotfile}"
    fi
done

#-----------------------------------------
# vim setting
DOT_VIM=.vim
if [ ! -d ~/${DOT_VIM} ]; then
    mkdir ~/${DOT_VIM}

    # neobundleがないとvimのプラグインとってこれないので先にゲット
    NEOBUNDLE_PATH=~/${DOT_VIM}/neobundle.vim
    if [ ! -d ${NEOBUNDLE_PATH} ]; then
        cd ~/${DOT_VIM}
        git clone https://github.com/Shougo/neobundle.vim.git
    fi
fi

VIMDIR_NAMES_ARRAY=\
(\
 syntax\
 ftdetect\
 after\
)
for dir in ${VIMDIR_NAMES_ARRAY[@]}; do
    if [ ! -e ~/${DOT_VIM}/${dir} ]; then
        ln -s ${DOTFILES_ENTITY_PATH}/${DOT_VIM}/${dir} ~/${DOT_VIM}/${dir}
        echo "Create complete ${dir}"
    else
        echo "Already Exist ${dir}"
    fi
done

