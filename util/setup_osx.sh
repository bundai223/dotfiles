#! /bin/bash
# TODO: 繰り返し行なうと重たい処理はフラグなどで切り替えるようにしたい。

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/osx

bash $ABS_PATH/setup.sh


# For OSX
echo "OS type ${OSTYPE}"

# Get utility
OSX_TOOL_NAMES_ARRAY=\
(\
 'https://github.com/oddstr/hengband-cocoa.git'\
 'git://github.com/JugglerShu/XVim.git'\
)
cd ~/tool
for toolname in ${OSX_TOOL_NAMES_ARRAY[@]}; do
    git clone ${toolname}
done

# Homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

#cd $OS_LOCAL_PATH && brew bundle
cd $OS_LOCAL_PATH && sh Brewfile.sh

# Make setting files link.
ln -s $OS_LOCAL_PATH/AquaSKK/kana-rule.conf ~/Library/Application\ Support/AquaSKK/

# disabled android file transfer autorun.
mv ~/Applications/Android\ File\ Transfer.app/Contents/Resources/Android\ File\ Transfer\ Agent.app ~/Applications/Android\ File\ Transfer.app/Contents/Resources/disabled_Android\ File\ Transfer\ Agent.app
mv ~/Library/Application\ Support/Google/Android\ File\ Transfer/Android\ File\ Transfer\ Agent.app ~/Library/Application\ Support/Google/Android\ File\ Transfer/disabled_Android\ File\ Transfer\ Agent.app

# Link IDE color file for intellij.
cp ~/tool/solarized/intellij-colors-solarized/Solarized* ~/Library/Preferences/IdeaIC13/colors/

# Set show AbsolutePath on finder tab.
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true
killall Finder
