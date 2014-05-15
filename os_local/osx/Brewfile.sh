
# 
brew update

# terminal apps
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

brew cleanup

# cask
brew tap caskroom/homebrew-cask
brew install brew-cask
brew cask update

brew cask install google-chrome
brew cask install iterm2
brew cask install xtrafinder
brew cask install dash
brew cask install android-file-transfer
brew cask install android-studio
brew cask install atom
brew cask install sourcetree
brew cask install genymotion
brew cask install sequel-pro
brew cask install cheatsheet

# for toy
brew cask install virtualbox
brew cask install synergy
brew cask install xbox360-controller-driver

brew cask cleanup
