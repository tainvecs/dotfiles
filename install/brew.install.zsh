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
if [[ ${DOTFILES_APPS["alt-tab"]} = "true" ]]; then
    brew install alt-tab
fi

# autoenv
if [[ ${DOTFILES_APPS["autoenv"]} = "true" ]]; then
    brew install autoenv
fi

# aws
if [[ ${DOTFILES_APPS["aws"]} = "true" ]]; then
    brew install awscli
fi

# clojure
if [[ ${DOTFILES_APPS["clojure"]} = "true" ]]; then
    brew install clojure/tools/clojure
fi

# coreutils, wget, and curl
brew install coreutils wget curl

# docker
if [[ ${DOTFILES_APPS["docker"]} = "true" ]]; then
    brew install --cask docker
fi

# elasticsearch
if [[ ${DOTFILES_APPS["elasticsearch"]} = "true" ]]; then
    brew tap elastic/tap
    brew install elastic/tap/elasticsearch-full
    # sudo brew services start elasticsearch-full
fi

# emacs
if [[ ${DOTFILES_APPS["emacs"]} = "true" ]]; then
    brew install --cask emacs
fi

# gcp
if [[ ${DOTFILES_APPS["gcp"]} = "true" ]]; then
    # brew install --cask google-cloud-sdk
    GCP_HOME="$DOTFILES_HOME/.gcp"
    GCP_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/gcp"
    export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

    curl https://sdk.cloud.google.com > "$GCP_HOME/install.sh"
    bash "$GCP_HOME/install.sh" --disable-prompts --install-dir=$GCP_HOME
fi

# golang
if [[ ${DOTFILES_APPS["golang"]} = "true" ]]; then
    brew install go
fi

# htop
if [[ ${DOTFILES_APPS["htop"]} = "true" ]]; then
    brew install htop
fi

# iterm
if [[ ${DOTFILES_APPS["iterm"]} = "true" ]]; then
    brew install --cask iterm2
fi

# jdk
if [[ ${DOTFILES_APPS["jdk"]} = "true" ]]; then
    # brew install --cask oracle-jdk
    brew install openjdk
fi

# kube
if [[ ${DOTFILES_APPS["kube"]} = "true" ]]; then
    brew install kubectl
fi

# openvpn
if [[ ${DOTFILES_APPS["openvpn"]} = "true" ]]; then
    brew install openvpn
    # sudo brew services start openvpn
fi

# p7zip
brew install unzip
if [[ ${DOTFILES_APPS["7z"]} = "true" ]]; then
    brew install p7zip
fi

# peco
if [[ ${DOTFILES_APPS["peco"]} = "true" ]]; then
    brew install peco
fi

# python
if [[ ${DOTFILES_APPS["python"]} = "true" ]]; then
    # brew install python
fi

# pyenv
if [[ ${DOTFILES_APPS["pyenv"]} = "true" ]]; then
    brew install openssl readline sqlite3 xz zlib
    brew install pyenv
    brew install pyenv-virtualenv
fi

# svn
if [[ ${DOTFILES_APPS["svn"]} = "true" ]]; then
    brew install subversion
fi

# tmux
if [[ ${DOTFILES_APPS["tmux"]} = "true" ]]; then
    brew install tmux
fi

# tree
if [[ ${DOTFILES_APPS["tree"]} = "true" ]]; then
    brew install tree
fi

# vim
if [[ ${DOTFILES_APPS["vim"]} = "true" ]]; then
    brew install vim
fi

# volta
if [[ ${DOTFILES_APPS["volta"]} = "true" ]]; then
    export VOLTA_HOME="$DOTFILES_HOME/.volta"
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

# watch
if [[ ${DOTFILES_APPS["watch"]} = "true" ]]; then
    brew install watch
fi
