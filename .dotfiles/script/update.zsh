#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Dotfiles Update Script
#
#
# Version: 0.0.1
# Last Modified: 2026-03-23
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


export DOTFILES_ROOT_DIR="${${${DOTFILES_ROOT_DIR:-$HOME/dotfiles}/#\~/${HOME}}:A}"


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
# Source Environment and Libraries
# ------------------------------------------------------------------------------


# source dotfiles.env
_dotfiles_dot_env_dotfiles_env_path="$DOTFILES_DOT_ENV_DIR/dotfiles.env"
if [[ ! -f "$_dotfiles_dot_env_dotfiles_env_path" ]]; then
    echo "Error: dotfiles dotfiles.env not found at $_dotfiles_dot_env_dotfiles_env_path" >&2
    return 1
fi
source "$_dotfiles_dot_env_dotfiles_env_path"

# source init.zsh
_dotfiles_dot_lib_dot_init_path="$DOTFILES_DOT_LIB_DIR/dotfiles/init.zsh"
if [[ ! -f "$_dotfiles_dot_lib_dot_init_path" ]]; then
    echo "Error: dotfiles init.zsh not found at $_dotfiles_dot_lib_dot_init_path" >&2
    return 1
fi
source "$_dotfiles_dot_lib_dot_init_path"


# ------------------------------------------------------------------------------
# Parse Arguments
# ------------------------------------------------------------------------------


_print_update_usage() {
    echo "Usage: update.zsh [options] [package_name]"
    echo ""
    echo "Options:"
    echo "  --list    List all managed packages"
    echo "  --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  update.zsh           # Update all managed packages"
    echo "  update.zsh bat       # Update a specific package"
    echo "  update.zsh --list    # List managed packages"
}

local _target_package=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --list)
            list_dotfiles_managed_packages
            return 0 ;;
        --help)
            _print_update_usage
            return 0 ;;
        -*)
            echo "Error: Unknown option '$1'" >&2
            _print_update_usage
            return 1 ;;
        *)
            _target_package="$1"
            shift ;;
    esac
done


# ------------------------------------------------------------------------------
# Update Packages
# ------------------------------------------------------------------------------


if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be updated." "warn"
elif [[ -n "$_target_package" ]]; then
    update_dotfiles_package "$_target_package"
else
    update_all_dotfiles_packages
fi
