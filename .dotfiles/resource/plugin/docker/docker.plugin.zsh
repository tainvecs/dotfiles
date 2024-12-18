#!/bin/zsh


# return if docker not installed
type docker >/dev/null || return

# env for dotfiles plugin versioning
export DOTFILES_PLUGIN_DOCKER_VERSION=1.0.0

# ----- login

# gitlab
# - $1: <username> of gitlab account
# - reference: https://docs.gitlab.com/ee/user/packages/container_registry/authenticate_with_container_registry.html
function docker-login-gitlab(){

    # check if arg missing
    if [[ -z $1 ]]; then
        echo 'error: missing argument.'
        echo '$1: <username> of gitlab account'
        return 1
    fi

    # login with password from stdin
    docker login 'registry.gitlab.com' -u $1 --password-stdin
}
