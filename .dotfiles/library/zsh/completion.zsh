#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Zsh Completion: Load and Trigger Completion with Zinit
#
#
# Version: 0.0.3
# Last Modified: 2025-06-21
#
# - Dependency
#   - Tool
#     - Zinit
#
#   - Environment Variables
#     - DOTFILES_ZSH_COMP_DIR
#
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#     - $DOTFILES_DOT_LIB_DIR/dotfiles/util.zsh
#
# - Managed Apps and Plugins
#   - gcp
#   - zoxide
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Prepare Completion Files
# ------------------------------------------------------------------------------


# docker
if command_exists "docker"; then
    local _docker_cmp_path="$DOTFILES_ZSH_COMP_DIR/_docker"
    [[ -f $_docker_cmp_path ]] || docker completion zsh > $_docker_cmp_path
fi

# gcp
if command_exists "gcloud"; then
    link_dotfiles_local_completion_to_dot "gcp/google-cloud-sdk" "completion.zsh.inc" "gcp.zsh.inc"
fi

# kubectl
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


# zoxide
if command_exists "zoxide"; then
    eval "$(zoxide init zsh)"
fi


# 'gcp.zsh.inc'
local _gcp_cmp_link="$DOTFILES_ZSH_COMP_DIR/gcp.zsh.inc"
if command_exists "gcloud" && [[ -f $_gcp_cmp_link ]]; then
    source $_gcp_cmp_link
fi
