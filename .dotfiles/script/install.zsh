#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Install dotfiles
#
# - clone dotfiles to DOTFILES_ROOT_DIR
# - update ~/.zshenv
#
# ------------------------------------------------------------------------------


export DOTFILES_ROOT_DIR="${${DOTFILES_ROOT_DIR:-$HOME/dotfiles}:A}"


# git clone or pull dotfiles repo
if [[ -d "$DOTFILES_ROOT_DIR" ]]; then
    echo "Info: Dotfiles directory $DOTFILES_ROOT_DIR already exists. Pulling latest changes..."
    git -C "$DOTFILES_ROOT_DIR" pull
else
    # git clone https://github.com/tainvecs/dotfiles.git "$DOTFILES_ROOT_DIR"
    git clone -b refactor/dotfiles-v2 https://github.com/tainvecs/dotfiles.git "$DOTFILES_ROOT_DIR"
fi

# check if ~/.zshenv already sources the main.env file, and append and source if not
local _dotfiles_dot_main_env_path="$DOTFILES_ROOT_DIR/.dotfiles/env/main.env"
if [[ ! -f "$_dotfiles_dot_main_env_path" ]]; then
    echo "Error: main.env not found at $_dotfiles_dot_main_env_path"
    return 1
fi
if ! grep -Fx "source $_dotfiles_dot_main_env_path" ~/.zshenv > /dev/null; then
    source "$_dotfiles_dot_main_env_path"
    echo "source $_dotfiles_dot_main_env_path" >> ~/.zshenv
fi


# ------------------------------------------------------------------------------
#
# Init dotfiles
#
# - source library
# - sanity check system name and architecture
# - link .zshrc
#
# ------------------------------------------------------------------------------


# source library
local scripts=(
    "util.zsh"
    "dotfiles/util.zsh"
    "package/install.zsh"
)
for _script in $scripts; do
    local path="$DOTFILES_DOT_LIB_DIR/$_script"
    if [[ ! -f "$path" ]]; then
        echo "Error: $path is not found." >&2
        return $RC_DEPENDENCY_MISSING
    fi
    source "$path" || { echo "error: Failed to source $path" >&2; return $RC_ERROR; }
done

# sanity check system name and architecture
export DOTFILES_SYS_NAME=$(get_system_name)
export DOTFILES_SYS_ARCHT=$(get_system_architecture)

if ! is_supported_system_name; then
    log_message "Unsupported system name $(uname)." "error"
    return $RC_UNSUPPORTED
fi
if ! is_supported_system_archt; then
    log_message "Unsupported system architecture $(uname -m)." "error"
    return $RC_UNSUPPORTED
fi

# link .zshrc from dotfiles config to local config directory
link_dotfiles_dot_config_to_local "zsh" ".zshrc" "zsh" ".zshrc"


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
    xcode-select --install || return $RC_ERROR
    softwareupdate --install-rosetta --agree-to-license || return $RC_ERROR

    # homebrew
    dotfiles_install_homebrew
    dotfiles_init_homebrew || return $RC_ERROR

    # misc
    brew install coreutils cmake wget || return $RC_ERROR

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


# prepare dotfiles package associative array and
# install all managed packages
unset DOTFILES_PACKAGE_ASC_ARR
typeset -A DOTFILES_PACKAGE_ASC_ARR
update_associative_array_from_array "DOTFILES_PACKAGE_ASC_ARR" "DOTFILES_USER_PACKAGE_ARR" "DOTFILES_PACKAGE_ARR"

if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be installed." "warn"
else
    install_all_dotfiles_packages
fi
