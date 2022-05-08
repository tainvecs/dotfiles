# ------------------------------------------------------------------------------
# autoenv
# ------------------------------------------------------------------------------


# activation script
if [[ $SYS_NAME == mac ]]; then
    AUTOENV_SCRIPT_PATH="$BREW_HOME/opt/autoenv/activate.sh"
elif [[ $SYS_NAME == linux ]]; then
    AUTOENV_SCRIPT_PATH="${DOTFILES[HOME_DIR]}/.autoenv/autoenv.git/activate.sh"
fi

# apply config and activate autoenv
if [[ -f $AUTOENV_SCRIPT_PATH ]]; then

    # home
    export AUTOENV_HOME="${DOTFILES[HOME_DIR]}/.autoenv"

    # config
    export AUTOENV_AUTH_FILE="$AUTOENV_HOME/.autoenv_authorized"
    export AUTOENV_ENV_FILENAME=".env"
    export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
    export AUTOENV_ENABLE_LEAVE="1"

    # activate
    source $AUTOENV_SCRIPT_PATH

fi


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


if type aws >/dev/null; then

    export AWS_HOME="${DOTFILES[HOME_DIR]}/.aws"

    if [[ -f "$AWS_HOME/config" ]]; then
        export AWS_CONFIG_FILE=$AWS_HOME/config
    fi

    if [[ -f "$AWS_HOME/credentials" ]]; then
        export AWS_SHARED_CREDENTIALS_FILE="$AWS_HOME/credentials"
        export AWS_CREDENTIAL_PROFILES_FILE="$AWS_HOME/credentials"
    fi

fi


# ------------------------------------------------------------------------------
# docker
# ------------------------------------------------------------------------------


if type docker >/dev/null; then

    export DOCKER_HOME="${DOTFILES[HOME_DIR]}/.docker"

    if [[ -d "$DOCKER_HOME" ]]; then
        export DOCKER_CONFIG="$DOCKER_HOME"
    fi

    # if [[ -f "$DOCKER_HOME/<credentials-file>" ]]; then
    #     export DOCKER_CERT_PATH="$DOCKER_HOME/<credentials-file>"
    # fi

    if type dockerd >/dev/null; then

        if [[ -f "$DOCKER_HOME/daemon.json" ]]; then

            alias dockerd="dockerd --data-root $DOCKER_HOME --config-file $DOCKER_HOME/daemon.json "

        fi

    fi
fi


# ------------------------------------------------------------------------------
# emacs
# ------------------------------------------------------------------------------


if type emacs >/dev/null; then

    export EMACS_HOME="${DOTFILES[HOME_DIR]}/.emacs"

    if [[ -f "$EMACS_HOME/init.el" ]]; then
        alias emacs='emacs -q --load "$EMACS_HOME/init.el"'
    fi

fi


# ------------------------------------------------------------------------------
# gcp
# ------------------------------------------------------------------------------

# home
GCP_HOME="${DOTFILES[HOME_DIR]}/.gcp"

# path
GCP_PATH_FILE="$GCP_HOME/google-cloud-sdk/path.zsh.inc"
if [ -f $GCP_PATH_FILE ]; then
    source $GCP_PATH_FILE
fi

if type gcloud >/dev/null; then

    # config
    GCP_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/gcp"
    export CLOUDSDK_CONFIG=$GCP_CONFIG_DIR

    # completion
    GCP_COMP_FILE="$GCP_HOME/google-cloud-sdk/completion.zsh.inc"

    if [ -f $GCP_COMP_FILE ]; then
        source $GCP_COMP_FILE
    fi

    alias gcp="gcloud compute "

fi


# ------------------------------------------------------------------------------
# go
# ------------------------------------------------------------------------------


if type go >/dev/null; then

    export GO_HOME="${DOTFILES[HOME_DIR]}/.go"

    export GOLIB=$GO_HOME/golib
    export GOCODE=$GO_HOME/gocode

    export GOPATH=$GOLIB:$GOCODE
    export PATH=$GOLIB/bin:$PATH

fi


# ------------------------------------------------------------------------------
# kubectl
# ------------------------------------------------------------------------------


if type kubectl >/dev/null; then

    export KUBE_HOME="${DOTFILES[HOME_DIR]}/.kube"

    # config
    if [[ -f "$KUBE_HOME/config" ]]; then
        export KUBECONFIG=$KUBE_HOME/config:$KUBECONFIG
    fi

    # cache
    [[ -d "$KUBE_HOME/cache" ]] || madir -p "$KUBE_HOME/cache"
    alias kubectl="kubectl --cache-dir $KUBE_HOME/cache "

    ZSH_COMPLETE_DIR="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete"
    KUBE_COMPLETE_FILE="$ZSH_COMPLETE_DIR/_kubectl"

    [[ -f $KUBE_COMPLETE_FILE ]] ||  kubectl completion zsh > $KUBE_COMPLETE_FILE

