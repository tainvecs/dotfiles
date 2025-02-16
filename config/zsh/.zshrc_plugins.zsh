# ------------------------------------------------------------------------------
# zinit
# ------------------------------------------------------------------------------


# check dependency
type zinit >/dev/null || return

# such as amd64 or arm64
ARCHT=${SYS_ARCHT:-$(uname -m)}


# ------------------------------------------------------------------------------
# powerlevel10k
# ------------------------------------------------------------------------------


if [[ ${DOTFILES_PLUGINS[p10k]} = "true" ]]; then

    # ----- cache
    # p10k: should stay close to the top of ~/.zshrc.
    P10K_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    [[ -r "$P10K_CACHE_PATH" ]] && source $P10K_CACHE_PATH

    # ----- zinit
    # install and start p10k
    zinit ice depth"1"
    zinit light romkatv/powerlevel10k

    # ----- config
    # load powerlevel10k theme
    # to customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
    P10K_CONFIG_PATH="${DOTFILES[CONFIG_DIR]}/p10k/.p10k.zsh"
    [[ -r $P10K_CONFIG_PATH ]] && source $P10K_CONFIG_PATH

fi


# ------------------------------------------------------------------------------
# zsh-autosuggestions
# ------------------------------------------------------------------------------


# zsh autosuggestions: trigger precmd hook upon load
if [[ ${DOTFILES_PLUGINS[zsh-autosuggestions]} = "true" ]]; then

    zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
    zinit light zsh-users/zsh-autosuggestions

    export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

fi


# ------------------------------------------------------------------------------
# fast-syntax-highlighting
# ------------------------------------------------------------------------------


# syntax highlighting
if [[ ${DOTFILES_PLUGINS[fast-syntax-highlighting]} = "true" ]]; then

    zinit ice wait"0b" lucid
    zinit light zdharma-continuum/fast-syntax-highlighting

fi


# ------------------------------------------------------------------------------
# bat
# bat-extras
# ------------------------------------------------------------------------------


