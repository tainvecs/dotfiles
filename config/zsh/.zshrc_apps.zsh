# ------------------------------------------------------------------------------
# autoenv
# ------------------------------------------------------------------------------


# activation script
if [[ $SYS_NAME = "mac" ]]; then
    AUTOENV_SCRIPT_PATH="$BREW_HOME/opt/autoenv/activate.sh"
elif [[ $SYS_NAME = "linux" ]]; then
    AUTOENV_SCRIPT_PATH="${DOTFILES[HOME_DIR]}/.autoenv/autoenv.git/activate.sh"
fi

# apply config and activate autoenv
if [[ -f "$AUTOENV_SCRIPT_PATH" ]]; then

    # home
    AUTOENV_HOME="${DOTFILES[HOME_DIR]}/.autoenv"
    [[ -d "$AUTOENV_HOME" ]] || mkdir -p "$AUTOENV_HOME"
    export AUTOENV_HOME

    # config
    export AUTOENV_AUTH_FILE="$AUTOENV_HOME/.autoenv_authorized"
    export AUTOENV_ENV_FILENAME=".env"
    export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
    export AUTOENV_ENABLE_LEAVE="1"

    # activate
    source "$AUTOENV_SCRIPT_PATH"
fi


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


if type aws >"/dev/null"; then

    # home
    AWS_HOME="${DOTFILES[HOME_DIR]}/.aws"
    [[ -d "$AWS_HOME" ]] || mkdir -p "$AWS_HOME"
    export AWS_HOME

    # config
    AWS_CONFIG_FILE="$AWS_HOME/config"
    if [[ -f "$AWS_CONFIG_FILE" ]]; then
        export AWS_CONFIG_FILE
    fi

    # credentials
    AWS_CREDENTIAL_FILE="$AWS_HOME/credentials"
    if [[ -f "$AWS_CREDENTIAL_FILE" ]]; then
        export AWS_SHARED_CREDENTIALS_FILE="$AWS_CREDENTIAL_FILE"
        export AWS_CREDENTIAL_PROFILES_FILE="$AWS_CREDENTIAL_FILE"
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
# ------------------------------------------------------------------------------


if type docker >"/dev/null"; then

    # home
    DOCKER_HOME="${DOTFILES[HOME_DIR]}/.docker"
    [[ -d "$DOCKER_HOME" ]] || mkdir -p "$DOCKER_HOME"
    export DOCKER_HOME

    # config
    # Location of the client config file config.json (default ~/.docker)
    export DOCKER_CONFIG="$DOCKER_HOME"

    # # credentials
    # if [[ -f "$DOCKER_HOME/<credentials-file>" ]]; then
    #     export DOCKER_CERT_PATH="$DOCKER_HOME/<credentials-file>"
    # fi

    # dockerd
    if type dockerd >"/dev/null"; then

        # config
        if [[ -f "$DOCKER_HOME/daemon.json" ]]; then
            alias dockerd="dockerd --config-file $DOCKER_HOME/daemon.json "
        fi
    fi
fi


# ------------------------------------------------------------------------------
# emacs
# ------------------------------------------------------------------------------


if type emacs >"/dev/null"; then

    # home
    EMACS_HOME="${DOTFILES[HOME_DIR]}/.emacs"
    [[ -d "$EMACS_HOME" ]] || mkdir -p "$EMACS_HOME"
    export EMACS_HOME

    # # config
    # if [[ -f "$EMACS_HOME/init.el" ]]; then
    #     alias emacs='emacs -q --load "$EMACS_HOME/init.el"'
    # fi

    # PATH
    if [[ -d "$EMACS_HOME/bin" ]]; then
        export PATH="$PATH:$EMACS_HOME/bin"
    fi
fi


# ------------------------------------------------------------------------------
# elasticsearch
# ------------------------------------------------------------------------------


if type elasticsearch >"/dev/null"; then

    # java
    if [[ $SYS_NAME = "mac" ]]; then
        export ES_JAVA_HOME="$(/usr/libexec/java_home)"
    fi
fi


# ------------------------------------------------------------------------------
# gcp
# ------------------------------------------------------------------------------


