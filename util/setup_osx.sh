#! /bin/bash

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
echo $ABS_PATH

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

brew install git
brew install zsh
brew install tmux
brew install cmake
brew install ctags
brew install z
brew install android
brew install luajit
brew install reattach-to-user-namespace
brew install terminal-notifier

brew install macvim --with-cscope --with-luajit


# Make setting files link.
ln -s $ABS_PATH/../os_local/osx/AquaSKK/kana-rule.conf ~/Library/Application\ Support/AquaSKK/
