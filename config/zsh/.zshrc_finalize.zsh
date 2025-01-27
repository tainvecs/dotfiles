# ------------------------------------------------------------------------------
# history
# ------------------------------------------------------------------------------


export HISTFILE=$ZSH_HISTFILE_PATH


# ------------------------------------------------------------------------------
# keybind
# ------------------------------------------------------------------------------


bindkey -e


# ------------------------------------------------------------------------------
# completion
# ------------------------------------------------------------------------------


# load completion
fpath=($ZSH_COMPLETE_DIR $fpath)

# zsh completions
if [[ ${DOTFILES_PLUGINS[zsh-completions]} = "true" ]]; then

    if [[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]]; then
        zinit ice wait"0c" lucid blockf atload"source $ZDOTDIR/.zshrc_completion.zsh"
        zinit light zsh-users/zsh-completions
    else
        zinit ice wait"0c" lucid blockf
        zinit light zsh-users/zsh-completions
    fi
fi
