# 
brew update

# cask
# gui tools
if [[ $OSTYPE == darwin* ]]; then
    # brew tap caskroom/versions
    brew install caskroom/homebrew-cask/brew-cask
    brew cask update

    brew cask install xquartz
    brew cask install google-chrome
    brew cask install iterm2
    brew cask install xtrafinder
    brew cask install dash
    brew cask install android-file-transfer
    brew cask install android-studio
    brew cask install intellij-idea-ce
    brew cask install atom
    brew cask install sourcetree
    brew cask install genymotion
    brew cask install sequel-pro
    brew cask install rcdefaultapp
    brew cask install virtualbox
    brew cask install synergy
    brew cask install vlc
    brew cask install menumeters
    brew cask install hyperswitch
    #brew cask install cheatsheet
    #brew cask install clipmenu

    brew install caskroom/versions/java6

    # for hobby
    if [ $OSX_PRIVATE ]; then
        brew cask install onepassword dropbox
        brew cask install skype
        #brew cask install wireshark
        brew cask install xbox360-controller-driver
        brew cask install blender
        brew cask install gimp
        brew cask install inkscape
        brew cask install minecraft
        brew cask install steam
        #brew cask install dropbox
        brew cask install cooviewer
        brew cask install dolphin openemu
    #    mediahuman
    #    mikutter
    #    snes
    #    grafittipod
    fi

    brew cask cleanup
fi

# cui tools
# Kensho chu
# brew install haxe  # altJs languages.
# brew install sonar # current name is "sonarqube". static source code analyser.

# brew install jenkins
# brew install nodebrew
# brew install mecab
# brew install node redis

brew install wget
brew install platntuml

# program languages.
brew install global
brew install go --cross-compile-common
brew install luajit
brew install ruby
brew install python
brew install opam rlwrap

# terminal apps
brew install git mercurial
brew install z zsh tmux
brew install cmake
brew install android ant apktool
brew install the_silver_searcher

brew install sanemat/font/ricty


if [[ $OSTYPE == darwin* ]]; then
    brew install terminal-notifier
    brew install reattach-to-user-namespace

    # macvim
    # 本当は本家版が最新っぽいのでいいがビルドエラーが出るのでフォーク版。
    brew install cscope
    brew install lua
    brew install --HEAD KazuakiM/homebrew-splhack/cmigemo-mk
    brew install --HEAD KazuakiM/homebrew-splhack/ctags-objc-ja
    brew install KazuakiM/homebrew-splhack/macvim-kaoriya --HEAD --with-lua --with-cscope
    brew linkapps
    ln -s /usr/local/opt/macvim/MacVim.app ~/Applications/

    # for hobby
    if [ $OSX_PRIVATE ]; then
        echo "nothing to do."
    fi

else
    brew install ctags
    brew install vim --with-lua --with-luajit
fi

brew cleanup


