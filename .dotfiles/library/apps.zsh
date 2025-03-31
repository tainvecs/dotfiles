#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Application
#
#
# Version: 0.0.2
# Last Modified: 2025-03-31
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_SYS_ARCHT
#     - DOTFILES_APP_ASC_ARR
#
#   - Library
#     - .dotfiles/library/util.zsh
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
