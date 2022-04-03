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


[[ -f "${DOTFILES[CONFIG_DIR]}/dotfiles/.plugins.zsh" ]] && source "${DOTFILES[CONFIG_DIR]}/dotfiles/.plugins.zsh"


# ------------------------------------------------------------------------------
# config
# ------------------------------------------------------------------------------


[[ -f "${DOTFILES[CONFIG_DIR]}/dotfiles/.config.zsh" ]] && source "${DOTFILES[CONFIG_DIR]}/dotfiles/.config.zsh"


# ------------------------------------------------------------------------------
# finalize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_finalize.zsh" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh"
