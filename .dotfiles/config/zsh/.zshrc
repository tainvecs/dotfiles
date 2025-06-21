# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.8
# Last Modified: 2025-06-21
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


local _dot_lib_util_path="$DOTFILES_DOT_LIB_DIR/util.zsh"

if [[ ! -f "$_dot_lib_util_path" ]]; then
    echo "error: $_dot_lib_util_path is not found." >&2
    return $RC_DEPENDENCY_MISSING
else
    source "$_dot_lib_util_path"
fi


local _dot_lib_dotfiles_util_path="$DOTFILES_DOT_LIB_DIR/dotfiles/util.zsh"

if [[ ! -f "$_dot_lib_dotfiles_util_path" ]]; then
    echo "error: $_dot_lib_dotfiles_util_path is not found." >&2
    return $RC_DEPENDENCY_MISSING
else
    source "$_dot_lib_dotfiles_util_path"
fi


local _dot_lib_package_init_path="$DOTFILES_DOT_LIB_DIR/package/init.zsh"

if [[ ! -f "$_dot_lib_package_init_path" ]]; then
    echo "error: $_dot_lib_package_init_path is not found." >&2
    return $RC_DEPENDENCY_MISSING
else
    source "$_dot_lib_package_init_path"
fi


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
    log_dotfiles_package_initialization "$_package_name" "sys-name-not-supported"
    return $RC_UNSUPPORTED
fi
if ! is_supported_system_archt; then
    log_dotfiles_package_initialization "$_package_name" "sys-archt-not-supported"
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
# User: completions, history, manual and secret
# ------------------------------------------------------------------------------


# add user completion if exist
prepend_dir_to_path "FPATH" $DOTFILES_USER_COMP_DIR

# user zsh history -> local zsh history
dotfiles_user_link_local_history "zsh" $HISTFILE "$DOTFILES_USER_HIST_DIR/zsh.history"

# add user manual if exist
prepend_dir_to_path "MANPATH" $DOTFILES_USER_MAN_DIR

# check user secret directory permission
if [[ -d "$DOTFILES_USER_SECRET_DIR" ]] && [[ $(get_permission "$DOTFILES_USER_SECRET_DIR") != "700" ]]; then
    chmod 700 "$DOTFILES_USER_SECRET_DIR"
fi


# ------------------------------------------------------------------------------
#
# Homebrew
#
# - Environment Variables
#   - BREW_HOME
#   - HOMEBREW_CELLAR
#   - HOMEBREW_PREFIX
#   - HOMEBREW_REPOSITORY
#
# ------------------------------------------------------------------------------


if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

    # BREW_HOME
    if [[ -d "/opt/homebrew" ]]; then
        export BREW_HOME="/opt/homebrew"
    elif [[ -d "/usr/local/Homebrew" ]]; then
        export BREW_HOME="/usr/local"
    else
        log_message "Homebrew not found in standard locations." "error"
    fi

    # set fpath, PATH, MANPATH and INFOPATH
    if [[ -n "$BREW_HOME" ]]; then
        eval $("${BREW_HOME}/bin/brew" shellenv)
    fi
fi


# ------------------------------------------------------------------------------
#
# Zinit
#
# - Environment Variables
#   - ZINIT
#   - ZINIT_HOME
#   - ZINIT_PLUGIN_DIR
#
# ------------------------------------------------------------------------------


# zinit home
export ZINIT_HOME="$ZDOTDIR/zinit"
export ZINIT_PLUGIN_DIR="$ZINIT_HOME/plugin"
export ZINIT_SNIPPET_DIR="$ZINIT_HOME/snippet"

# set zinit variables
declare -A ZINIT

ZINIT[HOME_DIR]="$ZINIT_HOME"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZINIT[PLUGINS_DIR]="$ZINIT_PLUGIN_DIR"
ZINIT[SNIPPETS_DIR]="$ZINIT_SNIPPET_DIR"
ZINIT[MAN_DIR]="$DOTFILES_LOCAL_MAN_DIR"
ZINIT[COMPINIT_OPTS]=-C  # to suppress warnings
ZINIT[COMPLETIONS_DIR]="$DOTFILES_ZSH_COMP_DIR"
ZINIT[ZCOMPDUMP_PATH]="$DOTFILES_ZSH_COMPDUMP_PATH"

export ZINIT

# source zinit binary
if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    log_message "Zinit binary at ${ZINIT[BIN_DIR]}/zinit.zsh not found." "error"
else
    source "${ZINIT[BIN_DIR]}/zinit.zsh"
fi


# ------------------------------------------------------------------------------
#
# Packages
#
# - Environment Variables
#   - DOTFILES_PACKAGE_ASC_ARR
#
# ------------------------------------------------------------------------------


# dependency checking
if [[ $DOTFILES_SYS_NAME == "mac" ]] && { ! command_exists brew }; then
    log_message "Brew is not available. Some of the dotfiles packages will not be initialized." "error"
    return $RC_DEPENDENCY_MISSING
fi

if ! command_exists zinit; then
    log_message "Zinit is not available. Some of the dotfiles packages will not be initialized." "error"
    return $RC_DEPENDENCY_MISSING
fi

# dotfiles package associative array
unset DOTFILES_PACKAGE_ASC_ARR
typeset -A DOTFILES_PACKAGE_ASC_ARR
update_associative_package_from_array "DOTFILES_PACKAGE_ASC_ARR" "DOTFILES_USER_PACKAGE_ARR" "DOTFILES_PACKAGE_ARR"

if [[ ${#DOTFILES_PACKAGE_ASC_ARR[@]} -eq 0 ]]; then
    log_message "DOTFILES_PACKAGE_ASC_ARR is empty. No package will be initialized." "warn"
fi

# init dotfiles packages
for _pkg in ${(k)DOTFILES_PACKAGE_ASC_ARR}; do

    # double check and skip false
    if ! is_dotfiles_managed_package "$_pkg"; then
        continue
    fi

    # skip package without init function
    local _init_func="dotfiles_init_${_pkg}"
    if (( ! ${+functions[$_init_func]} )); then
        continue
    fi

    # init package
    $_init_func
    if [[ $? -ne $RC_SUCCESS ]]; then
        log_dotfiles_package_initialization "$_pkg" "fail"
    fi
done


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
