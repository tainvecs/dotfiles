#!/bin/zsh


# Set options for compinit to suppress warnings
ZINIT[COMPINIT_OPTS]=-C

# Initialize completion
zpcompinit

# Replay directory history
zpcdreplay

# source completion script such as 'gcp.zsh.inc'
local _gcp_cmp_link="$ZSH_COMPLETE_DIR/gcp.zsh.inc"

if { type gcloud >"/dev/null" } && [[ -f $_gcp_cmp_link ]]; then
    source $_gcp_cmp_link
fi
