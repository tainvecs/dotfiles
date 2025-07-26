#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Dotfiles Installation Script
#
#
# Version: 0.0.2
# Last Modified: 2025-07-03
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Ensure Zsh
# ------------------------------------------------------------------------------


# Ensure we're running in zsh
[[ -n "$ZSH_VERSION" ]] || { echo "This script requires zsh" >&2; exit 1; }


# ------------------------------------------------------------------------------
# DOTFILES_ROOT_DIR
# ------------------------------------------------------------------------------


export DOTFILES_ROOT_DIR="${${DOTFILES_ROOT_DIR:-$HOME/dotfiles}:A}"


# ------------------------------------------------------------------------------
# DOTFILES_DOT_ROOT_DIR, DOTFILES_DOT_ENV_DIR, DOTFILES_DOT_LIB_DIR
# ------------------------------------------------------------------------------


[[ -n "$DOTFILES_DOT_ROOT_DIR" ]] || {
    export DOTFILES_DOT_ROOT_DIR="$DOTFILES_ROOT_DIR/.dotfiles"
}

[[ -n "$DOTFILES_DOT_ENV_DIR" ]] || {
    export DOTFILES_DOT_ENV_DIR="$DOTFILES_DOT_ROOT_DIR/env"
}

[[ -n "$DOTFILES_DOT_LIB_DIR" ]] || {
    export DOTFILES_DOT_LIB_DIR="$DOTFILES_DOT_ROOT_DIR/library"
}


# ------------------------------------------------------------------------------
#
# Install dotfiles
#
# - clone dotfiles to DOTFILES_ROOT_DIR
# - update ~/.zshenv
#   - export DOTFILES_ROOT_DIR
#   - source $DOTFILES_DOT_ENV_DIR/dotfiles.env
# - source $DOTFILES_DOT_ENV_DIR/dotfiles.env
# - source $DOTFILES_DOT_LIB_DIR/dotfiles/init.zsh
# - link dotfiles .zshrc
#
# ------------------------------------------------------------------------------


# git clone or pull dotfiles repo
if [[ -d "$DOTFILES_ROOT_DIR" ]]; then
    echo "Info: Dotfiles directory $DOTFILES_ROOT_DIR already exists. Pulling latest changes..."
    git -C "$DOTFILES_ROOT_DIR" pull
else
    git clone https://github.com/tainvecs/dotfiles.git "$DOTFILES_ROOT_DIR"
fi

# check if ~/.zshenv already set DOTFILES_ROOT_DIR
if ! grep -Fx "export DOTFILES_ROOT_DIR=$DOTFILES_ROOT_DIR" ~/.zshenv > /dev/null; then
    echo "export DOTFILES_ROOT_DIR=$DOTFILES_ROOT_DIR" >> ~/.zshenv
fi

# check if ~/.zshenv already source "$DOTFILES_DOT_ENV_DIR/dotfiles.env"
_dotfiles_dot_env_dotfiles_env_path="$DOTFILES_DOT_ENV_DIR/dotfiles.env"
if [[ ! -f "$_dotfiles_dot_env_dotfiles_env_path" ]]; then
    echo "Error: dotfiles dotfiles.env not found at $_dotfiles_dot_env_dotfiles_env_path" >&2
    return 1
fi
if ! grep -Fx "source $_dotfiles_dot_env_dotfiles_env_path" ~/.zshenv > /dev/null; then
    echo "source $_dotfiles_dot_env_dotfiles_env_path" >> ~/.zshenv
fi
source "$_dotfiles_dot_env_dotfiles_env_path"

# sources the init.zsh file
_dotfiles_dot_lib_dot_init_path="$DOTFILES_DOT_LIB_DIR/dotfiles/init.zsh"
if [[ ! -f "$_dotfiles_dot_lib_dot_init_path" ]]; then
    echo "Error: dotfiles init.zsh not found at $_dotfiles_dot_lib_dot_init_path" >&2
    return 1
fi
source "$_dotfiles_dot_lib_dot_init_path"

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


# ------------------------------------------------------------------------------
# Restart Shell
# ------------------------------------------------------------------------------


exec zsh
