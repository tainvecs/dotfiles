DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"


# ----- git
GIT_CONFIG_DIR=${XDG_CONFIG_HOME:-$DOTFILES_CONFIG}/git
cp -i "$GIT_CONFIG_DIR/config.template" "$GIT_CONFIG_DIR/config"


# ----- docker
DOCKER_HOME=${DOCKER_HOME:-$DOTFILES_HOME/.docker}

# docker.gitlab_login.sh
DOCKER_CONFIG_SCRIPT_SRC="$DOTFILES_CONFIG/docker/docker.gitlab_login.template.sh"
DOCKER_CONFIG_SCRIPT_DST="$DOTFILES_CONFIG/docker/docker.gitlab_login.sh"
DOCKER_HOME_SCRIPT_DST="$DOCKER_HOME/docker.gitlab_login.sh"
cp -i $DOCKER_CONFIG_SCRIPT_SRC $DOCKER_CONFIG_SCRIPT_DST
[[ ! -f $DOCKER_HOME_SCRIPT_DST ]] && ln -s $DOCKER_CONFIG_SCRIPT_DST $DOCKER_HOME_SCRIPT_DST


# ----- ssh
SSH_HOME=${SSH_HOME:-$DOTFILES_HOME/.ssh}

# config
SSH_CONFIG_CONFIG_SRC="$DOTFILES_CONFIG/ssh/config.template"
SSH_CONFIG_CONFIG_DST="$DOTFILES_CONFIG/ssh/config"
SSH_HOME_CONFIG_DST="$SSH_HOME/config"

cp -i $SSH_CONFIG_CONFIG_SRC $SSH_CONFIG_CONFIG_DST
[[ ! -f $SSH_HOME_CONFIG_DST ]] && ln -s $SSH_CONFIG_CONFIG_DST $SSH_HOME_CONFIG_DST

# sshd_config
SSHD_CONFIG_CONFIG_SRC="$DOTFILES_CONFIG/ssh/sshd_config.template"
