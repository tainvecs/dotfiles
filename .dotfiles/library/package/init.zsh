#!/bin/zsh


#------------------------------------------------------------------------------
#
# Utility Functions for Package Configuration Setup and Initialization
#
#
# Version: 0.0.1
# Last Modified: 2025-06-21
#
# Dependencies:
#   - Environment Variable File
#     - .dotfiles/env/return_code.env
#
#   - Environment Variables
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - BREW_HOME
#
#   - Library:
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#     - $DOTFILES_DOT_LIB_DIR/dotfiles/util.zsh
#
#------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# autoenv: automatically source environment variables
#
# - References
#   - https://github.com/hyperupcall/autoenv
#
# - Environment Variables
#   - AUTOENV_AUTH_FILE
#   - AUTOENV_ENV_FILENAME
#   - AUTOENV_ENV_LEAVE_FILENAME
#   - AUTOENV_ENABLE_LEAVE
#   - AUTOENV_NOTAUTH_FILE
#   - AUTOENV_VIEWER
#
# - Dependencies
#   - (optional) bat
#
# ------------------------------------------------------------------------------


function dotfiles_init_autoenv() {

    local _package_name="autoenv"

    # activation script
    local _init_script_path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _init_script_path="$BREW_HOME/opt/$_package_name/activate.sh"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _init_script_path="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name/$_package_name.git/activate.sh"
    fi

    # sanity check
    if [[ ! -f $_init_script_path ]]; then
        log_dotfiles_package_installation "$_package_name" "fail"
        return $RC_ERROR
    fi

    # home
    local _state_dir="$DOTFILES_LOCAL_STATE_DIR/$_package_name"
    ensure_directory "$_state_dir"

    # envs
    export AUTOENV_AUTH_FILE="$_state_dir/.autoenv_authorized"
    export AUTOENV_NOTAUTH_FILE="$_state_dir/.autoenv_not_authorized"
    export AUTOENV_ENV_FILENAME=".env"
    export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
    export AUTOENV_ENABLE_LEAVE="yes"

    if command_exists "bat"; then
        export AUTOENV_VIEWER="bat"
    fi

    # lazy-load autoenv only when `cd` is used
    function _lazy_load_autoenv() {
        add-zsh-hook -d chpwd _lazy_load_autoenv  # Remove hook before unfunctioning
        unfunction _lazy_load_autoenv             # Remove trigger after first use
        source "$_init_script_path"
        cd "$PWD"                                 # Trigger autoenv
    }

    # set a hook on `cd` to load autoenv only when used
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _lazy_load_autoenv
}


# ------------------------------------------------------------------------------
#
# aws: AWS Command Line Interface
#
# - References
#   - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# - Environment Variables
#   - AWS_CONFIG_FILE
#   - AWS_SHARED_CREDENTIALS_FILE
#
# ------------------------------------------------------------------------------


function dotfiles_init_aws() {

    local _package_name="aws"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_installation "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" "config" "$_package_name" "config")
    if [[ $? == $RC_SUCCESS ]]; then
        export AWS_CONFIG_FILE="$_config_link"
    fi

    # user credentials
    local _cred_link=$(link_dotfiles_user_credential_to_local "$_package_name" "credentials" "$_package_name" "credentials")
    if [[ $? == $RC_SUCCESS ]]; then
        export AWS_SHARED_CREDENTIALS_FILE="$_cred_link"
    fi
}


# ------------------------------------------------------------------------------
#
# bat
#
# - References
#   - https://github.com/sharkdp/bat
#
# - Environment Variables
#   - BAT_CONFIG_DIR
#   - BAT_CONFIG_PATH
#   - MANPAGER
#
# - Remark
#   - bat --generate-config-file
#   - bat --list-languages
#   - bat --list-themes
#
# batextra
#   - batgrep
#   - batman
#   - prettybat
#
# - References
#   - https://github.com/eth-p/bat-extras
#   - https://github.com/eth-p/bat-extras/blob/master/doc/prettybat.md#languages
#
# - Dependencies
#   - (optional) shfmt
#   - (optional) yq
#
# ------------------------------------------------------------------------------


