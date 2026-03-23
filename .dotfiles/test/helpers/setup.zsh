#!/bin/zsh
#
# Minimal test environment bootstrap
#
# Sources only pure variable/function definitions with no side effects.
# Requires DOTFILES_ROOT_DIR to be set by the caller.
#

if [[ -z "$DOTFILES_ROOT_DIR" ]]; then
    echo "Error: DOTFILES_ROOT_DIR must be set before sourcing setup.zsh" >&2
    return 1
fi

DOTFILES_DOT_ROOT_DIR="$DOTFILES_ROOT_DIR/.dotfiles"
DOTFILES_DOT_ENV_DIR="$DOTFILES_DOT_ROOT_DIR/env"
DOTFILES_DOT_LIB_DIR="$DOTFILES_DOT_ROOT_DIR/library"

source "$DOTFILES_DOT_ENV_DIR/return_code.env"
source "$DOTFILES_DOT_ENV_DIR/color.env"
source "$DOTFILES_DOT_LIB_DIR/util.zsh"
