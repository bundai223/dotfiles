#! /bin/bash
# golang のインストール・ghqのインストールを完了させる必要がある。
# TODO: 繰り返し行なうと重たい処理はフラグなどで切り替えるようにしたい。

PATH_TO_HERE=`dirname $0`
ABS_PATH=`cd $PATH_TO_HERE && pwd`
OS_LOCAL_PATH=$ABS_PATH/../os_local/osx

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
OSX_TOOL_NAMES_ARRAY=\
(\
 'oddstr/hengband-cocoa.git'\
 'JugglerShu/XVim.git'\
)
for toolname in ${OSX_TOOL_NAMES_ARRAY[@]}; do
    ghq get ${toolname}
done

# OSX環境に必須なHomebrewをインストール
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

cd $OS_LOCAL_PATH && sh Brewfile.sh


# リポジトリの取得にも必要なのでgoの初期化
source $ABS_PATH/setup_golang.sh

if [ $TMP_GITCONFIG == 1 ]; then
	rm ~/.gitconfig
fi

# 共通の初期化処理
# 各ツールの設定ファイルのリンクなど
source $ABS_PATH/setup.sh


# Make setting files link.
ln -s $ABS_PATH/SKK-JISYO.L ~/Library/Application\ Support/AquaSKK/SKK-JISYO.L
ln -s $OS_LOCAL_PATH/AquaSKK/kana-rule.conf ~/Library/Application\ Support/AquaSKK/
ln -s $OS_LOCAL_PATH/.vimrc_local ~/.vimrc_local
ln -s $OS_LOCAL_PATH/.zshrc_local ~/.zshrc_local
ln -s $OS_LOCAL_PATH/.zshenv_local ~/.zshenv_local

# disabled android file transfer autorun.
mv ~/Applications/Android\ File\ Transfer.app/Contents/Resources/Android\ File\ Transfer\ Agent.app ~/Applications/Android\ File\ Transfer.app/Contents/Resources/disabled_Android\ File\ Transfer\ Agent.app
mv ~/Library/Application\ Support/Google/Android\ File\ Transfer/Android\ File\ Transfer\ Agent.app ~/Library/Application\ Support/Google/Android\ File\ Transfer/disabled_Android\ File\ Transfer\ Agent.app

# Link IDE color file for intellij.
cp ~/repos/github.com/altercation/solarized/intellij-colors-solarized/Solarized* ~/Library/Preferences/IdeaIC13/colors/
cp ~/repos/github.com/altercation/solarized/intellij-colors-solarized/Solarized* ~/Library/Preferences/AndroidStudioBeta/colors/

# Set show AbsolutePath on finder tab.
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true
killall Finder

# AndroidStudio style.xml setting.
curl -L https://raw.githubusercontent.com/android/platform_development/master/ide/intellij/codestyles/AndroidStyle.xml > ~/Library/Preferences/AndroidStudioBeta/codestyles/AndroidStyle.xml

