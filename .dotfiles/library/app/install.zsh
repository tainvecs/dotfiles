#!/bin/zsh


#------------------------------------------------------------------------------
#
# Utility Functions for App Installation
#
#
# Version: 0.0.3
# Last Modified: 2025-05-21
#
# - Dependency
#   - Environment Variable File
#     - .dotfiles/env/misc.env
#   - Environment Variable
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
# ------------------------------------------------------------------------------


# Installs 7z (p7zip) for file compression
# Dependency: unzip
function _dotfiles_install_7z() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "7z" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "unzip"; then
        log_app_installation "7z" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or update
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "7z"; then
            install_apps "p7zip"
        else
            install_apps --update "p7zip"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        if ! command_exists "7z"; then
            install_apps "p7zip-full"
        else
            install_apps --update "p7zip-full"
        fi
    fi
}


# Installs Alt-Tab (macOS only) for window switching
function _dotfiles_install_alt-tab() {

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_app_installation "alt-tab" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! is_app_installed "alt-tab"; then
        install_apps "alt-tab"
    else
        install_apps --update "alt-tab"
    fi
}


# Installs Autoenv by cloning its Git repository
function _dotfiles_install_autoenv() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "autoenv" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    local _autoenv_home="$DOTFILES_XDG_CONFIG_DIR/autoenv"
    [[ -d $_autoenv_home ]] || mkdir -p $_autoenv_home

    local _autoenv_git_dir="$_autoenv_home/autoenv.git"
    if [[ ! -d $_autoenv_git_dir ]]; then
        log_app_installation "autoenv" "install"
        git clone https://github.com/hyperupcall/autoenv.git $_autoenv_git_dir
    else
        log_app_installation "autoenv" "update"
        git -C $_autoenv_git_dir pull
    fi

    if [[ $? -eq 0 ]]; then
        log_app_installation "autoenv" "success"
    else
        log_app_installation "autoenv" "fail"
        return $RC_ERROR
    fi
}


# Installs AWS CLI, with manual download on Linux
# Dependency: curl, unzip
function _dotfiles_install_aws() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "aws" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_app_installation "aws" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl" || ! command_exists "unzip"; then
        log_app_installation "aws" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or update
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "aws"; then
            install_apps "awscli"
        else
            install_apps --update "awscli"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # home
        local _aws_home="$DOTFILES_XDG_CONFIG_DIR/aws"
        [[ -d $_aws_home ]] || mkdir -p $_aws_home

        # download installer
        [[ -d "$_aws_home/aws" ]] && rm -r "$_aws_home/aws"
        [[ -f "$_aws_home/awscliv2.zip" ]] && rm -f "$_aws_home/awscliv2.zip"

        if [[ $DOTFILES_SYS_ARCHT == "arm64" ]]; then
            curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "$_aws_home/awscliv2.zip" || {
                log_app_installation "aws" "fail"
                rm -f "$_aws_home/awscliv2.zip"
                return $RC_ERROR
            }
        elif [[ $DOTFILES_SYS_ARCHT == "amd64" ]]; then
            curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$_aws_home/awscliv2.zip" || {
                log_app_installation "aws" "fail"
                rm -f "$_aws_home/awscliv2.zip"
                return $RC_ERROR
            }
        fi
        unzip "$_aws_home/awscliv2.zip" -d $_aws_home && rm -f "$_aws_home/awscliv2.zip"

        # install or update
        if ! command_exists "aws"; then
            log_app_installation "aws" "install"
            sudo "$_aws_home/aws/install"
        else
            log_app_installation "aws" "update"
            sudo "$_aws_home/aws/install" --update
        fi

        if [[ $? -eq 0 ]]; then
            log_app_installation "aws" "success"
        else
            log_app_installation "aws" "fail"
            return $RC_ERROR
        fi
    fi
}


# Installs Clojure programming language tools
function _dotfiles_install_clojure() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "clojure" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    local _clojure_app_name
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _clojure_app_name="clojure/tools/clojure"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _clojure_app_name="clojure"
    fi

    if ! command_exists "clojure"; then
        install_apps "$_clojure_app_name"
    else
        install_apps --update "$_clojure_app_name"
    fi
}


