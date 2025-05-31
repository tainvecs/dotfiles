#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions
#
#
# Version: 0.0.11
# Last Modified: 2025-05-31
#
# - Dependency
#   - Environment Variable File
#     - .dotfiles/env/color.env
#     - .dotfiles/env/misc.env
#
#   - Environment Variable
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - DOTFILES_APP_ASC_ARR
#     - DOTFILES_PLUGIN_ASC_ARR
#     - DOTFILES_XDG_CONFIG_DIR
#     - DOTFILES_XDG_STATE_DIR
#     - DOTFILES_DOT_CONFIG_DIR
#     - DOTFILES_USER_CONFIG_DIR
#     - DOTFILES_USER_SECRET_DIR
#     - DOTFILES_USER_HIST_DIR
#     - B_RED
#     - B_YELLOW
#     - B_GREEN
#     - COLOR_OFF
#
#   - Return Codes
#     - RC_SUCCESS
#     - RC_ERROR
#     - RC_SKIPPED
#     - RC_UNSUPPORTED
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# Application
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - RC_SUCCESS
#     - RC_ERROR
#     - RC_UNSUPPORTED
#
#   - Function
#     - dotfiles_logging
#     - command_exists
#     - is_app_installed
#     - log_app_installation
#
#   - App
#     - brew (mac)
#     - apt-get (linux)
#     - curl
#     - grep
#     - cut
#     - echo
#
# ------------------------------------------------------------------------------


# $1: GitHub username
# $2: GitHub repository name
function get_github_release_latest_version() {

    # Input checking
    if [[ -z "$1" ]]; then
        dotfiles_logging "\$1 (GitHub username) not provided." "error"
        return $RC_ERROR
    elif [[ -z "$2" ]]; then
        dotfiles_logging "\$2 (GitHub repository name) not provided." "error"
        return $RC_ERROR
    fi

    # Retrieve information from GitHub repo release page
    local _url="https://api.github.com/repos/$1/$2/releases"
    local _resp=$(curl -s "$_url")
    if [[ $? -ne 0 ]]; then
        dotfiles_logging "Failed to fetch data from $_url" "error"
        return $RC_ERROR
    fi

    # Parse response
    local _parsed_ver=$(echo "$_resp" | grep -m 1 tag_name | cut -d '"' -f 4)

    # Result
    if [[ -n "$_parsed_ver" ]]; then
        echo "$_parsed_ver"
        return $RC_SUCCESS
    else
        dotfiles_logging "No release version found for GitHub Project $1/$2." "warn"
        return $RC_ERROR
    fi
}

# Install applications
# $@: Package names
function install_apps() {

    # Check input
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return $RC_ERROR
    fi

    # Check for --update flag
    local _update_flag=false
    if [[ "$1" == "--update" ]]; then
        _update_flag=true
        shift
    fi

    # Install app(s) with apt (linux) or brew (mac)
    for _app_name in "$@"; do

        case $DOTFILES_SYS_NAME in

            "linux")

                if ! {command_exists "$_app_name" || is_app_installed "$_app_name"}; then

                    log_app_installation "$_app_name" "install"

                    if sudo apt-get install --no-install-recommends --no-install-suggests -y "$_app_name"; then
                        log_app_installation "$_app_name" "success"
                    else
                        log_app_installation "$_app_name" "fail"
                    fi

                elif $_update_flag; then

                    log_app_installation "$_app_name" "update"

                    if sudo apt install --only-upgrade "$_app_name"; then
                        log_app_installation "$_app_name" "success"
                    else
                        log_app_installation "$_app_name" "fail"
                    fi

                else
                    log_app_installation "$_app_name" "skip"
                    continue
                fi ;;

            "mac")

                if ! {command_exists "$_app_name" || is_app_installed "$_app_name"}; then

                    log_app_installation "$_app_name" "install"

                    if brew install "$_app_name"; then
                        log_app_installation "$_app_name" "success"
                    else
                        log_app_installation "$_app_name" "fail"
                    fi

                elif $_update_flag; then

                    log_app_installation "$_app_name" "update"

                    if brew upgrade "$_app_name"; then
                        log_app_installation "$_app_name" "success"
                    else
                        log_app_installation "$_app_name" "fail"
                    fi

                else
                    log_app_installation "$_app_name" "skip"
                    continue
                fi ;;

            *)
                log_app_installation "$_app_name" "sys-name-not-supported"
                return $RC_UNSUPPORTED ;;
        esac
    done
}

