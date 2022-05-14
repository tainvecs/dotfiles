#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`

# source zshenv
source $DOTFILES_HOME/.zsh/.zshenv


# ------------------------------------------------------------------------------
# install zinit
# ------------------------------------------------------------------------------


ZINIT_HOME="$DOTFILES_ROOT/home/.zsh/.zinit"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/zinit.git"
source $ZINIT_HOME/zinit.git/zinit.zsh


# ------------------------------------------------------------------------------
# source zinit packages
# ------------------------------------------------------------------------------


source $DOTFILES_CONFIG/zsh/.zshrc_plugins.zsh
zsh
