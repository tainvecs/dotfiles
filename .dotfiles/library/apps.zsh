#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Application
#
#
# Version: 0.0.1
# Last Modified: 2025-03-31
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_APP_ASC_ARR
#
#   - Library
#     - .dotfiles/library/util.zsh
#
# ------------------------------------------------------------------------------


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