function dotfiles_init_bat() {

    local _package_name="bat"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" "bat.conf" "$_package_name" "bat.conf")
    if [[ $? == $RC_SUCCESS ]]; then
        export BAT_CONFIG_PATH="$_config_link"
    fi

    # highlighting --help, -h and man
    alias -g -- --help='--help 2>&1 | bat --language=help --style=plain '
    alias -g -- -h='-h 2>&1 | bat --language=help --style=plain '
    export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

    # prettybat
    # dependency: yq (optional), shfmt (optional)
    if command_exists "prettybat"; then
        alias bat="prettybat "
    fi
}


# ------------------------------------------------------------------------------
#
# delta: a git, diff and grep syntax-highlighting pager
#
# - References
#   - https://github.com/dandavison/delta
#
# ------------------------------------------------------------------------------


function dotfiles_init_delta() {

    local _package_name="delta"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    alias diff="delta --line-numbers --side-by-side "
}


# ------------------------------------------------------------------------------
#
# docker: use OS-level virtualization to deliver software in containers
#
# - References
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# - Environment Variables
#   - DOCKER_CONFIG
#   - DOCKER_DEFAULT_PLATFORM
#
# - Dependencies
#   - curl
#   - gpg
#
# docker compose: a tool for defining and running multi-container applications
#
# - References
#   - https://docs.docker.com/compose/
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


function dotfiles_init_docker() {

    local _package_name="docker"
    local _package_plugin_name="docker-compose"

    # sanity check
    if ! is_supported_system_archt; then
        log_dotfiles_package_initialization "$_package_name" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi

    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    if ! command_exists "$_package_plugin_name"; then
        log_dotfiles_package_initialization "$_package_plugin_name" "fail"
        return $RC_ERROR
    fi

    # env
    export DOCKER_DEFAULT_PLATFORM="linux/$DOTFILES_SYS_ARCHT"

    # user config
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" "config.json" "$_package_name" "config.json")
    if [[ $? == $RC_SUCCESS ]]; then
        export DOCKER_CONFIG="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    fi

    # dockerd daemon user config
    if command_exists "dockerd"; then
        local _d_config_link=$(link_dotfiles_user_config_to_local "$_package_name" "daemon.json" "$_package_name" "daemon.json")
        if [[ $? == $RC_SUCCESS ]]; then
            alias dockerd="dockerd --config-file $_d_config_link "
        fi
    fi
}


# ------------------------------------------------------------------------------
#
# duf: a better 'df' alternative (Disk Usage/Free Utility)
#
# - References
#   - https://github.com/muesli/duf
#
# ------------------------------------------------------------------------------


function dotfiles_init_duf() {

    local _package_name="duf"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    alias df="duf -width 200 "
}


# ------------------------------------------------------------------------------
#
# dust: a more intuitive version of du in rust
#
# - References
#   - https://github.com/bootandy/dust
#
# ------------------------------------------------------------------------------


