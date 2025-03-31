#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions
#
#
# Version: 0.0.3
# Last Modified: 2025-03-31
#
# - Dependency
#   - Environment Variable
#     - .dotfiles/env/color.env
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# Command
#
# - Function
#   - dotfiles_logging
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
        _log_message="function(dotfiles_logging) \$1(message) is not set"
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
            echo -e "${B_RED}error: $_log_message ${COLOR_OFF}" >&2;;

        'warning')
            echo -e "${B_YELLOW}warning: $_log_message ${COLOR_OFF}" >&2;;

        'info')
            echo -e "${B_GREEN}info: $_log_message ${COLOR_OFF}";;

        *)
            echo -e "${B_RED}error: unknown log_level \"$_log_level\" for log_message \"$_log_message\" ${COLOR_OFF}" >&2;;
    esac
}


# ------------------------------------------------------------------------------
# Strings
# ------------------------------------------------------------------------------


function join_by { local IFS="$1"; shift; echo "$*"; }
