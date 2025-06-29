# ------------------------------------------------------------------------------
#
# Dotfiles Initialization Script
#
#
# Version: 0.0.1
# Last Modified: 2025-06-29
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Ensure Zsh
# ------------------------------------------------------------------------------


# Ensure we're running in zsh
[[ -n "$ZSH_VERSION" ]] || { echo "This script requires zsh" >&2; exit 1; }


# ------------------------------------------------------------------------------
#
# Dotfiles Initialization Script
#
#
# Version: 0.0.1
# Last Modified: 2025-06-29
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Ensure Zsh
# ------------------------------------------------------------------------------


# Ensure we're running in zsh
[[ -n "$ZSH_VERSION" ]] || { echo "This script requires zsh" >&2; exit 1; }


# ------------------------------------------------------------------------------
# DOTFILES_ROOT_DIR
# ------------------------------------------------------------------------------


# determine DOTFILES_ROOT_DIR is not set
# %x expands to script name,
# :A resolves symlinks,
# :h:h:h:h goes up 4 directories to find the root
if [[ ! -n "$DOTFILES_ROOT_DIR" ]]; then

    # check if the current script path is available
    # if true, set DOTFILES_ROOT_DIR based on script location
    if [[ -z "${(%):-%x}" ]]; then
        echo "Error: Unable to determine '.dotfiles/library/dotfiles/init.zsh' location" >&2
        return 1
    else
        export DOTFILES_ROOT_DIR="${${(%):-%x}:A:h:h:h:h}"
    fi
fi

# sanity check
if [[ ! -d "$DOTFILES_ROOT_DIR" ]]; then
    echo "Error: No environment directory found at '$DOTFILES_DOT_ENV_DIR'." >&2
    return $RC_ERROR
fi


# ------------------------------------------------------------------------------
# DOTFILES_DOT_ROOT_DIR, DOTFILES_DOT_ENV_DIR
# ------------------------------------------------------------------------------


[[ -n "$DOTFILES_DOT_ROOT_DIR" ]] || {
    export DOTFILES_DOT_ROOT_DIR="$DOTFILES_ROOT_DIR/.dotfiles"
}
[[ -n "$DOTFILES_DOT_ENV_DIR" ]] || {
    export DOTFILES_DOT_ENV_DIR="$DOTFILES_DOT_ROOT_DIR/env"
}


# ------------------------------------------------------------------------------
# Source Environment Variables
# ------------------------------------------------------------------------------


# sanity check
if [[ ! -d "$DOTFILES_DOT_ENV_DIR" ]]; then
    echo "Error: Dotfiles env (DOTFILES_DOT_ENV_DIR) not found at '$DOTFILES_DOT_ENV_DIR'." >&2
    return $RC_ERROR
fi

