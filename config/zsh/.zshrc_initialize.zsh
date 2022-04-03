# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------


typeset -U path

if [[ ! -z ${BREW_HOME+x} ]]; then
    
    path=(
        $BREW_HOME/bin
        $BREW_HOME/sbin
        /usr/local/bin
        /usr/local/sbin
        /usr/bin
        /usr/sbin
        /bin
        /sbin
        $path
    )

else

    path=(
        /usr/local/bin
        /usr/local/sbin
        /usr/bin
        /usr/sbin
        /bin
        /sbin
        $path
    )

fi 

export PATH


# ------------------------------------------------------------------------------
# brew
# ------------------------------------------------------------------------------


if [[ ! -z ${BREW_HOME+x} ]]; then

    export HOMEBREW_NO_AUTO_UPDATE=1

    # pyenv
    if type pyenv >/dev/null; then
        alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    fi

fi


# ------------------------------------------------------------------------------
# zinit
# ------------------------------------------------------------------------------


if [[ -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then

    source "${ZINIT[BIN_DIR]}/zinit.zsh"

fi
