# !/bin/bash
# need go & ghq

DOTFILES_ENTITY_PATH=~/repos/github.com/bundai223/dotfiles
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
 .gitconfig_global\
 .gitignore_global\
 .gitattributes_global\
 .zshenv\
 .zshrc\
 .vimrc\
 .gvimrc\
 .vrapperrc\
 .ideavimrc\
 .tmux.conf\
 .tmux/utility\
 .ctags\
 .emacs.d/init.el
)
for dotfile in ${DOTFILE_NAMES_ARRAY[@]}; do
    if [ ! -e ${DOTFILES_PATH}/${dotfile} ]; then
        ln -s ${DOTFILES_ENTITY_PATH}/${dotfile} ${DOTFILES_PATH}/${dotfile}
        echo "Create complete ${dotfile}"
    else
        echo "Already Exist ${dotfile}"
    fi
done
# Make git configuration file that include common config to make local setting.
if [ ! -e ${DOTFILES_PATH}/.gitconfig ]; then
    cp ${DOTFILES_ENTITY_PATH}/.gitconfig_local ${DOTFILES_PATH}/.gitconfig
fi
#}}}

# vim setting {{{
DOT_VIM=.vim
mkdir_noerror ~/${DOT_VIM}
mkdir_noerror ~/${DOT_VIM}/undo
mkdir_noerror ~/${DOT_VIM}/backup
mkdir_noerror ~/${DOT_VIM}/swp

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
    echo "let \$DOTFILES=expand(\"${DOTFILES_ENTITY_PATH}\")">${VIM_DOTFILE_PATH}
else
    echo "Already Exist ${VIM_DOTFILE_PATH}"
fi

#}}}

# Setup utility.
TOOL_DIR_PATH=~/repos
mkdir_noerror ${TOOL_DIR_PATH}

TOOL_NAMES_ARRAY=\
(\
 'github/gitignore.git'\
 'zsh-users/zsh-completions.git'\
 'zsh-users/antigen.git'\
 'altercation/solarized'\
 'ajaxorg/cloud9.git'\
 'csabahenk/dedrm-ebook-tools.git'\
)
for toolname in ${TOOL_NAMES_ARRAY[@]}; do
    ghq get ${toolname}
done

# OS Type Settings.
# Refactoring now.
# For OSX
echo "OS type ${OSTYPE}"
if [[ $OSTYPE == darwin* ]]; then
    echo "nothing to do."
else
    ghq get rupa/z.git
fi

# pythonツール
easy_install fabric
easy_install vim-vint


