#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Helper Functions
#
#
# Version: 0.0.1
# Last Modified: 2025-03-31
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_APP_ASC_ARR
#     - DOTFILES_PLUGIN_ASC_ARR
#
#   - Library
#
# ------------------------------------------------------------------------------


# Check if an application is in the managed list
# Usage: is_dotfiles_managed_app "app_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
is_dotfiles_managed_app() {
    if [[ -z "$1" ]]; then
        echo "Error: No application name provided" >&2
        return 2
    fi
    [[ "${DOTFILES_APP_ASC_ARR[$1]}" == "true" ]]
}


# Check if a plugin is in the managed list
# Usage: is_dotfiles_managed_plugin "plugin_name"
# Returns: 0 if managed, 1 if not managed, 2 if no argument provided
is_dotfiles_managed_plugin() {
    if [[ -z "$1" ]]; then
        echo "Error: No plugin name provided" >&2
        return 2
    fi
    [[ "${DOTFILES_PLUGIN_ASC_ARR[$1]}" == "true" ]]
}
