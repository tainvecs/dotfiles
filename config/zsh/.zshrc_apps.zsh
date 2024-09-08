# ------------------------------------------------------------------------------
# autoenv
#
# - references
#   - https://github.com/hyperupcall/autoenv
#
# - envs
#   - AUTOENV_AUTH_FILE,
#   - AUTOENV_ENV_FILENAME,
#   - AUTOENV_ENV_LEAVE_FILENAME,
#   - AUTOENV_ENABLE_LEAVE
# ------------------------------------------------------------------------------


# activation script
if [[ $SYS_NAME = "mac" ]]; then
    _autoenv_script_path="$BREW_HOME/opt/autoenv/activate.sh"
elif [[ $SYS_NAME = "linux" ]]; then
    _autoenv_script_path="${DOTFILES[HOME_DIR]}/.autoenv/autoenv.git/activate.sh"
fi

# apply config and activate autoenv
if [[ -f "$_autoenv_script_path" ]]; then

    # home
    local _autoenv_home_dir="${DOTFILES[HOME_DIR]}/.autoenv"
    [[ -d "$_autoenv_home_dir" ]] || mkdir -p "$_autoenv_home_dir"

    # envs
    export AUTOENV_AUTH_FILE="$_autoenv_home_dir/.autoenv_authorized"
    export AUTOENV_ENV_FILENAME=".env"
    export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
    export AUTOENV_ENABLE_LEAVE="1"

    # activate
    source "$_autoenv_script_path"
fi


# ------------------------------------------------------------------------------
# aws
#
# - references
#   - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# - envs
#   - AWS_CONFIG_FILE
#   - AWS_SHARED_CREDENTIALS_FILE
# ------------------------------------------------------------------------------


if type aws >"/dev/null"; then

    # home
    local _aws_home_dir="${DOTFILES[HOME_DIR]}/.aws"
    [[ -d "$_aws_home_dir" ]] || mkdir -p "$_aws_home_dir"

    # config
    local _aws_config_file_path="$_aws_home_dir/config"
    if [[ -f "$_aws_config_file_path" ]]; then
        export AWS_CONFIG_FILE="$_aws_config_file_path"
    fi

    # credentials
    local _aws_credentials_file_path="$_aws_home_dir/credentials"
    if [[ -f "$_aws_credentials_file_path" ]]; then
        export AWS_SHARED_CREDENTIALS_FILE="$_aws_credentials_file_path"
    fi
fi


# ------------------------------------------------------------------------------
# clojure
# ------------------------------------------------------------------------------


if type clojure >"/dev/null"; then

    # PATH
    if [[ $SYS_NAME = "mac" ]]; then
        export PATH="$PATH:/Applications/clojure"
    fi
fi


# ------------------------------------------------------------------------------
# docker
#
# - references
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# - envs
#   - DOCKER_CONFIG
#   - DOCKER_CERT_PATH
#
# dockerd
#
# - references
#   - https://docs.docker.com/reference/cli/dockerd/#environment-variables
#
# - envs
#   - DOCKER_CERT_PATH
# ------------------------------------------------------------------------------


if type docker >"/dev/null"; then

    # home
    local _docker_home_dir="${DOTFILES[HOME_DIR]}/.docker"
    [[ -d "$_docker_home_dir" ]] || mkdir -p "$_docker_home_dir"

    # config
    # Location of the client config file config.json (default ~/.docker)
    export DOCKER_CONFIG="$_docker_home_dir"

    # # credentials
    # local _docker_credential_file_path="$_docker_home_dir/<credential-file>"
    # if [[ -f "$_docker_credential_file_path" ]]; then
    #     export DOCKER_CERT_PATH="$_docker_credential_file_path"
    # fi

    # dockerd
    if type dockerd >"/dev/null"; then

        # config
        local _dockerd_config_file_path="$_docker_home_dir/daemon.json"
        if [[ -f "$_dockerd_config_file_path" ]]; then
            alias dockerd="dockerd --config-file $_dockerd_config_file_path "
        fi
    fi
