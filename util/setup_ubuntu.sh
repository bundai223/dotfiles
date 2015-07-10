#! /bin/bash

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/unix

# 初回の処理のために環境変数を読み込み
source $OS_LOCAL_PATH/.zshenv_local

# install go
ZIPNAME=go1.3.linux-amd64.tar.gz
wget http://golang.org/dl/${ZIPNAME}
sudo tar zxvf ${ZIPNAME} -C /usr/local
rm ${ZIPNAME}

PATH=/usr/local/go/bin/:$PATH
export PATH

sudo apt-get -y update
sudo apt-get -y install git mercurial ssh zsh aptitude tmux ssh ntp silversearcher-ag

# go setting
# ghqのパス設定のために一時的にコピーしておく
TMP_GITCONFIG=0
if [ ! -e ~/.gitconfig ]; then
	TMP_GITCONFIG=1
	cp $ABS_PATH/../.gitconfig ~/
fi


bash $ABS_PATH/setup_golang.sh

if [ $TMP_GITCONFIG == 1 ]; then
	rm ~/.gitconfig
fi

bash $ABS_PATH/setup_ricty.sh
bash $ABS_PATH/setup_vim.sh

# common setting
bash $ABS_PATH/setup.sh

# Make setting files link.
ln -s $OS_LOCAL_PATH/.vimrc_local ~/.vimrc_local
ln -s $OS_LOCAL_PATH/.zshrc_local ~/.zshrc_local
ln -s $OS_LOCAL_PATH/.zshenv_local ~/.zshenv_local
touch ~/.config/tmux/session

ZSH_PATH=`which zsh`
chsh -s ${ZSH_PATH}
# 
# exit

# Set dirname English.
LANG=C xdg-user-dirs-gtk-update
