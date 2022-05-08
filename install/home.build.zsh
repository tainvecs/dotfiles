#!/bin/zsh


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_LOCAL="$DOTFILES_ROOT/local"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# ------------------------------------------------------------------------------
# autoenv
# ------------------------------------------------------------------------------


AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
mkdir -p $AUTOENV_HOME
touch $AUTOENV_HOME/.gitkeep


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


# home
AWS_HOME="$DOTFILES_HOME/.aws"
mkdir -p $AWS_HOME
touch $AWS_HOME/.gitkeep

# local
AWS_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/aws/config"
AWS_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/aws/config"
[[ -L $AWS_LOCAL_CONFIG_DST || -f $AWS_LOCAL_CONFIG_DST ]] || ln -s $AWS_LOCAL_CONFIG_SRC $AWS_LOCAL_CONFIG_DST

# config
AWS_CONFIG_SRC="$DOTFILES_CONFIG/aws/config"
AWS_CONFIG_DST="$AWS_HOME/config"
[[ -f $AWS_CONFIG_SRC ]] && [[ ! -f $AWS_CONFIG_DST ]] && ln -s $AWS_CONFIG_SRC $AWS_CONFIG_DST

AWS_CREDENTIAL_SRC="$DOTFILES_CONFIG/aws/credentials"
AWS_CREDENTIAL_DST="$AWS_HOME/credentials"
[[ -f $AWS_CREDENTIAL_SRC ]] && [[ ! -f $AWS_CREDENTIAL_DST ]] && ln -s $AWS_CREDENTIAL_SRC $AWS_CREDENTIAL_DST


# ------------------------------------------------------------------------------
# docker
# ------------------------------------------------------------------------------


DOCKER_HOME="$DOTFILES_HOME/.docker"
mkdir -p $DOCKER_HOME
touch $DOCKER_HOME/.gitkeep

DOCKER_CONFIG_SRC="$DOTFILES_CONFIG/docker/config.json"
DOCKER_CONFIG_DST="$DOCKER_HOME/config.json"
[[ -f $DOCKER_CONFIG_SRC ]] && [[ ! -f $DOCKER_CONFIG_DST ]] && ln -s $DOCKER_CONFIG_SRC $DOCKER_CONFIG_DST

DOCKERD_CONFIG_SRC="$DOTFILES_CONFIG/docker/daemon.json"
DOCKERD_CONFIG_DST="$DOCKER_HOME/daemon.json"
[[ -f $DOCKERD_CONFIG_SRC ]] && [[ ! -f $DOCKERD_CONFIG_DST ]] && ln -s $DOCKERD_CONFIG_SRC $DOCKERD_CONFIG_DST


# ------------------------------------------------------------------------------
# emacs
# ------------------------------------------------------------------------------


# home
EMACS_HOME="$DOTFILES_HOME/.emacs"
mkdir -p "$EMACS_HOME/auto-save-list"
touch $EMACS_HOME/auto-save-list/.gitkeep

# config
EMACS_INIT_SRC="$DOTFILES_CONFIG/emacs/init.el"
EMACS_INIT_DST="$EMACS_HOME/init.el"
[[ -f $EMACS_INIT_SRC ]] && [[ ! -f $EMACS_INIT_DST ]] && ln -s $EMACS_INIT_SRC $EMACS_INIT_DST


# ------------------------------------------------------------------------------
# gcp
# ------------------------------------------------------------------------------


# home
GCP_HOME="$DOTFILES_HOME/.gcp"
mkdir -p $GCP_HOME

# config
GCP_CONFIG_DIR="$DOTFILES_CONFIG/gcp"
mkdir -p $GCP_CONFIG_DIR


# ------------------------------------------------------------------------------
# git: delta
# ------------------------------------------------------------------------------


# local
GIT_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/git/config.local"
GIT_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/git/config.local"
[[ -L $GIT_LOCAL_CONFIG_DST || -f $GIT_LOCAL_CONFIG_DST ]] || ln -s $GIT_LOCAL_CONFIG_SRC $GIT_LOCAL_CONFIG_DST

