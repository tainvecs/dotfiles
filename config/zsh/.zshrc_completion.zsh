#!/bin/zsh


# Set options for compinit to suppress warnings
ZINIT[COMPINIT_OPTS]=-C


# Prepare completion files

# docker and docker compose
if type docker >"/dev/null"; then

    # docker
    local _docker_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_docker"
    local _docker_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_docker"

    [[ -f $_docker_cmp_path ]] || docker completion zsh > $_docker_cmp_path
    [[ -L $_docker_cmp_link || -f $_docker_cmp_link ]] || ln -s $_docker_cmp_path $_docker_cmp_link

    # docker compose
    local _docker_comp_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_docker-compose"
    local _docker_comp_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_docker-compose"

    if [[ ! -f $_docker_comp_cmp_path ]]; then
        curl -sfLo $_docker_comp_cmp_path \
             "https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"
    fi
    [[ -L $_docker_comp_cmp_link || -f $_docker_comp_cmp_link ]] || ln -s $_docker_comp_cmp_path $_docker_comp_cmp_link
fi

# forgit: git viewer
if [[ ${DOTFILES_PLUGINS[forgit]} = "true" ]]; then

    local _forgit_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_forgit"
    local _forgit_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_forgit"

    if [[ ! -f $_forgit_cmp_path ]]; then
        curl -sfLo $_forgit_cmp_path \
             "https://raw.githubusercontent.com/wfxr/forgit/main/completions/_git-forgit"
    fi
    [[ -L $_forgit_cmp_link || -f $_forgit_cmp_link ]] || ln -s $_forgit_cmp_path $_forgit_cmp_link
fi

# gcp
if type gcloud >"/dev/null"; then
    local _gcp_cmp_script_path="${DOTFILES[HOME_DIR]}/.gcp/google-cloud-sdk/completion.zsh.inc"
    if [[ -f $_gcp_cmp_script_path ]]; then
        local _gcp_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/gcp.zsh.inc"
        local _gcp_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/gcp.zsh.inc"
        [[ -L $_gcp_cmp_path || -f $_gcp_cmp_path ]] || ln -s $_gcp_cmp_script_path $_gcp_cmp_path
        [[ -L $_gcp_cmp_link || -f $_gcp_cmp_link ]] || ln -s $_gcp_cmp_path $_gcp_cmp_link
    fi
fi

# kube
if type kubectl >"/dev/null"; then
    local _kube_cmp_path="${DOTFILES[CONFIG_DIR]}/zsh/.zsh_complete/_kubectl"
    local _kube_cmp_link="${DOTFILES[HOME_DIR]}/.zsh/.zsh_complete/_kubectl"
    [[ -f $_kube_cmp_path ]] || kubectl completion zsh > $_kube_cmp_path
    [[ -L $_kube_cmp_link || -f $_kube_cmp_link ]] || ln -s $_kube_cmp_path $_kube_cmp_link
fi


# Initialize completion
zpcompinit

# Replay directory history
zpcdreplay

# source completion script such as 'gcp.zsh.inc'
local _gcp_cmp_link="$ZSH_COMPLETE_DIR/gcp.zsh.inc"

if { type gcloud >"/dev/null" } && [[ -f $_gcp_cmp_link ]]; then
    source $_gcp_cmp_link
fi
