#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Zsh Completion: Load and Trigger Completion with Zinit
#
#
# Version: 0.0.2
# Last Modified: 2025-05-22
#
# - Dependency
#   - Tool
#     - Zinit
#   - Environment Variables
#     - DOTFILES_ZSH_COMP_DIR
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
# - Managed Apps and Plugins
#   - docker
#   - docker compose
#   - forgit
#   - gcp
#   - kube
#   - volta
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Prepare Completion Files
# ------------------------------------------------------------------------------


# docker and docker compose
if command_exists "docker"; then

    # docker
    local _docker_cmp_path="$DOTFILES_ZSH_COMP_DIR/_docker"
    [[ -f $_docker_cmp_path ]] || docker completion zsh > $_docker_cmp_path

    # docker compose
    local _docker_comp_cmp_path="$DOTFILES_ZSH_COMP_DIR/_docker-compose"
    if [[ ! -f $_docker_comp_cmp_path ]]; then
        curl -sfLo $_docker_comp_cmp_path \
             "https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"
    fi
fi

# forgit
if is_dotfiles_managed_plugin "forgit"; then
    local _forgit_cmp_path="$DOTFILES_ZSH_COMP_DIR/_forgit"
    if [[ ! -f $_forgit_cmp_path ]]; then
        curl -sfLo $_forgit_cmp_path \
             "https://raw.githubusercontent.com/wfxr/forgit/main/completions/_git-forgit"
    fi
fi

# gcp
if command_exists "gcloud"; then
    local _gcp_cmp_script_path="$DOTFILES_XDG_CONFIG_DIR/gcp/google-cloud-sdk/completion.zsh.inc"
    if [[ -f $_gcp_cmp_script_path ]]; then
        local _gcp_cmp_link="$DOTFILES_ZSH_COMP_DIR/gcp.zsh.inc"
        [[ -L $_gcp_cmp_link || -f $_gcp_cmp_link ]] || ln -s $_gcp_cmp_script_path $_gcp_cmp_link
    fi
fi

# kube
if command_exists "kubectl"; then
    local _kube_cmp_path="$DOTFILES_ZSH_COMP_DIR/_kubectl"
    [[ -f $_kube_cmp_path ]] || kubectl completion zsh > $_kube_cmp_path
fi


# volta
if command_exists "volta"; then
    local _volta_cmp_path="$DOTFILES_ZSH_COMP_DIR/_volta"
    [[ -f $_volta_cmp_path ]] || volta completions --output $_volta_cmp_path
fi


# ------------------------------------------------------------------------------
# Zinit Initialize Completion
# ------------------------------------------------------------------------------


zpcompinit
zpcdreplay


# ------------------------------------------------------------------------------
# Source Completion Scripts
# ------------------------------------------------------------------------------


# 'gcp.zsh.inc'
local _gcp_cmp_link="$DOTFILES_ZSH_COMP_DIR/gcp.zsh.inc"
if command_exists "gcloud" && [[ -f $_gcp_cmp_link ]]; then
    source $_gcp_cmp_link
fi
