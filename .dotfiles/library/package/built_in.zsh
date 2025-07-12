#!/bin/zsh


# ------------------------------------------------------------------------------
#
# git
#
# - References
#   - https://github.com/dandavison/delta
#
# - Dependencies
#   - (optional) delta, themes.gitconfig
#
# ------------------------------------------------------------------------------


function dotfiles_config_git() {

    local _package_name="git"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # delta
    if command_exists "delta"; then

        # themes.gitconfig
        _=$(link_dotfiles_share_config_to_local "delta" "themes.gitconfig" "$_package_name" "themes.gitconfig")

        # delta.gitconfig
        _=$(link_dotfiles_user_config_to_local "delta" "config" "$_package_name" "delta.gitconfig")
        if [[ $? != $RC_SUCCESS ]]; then
            _=$(link_dotfiles_dot_config_to_local "delta" "config" "$_package_name" "delta.gitconfig")
        fi
    fi

    # git
    _=$(link_dotfiles_user_config_to_local "$_package_name" "config" "$_package_name" "user.gitconfig")
    _=$(link_dotfiles_dot_config_to_local "$_package_name" "config" "$_package_name" "config")
}


# ------------------------------------------------------------------------------
#
# ssh: a network protocol that provides a secure way
#      to access and manage remote computers
#
# - References
#   - https://man7.org/linux/man-pages/man1/ssh.1.html
#
# - Environment Variables
#   - SSH_HOME
#   - GIT_SSH_COMMAND
#
# ------------------------------------------------------------------------------


function dotfiles_config_ssh() {

    local _package_name="ssh"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # config dir
    local _config_dir="$DOTFILES_LOCAL_CONFIG_DIR/$_package_name"
    ensure_directory "$_config_dir"
    export SSH_CONFIG_DIR=$_config_dir

    # user config
    local _user_config_link=$(link_dotfiles_user_config_to_local "$_package_name" "config" "$_package_name" "config")

    # known host
    local _known_host_path="$_config_dir/known_hosts"

    # keys
    local _credentials_link=$(link_dotfiles_user_credential_to_local "ssh" "keys" "ssh" "keys")
    export SSH_CRED_DIR=$_credentials_link

    # ssh cmd alias
    local _cmd="ssh -o UserKnownHostsFile=$_known_host_path"
    if [[ -f $_user_config_link ]]; then
        _cmd="ssh -F $_user_config_link -o UserKnownHostsFile=$_known_host_path"
    fi
    alias ssh=$_cmd
    export GIT_SSH_COMMAND=$_cmd
}


# ------------------------------------------------------------------------------
#
# zsh
#
# - Config
#   - alias.zsh
#   - function.zsh
#   - .zshrc
#
# ------------------------------------------------------------------------------


function dotfiles_config_zsh() {

    # .zshrc
    local _config_link=$(link_dotfiles_user_config_to_local "zsh" ".zshrc" "zsh" ".user.zshrc")
    [[ $? -eq $RC_SUCCESS ]] && [[ -n "$_config_link" ]] && source "$_config_link"

    # function.zsh
    local _func_config_link=$(link_dotfiles_user_config_to_local "zsh" "function.zsh" "zsh" "function.zsh")
    [[ $? -eq $RC_SUCCESS ]] && [[ -n "$_func_config_link" ]] && source "$_func_config_link"

    # alias.zsh
    local _alias_config_link=$(link_dotfiles_user_config_to_local "zsh" "alias.zsh" "zsh" "alias.zsh")
    [[ $? -eq $RC_SUCCESS ]] && [[ -n "$_alias_config_link" ]] && source "$_alias_config_link"
}
