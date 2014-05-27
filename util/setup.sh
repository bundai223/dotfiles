# !/bin/bash

DOTFILES_ENTITY_PATH=~/labo/dotfiles
DOTFILES_PATH=~

# エラーなしのmkdir
mkdir_noerror()
{
    if [ ! -d $1 ]; then
        mkdir $1
    fi
}

mkdir_noerror ~/.tmux
mkdir_noerror ~/.zsh


# Create symbolic link to dotfiles {{{
DOTFILE_NAMES_ARRAY=\
(\
 .gitconfig\
 .gitignore_global\
 .gitattributes_global\
 .zshrc\
 .vimrc\
 .gvimrc\
 .vrapperrc\
 .ideavimrc\
 .tmux.conf\
 .tmux/utility\
 .ctags
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
mkdir_noerror ~/${DOT_VIM}
mkdir_noerror ~/${DOT_VIM}/undo

# neobundleがないとvimのプラグインとってこれないので先にゲット
NEOBUNDLE_PATH=~/${DOT_VIM}/neobundle.vim
if [ ! -d ${NEOBUNDLE_PATH} ]; then
    cd ~/${DOT_VIM}
    git clone https://github.com/Shougo/neobundle.vim.git
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
VIM_DOTFILE_PATH=~/.vimrc_local_env
if [ ! -e ${VIM_DOTFILE_PATH} ]; then
    echo "let \$DOTFILES=expand(\"~/\").\"labo/dotfiles\"">${VIM_DOTFILE_PATH}
else
    echo "Already Exist ${VIM_DOTFILE_PATH}"
fi

#}}}

# Setup utility.
TOOL_DIR_PATH=~/tool
mkdir_noerror ${TOOL_DIR_PATH}
cd ${TOOL_DIR_PATH}

TOOL_NAMES_ARRAY=\
(\
 'https://github.com/github/gitignore.git'\
 'https://github.com/zsh-users/zsh-completions.git'\
 'https://github.com/altercation/solarized'\
)
for toolname in ${TOOL_NAMES_ARRAY[@]}; do
    git clone ${toolname}
done

# OS Type Settings.
# Refactoring now.
# For OSX
echo "OS type ${OSTYPE}"
if [[ $OSTYPE == darwin* ]]; then
    echo "nothing to do."
else
    git clone https://github.com/rupa/z.git
fi

