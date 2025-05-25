#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions
#
#
# Version: 0.0.9
# Last Modified: 2025-05-24
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
#     - DOTFILES_APP_ASC_ARR
#
#   - Function
#     - dotfiles_logging
#
# ------------------------------------------------------------------------------


# Print app installation message
# $1: package name
# $2: function code ("install", "skip", "fail", "success",
#                    "sys-archt-not-supported", "sys-name-not-supported", "dependency-missing")
function log_app_installation() {

    local app_name=$1
    local status=$2

    case $status in

        "install")
            dotfiles_logging "Start \"$app_name\" installation." "info" ;;

        "skip")
            dotfiles_logging "Skip \"$app_name\" installation as it is already installed." "info" ;;

        "update")
            dotfiles_logging "\"$app_name\" is already installed. Checking for update." "info" ;;

        "fail")
            dotfiles_logging "Failed to install/update \"$app_name\"." "error" ;;

        "success")
            dotfiles_logging "Successfully installed/updated \"$app_name\"." "info" ;;

        "sys-name-not-supported")
            dotfiles_logging "\"$app_name\" not installed. \"$app_name\" is not supported for '$DOTFILES_SYS_NAME'." "warn" ;;

        "sys-archt-not-supported")
            dotfiles_logging "\"$app_name\" not installed. \"$app_name\" is not supported for '$DOTFILES_SYS_ARCHT'." "warn" ;;

        "dependency-missing")
            dotfiles_logging "\"$app_name\" not installed. Dependency missing." "error" ;;

        *)
            echo "log_app_installation: Invalid status code \"$status\""
            echo "Usage: log_app_installation <app_name> <status>"
            echo -n '  <status> should be one of: "install", "skip", "fail", "success",'
            echo '"sys-name-not-supported", "sys-name-not-supported", "dependency-missing"' ;;
    esac
}


# Print app initialization message
# $1: package name
# $2: function code ("fail", "success", "sys-name-not-supported", "sys-archt-not-supported")
function log_app_initialization() {

    local app_name=$1
    local status=$2

    case $status in

        "fail")
            dotfiles_logging "Failed to initialization \"$app_name\"." "error" ;;

        "success")
            dotfiles_logging "Successfully initialized \"$app_name\"." "info" ;;

        "sys-name-not-supported")
            dotfiles_logging "\"$app_name\" not initialized. \"$app_name\" is not supported for '$DOTFILES_SYS_NAME'." "warn" ;;

        "sys-archt-not-supported")
            dotfiles_logging "\"$app_name\" not initialized. \"$app_name\" is not supported for '$DOTFILES_SYS_ARCHT'." "warn" ;;

        *)
            echo "log_app_initialization: Invalid status code \"$status\""
            echo "Usage: log_app_initialization <app_name> <status>"
            echo '  <status> should be one of: "fail", "success", "sys-name-not-supported", "sys-archt-not-supported".' ;;
    esac
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
            log_app_installation "$_in_app" "sys-name-not-supported"
            return $RC_UNSUPPORTED ;;
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
        return $RC_ERROR
    fi
    [[ "${DOTFILES_APP_ASC_ARR[$1]}" == "true" ]]
}


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
    local update_flag=false
    if [[ "$1" == "--update" ]]; then
        update_flag=true
        shift
    fi

    # Install app(s) with apt (linux) or brew (mac)
    for _in_app in "$@"; do

        case $DOTFILES_SYS_NAME in

            "linux")

                if ! {command_exists "$_in_app" || is_app_installed "$_in_app"}; then

                    log_app_installation "$_in_app" "install"

                    if sudo apt-get install --no-install-recommends --no-install-suggests -y "$_in_app"; then
                        log_app_installation "$_in_app" "success"
                    else
                        log_app_installation "$_in_app" "fail"
                    fi

                elif $update_flag; then

                    log_app_installation "$_in_app" "update"

                    if sudo apt install --only-upgrade "$_in_app"; then
                        log_app_installation "$_in_app" "success"
                    else
                        log_app_installation "$_in_app" "fail"
                    fi

                else
                    log_app_installation "$_in_app" "skip"
                    continue
                fi ;;

            "mac")

                if ! {command_exists "$_in_app" || is_app_installed "$_in_app"}; then

                    log_app_installation "$_in_app" "install"

                    if brew install "$_in_app"; then
                        log_app_installation "$_in_app" "success"
                    else
                        log_app_installation "$_in_app" "fail"
                    fi

                elif $update_flag; then

                    log_app_installation "$_in_app" "update"

                    if brew upgrade "$_in_app"; then
                        log_app_installation "$_in_app" "success"
                    else
                        log_app_installation "$_in_app" "fail"
                    fi

                else
                    log_app_installation "$_in_app" "skip"
                    continue
                fi ;;

            *)
                log_app_installation "$_in_app" "sys-name-not-supported"
                return $RC_UNSUPPORTED ;;
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
    [[ -v $_array_name && ${parameters[$_array_name]} == array ]]
}

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
        dotfiles_logging "Neither '$_in_main_array_name' nor '$_in_fallback_array_name' is valid to set up '$_out_asc_array_name'." "warn"
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
        return $RC_ERROR
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
        return $RC_ERROR
    fi
    [[ "${DOTFILES_PLUGIN_ASC_ARR[$1]}" == "true" ]]
}


# ------------------------------------------------------------------------------
# Strings
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
#     - DOTFILES_APP_ASC_ARR
#
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


function is_supported_system_name() {
    [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]
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


function is_supported_system_archt() {
    [[ $DOTFILES_SYS_ARCHT == "amd64" || $DOTFILES_SYS_ARCHT == "arm64" ]]
}
