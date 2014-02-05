# !/bin/bash

DOTFILES_ENTITY_PATH=~/labo/dotfiles
DOTFILES_PATH=~

# Create symbolic link to dotfiles {{{
DOTFILE_NAMES_ARRAY=\
(\
 .zshrc\
 .vimrc\
 .gvimrc\
 .vrapperrc\
 .tmux.conf\
)
for dotfile in ${DOTFILE_NAMES_ARRAY[@]}; do
    if [ ! -e ${DOTFILES_PATH}/${dotfile} ]; then
        ln -s ${DOTFILES_ENTITY_PATH}/${dotfile} ${DOTFILES_PATH}/${dotfile}
        echo "Create complete ${dotfile}"
    else
        echo "Already Exist ${dotfile}"
    fi
done
#}}}

# vim setting {{{
DOT_VIM=.vim
if [ ! -d ~/${DOT_VIM} ]; then
    mkdir ~/${DOT_VIM}

    # Save undo directory.
    mkdir ~/${DOT_VIM}/undo

    # neobundleがないとvimのプラグインとってこれないので先にゲット
    NEOBUNDLE_PATH=~/${DOT_VIM}/neobundle.vim
    if [ ! -d ${NEOBUNDLE_PATH} ]; then
        cd ~/${DOT_VIM}
        git clone https://github.com/Shougo/neobundle.vim.git
    fi
fi

# link to .vim dir
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

# path to dotfile
VIM_DOTFILE_PATH=~/.my_local_vimrc_env
if [ ! -e ${VIM_DOTFILE_PATH} ]; then
    echo "let \$DOTFILES=expand(\"~/\").\"labo/dotfiles\"">${VIM_DOTFILE_PATH}
else
    echo "Already Exist ${VIM_DOTFILE_PATH}"
fi

#}}}

# For OSX
if [ "$1" == "OSX" ]; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew install git zsh tmux cmake ctags reattach-to-user-namespace
    brew install macvim --with-cscope --with-luajit
fi