# config
GIT_THEME_SRC="$DOTFILES_RESOURCES/git/themes.gitconfig"
GIT_THEME_DST="$DOTFILES_CONFIG/git/themes.gitconfig"
[[ -f $GIT_THEME_SRC ]] && [[ ! -f $GIT_THEME_DST ]] && ln -s $GIT_THEME_SRC $GIT_THEME_DST


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


GO_HOME="$DOTFILES_HOME/.go"
mkdir -p "$GO_HOME/gocode" "$GO_HOME/golib"
touch $GO_HOME/gocode/.gitkeep
touch $GO_HOME/golib/.gitkeep


# ------------------------------------------------------------------------------
# kubectl
# ------------------------------------------------------------------------------


# home
KUBE_HOME="$DOTFILES_HOME/.kube"
mkdir -p "$KUBE_HOME/cache"
touch $KUBE_HOME/cache/.gitkeep

# config
KUBE_CONFIG_SRC="$DOTFILES_CONFIG/kube/config"
KUBE_CONFIG_DST="$KUBE_HOME/config"
[[ -f $KUBE_CONFIG_SRC ]] && [[ ! -f $KUBE_CONFIG_DST ]] && ln -s $KUBE_CONFIG_SRC $KUBE_CONFIG_DST


# ------------------------------------------------------------------------------
# less
# ------------------------------------------------------------------------------


LESS_HOME="$DOTFILES_HOME/.less"
mkdir -p $LESS_HOME
touch $LESS_HOME/.gitkeep


# ------------------------------------------------------------------------------
# openvpn
# ------------------------------------------------------------------------------


OPENVPN_HOME="$DOTFILES_HOME/.vpn"
mkdir -p $OPENVPN_HOME
touch $OPENVPN_HOME/.gitkeep


# ------------------------------------------------------------------------------
# p10k
# ------------------------------------------------------------------------------


# local
P10K_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/p10k/.p10k.zsh.local"
P10K_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/p10k/.p10k.zsh.local"
[[ -L $P10K_LOCAL_CONFIG_DST || -f $P10K_LOCAL_CONFIG_DST ]] || ln -s $P10K_LOCAL_CONFIG_SRC $P10K_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# python
# ------------------------------------------------------------------------------


# home
PYTHON_HOME="$DOTFILES_HOME/.python"
mkdir -p "$PYTHON_HOME/.ipython" "$PYTHON_HOME/.pyenv/shims" "$PYTHON_HOME/nltk_data"

touch $PYTHON_HOME/.ipython/.gitkeep
touch $PYTHON_HOME/.pyenv/shims/.gitkeep
touch $PYTHON_HOME/nltk_data/.gitkeep

# config
PYTHON_CONFIG_SRC="$DOTFILES_CONFIG/python/.pythonrc"
PYTHON_CONFIG_DST="$PYTHON_HOME/.pythonrc"
[[ -f $PYTHON_CONFIG_SRC ]] && [[ ! -f $PYTHON_CONFIG_DST ]] && ln -s $PYTHON_CONFIG_SRC $PYTHON_CONFIG_DST


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


# home
SSH_HOME="$DOTFILES_HOME/.ssh"
mkdir -p "$SSH_HOME/ssh_keys"
touch $SSH_HOME/authorized_keys $SSH_HOME/ssh_keys/.gitkeep

# local
SSH_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/ssh/config"
SSH_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/ssh/config"
[[ -L $SSH_LOCAL_CONFIG_DST || -f $SSH_LOCAL_CONFIG_DST ]] || ln -s $SSH_LOCAL_CONFIG_SRC $SSH_LOCAL_CONFIG_DST

# config
SSH_CONFIG_SRC="$DOTFILES_CONFIG/ssh/config"
SSH_CONFIG_DST="$SSH_HOME/config"
[[ -f $SSH_CONFIG_SRC ]] && [[ ! -f $SSH_CONFIG_DST ]] && ln -s $SSH_CONFIG_SRC $SSH_CONFIG_DST

