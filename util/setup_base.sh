# !/bin/bash
# need go & ghq

DOTFILES_ENTITY_PATH=~/repos/github.com/bundai223/dotfiles
DOTFILES_PATH=~

REPOS_PATH=~/repos

# エラーなしのmkdir
mkdir_noerror()
{
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
}

mkln()
{
  src=${1}
  dst=${2}
  if [ ! -e ${src} ]; then
    echo "Not exist source.: ${src}"
    return 1
  fi
  if [ ! -e ${dst} ]; then
    ln -s ${src} ${dst} && echo "Create link:${dst}"
  else
    echo "Already Exists ${dst}"
  fi
}

mkdir_noerror ~/.emacs.d
mkdir_noerror ~/tools/bin
mkdir_noerror ~/.config/git
mkdir_noerror ~/.config/tmux
mkdir_noerror ~/.config/zsh
mkdir_noerror ~/.config/zsh/z
mkdir_noerror ~/.config/vim

# Get tools repositories.
mkdir_noerror ${REPOS_PATH}

TOOL_NAMES_ARRAY=\
(\
 'Shougo/neobundle.vim'\
 'github/gitignore.git'\
 'zsh-users/zsh-completions.git'\
 'zsh-users/antigen.git'\
 'altercation/solarized'\
 'tomorrowkey/adb-peco'\
 'JakeWharton/pidcat'\
 'sys1yagi/genymotion-peco'\
 'powerline/fonts'\
 'rupa/z.git'\
 'bundai223/zsh-utils'\
 'bundai223/dotfiles'\
 'mzyy94/RictyDiminished-for-Powerline'\
)
#  'ajaxorg/cloud9.git'\
#  'csabahenk/dedrm-ebook-tools.git'\
for toolname in ${TOOL_NAMES_ARRAY[@]}; do
    ghq get ${toolname}
done

mkln ${REPOS_PATH}/github.com/bundai223/zsh-utils ~/.config/zsh/zsh-utils

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
 .config/tmux/utility\
 .config/git/templates\
 .config/powerline\
 .ctags\
 .emacs.d/inits\
)

for dotfile in ${DOTFILE_NAMES_ARRAY[@]}; do
  mkln ${DOTFILES_ENTITY_PATH}/${dotfile} ${DOTFILES_PATH}/${dotfile}
done

# Make git configuration file that include common config to make local setting.
if [ ! -e ${DOTFILES_PATH}/.gitconfig ]; then
    cp ${DOTFILES_ENTITY_PATH}/.gitconfig_local ${DOTFILES_PATH}/.gitconfig
fi
#}}}

ghq_root=$(ghq root)
sh ${ghq_root}/$(ghq list powerline/fonts)/install.sh

# pythonツール
pip install --upgrade pip setuptools
pip install --upgrade fabric
pip install --upgrade vim-vint
pip install --upgrade git+git://github.com/powerline/powerline psutil

# vim setting {{{
DOT_VIM=.config/vim
mkdir_noerror ~/${DOT_VIM}
mkdir_noerror ~/${DOT_VIM}/undo
mkdir_noerror ~/${DOT_VIM}/backup
mkdir_noerror ~/${DOT_VIM}/swp

# link to .vim dir
VIMDIR_NAMES_ARRAY=\
(\
 syntax\
 ftdetect\
 after\
)
for dir in ${VIMDIR_NAMES_ARRAY[@]}; do
  mkln ${DOTFILES_ENTITY_PATH}/${DOT_VIM}/${dir} ~/${DOT_VIM}/${dir}
done

# path to dotfile
VIM_DOTFILE_PATH=~/.vimrc_local_env
if [ ! -e ${VIM_DOTFILE_PATH} ]; then
    echo "let \$DOTFILES=expand(\"${DOTFILES_ENTITY_PATH}\")">${VIM_DOTFILE_PATH}
else
    echo "Already Exist ${VIM_DOTFILE_PATH}"
fi

#}}}


