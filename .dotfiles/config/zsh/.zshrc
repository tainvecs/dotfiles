# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.9
# Last Modified: 2025-06-28
#
# - Dependency
#   - Environment Variable Files
#     - DOTFILES_DOT_ENV_DIR/dotfiles.env
#     - DOTFILES_DOT_ENV_DIR/return_code.env
#
#   - Environment Variables
#     - DOTFILES_PACKAGE_ARR
#     - ZSH_PROF
#
#   - Library
#     - DOTFILES_DOT_LIB_DIR/util.zsh
#     - DOTFILES_DOT_LIB_DIR/dotfiles/util.zsh
#     - DOTFILES_DOT_LIB_DIR/package/init.zsh
#     - DOTFILES_DOT_LIB_DIR/package/install.zsh
#
# - Environment Variables
#   - BREW_HOME
#   - DOTFILES_PACKAGE_ASC_ARR
#   - DOTFILES_SYS_ARCHT
#   - DOTFILES_SYS_NAME
#   - HOMEBREW_CELLAR
#   - HOMEBREW_PREFIX
#   - HOMEBREW_REPOSITORY
#   - ZINIT
#   - ZINIT_HOME
#   - ZINIT_PLUGIN_DIR
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# Profile Start
#
# - Environment Variables
#   - ZSH_PROF
#
# ------------------------------------------------------------------------------


# zsh startup profile: `time ZSH_PROF=1 zsh -i -c exit`
# zsh startup log: `zsh -x -i -c exit 2>&1 | sed -u "s/^/[$(date '+%Y-%m-%d %H:%M:%S')] /"`
# zsh startup benchmark: `hyperfine 'zsh -i -c exit'`
if [[ -n "$ZSH_PROF" ]]; then
    zmodload zsh/zprof
fi


# ------------------------------------------------------------------------------
# Sanity Check
# ------------------------------------------------------------------------------


if [[ -z "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "error: DOTFILES_DOT_LIB_DIR is not set." >&2
    return $RC_ERROR
fi


# ------------------------------------------------------------------------------
# Library
# ------------------------------------------------------------------------------


local scripts=(
    "util.zsh"
    "dotfiles/util.zsh"
    "package/init.zsh"
)
for _script in $scripts; do
    local path="$DOTFILES_DOT_LIB_DIR/$_script"
    if [[ ! -f "$path" ]]; then
        echo "error: $path is not found." >&2
        return $RC_DEPENDENCY_MISSING
    fi
    source "$path" || { echo "error: Failed to source $path" >&2; return $RC_ERROR; }
done


# ------------------------------------------------------------------------------
#
# Environment Variables
#
# - Environment Variables
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


# ------------------------------------------------------------------------------
# Local: binary and manual
# ------------------------------------------------------------------------------


# ensure local binary
ensure_directory "$DOTFILES_LOCAL_BIN_DIR"

# ensure local man
ensure_directory "$DOTFILES_LOCAL_MAN_DIR/man1"


# ------------------------------------------------------------------------------
# User: history and secret
# ------------------------------------------------------------------------------


# user zsh history -> local zsh history
dotfiles_user_link_local_history "zsh" $HISTFILE "$DOTFILES_USER_HIST_DIR/zsh.history"

# check user secret directory permission
if [[ -d "$DOTFILES_USER_SECRET_DIR" ]] && [[ $(get_permission "$DOTFILES_USER_SECRET_DIR") != "700" ]]; then
    chmod 700 "$DOTFILES_USER_SECRET_DIR"
fi


# ------------------------------------------------------------------------------
#
# Packages
#
# - Dependencies
#   - Environment Variables
#     - DOTFILES_PACKAGE_ARR
#     - DOTFILES_USER_PACKAGE_ARR
#
#   - Packages
#     - Homebrew
#     - Zinit
#
# - Environment Variables
#   - DOTFILES_PACKAGE_ASC_ARR
#
# ------------------------------------------------------------------------------


# init homebrew and zinit, and check dependencies
if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
    if { ! dotfiles_init_homebrew } || { ! command_exists "brew" }; then
        log_dotfiles_package_initialization "homebrew" "error"
        return $RC_DEPENDENCY_MISSING
    fi
fi

if { ! dotfiles_init_zinit } || { ! command_exists "zinit" }; then
    log_dotfiles_package_initialization "zinit" "error"
    return $RC_DEPENDENCY_MISSING
fi

# prepare dotfiles package associative array and
# init all managed package in DOTFILES_PACKAGE_ASC_ARR
unset DOTFILES_PACKAGE_ASC_ARR
typeset -A DOTFILES_PACKAGE_ASC_ARR
update_associative_array_from_array "DOTFILES_PACKAGE_ASC_ARR" "DOTFILES_USER_PACKAGE_ARR" "DOTFILES_PACKAGE_ARR"

if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be initialized." "warn"
else
    init_all_dotfiles_packages
fi


# ------------------------------------------------------------------------------
#
# Completion
#
# - Dependency
#   - Zinit
#
# ------------------------------------------------------------------------------


# trigger zsh completions
if is_dotfiles_managed_package "zsh-completions"; then
    dotfiles_init_zsh-completions
fi


# ------------------------------------------------------------------------------
#
# Profile End
#
# - Environment Variables
#   - ZSH_PROF
#
# ------------------------------------------------------------------------------


if [[ -n "$ZSH_PROF" ]]; then
    zprof
fi
