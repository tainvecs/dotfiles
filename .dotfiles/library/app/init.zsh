#!/bin/zsh


#------------------------------------------------------------------------------
#
# Utility Functions for App Configuration Setup and Initialization
#
#
# Version: 0.0.1
# Last Modified: 2025-05-24
#
# Dependencies:
#   - Environment Variable File
#     - .dotfiles/env/misc.env
#   - Environment Variables
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - BREW_HOME
#     - DOTFILES_XDG_CONFIG_DIR
#     - DOTFILES_XDG_CACHE_DIR
#     - DOTFILES_XDG_STATE_DIR
#     - DOTFILES_USER_CONFIG_DIR
#     - DOTFILES_USER_SECRET_DIR
#     - DOTFILES_USER_HIST_DIR
#   - Library:
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
#------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# autoenv
#
# - References
#   - https://github.com/hyperupcall/autoenv
#
# - Environment Variables
#   - AUTOENV_AUTH_FILE
#   - AUTOENV_ENV_FILENAME
#   - AUTOENV_ENV_LEAVE_FILENAME
#   - AUTOENV_ENABLE_LEAVE
#
# ------------------------------------------------------------------------------


function _dotfiles_init_autoenv() {

    # activation script
    if [[ $DOTFILES_SYS_NAME = "mac" ]]; then
        local _autoenv_script_path="$BREW_HOME/opt/autoenv/activate.sh"
    elif [[ $DOTFILES_SYS_NAME = "linux" ]]; then
        local _autoenv_script_path="$DOTFILES_XDG_CONFIG_DIR/autoenv/autoenv.git/activate.sh"
    fi

    # apply config and activate autoenv
    if [[ -f $_autoenv_script_path ]]; then

        # home
        local _autoenv_home_dir="$DOTFILES_XDG_CONFIG_DIR/autoenv"
        [[ -d $_autoenv_home_dir ]] || mkdir -p $_autoenv_home_dir

        # envs
        export AUTOENV_AUTH_FILE="$_autoenv_home_dir/.autoenv_authorized"
        export AUTOENV_ENV_FILENAME=".env"
        export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
        export AUTOENV_ENABLE_LEAVE="1"

        # lazy-load autoenv only when `cd` is used
        function _lazy_load_autoenv() {
            add-zsh-hook -d chpwd _lazy_load_autoenv  # Remove hook before unfunctioning
            unfunction _lazy_load_autoenv             # Remove trigger after first use
            source $_autoenv_script_path
            cd "$PWD"                                 # Trigger autoenv
        }

        # set a hook on `cd` to load autoenv only when used
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _lazy_load_autoenv

    else
        log_app_initialization "autoenv" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# aws
#
# - References
#   - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# - Environment Variables
#   - AWS_CONFIG_FILE
#   - AWS_SHARED_CREDENTIALS_FILE
#
# ------------------------------------------------------------------------------


function _dotfiles_init_aws() {

    if command_exists "aws"; then

        # home
        local _aws_home_dir="$DOTFILES_XDG_CONFIG_DIR/aws"
        [[ -d $_aws_home_dir ]] || mkdir -p $_aws_home_dir

        # user config
        local _aws_user_config_path="$DOTFILES_USER_CONFIG_DIR/aws/config"
        local _aws_config_link="$_aws_home_dir/config"

        [[ -e $_aws_config_link ]] || ln -s $_aws_user_config_path $_aws_config_link
        if [[ ! -f $_aws_user_config_path ]]; then
            :
        elif [[ $(realpath "$_aws_config_link") != $(realpath "$_aws_user_config_path") ]]; then
            dotfiles_logging "Failed to link aws config from $_aws_user_config_path to $_aws_config_link." "warn"
        fi

        if [[ -f $_aws_config_link ]]; then
            export AWS_CONFIG_FILE=$_aws_config_link
        fi

        # user credentials
        local _aws_user_credentials_path="$DOTFILES_USER_SECRET_DIR/aws/credentials"
        local _aws_credentials_link="$_aws_home_dir/credentials"

        [[ -e $_aws_credentials_link ]] || ln -s $_aws_user_credentials_path $_aws_credentials_link
        if [[ ! -f $_aws_user_credentials_path ]]; then
            :
        elif [[ $(realpath "$_aws_credentials_link") != $(realpath "$_aws_user_credentials_path") ]]; then
            dotfiles_logging "Failed to link aws credentials from $_aws_user_credentials_path to $_aws_credentials_link." "warn"
        fi

        if [[ -f $_aws_credentials_link ]]; then
            export AWS_SHARED_CREDENTIALS_FILE=$_aws_credentials_link
        fi

    else
        log_app_initialization "aws" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# clojure
#
# - Environment Variables
#   - CLJ_CONFIG
#
# - PATH
#   - /Applications/clojure
#
# ------------------------------------------------------------------------------


function _dotfiles_init_clojure() {

    if command_exists "clojure"; then

        # home
        local _clj_home_dir="$DOTFILES_XDG_CONFIG_DIR/clojure"
        [[ -d $_clj_home_dir ]] || mkdir -p $_clj_home_dir
        export CLJ_CONFIG=$_clj_home_dir

        # .m2 cache
        local _m2_dir="$DOTFILES_XDG_CACHE_DIR/maven/repository"
        [[ -d $_m2_dir ]] || mkdir $_m2_dir
        alias clojure="clojure -Sdeps '{:mvn/local-repo \"$_m2_dir\"}' "

        # path
        if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            [[ ":$PATH:" != *":/Applications/clojure:"* ]] && export PATH="$PATH:/Applications/clojure"
        fi

    else
        log_app_initialization "clojure" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# docker
#
# - References
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# - Environment Variables
#   - DOCKER_CONFIG
#   - DOCKER_DEFAULT_PLATFORM
#
# dockerd
#
# - References
#   - https://docs.docker.com/reference/cli/dockerd/#environment-variables
#
# - Environment Variables
#   - DOCKER_CERT_PATH
#
# ------------------------------------------------------------------------------


function _dotfiles_init_docker() {

    if ! is_supported_system_archt; then
        log_app_initialization "docker" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi

    if command_exists "docker"; then

        # home
        local _docker_home_dir="$DOTFILES_XDG_CONFIG_DIR/docker"
        [[ -d $_docker_home_dir ]] || mkdir -p $_docker_home_dir

        export DOCKER_CONFIG=$_docker_home_dir
        export DOCKER_DEFAULT_PLATFORM="linux/$DOTFILES_SYS_ARCHT"

        # user config
        local _docker_user_config_path="$DOTFILES_USER_CONFIG_DIR/docker/config.json"
        local _docker_config_link="$_docker_home_dir/config.json"

        [[ -e $_docker_config_link ]] || ln -s $_docker_user_config_path $_docker_config_link
        if [[ ! -f $_docker_user_config_path ]]; then
            :
        elif [[ $(realpath "$_docker_config_link") != $(realpath "$_docker_user_config_path") ]]; then
            dotfiles_logging "Failed to link docker config from $_docker_user_config_path to $_docker_config_link." "warn"
        fi

        # dockerd daemon
        if command_exists "dockerd"; then

            # user config
            local _dockerd_user_config_path="$DOTFILES_USER_CONFIG_DIR/docker/daemon.json"
            local _dockerd_config_link="$_docker_home_dir/daemon.json"

            [[ -e $_dockerd_config_link ]] || ln -s $_dockerd_user_config_path $_dockerd_config_link
            if [[ ! -f $_dockerd_user_config_path ]]; then
                :
            elif [[ $(realpath "$_dockerd_config_link") != $(realpath "$_dockerd_user_config_path") ]]; then
                dotfiles_logging "Failed to link dockerd daemon config from $_dockerd_user_config_path to $_dockerd_config_link." "warn"
            fi

            if [[ -f $_dockerd_config_link ]]; then
                alias dockerd="dockerd --config-file $_dockerd_config_link "
            fi

        fi

    else
        log_app_initialization "docker" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# emacs
#
# - References
#   - https://www.gnu.org/software/emacs/manual/html_node/emacs/Environment.html
#   - https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html
#
# - Environment Variables
#   - EMACS_HOME
#
# - PATH
#   - $DOTFILES_XDG_CONFIG_DIR/emacs/bin
#
# ------------------------------------------------------------------------------


function _dotfiles_init_emacs() {

    if command_exists "emacs"; then

        # home
        local _emacs_home_dir="$DOTFILES_XDG_CONFIG_DIR/emacs"
        [[ -d $_emacs_home_dir ]] || mkdir -p $_emacs_home_dir
        export EMACS_HOME=$_emacs_home_dir

        # config
        local _emacs_config_path="$DOTFILES_DOT_CONFIG_DIR/emacs/init.el"
        local _emacs_config_link="$_emacs_home_dir/init.el"

        [[ -e $_emacs_config_link ]] || ln -s $_emacs_config_path $_emacs_config_link
        if [[ -f $_emacs_config_link ]]; then
            alias emacs="emacs -q --load \"$_emacs_config_link\" "
        else
            dotfiles_logging "Failed to link dotfiles emacs init.el." "error"
            log_app_initialization "emacs" "fail"
            return $RC_ERROR
        fi

        # user config
        local _emacs_user_config_path="$DOTFILES_USER_CONFIG_DIR/emacs/init.el"
        local _emacs_user_config_link="$_emacs_home_dir/init.local.el"

        [[ -e $_emacs_user_config_link ]] || ln -s $_emacs_user_config_path $_emacs_user_config_link
        if [[ ! -f $_emacs_user_config_path ]]; then
            :
        elif [[ $(realpath "$_emacs_user_config_link") != $(realpath "$_emacs_user_config_path") ]]; then
            dotfiles_logging "Failed to link emacs user config from $_emacs_user_config_path to $_emacs_user_config_link." "warn"
        fi

        # history -> user history
        if [[ -d $DOTFILES_USER_HIST_DIR ]]; then
            local _emacs_history_path="$DOTFILES_XDG_STATE_DIR/emacs/history"
            local _emacs_history_link="$DOTFILES_USER_HIST_DIR/emacs.history"
            [[ -e $_emacs_history_link ]] || ln -s $_emacs_history_path $_emacs_history_link
        fi

        # path
        local _emacs_bin_dir="$_emacs_home_dir/bin"
        [[ -d $_emacs_bin_dir ]] && [[ ":$PATH:" != *":$_emacs_bin_dir:"* ]] && export PATH="$PATH:$_emacs_bin_dir"

    else
        log_app_initialization "emacs" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# gcp
#
# - References
#   - https://cloud.google.com/sdk/docs/configurations
#
# - Environment Variables
#   - CLOUDSDK_CONFIG
#
# ------------------------------------------------------------------------------


function _dotfiles_init_gcp() {

    if command_exists "gcloud"; then

        alias gcp="gcloud compute "

        # home
        local _gcp_home_dir="$DOTFILES_XDG_CONFIG_DIR/gcp"
        [[ -d $_gcp_home_dir ]] || mkdir -p $_gcp_home_dir
        export CLOUDSDK_CONFIG=$_gcp_home_dir

        # user config
        local _gcp_user_config_path="$DOTFILES_USER_CONFIG_DIR/gcp/config_default"
        local _gcp_config_dir="$_gcp_home_dir/configurations"
        local _gcp_config_link="$_gcp_config_dir/config_default"

        [[ -d $_gcp_config_dir ]] || mkdir -p $_gcp_config_dir

        [[ -e $_gcp_config_link ]] || ln -s $_gcp_user_config_path $_gcp_config_link
        if [[ ! -f $_gcp_user_config_path ]]; then
            :
        elif [[ $(realpath "$_gcp_config_link") != $(realpath "$_gcp_user_config_path") ]]; then
            dotfiles_logging "Failed to link gcp config from $_gcp_user_config_path to $_gcp_config_link." "warn"
        fi

    else
        log_app_initialization "gcp" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# go
#
# - Environment Variables
#   - GOLIB
#   - GOCODE
#   - GOPATH
#
# - PATH
#   - $GOLIB/bin
#
# ------------------------------------------------------------------------------


function _dotfiles_init_go() {

    if command_exists "go"; then

        # home
        local _go_home_dir="$DOTFILES_XDG_CONFIG_DIR/go"
        [[ -d $_go_home_dir ]] || mkdir -p $_go_home_dir

        # PATH
        export GOLIB="$_go_home_dir/golib"
        export GOCODE="$_go_home_dir/gocode"
        export GOPATH="$GOLIB:$GOCODE"

        [[ -d "$GOLIB/bin" ]] || mkdir -p "$GOLIB/bin"
        [[ ":$PATH:" != *":$GOLIB/bin:"* ]] && export PATH="$PATH:$GOLIB/bin"

    else
        log_app_initialization "go" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# htop
#
# - References
#   - https://github.com/htop-dev/htop
#
# ------------------------------------------------------------------------------


function _dotfiles_init_htop() {

    if command_exists "htop"; then

        # home
        local _htop_home_dir="$DOTFILES_XDG_CONFIG_DIR/htop"
        [[ -d $_htop_home_dir ]] || mkdir -p $_htop_home_dir

        # user config
        local _htop_user_config_path="$DOTFILES_USER_CONFIG_DIR/htop/htoprc"
        local _htop_config_link="$_htop_home_dir/htoprc"

        [[ -e $_htop_config_link ]] || ln -s $_htop_user_config_path $_htop_config_link
        if [[ ! -f $_htop_user_config_path ]]; then
            :
        elif [[ $(realpath "$_htop_config_link") != $(realpath "$_htop_user_config_path") ]]; then
            dotfiles_logging "Failed to link htop config from $_htop_user_config_path to $_htop_config_link." "warn"
        fi

    else
        log_app_initialization "htop" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# keyd
#
# - References
#   - https://github.com/rvaiya/keyd
#
# ------------------------------------------------------------------------------


function _dotfiles_init_keyd() {

    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_app_initialization "keyd" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    if command_exists "keyd"; then

        # user config
        local _keyd_user_config_path="$DOTFILES_USER_CONFIG_DIR/keyd/default.conf"
        local _keyd_config_link="/etc/keyd/default.conf"

        if [[ ! -e $_keyd_config_link ]] && [[ -f $_keyd_user_config_path ]]; then
            sudo ln -s $_keyd_user_config_path $_keyd_config_link && sudo keyd reload
        fi

        if [[ ! -f $_keyd_user_config_path ]]; then
            :
        elif [[ $(realpath "$_keyd_config_link") != $(realpath "$_keyd_user_config_path") ]]; then
            dotfiles_logging "Failed to link keyd config from $_keyd_user_config_path to $_keyd_config_link." "warn"
        fi

    else
        log_app_initialization "keyd" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# kubectl
#
# - References
#   - https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
#   - https://kubernetes.io/docs/reference/kubectl/kubectl/
#
# - Environment Variables
#   - KUBECONFIG
#
# ------------------------------------------------------------------------------


function _dotfiles_init_kube() {

    if command_exists "kubectl"; then

        # home
        local _kube_home_dir="$DOTFILES_XDG_CONFIG_DIR/kube"
        [[ -d $_kube_home_dir ]] || mkdir -p $_kube_home_dir

        # user config and credentials
        local _kube_user_config_path="$DOTFILES_USER_SECRET_DIR/kube/config"
        local _kube_config_link="$_kube_home_dir/config"

        [[ -e $_kube_config_link ]] || ln -s $_kube_user_config_path $_kube_config_link
        if [[ ! -f $_kube_user_config_path ]]; then
            :
        elif [[ $(realpath "$_kube_config_link") != $(realpath "$_kube_user_config_path") ]]; then
            dotfiles_logging "Failed to link kube config from $_kube_user_config_path to $_kube_config_link." "warn"
        fi

        if [[ -f $_kube_config_link ]]; then
            export KUBECONFIG="$_kube_config_link:$KUBECONFIG"
        fi

        # cache
        local _kube_cache_dir="$DOTFILES_XDG_CACHE_DIR/kube"
        [[ -d $_kube_cache_dir ]] || mkdir -p $_kube_cache_dir
        alias kubectl="kubectl --cache-dir $_kube_cache_dir "

    else
        log_app_initialization "kubectl" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# openvpn
#
# - References
#   - https://openvpn.net/community-resources/reference-manual-for-openvpn-2-5/
#
# ------------------------------------------------------------------------------

function _dotfiles_init_openvpn() {

    if command_exists "openvpn"; then

        # mac, path
        if [[ $DOTFILES_SYS_NAME = "mac" ]]; then
            local _openvpn_bin_dir="$BREW_HOME/opt/openvpn/sbin"
            [[ -d $_openvpn_bin_dir ]] && [[ ":$PATH:" != *":$_openvpn_bin_dir:"* ]] && export PATH="$PATH:$_openvpn_bin_dir"
        fi

    else
        log_app_initialization "openvpn" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# python
#
# - References
#   - https://docs.python.org/3/using/cmdline.html#environment-variables
#   - https://www.nltk.org/data.html
#
# - Environment Variables
#   - PYTHONSTARTUP
#   - PYTHON_HISTORY
#   - NLTK_DATA
#
# pyenv
#
# - References
#   - https://github.com/pyenv/pyenv?tab=readme-ov-file#environment-variables
#
# - Environment Variables
#   - PYENV_ROOT
#
# ipython
#
# - References
#   - https://ipython.org/ipython-doc/3/config/intro.html#the-ipython-directory
#
# - Environment Variables
#   - IPYTHONDIR
#
# ------------------------------------------------------------------------------


function _dotfiles_init_python() {

    if command_exists "python"; then

        # home
        local _python_home_dir="$DOTFILES_XDG_CONFIG_DIR/python"
        [[ -d $_python_home_dir ]] || mkdir -p $_python_home_dir

        # user config
        local _python_user_config_path="$DOTFILES_USER_CONFIG_DIR/python/.pythonrc"
        local _python_config_link="$_python_home_dir/.pythonrc"

        [[ -e $_python_config_link ]] || ln -s $_python_user_config_path $_python_config_link
        if [[ ! -f $_python_user_config_path ]]; then
            :
        elif [[ $(realpath "$_python_config_link") != $(realpath "$_python_user_config_path") ]]; then
            dotfiles_logging "Failed to link python user config from $_python_user_config_path to $_python_config_link." "warn"
        fi

        if [[ -f $_python_config_link ]]; then
            export PYTHONSTARTUP=$_python_config_link
        fi

        # history -> user history
        if [[ -d $DOTFILES_USER_HIST_DIR ]]; then
            local _python_history_path="$DOTFILES_XDG_STATE_DIR/python/.python_history"
            local _python_history_link="$DOTFILES_USER_HIST_DIR/python.history"
            [[ -e $_python_history_link ]] || ln -s $_python_history_path $_python_history_link
        fi

        # nltk data directory
        local _nltk_data_dir="$_python_home_dir/nltk_data"
        [[ -d $_nltk_data_dir ]] || mkdir -p $_nltk_data_dir
        export NLTK_DATA=$_nltk_data_dir

        # pyenv
        local _pyenv_home_dir="$_python_home_dir/pyenv"
        local _pyenv_git_dir="$_pyenv_home_dir/pyenv.git"

        if command_exists "pyenv" || [[ -d $_pyenv_git_dir ]]; then

            # home
            [[ -d $_pyenv_home_dir ]] || mkdir -p $_pyenv_home_dir

            if [[ -d $_pyenv_git_dir ]]; then
                export PYENV_ROOT="$_pyenv_git_dir"
            else
                export PYENV_ROOT="$_pyenv_home_dir"
            fi

            # path
            local _pyenv_bin_dir="$PYENV_ROOT/bin"
            [[ -d $_pyenv_bin_dir ]] && [[ ":$PATH:" != *":$_pyenv_bin_dir:"* ]] && export PATH="$_pyenv_bin_dir:$PATH"

            local _pyenv_shims_dir="$PYENV_ROOT/shims"
            [[ -d $_pyenv_shims_dir ]] || mkdir -p $_pyenv_shims_dir

            # lazy load pyenv
            pyenv() {
                unset -f pyenv
                eval "$(command pyenv init -)"
                eval "$(command pyenv virtualenv-init -)"
                pyenv $@
            }

            # mac
            if command_exists "brew"; then
                pyenv-ln-brew() {
                    ln -s "$(brew --cellar python)/*" "$_pyenv_home_dir/versions/"
                }
            fi
        fi

        # ipython
        local _ipython_home_dir="$_python_home_dir/ipython"
        [[ -d $_ipython_home_dir ]] || mkdir -p $_ipython_home_dir

        export IPYTHONDIR=$_ipython_home_dir
        alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"

    else
        log_app_initialization "python" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# ssh
#
# - References
#   - https://man7.org/linux/man-pages/man1/ssh.1.html
#
# - Environment Variables
#   - SSH_HOME
#   - GIT_SSH_COMMAND
#
# ------------------------------------------------------------------------------


function _dotfiles_init_ssh() {

    if command_exists "ssh"; then

        # home
        local _ssh_home_dir="$DOTFILES_XDG_CONFIG_DIR/ssh"
        [[ -d $_ssh_home_dir ]] || mkdir -p $_ssh_home_dir
        export SSH_HOME=$_ssh_home_dir

        # keys
        local _ssh_user_credentials_dir="$DOTFILES_USER_SECRET_DIR/ssh/keys"
        local _ssh_credentials_link="$_ssh_home_dir/keys"

        [[ -e $_ssh_credentials_link ]] || ln -s $_ssh_user_credentials_dir $_ssh_credentials_link
        if [[ ! -d $_ssh_user_credentials_dir ]]; then
            :
        elif [[ $(realpath "$_ssh_credentials_link") != $(realpath "$_ssh_user_credentials_dir") ]]; then
            dotfiles_logging "Failed to link ssh credentials from $_ssh_user_credentials_dir to $_ssh_credentials_link." "warn"
        fi

        # user config
        local _ssh_user_config_path="$DOTFILES_USER_CONFIG_DIR/ssh/config"
        local _ssh_config_link="$_ssh_home_dir/config"

        [[ -e $_ssh_config_link ]] || ln -s $_ssh_user_config_path $_ssh_config_link
        if [[ ! -f $_ssh_user_config_path ]]; then
            :
        elif [[ $(realpath "$_ssh_config_link") != $(realpath "$_ssh_user_config_path") ]]; then
            dotfiles_logging "Failed to link ssh user config from $_ssh_user_config_path to $_ssh_config_link." "warn"
        fi

        # known host
        local _ssh_known_host_path="$_ssh_home_dir/known_hosts"

        # ssh cmd alias
        if [[ -f $_ssh_config_link ]]; then
            local _ssh_cmd="ssh -F $_ssh_config_link -o UserKnownHostsFile=$_ssh_known_host_path "
        else
            local _ssh_cmd="ssh -o UserKnownHostsFile=$_ssh_known_host_path "
        fi

        export GIT_SSH_COMMAND=$_ssh_cmd
        alias ssh=$_ssh_cmd

    else
        log_app_initialization "ssh" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# tmux
#
# - References
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# - Environment Variables
#   - TMUX_CONFIG_PATH
#   - TMUX_CONFIG_LOCAL_PATH
#
# ------------------------------------------------------------------------------


function _dotfiles_init_tmux() {

    if command_exists "tmux"; then

        # home
        local _tmux_home_dir="$DOTFILES_XDG_CONFIG_DIR/tmux"
        [[ -d $_tmux_home_dir ]] || mkdir -p $_tmux_home_dir

        # config
        local _tmux_config_path="$DOTFILES_DOT_CONFIG_DIR/tmux/.tmux.conf"
        local _tmux_config_link="$_tmux_home_dir/.tmux.conf"

        [[ -e $_tmux_config_link ]] || ln -s $_tmux_config_path $_tmux_config_link
        if [[ -f $_tmux_config_link ]]; then
            alias tmux="tmux -f $_tmux_config_path "
            export TMUX_CONFIG_PATH=$_tmux_config_link
        else
            dotfiles_logging "Failed to link dotfiles tmux .tmux.conf." "error"
            log_app_initialization "tmux" "fail"
            return $RC_ERROR
        fi

        # user config
        local _tmux_user_config_path="$DOTFILES_USER_CONFIG_DIR/tmux/.tmux.conf"
        local _tmux_user_config_link="$_tmux_home_dir/.tmux.local.conf"

        [[ -e $_tmux_user_config_link ]] || ln -s $_tmux_user_config_path $_tmux_user_config_link
        if [[ ! -f $_tmux_user_config_path ]]; then
            :
        elif [[ $(realpath "$_tmux_user_config_link") != $(realpath "$_tmux_user_config_path") ]]; then
            dotfiles_logging "Failed to link tmux user config from $_tmux_user_config_path to $_tmux_user_config_link." "warn"
        fi

        if [[ -f $_tmux_user_config_link ]]; then
            export TMUX_CONFIG_LOCAL_PATH=$_tmux_user_config_link
        fi

    else
        log_app_initialization "tmux" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# vim
#
# - Environment Variables
#   - VIM_HOME
#   - VIMINIT
#   - VIM_CONFIG_LOCAL_PATH
#
# ------------------------------------------------------------------------------


function _dotfiles_init_vim() {

    if command_exists "vim"; then

        # home
        local _vim_home_dir="$DOTFILES_XDG_CONFIG_DIR/vim"
        [[ -d $_vim_home_dir ]] || mkdir -p $_vim_home_dir
        export VIM_HOME=$_vim_home_dir

        # config
        local _vim_config_path="$DOTFILES_DOT_CONFIG_DIR/vim/.vimrc"
        local _vim_config_link="$_vim_home_dir/.vimrc"

        [[ -e $_vim_config_link ]] || ln -s $_vim_config_path $_vim_config_link
        if [[ -f $_vim_config_link ]]; then
            export VIMINIT="source $_vim_config_link"
        else
            dotfiles_logging "Failed to link dotfiles vim .vimrc." "error"
            log_app_initialization "vim" "fail"
            return $RC_ERROR
        fi

        # user config
        local _vim_user_config_path="$DOTFILES_USER_CONFIG_DIR/vim/.vimrc"
        local _vim_user_config_link="$_vim_home_dir/.local.vimrc"

        [[ -e $_vim_user_config_link ]] || ln -s $_vim_user_config_path $_vim_user_config_link
        if [[ ! -f $_vim_user_config_path ]]; then
            :
        elif [[ $(realpath "$_vim_user_config_link") != $(realpath "$_vim_user_config_path") ]]; then
            dotfiles_logging "Failed to link vim user config from $_vim_user_config_path to $_vim_user_config_link." "warn"
        fi

        if [[ -f $_vim_user_config_link ]]; then
            export VIM_CONFIG_LOCAL_PATH=$_vim_user_config_link
        fi

        # macs, alias
        if [[ $DOTFILES_SYS_NAME = "mac" ]]; then
            local _mac_vim_bin_path="$BREW_HOME/bin/vim"
            if [[ -f $_mac_vim_bin_path ]]; then
                alias vi=$_mac_vim_bin_path
                alias vim=$_mac_vim_bin_path
            fi
        fi

    else
        log_app_initialization "vim" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# volta
#
# - References
#   - https://github.com/npm/npm/issues/14528
#
# - Environment Variables
#   - VOLTA_HOME
#   - NPM_CONFIG_USERCONFIG
#
# - PATH
#   - $VOLTA_HOME/bin
#
# ------------------------------------------------------------------------------


function _dotfiles_init_volta() {

    if command_exists "volta"; then

        # home
        local _volta_home_dir="$DOTFILES_XDG_CONFIG_DIR/volta"
        [[ -d $_volta_home_dir ]] || mkdir -p $_volta_home_dir
        export VOLTA_HOME=$_volta_home_dir

        # path
        local _volta_bin_dir="$_volta_home_dir/bin"
        [[ ":$PATH:" != *":$_volta_bin_dir:"* ]] && export PATH="$PATH:$_volta_bin_dir"

        # npm user config
        local _volta_npm_home_dir="$_volta_home_dir/npm"
        [[ -d $_volta_npm_home_dir ]] || mkdir -p $_volta_npm_home_dir

        local _volta_npm_user_config_path="$DOTFILES_USER_CONFIG_DIR/volta/.npmrc"
        local _volta_npm_config_link="$_volta_npm_home_dir/.npmrc"

        [[ -e $_volta_npm_config_link ]] || ln -s $_volta_npm_user_config_path $_volta_npm_config_link
        if [[ ! -f $_volta_npm_user_config_path ]]; then
            :
        elif [[ $(realpath "$_volta_npm_config_link") != $(realpath "$_volta_npm_user_config_path") ]]; then
            dotfiles_logging "Failed to link volta npm config from $_volta_npm_user_config_path to $_volta_npm_config_link." "warn"
        fi

        if [[ -f $_volta_npm_config_link ]]; then
            export NPM_CONFIG_USERCONFIG=$_volta_npm_config_link
        fi

    else
        log_app_initialization "volta" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# wget
#
# - References
#   - https://www.gnu.org/software/wget/manual/html_node/HTTPS-_0028SSL_002fTLS_0029-Options.html
#
# ------------------------------------------------------------------------------


function _dotfiles_init_wget() {

    if command_exists "wget"; then

        # HSTS file configuration
        local _wget_state_dir="$DOTFILES_XDG_STATE_DIR/wget"
        [[ -d $_wget_state_dir ]] || mkdir -p $_wget_state_dir

        local _wget_hsts_file_path="$_wget_state_dir/.wget-hsts"
        alias wget="wget --hsts-file $_wget_hsts_file_path "

    else
        log_app_initialization "wget" "fail"
        return $RC_ERROR
    fi
}
