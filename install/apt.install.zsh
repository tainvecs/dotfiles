DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"

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
sudo apt-get install -y subversion

# c language
sudo apt-get install -y gcc

# java
sudo apt-get install -y default-jdk

# clojure
sudo apt-get install -y clojure

# python3
sudo apt-get install -y python3
sudo apt-get install -y python3-pip python3-dev build-essential
sudo pip3 install --upgrade pip

# golang
# install newer golang version manually
sudo apt-get install -y golang

# editor
# install newer version of emacs manually
sudo apt-get install -y less vim emacs

# tmux
sudo apt-get install -y tmux

# network connection
sudo apt-get install -y net-tools iputils-ping

# ssh server
sudo apt-get install -y openssh-server
sudo systemctl enable ssh.service
sudo service ssh start

# openvpn
sudo apt-get install -y openvpn easy-rsa

# zip, 7z
sudo apt-get install -y unzip p7zip-full

# autoenv
AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
git clone https://github.com/hyperupcall/autoenv.git "$AUTOENV_HOME/autoenv.git"

# aws
sudo apt-get install -y awscli

# gcp
GCP_HOME="$DOTFILES_HOME/.gcp"
GCP_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/gcp"
export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

curl https://sdk.cloud.google.com > "$GCP_HOME/install.sh"
bash "$GCP_HOME/install.sh" --disable-prompts --install-dir=$GCP_HOME

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install -y elasticsearch
sudo systemctl enable elasticsearch.service
sudo service elasticsearch start

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# peco
sudo apt-get install -y peco

# pyenv and pyenv-virtualenv
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
     libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
     libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

PYENV_HOME="$DOTFILES_HOME/.python/.pyenv"
git clone https://github.com/pyenv/pyenv.git "$PYENV_HOME/pyenv.git"
git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_HOME/pyenv.git/plugins/pyenv-virtualenv"

# tree
sudo apt-get install -y tree

# htop
sudo apt-get install -y htop

# volta
export VOLTA_HOME="$DOTFILES_HOME/.volta"
curl https://get.volta.sh | bash
