DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# homebrew
if ! type brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update
xcode-select --install

# alt-tab
brew install alt-tab

# autoenv
brew install autoenv

# aws
brew install awscli

# clojure
brew install clojure/tools/clojure

# coreutils, wget, and curl
brew install coreutils wget curl

# docker
brew install --cask docker

# elasticsearch
brew tap elastic/tap
brew install elastic/tap/elasticsearch-full
# sudo brew services start elasticsearch-full

# emacs
brew install --cask emacs

# gcp
# brew install --cask google-cloud-sdk

# golang
brew install go

# htop
brew install htop

# iterm2
brew install --cask iterm2

# jdk
# brew install --cask oracle-jdk
brew install openjdk

# kubectl
brew install kubectl

# openvpn
brew install openvpn
# sudo brew services start openvpn

# p7zip
brew install p7zip

# peco
brew install peco

# pyenv
brew install openssl readline sqlite3 xz zlib
brew install pyenv
brew install pyenv-virtualenv

# python
# brew install python

# svn
brew install subversion

# tmux
brew install tmux

# tree
brew install tree

# vim
brew install vim

# volta
export VOLTA_HOME="$DOTFILES_HOME/.volta"
curl https://get.volta.sh | bash

# watch
brew install watch