function dotfiles_init_dust() {

    local _package_name="dust"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    alias du="dust -r "
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
#   - $DOTFILES_LOCAL_CONFIG_DIR/emacs/bin
#
# ------------------------------------------------------------------------------


function dotfiles_init_emacs() {

    local _package_name="emacs"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # dotfiles config
    local _config_link=$(link_dotfiles_dot_config_to_local "$_package_name" "init.el" "$_package_name" "init.el")
    if [[ $? -ne $RC_SUCCESS ]]; then
        log_message "Failed to setup dotfiles emacs init.el." "error"
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi
    alias emacs="emacs -q --load \"$_config_link\" "

    # user config
    link_dotfiles_user_config_to_local "$_package_name" "init.el" "$_package_name" "init.local.el"

    # user history
    link_dotfiles_local_history_to_user "$_package_name" "history" "emacs.history"

    # home and path
    local _home_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    export EMACS_HOME=$_home_dir
    append_dir_to_path "PATH" "$_home_dir/bin"
}


# ------------------------------------------------------------------------------
#
# extract: supporting a wide variety of archive filetypes
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
#
# ------------------------------------------------------------------------------


function dotfiles_init_extract() {

    local _package_name="extract"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    zinit ice wait"2" lucid
    zinit light "$_package_name"

    alias x="extract "
}


# ------------------------------------------------------------------------------
#
# eza: a modern alternative to ls
#
# - References
#   - https://github.com/eza-community/eza
#   - https://github.com/eza-community/eza-themes
#
# ------------------------------------------------------------------------------


function dotfiles_init_eza() {

    local _package_name="eza"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # alias
    alias l="eza -l --total-size --color auto --color-scale size --icons auto --time-style '+%Y-%m-%d %H:%M' "
    alias ls="eza -l --color auto --color-scale size --icons auto --time-style '+%Y-%m-%d %H:%M' "
    alias la="eza -la --color auto --color-scale size --icons auto --time-style '+%Y-%m-%d %H:%M' "
    alias ll="eza -laT -L=2 --color auto --color-scale size --icons auto --time-style '+%Y-%m-%d %H:%M' "

    # TODO: custom eza theme
    # https://github.com/eza-community/eza-themes
}


# ------------------------------------------------------------------------------
#
# fast-syntax-highlighting: feature-rich syntax highlighting for ZSH
#
# - References
#   - https://github.com/zdharma-continuum/fast-syntax-highlighting
#
# ------------------------------------------------------------------------------


function dotfiles_init_fast-syntax-highlighting() {

    local _package_name="fast-syntax-highlighting"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    zinit ice wait"0b" lucid
    zinit light "$_package_name"
}


# ------------------------------------------------------------------------------
#
# fd: a fast and user-friendly alternative to 'find'
#
# - References
#   - https://github.com/sharkdp/fd
#
# ------------------------------------------------------------------------------


function dotfiles_init_fd() {

    local _package_name="fd"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    alias fd="fd --follow --hidden --ignore-case --color=always --exclude .git "
}


# ------------------------------------------------------------------------------
#
# forgit: a utility tool powered by fzf for using git interactively
#
# - References
#   - https://github.com/wfxr/forgit
#
# - Environment Variables
#   - FORGIT_LOG_GRAPH_ENABLE
#   - FORGIT_NO_ALIASES
#
# - Dependencies
#   - fzf
#   - (optional) bat
#   - (optional) delta
#   - (optional) tree
#
# ------------------------------------------------------------------------------


function dotfiles_init_forgit() {

    local _package_name="forgit"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # forgit
    export FORGIT_LOG_GRAPH_ENABLE=false
    export FORGIT_NO_ALIASES=true

    zinit ice wait"1" lucid
    zinit light "$_package_name"
}


# ------------------------------------------------------------------------------
#
# fzf: a command-line fuzzy finder
#
# - References
#   - https://github.com/junegunn/fzf
#   - https://github.com/Aloxaf/fzf-tab
#
# - Environment Variables
#   - FZF_DEFAULT_COMMAND
#   - FZF_DEFAULT_OPTS
#
# - Dependencies
#   - (optional) bat
#   - (optional) chafa
#   - (optional) fd
#
# ------------------------------------------------------------------------------


function dotfiles_init_fzf() {

    local _package_name="fzf"
    local _package_plugin_name="fzf-tab"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # fzf
    # dependency: fd (optional)
    if command_exists "fd"; then
        export FZF_DEFAULT_COMMAND="fd --follow --hidden --ignore-case --color=always --exclude .git "
    fi
    export FZF_DEFAULT_OPTS="--layout=reverse --ansi "

    alias fzf="fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}' "

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name" }; then
        log_dotfiles_package_initialization "$_package_plugin_name" "fail"
        return $RC_ERROR
    fi

    # fzf-tab
    zinit ice wait"1" lucid
    zinit light "$_package_plugin_name"
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


function dotfiles_init_gcp() {

    local _package_name="gcp"

    # sanity check
    if ! command_exists "gcloud"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    alias gcp="gcloud compute "

    # user config
    link_dotfiles_user_config_to_local "$_package_name" "config_default" "$_package_name" "configurations/config_default"
    export CLOUDSDK_CONFIG="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
}


# ------------------------------------------------------------------------------
#
# git
#
# - References
#   - https://github.com/dandavison/delta
#
# - Dependencies
#   - (optional) delta, themes.gitconfig
#
# ------------------------------------------------------------------------------


function dotfiles_init_git() {

    local _package_name="git"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # delta
    if command_exists "delta"; then

        # themes.gitconfig
        link_dotfiles_share_config_to_local "delta" "themes.gitconfig" "$_package_name" "themes.gitconfig"

        # delta.gitconfig
        link_dotfiles_user_config_to_local "delta" "config" "$_package_name" "delta.gitconfig"
        if [[ $? != $RC_SUCCESS ]]; then
            link_dotfiles_dot_config_to_local "delta" "config" "$_package_name" "delta.gitconfig"
        fi
    fi

    # git
    link_dotfiles_dot_config_to_local "$_package_name" "config" "$_package_name" "config"
    link_dotfiles_user_config_to_local "$_package_name" "config" "$_package_name" "user.gitconfig"
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


function dotfiles_init_go() {

    local _package_name="go"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # home
    local _home_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"
    ensure_directory $_home_dir

    # env
    export GOLIB="$_home_dir/golib"
    export GOCODE="$_home_dir/gocode"
    export GOPATH="$GOLIB:$GOCODE"

    # path
    local _bin_dir="$GOLIB/bin"
    ensure_directory "$_bin_dir"
    append_dir_to_path "PATH" "$_bin_dir"
}


# ------------------------------------------------------------------------------
#
# htop: an interactive process viewer
#
# - References
#   - https://github.com/htop-dev/htop
#
# ------------------------------------------------------------------------------


function dotfiles_init_htop() {

    local _package_name="htop"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config
    link_dotfiles_user_config_to_local "$_package_name" "htoprc" "$_package_name" "htoprc"
}


# ------------------------------------------------------------------------------
#
# hyperfine: a command-line benchmarking tool
#
# - References
#   - https://github.com/sharkdp/hyperfine
#
# ------------------------------------------------------------------------------


function dotfiles_init_hyperfine() {

    local _package_name="hyperfine"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # alias
    alias bm="hyperfine "
    alias bm-zsh='hyperfine "zsh -i -c exit" '
}


# ------------------------------------------------------------------------------
#
# keyd: keyboard remapping (linux only)
#
# - References
#   - https://github.com/rvaiya/keyd
#
# ------------------------------------------------------------------------------


function dotfiles_init_keyd() {

    local _package_name="keyd"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_initialization "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config
    link_dotfiles_user_config_to_local "$_package_name" "default.conf" "$_package_name" "default.conf"
}


# ------------------------------------------------------------------------------
#
# kubectl: Kubernetes command line interface
#
# - References
#   - https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
#   - https://kubernetes.io/docs/reference/kubectl/kubectl/
#
# - Environment Variables
#   - KUBECONFIG
#
# ------------------------------------------------------------------------------


function dotfiles_init_kubectl() {

    local _package_name="kubectl"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config and credentials
    local _config_link=$(link_dotfiles_user_credential_to_local "$_package_name" "config" "$_package_name" "config")
    if [[ $? == $RC_SUCCESS ]]; then
        export KUBECONFIG="$_config_link:$KUBECONFIG"
    fi

    # cache
    local _cache_dir="$DOTFILES_LOCAL_CACHE_DIR/$_package_name"
    ensure_directory "$_cache_dir"
    alias kubectl="kubectl --cache-dir $_cache_dir "
}


# ------------------------------------------------------------------------------
#
# nvitop: an interactive NVIDIA-GPU process viewer
#
# - References
#   - https://github.com/XuehaiPan/nvitop
#
# - Environment Variables
#   - LOGLEVEL
#   - NVITOP_MONITOR_MODE
#
# ------------------------------------------------------------------------------


function dotfiles_init_nvitop() {

    local _package_name="nvitop"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    export NVITOP_MONITOR_MODE="full,colorful,dark"
}


# ------------------------------------------------------------------------------
#
# peco: simplistic interactive filtering tool
#
# - References
#   - https://github.com/peco/peco
#
# ------------------------------------------------------------------------------


function dotfiles_init_peco() {

    local _package_name="peco"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # user config
    link_dotfiles_user_config_to_local "$_package_name" "config.json" "$_package_name" "config.json"
}


# ------------------------------------------------------------------------------
#
# powerlevel10k: zsh theme customization
#
# - References
#   - https://github.com/romkatv/powerlevel10k
#
# - Environment Variables
#   - POWERLEVEL9K_INSTANT_PROMPT
#
# ------------------------------------------------------------------------------


function dotfiles_init_powerlevel10k() {

    local _package_name="powerlevel10k"

    # export POWERLEVEL9K_INSTANT_PROMPT=quiet

    # ----- cache
    # p10k: should stay close to the top of ~/.zshrc.
    local _cache_script_path="${DOTFILES_LOCAL_CACHE_DIR:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    [[ -r $_cache_script_path ]] && source $_cache_script_path

    # ----- user config
    # load powerlevel10k theme
    # to customize prompt, run `p10k configure` or edit user/powerlevel10k/p10k.zsh.
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" "p10k.zsh" "$_package_name" "p10k.zsh")
    if [[ -f $_config_link ]]; then
        source $_config_link
    fi
}


# ------------------------------------------------------------------------------
#
# python: Python programming language
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
# ipython: python interactive commmand line shell
#
# - References
#   - https://ipython.org/ipython-doc/3/config/intro.html#the-ipython-directory
#
# - Environment Variables
#   - IPYTHONDIR
#
# pyenv: python version management tool
#
# - References
#   - https://github.com/pyenv/pyenv?tab=readme-ov-file#environment-variables
#
# - Environment Variables
#   - PYENV_ROOT
#
# ------------------------------------------------------------------------------


function dotfiles_init_python() {

    local _package_name="python"
    local _package_plugin_name="pyenv"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # ----- python
    local _package_home_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    ensure_directory "$_package_home_dir"

    # user config
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" ".pythonrc" "$_package_name" ".pythonrc")
    if [[ $? == $RC_SUCCESS ]]; then
        export PYTHONSTARTUP=$_config_link
    fi

    # app name, local history, user history
    dotfiles_user_link_local_history "$_package_name" ".python_history" "$_package_name.history"

    # nltk data directory
    local _nltk_data_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name/nltk_data"
    ensure_directory "$_nltk_data_dir"
    export NLTK_DATA=$_nltk_data_dir

    # ipython
    local _ipython_home_dir="$_package_home_dir/ipython"
    ensure_directory "$_ipython_home_dir"
    export IPYTHONDIR=$_ipython_home_dir
    alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()' "

    # ----- pyenv
    local _package_plugin_home_dir="$_package_home_dir/$_package_plugin_name"
    local _package_plugin_git_dir="$_package_plugin_home_dir/$_package_plugin_name.git"

    if command_exists "$_package_plugin_name" || [[ -d $_package_plugin_git_dir ]]; then

        # git dir for linux and home for macos
        if [[ -d $_package_plugin_git_dir ]]; then
            export PYENV_ROOT="$_package_plugin_git_dir"
        else
            export PYENV_ROOT="$_package_plugin_home_dir"
        fi

        # path
        local _package_plugin_bin_dir="$PYENV_ROOT/bin"
        prepend_dir_to_path "PATH" "$_package_plugin_bin_dir"

        # shims
        local _package_plugin_shims_dir="$PYENV_ROOT/shims"
        ensure_directory "$_package_plugin_shims_dir"

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
                ln -s "$(brew --cellar python)/*" "$_package_plugin_home_dir/versions/"
            }
        fi
    fi
}


# ------------------------------------------------------------------------------
#
# ripgrep: recursively searches directories for a regex pattern
#   while respecting your gitignore
#
# - References
#   - https://github.com/BurntSushi/ripgrep
#
# - Environment Variables
#   - RIPGREP_CONFIG_PATH
#
# - Dependencies
#   - (optional) bat
#   - (optional) bat-extras, batgrep
#
# ------------------------------------------------------------------------------


function dotfiles_init_ripgrep() {

    local _package_name="ripgrep"

    # sanity check
    if ! command_exists "rg"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # rg
    alias rg="rg -p --hidden --no-follow --max-columns 255 --column --glob '!.git' "

    # batgrep
    # dependency: bat-extras
    if command_exists "batgrep"; then
        alias rgb="batgrep -p --hidden --no-follow --glob '!.git' "
    fi

    # user config
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" ".ripgreprc" "$_package_name" ".ripgreprc")
    if [[ $? == $RC_SUCCESS ]]; then
        export RIPGREP_CONFIG_PATH="$_config_link"
    fi
}


# ------------------------------------------------------------------------------
#
# ssh: a network protocol that provides a secure way
#      to access and manage remote computers
#
# - References
#   - https://man7.org/linux/man-pages/man1/ssh.1.html
#
# - Environment Variables
#   - SSH_HOME
#   - GIT_SSH_COMMAND
#
# ------------------------------------------------------------------------------


function dotfiles_init_ssh() {

    local _package_name="ssh"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # home
    local _home_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    ensure_directory "$_home_dir"
    export SSH_HOME=$_home_dir

    # known host
    local _known_host_path="$_home_dir/known_hosts"

    # user config
    local _user_config_link=$(link_dotfiles_user_config_to_local "$_package_name" "config" "$_package_name" "config")

    # keys
    local _credentials_link=$(link_dotfiles_user_credential_to_local "ssh" "keys" "ssh" "keys")

    # ssh cmd alias
    local _cmd="ssh -o UserKnownHostsFile=$_known_host_path "
    if [[ -f $_user_config_link ]]; then
        _cmd="ssh -F $_user_config_link -o UserKnownHostsFile=$_known_host_path "
    fi
    alias ssh=$_cmd
    export GIT_SSH_COMMAND=$_cmd
}


# ------------------------------------------------------------------------------
#
# tmux
#
# - References
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# - Environment Variables
#   - TMUX_CONF (used by oh-my-zsh)
#   - TMUX_CONF_LOCAL (used by oh-my-zsh)
#
# ------------------------------------------------------------------------------


function dotfiles_init_tmux() {

    local _package_name="tmux"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # dot config
    local _dot_config_link=$(link_dotfiles_dot_config_to_local "$_package_name" "tmux.conf" "$_package_name" "tmux.conf")
    if [[ $? -ne $RC_SUCCESS ]]; then
        log_message "Failed to setup dotfiles $_package_name dot config" "error"
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi
    export TMUX_CONF=$_dot_config_link

    # user config
    local _user_config_link=$(link_dotfiles_user_config_to_local "$_package_name" ".tmux.conf" "$_package_name" "tmux.local.conf")
    if [[ $? == $RC_SUCCESS ]]; then
        export TMUX_CONF_LOCAL=$_user_config_link
    fi
}


# ------------------------------------------------------------------------------
#
# universalarchive: a convenient command-line interface for archiving files
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/universalarchive
#
# ------------------------------------------------------------------------------


function dotfiles_init_universalarchive() {

    local _package_name="universalarchive"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    zinit ice wait"2" lucid
    zinit light "$_package_name"

    alias a="ua "
}


# ------------------------------------------------------------------------------
#
# vim: a text editors
#
# - References
#   - https://www.vim.org/docs.php
#
# - Environment Variables
#   - VIM_HOME
#   - VIM_LOCAL_CONFIG_PATH
#   - VIMINIT
#
# ------------------------------------------------------------------------------


function dotfiles_init_vim() {

    local _package_name="vim"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # home
    local _home_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    ensure_directory "$_home_dir"
    export VIM_HOME=$_home_dir

    # dot config
    local _dot_config_link=$(link_dotfiles_dot_config_to_local "$_package_name" ".vimrc" "$_package_name" ".vimrc")
    if [[ $? -ne $RC_SUCCESS ]]; then
        log_message "Failed to setup dotfiles $_package_name dot config" "error"
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi
    export VIMINIT="source $_dot_config_link"

    # user config
    local _user_config_link=$(link_dotfiles_user_config_to_local "$_package_name" ".vimrc" "$_package_name" ".local.vimrc")
    if [[ $? == $RC_SUCCESS ]]; then
        export VIM_LOCAL_CONFIG_PATH="$_user_config_link"
    fi

    # macs alias
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        local _mac_bin_path="$BREW_HOME/bin/vim"
        if [[ -f $_mac_bin_path ]]; then
            alias vi=$_mac_bin_path
            alias vim=$_mac_bin_path
        fi
    fi
}


# ------------------------------------------------------------------------------
#
# volta: JavaScript tool manager
#
# - References
#   - https://volta.sh/
#   - https://github.com/npm/npm/issues/14528
#
# - Environment Variables
#   - NPM_CONFIG_USERCONFIG
#   - VOLTA_HOME
#
# - PATH
#   - $VOLTA_HOME/bin
#
# ------------------------------------------------------------------------------


function dotfiles_init_volta() {

    local _package_name="volta"

    # home
    local _home_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    export VOLTA_HOME=$_home_dir

    # sanity check
    if ! command_exists "$_package_name" && ! [[ -f "$_home_dir/bin/volta" ]]; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # path
    append_dir_to_path "PATH" "$_home_dir/bin"

    # npm user config
    local _npm_home_dir="$_home_dir/npm"
    ensure_directory "$_npm_home_dir"

    # user config
    local _user_config_link=$(link_dotfiles_user_config_to_local "$_package_name" ".npmrc" "$_package_name" "volta.user.npmrc")
    if [[ $? == $RC_SUCCESS ]]; then
        export NPM_CONFIG_USERCONFIG="$_user_config_link"
    fi
}


# ------------------------------------------------------------------------------
#
# wget: retrieving files using HTTP, HTTPS, FTP and FTPS
#
# - References
#   - https://www.gnu.org/software/wget/manual/html_node/HTTPS-_0028SSL_002fTLS_0029-Options.html
#
# ------------------------------------------------------------------------------


function dotfiles_init_wget() {

    local _package_name="wget"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # HSTS file configuration
    local _state_dir="$DOTFILES_LOCAL_STATE_DIR/$_package_name"
    ensure_directory "$_state_dir"
    local _hsts_file_path="$_state_dir/.wget-hsts"
    alias wget="wget --hsts-file $_hsts_file_path "
}


# ------------------------------------------------------------------------------
#
# zoxide: a smarter cd command
#
# - References
#   - https://github.com/ajeetdsouza/zoxide
#   - https://github.com/ajeetdsouza/zoxide/tree/main?tab=readme-ov-file#installation
#
# - Environment Variables
#   - _ZO_DATA_DIR
#   - _ZO_ECHO
#   - _ZO_RESOLVE_SYMLINKS
#
# ------------------------------------------------------------------------------


function dotfiles_init_zoxide() {

    local _package_name="zoxide"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # env
    local _data_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"
    [[ -d "$_data_dir" ]] || mkdir -p "$_data_dir"

    export _ZO_DATA_DIR="$_data_dir"
    export _ZO_ECHO=0
    export _ZO_RESOLVE_SYMLINKS=1

    # use cd and z for directory jump
    # it will trigger the autoenv with cd
    function j() {
        local _z_dir=$(zoxide query "$@")
        if [[ -n "$_z_dir" ]]; then
            cd "$_z_dir"
        fi
    }
}


# ------------------------------------------------------------------------------
#
# zsh-autosuggestions: command line auto-completion
#
# - References
#   - https://github.com/zsh-users/zsh-autosuggestions
#   - https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/config.zsh
#
# - Environment Variables
#   - ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE
#   - ZSH_AUTOSUGGEST_COMPLETION_IGNORE
#   - ZSH_CUSTOM
#
# ------------------------------------------------------------------------------


function dotfiles_init_zsh-autosuggestions() {

    local _package_name="zsh-autosuggestions"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # init
    zinit ice wait"0a" lucid
    zinit light "$_package_name"

    # env
    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

    # user config to override the default config
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/config.zsh
    local _config_link=$(link_dotfiles_user_config_to_local "$_package_name" "config.zsh" "$_package_name" "config.zsh")
    if [[ $? == $RC_SUCCESS ]]; then
        export ZSH_CUSTOM="$_config_link"
    fi
}


# ------------------------------------------------------------------------------
#
# zsh-completions: additional completion definitions for Zsh
#
# - References
#   - https://github.com/zsh-users/zsh-completions
#
# ------------------------------------------------------------------------------


function dotfiles_init_zsh-completions() {

    local _package_name="zsh-completions"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_name" }; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    local _dot_lib_zsh_cmp_path="$DOTFILES_DOT_LIB_DIR/zsh/completion.zsh"

    zinit ice wait"1" lucid
    zinit light "$_package_name"
}
