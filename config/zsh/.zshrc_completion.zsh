# zsh completions
if [[ ${DOTFILES_PLUGINS[zsh-completions]} = "true" ]]; then

    zinit ice wait"0c" lucid blockf
    zinit light zsh-users/zsh-completions

fi

# Set options for compinit to suppress warnings
ZINIT[COMPINIT_OPTS]=-C

# Initialize completion
zpcompinit

# Replay directory history
zpcdreplay