fi


# ------------------------------------------------------------------------------
# emacs
#
# - references
#   - https://www.gnu.org/software/emacs/manual/html_node/emacs/Environment.html
#   - https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html
#
# - envs
#   - EMACS_HOME
# ------------------------------------------------------------------------------


if type emacs >"/dev/null"; then

    # home
    local _emacs_home_dir="${DOTFILES[HOME_DIR]}/.emacs"
    [[ -d "$_emacs_home_dir" ]] || mkdir -p "$_emacs_home_dir"
    export EMACS_HOME="$_emacs_home_dir"

    # config
    local _emacs_config_path="$_emacs_home/init.el"
    if [[ -f "$_emacs_config_path" ]]; then
        alias emacs='emacs -q --load "$_emacs_config_path"'
    fi

    # PATH
    local _emacs_bin_dir="$_emacs_home/bin"
    [[ -d "$_emacs_bin_dir" ]] && export PATH="$PATH:$_emacs_bin_dir"
fi


# ------------------------------------------------------------------------------
# elasticsearch
#
# - references
#   - https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-enroll-agent
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html#windows-service-settings
#
# - envs
#   - ES_JAVA_HOME
# ------------------------------------------------------------------------------


if type elasticsearch >"/dev/null"; then

    # java
    if [[ $SYS_NAME = "mac" ]]; then
        export ES_JAVA_HOME="$(/usr/libexec/java_home)"
    fi
fi


# ------------------------------------------------------------------------------
# gcp
#
# - references
#   - https://cloud.google.com/sdk/docs/configurations
#
# - envs
#   - CLOUDSDK_CONFIG
# ------------------------------------------------------------------------------


# home
local _gcp_home_dir="${DOTFILES[HOME_DIR]}/.gcp"

# path
local _gcp_path_script_path="$_gcp_home_dir/google-cloud-sdk/path.zsh.inc"
if [[ -f "$_gcp_path_script_path" ]]; then
    source "$_gcp_path_script_path"
fi

if type gcloud >"/dev/null"; then

    alias gcp="gcloud compute "

    # config
    local _gcp_config_dir="${DOTFILES[CONFIG_DIR]}/gcp"
    [[ -d "$_gcp_config_dir" ]] || mkdir -p "$_gcp_config_dir"
    export CLOUDSDK_CONFIG="$_gcp_config_dir"

    # completion
    local _gcp_comp_path="$_gcp_home_dir/google-cloud-sdk/completion.zsh.inc"
    if [[ -f "$_gcp_comp_path" ]]; then
        source "$_gcp_comp_path"
    fi
fi


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


if type go >"/dev/null"; then

    # home
    local _go_home_dir="${DOTFILES[HOME_DIR]}/.go"
    [[ -d "$_go_home_dir" ]] || mkdir -p "$_go_home_dir"

    # PATH
    export GOLIB="$_go_home_dir/golib"
    export GOCODE="$_go_home_dir/gocode"

    export GOPATH="$GOLIB:$GOCODE"
    export PATH="$GOLIB/bin:$PATH"
fi


# ------------------------------------------------------------------------------
# kubectl
#
# - references
#   - https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
#   - https://kubernetes.io/docs/reference/kubectl/kubectl/
#
# - envs
#   - KUBECONFIG
# ------------------------------------------------------------------------------


if type kubectl >"/dev/null"; then

    # home
    local _kube_home_dir="${DOTFILES[HOME_DIR]}/.kube"
    [[ -d "$_kube_home_dir" ]] || mkdir -p "$_kube_home_dir"

    # config
    local _kube_config_path="$_kube_home_dir/config"
    if [[ -f "$_kube_config_path" ]]; then
        export KUBECONFIG="$_kube_config_path:$KUBECONFIG"
    fi

    # cache
    local _kube_cache_dir="$_kube_home_dir/cache"
    [[ -d "$_kube_cache_dir" ]] || mkdir -p "$_kube_cache_dir"
    alias kubectl="kubectl --cache-dir $_kube_cache_dir "

    # complete
    local _kube_cmp_path="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_kubectl"
    [[ -f "$_kube_cmp_path" ]] ||  kubectl completion zsh > "$_kube_cmp_path"