# home
GCP_HOME="${DOTFILES[HOME_DIR]}/.gcp"

# path
GCP_PATH_FILE="$GCP_HOME/google-cloud-sdk/path.zsh.inc"
if [[ -f "$GCP_PATH_FILE" ]]; then
    source "$GCP_PATH_FILE"
fi

if type gcloud >"/dev/null"; then

    alias gcp="gcloud compute "

    # config
    GCP_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/gcp"
    [[ -d "$GCP_CONFIG_DIR" ]] || mkdir -p "$GCP_CONFIG_DIR"
    export CLOUDSDK_CONFIG="$GCP_CONFIG_DIR"

    # completion
    GCP_COMP_FILE="$GCP_HOME/google-cloud-sdk/completion.zsh.inc"
    if [[ -f "$GCP_COMP_FILE" ]]; then
        source "$GCP_COMP_FILE"
    fi
fi


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


if type go >"/dev/null"; then

    # home
    GO_HOME="${DOTFILES[HOME_DIR]}/.go"
    [[ -d "$GO_HOME" ]] || mkdir -p "$GO_HOME"
    export GO_HOME

    # PATH
    export GOLIB="$GO_HOME/golib"
    export GOCODE="$GO_HOME/gocode"

    export GOPATH="$GOLIB:$GOCODE"
    export PATH="$GOLIB/bin:$PATH"
fi


# ------------------------------------------------------------------------------
# kubectl
# ------------------------------------------------------------------------------


if type kubectl >"/dev/null"; then

    # home
    KUBE_HOME="${DOTFILES[HOME_DIR]}/.kube"
    [[ -d "$KUBE_HOME" ]] || mkdir -p "$KUBE_HOME"
    export KUBE_HOME

    # config
    if [[ -f "$KUBE_HOME/config" ]]; then
        export KUBECONFIG="$KUBE_HOME/config:$KUBECONFIG"
    fi

    # cache
    [[ -d "$KUBE_HOME/cache" ]] || mkdir -p "$KUBE_HOME/cache"
    alias kubectl="kubectl --cache-dir $KUBE_HOME/cache "

    # complete
    ZSH_COMPLETE_DIR="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete"
    KUBE_COMPLETE_FILE="$ZSH_COMPLETE_DIR/_kubectl"
    [[ -f "$KUBE_COMPLETE_FILE" ]] ||  kubectl completion zsh > "$KUBE_COMPLETE_FILE"
fi


# ------------------------------------------------------------------------------
# openvpn
# ------------------------------------------------------------------------------


if type openvpn >"/dev/null"; then

    # home
    OPENVPN_HOME="${DOTFILES[HOME_DIR]}/.vpn"
    [[ -d "$OPENVPN_HOME" ]] || mkdir -p "$OPENVPN_HOME"
    export OPENVPN_HOME

    # PATH
    if [[ $SYS_NAME = "mac" ]]; then
        OPENVPN_DIR="$BREW_HOME/opt/openvpn"
        OPENVPN_BIN_DIR="$OPENVPN_DIR/sbin"
        [[ -d "$OPENVPN_BIN_DIR" ]] && export PATH="$PATH:$OPENVPN_BIN_DIR"
    fi
fi


# ------------------------------------------------------------------------------
# python, ipython, and pyenv
# ------------------------------------------------------------------------------