fi


# ------------------------------------------------------------------------------
# openvpn
# ------------------------------------------------------------------------------


if type openvpn >/dev/null; then

    # home
    OPENVPN_HOME="${DOTFILES[HOME_DIR]}/.vpn"

    # PATH
    OPENVPN_DIR="$BREW_HOME/opt/openvpn"
    OPENVPN_BIN_DIR="$OPENVPN_DIR/sbin"
    [[ -d $OPENVPN_BIN_DIR ]] && export PATH="$PATH:$OPENVPN_BIN_DIR"

fi


# ------------------------------------------------------------------------------
# python, ipython, and pyenv
# ------------------------------------------------------------------------------


if type python >/dev/null || type python3 >/dev/null; then


    # ----- python

    # home
    export PYTHON_HOME="${DOTFILES[HOME_DIR]}/.python"

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
    [[ -d $NLTK_DATA ]] || mkdir -p $NLTK_DATA


    # ----- pyenv

    if type pyenv >/dev/null || [[ -d "$PYTHON_HOME/.pyenv/pyenv.git" ]]; then

        # home
        export PYENV_HOME="$PYTHON_HOME/.pyenv"

        # root
        if [[ -d "$PYENV_HOME/pyenv.git" ]]; then
            export PYENV_ROOT="$PYENV_HOME/pyenv.git"
            PATH="$PYENV_ROOT/bin:$PATH"
        else
            export PYENV_ROOT=$PYENV_HOME
        fi

        # shims
        PYENV_SHIMS_PATH="$PYENV_HOME/shims"
        [[ -d $PYENV_SHIMS_PATH ]] || mkdir -p $PYENV_SHIMS_PATH
        PATH="$PYENV_SHIMS_PATH:$PATH"

        # lazy load pyenv
        pyenv() {
            unset -f pyenv
            eval "$(command pyenv init -)"
            eval "$(command pyenv virtualenv-init -)"
            pyenv $@
        }

        # link brew installed python
        if type brew >/dev/null; then
            pyenv-ln-brew(){
                ln -s $(brew --cellar python)/* $PYENV_HOME/versions/
            }
        fi

    fi


    # ----- ipython

    # home
    export IPYTHON_HOME="$PYTHON_HOME/.ipython"

    # root
    export IPYTHONDIR=$IPYTHON_HOME

    # ipython use the same version as python
    alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"


    export PATH

fi


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


if type ssh >/dev/null; then

    # home
    export SSH_HOME="${DOTFILES[HOME_DIR]}/.ssh"

    # config
    if [[ -f "$SSH_HOME/config" ]]; then
        SSH_CMD="ssh -F $SSH_HOME/config -o UserKnownHostsFile=$SSH_HOME/known_hosts "
        alias ssh=$SSH_CMD
    else
        SSH_CMD="ssh -o UserKnownHostsFile=$SSH_HOME/known_hosts "
    fi

    export GIT_SSH_COMMAND=$SSH_CMD

fi


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------


if type tmux >/dev/null; then

    # config
    export TMUX_CONFIG_DIR="${DOTFILES[CONFIG_DIR]}/tmux"
    if [[ -f "$TMUX_CONFIG_DIR/.tmux.conf" ]]; then
        alias tmux="tmux -f $TMUX_CONFIG_DIR/.tmux.conf"
    fi

fi


# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------


if type vim >/dev/null; then

    # home
    export VIM_HOME="${DOTFILES[HOME_DIR]}/.vim"

    # config
    if [[ -f "$VIM_HOME/.vimrc" ]]; then
        export VIMINIT="source $VIM_HOME/.vimrc"
    fi

fi

# mac: use vim installed by brew
if [[ -f $BREW_HOME/bin/vim ]]; then
    alias vi="$BREW_HOME/bin/vim "
    alias vim="$BREW_HOME/bin/vim "
fi


# ------------------------------------------------------------------------------
# volta
# ------------------------------------------------------------------------------


# home
export VOLTA_HOME="${DOTFILES[HOME_DIR]}/.volta"

if [[ -d $VOLTA_HOME/bin ]]; then
    export PATH=$VOLTA_HOME/bin:$PATH
fi
