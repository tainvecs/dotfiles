# ------------------------------------------------------------------------------
# dotfiles: root, home, config, local, library and resource
# ------------------------------------------------------------------------------


declare -A DOTFILES

# root
DOTFILES[ROOT_DIR]="${DOTFILES_ROOT_DIR:-$HOME/dotfiles}"

# home
DOTFILES[HOME_DIR]="${DOTFILES[ROOT_DIR]}/home"

# config
DOTFILES[CONFIG_DIR]="${DOTFILES[ROOT_DIR]}/config"
export XDG_CONFIG_HOME=${DOTFILES[CONFIG_DIR]}

# local
DOTFILES[LOCAL_DIR]="${DOTFILES[ROOT_DIR]}/local"
DOTFILES[LOCAL_CONFIG_DIR]="${DOTFILES[LOCAL_DIR]}/config"
DOTFILES[LOCAL_PLUGIN_DIR]="${DOTFILES[LOCAL_DIR]}/plugins"

# library
DOTFILES[LIB_DIR]="${DOTFILES[ROOT_DIR]}/library"

# resource
DOTFILES[RESOURCE_DIR]="${DOTFILES[ROOT_DIR]}/resources"

# cache
export XDG_CACHE_HOME="${DOTFILES[ROOT_DIR]}/cache"

# share
export XDG_DATA_HOME="${DOTFILES[ROOT_DIR]}/share"

# state
export XDG_STATE_HOME="${DOTFILES[ROOT_DIR]}/state"

# runtime
export XDG_RUNTIME_DIR="${DOTFILES[ROOT_DIR]}/runtime"

export DOTFILES


# ------------------------------------------------------------------------------
# zsh: home, sessions, history, and compinit
# ------------------------------------------------------------------------------


# home
export ZDOTDIR="${DOTFILES[HOME_DIR]}/.zsh"

# sessions
export SHELL_SESSION_DIR="$ZDOTDIR/.zsh_sessions"
export SHELL_SESSION_FILE="$SHELL_SESSION_DIR/$TERM_SESSION_ID.session"
export SHELL_SESSION_HISTFILE="$SHELL_SESSION_DIR/$TERM_SESSION_ID.history"
export SHELL_SESSION_HISTFILE_NEW="$SHELL_SESSION_DIR/$TERM_SESSION_ID.historynew"
export SHELL_SESSION_TIMESTAMP_FILE="$SHELL_SESSION_DIR/_expiration_check_timestamp"

# history
export ZSH_HISTFILE_PATH="$ZDOTDIR/.zsh_history"

# compinit
export ZSH_COMPLETE_DIR="$ZDOTDIR/.zsh_complete"
export ZSH_COMPDUMP_PATH="$ZSH_COMPLETE_DIR/.zcompdump"


# ------------------------------------------------------------------------------
# dotfiles: apps
# ------------------------------------------------------------------------------


# apps
declare -a APP_ARR=(

    "7z"
    "alt-tab"
    "autoenv"
    # "aws"
    # "clojure"
    "coreutils"
    # "docker"
    # "elasticsearch"
    # "emacs"
    # "gcp"
    # "golang"
    "htop"
    "iterm"
    "jdk"
    # "keyd"
    # "kube"
    # "meilisearch"
    # "nvitop"
    # "nvtop"
    # "openvpn"
    "python"
    "pyenv"
    "svn"
    "tmux"
    "tree"
    "vim"
    # "vscode"
    # "volta"
    "watch"

)

declare -A DOTFILES_APPS

for a_name in ${APP_ARR[@]}; do
    DOTFILES_APPS[$a_name]="true"
done

export DOTFILES_APPS


# ------------------------------------------------------------------------------
# dotfiles: plugins
# ------------------------------------------------------------------------------


# plugins
DOTFILES[PLUGINS_DIR]="${DOTFILES[ROOT_DIR]}/plugins"

