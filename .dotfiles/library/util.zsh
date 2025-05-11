#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions
#
#
# Version: 0.0.5
# Last Modified: 2025-05-11
#
# - Dependency
#   - Environment Variable File
#     - .dotfiles/env/color.env
#
#   - Environment Variable
#     - DOTFILES_SYS_ARCHT
#     - DOTFILES_APP_ASC_ARR
#     - DOTFILES_PLUGIN_ASC_ARR
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# Application
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_SYS_ARCHT
#     - DOTFILES_APP_ASC_ARR
#
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# Print app installation message
# $1: package name
# $2: function code ("start", "skip")
function log_app_installation() {

    case $2 in

        "start")
            dotfiles_logging "Start \"$1\" installation." "info" ;;

        "skip")
            dotfiles_logging "Skip \"$1\" installation as it is already installed." "info" ;;

        *)
            echo 'log_app_installation: Print app installation message'
            echo '  $1: package name'
            echo '  $2: function code ("start", "skip")' ;;
    esac
}


# Check if an application is installed.
# Returns 0 if installed, non-zero otherwise.
function is_app_installed() {

    # Check input
    local _app_name
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return 2
    else
        _app_name="$1"
    fi

    # Check if an app is installed using dpkg-query (linux) or brew (mac)
    case $DOTFILES_SYS_ARCHT in

        "linux")
            dpkg-query -s "$_app_name" &>/dev/null ;;
        "mac")
            brew list "$_app_name" --quiet &>/dev/null ;;
        *)
            dotfiles_logging "Unknown system architecture '${DOTFILES_SYS_ARCHT}' determined from DOTFILES_SYS_ARCHT." "error"
            return 2 ;;
    esac

    # explicitly return success
    return $?
}


# Check if an application is in the managed list
# Usage: is_dotfiles_managed_app "app_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
function is_dotfiles_managed_app() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return 2
    fi
    [[ "${DOTFILES_APP_ASC_ARR[$1]}" == "true" ]]
}


# $1: GitHub username
# $2: GitHub repository name
function get_github_release_latest_version() {

    # Input checking
    if [[ -z "$1" ]]; then
        dotfiles_logging "\$1 (GitHub username) not provided." "error"
        return 2
    elif [[ -z "$2" ]]; then
        dotfiles_logging "\$2 (GitHub repository name) not provided." "error"
        return 2
    fi

    # Retrieve information from GitHub repo release page
    local _url="https://api.github.com/repos/$1/$2/releases"
    local _resp=$(curl -s "$_url")

    # Parse response
    local _parsed_ver=$(echo "$_resp" | grep -m 1 tag_name | cut -d '"' -f 4)

    # Result
    if [[ -n "$_parsed_ver" ]]; then
        echo "$_parsed_ver"
        return 0
    else
        dotfiles_logging "No release version found for GitHub Project $1/$2." "warning"
        return 1
    fi
}


# Install applications
# $@: Package names
function install_apps() {

    # Check input
    if [[ -z "$1" ]]; then
        dotfiles_logging "No application name provided." "error"
        return 2
    fi

    # Install app(s) with apt (linux) or brew (mac)
    for _in_app in "$@"; do

        # Skip if already installed
        if command_exists "$_in_app" || is_app_installed "$_in_app"; then
            log_app_installation "$_in_app" 'skip'
            continue
        fi

        # Install app
        case $DOTFILES_SYS_ARCHT in

            "linux")
                log_app_installation "$_in_app" 'start'
                sudo apt-get install --no-install-recommends --no-install-suggests -y "$_in_app" ;;
            "mac")
                log_app_installation "$_in_app" 'start'
                brew install "$_in_app" ;;
            *)
                dotfiles_logging "Unknown system architecture '${DOTFILES_SYS_ARCHT}' determined from DOTFILES_SYS_ARCHT." "error"
                return 2 ;;
        esac
    done
}


# ------------------------------------------------------------------------------
#
# Array
#
# - Dependency
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# Check if a variable is a normal (non-associative) array
function is_normal_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} = array ]]
}

# Check if a variable is an associative array
function is_associative_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} = association ]]
}

# Check if an array has at least one element
function is_non_empty_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${#${(P)_array_name[@]}} -gt 0 ]]
}

# Update an associative array from input array elements
function update_associative_array_from_array() {

    local _out_asc_array_name="$1"
    local _in_main_array_name="$2"
    local _in_fallback_array_name="$3"

    # Check if output_name is defined and is an associative array
    if ! is_associative_array "$_out_asc_array_name"; then
        dotfiles_logging "'$_out_asc_array_name' must be defined as an associative array before calling this function" "error"
        return 1
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
        dotfiles_logging "Neither '$_in_main_array_name' nor '$_in_fallback_array_name' is valid to set up '$_out_asc_array_name'." "warning"
    fi
}


# ------------------------------------------------------------------------------
#
# Command
#
# - Dependency
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# $1: Command name
function command_exists() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "\$1 (command name) not provided." "error"
        return 2
    fi
    command -v "$1" >/dev/null 2>&1 || type "$1" >/dev/null 2>&1
}


# ------------------------------------------------------------------------------
#
# Logging
#
# - Environment Variable
#   - B_RED
#   - B_YELLOW
#   - B_GREEN
#   - COLOR_OFF
#
# ------------------------------------------------------------------------------


# $1: message
# $2 (optional): level ("error" "warning" "info")
function dotfiles_logging() {

    local _log_message
    local _log_level

    # process arguments
    if [[ -n $1 ]]; then
        _log_message=$1
    else
        _log_message="Function(dotfiles_logging) \$1(message) is not set"
        _log_level='error'
    fi

    if [[ -n $_log_level ]]; then
        :
    elif [[ -n $2 ]]; then
        _log_level=$2
    else
        _log_level='info'
    fi

    # log message
    case $_log_level in

        'error')
            echo -e "${B_RED}Error: $_log_message ${COLOR_OFF}" >&2;;

        'warning')
            echo -e "${B_YELLOW}Warning: $_log_message ${COLOR_OFF}" >&2;;

        'info')
            echo -e "${B_GREEN}Info: $_log_message ${COLOR_OFF}";;

        *)
            echo -e "${B_RED}Error: unknown log_level \"$_log_level\" for log_message \"$_log_message\" ${COLOR_OFF}" >&2;;
    esac
}


# ------------------------------------------------------------------------------
#
# Plugin
#
# - Dependency
#   - Functions
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# Check if a plugin is in the managed list
# Usage: is_dotfiles_managed_plugin "plugin_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
function is_dotfiles_managed_plugin() {
    if [[ -z "$1" ]]; then
        dotfiles_logging "No plugin name provided." "error"
        return 2
    fi
    [[ "${DOTFILES_PLUGIN_ASC_ARR[$1]}" == "true" ]]
}


# ------------------------------------------------------------------------------
# Strings
# ------------------------------------------------------------------------------


function join_by { local IFS="$1"; shift; echo "$*"; }


# ------------------------------------------------------------------------------
# System
# ------------------------------------------------------------------------------


function get_system_name() {

    local os_name=$(uname)

    case $os_name in

        "Linux")
            echo "linux" ;;

        "Darwin")
            echo "mac" ;;

        *)
            echo "unknown($os_name)" ;;
    esac
}


function get_system_architecture() {

    local archt=$(uname -m)

    case $archt in

        "x86_64")
            echo "amd64" ;;

        "arm64" | "aarch64")
            echo "arm64" ;;

        arm*)
            echo "arm" ;;

        *)
            echo "unknown($archt)" ;;
    esac
}
