#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions
#
#
# Version: 0.0.13
# Last Modified: 2025-06-21
#
# - Dependency
#   - Environment Variable Files
#     - .dotfiles/env/color.env
#     - .dotfiles/env/return_code.env
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# Array
#
# - Dependency
#   - Function
#     - log_message
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

    # Check if $1 output_name is defined and is an associative array
    if ! is_associative_array "$_out_asc_array_name"; then
        log_message "'$_out_asc_array_name' must be defined as an associative array before calling this function" "error"
        return $RC_ERROR
    fi

    # Determine either $2 or $3 array's elements to use
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
        log_message "Neither '$_in_main_array_name' nor '$_in_fallback_array_name' is valid to set up '$_out_asc_array_name'." "error"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# Command
#
# - Dependency
#   - Function
#     - log_message
#
# ------------------------------------------------------------------------------


# $1: Command name
function command_exists() {
    if [[ -z "$1" ]]; then
        log_message "\$1 (command name) not provided." "error"
        return $RC_ERROR
    fi
    command -v "$1" >/dev/null 2>&1 || type "$1" >/dev/null 2>&1
}


# ------------------------------------------------------------------------------
# Directory
# ------------------------------------------------------------------------------


# Create a directory if it doesn't exist
# $1: directory path
function ensure_directory() {
    [[ -d "$1" ]] || mkdir -p "$1"
}


# ------------------------------------------------------------------------------
# GitHub
# ------------------------------------------------------------------------------


# $1: GitHub username
# $2: GitHub repository name
function get_github_release_latest_version() {

    # Input checking
    if [[ -z "$1" ]]; then
        log_message "\$1 (GitHub username) not provided." "error"
        return $RC_INVALID_ARGS
    elif [[ -z "$2" ]]; then
        log_message "\$2 (GitHub repository name) not provided." "error"
        return $RC_INVALID_ARGS
    fi

    # Retrieve information from GitHub repo release page
    local _url="https://api.github.com/repos/$1/$2/releases"
    local _resp=$(curl -s "$_url")
    if [[ $? -ne 0 ]]; then
        log_message "Failed to fetch data from $_url" "error"
        return $RC_ERROR
    fi

    # Parse response
    local _parsed_ver=$(echo "$_resp" | grep -m 1 tag_name | cut -d '"' -f 4)

    # Result
    if [[ -n "$_parsed_ver" ]]; then
        echo "$_parsed_ver"
        return $RC_SUCCESS
    else
        log_message "No release version found for GitHub Project $1/$2." "warn"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
# Link
# ------------------------------------------------------------------------------


# Create a symbolic link with validation and logging
# $1: source path
# $2: link path
function create_validated_symlink() {

    local _source_path="$1"
    local _link_path="$2"

    # sanity check
    if [[ ! -e "$_source_path" ]]; then
        # log_message "Skipped linking dot config from $_source_path to $_link_path." "warn"
        return $RC_SKIPPED
    fi

    # create symlink
    [[ -e "$_link_path" ]] || ln -sf "$_source_path" "$_link_path"

    # validate
    if [[ ! "$_source_path" -ef "$_link_path" ]]; then
        log_message "Failed to link from $_source_path to $_link_path." "error"
        return $RC_ERROR
    fi

    echo "$_link_path"
    return $RC_SUCCESS
}


# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------


# $1: message
# $2 (optional): level ("error" "warn" "info")
function log_message() {

    local _message
    local _level

    # process arguments
    if [[ -n $1 ]]; then
        _message=$1
    else
        _message="Function(log_message) \$1(message) is not set"
        _level="error"
    fi

    if [[ -n $_level ]]; then
        :
    elif [[ -n $2 ]]; then
        _level=$2
    else
        _level="info"
    fi

    # log message
    case $_level in

        "error")
            echo -e "${B_RED}Error: $_message ${COLOR_OFF}" >&2;;

        "warn")
            echo -e "${B_YELLOW}Warn: $_message ${COLOR_OFF}" >&2;;

        "info")
            echo -e "${B_GREEN}Info: $_message ${COLOR_OFF}";;

        *)
            echo -e "${B_RED}Error: unknown log_level \"$_level\" for log_message \"$_message\" ${COLOR_OFF}" >&2;;
    esac
}


# ------------------------------------------------------------------------------
#
# PATH
#
# - Dependency
#   - Functions
#     - log_message
#
# ------------------------------------------------------------------------------


# Add directory to the end of PATH if not already present
# $1: path variable, $2: directory path
function append_dir_to_path() {

    # Check if both arguments are provided
    if [[ $# -ne 2 ]]; then
        log_message "Error: append_dir_to_path requires two arguments: \$1 path_variable and \$2 directory_path" "error"
        return RC_ERROR
    fi

    local _path_var="$1"
    local _dir_path="$2"

    # Check if the directory exists
    if [[ ! -d "$_dir_path" ]]; then
        log_message "Directory $_dir_path missing. Skip from adding it to $_path_var." "warn"
        return $RC_SKIPPED
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
        log_message "Error: prepend_dir_to_path requires two arguments: \$1 path_variable and \$2 directory_path" "error"
        return RC_ERROR
    fi

    local _path_var="$1"
    local _dir_path="$2"

    # Check if the directory exists
    if [[ ! -d "$_dir_path" ]]; then
        log_message "Directory $_dir_path missing. Skip from adding it to $_path_var." "warn"
        return $RC_SKIPPED
    fi

    # append dir to path
    if [[ ":${(P)_path_var}:" != *":$_dir_path:"* ]]; then
        export $_path_var="$_dir_path:${(P)_path_var}"
    fi
}


# ------------------------------------------------------------------------------
# Strings
# ------------------------------------------------------------------------------


function join_by { local IFS="$1"; shift; echo "$*"; }


# ------------------------------------------------------------------------------
# System
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