if type python >"/dev/null" || type python3 >"/dev/null"; then


    # ----- python

    # home
    PYTHON_HOME="${DOTFILES[HOME_DIR]}/.python"
    [[ -d "$PYTHON_HOME" ]] || mkdir -p "$PYTHON_HOME"
    export PYTHON_HOME

    # config
    if [[ -f "$PYTHON_HOME/.pythonrc" ]]; then
        export PYTHONSTARTUP="$PYTHON_HOME/.pythonrc"
    fi

    # alias
    alias py="python3 "
    alias python="python3 "
    alias pip="pip3 "

    # function
    function py-clean() {

        # Remove python compiled byte-code and mypy/pytest cache in either the current
        # directory or in a list of specified directories (including sub directories).

        ZSH_PYCLEAN_PLACES=${*:-'.'}
        find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
        find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
        find ${ZSH_PYCLEAN_PLACES} -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
        find ${ZSH_PYCLEAN_PLACES} -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
    }

    # nltk
    export NLTK_DATA="$PYTHON_HOME/nltk_data"
    [[ -d "$NLTK_DATA" ]] || mkdir -p "$NLTK_DATA"


    # ----- pyenv

    if type pyenv >"/dev/null" || [[ -d "$PYTHON_HOME/.pyenv/pyenv.git" ]]; then

        # home
        PYENV_HOME="$PYTHON_HOME/.pyenv"
        [[ -d "$PYENV_HOME" ]] || mkdir -p "$PYENV_HOME"
        export PYENV_HOME

        # root
        if [[ -d "$PYENV_HOME/pyenv.git" ]]; then
            export PYENV_ROOT="$PYENV_HOME/pyenv.git"
            export PATH="$PYENV_ROOT/bin:$PATH"
        else
            export PYENV_ROOT="$PYENV_HOME"
        fi

        # shims
        PYENV_SHIMS_PATH="$PYENV_HOME/shims"
        [[ -d "$PYENV_SHIMS_PATH" ]] || mkdir -p "$PYENV_SHIMS_PATH"

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
                ln -s "$(brew --cellar python)/*" "$PYENV_HOME/versions/"
            }
        fi
    fi


    # ----- ipython

    # home
    IPYTHON_HOME="$PYTHON_HOME/.ipython"
    [[ -d "$IPYTHON_HOME" ]] || mkdir -p "$IPYTHON_HOME"
    export IPYTHON_HOME

    # root
    export IPYTHONDIR="$IPYTHON_HOME"

    # ipython use the same version as python
    alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
fi


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


if type ssh >"/dev/null"; then

    # home
    SSH_HOME="${DOTFILES[HOME_DIR]}/.ssh"
    [[ -d "$SSH_HOME" ]] || mkdir -p "$SSH_HOME"
    export SSH_HOME

    # config
    if [[ -f "$SSH_HOME/config" ]]; then
        SSH_CMD="ssh -F $SSH_HOME/config -o UserKnownHostsFile=$SSH_HOME/known_hosts "
    else
        SSH_CMD="ssh -o UserKnownHostsFile=$SSH_HOME/known_hosts "
    fi

    alias ssh="$SSH_CMD"
    export GIT_SSH_COMMAND="$SSH_CMD"
fi


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------


if type tmux >"/dev/null"; then

    # config
    TMUX_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/tmux"
    [[ -d "$TMUX_CONFIG_DIR" ]] || mkdir -p "$TMUX_CONFIG_DIR"
    export TMUX_CONFIG_DIR

    if [[ -f "$TMUX_CONFIG_DIR/.tmux.conf" ]]; then
        alias tmux="tmux -f $TMUX_CONFIG_DIR/.tmux.conf"
    fi
fi


# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------


if type vim >"/dev/null"; then

    # home
    VIM_HOME="${DOTFILES[HOME_DIR]}/.vim"
    [[ -d "$VIM_HOME" ]] || mkdir -p "$VIM_HOME"
    export VIM_HOME

    # config
    if [[ -f "$VIM_HOME/.vimrc" ]]; then
        export VIMINIT="source $VIM_HOME/.vimrc"
    fi
fi

# mac: use vim installed by brew
if [[ -f "$BREW_HOME/bin/vim" ]]; then
    alias vi="$BREW_HOME/bin/vim "
    alias vim="$BREW_HOME/bin/vim "
fi


# ------------------------------------------------------------------------------
# volta
# ------------------------------------------------------------------------------


if type volta >"/dev/null"; then

    # home
    VOLTA_HOME="${DOTFILES[HOME_DIR]}/.volta"
    [[ -d "$VOLTA_HOME" ]] || mkdir -p "$VOLTA_HOME"
    export VOLTA_HOME

    # PATH
    if [[ -d "$VOLTA_HOME/bin" ]]; then
        export PATH="$VOLTA_HOME/bin:$PATH"
    fi
fi
