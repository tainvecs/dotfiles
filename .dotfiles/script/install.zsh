#!/bin/zsh


# ------------------------------------------------------------------------------
#
# dotfiles
#
# - description
#   - locate dotfiles root directory
#   - link dotfiles root dir and dotfiles .zshenv path with ~/.zshenv
#
# - environment variables
#   - DOTFILES_ROOT
#     - decide the root directory for dotfiles
#     - default: $HOME/dotfiles
#
# - notes
#   - dotfiles .zshenv
#     - dotfiles/.dotfiles/env/.zshenv
#
# ------------------------------------------------------------------------------


local _dotfiles_root_dir="${DOTFILES_ROOT:-$HOME/dotfiles}"
local _dotfiles_zshenv_file_path="$_dotfiles_root_dir/.dotfiles/env/.zshenv"

# clone dotfiles to root dir
if [[ ! -d $_dotfiles_root_dir ]]; then
    git clone https://github.com/tainvecs/dotfiles.git $_dotfiles_root_dir
else
    echo "error: dotfiles root directory $_dotfiles_root_dir already in use."
    return 1
fi

# link with ~/.zshenv
echo "source $_dotfiles_zshenv_file_path" >> ~/.zshenv

# source for installation
source $_dotfiles_zshenv_file_path
