#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# install apps by brew or apt-get
# ------------------------------------------------------------------------------


if [[ $OS_TYPE = "Darwin" ]]; then

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

    # emacs: use d12frosted/emacs-plus
    if [[ ${DOTFILES_APPS["emacs"]} = "true" ]]; then
        brew tap d12frosted/emacs-plus
        brew install emacs-plus
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

    # meilisearch
    if [[ ${DOTFILES_APPS["meilisearch"]} = "true" ]]; then
        brew install meilisearch
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


elif [[ $OS_TYPE = "Linux" ]]; then

    export DEBIAN_FRONTEND=noninteractive

    # sudo
    if type sudo >/dev/null; then

        sudo apt-get update

        # install php
        sudo apt-get install -y php

        # time zone and locales
        sudo apt-get install -y tzdata locales

    else

        apt-get update

        # install php
        apt-get install -y php

        # time zone and locales
        apt-get install -y tzdata locales

        # install sudo
        apt-get install -y sudo

    fi

    # install man
    sudo apt-get install -y man-db

    # fundamental
    sudo apt-get install -y curl wget
    sudo apt-get install -y ca-certificates
    sudo apt-get install -y gnupg
    sudo apt-get install -y lsb-release
    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y dialog

    # git
    sudo apt-get install -y git

    # svn
    if [[ ${DOTFILES_APPS["svn"]} = "true" ]]; then
        sudo apt-get install -y subversion
    fi

    # c language
    sudo apt-get install -y gcc

    # java
    if [[ ${DOTFILES_APPS["jdk"]} = "true" ]]; then
        sudo apt-get install -y default-jdk
    fi

    # clojure
    if [[ ${DOTFILES_APPS["clojure"]} = "true" ]]; then
        sudo apt-get install -y clojure
    fi

    # python3
    if [[ ${DOTFILES_APPS["python"]} = "true" ]]; then
        sudo apt-get install -y python3
        sudo apt-get install -y python3-pip python3-dev build-essential
        sudo pip3 install --upgrade pip
    fi

    # golang
    if [[ ${DOTFILES_APPS["golang"]} = "true" ]]; then
        # install newer golang version manually
        sudo apt-get install -y golang
    fi

    # less
    sudo apt-get install -y less

    # emacs
    if [[ ${DOTFILES_APPS["emacs"]} = "true" ]]; then
        sudo apt-get install -y emacs
    fi

    # vim
    if [[ ${DOTFILES_APPS["vim"]} = "true" ]]; then
        sudo apt-get install -y vim
    fi

    # network connection
    sudo apt-get install -y net-tools iputils-ping

    # ssh server
    sudo apt-get install -y openssh-server
    sudo systemctl enable ssh.service
    sudo service ssh start

    # openvpn
    if [[ ${DOTFILES_APPS["openvpn"]} = "true" ]]; then
        sudo apt-get install -y openvpn easy-rsa
    fi

    # autoenv
    if [[ ${DOTFILES_APPS["autoenv"]} = "true" ]]; then
        AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
        git clone https://github.com/hyperupcall/autoenv.git "$AUTOENV_HOME/autoenv.git"
    fi

    # aws
    if [[ ${DOTFILES_APPS["aws"]} = "true" ]]; then
        sudo apt-get install -y awscli
    fi

    # htop
    if [[ ${DOTFILES_APPS["htop"]} = "true" ]]; then
        sudo apt-get install -y htop
    fi

    # gcp
    if [[ ${DOTFILES_APPS["gcp"]} = "true" ]]; then
        GCP_HOME="$DOTFILES_HOME/.gcp"
        GCP_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/gcp"
        export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

        curl https://sdk.cloud.google.com > "$GCP_HOME/install.sh"
        bash "$GCP_HOME/install.sh" --disable-prompts --install-dir=$GCP_HOME
    fi

    # docker
    if [[ ${DOTFILES_APPS["docker"]} = "true" ]]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    fi

    # elasticsearch
    if [[ ${DOTFILES_APPS["elasticsearch"]} = "true" ]]; then
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
        sudo apt-get update && sudo apt-get install -y elasticsearch
        sudo systemctl enable elasticsearch.service
        # sudo service elasticsearch start
    fi

    # meilisearch
    if [[ ${DOTFILES_APPS["meilisearch"]} = "true" ]]; then
        sudo echo "deb [trusted=yes] https://apt.fury.io/meilisearch/ /" > /etc/apt/sources.list.d/fury.list
        sudo apt-get update && sudo apt-get install -y meilisearch-http
    fi

    # kubectl
    if [[ ${DOTFILES_APPS["kube"]} = "true" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi

    # peco
    if [[ ${DOTFILES_APPS["peco"]} = "true" ]]; then
        sudo apt-get install -y peco
    fi

    # pyenv and pyenv-virtualenv
    if [[ ${DOTFILES_APPS["pyenv"]} = "true" ]]; then
        sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
             libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
             libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

        PYENV_HOME="$DOTFILES_HOME/.python/.pyenv"
        git clone https://github.com/pyenv/pyenv.git "$PYENV_HOME/pyenv.git"
        git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_HOME/pyenv.git/plugins/pyenv-virtualenv"
    fi

    # tmux
    if [[ ${DOTFILES_APPS["tmux"]} = "true" ]]; then
        sudo apt-get install -y tmux
    fi

    # tree
    if [[ ${DOTFILES_APPS["tree"]} = "true" ]]; then
        sudo apt-get install -y tree
    fi

    # unzip, 7z
    sudo apt-get install -y unzip

    if [[ ${DOTFILES_APPS["7z"]} = "true" ]]; then
        sudo apt-get install -y p7zip-full
    fi

    # volta
    if [[ ${DOTFILES_APPS["volta"]} = "true" ]]; then
        export VOLTA_HOME="$DOTFILES_HOME/.volta"
        curl https://get.volta.sh | bash -s -- --skip-setup
    fi

fi