# Check if an application is installed.
# Returns 0 if installed, non-zero otherwise.
function is_app_installed() {

    # Check input
    local _app_name
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return $RC_ERROR
    else
        _app_name="$1"
    fi

    # Check if an app is installed using dpkg-query (linux) or brew (mac)
    case $DOTFILES_SYS_NAME in

        "linux")
            dpkg-query -s "$_app_name" &>/dev/null ;;
        "mac")
            brew list "$_app_name" --quiet &>/dev/null ;;
        *)
            log_app_installation "$_app_name" "sys-name-not-supported"
            return $RC_UNSUPPORTED ;;
    esac

    # explicitly return success
    return $?
}

# Print app initialization message
# $1: package name
# $2: function code ("fail", "success", "sys-name-not-supported", "sys-archt-not-supported")
function log_app_initialization() {

    local _app_name=$1
    local _status=$2

    case $_status in

        "fail")
            dotfiles_logging "Failed to initialization \"$_app_name\"." "error" ;;

        "success")
            dotfiles_logging "Successfully initialized \"$_app_name\"." "info" ;;

        "sys-name-not-supported")
            dotfiles_logging "\"$_app_name\" not initialized. \"$_app_name\" is not supported for '$DOTFILES_SYS_NAME'." "warn" ;;

        "sys-archt-not-supported")
            dotfiles_logging "\"$_app_name\" not initialized. \"$_app_name\" is not supported for '$DOTFILES_SYS_ARCHT'." "warn" ;;

        *)
            dotfiles_logging "log_app_initialization: Invalid status code \"$_status\"" "error"

            echo "Usage: log_app_initialization <app_name> <status>"
            echo '  <status> should be one of: "fail", "success", "sys-name-not-supported", "sys-archt-not-supported".' ;;
    esac
}

# Print app installation message
# $1: package name
# $2: function code ("install", "skip", "fail", "success",
#                    "sys-archt-not-supported", "sys-name-not-supported", "dependency-missing")
function log_app_installation() {

    local _app_name=$1
    local _status=$2

    case $_status in

        "install")
            dotfiles_logging "Start \"$_app_name\" installation." "info" ;;

        "skip")
            dotfiles_logging "Skip \"$_app_name\" installation as it is already installed." "info" ;;

        "update")
            dotfiles_logging "\"$_app_name\" is already installed. Checking for update." "info" ;;

        "fail")
            dotfiles_logging "Failed to install/update \"$_app_name\"." "error" ;;

        "success")
            dotfiles_logging "Successfully installed/updated \"$_app_name\"." "info" ;;

        "sys-name-not-supported")
            dotfiles_logging "\"$_app_name\" not installed. \"$_app_name\" is not supported for '$DOTFILES_SYS_NAME'." "warn" ;;

        "sys-archt-not-supported")
            dotfiles_logging "\"$_app_name\" not installed. \"$_app_name\" is not supported for '$DOTFILES_SYS_ARCHT'." "warn" ;;

        "dependency-missing")
            dotfiles_logging "\"$_app_name\" not installed. Dependency missing." "error" ;;

        *)
            dotfiles_logging "log_app_installation: Invalid status code \"$_status\"" "error"

            echo "Usage: log_app_installation <app_name> <status>"
            echo -n '  <status> should be one of: "install", "skip", "fail", "success",'
            echo '"sys-name-not-supported", "sys-archt-not-supported", "dependency-missing"' ;;
    esac
}


# ------------------------------------------------------------------------------
#
# Array
#
# - Dependency
#   - Environment Variable
#     - RC_ERROR
#
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------

# Check if a variable is an associative array
function is_associative_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} == association ]]
}

# Check if an array has at least one element
function is_non_empty_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${#${(P)_array_name[@]}} -gt 0 ]]
}

# Check if a variable is a normal (non-associative) array
function is_normal_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} == array ]]
}

