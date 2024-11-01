#!/bin/zsh


# ------------------------------------------------------------------------------
# init params and source libs
# ------------------------------------------------------------------------------


# dotfiles
DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_LIB="$DOTFILES_ROOT/library"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# lib and envs
source "$DOTFILES_LIB/apps.zsh"

if [[ -z $SYS_NAME || -z $SYS_ARCHT ]]; then

    source "$DOTFILES_LIB/sys.zsh"

    SYS_NAME=`get_system_architecture`
    SYS_ARCHT=`get_system_name`
fi


# ------------------------------------------------------------------------------
# install apps by brew or apt-get
# ------------------------------------------------------------------------------


if [[ $SYS_NAME = "mac" ]]; then

    # alt-tab
    if [[ ${DOTFILES_APPS[alt-tab]} = "true" ]]; then
        brew install alt-tab
    fi

    # autoenv
    if [[ ${DOTFILES_APPS[autoenv]} = "true" ]]; then
        brew install autoenv
    fi

    # aws
    if [[ ${DOTFILES_APPS[aws]} = "true" ]]; then
        brew install awscli
    fi

    # clojure
    if [[ ${DOTFILES_APPS[clojure]} = "true" ]]; then
        brew install clojure/tools/clojure
    fi

    # coreutils, wget, and curl
    brew install coreutils wget curl

    # docker
    if [[ ${DOTFILES_APPS[docker]} = "true" ]]; then
        brew install --cask docker
    fi

    # elasticsearch
    if [[ ${DOTFILES_APPS[elasticsearch]} = "true" ]]; then
        brew tap elastic/tap
        brew install elastic/tap/elasticsearch-full
        # sudo brew services start elasticsearch-full
    fi

    # emacs: use d12frosted/emacs-plus
    if [[ ${DOTFILES_APPS[emacs]} = "true" ]]; then
        brew tap d12frosted/emacs-plus
        brew install emacs-plus
    fi

    # gcp
    if [[ ${DOTFILES_APPS[gcp]} = "true" ]] && \
       ! { type gcloud >"/dev/null" }
    then

        echo_app_installation_message 'gcp' 'start'

        # home
        GCP_HOME="$DOTFILES_HOME/.gcp"
        [[ -d $GCP_HOME ]] || mkdir -p $GCP_HOME

        # config
        GCP_CONFIG_DIR="$DOTFILES_CONFIG/gcp"
        [[ -d $GCP_CONFIG_DIR ]] || mkdir -p $GCP_CONFIG_DIR
        export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

        # install
        # brew install --cask google-cloud-sdk
        curl -fL https://sdk.cloud.google.com > "$GCP_HOME/install.sh"
        bash "$GCP_HOME/install.sh" --disable-prompts --install-dir=$GCP_HOME

    else
        echo_app_installation_message 'gcp' 'skip'
    fi

    # golang
    if [[ ${DOTFILES_APPS[golang]} = "true" ]]; then
        brew install go
    fi

    # htop
    if [[ ${DOTFILES_APPS[htop]} = "true" ]]; then
        brew install htop
    fi

    # iterm
    if [[ ${DOTFILES_APPS[iterm]} = "true" ]]; then
        brew install --cask iterm2
    fi

    # jdk
    if [[ ${DOTFILES_APPS[jdk]} = "true" ]]; then
        # brew install --cask oracle-jdk
        brew install openjdk
    fi

    # kube
    if [[ ${DOTFILES_APPS[kube]} = "true" ]]; then
        brew install kubectl
    fi

    # meilisearch
    if [[ ${DOTFILES_APPS[meilisearch]} = "true" ]]; then
        brew install meilisearch
    fi

    # openvpn
    if [[ ${DOTFILES_APPS[openvpn]} = "true" ]]; then
        brew install openvpn
        # sudo brew services start openvpn
    fi

    # p7zip
    brew install unzip
    if [[ ${DOTFILES_APPS[7z]} = "true" ]]; then
        brew install p7zip
    fi

    # peco
    if [[ ${DOTFILES_APPS[peco]} = "true" ]]; then
        brew install peco
    fi

    # python
    if [[ ${DOTFILES_APPS[python]} = "true" ]]; then
        # brew install python
    fi

    # pyenv
    if [[ ${DOTFILES_APPS[pyenv]} = "true" ]]; then
        brew install openssl readline sqlite3 xz zlib
        brew install pyenv
        brew install pyenv-virtualenv
    fi

    # svn
    if [[ ${DOTFILES_APPS[svn]} = "true" ]]; then
        brew install subversion
    fi

    # tmux
    if [[ ${DOTFILES_APPS[tmux]} = "true" ]]; then
        brew install tmux
    fi

    # tree
    if [[ ${DOTFILES_APPS[tree]} = "true" ]]; then
        brew install tree
    fi

    # vim
    if [[ ${DOTFILES_APPS[vim]} = "true" ]]; then
        brew install vim
    fi

    # volta
    if [[ ${DOTFILES_APPS[volta]} = "true" ]] && \
       ! { type volta >"/dev/null" }
    then
        export VOLTA_HOME="$DOTFILES_HOME/.volta"
        curl -fL https://get.volta.sh | bash -s -- --skip-setup
    fi

    # vscode
    if [[ ${DOTFILES_APPS[vscode]} = "true" ]]; then
        brew install --cask visual-studio-code
    fi

    # watch
    if [[ ${DOTFILES_APPS[watch]} = "true" ]]; then
        brew install watch
    fi


