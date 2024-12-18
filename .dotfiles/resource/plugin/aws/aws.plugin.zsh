#!/bin/zsh


# return if aws-cli not installed
type aws >/dev/null || return

# env for dotfiles plugin versioning
export DOTFILES_PLUGIN_AWS_VERSION=1.0.0

# account
# - https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-caller-identity.html?highlight=get%20caller%20identity
alias aws-account="aws sts get-caller-identity"

# profile
# - https://awscli.amazonaws.com/v2/documentation/api/latest/reference/configure/list.html
alias aws-status="aws configure list"