# Update an associative array from input array elements
function update_associative_array_from_array() {

    local _out_asc_array_name="$1"
    local _in_main_array_name="$2"
    local _in_fallback_array_name="$3"

    # Check if output_name is defined and is an associative array
    if ! is_associative_array "$_out_asc_array_name"; then
        dotfiles_logging "'$_out_asc_array_name' must be defined as an associative array before calling this function" "error"
        return $RC_ERROR
    fi

    # Determine which array's elements to use
    local _in_array_name
    if is_normal_array "$_in_main_array_name" && is_non_empty_array "$_in_main_array_name"; then
        _in_array_name="$_in_main_array_name"
    elif is_normal_array "$_in_fallback_array_name" && is_non_empty_array "$_in_fallback_array_name"; then
        _in_array_name="$_in_fallback_array_name"
    fi

    # Populate the associative array with keys set to "true"
    if [[ -n $_in_array_name ]]; then
        for key in "${(@P)_in_array_name[@]}"; do
            eval "${_out_asc_array_name}[$key]=true"
        done
    else
        dotfiles_logging "Neither '$_in_main_array_name' nor '$_in_fallback_array_name' is valid to set up '$_out_asc_array_name'." "error"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# Command
#
# - Dependency
#   - Environment Variable
#     - RC_ERROR
#
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# $1: Command name
function command_exists() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "\$1 (command name) not provided." "error"
        return $RC_ERROR
    fi
    command -v "$1" >/dev/null 2>&1 || type "$1" >/dev/null 2>&1
}


# ------------------------------------------------------------------------------
#
# Directory
#
# - Dependency
#   - None
#
# ------------------------------------------------------------------------------


# Create a directory if it doesn't exist
# $1: directory path
function ensure_directory() {
    [[ -d "$1" ]] || mkdir -p "$1"
}


# ------------------------------------------------------------------------------
#
# Dotfiles
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_APP_ASC_ARR
#     - DOTFILES_PLUGIN_ASC_ARR
#     - DOTFILES_XDG_CONFIG_DIR
#     - DOTFILES_XDG_STATE_DIR
#     - DOTFILES_DOT_CONFIG_DIR
#     - DOTFILES_USER_CONFIG_DIR
#     - DOTFILES_USER_SECRET_DIR
#     - DOTFILES_USER_HIST_DIR
#     - RC_SUCCESS
#     - RC_ERROR
#     - RC_SKIPPED
#
#   - Functions
#     - dotfiles_logging
#     - ensure_directory
#     - create_validated_symlink
#
# ------------------------------------------------------------------------------


# Check if an application is in the managed list
# Usage: is_dotfiles_managed_app "app_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
function is_dotfiles_managed_app() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return $RC_ERROR
    fi
    [[ "${DOTFILES_APP_ASC_ARR[$1]}" == "true" ]]
}

# Check if a plugin is in the managed list
# Usage: is_dotfiles_managed_plugin "plugin_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
function is_dotfiles_managed_plugin() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "No plugin name provided." "error"
        return $RC_ERROR
    fi
    [[ "${DOTFILES_PLUGIN_ASC_ARR[$1]}" == "true" ]]
}

# Setup standard app directory structure
# $1: app name
# Returns: app_home_dir path via echo
function setup_dotfiles_app_home() {

    local _app_name="$1"
    local _app_home_dir="$DOTFILES_XDG_CONFIG_DIR/$_app_name"

    ensure_directory "$_app_home_dir"

    echo "$_app_home_dir"
}

# Setup dotfiles config with symlink
# $1: app name
# $2: app home directory
# $3: config filename
# Returns: config link path via echo if successful, exits on failure
function setup_dotfiles_config() {

    local _app_name="$1"
    local _app_home_dir="$2"
    local _config_filename="$3"

    local _dotfiles_config_path="$DOTFILES_DOT_CONFIG_DIR/$_app_name/$_config_filename"
    local _config_link="$_app_home_dir/$_config_filename"

    if ! create_validated_symlink "$_dotfiles_config_path" "$_config_link"; then
        dotfiles_logging "Failed to link dotfiles $_app_name config from $_dotfiles_config_path to $_config_link." "warn"
    fi

    if [[ -f "$_config_link" ]]; then
        echo "$_config_link"
        return $RC_SUCCESS
    else
        return $RC_ERROR
    fi
}

