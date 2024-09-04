#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT=${DOTFILES_ROOT_DIR:-"$HOME/dotfiles"}
DOTFILES_ZSHENV_PATH="$DOTFILES_ROOT/config/zsh/.zshenv"


# ------------------------------------------------------------------------------
# dotfiles repo
# ------------------------------------------------------------------------------


# clone dotfiles to home directory
git clone https://github.com/tainvecs/dotfiles.git $DOTFILES_ROOT


# ------------------------------------------------------------------------------
# dotfiles zsh environment variables
# ------------------------------------------------------------------------------


# update DOTFILES[ROOT_DIR] with DOTFILES_ROOT in dotfiles zshenv
sed -ir "s#^DOTFILES\[ROOT_DIR\].*#DOTFILES\[ROOT_DIR\]=$DOTFILES_ROOT#" $DOTFILES_ZSHENV_PATH

# source dotfiles zsh environment variables
echo "source $DOTFILES_ZSHENV_PATH" >> ~/.zshenv


# ------------------------------------------------------------------------------
# dotfiles bootstrap script
# ------------------------------------------------------------------------------


# run bootstrap script
# The bootstrap script will go through the "prerequisite installation",
# "resources download", "home and config setup", "application installation",
# "vim and emacs setup", and "plugin installation".
cd $DOTFILES_ROOT && zsh ./scripts/bootstrap.zsh
