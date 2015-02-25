#! /bin/bash
# golang のインストール・ghqのインストールを完了させる必要がある。
#qua TODO: 繰り返し行なうと重たい処理はフラグなどで切り替えるようにしたい。

PATH_TO_HERE=`dirname ${0}`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/osx


# OSX環境に必須なHomebrewをインストール
if [ -z `which brew` ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


# 初回の処理のために環境変数を読み込み
source $OS_LOCAL_PATH/.zshenv_local

# ghqのパス設定のために一時的にコピーしておく
TMP_GITCONFIG=0
if [ ! -e ~/.gitconfig ]; then
    TMP_GITCONFIG=1
    cp $ABS_PATH/../.gitconfig_global ~/.gitconfig
fi


# For OSX
echo "OS type ${OSTYPE}"
echo $GOPATH

# Get utility
cd $OS_LOCAL_PATH && sh Brewfile.sh

# リポジトリの取得にも必要なのでgoの初期化
source $ABS_PATH/setup_golang.sh

if [ $TMP_GITCONFIG == 1 ]; then
    rm ~/.gitconfig
fi

# 共通の初期化処理
# 各ツールの設定ファイルのリンクなど
source $ABS_PATH/setup.sh

OSX_TOOL_NAMES_ARRAY=\
(\
 'JugglerShu/XVim.git'\
)
for toolname in ${OSX_TOOL_NAMES_ARRAY[@]}; do
    ghq get ${toolname}
done


# Make setting files link.
mkdir -p ~/Library/Application\ Support/AquaSKK
sudo ln -s $ABS_PATH/SKK-JISYO.L ~/Library/Application\ Support/AquaSKK
sudo ln -s $ABS_PATH/skk-jisyo.utf8 ~/Library/Application\ Support/AquaSKK
sudo ln -s $OS_LOCAL_PATH/AquaSKK/kana-rule.conf ~/Library/Application\ Support/AquaSKK/
ln -s $OS_LOCAL_PATH/.vimrc_local ~/.vimrc_local
ln -s $OS_LOCAL_PATH/.zshrc_local ~/.zshrc_local
ln -s $OS_LOCAL_PATH/.zshenv_local ~/.zshenv_local

# disabled android file transfer autorun.
mv ~/Applications/Android\ File\ Transfer.app/Contents/Resources/Android\ File\ Transfer\ Agent.app ~/Applications/Android\ File\ Transfer.app/Contents/Resources/disabled_Android\ File\ Transfer\ Agent.app
mv ~/Library/Application\ Support/Google/Android\ File\ Transfer/Android\ File\ Transfer\ Agent.app ~/Library/Application\ Support/Google/Android\ File\ Transfer/disabled_Android\ File\ Transfer\ Agent.app

INSTALL_FONTS_PATH=~/Library/Fonts
if [ ! -e ${INSTALL_FONTS_PATH}/Ricty-Regular.ttf ]; then
    cp /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ${INSTALL_FONTS_PATH}/
    fc-cache -vf
fi

# Link IDE color file for intellij.
cp ~/repos/github.com/altercation/solarized/intellij-colors-solarized/Solarized* ~/Library/Preferences/IdeaIC13/colors/
cp ~/repos/github.com/altercation/solarized/intellij-colors-solarized/Solarized* ~/Library/Preferences/AndroidStudioBeta/colors/

# Set show AbsolutePath on finder tab.
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true
killall Finder

# AndroidStudio style.xml setting.
curl -L https://raw.githubusercontent.com/android/platform_development/master/ide/intellij/codestyles/AndroidStyle.xml > ~/Library/Preferences/AndroidStudioBeta/codestyles/AndroidStyle.xml


# opamの設定
# opam init
# opam 

