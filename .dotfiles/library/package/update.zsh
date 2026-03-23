#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions for Package Update
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
# - Dependency
#   - unzip
#
# ------------------------------------------------------------------------------


function dotfiles_update_7z() {

    local _package_name="7z"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="p7zip"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="p7zip-full"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "unzip"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# alt-tab: window switching (macOS only)
#
# - Reference
#   - https://alt-tab-macos.netlify.app/
#
# ------------------------------------------------------------------------------


function dotfiles_update_alt-tab() {

    local _package_name="alt-tab"
    local _package_id="alt-tab"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# autoenv: automatically source environment variables
#
# - References
#   - https://github.com/hyperupcall/autoenv
#
# ------------------------------------------------------------------------------


function dotfiles_update_autoenv() {

    local _package_name="autoenv"
    local _package_id="hyperupcall/autoenv"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# aws: AWS command line interface
#
# - References
#   - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# - Dependencies
#   - curl
#   - unzip
#
# ------------------------------------------------------------------------------


function dotfiles_update_aws() {

    local _package_name="aws"
    local _package_id

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_dotfiles_package_update "$_package_name" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl" || ! command_exists "unzip"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        _package_id="awscli"
        update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # tmp directory for installer
        local _tmp_dir=$(mktemp -d)
        trap 'rm -rf "$_tmp_dir"' EXIT  # Ensure cleanup on exit

        local _bin_dir="$DOTFILES_LOCAL_BIN_DIR"
        local _install_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"

        local _bin_archt
        if [[ $DOTFILES_SYS_ARCHT == "arm64" ]]; then
            _bin_archt="aarch64"
        elif [[ $DOTFILES_SYS_ARCHT == "amd64" ]]; then
            _bin_archt="x86_64"
        fi

        local _zip_url="https://awscli.amazonaws.com/awscli-exe-linux-$_bin_archt.zip"
        local _zip_path="$_tmp_dir/awscliv2.zip"

        # Download the installer
        curl -fL "$_zip_url" -o "$_zip_path" || {
            log_dotfiles_package_update "$_package_name" "fail"
            return $RC_ERROR
        }

        # Unzip the installer
        unzip "$_zip_path" -d "$_tmp_dir" || {
            log_dotfiles_package_update "$_package_name" "fail"
            return $RC_ERROR
        }

        # Upgrade
        log_dotfiles_package_update "$_package_name" "upgrade"
        sudo "$_tmp_dir/aws/install" --bin-dir "$_bin_dir" --install-dir "$_install_dir" --update

        if [[ $? -eq $RC_SUCCESS ]]; then
            log_dotfiles_package_update "$_package_name" "success"
        else
            log_dotfiles_package_update "$_package_name" "fail"
            return $RC_ERROR
        fi
    fi
}


# ------------------------------------------------------------------------------
#
# bat: cat clone with syntax highlighting
#
# - References
#   - https://github.com/sharkdp/bat
#
# bat-extras: bash scripts that integrate bat with various command line tools
#   - batgrep
#   - batman
#   - prettybat
#
# - Reference
#   - https://github.com/eth-p/bat-extras
#   - https://github.com/eth-p/bat-extras/blob/master/doc/prettybat.md#languages
#
# - Dependency
#   - (optional) shfmt
#   - (optional) yq
#
# ------------------------------------------------------------------------------


function dotfiles_update_bat() {

    local _package_name="bat"
    local _package_plugin_name="bat-extras"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # bat
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "sharkdp/bat"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # bat-extras
    if is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "eth-p/bat-extras"; then
        update_dotfiles_packages "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
    fi
}


# ------------------------------------------------------------------------------
#
# claude-code: an agentic coding tool
#
# - References
#   - https://docs.anthropic.com/en/docs/claude-code
#
# - Dependency
#   - curl
#
# ------------------------------------------------------------------------------


function dotfiles_update_claude-code() {

    local _package_name="claude-code"
    local _bin_name="claude"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_bin_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    log_dotfiles_package_update "$_package_name" "upgrade"

    if $_bin_name update; then
        log_dotfiles_package_update "$_package_name" "success"
    else
        log_dotfiles_package_update "$_package_name" "up-to-date"
    fi
}


# ------------------------------------------------------------------------------
#
# delta: a git, diff and grep syntax-highlighting pager
#
# - References
#   - https://github.com/dandavison/delta
#
# ------------------------------------------------------------------------------


function dotfiles_update_delta() {

    local _package_name="delta"
    local _package_res_name="delta-res"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # delta
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "dandavison/delta"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # delta-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "dandavison/delta"; then
        update_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi
}


# ------------------------------------------------------------------------------
#
# docker: use OS-level virtualization to deliver software in containers
#
# - References
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# - Dependencies
#   - curl
#   - gpg
#
# docker compose: a tool for defining and running multi-container applications
#
# - References
#   - https://docs.docker.com/compose/
#
# ------------------------------------------------------------------------------


function dotfiles_update_docker() {

    local _package_name="docker"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        update_dotfiles_packages "$_package_name" "package-manager" \
                                 "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        update_dotfiles_packages "$_package_name" "package-manager" "docker docker-compose"
    fi

    # docker-compose completion
    local _docker_comp_cmp_name="_docker-compose"
    local _docker_comp_cmp_id="https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"

    if is_dotfiles_package_installed "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_id"; then
        update_dotfiles_packages "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_name"
    fi
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


function dotfiles_update_docker-credential-helpers() {

    local _package_name="docker-credential-helpers"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "docker/docker-credential-helpers" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# duf: a better 'df' alternative (Disk Usage/Free Utility)
#
# - References
#   - https://github.com/muesli/duf
#
# ------------------------------------------------------------------------------


function dotfiles_update_duf() {

    local _package_name="duf"
    local _package_res_name="duf-res"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # duf
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "muesli/duf"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # duf-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "muesli/duf"; then
        update_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi
}


# ------------------------------------------------------------------------------
#
# dust: a more intuitive version of du in rust
#
# - References
#   - https://github.com/bootandy/dust
#
# ------------------------------------------------------------------------------


function dotfiles_update_dust() {

    local _package_name="dust"
    local _package_res_name="dust-res"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # dust
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "bootandy/dust"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # dust-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "bootandy/dust"; then
        update_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi
}


# ------------------------------------------------------------------------------
#
# emacs: a text editors
#
# ------------------------------------------------------------------------------


function dotfiles_update_emacs() {

    local _package_name="emacs"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="emacs-plus"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="emacs"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# extract: supporting a wide variety of archive filetypes
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
#
# ------------------------------------------------------------------------------


function dotfiles_update_extract() {

    local _package_name="extract"
    local _package_id="OMZ::plugins/extract/extract.plugin.zsh"
    local _comp_name="_extract"
    local _comp_id="OMZ::plugins/extract/_extract"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # extract
    if is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id"; then
        update_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # _extract completion
    if is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id"; then
        update_dotfiles_packages "$_comp_name" "zinit-snippet" "$_comp_name"
    fi
}


# ------------------------------------------------------------------------------
#
# eza: a modern alternative to ls
#
# - References
#   - https://github.com/eza-community/eza
#   - https://github.com/eza-community/eza-themes
#
# - Dependencies:
#   - (linux) gpg
#
# ------------------------------------------------------------------------------


function dotfiles_update_eza() {

    local _package_name="eza"
    local _package_id="eza"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# fast-syntax-highlighting: feature-rich syntax highlighting for Zsh
#
# - References
#   - https://github.com/zdharma-continuum/fast-syntax-highlighting
#
# ------------------------------------------------------------------------------


function dotfiles_update_fast-syntax-highlighting() {

    local _package_name="fast-syntax-highlighting"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "zdharma-continuum/fast-syntax-highlighting" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# fd: a fast and user-friendly alternative to 'find'
#
# - References
#   - https://github.com/sharkdp/fd
#
# ------------------------------------------------------------------------------


function dotfiles_update_fd() {

    local _package_name="fd"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "sharkdp/fd" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# forgit: a utility tool powered by fzf for using git interactively
#
# - References
#   - https://github.com/wfxr/forgit
#
# - Dependencies
#   - fzf
#   - (optional) bat
#   - (optional) delta
#   - (optional) tree
#
# ------------------------------------------------------------------------------


function dotfiles_update_forgit() {

    local _package_name="forgit"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "wfxr/forgit" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# fzf: Installs fzf for a command-line fuzzy finder
#
# - References
#   - https://github.com/junegunn/fzf
#   - https://github.com/Aloxaf/fzf-tab
#
# - Dependencies
#   - (optional) bat
#   - (optional) chafa
#   - (optional) fd
#
# ------------------------------------------------------------------------------


function dotfiles_update_fzf() {

    local _package_name="fzf"
    local _package_res_name="fzf-res"
    local _package_plugin_name="fzf-tab"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # fzf
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "junegunn/fzf"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # fzf-res
    if is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "junegunn/fzf"; then
        update_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi

    # fzf-tab
    if is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "Aloxaf/fzf-tab"; then
        update_dotfiles_packages "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
    fi
}


# ------------------------------------------------------------------------------
#
# gcp: google cloud platform command line interface
#
# - References
#   - https://cloud.google.com/sdk/docs/configurations
#
# - Dependencies
#   - curl
#
# ------------------------------------------------------------------------------


function dotfiles_update_gcp() {

    local _package_name="gcp"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "gcloud"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    log_dotfiles_package_update "$_package_name" "upgrade"

    if gcloud components update --quiet; then
        log_dotfiles_package_update "$_package_name" "success"
    else
        log_dotfiles_package_update "$_package_name" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# go: Go programming language
#
# ------------------------------------------------------------------------------


function dotfiles_update_go() {

    local _package_name="go"
    local _package_id

    # select package name
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="go"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="golang-go"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# htop: an interactive process viewer
#
# - References
#   - https://github.com/htop-dev/htop
#
# ------------------------------------------------------------------------------


function dotfiles_update_htop() {

    local _package_name="htop"
    local _package_id="htop"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# hwatch: a 'watch' alternative
#
# - References
#   - https://github.com/blacknon/hwatch
#
# ------------------------------------------------------------------------------


function dotfiles_update_hwatch() {

    local _package_name="hwatch"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "blacknon/hwatch" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# hyperfine: a command-line benchmarking tool
#
# - References
#   - https://github.com/sharkdp/hyperfine
#
# ------------------------------------------------------------------------------


function dotfiles_update_hyperfine() {

    local _package_name="hyperfine"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "sharkdp/hyperfine" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# iterm: terminal emulator (macOS only)
#
# - References
#   - https://iterm2.com/
#
# ------------------------------------------------------------------------------


function dotfiles_update_iterm() {

    local _package_name="iterm"
    local _package_id="iterm2"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# jdk: java development kit
#
# - References
#   - https://iterm2.com/
#
# ------------------------------------------------------------------------------


function dotfiles_update_jdk() {

    local _package_name="jdk"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="openjdk"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="default-jdk"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "java"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# keyd: keyboard remapping (linux only)
#
# - References
#   - https://github.com/rvaiya/keyd
#
# ------------------------------------------------------------------------------


function dotfiles_update_keyd() {

    local _package_name="keyd"
    local _package_id="rvaiya/keyd"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "git-repo-make-install" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# kubectl: Kubernetes command line interface
#
# - References
#   - https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
#   - https://kubernetes.io/docs/reference/kubectl/kubectl/
#
# - Dependencies
#   - curl
#
# ------------------------------------------------------------------------------


function dotfiles_update_kubectl() {

    local _package_name="kubectl"
    local _package_id

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_dotfiles_package_update "$_package_name" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        local _latest_ver="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
        _package_id="https://dl.k8s.io/release/$_latest_ver/bin/linux/$DOTFILES_SYS_ARCHT/kubectl"

        if is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id"; then
            update_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_name"
        else
            log_dotfiles_package_update "$_package_name" "not-found"
        fi

    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        _package_id="kubectl"
        update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# nvitop: an interactive NVIDIA-GPU process viewer
#
# - References
#   - https://github.com/XuehaiPan/nvitop
#
# - Dependencies
#   - nvidia-smi
#   - pip
#
# ------------------------------------------------------------------------------


function dotfiles_update_nvitop() {

    local _package_name="nvitop"
    local _package_id="nvitop"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "nvidia-smi" || ! command_exists "pip"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "pip" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# oh my tmux: pretty & versatile tmux configuration
#
# - References
#   - https://github.com/gpakosz/.tmux
#
# - Dependencies
#   - tmux
#
# ------------------------------------------------------------------------------


function dotfiles_update_oh-my-tmux() {

    local _package_name="oh-my-tmux"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "gpakosz/.tmux" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# peco: simplistic interactive filtering tool
#
# - References
#   - https://github.com/peco/peco
#
# ------------------------------------------------------------------------------


function dotfiles_update_peco() {

    local _package_name="peco"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "peco/peco" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# powerlevel10k: zsh theme customization
#
# - References
#   - https://github.com/romkatv/powerlevel10k
#
# ------------------------------------------------------------------------------


function dotfiles_update_powerlevel10k() {

    local _package_name="powerlevel10k"
    local _package_media_name="powerlevel10k-media"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # powerlevel10k
    if is_dotfiles_package_installed "$_package_name" "zinit-plugin" "romkatv/powerlevel10k"; then
        update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # powerlevel10k-media
    if is_dotfiles_package_installed "$_package_media_name" "zinit-plugin" "romkatv/powerlevel10k-media"; then
        update_dotfiles_packages "$_package_media_name" "zinit-plugin" "$_package_media_name"
    fi
}


# ------------------------------------------------------------------------------
#
# python: Python programming language
#
# - References
#   - https://docs.python.org/3/using/cmdline.html#environment-variables
#   - https://www.nltk.org/data.html
#
# ------------------------------------------------------------------------------


function dotfiles_update_python() {

    local _package_name="python"
    local _package_id="python3"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# pyenv: python version management tool
#
# - References
#   - https://github.com/pyenv/pyenv
#
# ------------------------------------------------------------------------------


function dotfiles_update_pyenv() {

    local _package_name="pyenv"
    local _package_id

    local _package_plugin_name="pyenv-virtualenv"
    local _package_plugin_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="pyenv"
        _package_plugin_id="pyenv-virtualenv"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="pyenv/pyenv"
        _package_plugin_id="pyenv/pyenv-virtualenv"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        update_dotfiles_packages "$_package_name" "package-manager" "$_package_id $_package_plugin_id"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        update_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
        update_dotfiles_packages "$_package_plugin_name" "git-repo-pull" "$_package_plugin_id"

        # link pyenv plugin
        local _from_link="$DOTFILES_LOCAL_SHARE_DIR/$_package_plugin_name/$_package_plugin_name.git"
        local _to_link="$DOTFILES_LOCAL_SHARE_DIR/$_package_name/$_package_name.git/plugins"
        create_validated_symlink $_from_link $_to_link
    fi
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


function dotfiles_update_ripgrep() {

    local _package_name="ripgrep"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "BurntSushi/ripgrep" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# tmux: terminal multiplexer
#
# - References
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# ------------------------------------------------------------------------------


function dotfiles_update_tmux() {

    local _package_name="tmux"
    local _package_id="tmux"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# tre: a 'tree' alternative
#
# - References
#   - https://github.com/dduan/tre
#
# ------------------------------------------------------------------------------


function dotfiles_update_tre() {

    local _package_name="tre"
    local _package_id="tre-command"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# tree: recursive directory listing program
#
# - References
#   - https://github.com/Old-Man-Programmer/tree
#
# ------------------------------------------------------------------------------


function dotfiles_update_tree() {

    local _package_name="tree"
    local _package_id="tree"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# universalarchive: a convenient command-line interface for archiving files
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/universalarchive
#
# ------------------------------------------------------------------------------


function dotfiles_update_universalarchive() {

    local _package_name="universalarchive"
    local _package_id="OMZ::plugins/universalarchive/universalarchive.plugin.zsh"
    local _comp_name="_universalarchive"
    local _comp_id="OMZ::plugins/universalarchive/_universalarchive"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # universalarchive
    if is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id"; then
        update_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_name"
    else
        log_dotfiles_package_update "$_package_name" "not-found"
    fi

    # _universalarchive completion
    if is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id"; then
        update_dotfiles_packages "$_comp_name" "zinit-snippet" "$_comp_name"
    fi
}


# ------------------------------------------------------------------------------
#
# uv: Python package and project manager
#
# - References
#   - https://github.com/astral-sh/uv
#
# ------------------------------------------------------------------------------


function dotfiles_update_uv() {

    local _package_name="uv"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "astral-sh/uv" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# vim: a text editors
#
# - References
#   - https://www.vim.org/docs.php
#
# ------------------------------------------------------------------------------


function dotfiles_update_vim() {

    local _package_name="vim"
    local _package_id="vim"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# volta: JavaScript tool manager
#
# - References
#   - https://volta.sh/
#
# - Dependency
#   - curl
#
# - Environment Variables
#   - VOLTA_HOME
#
# ------------------------------------------------------------------------------


function dotfiles_update_volta() {

    local _package_name="volta"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_update "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    # upgrade
    log_dotfiles_package_update "$_package_name" "upgrade"

    if curl https://get.volta.sh | bash -s -- --skip-setup; then
        log_dotfiles_package_update "$_package_name" "success"
    else
        log_dotfiles_package_update "$_package_name" "fail"
        return $RC_ERROR
    fi
}


# ------------------------------------------------------------------------------
#
# vscode: code editor
#
# - References
#   - https://github.com/microsoft/vscode
#
# - Dependency
#   - wget (Linux only)
#
# ------------------------------------------------------------------------------


function dotfiles_update_vscode() {

    local _package_name="vscode"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # upgrade
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        local _package_id="visual-studio-code"

        if ! { is_dotfiles_package_installed "$_package_name" "brew-cask" "$_package_id" }; then
            log_dotfiles_package_update "$_package_name" "not-found"
            return $RC_NOT_FOUND
        fi

        update_dotfiles_packages "$_package_name" "brew-cask" "$_package_id"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        local _package_id="code"

        if ! command_exists "$_package_id"; then
            log_dotfiles_package_update "$_package_name" "not-found"
            return $RC_NOT_FOUND
        fi

        update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
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


function dotfiles_update_watch() {

    local _package_name="watch"
    local _package_id="watch"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# zinit: zsh plugin manager
#
# - Reference
#   - https://github.com/zdharma-continuum/zinit
#
# ------------------------------------------------------------------------------


function dotfiles_update_zinit() {

    local _package_name="zinit"
    local _package_id="zdharma-continuum/zinit"

    # sanity check
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# zoxide: a smarter cd command
#
# - References
#   - https://github.com/ajeetdsouza/zoxide
#
# ------------------------------------------------------------------------------


function dotfiles_update_zoxide() {

    local _package_name="zoxide"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "ajeetdsouza/zoxide" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# zsh-autosuggestions: command line auto-completion
#
# - References
#   - https://github.com/zsh-users/zsh-autosuggestions
#
# ------------------------------------------------------------------------------


function dotfiles_update_zsh-autosuggestions() {

    local _package_name="zsh-autosuggestions"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "zsh-users/zsh-autosuggestions" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}


# ------------------------------------------------------------------------------
#
# zsh-completions:
#
# - References
#   - https://github.com/zsh-users/zsh-completions
#
# ------------------------------------------------------------------------------


function dotfiles_update_zsh-completions() {

    local _package_name="zsh-completions"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_update "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "zsh-users/zsh-completions" }; then
        log_dotfiles_package_update "$_package_name" "not-found"
        return $RC_NOT_FOUND
    fi

    update_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_name"
}
