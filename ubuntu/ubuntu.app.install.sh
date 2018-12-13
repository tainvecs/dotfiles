
#!bin/bash


export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install php

if ! [ -x "$(command -v sudo)" ]; then
    apt-get install sudo;
fi

sudo apt-get -y upgrade

sudo apt-get -y install man-db
man man >/dev/null
if ! [ $? -eq 0 ]; then
    rm /etc/dpkg/dpkg.cfg.d/excludes;
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall;
fi

sudo apt-get -y install ssh
sudo apt-get -y install curl wget
sudo apt-get -y install git
sudo apt-get -y install tmux
sudo apt-get -y install htop
sudo apt-get -y install dialog
sudo apt-get -y install locales
sudo apt-get -y install less vim
sudo apt-get -y install python3
sudo apt-get -y install python3-pip python3-dev build-essential
sudo pip3 install --upgrade pip
sudo pip3 install virtualenv
sudo pip3 install numpy matplotlib scipy pandas
sudo pip3 install beautifulsoup4
sudo pip3 install ipython jupyter

#sudo apt-get -y install lsb-release lsb-core

#rm -r /var/lib/apt/lists/*
