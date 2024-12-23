#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_SCRIPTS="$DOTFILES_ROOT/scripts"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"


# ------------------------------------------------------------------------------
# install script for macOS or Ubuntu
# ------------------------------------------------------------------------------


# install prerequisite for macOS or Ubuntu
zsh $DOTFILES_SCRIPTS/prerequisite.install.zsh

# download and locate resource files
zsh $DOTFILES_SCRIPTS/resources.download.zsh

# apply config local templates
zsh $DOTFILES_SCRIPTS/config.build.zsh

# build home directory, and link configs and local configs to home directory
zsh $DOTFILES_SCRIPTS/home.build.zsh

# initialize zsh by sourcing .zshenv and .zshrc_initialize.zsh
DOTFILES_ZSH_HOME="$DOTFILES_HOME/.zsh"
source "$DOTFILES_ZSH_HOME/.zshenv"
source "$DOTFILES_ZSH_HOME/.zshrc_initialize.zsh"

# install apps using brew or apt-get
zsh $DOTFILES_SCRIPTS/apps.install.zsh
source "$DOTFILES_ZSH_HOME/.zshrc_apps.zsh"

# set up vim
type vim >"/dev/null" && zsh $DOTFILES_SCRIPTS/vim.setup.zsh

# set up emacs
type emacs >"/dev/null" && zsh $DOTFILES_SCRIPTS/emacs.setup.zsh

# install plugins by zinit plugin manager
zsh $DOTFILES_SCRIPTS/plugins.install.zsh
