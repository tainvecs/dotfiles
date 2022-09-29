#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_LOCAL="$DOTFILES_ROOT/local"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# ------------------------------------------------------------------------------
# autoenv
# ------------------------------------------------------------------------------


# home
AUTOENV_HOME="$DOTFILES_HOME/.autoenv"
mkdir -p $AUTOENV_HOME


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


# home
AWS_HOME="$DOTFILES_HOME/.aws"
mkdir -p $AWS_HOME


# ------------------------------------------------------------------------------
# docker
# ------------------------------------------------------------------------------


# home
DOCKER_HOME="$DOTFILES_HOME/.docker"
mkdir -p $DOCKER_HOME


# ------------------------------------------------------------------------------
# emacs
# ------------------------------------------------------------------------------


# home
EMACS_HOME="$DOTFILES_HOME/.emacs"
mkdir -p "$EMACS_HOME/auto-save-list"


# ------------------------------------------------------------------------------
# gcp
# ------------------------------------------------------------------------------


# home
GCP_HOME="$DOTFILES_HOME/.gcp"
mkdir -p $GCP_HOME


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


# home
GO_HOME="$DOTFILES_HOME/.go"
mkdir -p "$GO_HOME/gocode" "$GO_HOME/golib"


# ------------------------------------------------------------------------------
# kubectl
# ------------------------------------------------------------------------------


# home
KUBE_HOME="$DOTFILES_HOME/.kube"
mkdir -p "$KUBE_HOME/cache"


# ------------------------------------------------------------------------------
# less
# ------------------------------------------------------------------------------


# home
LESS_HOME="$DOTFILES_HOME/.less"
mkdir -p $LESS_HOME


# ------------------------------------------------------------------------------
# openvpn
# ------------------------------------------------------------------------------


# home
OPENVPN_HOME="$DOTFILES_HOME/.vpn"
mkdir -p $OPENVPN_HOME


# ------------------------------------------------------------------------------
# python
# ------------------------------------------------------------------------------


# home
PYTHON_HOME="$DOTFILES_HOME/.python"
mkdir -p "$PYTHON_HOME/.ipython" "$PYTHON_HOME/.pyenv/shims" "$PYTHON_HOME/nltk_data"


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


# home
SSH_HOME="$DOTFILES_HOME/.ssh"
mkdir -p $SSH_HOME
touch $SSH_HOME/authorized_keys

# home -> config ssh_keys
SSH_KEYS_DIR_SRC="$DOTFILES_CONFIG/ssh/ssh_keys"
SSH_KEYS_DIR_DST="$SSH_HOME/ssh_keys"
[[ -d $SSH_KEYS_DIR_SRC ]] && [[ ! -d $SSH_KEYS_DIR_DST ]] && ln -s $SSH_KEYS_DIR_SRC $SSH_KEYS_DIR_DST

# home -> sshd_config
SSHD_CONFIG_ROOT_SRC="/etc/ssh/sshd_config"
SSHD_CONFIG_SRC="$DOTFILES_CONFIG/ssh/sshd_config"
[[ -f $SSHD_CONFIG_ROOT_SRC ]] && [[ ! -f $SSHD_CONFIG_SRC ]] && ln -s $SSHD_CONFIG_ROOT_SRC $SSHD_CONFIG_SRC


# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------


# home
VIM_HOME="$DOTFILES_HOME/.vim"
mkdir -p "$VIM_HOME/.backup" "$VIM_HOME/.swp" "$VIM_HOME/.undo"
mkdir -p "$VIM_HOME/bundle"

# home -> resource
VIM_COLORS_SRC="$DOTFILES_RESOURCES/vim/colors"
VIM_COLORS_HOME_DST="$VIM_HOME/colors"
[[ -d $VIM_COLORS_SRC ]] && [[ ! -d $VIM_COLORS_HOME_DST ]] && ln -s $VIM_COLORS_SRC $VIM_COLORS_HOME_DST


# ------------------------------------------------------------------------------
# volta
# ------------------------------------------------------------------------------


# home
VOLTA_HOME="$DOTFILES_HOME/.volta"
mkdir -p $VOLTA_HOME