fi


# ------------------------------------------------------------------------------
# openvpn
#
# - references
#   - https://openvpn.net/community-resources/reference-manual-for-openvpn-2-5/
# ------------------------------------------------------------------------------


if type openvpn >"/dev/null"; then

    # home
    local _openvpn_home_dir="${DOTFILES[HOME_DIR]}/.vpn"
    [[ -d "$_openvpn_home_dir" ]] || mkdir -p "$_openvpn_home_dir"

    # PATH
    if [[ $SYS_NAME = "mac" ]]; then

        local _openvpn_bin_dir="$BREW_HOME/opt/openvpn/sbin"
        [[ -d "$_openvpn_bin_dir" ]] && export PATH="$PATH:$_openvpn_bin_dir"
    fi
fi


# ------------------------------------------------------------------------------
# python
#
# - references
#   - https://docs.python.org/3/using/cmdline.html#environment-variables
#   - https://www.nltk.org/data.html
#
# - envs
#   - PYTHONSTARTUP
#
# pyenv
#
# - references
#   - https://github.com/pyenv/pyenv?tab=readme-ov-file#environment-variables
#
# - envs
#   - PYENV_ROOT
#
# ipython
#
# - references
#   - https://ipython.org/ipython-doc/3/config/intro.html#the-ipython-directory
#
# - envs
#   - IPYTHONDIR
# ------------------------------------------------------------------------------


if type python >"/dev/null" || type python3 >"/dev/null"; then


    # ----- python

    # alias
    alias py="python3 "
    alias python="python3 "
    alias pip="pip3 "

    # home
    local _python_home_dir="${DOTFILES[HOME_DIR]}/.python"
    [[ -d "$_python_home_dir" ]] || mkdir -p "$_python_home_dir"

    # config
    local _python_config_path="$_python_home_dir/.pythonrc"
    if [[ -f "$_python_config_path" ]]; then
        export PYTHONSTARTUP="$_python_config_path"
    fi

    # function
    function py-clean() {

        # Remove python compiled byte-code and mypy/pytest cache in either the current
        # directory or in a list of specified directories (including sub directories).

        local _zsh_pyclean_places=${*:-'.'}
        find ${_zsh_pyclean_places} -type f -name "*.py[co]" -delete
        find ${_zsh_pyclean_places} -type d -name "__pycache__" -delete
        find ${_zsh_pyclean_places} -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
        find ${_zsh_pyclean_places} -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
    }

    # nltk
    local _nltk_data_dir="$_python_home_dir/nltk_data"
    [[ -d "$_nltk_data_dir" ]] || mkdir -p "$_nltk_data_dir"
    export NLTK_DATA="$_nltk_data_dir"


    # ----- pyenv

    if type pyenv >"/dev/null" || [[ -d "$_python_home_dir/.pyenv/pyenv.git" ]]; then

        # home
        local _pyenv_home_dir="$_python_home_dir/.pyenv"
        [[ -d "$_pyenv_home_dir" ]] || mkdir -p "$_pyenv_home_dir"

        # root
        if [[ -d "$_pyenv_home_dir/pyenv.git" ]]; then
            export PYENV_ROOT="$_pyenv_home_dir/pyenv.git"
        else
            export PYENV_ROOT="$_pyenv_home_dir"
        fi

        # PATH
        local _pyenv_bin_dir="$PYENV_ROOT/bin"
        [[ -d "$_pyenv_bin_dir" ]] && export PATH="$_pyenv_bin_dir:$PATH"

        # shims
        local _pyenv_shims_path="$_pyenv_home_dir/shims"
        [[ -d "$_pyenv_shims_path" ]] || mkdir -p "$_pyenv_shims_path"

        # lazy load pyenv
        pyenv() {
            unset -f pyenv
            eval "$(command pyenv init -)"
            eval "$(command pyenv virtualenv-init -)"
            pyenv $@
        }

        # link brew installed python
        if type brew >"/dev/null"; then
            pyenv-ln-brew(){
                ln -s "$(brew --cellar python)/*" "$_pyenv_home_dir/versions/"
            }
        fi
    fi


    # ----- ipython

    # home
    local _ipython_home_dir="$_python_home_dir/.ipython"
    [[ -d "$_ipython_home_dir" ]] || mkdir -p "$_ipython_home_dir"

    # root
    export IPYTHONDIR="$_ipython_home_dir"

    # ipython use the same version as python
    alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
