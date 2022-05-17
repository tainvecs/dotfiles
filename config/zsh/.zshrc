# If not running interactively, don't do anything
# [[ -o interactive ]] || return


# ------------------------------------------------------------------------------
# initialize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh"
[[ -f "$ZDOTDIR/.zshrc_initialize.zsh.local" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh.local"


# ------------------------------------------------------------------------------
# config
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_apps.zsh" ]] && source "$ZDOTDIR/.zshrc_apps.zsh"
[[ -f "$ZDOTDIR/.zshrc_apps.zsh.local" ]] && source "$ZDOTDIR/.zshrc_apps.zsh.local"


# ------------------------------------------------------------------------------
# plugins
# dependency: zinit
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_plugins.zsh" ]] && source "$ZDOTDIR/.zshrc_plugins.zsh"
[[ -f "$ZDOTDIR/.zshrc_plugins.zsh.local" ]] && source "$ZDOTDIR/.zshrc_plugins.zsh.local"


# ------------------------------------------------------------------------------
# finalize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_finalize.zsh" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh"
[[ -f "$ZDOTDIR/.zshrc_finalize.zsh.local" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh.local"


# ------------------------------------------------------------------------------
# local
# ------------------------------------------------------------------------------


if [[ -f "$ZDOTDIR/.zshrc.local" ]]; then
    source "$ZDOTDIR/.zshrc.local"
elif [[ -f "${DOTFILES[CONFIG_DIR]}/zsh/.zshrc.local" ]]; then
    source "${DOTFILES[CONFIG_DIR]}/zsh/.zshrc.local"
fi
