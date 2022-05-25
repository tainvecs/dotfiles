#!/bin/zsh

# clone dotfiles to home directory
git clone https://github.com/tainvecs/dotfiles.git ~/dotfiles

# source dotfiles zsh environment variables
echo "source ~/dotfiles/config/zsh/.zshenv" >> ~/.zshenv

# run bootstrap script
# The bootstrap script will go through the "prerequisite installation",
# "resources download", "home and config setup", "application installation",
# "vim and emacs setup", and "plugin installation".
cd ~/dotfiles && zsh ./scripts/bootstrap.zsh
