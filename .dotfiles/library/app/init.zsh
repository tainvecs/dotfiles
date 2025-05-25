#!/bin/zsh


#------------------------------------------------------------------------------
#
# Utility Functions for App Configuration Setup and Initialization
#
#
# Version: 0.0.2
# Last Modified: 2025-05-25
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
    local _autoenv_script_path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _autoenv_script_path="$BREW_HOME/opt/autoenv/activate.sh"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _autoenv_script_path="$DOTFILES_XDG_CONFIG_DIR/autoenv/autoenv.git/activate.sh"
    fi

    # sanity check
    if [[ ! -f $_autoenv_script_path ]]; then
        log_app_initialization "autoenv" "fail"
        return $RC_ERROR
    fi

    # home
    local _autoenv_home_dir=$(setup_dotfiles_app_home "autoenv")

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

    # sanity check
    if ! command_exists "aws"; then
        log_app_initialization "aws" "fail"
        return $RC_ERROR
    fi

    # home
    local _aws_home_dir=$(setup_dotfiles_app_home "aws")

    # user config
    local _aws_config_link=$(setup_dotfiles_user_config "aws" "config" "$_aws_home_dir" "config")
    if [[ -f $_aws_config_link ]]; then
        export AWS_CONFIG_FILE=$_aws_config_link
    fi

    # user credentials
    local _aws_credentials_link=$(setup_dotfiles_user_credentials "aws" "$_aws_home_dir" "credentials")
    if [[ -f $_aws_credentials_link ]]; then
        export AWS_SHARED_CREDENTIALS_FILE=$_aws_credentials_link
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

    # sanity check
    if ! command_exists "clojure"; then
        log_app_initialization "clojure" "fail"
        return $RC_ERROR
    fi

    # home
    local _clj_home_dir=$(setup_dotfiles_app_home "clojure")
    export CLJ_CONFIG=$_clj_home_dir

    # .m2 cache
    local _m2_dir="$DOTFILES_XDG_CACHE_DIR/maven/repository"
    ensure_directory "$_m2_dir"
    alias clojure="clojure -Sdeps '{:mvn/local-repo \"$_m2_dir\"}' "

    # path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        append_dir_to_path "/Applications/clojure"
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

    # sanity check
    if ! is_supported_system_archt; then
        log_app_initialization "docker" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi

    if ! command_exists "docker"; then
        log_app_initialization "docker" "fail"
        return $RC_ERROR
    fi

    # home
    local _docker_home_dir=$(setup_dotfiles_app_home "docker")
    export DOCKER_CONFIG=$_docker_home_dir
    export DOCKER_DEFAULT_PLATFORM="linux/$DOTFILES_SYS_ARCHT"

    # user config
    local _docker_config_link=$(setup_dotfiles_user_config "docker" "config.json" "$_docker_home_dir" "config.json")

    # dockerd daemon user config
    if command_exists "dockerd"; then
        local _dockerd_config_link=$(setup_dotfiles_user_config "docker" "daemon.json" "$_docker_home_dir" "daemon.json")
        [[ -f $_dockerd_config_link ]] && alias dockerd="dockerd --config-file $_dockerd_config_link "
    fi
}


# ------------------------------------------------------------------------------
#
# Elasticsearch
#
# Slow, should be loaded in background with zinit.
#
# - References
#   - https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-enroll-agent
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html#windows-service-settings
#
# - Environment Variables
#   - ES_HOME
#   - ES_JAVA_HOME
#
# ------------------------------------------------------------------------------


