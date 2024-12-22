#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_SCRIPTS="$DOTFILES_ROOT/scripts"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# prerequisite for install script
# ------------------------------------------------------------------------------


if [[ $OS_TYPE = "Darwin" ]]; then   # macos: xcode-select, homebrew, unzip and curl

    # xcode-select
    xcode-select --install

    # rosetta
    softwareupdate --install-rosetta --agree-to-license

    # homebrew
    if ! type brew >/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
    brew update

    # curl and unzip
    brew install unzip curl

elif [[ $OS_TYPE = "Linux" ]]; then  # linux: apt-get, unzip and curl

    # curl and unzip
    if type sudo >/dev/null; then
        sudo apt-get update
        sudo apt-get install -y unzip curl
    else
        apt-get update
        apt-get install -y unzip curl
    fi

fi