fi


# ------------------------------------------------------------------------------
# ssh
#
# - references
#   - https://man7.org/linux/man-pages/man1/ssh.1.html
#
# - envs
#   - SSH_HOME
#   - GIT_SSH_COMMAND
# ------------------------------------------------------------------------------


if type ssh >"/dev/null"; then

    # home
    local _ssh_home_dir="${DOTFILES[HOME_DIR]}/.ssh"
    [[ -d "$_ssh_home_dir" ]] || mkdir -p "$_ssh_home_dir"
    export SSH_HOME="$_ssh_home_dir"

    # config
    local _ssh_config_path="$_ssh_home_dir/config"
    local _ssh_known_hosts_path="$_ssh_home_dir/known_hosts"

    if [[ -f "$_ssh_config_path" ]]; then
        local _ssh_cmd="ssh -F $_ssh_config_path -o UserKnownHostsFile=$_ssh_known_hosts_path "
    else
        local _ssh_cmd="ssh -o UserKnownHostsFile=$_ssh_known_hosts_path "
    fi

    # command
    export GIT_SSH_COMMAND="$_ssh_cmd"
    alias ssh="$_ssh_cmd"
fi


# ------------------------------------------------------------------------------
# tmux
#
# - references
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
# ------------------------------------------------------------------------------


if type tmux >"/dev/null"; then

    # config
    local _tmux_config_path="${DOTFILES[CONFIG_DIR]}/tmux/.tmux.conf"
    if [[ -f "$_tmux_config_path" ]]; then
        alias tmux="tmux -f $_tmux_config_path"
    fi
fi


# ------------------------------------------------------------------------------
# vim
#
# - envs
#   - VIM_HOME
#   - VIMINIT
# ------------------------------------------------------------------------------


if type vim >"/dev/null"; then

    # home
    local _vim_home_dir="${DOTFILES[HOME_DIR]}/.vim"
    [[ -d "$_vim_home_dir" ]] || mkdir -p "$_vim_home_dir"
    export VIM_HOME="$_vim_home_dir"

    # config
    local _vim_config_path="$_vim_home_dir/.vimrc"
    if [[ -f "$_vim_config_path" ]]; then
        export VIMINIT="source $_vim_config_path"
    fi
fi

# mac
if [[ $SYS_NAME = "mac" ]]; then

    # use vim installed by brew
    local _mac_vim_bin_path="$BREW_HOME/bin/vim"
    if [[ -f "$_mac_vim_bin_path" ]]; then
        alias vi="$_mac_vim_bin_path "
        alias vim="$_mac_vim_bin_path "
    fi
fi


# ------------------------------------------------------------------------------
# volta
# ------------------------------------------------------------------------------


if type volta >"/dev/null"; then

    # home
    local _volta_home_dir="${DOTFILES[HOME_DIR]}/.volta"
    [[ -d "$_volta_home_dir" ]] || mkdir -p "$_volta_home_dir"

    # PATH
    local _volta_bin_dir="$_volta_home_dir/bin"
    [[ -d "$_volta_bin_dir" ]] && export PATH="$_volta_bin_dir:$PATH"
fi