declare -a PLUGIN_ARR=(

    "bat"
    "bat-extras"
    # "bottom"
    "copybuffer"
    "delta"
    # "docker-credential-helpers"
    # "duf"
    # "dust"
    "exa"
    "extract"
    "fast-syntax-highlighting"
    "fd"
    "forgit"
    "fzf"
    # "hyperfine"
    # "lazydocker"
    "p10k"
    # "peco"
    "ripgrep"
    "universalarchive"
    # "urltools"
    "z"
    "zsh-autosuggestions"
    "zsh-completions"

    # "dotfiles-aws"
    # "dotfiles-docker"
    # "dotfiles-es"
    # "dotfiles-fail2ban"
    "dotfiles-git"
    # "dotfiles-info"
    # "dotfiles-kube"
    "dotfiles-mac"
    "dotfiles-misc"
    # "dotfiles-ms"
    # "dotfiles-network"
    "dotfiles-update"
    # "dotfiles-vim"

)

declare -A DOTFILES_PLUGINS

for p_name in ${PLUGIN_ARR[@]}; do
    DOTFILES_PLUGINS[$p_name]="true"
done

export DOTFILES_PLUGINS


# ------------------------------------------------------------------------------
# dotfiles: library
# ------------------------------------------------------------------------------


source "${DOTFILES[LIB_DIR]}/sys.zsh"


# ------------------------------------------------------------------------------
# sys
# ------------------------------------------------------------------------------


export SYS_NAME=`get_system_name`
export SYS_ARCHT=`get_system_architecture`


# ------------------------------------------------------------------------------
# brew
# ------------------------------------------------------------------------------


if [[ $SYS_NAME = "mac" ]]; then

    if [[ -d "/opt/homebrew" ]]; then
        export BREW_HOME="/opt/homebrew"
    elif [[ -d "/usr/local/Homebrew" ]]; then
        export BREW_HOME="/usr/local"
    fi

fi


# ------------------------------------------------------------------------------
# zinit
# ------------------------------------------------------------------------------


declare -A ZINIT

ZINIT[HOME_DIR]="$ZDOTDIR/.zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"
ZINIT[ZCOMPDUMP_PATH]=$ZSH_COMPDUMP_PATH

export ZINIT


# ------------------------------------------------------------------------------
# iterm
# ------------------------------------------------------------------------------


# iterm with tmux
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX="YES"


# ------------------------------------------------------------------------------
# editor: less, vim, and emacs
# ------------------------------------------------------------------------------


# editor
if type vim >"/dev/null"; then
    export VISUAL="vim"
elif type emacs >"/dev/null"; then
    export VISUAL="emacs"
fi
export EDITOR=$VISUAL
export SUDO_EDITOR=$VISUAL
export SELECTED_EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL


# less
export LESSHISTFILE="${DOTFILES[HOME_DIR]}/less/.lesshst"


# ------------------------------------------------------------------------------
# misc: locale, color and fonts
# ------------------------------------------------------------------------------


# locale
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# color
export TERM="xterm-256color"


# fonts
if [[ $SYS_NAME = "mac" ]]; then

    export FONTS_DIR="$HOME/Library/Fonts"

elif [[ $SYS_NAME = "linux" ]]; then

    export FONTS_DIR="$XDG_DATA_HOME/fonts"

fi


# ------------------------------------------------------------------------------
# local
# ------------------------------------------------------------------------------


if [[ -f "$ZDOTDIR/.zshenv.local" ]]; then
    source "$ZDOTDIR/.zshenv.local"
elif [[ -f "${DOTFILES[CONFIG_DIR]}/zsh/.zshenv.local" ]]; then
    source "${DOTFILES[CONFIG_DIR]}/zsh/.zshenv.local"
elif [[ -f "${DOTFILES[LOCAL_CONFIG_DIR]}/zsh/.zshenv.local" ]]; then
    source "${DOTFILES[LOCAL_CONFIG_DIR]}/zsh/.zshenv.local"
fi
