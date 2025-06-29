#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Dotfiles Installation Script
#
#
# Version: 0.0.1
# Last Modified: 2025-06-29
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# DOTFILES_ROOT_DIR
# ------------------------------------------------------------------------------


export DOTFILES_ROOT_DIR="${${DOTFILES_ROOT_DIR:-$HOME/dotfiles}:A}"


# ------------------------------------------------------------------------------
#
# Install dotfiles
#
# - clone dotfiles to DOTFILES_ROOT_DIR
# - update ~/.zshenv
#
# ------------------------------------------------------------------------------


# git clone or pull dotfiles repo
if [[ -d "$DOTFILES_ROOT_DIR" ]]; then
    echo "Info: Dotfiles directory $DOTFILES_ROOT_DIR already exists. Pulling latest changes..."
    git -C "$DOTFILES_ROOT_DIR" pull
else
    # git clone https://github.com/tainvecs/dotfiles.git "$DOTFILES_ROOT_DIR"
    git clone -b refactor/dotfiles-v2 https://github.com/tainvecs/dotfiles.git "$DOTFILES_ROOT_DIR"
fi

# check if ~/.zshenv already set DOTFILES_ROOT_DIR
if ! grep -Fx "export DOTFILES_ROOT_DIR=$DOTFILES_ROOT_DIR" ~/.zshenv > /dev/null; then
    echo "export DOTFILES_ROOT_DIR=$DOTFILES_ROOT_DIR" >> ~/.zshenv
fi

# check if ~/.zshenv already sources the init.zsh file, and append and source if not
_dotfiles_init_script_path="$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/init.zsh"
if [[ ! -f "$_dotfiles_init_script_path" ]]; then
    echo "Error: dotfiles init.zsh not found at $_dotfiles_init_script_path"
    return 1
fi
if ! grep -Fx "source $_dotfiles_init_script_path" ~/.zshenv > /dev/null; then
    echo "source $_dotfiles_init_script_path" >> ~/.zshenv
fi
source "$_dotfiles_init_script_path"

# link .zshrc from dotfiles config to local config directory
_dotfiles_zshrc_path=$(link_dotfiles_dot_config_to_local "zsh" ".zshrc" "zsh" ".zshrc") || return $RC_ERROR
log_message "dotfiles .zshrc is linked at $_dotfiles_zshrc_path" "info"


# ------------------------------------------------------------------------------
#
# Install Prerequisites
#
# - macOS
#   - coreutils
#   - cmake
#   - homebrew
#   - rosetta
#   - wget
#   - xcode-select (clang, git, make)
#   - zinit
#
# - Ubuntu
#   - cmake
#   - curl
#   - dialog
#   - php
#   - unzip
#   - wget
#   - zinit
#
#   - built-in
#     - apt-transport-https
#     - ca-certificates
#     - gnupg
#     - locales
#     - lsb-release
#     - man-db
#     - tzdata
#
# ------------------------------------------------------------------------------


# install prerequisite for macOS and Ubuntu
if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

    # xcode-select and rosetta
    xcode-select --install
    softwareupdate --install-rosetta --agree-to-license

    # homebrew
    dotfiles_install_homebrew
    dotfiles_init_homebrew || return $RC_ERROR

    # misc
    brew install cmake coreutils wget || return $RC_ERROR

elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

    export DEBIAN_FRONTEND=noninteractive

    if command_exists sudo; then
        sudo apt-get update
        sudo apt-get install --no-install-recommends -y \
             php tzdata locales \
             cmake curl dialog unzip wget \
             ca-certificates gnupg lsb-release apt-transport-https \
             man-db || return $RC_ERROR
    else
        apt-get update
        apt-get install --no-install-recommends -y \
                php tzdata locales \
                cmake curl dialog unzip wget \
                ca-certificates gnupg lsb-release apt-transport-https \
                man-db || return $RC_ERROR
        apt-get install sudo
    fi
fi

# zinit
dotfiles_install_zinit
dotfiles_init_zinit || return $RC_ERROR


# ------------------------------------------------------------------------------
# Install Packages
# ------------------------------------------------------------------------------


# install all managed packages
if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be installed." "warn"
else
    install_all_dotfiles_packages
fi
