

# ------------------------------------------------------------------------------
# function
# ------------------------------------------------------------------------------


install_mac_package() {

    brew ls --versions $1 &>/dev/null

    if [ $? = 1 ]; then
        brew install $1
    fi

}


install_python_package() {

    pip3 freeze | grep $1"==*" &>/dev/null

    if [ $? = 1 ]; then
        sudo pip3 install $1
    fi

}


# ------------------------------------------------------------------------------
# mac packages: more information on https://formulae.brew.sh/formula/
# ------------------------------------------------------------------------------


echo "Checking mac packages..."


# homebrew
if ! hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# git
install_mac_package git

# docker
install_mac_package docker

# tmux
install_mac_package tmux

# vim
install_mac_package vim

# coreutils
install_mac_package coreutils

# wget
install_mac_package wget

# unrar
install_mac_package unrar

# 7z
install_mac_package p7zip

# python3
install_mac_package python3
