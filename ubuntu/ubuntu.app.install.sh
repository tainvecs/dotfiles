

apt-get update

# install php
export DEBIAN_FRONTEND=noninteractive
apt-get -y install php

# install time zone data
export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata

# install locales
export DEBIAN_FRONTEND=noninteractive
apt-get -y install locales

# check and install sudo
if ! [ -x "$(command -v sudo)" ]; then
    apt-get install sudo;
fi

sudo apt-get -y upgrade

# install man
sudo apt-get -y install man-db
man man >/dev/null
if ! [ $? -eq 0 ]; then
    rm /etc/dpkg/dpkg.cfg.d/excludes;
    dpkg -l | grep ^ii | cut -d' ' -f3 | xargs apt-get install -y --reinstall;
fi

# install ubuntu apps
sudo apt-get -y install curl wget
sudo apt-get -y install net-tools iputils-ping
sudo apt-get -y install git
sudo apt-get -y install tmux
sudo apt-get -y install htop
sudo apt-get -y install dialog
sudo apt-get -y install less vim

# ssh server and deny host
sudo apt-get install -y openssh-server
sudo apt-get install -y denyhosts
sudo systemctl enable denyhosts.service
service denyhosts start

# python3
sudo apt-get -y install python3
sudo apt-get -y install python3-pip python3-dev build-essential
sudo pip3 install --upgrade pip
