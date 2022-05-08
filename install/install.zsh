#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_INSTALL="$DOTFILES_ROOT/install"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# install script for macOS
# ------------------------------------------------------------------------------


if [[ $OS_TYPE = "Darwin" ]]; then


    # ----- download resources
    zsh $DOTFILES_INSTALL/download.zsh


    # ----- resource
    zsh $DOTFILES_INSTALL/resources.install.zsh


    # ----- home
    zsh $DOTFILES_INSTALL/home.build.zsh


    # ----- zsh
    # zshenv
    DOTFILES_ZSH_HOME="$DOTFILES_HOME/.zsh"
    if [[ ! -f "~/.zshenv" ]] && [[ -f "$DOTFILES_ZSH_HOME/.zshenv" ]]; then
        ln -s "$DOTFILES_ZSH_HOME/.zshenv" ~
    else
        echo "Please Link $DOTFILES_ZSHENV_PATH to ~/.zshenv"
        cat dotfiles/config/zsh/.zshenv >> ~/.zshenv
    fi
    source "$DOTFILES_ZSH_HOME/.zshenv"

    # initialize
    if [[ -f "$DOTFILES_ZSH_HOME/.zshrc_initialize.zsh" ]]; then
        source "$DOTFILES_ZSH_HOME/.zshrc_initialize.zsh"
    fi


    # ----- install apps
    zsh $DOTFILES_INSTALL/brew.install.zsh


    # ----- install plugins manager
    zsh $DOTFILES_INSTALL/zinit.install.zsh


    # ----- config and set up
    # config
    if [[ -f "$DOTFILES_ZSH_HOME/.zshrc_apps.zsh" ]]; then
        source "$DOTFILES_ZSH_HOME/.zshrc_apps.zsh"
    fi

    # set up vim
    zsh $DOTFILES_INSTALL/vim.install.zsh

    # set up emacs
    zsh $DOTFILES_INSTALL/emacs.install.zsh


elif [[ $OS_TYPE = "Linux" ]]; then


    # ----- prerequisite
    if type sudo >/dev/null; then
        sudo apt-get update
        sudo apt-get install curl
    else
        apt-get update
        apt-get install curl
    fi


    # ----- download resources
    zsh $DOTFILES_INSTALL/download.zsh


    # ----- resource
    zsh $DOTFILES_INSTALL/resources.install.zsh


    # ----- home
    zsh $DOTFILES_INSTALL/home.build.zsh


    # ----- zsh
    # zshenv
    DOTFILES_ZSH_HOME="$DOTFILES_HOME/.zsh"
    if [[ ! -f "~/.zshenv" ]] && [[ -f "$DOTFILES_ZSH_HOME/.zshenv" ]]; then
        ln -s "$DOTFILES_ZSH_HOME/.zshenv" ~
    else
        echo "Please Link $DOTFILES_ZSHENV_PATH to ~/.zshenv"
        cat dotfiles/config/zsh/.zshenv >> ~/.zshenv
    fi
    source "$DOTFILES_ZSH_HOME/.zshenv"

    # initialize
    if [[ -f "$DOTFILES_ZSH_HOME/.zshrc_initialize.zsh" ]]; then
        source "$DOTFILES_ZSH_HOME/.zshrc_initialize.zsh"
    fi


    # ----- install apps
    zsh $DOTFILES_INSTALL/apt.install.zsh


    # ----- install plugins manager
    zsh $DOTFILES_INSTALL/zinit.install.zsh


    # ----- config and set up
    # config
    if [[ -f "$DOTFILES_ZSH_HOME/.zshrc_apps.zsh" ]]; then
        source "$DOTFILES_ZSH_HOME/.zshrc_apps.zsh"
    fi

    # set up vim
    zsh $DOTFILES_INSTALL/vim.install.zsh

    # set up emacs
    zsh $DOTFILES_INSTALL/emacs.install.zsh


fi