# Installs Docker, with manual setup on macOS and repository on Linux
# Dependency: curl
function _dotfiles_install_docker() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "docker" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_app_installation "autoenv" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "docker" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        # skip
        if command_exists "docker"; then
            log_app_installation "docker" "skip"
            return $RC_SUCCESS
        fi

        # install
        log_app_installation "docker" "install"
        local _install_status

        # ----- docker
        curl -O "https://desktop.docker.com/mac/main/$DOTFILES_SYS_ARCHT/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-$DOTFILES_SYS_ARCHT"

        sudo hdiutil attach Docker.dmg
        sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
        _install_status=$?
        sudo hdiutil detach /Volumes/Docker
        rm -f Docker.dmg

        if [[ $_install_status -ne $RC_SUCCESS ]]; then
            log_app_installation "docker" "fail"
            return $RC_ERROR
        fi

        # ----- docker-buildx
        brew install docker-buildx || {
            log_app_installation "docker" "fail"
            _install_status=$RC_ERROR
            return $RC_ERROR
        }

        [[ $_install_status -eq $RC_SUCCESS ]] && log_app_installation "docker" "success"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        if ! command_exists "docker"; then
            install_apps "docker-ce docker-ce-cli containerd.io"
        else
            install_apps --update "docker-ce docker-ce-cli containerd.io"
        fi
    fi
}


# Installs Elasticsearch, with tarball on macOS and repository on Linux
# Dependency: curl
function _dotfiles_install_elasticsearch() {

    # skip
    if is_app_installed "elasticsearch"; then
        log_app_installation "elasticsearch" "skip"
        return $RC_SUCCESS
    fi

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "elasticsearch" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_app_installation "elasticsearch" "sys-archt-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "elasticsearch" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # home
    local _es_home="$DOTFILES_XDG_CONFIG_DIR/es"
    [[ -d $_es_home ]] || mkdir -p $_es_home

    # get version
    local _es_sys_name
    local _es_sys_archt
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _es_sys_name="darwin"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _es_sys_name="linux"
    fi
    if [[ $DOTFILES_SYS_ARCHT == "amd64" ]]; then
        _es_sys_archt="x86_64"
    elif [[ $DOTFILES_SYS_ARCHT == "arm64" ]]; then
        _es_sys_archt="aarch64"
    fi
    local _es_version=$(get_github_release_latest_version "elastic" "elasticsearch")
    local _es_zip_file_name="elasticsearch-$_es_version-$_es_sys_name-$_es_sys_archt.tar.gz"

    # clean up, download, verify, extract and install
    [[ -d "$_es_home/es" ]] && rm -r "$_es_home/es"

    curl -O "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name"
    curl "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name.sha512" | shasum -a 512 -c -
    mkdir "$_es_home/es" && tar -xzf "$_es_zip_file_name" -C "$_es_home/es" --strip-components 1
    rm -f "$_es_zip_file_name"
}


# Installs Emacs text editor
function _dotfiles_install_emacs() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "emacs" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    local _emacs_app_name
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        brew tap d12frosted/emacs-plus
        _emacs_app_name="emacs-plus"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _emacs_app_name="emacs"
    fi

    if ! command_exists "emacs"; then
        install_apps $_emacs_app_name
    else
        install_apps --update $_emacs_app_name
    fi
}


# Installs Google Cloud SDK
# Dependency: curl
function _dotfiles_install_gcp() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "gcp" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "gcp" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # skip if installed
    if command_exists "gcloud"; then
        log_app_installation "gcp" "skip"
        return $RC_SUCCESS
    fi

    # install
    log_app_installation "gcp" "install"

    local _gcp_home="$DOTFILES_XDG_CONFIG_DIR/gcp"
    [[ -d $_gcp_home ]] || mkdir -p $_gcp_home

    curl -fL https://sdk.cloud.google.com > "$_gcp_home/install.sh"
    if bash "$_gcp_home/install.sh" --disable-prompts --install-dir=$_gcp_home; then
        log_app_installation "gcp" "success"
        rm -f "$_gcp_home/install.sh"
    else
        log_app_installation "gcp" "fail"
        rm -f "$_gcp_home/install.sh"
        return $RC_ERROR
    fi
}