# Setup history symlink to user history directory
# $1: app name
# $2: history filename in XDG_STATE
# $3: history filename in user directory (optional, defaults to "$app_name.history")
function setup_dotfiles_history_link() {

    # sanity check
    [[ -d "$DOTFILES_USER_HIST_DIR" ]] || return $RC_SKIPPED

    # link state history -> user history
    local _app_name="$1"
    local _state_history_file="$2"
    local _user_history_file="${3:-$_app_name.history}"

    local _history_path="$DOTFILES_XDG_STATE_DIR/$_app_name/$_state_history_file"
    local _history_link="$DOTFILES_USER_HIST_DIR/$_user_history_file"

    [[ -e "$_history_link" ]] || ln -s "$_history_path" "$_history_link"
}

# Setup user config with symlink
# $1: app name
# $2: user config filename
# $3: app home directory
# $4: config filename
# Returns: config link path via echo
function setup_dotfiles_user_config() {

    local _app_name="$1"
    local _user_config_filename="$2"
    local _app_home_dir="$3"
    local _config_filename="$4"

    local _user_config_path="$DOTFILES_USER_CONFIG_DIR/$_app_name/$_user_config_filename"
    local _config_link="$_app_home_dir/$_config_filename"

    if ! create_validated_symlink "$_user_config_path" "$_config_link"; then
        dotfiles_logging "Failed to link $_app_name user config from $_user_config_path to $_config_link." "warn"
    fi

    echo $_config_link
}

# Setup user credentials with symlink
# $1: app name
# $2: app home directory
# $3: credentials filename
# Returns: credentials link path via echo
function setup_dotfiles_user_credentials() {

    local _app_name="$1"
    local _app_home_dir="$2"
    local _creds_filename="${3:-credentials}"

    local _user_creds_path="$DOTFILES_USER_SECRET_DIR/$_app_name/$_creds_filename"
    local _creds_link="$_app_home_dir/$_creds_filename"

    if ! create_validated_symlink "$_user_creds_path" "$_creds_link"; then
        dotfiles_logging "Failed to link $_app_name user credentials from $_user_creds_path to $_creds_link." "warn"
    fi

    echo $_creds_link
}


# ------------------------------------------------------------------------------
#
# Link
#
# - Dependency
#   - Environment Variable
#     - RC_SUCCESS
#     - RC_ERROR
#     - RC_SKIPPED
#
# ------------------------------------------------------------------------------


# Create a symbolic link with validation and logging
# $1: source path
# $2: link path
function create_validated_symlink() {

    local _source_path="$1"
    local _link_path="$2"

    # create symlink
    [[ -e "$_link_path" ]] || ln -s "$_source_path" "$_link_path"

    # validate
    if [[ ! -e "$_source_path" ]]; then
        return $RC_SKIPPED
    elif [[ ! "$_source_path" -ef "$_link_path" ]]; then
        return $RC_ERROR
    fi

    return $RC_SUCCESS
}


# ------------------------------------------------------------------------------
#
# Logging
#
# - Dependency
#   - Environment Variable
#     - B_RED
#     - B_YELLOW
#     - B_GREEN
#     - COLOR_OFF
#
# ------------------------------------------------------------------------------


# $1: message
# $2 (optional): level ("error" "warn" "info")
function dotfiles_logging() {

    local _log_message
    local _log_level

    # process arguments
    if [[ -n $1 ]]; then
        _log_message=$1
    else
        _log_message="Function(dotfiles_logging) \$1(message) is not set"
        _log_level="error"
    fi

    if [[ -n $_log_level ]]; then
        :
    elif [[ -n $2 ]]; then
        _log_level=$2
    else
        _log_level="info"
    fi

    # log message
    case $_log_level in

        "error")
            echo -e "${B_RED}Error: $_log_message ${COLOR_OFF}" >&2;;

        "warn")
            echo -e "${B_YELLOW}Warn: $_log_message ${COLOR_OFF}" >&2;;

        "info")
            echo -e "${B_GREEN}Info: $_log_message ${COLOR_OFF}";;

        *)
            echo -e "${B_RED}Error: unknown log_level \"$_log_level\" for log_message \"$_log_message\" ${COLOR_OFF}" >&2;;
    esac
}