# load all .env files in DOTFILES_DOT_ENV_DIR
for _env_file in $DOTFILES_DOT_ENV_DIR/*.env(.N); do
    source "$_env_file" || echo "Error: Failed to source '$_env_file'" >&2
done

# load all .env files in DOTFILES_USER_ENV_DIR
if [[ -d "$DOTFILES_USER_ENV_DIR" ]]; then
    for _env_file in $DOTFILES_USER_ENV_DIR/*.env(.N); do
        source "$_env_file" || echo "Error: Failed to source '$_env_file'" >&2
    done
fi


# ------------------------------------------------------------------------------
# Source Libraries
# ------------------------------------------------------------------------------


# sanity check
if [[ ! -n "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "Error: DOTFILES_DOT_LIB_DIR is not set." >&2
    return $RC_ERROR
elif [[ ! -d "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "Error: Dotfiles Library (DOTFILES_DOT_LIB_DIR) is not found at '$DOTFILES_DOT_LIB_DIR'" >&2
    return $RC_ERROR
fi

# source libraries
_scripts=(
    "util.zsh"
    "dotfiles/util.zsh"
    "package/install.zsh"
    "package/init.zsh"
)
for _script in $_scripts; do
    _path="$DOTFILES_DOT_LIB_DIR/$_script"
    if [[ ! -f "$_path" ]]; then
        echo "Error: $_path is not found." >&2
        return $RC_DEPENDENCY_MISSING
    fi
    source "$_path" || { echo "Error: Failed to source $_path" >&2; return $RC_ERROR; }
done


# ------------------------------------------------------------------------------
#
# Set Environment Variables
#
# - Environment Variables
#   - DOTFILES_PACKAGE_ASC_ARR
#   - DOTFILES_SYS_NAME
#   - DOTFILES_SYS_ARCHT
#
# ------------------------------------------------------------------------------


# system name and architecture
export DOTFILES_SYS_NAME=$(get_system_name)
export DOTFILES_SYS_ARCHT=$(get_system_architecture)

# sanity check
if ! is_supported_system_name; then
    log_message "Dotfiles is not supported on system name '$DOTFILES_SYS_NAME'." "error"
    return $RC_UNSUPPORTED
fi
if ! is_supported_system_archt; then
    log_message "Dotfiles is not supported on system architecture '$DOTFILES_SYS_ARCHT'." "error"
    return $RC_UNSUPPORTED
fi

# prepare dotfiles package associative array for
# all managed package in DOTFILES_PACKAGE_ASC_ARR
unset DOTFILES_PACKAGE_ASC_ARR
typeset -gA DOTFILES_PACKAGE_ASC_ARR
update_associative_array_from_array "DOTFILES_PACKAGE_ASC_ARR" "DOTFILES_USER_PACKAGE_ARR" "DOTFILES_PACKAGE_ARR"
# ------------------------------------------------------------------------------
# DOTFILES_ROOT_DIR
# ------------------------------------------------------------------------------


# determine DOTFILES_ROOT_DIR is not set
# %x expands to script name,
# :A resolves symlinks,
# :h:h:h:h goes up 4 directories to find the root
if [[ ! -n "$DOTFILES_ROOT_DIR" ]]; then

    # check if the current script path is available
    # if true, set DOTFILES_ROOT_DIR based on script location
    if [[ -z "${(%):-%x}" ]]; then
        echo "Error: Unable to determine '.dotfiles/library/dotfiles/init.zsh' location" >&2
        return 1
    else
        export DOTFILES_ROOT_DIR="${${(%):-%x}:A:h:h:h:h}"
    fi
fi

# sanity check
if [[ ! -d "$DOTFILES_ROOT_DIR" ]]; then
    echo "Error: No environment directory found at '$DOTFILES_DOT_ENV_DIR'." >&2
    return $RC_ERROR
fi


# ------------------------------------------------------------------------------
# DOTFILES_DOT_ROOT_DIR, DOTFILES_DOT_ENV_DIR
# ------------------------------------------------------------------------------


[[ -n "$DOTFILES_DOT_ROOT_DIR" ]] || {
    export DOTFILES_DOT_ROOT_DIR="$DOTFILES_ROOT_DIR/.dotfiles"
}
[[ -n "$DOTFILES_DOT_ENV_DIR" ]] || {
    export DOTFILES_DOT_ENV_DIR="$DOTFILES_DOT_ROOT_DIR/env"
}


# ------------------------------------------------------------------------------
# Source Environment Variables
# ------------------------------------------------------------------------------


# sanity check
if [[ ! -d "$DOTFILES_DOT_ENV_DIR" ]]; then
    echo "Error: Dotfiles env (DOTFILES_DOT_ENV_DIR) not found at '$DOTFILES_DOT_ENV_DIR'." >&2
    return $RC_ERROR
fi

# load all .env files in DOTFILES_DOT_ENV_DIR
for _env_file in $DOTFILES_DOT_ENV_DIR/*.env(.N); do
    source "$_env_file" || echo "Error: Failed to source '$_env_file'" >&2
done

# load all .env files in DOTFILES_USER_ENV_DIR
if [[ -d "$DOTFILES_USER_ENV_DIR" ]]; then
    for _env_file in $DOTFILES_USER_ENV_DIR/*.env(.N); do
        source "$_env_file" || echo "Error: Failed to source '$_env_file'" >&2
    done
fi


# ------------------------------------------------------------------------------
# Source Libraries
# ------------------------------------------------------------------------------


# sanity check
if [[ ! -n "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "Error: DOTFILES_DOT_LIB_DIR is not set." >&2
    return $RC_ERROR
elif [[ ! -d "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "Error: Dotfiles Library (DOTFILES_DOT_LIB_DIR) is not found at '$DOTFILES_DOT_LIB_DIR'" >&2
    return $RC_ERROR
fi

# source libraries
_scripts=(
    "util.zsh"
    "dotfiles/util.zsh"
    "package/install.zsh"
    "package/init.zsh"
)
for _script in $_scripts; do
    _path="$DOTFILES_DOT_LIB_DIR/$_script"
    if [[ ! -f "$_path" ]]; then
        echo "Error: $_path is not found." >&2
        return $RC_DEPENDENCY_MISSING
    fi
    source "$_path" || { echo "Error: Failed to source $_path" >&2; return $RC_ERROR; }
done


# ------------------------------------------------------------------------------
#
# Set Environment Variables
#
# - Environment Variables
#   - DOTFILES_PACKAGE_ASC_ARR
#   - DOTFILES_SYS_NAME
#   - DOTFILES_SYS_ARCHT
#
# ------------------------------------------------------------------------------


# system name and architecture
export DOTFILES_SYS_NAME=$(get_system_name)
export DOTFILES_SYS_ARCHT=$(get_system_architecture)

# sanity check
if ! is_supported_system_name; then
    log_message "Dotfiles is not supported on system name '$DOTFILES_SYS_NAME'." "error"
    return $RC_UNSUPPORTED
fi
if ! is_supported_system_archt; then
    log_message "Dotfiles is not supported on system architecture '$DOTFILES_SYS_ARCHT'." "error"
    return $RC_UNSUPPORTED
fi

# prepare dotfiles package associative array for
# all managed package in DOTFILES_PACKAGE_ASC_ARR
unset DOTFILES_PACKAGE_ASC_ARR
typeset -gA DOTFILES_PACKAGE_ASC_ARR
update_associative_array_from_array "DOTFILES_PACKAGE_ASC_ARR" "DOTFILES_USER_PACKAGE_ARR" "DOTFILES_PACKAGE_ARR"


# ------------------------------------------------------------------------------
# Local: binary, completion and manual
# ------------------------------------------------------------------------------


# ensure local binary
ensure_directory "$DOTFILES_LOCAL_BIN_DIR"

# ensure local completion
ensure_directory "$DOTFILES_ZSH_COMP_DIR"

# ensure local man
ensure_directory "$DOTFILES_LOCAL_MAN_DIR/man1"