function _dotfiles_init_es(){

    # sanity check
    local _es_home_dir="$DOTFILES_XDG_CONFIG_DIR/es/es"
    if [[ ! -d "$_es_home_dir" ]]; then
        log_app_initialization "es" "fail"
        return $RC_ERROR
    fi

    # home
    export ES_HOME=$_es_home_dir

    # path
    append_dir_to_path "$_es_home_dir/bin"

    # java
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        export ES_JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home)}"
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

    # sanity check
    if ! command_exists "emacs"; then
        log_app_initialization "emacs" "fail"
        return $RC_ERROR
    fi

    # home
    local _emacs_home_dir=$(setup_dotfiles_app_home "emacs")
    export EMACS_HOME=$_emacs_home_dir

    # dotfiles config
    local _emacs_config_link
    _emacs_config_link=$(setup_dotfiles_config "emacs" "$_emacs_home_dir" "init.el")
    if [[ $? -ne $RC_SUCCESS ]]; then
        dotfiles_logging "Failed to setup dotfiles emacs init.el." "error"
        log_app_initialization "emacs" "fail"
        return $RC_ERROR
    fi
    alias emacs="emacs -q --load \"$_emacs_config_link\" "

    # user config
    setup_dotfiles_user_config "emacs" "init.el" "$_emacs_home_dir" "init.local.el"

    # history -> user history
    setup_dotfiles_history_link "emacs" "history" "emacs.history"

    # path
    append_dir_to_path "$_emacs_home_dir/bin"
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

    # sanity check
    if ! command_exists "gcloud"; then
        log_app_initialization "gcp" "fail"
        return $RC_ERROR
    fi

    alias gcp="gcloud compute "

    # home
    local _gcp_home_dir=$(setup_dotfiles_app_home "gcp")
    export CLOUDSDK_CONFIG=$_gcp_home_dir

    # user config
    local _gcp_config_dir="$_gcp_home_dir/configurations"
    ensure_directory "$_gcp_config_dir"

    local _gcp_user_config_path="$DOTFILES_USER_CONFIG_DIR/gcp/config_default"
    local _gcp_config_link="$_gcp_config_dir/config_default"

    if ! create_validated_symlink "$_gcp_user_config_path" "$_gcp_config_link"; then
        dotfiles_logging "Failed to link gcp config from $_gcp_user_config_path to $_gcp_config_link." "warn"
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

    # sanity check
    if ! command_exists "go"; then
        log_app_initialization "go" "fail"
        return $RC_ERROR
    fi

    # home
    local _go_home_dir=$(setup_dotfiles_app_home "go")

    # env
    export GOLIB="$_go_home_dir/golib"
    export GOCODE="$_go_home_dir/gocode"
    export GOPATH="$GOLIB:$GOCODE"

    # path
    local _golib_bin_dir="$GOLIB/bin"
    ensure_directory "$_golib_bin_dir"
    append_dir_to_path "$_golib_bin_dir"
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

    # sanity check
    if ! command_exists "htop"; then
        log_app_initialization "htop" "fail"
        return $RC_ERROR
    fi

    # home
    local _htop_home_dir=$(setup_dotfiles_app_home "htop")

    # user config
    local _htop_config_link=$(setup_dotfiles_user_config "htop" "htoprc" "$_htop_home_dir" "htoprc")
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

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_app_initialization "keyd" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    if ! command_exists "keyd"; then
        log_app_initialization "keyd" "fail"
        return $RC_ERROR
    fi

    # user config
    local _keyd_user_config_path="$DOTFILES_USER_CONFIG_DIR/keyd/default.conf"
    local _keyd_config_link="/etc/keyd/default.conf"

    if [[ ! -e $_keyd_config_link ]] && [[ -f $_keyd_user_config_path ]]; then
        sudo ln -s "$_keyd_user_config_path" "$_keyd_config_link" && sudo keyd reload
    fi

    if [[ -f $_keyd_user_config_path ]] && [[ ! $_keyd_config_link -ef $_keyd_user_config_path ]]; then
        dotfiles_logging "Failed to link keyd config from $_keyd_user_config_path to $_keyd_config_link." "warn"
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

    # sanity check
    if ! command_exists "kubectl"; then
        log_app_initialization "kubectl" "fail"
        return $RC_ERROR
    fi

    # home
    local _kube_home_dir=$(setup_dotfiles_app_home "kube")

    # user config and credentials
    local _kube_config_link=$(setup_dotfiles_user_credentials "kube" "$_kube_home_dir" "config")
    if [[ -f $_kube_config_link ]]; then
        export KUBECONFIG="$_kube_config_link:$KUBECONFIG"
    fi

    # cache
    local _kube_cache_dir="$DOTFILES_XDG_CACHE_DIR/kube"
    ensure_directory "$_kube_cache_dir"
    alias kubectl="kubectl --cache-dir $_kube_cache_dir "
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

    # sanity check
    if ! command_exists "openvpn"; then
        log_app_initialization "openvpn" "fail"
        return $RC_ERROR
    fi

    # mac, path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        append_dir_to_path "$BREW_HOME/opt/openvpn/sbin"
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

    # sanity check
    if ! command_exists "python"; then
        log_app_initialization "python" "fail"
        return $RC_ERROR
    fi

    # home
    local _python_home_dir=$(setup_dotfiles_app_home "python")

    # user config
    local _python_config_link=$(setup_dotfiles_user_config "python" ".pythonrc" "$_python_home_dir" ".pythonrc")
    if [[ -f $_python_config_link ]]; then
        export PYTHONSTARTUP=$_python_config_link
    fi

    # history -> user history
    setup_dotfiles_history_link "python" ".python_history"

    # nltk data directory
    local _nltk_data_dir="$_python_home_dir/nltk_data"
    ensure_directory "$_nltk_data_dir"
    export NLTK_DATA=$_nltk_data_dir

    # pyenv
    local _pyenv_home_dir="$_python_home_dir/pyenv"
    local _pyenv_git_dir="$_pyenv_home_dir/pyenv.git"

    if command_exists "pyenv" || [[ -d $_pyenv_git_dir ]]; then

        # home
        ensure_directory "$_pyenv_home_dir"

        # git dir
        if [[ -d $_pyenv_git_dir ]]; then
            export PYENV_ROOT="$_pyenv_git_dir"
        else
            export PYENV_ROOT="$_pyenv_home_dir"
        fi

        # path
        local _pyenv_bin_dir="$PYENV_ROOT/bin"
        prepend_dir_to_path "$_pyenv_bin_dir"

        # shims
        local _pyenv_shims_dir="$PYENV_ROOT/shims"
        ensure_directory "$_pyenv_shims_dir"

        # lazy load pyenv
        pyenv() {
            unset -f pyenv
            eval "$(command pyenv init -)"
            eval "$(command pyenv virtualenv-init -)"
            pyenv "$@"
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
    ensure_directory "$_ipython_home_dir"
    export IPYTHONDIR=$_ipython_home_dir
    alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()' "
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

    # sanity check
    if ! command_exists "ssh"; then
        log_app_initialization "ssh" "fail"
        return $RC_ERROR
    fi

    # home
    local _ssh_home_dir=$(setup_dotfiles_app_home "ssh")
    export SSH_HOME=$_ssh_home_dir

    # known host
    local _ssh_known_host_path="$_ssh_home_dir/known_hosts"

    # user config
    local _ssh_config_link=$(setup_dotfiles_user_config "ssh" "config" "$_ssh_home_dir" "config")

    # keys
    local _ssh_credentials_link=$(setup_dotfiles_user_credentials "ssh" "$_ssh_home_dir" "keys")

    # ssh cmd alias
    local _ssh_cmd="ssh -o UserKnownHostsFile=$_ssh_known_host_path "
    if [[ -f $_ssh_config_link ]]; then
        _ssh_cmd="ssh -F $_ssh_config_link -o UserKnownHostsFile=$_ssh_known_host_path "
    fi

    export GIT_SSH_COMMAND=$_ssh_cmd
    alias ssh=$_ssh_cmd
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

    # sanity check
    if ! command_exists "tmux"; then
        log_app_initialization "tmux" "fail"
        return $RC_ERROR
    fi

    # home
    local _tmux_home_dir=$(setup_dotfiles_app_home "tmux")

    # dotfiles config
    local _tmux_config_link
    _tmux_config_link=$(setup_dotfiles_config "tmux" "$_tmux_home_dir" ".tmux.conf")
    if [[ $? -ne $RC_SUCCESS ]]; then
        dotfiles_logging "Failed to setup dotfiles tmux .tmux.conf." "error"
        log_app_initialization "tmux" "fail"
        return $RC_ERROR
    fi
    alias tmux="tmux -f $_tmux_config_link "
    export TMUX_CONFIG_PATH=$_tmux_config_link

    # user config
    local _tmux_user_config_link=$(setup_dotfiles_user_config "tmux" ".tmux.conf" "$_tmux_home_dir" ".tmux.local.conf")
    if [[ -f $_tmux_user_config_link ]]; then
        export TMUX_CONFIG_LOCAL_PATH=$_tmux_user_config_link
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

    # sanity check
    if ! command_exists "vim"; then
        log_app_initialization "vim" "fail"
        return $RC_ERROR
    fi

    # home
    local _vim_home_dir=$(setup_dotfiles_app_home "vim")
    export VIM_HOME=$_vim_home_dir

    # dotfiles config
    local _vim_config_link
    _vim_config_link=$(setup_dotfiles_config "vim" "$_vim_home_dir" ".vimrc")
    if [[ $? -ne $RC_SUCCESS ]]; then
        dotfiles_logging "Failed to setup dotfiles vim .vimrc." "error"
        log_app_initialization "vim" "fail"
        return $RC_ERROR
    fi
    export VIMINIT="source $_vim_config_link"

    # user config
    local _vim_user_config_link=$(setup_dotfiles_user_config "vim" ".vimrc" "$_vim_home_dir" ".local.vimrc")
    if [[ -f $_vim_user_config_link ]]; then
        export VIM_CONFIG_LOCAL_PATH=$_vim_user_config_link
    fi

    # macs, alias
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        local _mac_vim_bin_path="$BREW_HOME/bin/vim"
        if [[ -f $_mac_vim_bin_path ]]; then
            alias vi=$_mac_vim_bin_path
            alias vim=$_mac_vim_bin_path
        fi
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

    # sanity check
    if ! command_exists "volta"; then
        log_app_initialization "volta" "fail"
        return $RC_ERROR
    fi

    # home
    local _volta_home_dir=$(setup_dotfiles_app_home "volta")
    export VOLTA_HOME=$_volta_home_dir

    # path
    append_dir_to_path "$_volta_home_dir/bin"

    # npm user config
    local _volta_npm_home_dir="$_volta_home_dir/npm"
    ensure_directory "$_volta_npm_home_dir"

    local _volta_npm_config_link=$(setup_dotfiles_user_config "volta" ".npmrc" "$_volta_npm_home_dir" ".npmrc")
    if [[ -f $_volta_npm_config_link ]]; then
        export NPM_CONFIG_USERCONFIG=$_volta_npm_config_link
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

    # sanity check
    if ! command_exists "wget"; then
        log_app_initialization "wget" "fail"
        return $RC_ERROR
    fi

    # HSTS file configuration
    local _wget_state_dir="$DOTFILES_XDG_STATE_DIR/wget"
    ensure_directory "$_wget_state_dir"
    local _wget_hsts_file_path="$_wget_state_dir/.wget-hsts"
    alias wget="wget --hsts-file $_wget_hsts_file_path "
}
