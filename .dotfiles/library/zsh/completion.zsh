#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Zsh Completion: Load and Trigger Completion with Zinit
#
#
# Version: 0.0.6
# Last Modified: 2025-07-06
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
#   - docker
#   - gcp
#   - kubectl
#   - volta
#   - zinit
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Prepare Completion Files
# ------------------------------------------------------------------------------


ensure_directory "$DOTFILES_ZSH_COMP_DIR"


# docker
if command_exists "docker"; then
    local _cmp_path="$DOTFILES_ZSH_COMP_DIR/_docker"
    if [[ ! -f $_cmp_path ]]; then
        docker completion zsh > $_cmp_path || log_message "Failed to generate docker completion $_cmp_path" "error"
    fi
fi

# gcp
if command_exists "gcloud"; then
    _=$(link_dotfiles_share_completion_to_local "gcp/google-cloud-sdk" "completion.zsh.inc" "gcp.zsh.inc")
fi

# kubectl
if command_exists "kubectl"; then
    local _cmp_path="$DOTFILES_ZSH_COMP_DIR/_kubectl"
    if [[ ! -f $_cmp_path ]]; then
        kubectl completion zsh > $_cmp_path || log_message "Failed to generate kubectl completion $_cmp_path" "error"
    fi
fi

# volta
if command_exists "volta"; then
    local _cmp_path="$DOTFILES_ZSH_COMP_DIR/_volta"
    if [[ ! -f $_cmp_path ]]; then
        volta completions --output $_cmp_path zsh || log_message "Failed to generate volta completion $_cmp_path" "error"
    fi
fi

# zinit
if command_exists "zinit"; then
    _=$(link_dotfiles_share_completion_to_local "zinit/zinit.git" "_zinit" "_zinit")
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
local _cmp_link="$DOTFILES_ZSH_COMP_DIR/gcp.zsh.inc"
if command_exists "gcloud" && [[ -f $_cmp_link ]]; then
    source $_cmp_link || log_message "Failed to source gcp completion $_cmp_link" "error"
fi
