#! /bin/bash
# TODO: 繰り返し行なうと重たい処理はフラグなどで切り替えるようにしたい。

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/osx

sh $ABS_PATH/setup.sh


# For OSX
echo "OS type ${OSTYPE}"

# Get utility
#OSX_TOOL_NAMES_ARRAY=\
#(\
# 'https://github.com/dankogai/osx-mv2trash.git'\ # こいつは死んでるので使わない
#)
#for toolname in ${OSX_TOOL_NAMES_ARRAY[@]}; do
#    git clone ${toolname}
#done

# Homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

#cd $OS_LOCAL_PATH && brew bundle
cd $OS_LOCAL_PATH && sh Brewfile.sh

# Make setting files link.
ln -s $OS_LOCAL_PATH/AquaSKK/kana-rule.conf ~/Library/Application\ Support/AquaSKK/

