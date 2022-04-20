# If not running interactively, don't do anything
# [[ -o interactive ]] || return


# ------------------------------------------------------------------------------
# initialize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh"


# ------------------------------------------------------------------------------
# plugins
# dependency: zinit
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_plugins.zsh" ]] && source "$ZDOTDIR/.zshrc_plugins.zsh"


# ------------------------------------------------------------------------------
# config
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_apps.zsh" ]] && source "$ZDOTDIR/.zshrc_apps.zsh"


# ------------------------------------------------------------------------------
# finalize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_finalize.zsh" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh"
