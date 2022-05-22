# dotfiles

Setting up the terminal on a computer, including all the configuration, app, and plugin installation, takes a lot of work and effort. Moreover, especially when working on multiple computers, the synchronization of all these setting between these computing instances become an issue.

Project `dotfiles` provides a framework to do all the setups with a bootstrap script `scripts/bootstrap.zsh`.

Besides, docker image `ghcr.io/tainvecs/dotfiles:latest` also provides a test environment for typing out this project with the config templates. 

## Prerequisite
- macOS or Ubuntu
- zsh

## Installation
### Clone dotfiles to Home Directory
```zsh
git clone https://github.com/tainvecs/dotfiles.git ~/dotfiles
```
### Source dotfiles Zsh Environment Variables
Create a symbolic link to dotfiles `.zshenv` at home directory
```zsh
ln -s ~/dotfiles/config/zsh/.zshenv ~/.zshenv
```
Alternatively, source the dotfiles `.zshenv` from your `.zshenv`
```zsh
echo "source ~/dotfiles/config/zsh/.zshenv" >> ~/.zshenv
```
### Run Bootstrap Script
The bootstrap script will go through the **prerequisite installation**, **resources download**, **home and config setup**, **application installation**, **vim and emacs setup**, and **plugin installation**. 
```zsh
cd ~/dotfiles && zsh ./scripts/bootstrap.zsh
```
You can create your local config files in `local/config` by referencing `local/config_template`. 
Alternatively, you can also apply all the templates in `local/config_template` by setting the env `DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES`. 
```zsh
cd ~/dotfiles && env DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES=true zsh ./scripts/bootstrap.zsh
```
