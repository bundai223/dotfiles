#! /bin/bash

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/unix

# 初回の処理のために環境変数を読み込み
source $OS_LOCAL_PATH/.zshenv_local

# sudo yum -y update
sudo yum -y install git zsh tmux wget ntp python python-devel
# install pip
curl -kL https://bootstrap.pypa.io/get-pip.py | sudo python

# install go
OS_TYPE=linux-386
#OS_TYPE=linux-amd64
GO_VERSION=1.6.2
ZIPNAME=go${GO_VERSION}.${OS_TYPE}.tar.gz
CHECK_VERSION=$(go version|grep ${GO_VERSION})
if [ -z "${CHECK_VERSION}" ]; then
  wget http://golang.org/dl/${ZIPNAME}
  sudo tar zxvf ${ZIPNAME} -C /usr/local
  rm ${ZIPNAME}
fi

PATH=/usr/local/go/bin/:$PATH
export PATH

# go setting
# ghqのパス設定のために一時的にコピーしておく
TMP_GITCONFIG=0
if [ ! -e ~/.gitconfig ]; then
  TMP_GITCONFIG=1
  cp $ABS_PATH/../.gitconfig_global ~/.gitconfig
fi


bash $ABS_PATH/install_golang.sh

if [ $TMP_GITCONFIG == 1 ]; then
  rm ~/.gitconfig
fi

bash $ABS_PATH/install_ricty.sh
#bash $ABS_PATH/install_vim.sh

# common setting
bash $ABS_PATH/setup_base.sh

# Make setting files link.
ln -s $OS_LOCAL_PATH/.vimrc_local ~/.vimrc_local
ln -s $OS_LOCAL_PATH/.zshrc_local ~/.zshrc_local
ln -s $OS_LOCAL_PATH/.zshenv_local ~/.zshenv_local
touch ~/.config/tmux/session

ZSH_PATH=`which zsh`
chsh -s ${ZSH_PATH}
# 
# exit