# ------------------------------------------------------------------------------
# z
# ------------------------------------------------------------------------------


# home
Z_HOME="$DOTFILES_HOME/.z"
mkdir -p $Z_HOME


# ------------------------------------------------------------------------------
# zsh
# ------------------------------------------------------------------------------


# home
ZSH_HOME="$DOTFILES_HOME/.zsh"
mkdir -p "$ZSH_HOME/.zinit" "$ZSH_HOME/.zsh_sessions"

# home -> config
ZSHRC_COMPLETE_SRC="$DOTFILES_CONFIG/zsh/.zsh_complete"
ZSHRC_COMPLETE_DST="$ZSH_HOME/.zsh_complete"
[[ -d $ZSHRC_COMPLETE_SRC ]] && [[ ! -d $ZSHRC_COMPLETE_DST ]] && ln -s $ZSHRC_COMPLETE_SRC $ZSHRC_COMPLETE_DST


# ------------------------------------------------------------------------------
# home -> config (local)
# ------------------------------------------------------------------------------


# local config
declare -a LOCAL_CONFIG_PATH_ARR=(

    # emacs
    "$DOTFILES_CONFIG/emacs/init.el.local"

    # vim
    "$DOTFILES_CONFIG/vim/.vimrc.local"

    # zsh
    "$DOTFILES_CONFIG/zsh/.zshenv.local"
    "$DOTFILES_CONFIG/zsh/.zshrc_initialize.zsh.local"
    "$DOTFILES_CONFIG/zsh/.zshrc_apps.zsh.local"
    "$DOTFILES_CONFIG/zsh/.zshrc_plugins.zsh.local"
    "$DOTFILES_CONFIG/zsh/.zshrc_finalize.zsh.local"

)

setopt nullglob
for src_path in $LOCAL_CONFIG_PATH_ARR; do

    dst_path=$(echo $src_path | sed "s#${DOTFILES_CONFIG}\/#${DOTFILES_HOME}\/.#")
    dst_dir=$(dirname "$dst_path")

    if [[ ! -d $dst_dir ]]; then
        echo "missing directory $dst_dir"
        mkdir -p $dst_dir
    fi

    [[ -L $dst_path || -f $dst_path ]] || ln -s $src_path $dst_path

done
unsetopt nullglob


# ------------------------------------------------------------------------------
# home -> config
# ------------------------------------------------------------------------------


# config
declare -a CONFIG_PATH_ARR=(

    # aws
    "$DOTFILES_CONFIG/aws/config"
    "$DOTFILES_CONFIG/aws/credentials"

    # docker
    "$DOTFILES_CONFIG/docker/config.json"
    "$DOTFILES_CONFIG/docker/daemon.json"

    # emacs
    "$DOTFILES_CONFIG/emacs/init.el"

    # kube
    "$DOTFILES_CONFIG/kube/config"

    # python
    "$DOTFILES_CONFIG/python/.pythonrc"

    # ssh
    "$DOTFILES_CONFIG/ssh/config"
    "$DOTFILES_CONFIG/ssh/sshd_config"

    # vimrc
    "$DOTFILES_CONFIG/vim/.vimrc"

    # zsh
    "$DOTFILES_CONFIG/zsh/.zshenv"
    "$DOTFILES_CONFIG/zsh/.zshrc"
    "$DOTFILES_CONFIG/zsh/.zshrc_initialize.zsh"
    "$DOTFILES_CONFIG/zsh/.zshrc_apps.zsh"
    "$DOTFILES_CONFIG/zsh/.zshrc_plugins.zsh"
    "$DOTFILES_CONFIG/zsh/.zshrc_finalize.zsh"

)

setopt nullglob
for src_path in $CONFIG_PATH_ARR; do

    dst_path=$(echo $src_path | sed "s#${DOTFILES_CONFIG}\/#${DOTFILES_HOME}\/.#")
    dst_dir=$(dirname "$dst_path")

    if [[ ! -d $dst_dir ]]; then
        echo "missing directory $dst_dir"
        mkdir -p $dst_dir
    fi

    [[ -L $dst_path || -f $dst_path ]] || ln -s $src_path $dst_path

done
unsetopt nullglob
