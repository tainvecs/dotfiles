#!/bin/zsh


# ------------------------------------------------------------------------------
#
# directories
#
# - description
#   - setup directories for dotfiles
#
# - dependency
#   - env
#     - dotfiles/.dotfiles/env/.dotfiles.env
#
# - notes
#
#   - dotfiles
#     - home
#
#   - user
#     - config
#     - secret
#     - completion
#     - history
#     - local
#
#   - XDG
#     - config
#     - .cache
#     - .state
#     - .share
#     - .tmp
#
# ------------------------------------------------------------------------------


# dotfiles
[[ -d $DOTFILES_HOME_DIR ]] || mkdir -p $DOTFILES_HOME_DIR

# user
[[ -d $DOTFILES_CONFIG_DIR ]] || mkdir -p $DOTFILES_CONFIG_DIR
[[ -d $DOTFILES_SECRET_DIR ]] || mkdir -p $DOTFILES_SECRET_DIR
[[ -d $DOTFILES_COMP_DIR   ]] || mkdir -p $DOTFILES_COMP_DIR
[[ -d $DOTFILES_HIST_DIR ]] || mkdir -p $DOTFILES_HIST_DIR
[[ -d $DOTFILES_LOCAL_DIR  ]] || mkdir -p $DOTFILES_LOCAL_DIR

# XDG
[[ -d $XDG_CONFIG_HOME ]] || mkdir -p $XDG_CONFIG_HOME
[[ -d $XDG_CACHE_HOME  ]] || mkdir -p $XDG_CACHE_HOME
[[ -d $XDG_STATE_HOME  ]] || mkdir -p $XDG_STATE_HOME
[[ -d $XDG_DATA_HOME   ]] || mkdir -p $XDG_DATA_HOME
[[ -d $XDG_RUNTIME_DIR ]] || mkdir -p $XDG_RUNTIME_DIR
