#!/bin/zsh


# ------------------------------------------------------------------------------
# autoenv
#
# - references
#   - https://github.com/hyperupcall/autoenv
#
# - envs
#   - AUTOENV_AUTH_FILE
#   - AUTOENV_ENV_FILENAME
#   - AUTOENV_ENV_LEAVE_FILENAME
#   - AUTOENV_ENABLE_LEAVE
# ------------------------------------------------------------------------------


function _dotfiles_init_autoenv(){

    # activation script
    if [[ $SYS_NAME = "mac" ]]; then
        local _autoenv_script_path="$BREW_HOME/opt/autoenv/activate.sh"
    elif [[ $SYS_NAME = "linux" ]]; then
        local _autoenv_script_path="${DOTFILES[HOME_DIR]}/.autoenv/autoenv.git/activate.sh"
    fi

    # apply config and activate autoenv
    if [[ -f $_autoenv_script_path ]]; then

        # home
        local _autoenv_home_dir="${DOTFILES[HOME_DIR]}/.autoenv"
        [[ -d $_autoenv_home_dir ]] || mkdir -p $_autoenv_home_dir

        # envs
        export AUTOENV_AUTH_FILE="$_autoenv_home_dir/.autoenv_authorized"
        export AUTOENV_ENV_FILENAME=".env"
        export AUTOENV_ENV_LEAVE_FILENAME=".env.leave"
        export AUTOENV_ENABLE_LEAVE="1"

        # activate
        source $_autoenv_script_path
    fi
}

_dotfiles_init_autoenv


# ------------------------------------------------------------------------------
# elasticsearch
#
# - references
#   - https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-enroll-agent
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html#windows-service-settings
#
# - envs
#   - ES_HOME
#   - ES_JAVA_HOME
# ------------------------------------------------------------------------------


function _dotfiles_init_es(){

    # elasticsearch home
    if [[ $SYS_NAME = "mac" ]]; then
        local _es_home_dir="${DOTFILES[HOME_DIR]}/.es/es"
    elif [[ $SYS_NAME = "linux" ]]; then
        local _es_home_dir="/usr/share/elasticsearch/"
    fi

    # set up
    if type elasticsearch >"/dev/null" || [[ -d "$_es_home_dir" ]]; then

        # home
        [[ -d $_es_home_dir ]] || mkdir -p $_es_home_dir
        export ES_HOME=$_es_home_dir

        # path
        local _es_bin_dir="$ES_HOME/bin"
        [[ -d $_es_bin_dir ]] && export PATH="$PATH:$_es_bin_dir"

        # java
        if [[ $SYS_NAME = "mac" ]]; then
            export ES_JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home)}"
        fi
    fi
}

_dotfiles_init_es