# Installs Go programming language
function _dotfiles_install_golang() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "golang" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # select package name
    local _golang_app_name
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _golang_app_name="go"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _golang_app_name="golang-go"
    fi

    # install or update
    if ! command_exists "go"; then
        install_apps "$_golang_app_name"
    else
        install_apps --update "$_golang_app_name"
    fi
}


# Installs htop system-monitoring tool
function _dotfiles_install_htop() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "htop" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "htop"; then
        install_apps "htop"
    else
        install_apps --update "htop"
    fi
}


# Installs iTerm2 (macOS only) terminal emulator
function _dotfiles_install_iterm() {

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_app_installation "iterm" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # skip if installed
    if is_app_installed "iterm2"; then
        log_app_installation "iterm" "skip"
        return $RC_SUCCESS
    fi

    # install (using brew cask since it's a GUI app)
    log_app_installation "iterm" "install"
    if brew install --cask iterm2; then
        log_app_installation "iterm" "success"
    else
        log_app_installation "iterm" "fail"
        return $RC_ERROR
    fi
}


# Installs Java Development Kit (JDK)
function _dotfiles_install_jdk() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "jdk" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # select package name
    local _jdk_app_name
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        _jdk_app_name="openjdk"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        _jdk_app_name="default-jdk"
    fi

    # install or update
    if ! command_exists "java"; then
        install_apps "$_jdk_app_name"
    else
        install_apps --update "$_jdk_app_name"
    fi
}


# Installs keyd (Linux only) for keyboard remapping
function _dotfiles_install_keyd() {

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_app_installation "keyd" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    local _keyd_home="$DOTFILES_XDG_CONFIG_DIR/keyd"
    [[ -d $_keyd_home ]] || mkdir -p $_keyd_home
    local _keyd_git_dir="$_keyd_home/keyd.git"

    if command_exists "keyd" || is_app_installed "keyd"; then

        if [[ ! -d $_keyd_git_dir ]]; then
            dotfiles_logging "Warn: $_keyd_git_dir is missing." "warn"
            log_app_installation "keyd" "skip"
            return $RC_SUCCESS
        else
            log_app_installation "keyd" "update"
            git -C $_keyd_git_dir pull
        fi

    else

        if [[ ! -d $_keyd_git_dir ]]; then

            log_app_installation "keyd" "install"
            git clone https://github.com/rvaiya/keyd $_keyd_git_dir

            if pushd $_keyd_git_dir >/dev/null; then
                if make && sudo make install; then
                    sudo systemctl enable keyd && sudo systemctl start keyd
                    log_app_installation "keyd" "success"
                    popd >/dev/null
                else
                    log_app_installation "keyd" "fail"
                    popd >/dev/null
                    return $RC_ERROR
                fi
            else
                log_app_installation "keyd" "fail"
                return $RC_ERROR
            fi

        else
            log_app_installation "keyd" "update"
            git -C $_keyd_git_dir pull
        fi
    fi

    if [[ $? -eq 0 ]]; then
        log_app_installation "keyd" "success"
    else
        log_app_installation "keyd" "fail"
        return $RC_ERROR
    fi
}


# Installs Kubernetes CLI (kubectl)
# Dependency: curl
function _dotfiles_install_kube() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "kube" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "kube" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # handle macOS
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "kubectl"; then
            install_apps "kubectl"
        else
            install_apps --update "kubectl"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if installed
        if command_exists "kubectl"; then
            log_app_installation "kube" "skip"
            return $RC_SUCCESS
        fi

        # check architecture
        if ! is_supported_system_archt; then
            log_app_installation "kube" "sys-archt-not-supported"
            return $RC_UNSUPPORTED
        fi

        # install
        log_app_installation "kube" "install"
        curl -fLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$DOTFILES_SYS_ARCHT/kubectl"
        if sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; then
            log_app_installation "kube" "success"
            rm -f kubectl
        else
            log_app_installation "kube" "fail"
            rm -f kubectl
            return $RC_ERROR
        fi
    fi
}