# ------------------------------------------------------------------------------
#
# PATH
#
# - Dependency
#   - Functions
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# Add directory to the end of PATH if not already present
# $1: path variable, $2: directory path
function append_dir_to_path() {

    # Check if both arguments are provided
    if [[ $# -ne 2 ]]; then
        dotfiles_logging "Error: append_dir_to_path requires two arguments: \$1 path_variable and \$2 directory_path" "error"
        return RC_ERROR
    fi

    local _path_var="$1"
    local _dir_path="$2"

    # Check if the directory exists
    if [[ ! -d "$_dir_path" ]]; then
        dotfiles_logging "Directory $_dir_path missing. Skip from adding it to $_path_var." "warn"
        return RC_SKIPPED
    fi

    # append dir to path
    if [[ ":${(P)_path_var}:" != *":$_dir_path:"* ]]; then
        export $_path_var="${(P)_path_var}:$_dir_path"
    fi
}

# Add directory to beginning of PATH if not already present
# $1: path variable, $2: directory path
function prepend_dir_to_path() {

    # Check if both arguments are provided
    if [[ $# -ne 2 ]]; then
        dotfiles_logging "Error: prepend_dir_to_path requires two arguments: \$1 path_variable and \$2 directory_path" "error"
        return RC_ERROR
    fi

    local _path_var="$1"
    local _dir_path="$2"

    # Check if the directory exists
    if [[ ! -d "$_dir_path" ]]; then
        dotfiles_logging "Directory $_dir_path missing. Skip from adding it to $_path_var." "warn"
        return RC_SKIPPED
    fi

    # append dir to path
    if [[ ":${(P)_path_var}:" != *":$_dir_path:"* ]]; then
        export $_path_var="$_dir_path:${(P)_path_var}"
    fi
}



# ------------------------------------------------------------------------------
#
# Plugin
#
# - Dependency
#   - App
#     - zinit
#
# ------------------------------------------------------------------------------


# Print app initialization message
# $1: package name
# $2: function code ("fail", "success", "sys-name-not-supported", "sys-archt-not-supported")
function log_plugin_installation() {

    local _plugin_name=$1
    local _status=$2

    case $_status in

        "sys-name-not-supported")
            dotfiles_logging "\"$_app_name\" not installed. \"$_app_name\" is not supported for '$DOTFILES_SYS_NAME'." "warn" ;;

        "sys-archt-not-supported")
            dotfiles_logging "\"$_plugin_name\" not initialized. \"$_plugin_name\" is not supported for '$DOTFILES_SYS_ARCHT'." "warn" ;;

        *)
            dotfiles_logging "log_plugin_initialization: Invalid status code \"$_status\"" "error"

            echo "Usage: log_plugin_initialization <app_name> <status>"
            echo '  <status> should be one of: "sys-archt-not-supported".' ;;
    esac
}


function is_plugin_installed() {
    [[ " ${zsh_loaded_plugins[@]} " =~ " $1 " ]]
}


# ------------------------------------------------------------------------------
#
# Strings
#
# - Dependency
#   - None
#
# ------------------------------------------------------------------------------


function join_by { local IFS="$1"; shift; echo "$*"; }


# ------------------------------------------------------------------------------
#
# System
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#
# ------------------------------------------------------------------------------


function get_system_architecture() {

    local _archt=$(uname -m)

    case $_archt in

        "x86_64")
            echo "amd64" ;;

        "arm64" | "aarch64")
            echo "arm64" ;;

        arm*)
            echo "arm" ;;

        *)
            echo "unknown($_archt)" ;;
    esac
}

function get_system_name() {

    local _os_name=$(uname)

    case $_os_name in

        "Linux")
            echo "linux" ;;

        "Darwin")
            echo "mac" ;;

        *)
            echo "unknown($_os_name)" ;;
    esac
}

function is_supported_system_archt() {
    [[ $DOTFILES_SYS_ARCHT == "amd64" || $DOTFILES_SYS_ARCHT == "arm64" ]]
}

function is_supported_system_name() {
    [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]
}
