# ------------------------------------------------------------------------------
# PATH and FPATH
#
# - references
#   - https://github.zshell.dev/post/zsh/cheatsheet/typeset/
# ------------------------------------------------------------------------------


typeset -U path fpath

path=(
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
    "${(@)path}"
)

fpath=(
    $ZSH_COMPLETE_DIR
    "${(@)fpath}"
)


# ------------------------------------------------------------------------------
# brew
#
# - envs
#   - HOMEBREW_PREFIX
#   - HOMEBREW_CELLAR
#   - HOMEBREW_REPOSITORY
# ------------------------------------------------------------------------------


# set envs, fpath, PATH, MANPATH and INFOPATH
if [[ ! -z "${BREW_HOME}" ]]; then
    eval $("${BREW_HOME}/bin/brew" shellenv)
fi


# ------------------------------------------------------------------------------
# zinit
# ------------------------------------------------------------------------------


if [[ -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    source "${ZINIT[BIN_DIR]}/zinit.zsh"
fi
