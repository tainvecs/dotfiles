# ------------------------------------------------------------------------------
#
# Dotfiles Initialization Script
#
#
# Version: 0.0.3
# Last Modified: 2025-07-03
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Sanity Check
# ------------------------------------------------------------------------------


if [[ ! -n "$DOTFILES_ROOT_DIR" ]]; then
    echo "Error: environment variable DOTFILES_ROOT_DIR is not set." >&2
fi

if [[ ! -n "$DOTFILES_ENV_SOURCED" ]]; then
    echo "Error: DOTFILES_DOT_ENV_DIR/dotfiles.env not sourced" >&2
fi


# ------------------------------------------------------------------------------
# Source Environment Variables
# ------------------------------------------------------------------------------


# sanity check
if [[ ! -d "$DOTFILES_DOT_ENV_DIR" ]]; then
    echo "Error: Dotfiles env (DOTFILES_DOT_ENV_DIR) not found at '$DOTFILES_DOT_ENV_DIR'." >&2
    return $RC_ERROR
fi

# load all .env files in DOTFILES_DOT_ENV_DIR except dotfiles.env
for _env_file in $DOTFILES_DOT_ENV_DIR/*.env(.N); do
    [[ "$_env_file" == "$DOTFILES_DOT_ENV_DIR/dotfiles.env" ]] && continue
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
# Local
# ------------------------------------------------------------------------------


# binary
ensure_directory "$DOTFILES_LOCAL_BIN_DIR"

# cache
# - zsh
ensure_directory "$DOTFILES_ZSH_CACHE_DIR"

# config
ensure_directory "$DOTFILES_LOCAL_CONFIG_DIR"

# share
# - completion
# - man
ensure_directory "$DOTFILES_ZSH_COMP_DIR"
ensure_directory "$DOTFILES_LOCAL_MAN_DIR/man1"

# state
# - history
# - session
ensure_directory "$DOTFILES_LOCAL_STATE_DIR/zsh"
export HISTFILE="$DOTFILES_ZSH_HISTFILE_PATH"
ensure_directory "$SHELL_SESSION_DIR"
