DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
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
# git: delta
# ------------------------------------------------------------------------------


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


# home
TMUX_HOME="$DOTFILES_HOME/.tmux"
mkdir -p $TMUX_HOME
touch $TMUX_HOME/.gitkeep

# config
TMUX_CONFIG_SRC="$DOTFILES_CONFIG/tmux/.tmux.conf"
TMUX_CONFIG_DST="$TMUX_HOME/.tmux.conf"
[[ -f $TMUX_CONFIG_SRC ]] && [[ ! -f $TMUX_CONFIG_DST ]] && ln -s $TMUX_CONFIG_SRC $TMUX_CONFIG_DST


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

# config
VIM_CONFIG_SRC="$DOTFILES_CONFIG/vim/.vimrc"
VIM_CONFIG_DST="$VIM_HOME/.vimrc"
[[ -f $VIM_CONFIG_SRC ]] && [[ ! -f $VIM_CONFIG_DST ]] && ln -s $VIM_CONFIG_SRC $VIM_CONFIG_DST

# resource
VIM_COLORS_SRC="$DOTFILES_RESOURCES/vim/colors"
VIM_COLORS_DST="$VIM_HOME/colors"
[[ -d $VIM_COLORS_SRC ]] && [[ -d $VIM_COLORS_DST ]] && cp $VIM_COLORS_SRC/* $VIM_COLORS_DST


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

ZSGRC_FINAL_SRC="$DOTFILES_CONFIG/zsh/.zshrc_finalize.zsh"
ZSGRC_FINAL_DST="$ZSH_HOME/.zshrc_finalize.zsh"
[[ -f $ZSGRC_FINAL_SRC ]] && [[ ! -f $ZSGRC_FINAL_DST ]] && ln -s $ZSGRC_FINAL_SRC $ZSGRC_FINAL_DST

ZSGRC_COMPLETE_SRC="$DOTFILES_CONFIG/zsh/.zsh_complete"
ZSGRC_COMPLETE_DST="$ZSH_HOME/.zsh_complete"
[[ -d $ZSGRC_COMPLETE_SRC ]] && [[ -d $ZSGRC_COMPLETE_DST ]] && cp $ZSGRC_COMPLETE_SRC/* $ZSGRC_COMPLETE_DST
