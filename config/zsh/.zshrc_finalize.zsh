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


# zsh completions
if [[ ${DOTFILES_PLUGINS[zsh-completions]} = "true" ]]; then
    local _cmp_script_path="$ZDOTDIR/.zshrc_completion.zsh"
    zinit ice wait"0c" lucid blockf \
        atload"[[ -f $_cmp_script_path ]] && source $_cmp_script_path"
    zinit light zsh-users/zsh-completions
fi
