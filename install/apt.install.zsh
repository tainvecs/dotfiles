DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"

export DEBIAN_FRONTEND=noninteractive

# sudo
if type sudo >/dev/null; then

    sudo apt update

    # install php
    sudo apt install -y php

    # time zone and locales
    sudo apt install -y tzdata locales

else

    apt update

    # install php
    apt install -y php

    # time zone and locales
    apt install -y tzdata locales

    # install sudo
    apt install -y sudo

fi

# install man
sudo apt install -y man-db

# fundamental
sudo apt install -y curl wget
sudo apt install -y ca-certificates
sudo apt install -y gnupg
sudo apt install -y lsb-release
sudo apt install -y apt-transport-https
sudo apt install -y dialog

# git
sudo apt install -y git

# svn
sudo apt install -y subversion

# c language
sudo apt install -y gcc

# java
sudo apt install -y default-jdk

# clojure
sudo apt install -y clojure

# python3
sudo apt install -y python3
sudo apt install -y python3-pip python3-dev build-essential
sudo pip3 install --upgrade pip

# golang
# install newer golang version manually
sudo apt install -y golang

# editor
# install newer version of emacs manually
sudo apt install -y less vim emacs

# tmux
sudo apt install -y tmux

# network connection
sudo apt install -y net-tools iputils-ping

# ssh server
sudo apt install -y openssh-server
sudo systemctl enable ssh.service
sudo service ssh start

# denyhosts
sudo apt install -y denyhosts
sudo systemctl enable denyhosts.service
sudo service denyhosts start

# openvpn
sudo apt install -y openvpn easy-rsa

# zip, 7z
sudo apt install -y unzip p7zip-full

# autoenv
AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
git clone https://github.com/hyperupcall/autoenv.git "$AUTOENV_HOME/autoenv.git"

# aws
sudo apt install -y awscli

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update && sudo apt install -y elasticsearch
sudo systemctl enable elasticsearch.service
sudo service elasticsearch start

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# peco
sudo apt install -y peco

# pyenv and pyenv-virtualenv
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
     libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
     libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

PYENV_HOME="$DOTFILES_HOME/.python/.pyenv"
git clone https://github.com/pyenv/pyenv.git "$PYENV_HOME/pyenv.git"
git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_HOME/pyenv.git/plugins/pyenv-virtualenv"

# tree
sudo apt install -y tree

# htop
sudo apt install -y htop

# volta
export VOLTA_HOME="$DOTFILES_HOME/.volta"
curl https://get.volta.sh | bash