elif [[ $SYS_NAME = "linux" ]]; then

    export DEBIAN_FRONTEND=noninteractive

    # sudo
    if type sudo >"/dev/null"; then

        sudo apt-get update

        # install php
        sudo_apt_install php

        # time zone and locales
        sudo_apt_install tzdata locales

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
    sudo_apt_install man-db

    # fundamental
    sudo_apt_install curl wget
    sudo_apt_install ca-certificates
    sudo_apt_install gnupg
    sudo_apt_install lsb-release
    sudo_apt_install apt-transport-https
    sudo_apt_install dialog

    # git
    sudo_apt_install git

    # svn
    if [[ ${DOTFILES_APPS[svn]} = "true" ]]; then
        sudo_apt_install subversion
    fi

    # c language
    sudo_apt_install gcc

    # java
    if [[ ${DOTFILES_APPS[jdk]} = "true" ]]; then
        sudo_apt_install default-jdk
    fi

    # clojure
    if [[ ${DOTFILES_APPS[clojure]} = "true" ]]; then
        sudo_apt_install clojure
    fi

    # python3
    if [[ ${DOTFILES_APPS[python]} = "true" ]] && \
           ! { type python >"/dev/null" } && \
           ! { dpkg -l python3 &>"/dev/null" }
    then
        sudo_apt_install python3
        sudo_apt_install python3-pip python3-dev build-essential
        sudo pip3 install --upgrade pip
    fi

    # golang
    if [[ ${DOTFILES_APPS[golang]} = "true" ]]; then
        sudo_apt_install golang
    fi

    # less
    sudo_apt_install less

    # emacs
    if [[ ${DOTFILES_APPS[emacs]} = "true" ]]; then
        sudo_apt_install emacs
    fi

    # vim
    if [[ ${DOTFILES_APPS[vim]} = "true" ]]; then
        sudo_apt_install vim
    fi

    # network connection
    sudo_apt_install net-tools iputils-ping

    # ssh server
    if ! { dpkg -l openssh-server &>"/dev/null" }; then
        sudo_apt_install openssh-server
        sudo systemctl enable ssh.service
        sudo service ssh start
    fi

    # openvpn
    if [[ ${DOTFILES_APPS[openvpn]} = "true" ]]; then
        sudo_apt_install openvpn easy-rsa
    fi

    # autoenv
    if [[ ${DOTFILES_APPS[autoenv]} = "true" ]]; then

        # home
        AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
        [[ -d $AUTOENV_HOME ]] || mkdir -p $AUTOENV_HOME

        # install
        AUTOENV_GIT_DIR="$AUTOENV_HOME/autoenv.git"
        if [[ ! -d $AUTOENV_GIT_DIR ]]; then
            git clone https://github.com/hyperupcall/autoenv.git $AUTOENV_GIT_DIR
        fi
    fi

    # aws
    if [[ ${DOTFILES_APPS[aws]} = "true" ]]; then

        # home
        AWS_HOME="$DOTFILES_HOME/.aws"
        [[ -d $AWS_HOME ]] || mkdir -p $AWS_HOME

        # check if exist
        if [[ -d "$AWS_HOME/aws" ]]; then

            echo_app_installation_message 'aws' 'skip'

        else

            echo_app_installation_message 'aws' 'start'

            # download installer
            if [[ $SYS_ARCHT = 'arm64' ]]; then
                curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "$AWS_HOME/awscliv2.zip"
            elif [[ $SYS_ARCHT = 'amd64' ]]; then
                curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$AWS_HOME/awscliv2.zip"
            else
                echo "error: 'aws' not installed. Unknown system architecture $SYS_ARCHT"
            fi

            # unzip
            unzip "$AWS_HOME/awscliv2.zip" -d $AWS_HOME && rm "$AWS_HOME/awscliv2.zip"

            # install
            sudo "$AWS_HOME/aws/install"
        fi
    fi

    # htop
    if [[ ${DOTFILES_APPS[htop]} = "true" ]]; then
        sudo_apt_install htop
    fi

    # gcp
    if [[ ${DOTFILES_APPS[gcp]} = "true" ]] && \
       ! { type gcloud >"/dev/null" }
    then

        echo_app_installation_message 'gcp' 'start'

        # home
        GCP_HOME="$DOTFILES_HOME/.gcp"
        [[ -d $GCP_HOME ]] || mkdir -p $GCP_HOME

        # config
        GCP_CONFIG_DIR="$DOTFILES_CONFIG/gcp"
        [[ -d $GCP_CONFIG_DIR ]] || mkdir -p $GCP_CONFIG_DIR
        export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

        # install
        curl -fL https://sdk.cloud.google.com > "$GCP_HOME/install.sh"
        bash "$GCP_HOME/install.sh" --disable-prompts --install-dir=$GCP_HOME

    else
        echo_app_installation_message 'gcp' 'skip'
    fi

    # docker
    if [[ ${DOTFILES_APPS[docker]} = "true" ]] && \
       ! { type docker >"/dev/null" } && \
       ! { dpkg -l docker &>"/dev/null" }
    then

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > "/dev/null"
        sudo apt-get update && sudo_apt_install docker-ce docker-ce-cli containerd.io

    else
        echo_app_installation_message 'docker' 'skip'
    fi

    # elasticsearch
    if [[ ${DOTFILES_APPS[elasticsearch]} = "true" ]] && \
       ! { type elasticsearch >"/dev/null" } && \
       ! { dpkg -l elasticsearch &>"/dev/null" }
    then

        # install
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        sudo_apt_install apt-transport-https
        echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
        sudo apt-get update && sudo_apt_install elasticsearch

        # start
        sudo systemctl enable elasticsearch.service
        # sudo service elasticsearch start
    else
        echo_app_installation_message 'elasticsearch' 'skip'
    fi

    # meilisearch
    if [[ ${DOTFILES_APPS[meilisearch]} = "true" ]] && \
       ! { type meilisearch >"/dev/null" } && \
       ! { dpkg -l meilisearch-http &>"/dev/null" }
    then
        sudo echo "deb [trusted=yes] https://apt.fury.io/meilisearch/ /" > /etc/apt/sources.list.d/fury.list
        sudo apt-get update && sudo_apt_install meilisearch-http
    else
        echo_app_installation_message 'meilisearch' 'skip'
    fi

    # kubectl
    if [[ ${DOTFILES_APPS[kube]} = "true" ]] && \
       ! { type kubectl >"/dev/null" } && \
       ! { dpkg -l kubectl &>"/dev/null" }
    then
        curl -fLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    else
        echo_app_installation_message 'kube' 'skip'
    fi

    # peco
    if [[ ${DOTFILES_APPS[peco]} = "true" ]]; then
        sudo_apt_install peco
    fi

    # pyenv and pyenv-virtualenv
    if [[ ${DOTFILES_APPS[pyenv]} = "true" ]] && \
       ! { type pyenv >"/dev/null" }
    then

        # prerequisite
        sudo_apt_install make build-essential libssl-dev zlib1g-dev \
             libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
             libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

        # home
        PYENV_HOME="$DOTFILES_HOME/.python/.pyenv"
        [[ -d $PYENV_HOME ]] || mkdir -p $PYENV_HOME

        # install
        PYENV_GIT_DIR="$PYENV_HOME/pyenv.git"
        PYENV_VENV_GIT_DIR="$PYENV_HOME/pyenv.git/plugins/pyenv-virtualenv"

        if [[ ! -d $PYENV_GIT_DIR ]]; then
            git clone https://github.com/pyenv/pyenv.git $PYENV_GIT_DIR
        fi
        if [[ ! -d $PYENV_VENV_GIT_DIR ]]; then
            git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_VENV_GIT_DIR
        fi
    fi

    # tmux
    if [[ ${DOTFILES_APPS[tmux]} = "true" ]]; then
        sudo_apt_install tmux
    fi

    # tree
    if [[ ${DOTFILES_APPS[tree]} = "true" ]]; then
        sudo_apt_install tree
    fi

    # unzip, 7z
    sudo_apt_install unzip

    if [[ ${DOTFILES_APPS[7z]} = "true" ]]; then
        sudo_apt_install p7zip-full
    fi

    # volta
    if [[ ${DOTFILES_APPS[volta]} = "true" ]] && \
       ! { type volta >"/dev/null" }
    then
        export VOLTA_HOME="$DOTFILES_HOME/.volta"
        curl https://get.volta.sh | bash -s -- --skip-setup
    else
        echo_app_installation_message 'volta' 'skip'
    fi

    # vscode
    # reference: https://code.visualstudio.com/docs/setup/linux
    if [[ ${DOTFILES_APPS[vscode]} = "true" ]] && \
       ! { type code >"/dev/null" }
    then

        # prerequisite
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg

        # install
        sudo_apt_install apt-transport-https
        sudo apt update
        sudo_apt_install code
    else
        echo_app_installation_message 'vscode' 'skip'
    fi

fi
