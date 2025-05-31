# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.5
# Last Modified: 2025-05-31
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_APP_ARR
#     - DOTFILES_USER_APP_ARR
#     - DOTFILES_USER_PLUGIN_ARR
#     - DOTFILES_PLUGIN_ARR
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
# - Environment Variable
#   - DOTFILES_APP_ASC_ARR
#   - DOTFILES_SYS_ARCHT
#   - DOTFILES_SYS_NAME
#   - DOTFILES_PLUGIN_ASC_ARR
#   - DOTFILES_USER_MAN_DIR
#   - DOTFILES_LOCAL_MAN_DIR
#   - ZINIT
#   - ZINIT_HOME
#   - ZSH_PROF
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
#
# Sanity Check
#
# - Dependency
#   - Environment Variable
#     - DOTFILES_DOT_LIB_DIR
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
# ------------------------------------------------------------------------------


if [[ -z "$DOTFILES_DOT_LIB_DIR" ]]; then
    echo "error: DOTFILES_DOT_LIB_DIR is not set." >&2
    return 1
elif [[ ! -f "$DOTFILES_DOT_LIB_DIR/util.zsh" ]]; then
    echo "error: $DOTFILES_DOT_LIB_DIR/util.zsh is not found." >&2
    return 1
fi


# ------------------------------------------------------------------------------
#
# Library
#
# - Environment Variables
#   - DOTFILES_SYS_NAME
#   - DOTFILES_SYS_ARCHT
#
# ------------------------------------------------------------------------------


# load utils
source "$DOTFILES_DOT_LIB_DIR/util.zsh"

# sys env
export DOTFILES_SYS_NAME=$(get_system_name)
export DOTFILES_SYS_ARCHT=$(get_system_architecture)


# ------------------------------------------------------------------------------
#
# Homebrew
#
# - Environment Variables
#   - BREW_HOME
#   - HOMEBREW_PREFIX
#   - HOMEBREW_CELLAR
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
        dotfiles_logging "Homebrew not found in standard locations." "error"
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
#
# ------------------------------------------------------------------------------


# zinit home
export ZINIT_HOME="$ZDOTDIR/zinit"

# set zinit variables
declare -A ZINIT

ZINIT[HOME_DIR]="$ZINIT_HOME"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZINIT[PLUGINS_DIR]="${ZINIT[HOME_DIR]}/plugins"
ZINIT[MAN_DIR]="$DOTFILES_LOCAL_MAN_DIR"
ZINIT[COMPINIT_OPTS]=-C  # to suppress warnings
ZINIT[COMPLETIONS_DIR]="$DOTFILES_ZSH_COMP_DIR"
ZINIT[ZCOMPDUMP_PATH]="$DOTFILES_ZSH_COMPDUMP_PATH"

export ZINIT

# source zinit binary
if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    dotfiles_logging "Zinit binary at ${ZINIT[BIN_DIR]}/zinit.zsh not found." "error"
else
    source "${ZINIT[BIN_DIR]}/zinit.zsh"
fi


# ------------------------------------------------------------------------------
#
# Apps
#
# - Environment Variables
#   - DOTFILES_APP_ASC_ARR
#
# ------------------------------------------------------------------------------


# dotfiles app associative array
unset DOTFILES_APP_ASC_ARR
typeset -A DOTFILES_APP_ASC_ARR
update_associative_array_from_array "DOTFILES_APP_ASC_ARR" "DOTFILES_USER_APP_ARR" "DOTFILES_APP_ARR"

# set up app configs
if [[ $DOTFILES_SYS_NAME == "mac" ]] && { ! command_exists brew }; then
    dotfiles_logging "Brew is not available. App config will not be set." "error"
elif [[ ${#DOTFILES_APP_ASC_ARR[@]} -eq 0 ]]; then
    dotfiles_logging "DOTFILES_APP_ASC_ARR is empty. No app config will be set." "warn"
else
    :  # TODO: Add app-specific setup here if needed
fi


# ------------------------------------------------------------------------------
#
# Plugins
#
# - Environment Variables
#   - DOTFILES_PLUGIN_ASC_ARR
#
# ------------------------------------------------------------------------------


# dotfiles plugin associative array
unset DOTFILES_PLUGIN_ASC_ARR
typeset -A DOTFILES_PLUGIN_ASC_ARR
update_associative_array_from_array "DOTFILES_PLUGIN_ASC_ARR" "DOTFILES_USER_PLUGIN_ARR" "DOTFILES_PLUGIN_ARR"

# set up plugin configs
if ! command_exists zinit; then
    dotfiles_logging "Zinit is not available. Plugin will not be loaded." "error"
elif [[ ${#DOTFILES_PLUGIN_ASC_ARR[@]} -eq 0 ]]; then
    dotfiles_logging "DOTFILES_PLUGIN_ASC_ARR is empty. No plugin will be loaded." "warn"
else
    :  # TODO: Add plugin-specific setup here if needed
fi


# ------------------------------------------------------------------------------
#
# Completion
#
# - Dependency
#   - Zinit
#
# ------------------------------------------------------------------------------


# zsh completions
if command_exists zinit; then

    local _cmp_script_path="$DOTFILES_DOT_LIB_DIR/zsh/completion.zsh"

    zinit ice wait"0c" lucid blockf \
          atload'[[ -f $_cmp_script_path ]] && source $_cmp_script_path || \
                 dotfiles_logging "Completion script $_cmp_script_path not found." "warn"'
    zinit light zsh-users/zsh-completions
fi


# ------------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------------


# manual directory
ensure_directory $DOTFILES_LOCAL_MAN_DIR
append_dir_to_path "MANPATH" $DOTFILES_LOCAL_MAN_DIR
append_dir_to_path "MANPATH" $DOTFILES_USER_MAN_DIR

# zsh history -> user history
if [[ -d $DOTFILES_USER_HIST_DIR ]]; then
    local _zsh_history_link="$DOTFILES_USER_HIST_DIR/zsh.history"
    [[ -e $_zsh_history_link ]] || ln -s $HISTFILE $_zsh_history_link
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
