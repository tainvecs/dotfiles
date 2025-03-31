#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Array
#
#
# Version: 0.0.1
# Last Modified: 2025-03-31
#
# - Dependency
#   - Library
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