# Installs Meilisearch search engine
# Dependency: curl
function _dotfiles_install_meilisearch() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "meilisearch" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "meilisearch" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # handle macOS
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "meilisearch"; then
            install_apps "meilisearch"
        else
            install_apps --update "meilisearch"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if installed
        if command_exists "meilisearch"; then
            log_app_installation "meilisearch" "skip"
            return $RC_SUCCESS
        fi

        # install
        log_app_installation "meilisearch" "install"

        curl -L https://install.meilisearch.com | sh
        if sudo install -o root -g root -m 0755 meilisearch /usr/local/bin/meilisearch; then
            log_app_installation "meilisearch" "success"
            rm -f meilisearch
        else
            log_app_installation "meilisearch" "fail"
            rm -f meilisearch
            return $RC_ERROR
        fi
    fi
}


# Installs nvtop GPU monitoring tool
# Dependency: cmake, make
function _dotfiles_install_nvtop() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "nvtop" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "cmake" || ! command_exists "make"; then
        log_app_installation "nvtop" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # skip if installed
    if command_exists "nvtop"; then
        log_app_installation "nvtop" "skip"
        return $RC_SUCCESS
    fi

    # install
    log_app_installation "nvtop" "install"

    local _nvtop_home="$DOTFILES_XDG_CONFIG_DIR/nvtop"
    [[ -d $_nvtop_home ]] || mkdir -p $_nvtop_home

    local _nvtop_git_dir="$_nvtop_home/nvtop.git"
    if [[ ! -d $_nvtop_git_dir ]]; then

        git clone https://github.com/Syllo/nvtop.git $_nvtop_git_dir
        mkdir -p "$_nvtop_git_dir/build"

        if pushd "$_nvtop_git_dir/build" >/dev/null; then
            if cmake .. -DAPPLE_SUPPORT=ON && make && sudo make install; then
                log_app_installation "nvtop" "success"
                popd >/dev/null
            else
                log_app_installation "nvtop" "fail"
                popd >/dev/null
                return $RC_ERROR
            fi
        else
            log_app_installation "nvtop" "fail"
            return $RC_ERROR
        fi
    else
        log_app_installation "nvtop" "skip"
    fi
}


# Installs nvitop (Linux only) GPU monitoring tool via pip
# Dependency: nvidia-smi, pip
function _dotfiles_install_nvitop() {

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "linux" ]]; then
        log_app_installation "nvitop" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "nvidia-smi" || ! command_exists "pip"; then
        log_app_installation "nvitop" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # install or update
    if ! command_exists "nvitop"; then
        log_app_installation "nvitop" "install"
        pip install nvitop
    else
        log_app_installation "nvitop" "update"
        pip install --upgrade nvitop
    fi

    if [[ $? -eq 0 ]]; then
        log_app_installation "nvitop" "success"
    else
        log_app_installation "nvitop" "fail"
        return $RC_ERROR
    fi
}


# Installrts OpenVPN for virtual private networking
function _dotfiles_install_openvpn() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "openvpn" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "openvpn"; then
        install_apps "openvpn"
    else
        install_apps --update "openvpn"
    fi
}


# Installs Python and upgrades pip
function _dotfiles_install_python() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "python" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install Python and pip
    local _python_app_name
    if [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "python3 python3-pip python3-dev build-essential"
    fi

    # upgrade pip
    sudo pip3 install --upgrade pip
}


# Installs pyenv for Python version management
function _dotfiles_install_pyenv() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "pyenv" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "pyenv" && ! is_app_installed "pyenv"; then
            install_apps "openssl readline sqlite3 xz zlib pyenv pyenv-virtualenv"
        else
            install_apps --upgrade "pyenv pyenv-virtualenv"
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # home directory
        local _pyenv_home="$DOTFILES_XDG_CONFIG_DIR/pyenv"
        [[ -d $_pyenv_home ]] || mkdir -p $_pyenv_home

        # pyenv home
        local _pyenv_git_dir="$_pyenv_home/pyenv.git"
        local _pyenv_venv_git_dir="$_pyenv_home/pyenv.git/plugins/pyenv-virtualenv"

        # install or update
        if ! command_exists "pyenv" && ! is_app_installed "pyenv"; then

            log_app_installation "pyenv" "install"

            # install prerequisites
            install_apps "make libssl-dev zlib1g-dev libbz2-dev libreadline-dev"
            install_apps "libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev"
            install_apps "libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"

            # install with git
            [[ -d $_pyenv_git_dir ]] && rm -r $_pyenv_git_dir
            [[ -d $_pyenv_venv_git_dir ]] || rm -r $_pyenv_venv_git_dir

            git clone https://github.com/pyenv/pyenv.git $_pyenv_git_dir || {
                log_app_installation "pyenv" "fail"
                return $RC_ERROR
            }
            git clone https://github.com/pyenv/pyenv-virtualenv.git $_pyenv_venv_git_dir || {
                log_app_installation "pyenv" "fail"
                return $RC_ERROR
            }

        else
            git -C $_pyenv_git_dir pull || {
                log_app_installation "pyenv" "fail"
                return $RC_ERROR
            }
            git -C $_pyenv_venv_git_dir pull || {
                log_app_installation "pyenv" "fail"
                return $RC_ERROR
            }
        fi

        log_app_installation "pyenv" "success"
    fi
}


