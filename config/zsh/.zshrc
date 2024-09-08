# ------------------------------------------------------------------------------
# initialize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh"
[[ -f "$ZDOTDIR/.zshrc_initialize.zsh.local" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh.local"


# ------------------------------------------------------------------------------
# apps: config
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
