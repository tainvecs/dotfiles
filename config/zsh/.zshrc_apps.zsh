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


function _dotfiles_init_aws(){

    if type aws >"/dev/null"; then

        # home
        local _aws_home_dir="${DOTFILES[HOME_DIR]}/.aws"
        [[ -d $_aws_home_dir ]] || mkdir -p $_aws_home_dir

        # config
        local _aws_config_file_path="$_aws_home_dir/config"
        if [[ -f $_aws_config_file_path ]]; then
            export AWS_CONFIG_FILE=$_aws_config_file_path
        fi

        # credentials
        local _aws_credentials_file_path="$_aws_home_dir/credentials"
        if [[ -f $_aws_credentials_file_path ]]; then
            export AWS_SHARED_CREDENTIALS_FILE=$_aws_credentials_file_path
        fi
    fi
}

_dotfiles_init_aws


# ------------------------------------------------------------------------------
# clojure
# ------------------------------------------------------------------------------


function _dotfiles_init_clojure(){

    if type clojure >"/dev/null"; then

        # home
        local _clj_home_dir="${DOTFILES[HOME_DIR]}/.clojure"
        [[ -d $_clj_home_dir ]] || mkdir -p $_clj_home_dir

        export CLJ_CONFIG=$_clj_home_dir

        # .m2
        alias clojure="clojure -Sdeps '{:mvn/local-repo \"$XDG_CACHE_HOME/maven/repository\"}' "

        # PATH
        if [[ $SYS_NAME = "mac" ]]; then
            export PATH="$PATH:/Applications/clojure"
        fi
    fi
}

_dotfiles_init_clojure


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


function _dotfiles_init_docker(){

    if type docker >"/dev/null"; then

        # ----- home
        local _docker_home_dir="${DOTFILES[HOME_DIR]}/.docker"
        [[ -d $_docker_home_dir ]] || mkdir -p $_docker_home_dir

        # ----- config
        # Location of the client config file config.json (default ~/.docker)
        export DOCKER_CONFIG=$_docker_home_dir
        export DOCKER_DEFAULT_PLATFORM="linux/$SYS_ARCHT"

        # ----- dockerd
        if type dockerd >"/dev/null"; then

            # config
            local _dockerd_config_file_path="$_docker_home_dir/daemon.json"
            if [[ -f $_dockerd_config_file_path ]]; then
                alias dockerd="dockerd --config-file $_dockerd_config_file_path "
            fi
        fi

        # ----- completion

        # docker
        local _docker_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_docker"
        local _docker_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_docker"

        if [[ ! -f $_docker_cmp_path ]]; then
            curl -fLo $_docker_cmp_path \
                 "https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker"
        fi
        [[ -L $_docker_cmp_link || -f $_docker_cmp_link ]] || ln -s $_docker_cmp_path $_docker_cmp_link

        # docker compose
        local _docker_comp_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_docker-compose"
        local _docker_comp_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_docker-compose"

        if [[ ! -f $_docker_comp_cmp_path ]]; then
            curl -fLo $_docker_comp_cmp_path \
                 "https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"
        fi
        [[ -L $_docker_comp_cmp_link || -f $_docker_comp_cmp_link ]] || ln -s $_docker_comp_cmp_path $_docker_comp_cmp_link
    fi
}

_dotfiles_init_docker


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


function _dotfiles_init_emacs(){

    if type emacs >"/dev/null"; then

        # home
        local _emacs_home_dir="${DOTFILES[HOME_DIR]}/.emacs"
        [[ -d $_emacs_home_dir ]] || mkdir -p $_emacs_home_dir
        export EMACS_HOME=$_emacs_home_dir

        # config
        local _emacs_config_path="$_emacs_home_dir/init.el"
        if [[ -f $_emacs_config_path ]]; then
            alias emacs="emacs -q --load \"$_emacs_config_path\" "
        fi

        # PATH
        local _emacs_bin_dir="$_emacs_home_dir/bin"
        [[ -d $_emacs_bin_dir ]] && export PATH="$PATH:$_emacs_bin_dir"
    fi
}

_dotfiles_init_emacs


# ------------------------------------------------------------------------------
# gcp
#
# - references
#   - https://cloud.google.com/sdk/docs/configurations
#
# - envs
#   - CLOUDSDK_CONFIG
# ------------------------------------------------------------------------------


function _dotfiles_init_gcp(){

    # home
    local _gcp_home_dir="${DOTFILES[HOME_DIR]}/.gcp"

    # path
    local _gcp_path_script_path="$_gcp_home_dir/google-cloud-sdk/path.zsh.inc"
    if [[ -f $_gcp_path_script_path ]]; then
        source $_gcp_path_script_path
    fi

    if type gcloud >"/dev/null"; then

        alias gcp="gcloud compute "

        # config
        local _gcp_config_dir="${DOTFILES[CONFIG_DIR]}/gcp"
        [[ -d $_gcp_config_dir ]] || mkdir -p $_gcp_config_dir
        export CLOUDSDK_CONFIG=$_gcp_config_dir

        # completion
        local _gcp_cmp_script_path="$_gcp_home_dir/google-cloud-sdk/completion.zsh.inc"
        if [[ -f $_gcp_cmp_script_path ]]; then
            local _gcp_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/gcp.zsh.inc"
            local _gcp_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/gcp.zsh.inc"
            [[ -L $_gcp_cmp_path || -f $_gcp_cmp_path ]] || ln -s $_gcp_cmp_script_path $_gcp_cmp_path
            [[ -L $_gcp_cmp_link || -f $_gcp_cmp_link ]] || ln -s $_gcp_cmp_path $_gcp_cmp_link
         fi
    fi
}

