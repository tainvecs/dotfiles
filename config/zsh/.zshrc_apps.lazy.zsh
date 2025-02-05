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