# sshd_config
SSHD_CONFIG_ROOT_SRC="/etc/ssh/sshd_config"
SSHD_CONFIG_SRC="$DOTFILES_CONFIG/ssh/sshd_config"
SSHD_CONFIG_DST="$SSH_HOME/sshd_config"
[[ -f $SSHD_CONFIG_ROOT_SRC ]] && [[ ! -f $SSHD_CONFIG_SRC ]] && ln -s $SSHD_CONFIG_ROOT_SRC $SSHD_CONFIG_SRC
[[ -f $SSHD_CONFIG_SRC ]] && [[ ! -f $SSHD_CONFIG_DST ]] && ln -s $SSHD_CONFIG_SRC $SSHD_CONFIG_DST


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------


# local
TMUX_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/tmux/.tmux.conf.local"
TMUX_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/tmux/.tmux.conf.local"
[[ -L $TMUX_LOCAL_CONFIG_DST || -f $TMUX_LOCAL_CONFIG_DST ]] || ln -s $TMUX_LOCAL_CONFIG_SRC $TMUX_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------


# home
VIM_HOME="$DOTFILES_HOME/.vim"
mkdir -p $VIM_HOME
mkdir -p "$VIM_HOME/.backup" "$VIM_HOME/.swp" "$VIM_HOME/.undo"
mkdir -p "$VIM_HOME/bundle" "$VIM_HOME/colors"
touch $VIM_HOME/.backup/.gitkeep
touch $VIM_HOME/.swp/.gitkeep
touch $VIM_HOME/.undo/.gitkeep
touch $VIM_HOME/bundle/.gitkeep

# local
VIMRC_LOCAL_SRC="$DOTFILES_LOCAL/config/vim/.vimrc.local"
VIMRC_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/vim/.vimrc.local"
VIMRC_LOCAL_HOME_DST="$VIM_HOME/.vimrc.local"
[[ -L $VIMRC_LOCAL_CONFIG_DST || -f $VIMRC_LOCAL_CONFIG_DST ]] || ln -s $VIMRC_LOCAL_SRC $VIMRC_LOCAL_CONFIG_DST
[[ -L $VIMRC_LOCAL_HOME_DST || -f $VIMRC_LOCAL_HOME_DST ]] || ln -s $VIMRC_LOCAL_CONFIG_DST $VIMRC_LOCAL_HOME_DST

# config
VIM_CONFIG_SRC="$DOTFILES_CONFIG/vim/.vimrc"
VIM_CONFIG_DST="$VIM_HOME/.vimrc"
[[ -f $VIM_CONFIG_SRC ]] && [[ ! -f $VIM_CONFIG_DST ]] && ln -s $VIM_CONFIG_SRC $VIM_CONFIG_DST

