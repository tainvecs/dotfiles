#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Utility Functions for Package Installation
#
#
# Version: 0.0.5
# Last Modified: 2025-07-03
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


function dotfiles_install_7z() {

    local _package_name="7z"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="p7zip"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="p7zip-full"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "unzip"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# alt-tab: window switching (macOS only)
#
# - Reference
#   - https://alt-tab-macos.netlify.app/
#
# ------------------------------------------------------------------------------


function dotfiles_install_alt-tab() {

    local _package_name="alt-tab"
    local _package_id="alt-tab"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# autoenv: automatically source environment variables
#
# - References
#   - https://github.com/hyperupcall/autoenv
#
# ------------------------------------------------------------------------------


function dotfiles_install_autoenv() {

    local _package_name="autoenv"
    local _package_id="hyperupcall/autoenv"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        install_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "git-repo-pull" "$_package_id"
    fi
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


function dotfiles_install_aws() {

    local _package_name="aws"
    local _package_id

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_dotfiles_package_installation "$_package_name" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl" || ! command_exists "unzip"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or upgrade
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        _package_id="awscli"

        if ! command_exists "$_package_name"; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # tmp directory for installer
        local _tmp_dir=$(mktemp -d)
        local _bin_dir="$DOTFILES_LOCAL_BIN_DIR"
        local _install_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"

        # prepare installer
        local _bin_archt
        if [[ $DOTFILES_SYS_ARCHT == "arm64" ]]; then
            _bin_archt="aarch64"
        elif [[ $DOTFILES_SYS_ARCHT == "amd64" ]]; then
            _bin_archt="x86_64"
        fi

        {
            curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-$_bin_archt.zip" \
                 -o "$_tmp_dir/awscliv2.zip" && \
            unzip "$_tmp_dir/awscliv2.zip" -d "$_tmp_dir" && \
            rm -f "$_tmp_dir/awscliv2.zip"

        } || {
            log_dotfiles_package_installation "$_package_name" "fail"
            rm -rf "$_tmp_dir/aws" "$_tmp_dir/awscliv2.zip"
            return $RC_ERROR
        }

        # install or upgrade
        if ! command_exists "$_package_name"; then
            log_dotfiles_package_installation "$_package_name" "install"
            sudo "$_home_dir/aws/install" --bin-dir "$_bin_dir" --install-dir "$_install_dir"
        else
            log_dotfiles_package_installation "$_package_name" "upgrade"
            sudo "$_home_dir/aws/install" --bin-dir "$_bin_dir" --install-dir "$_install_dir" --update
        fi

        if [[ $? -eq $RC_SUCCESS ]]; then
            log_dotfiles_package_installation "$_package_name" "success"
            rm -rf "$_tmp_dir/aws"
        else
            log_dotfiles_package_installation "$_package_name" "fail"
            rm -rf "$_tmp_dir/aws" "$_install_dir"
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


function dotfiles_install_bat() {

    local _package_name="bat"
    local _package_id="sharkdp/bat"

    local _package_plugin_name="bat-extras"
    local _package_plugin_id="eth-p/bat-extras"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # bat
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
              $( [[ $DOTFILES_SYS_NAME == "linux" ]] && echo "bpick\"bat*$(uname -m)*linux-gnu.tar.gz\"" ) \
              mv"bat* -> bat" \
              atclone'ln -sf $(realpath ./bat/bat) $DOTFILES_LOCAL_BIN_DIR/bat;                   # binary
                      ln -sf $(realpath ./bat/bat.1) $DOTFILES_LOCAL_MAN_DIR/man1;                # manual
                      ln -sf $(realpath ./bat/autocomplete/bat.zsh) $DOTFILES_ZSH_COMP_DIR/_bat;  # completion ' \
              atpull'%atclone'

        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi

    # bat-extras
    if ! { is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id" }; then

        zinit ice lucid from"gh-r" as"null" id-as"$_package_plugin_name" \
              atclone'ln -sf $(realpath ./bin/*(*)) $DOTFILES_LOCAL_BIN_DIR/;      # binary
                      ln -sf $(realpath ./man/*(.)) $DOTFILES_LOCAL_MAN_DIR/man1;  # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id"

    else
        install_dotfiles_packages --upgrade "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
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


function dotfiles_install_delta() {

    local _package_name="delta"
    local _package_id="dandavison/delta"

    local _package_res_name="delta-res"
    local _package_res_id="dandavison/delta"

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
              mv"delta* -> delta" \
              atclone'ln -sf $(realpath ./delta/delta) $DOTFILES_LOCAL_BIN_DIR/$_package_name' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi

    # completion and theme config
    if ! { is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id" }; then

        local _sed_command
        if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            _sed_command='sed -i "" -e "s/syntax-theme = Vibrant Sunburst/# syntax-theme = Vibrant Sunburst/g"'
        elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then \
            _sed_command='sed -i "s/syntax-theme = Vibrant Sunburst/# syntax-theme = Vibrant Sunburst/g"'
        fi

        zinit ice lucid as"null" id-as"$_package_res_name" \
              atclone'ln -sf $(realpath ./etc/completion/completion.zsh) $DOTFILES_ZSH_COMP_DIR/_delta;      # completion
                      delta --help > delta.1;                                                                # manual
                      ln -sf $(realpath delta.1) $DOTFILES_LOCAL_MAN_DIR/man1/delta.1;
                      cp ./themes.gitconfig ./themes.prune.gitconfig                                         # theme config
                      '"$_sed_command"' ./themes.prune.gitconfig;
                      mkdir -p $DOTFILES_LOCAL_SHARE_DIR/delta;
                      ln -sf $(realpath ./themes.prune.gitconfig) $DOTFILES_LOCAL_SHARE_DIR/delta/themes.gitconfig;' \

              atpull'%atclone'
        install_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_id"

    else
        install_dotfiles_packages --upgrade "$_package_res_name" "zinit-plugin" "$_package_res_name"
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


function dotfiles_install_docker() {

    local _package_name="docker"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then

        if [[ $DOTFILES_SYS_NAME == "linux" ]]; then

            # add docker's official gpg key:
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            # add the repository to apt sources:
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc]
                 https://download.docker.com/linux/ubuntu
                 $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
                 stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update

            # install
            install_dotfiles_packages "$_package_name" "package-manager" \
                                     "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

        elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            install_dotfiles_packages "$_package_name" "package-manager" "docker docker-compose"
        fi

    else
        if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" \
                                     "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
        elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" "docker docker-compose"
        fi
    fi

    # docker completion
    local _docker_cmp_path="$DOTFILES_ZSH_COMP_DIR/_docker"
    if [[ ! -f $_docker_cmp_path ]]; then
        docker completion zsh > $_docker_cmp_path || log_message "Failed to generate docker completion $_docker_cmp_path" "error"
    fi

    # docker-compose completion
    local _docker_comp_cmp_name="_docker-compose"
    local _docker_comp_cmp_id="https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/zsh/_docker-compose"

    if ! { is_dotfiles_package_installed "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_id" }; then
        zinit ice lucid as"completion" id-as"$_docker_comp_cmp_name"
        install_dotfiles_packages "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_id"
    else
        install_dotfiles_packages --upgrade "$_docker_comp_cmp_name" "zinit-snippet" "$_docker_comp_cmp_name"
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


function dotfiles_install_docker-credential-helpers() {

    local _package_name="docker-credential-helpers"
    local _package_id="docker/docker-credential-helpers"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

            zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
                  bpick"docker-credential-osxkeychain-*" \
                  mv"docker-credential-osxkeychain-* -> docker-credential-osxkeychain" \
                  atclone'ln -sf $(realpath ./docker-credential-osxkeychain) $DOTFILES_LOCAL_BIN_DIR/docker-credential-osxkeychain' \
                  atpull'%atclone'

        elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

            zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
                  bpick"docker-credential-secretservice-*" \
                  mv"docker-credential-secretservice-* -> docker-credential-secretservice" \
                  atclone'ln -sf $(realpath ./docker-credential-secretservice) $DOTFILES_LOCAL_BIN_DIR/docker-credential-secretservice' \
                  atpull'%atclone'
        fi
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# duf: a better 'df' alternative (Disk Usage/Free Utility)
#
# - References
#   - https://github.com/muesli/duf
#
# ------------------------------------------------------------------------------


function dotfiles_install_duf() {

    local _package_name="duf"
    local _package_id="muesli/duf"

    local _package_res_name="duf-res"
    local _package_res_id="muesli/duf"

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
              atclone'ln -sf $(realpath ./duf) $DOTFILES_LOCAL_BIN_DIR/$_package_name' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi

    # manual
    if ! { is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id" }; then

        zinit ice lucid as"null" id-as"$_package_res_name" \
              atclone'ln -sf $(realpath duf.1) $DOTFILES_LOCAL_MAN_DIR/man1/duf.1' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_id"

    else
        install_dotfiles_packages --upgrade "$_package_res_name" "zinit-plugin" "$_package_res_name"
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


function dotfiles_install_dust() {

    local _package_name="dust"
    local _package_id="bootandy/dust"

    local _package_res_name="dust-res"
    local _package_res_id="bootandy/dust"

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" as"null" id-as"$_package_name" \
              mv"dust* -> dust" \
              atclone'ln -sf $(realpath ./dust/dust) $DOTFILES_LOCAL_BIN_DIR/$_package_name' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi

    # manual and completion
    if ! { is_dotfiles_package_installed "$_package_res_name" "zinit-plugin" "$_package_res_id" }; then

        zinit ice lucid as"null" id-as"$_package_res_name" \
              atclone'ln -sf $(realpath ./completions/_dust) $DOTFILES_ZSH_COMP_DIR/_dust;       # completion
                      ln -sf $(realpath ./man-page/dust.1) $DOTFILES_LOCAL_MAN_DIR/man1/dust.1;  # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_res_name" "zinit-plugin" "$_package_res_id"

    else
        install_dotfiles_packages --upgrade "$_package_res_name" "zinit-plugin" "$_package_res_name"
    fi
}


# ------------------------------------------------------------------------------
#
# emacs: a text editors
#
# ------------------------------------------------------------------------------


function dotfiles_install_emacs() {

    local _package_name="emacs"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        brew tap d12frosted/emacs-plus
        _package_id="emacs-plus"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="emacs"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# extract: supporting a wide variety of archive filetypes
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
#
# ------------------------------------------------------------------------------


function dotfiles_install_extract() {

    local _package_name="extract"
    local _package_id="OMZ::plugins/extract/extract.plugin.zsh"
    local _comp_name="_extract"
    local _comp_id="OMZ::plugins/extract/_extract"

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name"
        install_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-snippet" "$_package_name"
    fi

    # completion
    if ! { is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id" }; then
        zinit ice lucid as"completion" id-as"$_comp_name"
        install_dotfiles_packages "$_comp_name" "zinit-snippet" "$_comp_id"
    else
        install_dotfiles_packages --upgrade "$_comp_name" "zinit-snippet" "$_comp_name"
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


function dotfiles_install_eza() {

    local _package_name="eza"
    local _package_id="eza"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then

        # prerequisite
        if [[ $DOTFILES_SYS_NAME == "linux" ]]; then

            # check dependency
            if ! command_exists "gpg"; then
                log_dotfiles_package_installation "$_package_name" "dependency-missing"
                return $RC_DEPENDENCY_MISSING
            fi

            # set up apt keyring for eza
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
            sudo apt update
        fi

        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# fast-syntax-highlighting: feature-rich syntax highlighting for Zsh
#
# - References
#   - https://github.com/zdharma-continuum/fast-syntax-highlighting
#
# ------------------------------------------------------------------------------


function dotfiles_install_fast-syntax-highlighting() {

    local _package_name="fast-syntax-highlighting"
    local _package_id="zdharma-continuum/fast-syntax-highlighting"

    # fast-syntax-highlighting
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name" blockf \
              atclone'ln -sf $(realpath ./_fast-theme) $DOTFILES_ZSH_COMP_DIR/_fast-theme' \
              atpull'%atclone'

        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# fd: a fast and user-friendly alternative to 'find'
#
# - References
#   - https://github.com/sharkdp/fd
#
# ------------------------------------------------------------------------------


function dotfiles_install_fd() {

    local _package_name="fd"
    local _package_id="sharkdp/fd"

    # binary, completions and manual
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" id-as"$_package_name" as"null" \
              mv"fd* -> fd" \
              atclone'ln -sf $(realpath ./fd/fd) $DOTFILES_LOCAL_BIN_DIR/$_package_name;    # binary
                      ln -sf $(realpath ./fd/autocomplete/_fd) $DOTFILES_ZSH_COMP_DIR/_fd;  # completion
                      ln -sf $(realpath ./fd/fd.1) $DOTFILES_LOCAL_MAN_DIR/man1/fd.1;       # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
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


function dotfiles_install_forgit() {

    local _package_name="forgit"
    local _package_id="wfxr/forgit"

    # sanity check
    if ! command_exists "fzf"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
    fi

    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name"
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
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


function dotfiles_install_fzf() {

    local _package_name="fzf"
    local _package_id="fzf"

    local _package_plugin_name="fzf-tab"
    local _package_plugin_id="Aloxaf/fzf-tab"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # fzf
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi

    # fzf-tab
    if ! { is_dotfiles_package_installed "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id" }; then
        zinit ice lucid id-as"$_package_plugin_name" blockf
        install_dotfiles_packages "$_package_plugin_name" "zinit-plugin" "$_package_plugin_id"
    else
        install_dotfiles_packages --upgrade "$_package_plugin_name" "zinit-plugin" "$_package_plugin_name"
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


function dotfiles_install_gcp() {

    local _package_name="gcp"
    local _package_id="gcp"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # skip if installed
    if command_exists "gcloud"; then
        log_dotfiles_package_installation "$_package_name" "skip"
        return $RC_SUCCESS
    fi

    # install
    log_dotfiles_package_installation "$_package_name" "install"

    local _home_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"
    ensure_directory "$_home_dir"

    curl -fL https://sdk.cloud.google.com > "$_home_dir/install.sh"
    if bash "$_home_dir/install.sh" --disable-prompts --install-dir=$_home_dir; then
        log_dotfiles_package_installation "$_package_name" "success"
        rm -f "$_home_dir/install.sh"
    else
        log_dotfiles_package_installation "$_package_name" "fail"
        rm -f "$_home_dir/install.sh"
        return $RC_ERROR
    fi

    # completion
    _=$(link_dotfiles_share_completion_to_local "$_package_name/google-cloud-sdk" "completion.zsh.inc" "gcp.zsh.inc")

    # path
    local _bin_dir="$_home_dir/google-cloud-sdk/bin"
    append_dir_to_path "PATH" "$_bin_dir"
}


# ------------------------------------------------------------------------------
#
# go: Go programming language
#
# ------------------------------------------------------------------------------


function dotfiles_install_go() {

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
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# homebrew: package manager (macOS only)
#
# - Reference
#   - https://brew.sh/
#
# ------------------------------------------------------------------------------


function dotfiles_install_homebrew() {

    local _package_name="homebrew"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "brew"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        brew update
    fi
}


# ------------------------------------------------------------------------------
#
# htop: an interactive process viewer
#
# - References
#   - https://github.com/htop-dev/htop
#
# ------------------------------------------------------------------------------


function dotfiles_install_htop() {

    local _package_name="htop"
    local _package_id="htop"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# hyperfine: a command-line benchmarking tool
#
# - References
#   - https://github.com/sharkdp/hyperfine
#
# ------------------------------------------------------------------------------


function dotfiles_install_hyperfine() {

    local _package_name="hyperfine"
    local _package_id="sharkdp/hyperfine"

    # binary, completions and manual
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" id-as"$_package_name" as"null" \
              mv"hyperfine* -> hyperfine" \
              atclone'ln -sf $(realpath ./hyperfine/hyperfine) $DOTFILES_LOCAL_BIN_DIR/$_package_name;           # binary
                      ln -sf $(realpath ./hyperfine/autocomplete/_hyperfine) $DOTFILES_ZSH_COMP_DIR/_hyperfine;  # completion
                      ln -sf $(realpath ./hyperfine/hyperfine.1) $DOTFILES_LOCAL_MAN_DIR/man1/hyperfine.1;       # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# iterm: terminal emulator (macOS only)
#
# - References
#   - https://iterm2.com/
#
# ------------------------------------------------------------------------------


function dotfiles_install_iterm() {

    local _package_name="iterm"
    local _package_id="iterm2"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
}


# ------------------------------------------------------------------------------
#
# jdk: java development kit
#
# - References
#   - https://iterm2.com/
#
# ------------------------------------------------------------------------------


function dotfiles_install_jdk() {

    local _package_name="jdk"
    local _package_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="openjdk"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="default-jdk"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "java"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# keyd: keyboard remapping (linux only)
#
# - References
#   - https://github.com/rvaiya/keyd
#
# ------------------------------------------------------------------------------


function dotfiles_install_keyd() {

    local _package_name="keyd"
    local _package_id="rvaiya/keyd"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "git-repo-make-install" "$_package_id"
        if [[ $? != $RC_SUCCESS ]]; then
            sudo systemctl enable "$_package_name" && sudo systemctl start "$_package_name"
        fi

    else
        install_dotfiles_packages --upgrade "$_package_name" "git-repo-make-install" "$_package_id"
    fi
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


function dotfiles_install_kubectl() {

    local _package_name="kubectl"
    local _package_id

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_dotfiles_package_installation "$_package_name" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or upgrade
    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        local _latest_ver="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
        _package_id="https://dl.k8s.io/release/$_latest_ver/bin/linux/$DOTFILES_SYS_ARCHT/kubectl"

        if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id" }; then
            zinit ice lucid id-as"$_package_name"
            install_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "zinit-snippet" "$_package_name"
        fi

    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        _package_id="kubectl"

        if ! command_exists "$_package_name"; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
        fi
    fi

    # completion
    local _cmp_path="$DOTFILES_ZSH_COMP_DIR/_$_package_name"
    if [[ ! -f $_cmp_path ]]; then
        kubectl completion zsh > $_cmp_path || log_message "Failed to generate kubectl completion $_cmp_path" "error"
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


function dotfiles_install_nvitop() {

    local _package_name="nvitop"
    local _package_id="nvitop"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "nvidia-smi" || ! command_exists "pip"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "pip" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "pip" "$_package_id"
    fi
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


function dotfiles_install_oh-my-tmux() {

    local _package_name="oh-my-tmux"
    local _package_id="gpakosz/.tmux"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    local _home_dir="$DOTFILES_LOCAL_CONFIG_DIR/tmux"
    ensure_directory "$_home_dir"

    # oh-my-tmux tmux config
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid as"null" id-as"$_package_name" \
              atclone'ln -sf $(realpath ./.tmux.conf) $_home_dir/tmux.$_package_name.conf' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# peco: simplistic interactive filtering tool
#
# - References
#   - https://github.com/peco/peco
#
# ------------------------------------------------------------------------------


function dotfiles_install_peco() {

    local _package_name="peco"
    local _package_id="peco"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # peco
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# powerlevel10k: zsh theme customization
#
# - References
#   - https://github.com/romkatv/powerlevel10k
#
# ------------------------------------------------------------------------------


function dotfiles_install_powerlevel10k() {

    local _package_name="powerlevel10k"
    local _package_id="romkatv/powerlevel10k"

    local _package_media_name="powerlevel10k-media"
    local _package_media_id="romkatv/powerlevel10k-media"

    # p10k
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name" depth"1"
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi

    # p10k-media
    if ! { is_dotfiles_package_installed "$_package_media_name" "zinit-plugin" "$_package_media_id" }; then

        zinit ice lucid as"null" id-as"$_package_media_name" \
              atclone'rsync -av --copy-links *.ttf $DOTFILES_FONT_DIR/' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_media_name" "zinit-plugin" "$_package_media_id"

        # update font cache
        if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
            fc-cache -fv
        fi
    else
        install_dotfiles_packages --upgrade "$_package_media_name" "zinit-plugin" "$_package_media_name"
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


function dotfiles_install_python() {

    local _package_name="python"
    local _package_id="python3"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install Python and pip
    if ! command_exists "$_package_name"; then
        if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id python3-pip python3-dev build-essential"
        elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
        fi
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# pyenv: python version management tool
#
# - References
#   - https://github.com/pyenv/pyenv
#
# ------------------------------------------------------------------------------


function dotfiles_install_pyenv() {

    local _package_name="pyenv"
    local _package_id

    local _package_plugin_name="pyenv-virtualenv"
    local _package_plugin_id

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _package_id="pyenv"
        _package_plugin_id="pyenv-virtualenv"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _package_id="pyenv/pyenv"
        _package_plugin_id="pyenv-virtualenv/pyenv-virtualenv"
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if { ! command_exists "python" && ! command_exists "python3" }; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or update
    if ! { is_dotfiles_package_installed "$_package_name" "package-manager" "$_package_id" }; then
        if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            local _pkg_str="openssl readline sqlite3 xz zlib $_package_id $_package_plugin_id"
            install_dotfiles_packages "$_package_name" "package-manager" "$_pkg_str"
        elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
            local _pkg_str="make libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
                            libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev \
                            libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
            install_dotfiles_packages "$_package_name" "package-manager" "$_pkg_str"
            install_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
            install_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_plugin_id"
        fi
    else
        if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id $_package_plugin_id"
        elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
            install_dotfiles_packages --upgrade "$_package_name" "git-repo-pull" "$_package_id"
            install_dotfiles_packages --upgrade "$_package_name" "git-repo-pull" "$_package_plugin_id"
        fi
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


function dotfiles_install_ripgrep() {

    local _package_name="ripgrep"
    local _package_id="BurntSushi/ripgrep"

    # binary, completions and manual
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" id-as"$_package_name" as"null" \
              mv"ripgrep* -> ripgrep" \
              atclone'ln -sf $(realpath ./ripgrep/rg) $DOTFILES_LOCAL_BIN_DIR/rg;               # binary
                      ln -sf $(realpath ./ripgrep/complete/_rg) $DOTFILES_ZSH_COMP_DIR/_rg;     # completion
                      ln -sf $(realpath ./ripgrep/doc/rg.1) $DOTFILES_LOCAL_MAN_DIR/man1/rg.1;  # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# tmux: terminal multiplexer
#
# - References
#   - https://man7.org/linux/man-pages/man1/tmux.1.html
#
# ------------------------------------------------------------------------------


function dotfiles_install_tmux() {

    local _package_name="tmux"
    local _package_id="tmux"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# tre: a 'tree' alternative
#
# - References
#   - https://github.com/dduan/tre
#
# ------------------------------------------------------------------------------


function dotfiles_install_tre() {

    local _package_name="tre"
    local _package_id="tre-command"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# tree: recursive directory listing program
#
# - References
#   - https://github.com/Old-Man-Programmer/tree
#
# ------------------------------------------------------------------------------


function dotfiles_install_tree() {

    local _package_name="tree"
    local _package_id="tree"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# universalarchive: a convenient command-line interface for archiving files
#
# - References
#   - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/universalarchive
#
# ------------------------------------------------------------------------------


function dotfiles_install_universalarchive() {

    local _package_name="universalarchive"
    local _package_id="OMZ::plugins/universalarchive/universalarchive.plugin.zsh"
    local _comp_name="_universalarchive"
    local _comp_id="OMZ::plugins/universalarchive/_universalarchive"

    # binary
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-snippet" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name"
        install_dotfiles_packages "$_package_name" "zinit-snippet" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-snippet" "$_package_name"
    fi

    # completion
    if ! { is_dotfiles_package_installed "$_comp_name" "zinit-snippet" "$_comp_id" }; then
        zinit ice lucid as"completion" id-as"$_comp_name"
        install_dotfiles_packages "$_comp_name" "zinit-snippet" "$_comp_id"
    else
        install_dotfiles_packages --upgrade "$_comp_name" "zinit-snippet" "$_comp_name"
    fi
}


# ------------------------------------------------------------------------------
#
# vim: a text editors
#
# - References
#   - https://www.vim.org/docs.php
#
# ------------------------------------------------------------------------------


function dotfiles_install_vim() {

    local _package_name="vim"
    local _package_id="vim"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
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


function dotfiles_install_volta() {

    local _package_name="volta"
    local _package_id="volta"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_dotfiles_package_installation "$_package_name" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # env
    local _home_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"
    ensure_directory "$_home_dir"
    export VOLTA_HOME=$_home_dir

    # install or upgrade
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_installation "$_package_name" "install"
    else
        log_dotfiles_package_installation "$_package_name" "upgrade"
    fi

    if curl https://get.volta.sh | bash -s -- --skip-setup; then
        log_dotfiles_package_installation "$_package_name" "success"
    else
        log_dotfiles_package_installation "$_package_name" "fail"
        return $RC_ERROR
    fi

    # path
    append_dir_to_path "PATH" "$_home_dir/bin"

    # completion
    local _cmp_path="$DOTFILES_ZSH_COMP_DIR/_$_package_name"
    if [[ ! -f $_cmp_path ]]; then
        volta completions --output $_cmp_path zsh || log_message "Failed to generate $_package_name completion" "error"
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


function dotfiles_install_vscode() {

    local _package_name="vscode"

    # sanity check
    if ! is_supported_system_name; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        local _package_id="visual-studio-code"

        if ! command_exists "$_package_name" && \
           ! { is_dotfiles_package_installed "$_package_name" "brew-cask" "$_package_id" }; then
            install_dotfiles_packages "$_package_name" "brew-cask" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "brew-cask" "$_package_id"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        local _package_id="code"

        if ! command_exists "$_package_id"; then
            log_dotfiles_package_installation "$_package_name" "dependency-missing"
            return $RC_DEPENDENCY_MISSING
        fi

        if ! command_exists "$_package_id" && \
           ! { is_dotfiles_package_installed "$_package_name" "brew-cask" "$_package_id" }; then

            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
                 https://packages.microsoft.com/repos/code stable main" | \
                sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg
            sudo apt-get update

            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
        fi
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


function dotfiles_install_watch() {

    local _package_name="watch"
    local _package_id="watch"

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_dotfiles_package_installation "$_package_name" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or upgrade
    if ! command_exists "$_package_name"; then
        install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
    fi
}


# ------------------------------------------------------------------------------
#
# zinit: zsh plugin manager
#
# - Reference
#   - https://github.com/zdharma-continuum/zinit
#
# ------------------------------------------------------------------------------


function dotfiles_install_zinit() {

    local _package_name="zinit"
    local _package_id="zdharma-continuum/zinit"

    # install or upgrade
    if ! { is_dotfiles_package_installed "$_package_name" "git-repo-pull" "$_package_id" }; then
        install_dotfiles_packages "$_package_name" "git-repo-pull" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "git-repo-pull" "$_package_id"
    fi

    # completion
    _=$(link_dotfiles_share_completion_to_local "$_package_name/zinit.git" "_zinit" "_$_package_name")
}


# ------------------------------------------------------------------------------
#
# zoxide: a smarter cd command
#
# - References
#   - https://github.com/ajeetdsouza/zoxide
#
# ------------------------------------------------------------------------------


function dotfiles_install_zoxide() {

    local _package_name="zoxide"
    local _package_id="ajeetdsouza/zoxide"

    # binary, completions and manual
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" id-as"$_package_name" as"null" \
              mv"zoxide* -> zoxide" \
              atclone'ln -sf $(realpath ./zoxide) $DOTFILES_LOCAL_BIN_DIR/zoxide;               # binary
                      ln -sf $(realpath ./completions/_zoxide) $DOTFILES_ZSH_COMP_DIR/_zoxide;  # completion
                      ln -sf $(realpath ./man/man1/*(.)) $DOTFILES_LOCAL_MAN_DIR/man1;          # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# zsh-autosuggestions: command line auto-completion
#
# - References
#   - https://github.com/zsh-users/zsh-autosuggestions
#
# ------------------------------------------------------------------------------


function dotfiles_install_zsh-autosuggestions() {

    local _package_name="zsh-autosuggestions"
    local _package_id="zsh-users/zsh-autosuggestions"

    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name" \
              atload"_zsh_autosuggest_start"
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


# ------------------------------------------------------------------------------
#
# zsh-completions:
#
# - References
#   - https://github.com/zsh-users/zsh-completions
#
# ------------------------------------------------------------------------------


function dotfiles_install_zsh-completions() {

    local _package_name="zsh-completions"
    local _package_id="zsh-users/zsh-completions"

    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then
        zinit ice lucid id-as"$_package_name" blockf
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"
    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}
