# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.1
# Last Modified: 2025-03-30
#
# - Reference
#   - DOTFILES_APP_ARR
#   - DOTFILES_PLUGIN_ARR
#   - DOTFILES_USER_APP_ARR
#   - DOTFILES_USER_PLUGIN_ARR
#
# - Environment Variable
#   - DOTFILES_APP_ASC_ARR
#   - DOTFILES_PLUGIN_ASC_ARR
#
# - Helper Function
#   - is_dotfiles_managed_app
#   - is_dotfiles_managed_plugin
#
# ------------------------------------------------------------------------------


# Check if a variable is a normal (non-associative) array
is_normal_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} = array ]]
}

# Check if a variable is an associative array
is_associative_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${parameters[$_array_name]} = association ]]
}

# Check if an array has at least one element
is_non_empty_array() {
    local _array_name="$1"
    [[ -v $_array_name && ${#${(P)_array_name[@]}} -gt 0 ]]
}

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


# Update an associative array from input array elements
update_associative_array_from_array() {

    local _out_asc_array_name="$1"
    local _in_main_array_name="$2"
    local _in_fallback_array_name="$3"

    # Check if output_name is defined and is an associative array
    if ! is_associative_array "$_out_asc_array_name"; then
        echo "Error: '$_out_asc_array_name' must be defined as an associative array before calling this function" >&2
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
        echo "Warning: neither '$_in_main_array_name' nor '$_in_fallback_array_name' is valid to set up '$_out_asc_array_name'." >&2
    fi
}

# set up DOTFILES_APP_ASC_ARR
unset DOTFILES_APP_ASC_ARR
typeset -A DOTFILES_APP_ASC_ARR
update_associative_array_from_array "DOTFILES_APP_ASC_ARR" "DOTFILES_USER_APP_ARR" "DOTFILES_APP_ARR"


# DOTFILES_PLUGIN_ASC_ARR
unset DOTFILES_PLUGIN_ASC_ARR
typeset -A DOTFILES_PLUGIN_ASC_ARR
update_associative_array_from_array "DOTFILES_PLUGIN_ASC_ARR" "DOTFILES_PLUGIN_APP_ARR" "DOTFILES_PLUGIN_ARR"