if [[ ${DOTFILES_PLUGINS[bat]} = "true" ]]; then

    # ----- bat
    if [[ $SYS_NAME == "linux" ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then
        zinit ice wait"0b" lucid from"gh-r" as"program" bpick"bat*$ARCHT*" pick"usr/bin/bat"
    else
        zinit ice wait"0b" lucid from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat"
    fi
    zinit light sharkdp/bat
    alias cat="bat "

    # ----- bat-extras
    if [[ ${DOTFILES_PLUGINS[bat-extras]} = "true" ]]; then

        zinit ice wait"1" lucid as"program" pick"src/batgrep.sh"
        zinit light eth-p/bat-extras

        alias man="batman.sh "

    fi

fi


# ------------------------------------------------------------------------------
# exa
# ------------------------------------------------------------------------------


# exa: replacement for ls
if [[ ${DOTFILES_PLUGINS[exa]} = "true" ]]; then

    zinit ice wait"0c" lucid from"gh-r" as"program" pick"/bin/exa"
    zinit light ogham/exa

    alias ls="exa -l --color auto "
    alias la="exa -la --color auto "
    alias ll="exa -laT -L=2 --color auto "

fi


# ------------------------------------------------------------------------------
# ripgrep
# ------------------------------------------------------------------------------


if [[ ${DOTFILES_PLUGINS[ripgrep]} = "true" ]]; then

    if [[ $SYS_NAME == linux ]] && [[ $ARCHT = "amd64" ]]; then
        zinit ice wait"0c" lucid from"gh-r" as"program" bpick"ripgrep*$ARCHT*" pick"usr/bin/rg"
    else
        zinit ice wait"0c" lucid from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
    fi
    zinit light BurntSushi/ripgrep

    alias rg="rg -p --hidden --no-follow --max-columns 255 --column --glob '!.git' "

    # dependency: bat-extras
    if [[ ${DOTFILES_PLUGINS[bat-extras]} = "true" ]]; then
        alias rg-bat="batgrep.sh -p --hidden --no-follow --glob '!.git' "
    fi

fi


# ------------------------------------------------------------------------------
# fzf
# fd
# ------------------------------------------------------------------------------


# fzf
if [[ ${DOTFILES_PLUGINS[fzf]} = "true" ]]; then

    # fzf
    zinit ice wait"0b" lucid from"gh-r" as"command"
    zinit light junegunn/fzf

    # fzf bynary and tmux helper script
    zinit ice wait"0b" lucid as"command" id-as"junegunn/fzf-tmux" pick"bin/fzf-tmux"
    zinit light junegunn/fzf

    # bind multiple widgets using fzf
    zinit ice wait"0c" lucid multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
    zinit light junegunn/fzf

    # fzf-tab
    zinit ice wait"1" lucid
    zinit light Aloxaf/fzf-tab

    # dependency: fd
    if [[ ${DOTFILES_PLUGINS[fd]} = "true" ]]; then
        export FZF_DEFAULT_COMMAND="fd --type file --hidden --color=always --exclude .git "
        export FZF_DEFAULT_OPTS="--ansi"
    fi

    # dependency: bat
    if [[ ${DOTFILES_PLUGINS[bat]} = "true" ]]; then
        alias pv="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' "
    fi

fi


# fd
if [[ ${DOTFILES_PLUGINS[fd]} = "true" ]]; then

    if [[ $SYS_NAME == "linux" ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then
        zinit ice wait"0c" lucid from"gh-r" as"program" bpick"fd*$ARCHT*" pick"usr/bin/fd"
    else
        zinit ice wait"0c" lucid from"gh-r" as"program" mv"fd* -> fd" pick"fd/fd"
    fi

    zinit light sharkdp/fd

    alias fd="fd --hidden --color=always --exclude .git "

fi


# ------------------------------------------------------------------------------
# z
# ------------------------------------------------------------------------------


# z
if [[ ${DOTFILES_PLUGINS[z]} = "true" ]]; then

    # jump around dir
    zinit ice wait"0c" lucid
    zinit light agkozak/zsh-z

    export ZSHZ_DATA="${DOTFILES[HOME_DIR]}/.z/.z"

    # to be able to work with autoenv
    j() { cd $(z $1 -e || echo $PWD) }

fi


# ------------------------------------------------------------------------------
# delta
# forgit
# ------------------------------------------------------------------------------


# delta: git styling
if [[ ${DOTFILES_PLUGINS[delta]} = "true" ]]; then

    if [[ $SYS_NAME == "linux" ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then
        zinit ice wait"1" lucid from"gh-r" as"program" bpick"*delta*$ARCHT*" pick"usr/bin/delta"
    else
        zinit ice wait"1" lucid as"program" from"gh-r" pick"delta*/delta"
    fi
    zinit light 'dandavison/delta'

    # file diff
    diff(){ delta -s -n $1 $2 }

fi


# forgit: git viewer
if [[ ${DOTFILES_PLUGINS[forgit]} = "true" ]]; then

    zinit ice wait"1" lucid
    zinit load 'wfxr/forgit'

    export FORGIT_NO_ALIASES=true
    export FORGIT_LOG_GRAPH_ENABLE=false
fi


# ------------------------------------------------------------------------------
# docker
# ------------------------------------------------------------------------------


# docker credential helpers
if [[ ${DOTFILES_PLUGINS[docker-credential-helpers]} = "true" ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then

    if [[ $SYS_NAME == "mac" ]]; then

        zinit ice wait"2" lucid from"gh-r" as"program" bpick"docker-credential-osxkeychain-*" \
              mv"docker-credential-osxkeychain-* -> docker-credential-osxkeychain"

    elif [[ $SYS_NAME == "linux" ]]; then
        zinit ice wait"2" lucid from"gh-r" as"program" bpick"docker-credential-secretservice-*" \
              mv"docker-credential-secretservice-* -> docker-credential-secretservice"
    fi

    zinit light docker/docker-credential-helpers
fi


# lazydocker
if [[ ${DOTFILES_PLUGINS[lazydocker]} = "true" ]]; then

    zinit ice wait"2" lucid as"program" from"gh-r" pick"lazydocker"
    zinit light 'jesseduffield/lazydocker'

    alias dtop="lazydocker "

fi


# ------------------------------------------------------------------------------
# bottom
# dust
# duf
# ------------------------------------------------------------------------------


# bottom
if [[ ${DOTFILES_PLUGINS[bottom]} = "true" ]]; then

    if [[ $SYS_NAME == mac ]]; then

        zinit ice wait"2" lucid from"gh-r" as"program" pick"btm"
        zinit light ClementTsang/bottom

    elif [[ $SYS_NAME == linux ]]; then

        zinit ice wait"2" lucid from"gh-r" as"program" bpick='*.deb' pick"usr/bin/btm"
        zinit light ClementTsang/bottom

    fi
fi


# dust: instant overview of which directories are using disk space
if [[ ${DOTFILES_PLUGINS[dust]} = "true" ]]; then

    if [[ $SYS_NAME == linux ]] && [[ $ARCHT = "amd64" ]]; then
        zinit ice wait"2" lucid from"gh-r" as"program" bpick"dust*$ARCHT*" pick"usr/bin/dust"
    else
        zinit ice wait"2" lucid from"gh-r" as"program" mv"dust*/dust -> dust" pick"dust"
    fi
    zinit light bootandy/dust

    alias dir="dust -r "
    alias du="dust -r "

fi


# duf: disk usage
if [[ ${DOTFILES_PLUGINS[duf]} = "true" ]]; then

    if [[ $SYS_NAME == mac ]]; then
        zinit ice wait"2" lucid from"gh-r" as"program" mv="duf* -> duf" pick"duf"
    elif [[ $SYS_NAME == linux ]]; then
        zinit ice wait"2" lucid from"gh-r" as"program" bpick='*.deb' pick"usr/bin/duf"
    fi
    zinit light muesli/duf

    alias df="duf -width 200 "

fi


# ------------------------------------------------------------------------------
# hyperfine
# ------------------------------------------------------------------------------


# hyperfine: benchmark
if [[ ${DOTFILES_PLUGINS[hyperfine]} = "true" ]]; then

    if [[ $SYS_NAME == linux ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then
        zinit ice wait"2" lucid from"gh-r" as"program" bpick"hyperfine*$ARCHT*" pick"usr/bin/hyperfine"
    else
        zinit ice wait"2" lucid from"gh-r" as"program" mv"hyperfine*/hyperfine -> hyperfine" pick"hyperfine"
    fi
    zinit light sharkdp/hyperfine

    alias bm="hyperfine "
    alias bm-zsh='bm "zsh -i -c -x exit" '

fi


# ------------------------------------------------------------------------------
# peco
# ------------------------------------------------------------------------------


# peco: interactive filtering tool
if [[ ${DOTFILES_PLUGINS[peco]} = "true" ]] && [[ $ARCHT = "amd64" || $ARCHT = "arm64" ]]; then
    zinit ice wait"2" lucid from"gh-r" as"program" pick"peco_*/peco"
    zinit light peco/peco
fi


# ------------------------------------------------------------------------------
# OMZ::lib/clipboard.zsh
# OMZ::plugins/copybuffer
# ------------------------------------------------------------------------------


# macOS
if [[ $SYS_NAME = "mac" ]] && [[ ${DOTFILES_PLUGINS[copybuffer]} = "true" ]]; then

    # copy stdin to clipboard
    zinit ice wait"2" lucid
    zinit snippet OMZ::lib/clipboard.zsh

    alias c="clipcopy "

    # ctrl+o copy buffer to clipboard
    zinit ice wait"2" lucid
    zinit snippet OMZ::plugins/copybuffer

fi


# ------------------------------------------------------------------------------
# OMZ::plugins/extract
# OMZ::plugins/universalarchive
# ------------------------------------------------------------------------------


# extract
if [[ ${DOTFILES_PLUGINS[extract]} = "true" ]]; then

    zinit ice wait"2" lucid
    zinit snippet OMZ::plugins/extract

    alias x="extract "

fi


# universalarchive
if [[ ${DOTFILES_PLUGINS[universalarchive]} = "true" ]]; then

    zinit ice wait"2" lucid
    zinit snippet OMZ::plugins/universalarchive

    alias a="ua "

fi


# ------------------------------------------------------------------------------
# OMZ::plugins/urltools
# ------------------------------------------------------------------------------


# urltools: url encode and decode
if [[ ${DOTFILES_PLUGINS[urltools]} = "true" ]]; then

    zinit ice wait"2" lucid
    zinit snippet OMZ::plugins/urltools

    alias url-decode="urldecode "
    alias url-encode="urlencode "

fi


# ------------------------------------------------------------------------------
# dotfiles-aws
# dotfiles-docker
# dotfiles-es
# dotfiles-git
# dotfiles-info
# dotfiles-kube
# dotfiles-mac
# dotfiles-misc
# dotfiles-ms
# dotfiles-network
# dotfiles-update
# dotfiles-vim
# ------------------------------------------------------------------------------


# dotfiles-aws
if [[ ${DOTFILES_PLUGINS[dotfiles-aws]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/aws/.aws.plugin.zsh"
fi

# dotfiles-docker
if [[ ${DOTFILES_PLUGINS[dotfiles-docker]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/docker/.docker.plugin.zsh"
fi

# dotfiles-es
if [[ ${DOTFILES_PLUGINS[dotfiles-es]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/es/.es.plugin.zsh"
fi

# dotfiles-fail2ban
if [[ ${DOTFILES_PLUGINS[dotfiles-fail2ban]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/fail2ban/.fail2ban.plugin.zsh"
fi

# dotfiles-git
if [[ ${DOTFILES_PLUGINS[dotfiles-git]} = "true" ]]; then
    zinit ice wait"1" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/git/.git.plugin.zsh"
fi

# dotfiles-info
if [[ ${DOTFILES_PLUGINS[dotfiles-info]} = "true" ]]; then
    zinit ice wait"1" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/info/.info.plugin.zsh"
fi

# dotfiles-kube
if [[ ${DOTFILES_PLUGINS[dotfiles-kube]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/kube/.kube.plugin.zsh"
fi

# dotfiles-mac
if [[ ${DOTFILES_PLUGINS[dotfiles-mac]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/mac/.mac.plugin.zsh"
fi

# dotfiles-misc
if [[ ${DOTFILES_PLUGINS[dotfiles-misc]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/misc/.misc.plugin.zsh"
fi

# dotfiles-ms
if [[ ${DOTFILES_PLUGINS[dotfiles-ms]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/ms/.ms.plugin.zsh"
fi

# dotfiles-network
if [[ ${DOTFILES_PLUGINS[dotfiles-network]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/network/.network.plugin.zsh"
fi

# dotfiles-update
if [[ ${DOTFILES_PLUGINS[dotfiles-update]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/update/.update.plugin.zsh"
fi

# dotfiles-vim
if [[ ${DOTFILES_PLUGINS[dotfiles-vim]} = "true" ]]; then
    zinit ice wait"2" lucid
    zinit snippet "${DOTFILES[PLUGINS_DIR]}/vim/.vim.plugin.zsh"
fi