# Installs Subversion (SVN) version control
function _dotfiles_install_svn() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "svn" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "svn"; then
        install_apps "subversion"
    else
        install_apps --update "subversion"
    fi
}


# Installs tmux terminal multiplexer
function _dotfiles_install_tmux() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "tmux" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "tmux"; then
        install_apps "tmux"
    else
        install_apps --update "tmux"
    fi
}


# Installs tree command for directory listing
function _dotfiles_install_tree() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "tree" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "tree"; then
        install_apps "tree"
    else
        install_apps --update "tree"
    fi
}


# Installs Vim text editor
function _dotfiles_install_vim() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "vim" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "vim"; then
        install_apps "vim"
    else
        install_apps --update "vim"
    fi
}


# Installs Volta for Node.js version management
# Dependency: curl
function _dotfiles_install_volta() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "volta" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! command_exists "curl"; then
        log_app_installation "volta" "dependency-missing"
        return $RC_DEPENDENCY_MISSING
    fi

    # skip if installed
    if command_exists "volta"; then
        log_app_installation "volta" "skip"
        return $RC_SUCCESS
    fi

    # install
    log_app_installation "volta" "install"

    local _volta_home="$DOTFILES_XDG_CONFIG_DIR/volta"
    [[ -d $_volta_home ]] || mkdir -p $_volta_home
    export VOLTA_HOME=$_volta_home

    local _volta_npm_home_dir="$_volta_home/npm"
    [[ -d $_volta_npm_home_dir ]] || mkdir -p $_volta_npm_home_dir
    local _volta_npm_config_path="$_volta_npm_home_dir/.npmrc"
    export NPM_CONFIG_USERCONFIG=$_volta_npm_config_path

    if curl https://get.volta.sh | bash -s -- --skip-setup; then
        log_app_installation "volta" "success"
    else
        log_app_installation "volta" "fail"
        return $RC_ERROR
    fi
}


# Installs Visual Studio Code editor
# Dependency: wget (Linux only)
function _dotfiles_install_vscode() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "vscode" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        if ! command_exists "code" && ! is_app_installed "visual-studio-code"; then
            log_app_installation "vscode" "install"
            brew install --cask visual-studio-code
        else
            log_app_installation "vscode" "update"
            brew upgrade --cask visual-studio-code
        fi

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        if ! command_exists "wget"; then
            log_app_installation "vscode" "dependency-missing"
            return $RC_DEPENDENCY_MISSING
        fi

        if ! command_exists "code" && ! is_app_installed "code"; then

            log_app_installation "vscode" "install"

            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
            rm -f packages.microsoft.gpg

            sudo apt-get update
            sudo apt-get install -y code

        else
            install_apps --update "code"
        fi
    fi

    if [[ $? -eq 0 ]]; then
        log_app_installation "vscode" "success"
    else
        log_app_installation "vscode" "fail"
        return $RC_ERROR
    fi
}

# Installs watch command (macOS only) for running commands periodically
function _dotfiles_install_watch() {

    # sanity check
    if [[ $DOTFILES_SYS_NAME != "mac" ]]; then
        log_app_installation "watch" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi

    # install or update
    if ! command_exists "watch"; then
        install_apps "watch"
    else
        install_apps --update "watch"
    fi
}
