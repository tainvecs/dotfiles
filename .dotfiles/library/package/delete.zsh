#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions for Package Deletion
#
#
# Version: 0.0.1
# Last Modified: 2026-03-23
#
# - Dependency
#   - Environment Variable File
#     - .dotfiles/env/dotfiles.env
#     - .dotfiles/env/return_code.env
#
#   - Environment Variable
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#     - $DOTFILES_DOT_LIB_DIR/dotfiles/util.zsh
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
#
# 7z: a file archiver with a high compression ratio
#
# - Reference
#   - https://www.7-zip.org/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_7z() {

    local _package_name="7z"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="p7zip"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="p7zip-full"
    fi

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# alt-tab: window switching (macOS only)
#
# - Reference
#   - https://alt-tab-macos.netlify.app/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_alt-tab() {

    local _package_name="alt-tab"
    local _package_id="alt-tab"

    # check if installed
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_deletion "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# autoenv: automatically source environment variables
#
# - References
#   - https://github.com/hyperupcall/autoenv
#
# ------------------------------------------------------------------------------


function dotfiles_delete_autoenv() {

    local _package_name="autoenv"
    local _package_id="hyperupcall/autoenv"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "git-repo-pull" "$_package_id"

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
    _cleanup_dotfiles_state_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# aws: AWS command line interface
#
# - References
#   - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# ------------------------------------------------------------------------------


function dotfiles_delete_aws() {

    local _package_name="aws"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        local _package_id="awscli"
        _delete_dotfiles_package "$_package_name" "package-manager" "$_package_id"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # remove share dir (contains the aws install)
        _cleanup_dotfiles_share_dir "$_package_name"
        # remove bin symlinks
        _cleanup_dotfiles_bin_symlinks "$_package_name"
    fi

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# bat: cat clone with syntax highlighting
#
# - References
#   - https://github.com/sharkdp/bat
#
# bat-extras: bash scripts that integrate bat with various command line tools
#
# - Reference
#   - https://github.com/eth-p/bat-extras
#
# ------------------------------------------------------------------------------


function dotfiles_delete_bat() {

    local _package_name="bat"
    local _package_id="sharkdp/bat"
    local _package_plugin_name="bat-extras"
    local _package_plugin_id="eth-p/bat-extras"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete bat
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete bat-extras
    if is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id"; then
        _delete_dotfiles_package "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
    fi

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_bin_symlinks "$_package_plugin_name"
    _cleanup_dotfiles_config_dir "$_package_name"
    _cleanup_dotfiles_completion "_bat"
    _cleanup_dotfiles_man_pages "$_package_name"
    _cleanup_dotfiles_man_pages "$_package_plugin_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# claude-code: an agentic coding tool
#
# - References
#   - https://docs.anthropic.com/en/docs/claude-code
#
# ------------------------------------------------------------------------------


function dotfiles_delete_claude-code() {

    local _package_name="claude-code"
    local _package_dir_name="claude"
    local _bin_name="claude"

    # check if installed
    if ! command_exists "$_bin_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    # remove bin symlink
    [[ -L "$DOTFILES_LOCAL_BIN_DIR/$_bin_name" ]] && rm -f "$DOTFILES_LOCAL_BIN_DIR/$_bin_name"

    # cleanup config dir
    _cleanup_dotfiles_config_dir "$_package_dir_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# delta: a git, diff and grep syntax-highlighting pager
#
# - References
#   - https://github.com/dandavison/delta
#
# ------------------------------------------------------------------------------


function dotfiles_delete_delta() {

    local _package_name="delta"
    local _package_id="dandavison/delta"
    local _package_res_name="delta-res"
    local _package_res_id="dandavison/delta"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete delta
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete delta-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id"; then
        _delete_dotfiles_package "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_delta"
    _cleanup_dotfiles_man_pages "$_package_name"
    _cleanup_dotfiles_share_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# docker: use OS-level virtualization to deliver software in containers
#
# - References
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# docker compose: a tool for defining and running multi-container applications
#
# - References
#   - https://docs.docker.com/compose/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_docker() {

    local _package_name="docker"
    local _docker_comp_cmp_name="_docker-compose"
    local _docker_comp_cmp_id="https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    # delete docker
    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _delete_dotfiles_package "$_package_name" "package-manager" "docker-ce"
        _delete_dotfiles_package "$_package_name" "package-manager" "docker-ce-cli"
        _delete_dotfiles_package "$_package_name" "package-manager" "containerd.io"
        _delete_dotfiles_package "$_package_name" "package-manager" "docker-buildx-plugin"
        _delete_dotfiles_package "$_package_name" "package-manager" "docker-compose-plugin"
    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _delete_dotfiles_package "$_package_name" "package-manager" "docker"
        _delete_dotfiles_package "$_package_name" "package-manager" "docker-compose"
    fi

    # delete docker-compose completion snippet
    if is_dotfiles_package_installed "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_id"; then
        _delete_dotfiles_package "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_name"
    fi

    # cleanup
    _cleanup_dotfiles_completion "_docker"
    _cleanup_dotfiles_completion "_docker-compose"
    _cleanup_dotfiles_config_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# docker-credential-helpers:
#   keeping docker login credentials safe by storing in platform keystores
#
# - References
#   - https://github.com/docker/docker-credential-helpers
#
# ------------------------------------------------------------------------------


function dotfiles_delete_docker-credential-helpers() {

    local _package_name="docker-credential-helpers"
    local _package_id="docker/docker-credential-helpers"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _cleanup_dotfiles_bin_symlinks "docker-credential-osxkeychain"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _cleanup_dotfiles_bin_symlinks "docker-credential-secretservice"
    fi

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# duf: a better 'df' alternative (Disk Usage/Free Utility)
#
# - References
#   - https://github.com/muesli/duf
#
# ------------------------------------------------------------------------------


function dotfiles_delete_duf() {

    local _package_name="duf"
    local _package_id="muesli/duf"
    local _package_res_name="duf-res"
    local _package_res_id="muesli/duf"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete duf
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete duf-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id"; then
        _delete_dotfiles_package "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# dust: a more intuitive version of du in rust
#
# - References
#   - https://github.com/bootandy/dust
#
# ------------------------------------------------------------------------------


function dotfiles_delete_dust() {

    local _package_name="dust"
    local _package_id="bootandy/dust"
    local _package_res_name="dust-res"
    local _package_res_id="bootandy/dust"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete dust
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete dust-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id"; then
        _delete_dotfiles_package "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_dust"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# emacs: a text editors
#
# ------------------------------------------------------------------------------


function dotfiles_delete_emacs() {

    local _package_name="emacs"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="emacs-plus"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="emacs"
    fi

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"
    _cleanup_dotfiles_state_dir "$_package_name"
}


# ------------------------------------------------------------------------------
#
# extract: supporting a wide variety of archive filetypes
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
#
# ------------------------------------------------------------------------------


function dotfiles_delete_extract() {

    local _package_name="extract"
    local _package_id="OMZ::plugins/extract/extract.plugin.zsh"
    local _comp_name="_extract"
    local _comp_id="OMZ::plugins/extract/_extract"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete extract
    _delete_dotfiles_package "$_package_name" "zinit-snippet" "$_package_name"

    # delete _extract completion
    if is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id"; then
        _delete_dotfiles_package "$_comp_name" "zinit-snippet" "$_comp_name"
    fi

    # cleanup
    _cleanup_dotfiles_completion "_extract"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# eza: a modern alternative to ls
#
# - References
#   - https://github.com/eza-community/eza
#
# ------------------------------------------------------------------------------


function dotfiles_delete_eza() {

    local _package_name="eza"
    local _package_id="eza"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# fast-syntax-highlighting: feature-rich syntax highlighting for Zsh
#
# - References
#   - https://github.com/zdharma-continuum/fast-syntax-highlighting
#
# ------------------------------------------------------------------------------


function dotfiles_delete_fast-syntax-highlighting() {

    local _package_name="fast-syntax-highlighting"
    local _package_id="zdharma-continuum/fast-syntax-highlighting"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_completion "_fast-theme"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# fd: a fast and user-friendly alternative to 'find'
#
# - References
#   - https://github.com/sharkdp/fd
#
# ------------------------------------------------------------------------------


function dotfiles_delete_fd() {

    local _package_name="fd"
    local _package_id="sharkdp/fd"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_fd"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# forgit: a utility tool powered by fzf for using git interactively
#
# - References
#   - https://github.com/wfxr/forgit
#
# ------------------------------------------------------------------------------


function dotfiles_delete_forgit() {

    local _package_name="forgit"
    local _package_id="wfxr/forgit"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# fzf: a command-line fuzzy finder
#
# - References
#   - https://github.com/junegunn/fzf
#   - https://github.com/Aloxaf/fzf-tab
#
# ------------------------------------------------------------------------------


function dotfiles_delete_fzf() {

    local _package_name="fzf"
    local _package_id="junegunn/fzf"
    local _package_res_name="fzf-res"
    local _package_res_id="junegunn/fzf"
    local _package_plugin_name="fzf-tab"
    local _package_plugin_id="Aloxaf/fzf-tab"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete fzf
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete fzf-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id"; then
        _delete_dotfiles_package "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi

    # delete fzf-tab
    if is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id"; then
        _delete_dotfiles_package "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
    fi

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# gcp: google cloud platform command line interface
#
# - References
#   - https://cloud.google.com/sdk/docs/configurations
#
# ------------------------------------------------------------------------------


function dotfiles_delete_gcp() {

    local _package_name="gcp"

    # check if installed
    if ! command_exists "gcloud"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
    _cleanup_dotfiles_completion "gcp.zsh.inc"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# go: Go programming language
#
# ------------------------------------------------------------------------------


function dotfiles_delete_go() {

    local _package_name="go"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="go"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="golang-go"
    fi

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
}


# ------------------------------------------------------------------------------
#
# htop: an interactive process viewer
#
# - References
#   - https://github.com/htop-dev/htop
#
# ------------------------------------------------------------------------------


function dotfiles_delete_htop() {

    local _package_name="htop"
    local _package_id="htop"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# hwatch: a 'watch' alternative
#
# - References
#   - https://github.com/blacknon/hwatch
#
# ------------------------------------------------------------------------------


function dotfiles_delete_hwatch() {

    local _package_name="hwatch"
    local _package_id="blacknon/hwatch"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_hwatch"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# hyperfine: a command-line benchmarking tool
#
# - References
#   - https://github.com/sharkdp/hyperfine
#
# ------------------------------------------------------------------------------


function dotfiles_delete_hyperfine() {

    local _package_name="hyperfine"
    local _package_id="sharkdp/hyperfine"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_hyperfine"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# iterm: terminal emulator (macOS only)
#
# - References
#   - https://iterm2.com/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_iterm() {

    local _package_name="iterm"
    local _package_id="iterm2"

    # check if installed
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_deletion "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# jdk: java development kit
#
# ------------------------------------------------------------------------------


function dotfiles_delete_jdk() {

    local _package_name="jdk"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="openjdk"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="default-jdk"
    fi

    # check if installed
    if ! command_exists "java"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# keyd: keyboard remapping (linux only)
#
# - References
#   - https://github.com/rvaiya/keyd
#
# ------------------------------------------------------------------------------


function dotfiles_delete_keyd() {

    local _package_name="keyd"
    local _package_id="rvaiya/keyd"

    # check if installed
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_deletion "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-make-install" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    # stop service
    sudo systemctl stop "$_package_name" 2>/dev/null
    sudo systemctl disable "$_package_name" 2>/dev/null

    # run make uninstall from cloned dir if available
    local _pkg_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name/$_package_name.git"
    if [[ -d "$_pkg_dir" ]] && [[ -f "$_pkg_dir/Makefile" ]]; then
        (cd "$_pkg_dir" && sudo make uninstall 2>/dev/null)
    fi

    # remove share dir
    _cleanup_dotfiles_share_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# kubectl: Kubernetes command line interface
#
# - References
#   - https://kubernetes.io/docs/reference/kubectl/kubectl/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_kubectl() {

    local _package_name="kubectl"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _delete_dotfiles_package "$_package_name" "zinit-snippet" "$_package_name"
    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _delete_dotfiles_package "$_package_name" "package-manager" "$_package_name"
    fi

    # cleanup
    _cleanup_dotfiles_completion "_kubectl"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# nvitop: an interactive NVIDIA-GPU process viewer
#
# - References
#   - https://github.com/XuehaiPan/nvitop
#
# ------------------------------------------------------------------------------


function dotfiles_delete_nvitop() {

    local _package_name="nvitop"
    local _package_id="nvitop"

    # check if installed
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_deletion "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "pip" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# oh my tmux: pretty & versatile tmux configuration
#
# - References
#   - https://github.com/gpakosz/.tmux
#
# ------------------------------------------------------------------------------


function dotfiles_delete_oh-my-tmux() {

    local _package_name="oh-my-tmux"
    local _package_id="gpakosz/.tmux"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup oh-my-tmux config symlink in tmux dir
    local _tmux_config_dir="$DOTFILES_LOCAL_CONFIG_DIR/tmux"
    [[ -L "$_tmux_config_dir/tmux.$_package_name.conf" ]] && rm -f "$_tmux_config_dir/tmux.$_package_name.conf"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# peco: simplistic interactive filtering tool
#
# - References
#   - https://github.com/peco/peco
#
# ------------------------------------------------------------------------------


function dotfiles_delete_peco() {

    local _package_name="peco"
    local _package_id="peco/peco"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# powerlevel10k: zsh theme customization
#
# - References
#   - https://github.com/romkatv/powerlevel10k
#
# ------------------------------------------------------------------------------


function dotfiles_delete_powerlevel10k() {

    local _package_name="powerlevel10k"
    local _package_id="romkatv/powerlevel10k"
    local _package_media_name="powerlevel10k-media"
    local _package_media_id="romkatv/powerlevel10k-media"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete powerlevel10k
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # delete powerlevel10k-media
    if is_dotfiles_package_installed "$_package_media_name" "zinit-plugin" "$_package_media_id"; then
        _delete_dotfiles_package "$_package_media_name" "zinit-plugin" "$_package_media_name"
    fi

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# python: Python programming language
#
# - References
#   - https://docs.python.org/3/using/cmdline.html#environment-variables
#
# ------------------------------------------------------------------------------


function dotfiles_delete_python() {

    local _package_name="python"
    local _package_id="python3"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"
    _cleanup_dotfiles_state_dir "$_package_name"
}


# ------------------------------------------------------------------------------
#
# pyenv: python version management tool
#
# - References
#   - https://github.com/pyenv/pyenv
#
# ------------------------------------------------------------------------------


function dotfiles_delete_pyenv() {

    local _package_name="pyenv"
    local _package_plugin_name="pyenv-virtualenv"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _delete_dotfiles_package "$_package_name" "package-manager" "pyenv"
        _delete_dotfiles_package "$_package_plugin_name" "package-manager" "pyenv-virtualenv"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _delete_dotfiles_package "$_package_name" "git-repo-pull" "pyenv/pyenv"
        _delete_dotfiles_package "$_package_plugin_name" "git-repo-pull" "pyenv/pyenv-virtualenv"
    fi

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
    _cleanup_dotfiles_share_dir "$_package_plugin_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# ripgrep: recursively searches directories for a regex pattern
#   while respecting your gitignore
#
# - References
#   - https://github.com/BurntSushi/ripgrep
#
# ------------------------------------------------------------------------------


function dotfiles_delete_ripgrep() {

    local _package_name="ripgrep"
    local _package_id="BurntSushi/ripgrep"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_rg"
    _cleanup_dotfiles_man_pages "$_package_name"
    _cleanup_dotfiles_config_dir "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# tmux: terminal multiplexer
#
# - References
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# ------------------------------------------------------------------------------


function dotfiles_delete_tmux() {

    local _package_name="tmux"
    local _package_id="tmux"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"
}


# ------------------------------------------------------------------------------
#
# tre: a 'tree' alternative
#
# - References
#   - https://github.com/dduan/tre
#
# ------------------------------------------------------------------------------


function dotfiles_delete_tre() {

    local _package_name="tre"
    local _package_id="tre-command"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# tree: recursive directory listing program
#
# - References
#   - https://github.com/Old-Man-Programmer/tree
#
# ------------------------------------------------------------------------------


function dotfiles_delete_tree() {

    local _package_name="tree"
    local _package_id="tree"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# universalarchive: a convenient command-line interface for archiving files
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/universalarchive
#
# ------------------------------------------------------------------------------


function dotfiles_delete_universalarchive() {

    local _package_name="universalarchive"
    local _package_id="OMZ::plugins/universalarchive/universalarchive.plugin.zsh"
    local _comp_name="_universalarchive"
    local _comp_id="OMZ::plugins/universalarchive/_universalarchive"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete universalarchive
    _delete_dotfiles_package "$_package_name" "zinit-snippet" "$_package_name"

    # delete _universalarchive completion
    if is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id"; then
        _delete_dotfiles_package "$_comp_name" "zinit-snippet" "$_comp_name"
    fi

    # cleanup
    _cleanup_dotfiles_completion "_universalarchive"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# uv: Python package and project manager
#
# - References
#   - https://github.com/astral-sh/uv
#
# ------------------------------------------------------------------------------


function dotfiles_delete_uv() {

    local _package_name="uv"
    local _package_id="astral-sh/uv"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_uv"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# vim: a text editors
#
# - References
#   - https://www.vim.org/docs.php
#
# ------------------------------------------------------------------------------


function dotfiles_delete_vim() {

    local _package_name="vim"
    local _package_id="vim"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    # cleanup
    _cleanup_dotfiles_config_dir "$_package_name"
    _cleanup_dotfiles_state_dir "$_package_name"
}


# ------------------------------------------------------------------------------
#
# volta: JavaScript tool manager
#
# - References
#   - https://volta.sh/
#
# ------------------------------------------------------------------------------


function dotfiles_delete_volta() {

    local _package_name="volta"

    # check if installed
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    log_dotfiles_package_deletion "$_package_name" "delete"

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
    _cleanup_dotfiles_completion "_volta"
    _cleanup_dotfiles_bin_symlinks "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# vscode: code editor
#
# - References
#   - https://github.com/microsoft/vscode
#
# ------------------------------------------------------------------------------


function dotfiles_delete_vscode() {

    local _package_name="vscode"

    # check if installed
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        local _package_id="visual-studio-code"

        if ! { is_dotfiles_package_installed "$_package_name" "brew-cask" "$_package_id" }; then
            log_dotfiles_package_deletion "$_package_name" "not-found"
            return $RC_NOT_FOUND
        fi

        delete_dotfiles_packages "$_package_name" "brew-cask" "$_package_id"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        local _package_id="code"

        if ! command_exists "$_package_id"; then
            log_dotfiles_package_deletion "$_package_name" "not-found"
            return $RC_NOT_FOUND
        fi

        delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# watch: running commands periodically
#
# - References
#   - https://man7.org/linux/man-pages/man1/watch.1.html
#
# ------------------------------------------------------------------------------


function dotfiles_delete_watch() {

    local _package_name="watch"
    local _package_id="watch"

    # check if installed
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_deletion "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    delete_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# zinit: zsh plugin manager
#
# - Reference
#   - https://github.com/zdharma-continuum/zinit
#
# ------------------------------------------------------------------------------


function dotfiles_delete_zinit() {

    local _package_name="zinit"
    local _package_id="zdharma-continuum/zinit"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "git-repo-pull" "$_package_id"

    # cleanup
    _cleanup_dotfiles_share_dir "$_package_name"
    _cleanup_dotfiles_completion "_zinit"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# zoxide: a smarter cd command
#
# - References
#   - https://github.com/ajeetdsouza/zoxide
#
# ------------------------------------------------------------------------------


function dotfiles_delete_zoxide() {

    local _package_name="zoxide"
    local _package_id="ajeetdsouza/zoxide"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    # cleanup
    _cleanup_dotfiles_bin_symlinks "$_package_name"
    _cleanup_dotfiles_completion "_zoxide"
    _cleanup_dotfiles_man_pages "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# zsh-autosuggestions: command line auto-completion
#
# - References
#   - https://github.com/zsh-users/zsh-autosuggestions
#
# ------------------------------------------------------------------------------


function dotfiles_delete_zsh-autosuggestions() {

    local _package_name="zsh-autosuggestions"
    local _package_id="zsh-users/zsh-autosuggestions"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}


# ------------------------------------------------------------------------------
#
# zsh-completions:
#
# - References
#   - https://github.com/zsh-users/zsh-completions
#
# ------------------------------------------------------------------------------


function dotfiles_delete_zsh-completions() {

    local _package_name="zsh-completions"
    local _package_id="zsh-users/zsh-completions"

    # check if installed
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        log_dotfiles_package_deletion "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # delete
    _delete_dotfiles_package "$_package_name" "zinit-plugin" "$_package_name"

    log_dotfiles_package_deletion "$_package_name" "success"
}