_dotfiles_init_gcp


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


_dotfiles_init_go(){

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
}

_dotfiles_init_go


# ------------------------------------------------------------------------------
# keyd
#
# - reference
#   - https://github.com/rvaiya/keyd
# ------------------------------------------------------------------------------


_dotfiles_init_keyd(){

    if type keyd >"/dev/null" && [[ $SYS_NAME = "linux" ]]; then

        # config
        KEYD_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/keyd"

        KEYD_CONFIG_LINK="/etc/keyd/default.conf"
        KEYD_CONFIG_FILE="$KEYD_CONFIG_DIR/default.conf"
        if [[ ! -f $KEYD_CONFIG_LINK ]] && [[ -f $KEYD_CONFIG_FILE ]]; then
            sudo ln -s $KEYD_CONFIG_FILE $KEYD_CONFIG_LINK
            sudo keyd reload
        fi
    fi
}

_dotfiles_init_keyd


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


_dotfiles_init_kube(){

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

        # completion
        local _kube_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_kubectl"
        local _kube_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_kubectl"
        [[ -f $_kube_cmp_path ]] || kubectl completion zsh > $_kube_cmp_path
        [[ -L $_kube_cmp_link || -f $_kube_cmp_link ]] || ln -s $_kube_cmp_path $_kube_cmp_link
    fi
}

_dotfiles_init_kube


# ------------------------------------------------------------------------------
# openvpn
#
# - references
#   - https://openvpn.net/community-resources/reference-manual-for-openvpn-2-5/
# ------------------------------------------------------------------------------


_dotfiles_init_openvpn(){

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
}

_dotfiles_init_openvpn


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


_dotfiles_init_python(){

    if type python >"/dev/null" || type python3 >"/dev/null"; then

        # ----- python

        # alias
        alias py="python3 "
        alias python="python3 "
        alias pip="pip3 "

        # home
        local _python_home_dir="${DOTFILES[HOME_DIR]}/.python"
        [[ -d "$_python_home_dir" ]] || mkdir -p "$_python_home_dir"
        export PYTHON_HISTORY="$_python_home_dir/.python_history"

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
}

_dotfiles_init_python


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


_dotfiles_init_ssh(){

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
}

_dotfiles_init_ssh


# ------------------------------------------------------------------------------
# tmux
#
# - references
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# - envs
#   - TMUX_CONFIG_PATH
#   - TMUX_CONFIG_LOCAL_PATH
# ------------------------------------------------------------------------------


_dotfiles_init_tmux(){

    if type tmux >"/dev/null"; then

        # config
        local _tmux_config_path="${DOTFILES[CONFIG_DIR]}/tmux/.tmux.conf"
        local _tmux_config_local_path="${DOTFILES[CONFIG_DIR]}/tmux/.tmux.conf.local"

        if [[ -f "$_tmux_config_path" ]]; then
            alias tmux="tmux -f $_tmux_config_path"
            export TMUX_CONFIG_PATH="$_tmux_config_path"
        fi
        if [[ -f "$_tmux_config_local_path" ]]; then
            export TMUX_CONFIG_LOCAL_PATH="$_tmux_config_local_path"
        fi
    fi
}

_dotfiles_init_tmux


# ------------------------------------------------------------------------------
# vim
#
# - envs
#   - VIM_HOME
#   - VIMINIT
# ------------------------------------------------------------------------------


_dotfiles_init_vim(){

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
}

_dotfiles_init_vim


# ------------------------------------------------------------------------------
# volta
#
# - references
#   - https://github.com/npm/npm/issues/14528
# ------------------------------------------------------------------------------


_dotfiles_init_volta(){

    local _volta_home_dir="${DOTFILES[HOME_DIR]}/.volta"
    local _volta_bin_dir="$_volta_home_dir/bin"

    if { type volta >"/dev/null" } || [[ -d $_volta_bin_dir ]]; then

        # ----- volta
        # home
        [[ -d "$_volta_home_dir" ]] || mkdir -p "$_volta_home_dir"
        export VOLTA_HOME=$_volta_home_dir

        # PATH
        export PATH="$PATH:$_volta_bin_dir"

        # ----- npm
        # home
        local _volta_npm_home_dir="$_volta_home_dir/npm"
        [[ -d "$_volta_npm_home_dir" ]] || mkdir -p "$_volta_npm_home_dir"

        # config
        local _volta_npm_config_path="$_volta_npm_home_dir/.npmrc"

        if [[ -f $_volta_npm_config_path ]]; then
            export NPM_CONFIG_USERCONFIG=$_volta_npm_config_path
        fi
    fi
}

_dotfiles_init_volta


# ------------------------------------------------------------------------------
# wget
#
# - references
#   - https://www.gnu.org/software/wget/manual/html_node/HTTPS-_0028SSL_002fTLS_0029-Options.html
# ------------------------------------------------------------------------------


_dotfiles_init_wget(){


    if type wget >"/dev/null"; then

        # home
        local _wget_home_dir="${DOTFILES[HOME_DIR]}/.wget"
        [[ -d "$_wget_home_dir" ]] || mkdir -p "$_wget_home_dir"

        # hsts file
        local _wget_hsts_file_path="$_wget_home_dir/.wget-hsts"
        alias wget="wget --hsts-file $_wget_hsts_file_path "
    fi
}

_dotfiles_init_wget