# resource
VIM_COLORS_SRC="$DOTFILES_RESOURCES/vim/colors"
VIM_COLORS_DST="$VIM_HOME/colors"
[[ -d $VIM_COLORS_SRC ]] && [[ -d $VIM_COLORS_DST ]] && cp $VIM_COLORS_SRC/* $VIM_COLORS_DST


# ------------------------------------------------------------------------------
# volta
# ------------------------------------------------------------------------------


# home
VOLTA_HOME="$DOTFILES_HOME/.volta"
mkdir -p $VOLTA_HOME


# ------------------------------------------------------------------------------
# z
# ------------------------------------------------------------------------------


Z_HOME="$DOTFILES_HOME/.z"
mkdir -p $Z_HOME
touch $Z_HOME/.gitkeep


# ------------------------------------------------------------------------------
# zsh
# ------------------------------------------------------------------------------


# home
ZSH_HOME="$DOTFILES_HOME/.zsh"
mkdir -p "$ZSH_HOME/.zinit" "$ZSH_HOME/.zsh_complete" "$ZSH_HOME/.zsh_sessions"

touch $ZSH_HOME/.zinit/.gitkeep
touch $ZSH_HOME/.zsh_sessions/.gitkeep

# local
ZSHENV_LOCAL_SRC="$DOTFILES_LOCAL/config/zsh/.zshenv.local"
ZSHENV_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/zsh/.zshenv.local"
ZSHENV_LOCAL_HOME_DST="$ZSH_HOME/.zshenv.local"
[[ -L $ZSHENV_LOCAL_CONFIG_DST || -f $ZSHENV_LOCAL_CONFIG_DST ]] || ln -s $ZSHENV_LOCAL_SRC $ZSHENV_LOCAL_CONFIG_DST
[[ -L $ZSHENV_LOCAL_HOME_DST || -f $ZSHENV_LOCAL_HOME_DST ]] || ln -s $ZSHENV_LOCAL_CONFIG_DST $ZSHENV_LOCAL_HOME_DST

ZSHRC_LOCAL_SRC="$DOTFILES_LOCAL/config/zsh/.zshrc.local"
ZSHRC_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/zsh/.zshrc.local"
ZSHRC_LOCAL_HOME_DST="$ZSH_HOME/.zshrc.local"
[[ -L $ZSHRC_LOCAL_CONFIG_DST || -f $ZSHRC_LOCAL_CONFIG_DST ]] || ln -s $ZSHRC_LOCAL_SRC $ZSHRC_LOCAL_CONFIG_DST
[[ -L $ZSHRC_LOCAL_HOME_DST || -f $ZSHRC_LOCAL_HOME_DST ]] || ln -s $ZSHRC_LOCAL_CONFIG_DST $ZSHRC_LOCAL_HOME_DST

# config
ZSHENV_PATH_SRC="$DOTFILES_CONFIG/zsh/.zshenv"
ZSHENV_PATH_DST="$ZSH_HOME/.zshenv"
[[ -f $ZSHENV_PATH_SRC ]] && [[ ! -f $ZSHENV_PATH_DST ]] && ln -s $ZSHENV_PATH_SRC $ZSHENV_PATH_DST

ZSHRC_PATH_SRC="$DOTFILES_CONFIG/zsh/.zshrc"
ZSHRC_PATH_DST="$ZSH_HOME/.zshrc"
[[ -f $ZSHRC_PATH_SRC ]] && [[ ! -f $ZSHRC_PATH_DST ]] && ln -s $ZSHRC_PATH_SRC $ZSHRC_PATH_DST

ZSHRC_INIT_SRC="$DOTFILES_CONFIG/zsh/.zshrc_initialize.zsh"
ZSHRC_INIT_DST="$ZSH_HOME/.zshrc_initialize.zsh"
[[ -f $ZSHRC_INIT_SRC ]] && [[ ! -f $ZSHRC_INIT_DST ]] && ln -s $ZSHRC_INIT_SRC $ZSHRC_INIT_DST

ZSHRC_PLUGINS_SRC="$DOTFILES_CONFIG/zsh/.zshrc_plugins.zsh"
ZSHRC_PLUGINS_DST="$ZSH_HOME/.zshrc_plugins.zsh"
[[ -f $ZSHRC_PLUGINS_SRC ]] && [[ ! -f $ZSHRC_PLUGINS_DST ]] && ln -s $ZSHRC_PLUGINS_SRC $ZSHRC_PLUGINS_DST

ZSHRC_APPS_SRC="$DOTFILES_CONFIG/zsh/.zshrc_apps.zsh"
ZSHRC_APPS_DST="$ZSH_HOME/.zshrc_apps.zsh"
[[ -f $ZSHRC_APPS_SRC ]] && [[ ! -f $ZSHRC_APPS_DST ]] && ln -s $ZSHRC_APPS_SRC $ZSHRC_APPS_DST

ZSHRC_FINAL_SRC="$DOTFILES_CONFIG/zsh/.zshrc_finalize.zsh"
ZSHRC_FINAL_DST="$ZSH_HOME/.zshrc_finalize.zsh"
[[ -f $ZSHRC_FINAL_SRC ]] && [[ ! -f $ZSHRC_FINAL_DST ]] && ln -s $ZSHRC_FINAL_SRC $ZSHRC_FINAL_DST

ZSHRC_COMPLETE_SRC="$DOTFILES_CONFIG/zsh/.zsh_complete"
ZSHRC_COMPLETE_DST="$ZSH_HOME/.zsh_complete"
[[ -d $ZSHRC_COMPLETE_SRC ]] && [[ -d $ZSHRC_COMPLETE_DST ]] && cp $ZSHRC_COMPLETE_SRC/* $ZSHRC_COMPLETE_DST
