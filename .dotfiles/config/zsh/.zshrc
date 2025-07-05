# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.12
# Last Modified: 2025-07-03
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
# Sanity Check
# ------------------------------------------------------------------------------


if [[ ! -n "$DOTFILES_ROOT_DIR" ]]; then
    echo "Error: environment variable DOTFILES_ROOT_DIR is not set." >&2
    return 1
fi

if [[ ! -n "$DOTFILES_ENV_SOURCED" ]]; then
    echo "Error: DOTFILES_DOT_ENV_DIR/dotfiles.env not sourced" >&2
    return 1
fi


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
# Source Dotfiles Init Script
# ------------------------------------------------------------------------------


_dotfiles_dot_lib_dot_init_path="$DOTFILES_DOT_LIB_DIR/dotfiles/init.zsh"
if [[ ! -f "$_dotfiles_dot_lib_dot_init_path" ]]; then
    echo "Error: dotfiles init.zsh not found at $_dotfiles_dot_lib_dot_init_path" >&2
    return 1
fi
source "$_dotfiles_dot_lib_dot_init_path"


# ------------------------------------------------------------------------------
# User: history and secret
# ------------------------------------------------------------------------------


# user zsh history -> local zsh history
_=$(link_dotfiles_local_history_to_user "zsh" "history")

# check user secret directory permission
if [[ -d "$DOTFILES_USER_SECRET_DIR" ]] && [[ $(get_permission "$DOTFILES_USER_SECRET_DIR") != "700" ]]; then
    chmod 700 "$DOTFILES_USER_SECRET_DIR"
fi


# ------------------------------------------------------------------------------
#
# Init Packages
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

# init all managed package in DOTFILES_PACKAGE_ASC_ARR
if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be initialized." "warn"
else
    init_all_dotfiles_packages
fi


# ------------------------------------------------------------------------------
#
# Zsh Completion
#
# - Dependency
#   - Zinit
#
# ------------------------------------------------------------------------------


# trigger zsh completions
if is_dotfiles_managed_package "zsh-completions"; then
    dotfiles_init_zsh-completions
else
    zpcompinit
    zpcdreplay
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
