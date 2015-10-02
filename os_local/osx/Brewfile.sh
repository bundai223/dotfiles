#
brew update

# cask
# gui tools
if [[ $OSTYPE == darwin* ]]; then
  # brew tap caskroom/versions
  brew tap bundai223/personal

  brew install caskroom/cask/brew-cask
  brew cask update

  caskapp=(
    kobito
    xquartz
    google-chrome
    iterm2
    xtrafinder
    dash
    android-file-transfer
    android-studio
    atom
    sourcetree
    genymotion
    virtualbox
    vagrant
    vlc
    menumeters
    hyperswitch
    appcleaner
    fluid
    platypus
    cd-to
    karabiner
    java
  )

  # for hobby
  if [ $PRIVATE ]; then
    caskapp=(
      "${caskapp}"
      1password
      dropbox
      skype
      xbox360-controller-driver
      blender
      gimp
      inkscape
      minecraft
      steam
      cooviewer
      calibre
      dolphin
      openemu
      aquaskk
    )
    #    mediahuman
    #    mikutter
    #    snes
    #    grafittipod
  fi

  brew cask install --appdir="/Applications" ${caskapp[@]}
  brew cask cleanup
fi

# cui tools
brew install wget coreutils findutils
brew install plantuml

# program languages.
brew install global
# brew install haxe  # altJs languages.
brew install rust
brew install go --cross-compile-common
brew install luajit lua
# brew install ruby
brew install python
brew install opam rlwrap

# terminal apps
brew install git mercurial
brew install z zsh tmux
brew install cmake
# brew install android-sdk android-ndk ant apktool
brew install the_silver_searcher
brew install docker boot2docker
# brew install emacs --cocoa --with-gnutls

brew install sanemat/font/ricty --vim-powerline

if [[ $OSTYPE == darwin* ]]; then
  brew install terminal-notifier
  brew install reattach-to-user-namespace

  # macvim-kaoriya
  brew install cscope
  brew install KazuakiM/macvim/macvim-kaoriya --HEAD --with-lua --with-cscope
  brew linkapps
  ln -s /usr/local/opt/macvim/MacVim.app ~/Applications/

  # for hobby
  if [ $PRIVATE ]; then
    echo "nothing to do."
  fi

else
  brew install ctags
  brew install vim --with-lua --with-luajit
fi

brew cleanup


