#!/bin/zsh


#------------------------------------------------------------------------------
#
# Utility Functions for App Installation
#
#
# Version: 0.0.2
# Last Modified: 2025-05-17
#
# - Dependency
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

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "p7zip"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "p7zip-full"
    else
        log_app_installation "7z" "sys-name-unknown"
        return 2
    fi
}


# Installs Alt-Tab (macOS only) for window switching
function _dotfiles_install_alt-tab() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "alt-tab"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        log_app_installation "alt-tab" "sys-name-not-supported"
        return 2
    else
        log_app_installation "alt-tab" "sys-name-unknown"
        return 2
    fi
}


# Installs Autoenv by cloning its Git repository
function _dotfiles_install_autoenv() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then

        log_app_installation "autoenv" "start"

        local _autoenv_home="$DOTFILES_XDG_CONFIG_DIR/autoenv"
        [[ -d $_autoenv_home ]] || mkdir -p $_autoenv_home

        local _autoenv_git_dir="$_autoenv_home/autoenv.git"
        if [[ ! -d $_autoenv_git_dir ]]; then
            git clone https://github.com/hyperupcall/autoenv.git $_autoenv_git_dir
        else
            git -C $_autoenv_git_dir pull
        fi

    else
        log_app_installation "autoenv" "sys-name-unknown"
        return 2
    fi
}


# Installs AWS CLI, with manual download on Linux
# Dependency: curl, unzip
function _dotfiles_install_aws() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "awscli"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if command_exists "aws"; then
            log_app_installation "aws" "skip"
            return 0
        fi

        log_app_installation "aws" "start"

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
                return 1
            }
        elif [[ $DOTFILES_SYS_ARCHT == "amd64" ]]; then
            curl -fL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$_aws_home/awscliv2.zip" || {
                log_app_installation "aws" "fail"
                rm -f "$_aws_home/awscliv2.zip"
                return 1
            }
        else
            log_app_installation "aws" "sys-archt-unknown"
            return 2
        fi

        # unzip and install
        unzip "$_aws_home/awscliv2.zip" -d $_aws_home && rm -f "$_aws_home/awscliv2.zip"
        sudo "$_aws_home/aws/install"

    else
        log_app_installation "aws" "sys-name-unknown"
    fi
}


# Installs Clojure programming language tools
function _dotfiles_install_clojure() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "clojure/tools/clojure"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "clojure"
    else
        log_app_installation "clojure" "sys-name-unknown"
        return 2
    fi
}


# Installs Docker, with manual setup on macOS and repository on Linux
# Dependency: curl
function _dotfiles_install_docker() {

    # skip if already installed
    if command_exists "docker"; then
        log_app_installation "docker" "skip"
        return 0
    fi

    # check if system archt is supported
    if [[ $DOTFILES_SYS_ARCHT != "arm64" && $DOTFILES_SYS_ARCHT != "amd64" ]]; then
        log_app_installation "docker" "sys-archt-unknown"
        return 2
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        log_app_installation "docker" "start"

        # ----- docker
        # download
        curl -O "https://desktop.docker.com/mac/main/$DOTFILES_SYS_ARCHT/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-$DOTFILES_SYS_ARCHT"

        # install
        sudo hdiutil attach Docker.dmg
        sudo /Volumes/Docker/Docker.app/Contents/MacOS/install

        # clean up
        sudo hdiutil detach /Volumes/Docker
        rm -f Docker.dmg

        # ----- docker-buildx
        brew install docker-buildx

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        log_app_installation "docker" "start"

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update && sudo_apt_install docker-ce docker-ce-cli containerd.io

    else
        log_app_installation "docker" "sys-name-unknown"
        return 2
    fi
}


# Installs Elasticsearch, with tarball on macOS and repository on Linux
# Dependency: wget and curl
function _dotfiles_install_elasticsearch() {

    # skip if already installed
    if command_exists "elasticsearch"; then
        log_app_installation "elasticsearch" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        # home
        local _es_home="$DOTFILES_XDG_CONFIG_DIR/es"
        [[ -d $_es_home ]] || mkdir -p $_es_home

        log_app_installation "elasticsearch" "start"

        # get version
        local _es_version=$(get_github_release_latest_version 'elastic' 'elasticsearch')
        local _es_zip_file_name="elasticsearch-$_es_version-darwin-x86_64.tar.gz"

        # download, verify, and extract
        [[ -d "$_es_home/es" ]] && rm -r "$_es_home/es"

        curl -O "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name"
        curl "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name.sha512" | shasum -a 512 -c -
        mkdir "$_es_home/es" && tar -xzf "$_es_zip_file_name" -C "$_es_home/es" --strip-components 1

        # Clean up
        rm -f "$_es_zip_file_name"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if is_app_installed "elasticsearch"; then
            log_app_installation "elasticsearch" "skip"
            return 0
        fi

        log_app_installation "elasticsearch" "start"

        # add repository and install
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
        install_apps "apt-transport-https"
        echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | \
            sudo tee /etc/apt/sources.list.d/elastic-8.x.list
        sudo apt-get update && sudo_apt_install elasticsearch

        # enable service
        sudo systemctl enable elasticsearch.service

    else
        log_app_installation "elasticsearch" "sys-name-unknown"
        return 2
    fi
}


# Installs Emacs text editor
function _dotfiles_install_emacs() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        # skip if already installed
        if command_exists "emacs" || is_app_installed "emacs"; then
            log_app_installation "emacs" "skip"
            return 0
        fi

        # install
        log_app_installation "emacs" "start"

        brew tap d12frosted/emacs-plus
        brew install emacs-plus

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "emacs"
    else
        log_app_installation "emacs" "sys-name-unknown"
        return 2
    fi
}


# Installs Google Cloud SDK
# Dependency: curl
function _dotfiles_install_gcp() {

    # skip if already installed
    if command_exists "gcloud"; then
        log_app_installation "gcp" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then

        log_app_installation "gcp" "start"

        # home
        local _gcp_home="$DOTFILES_XDG_CONFIG_DIR/gcp"
        [[ -d $_gcp_home ]] || mkdir -p $_gcp_home

        # install
        # brew install --cask google-cloud-sdk
        curl -fL https://sdk.cloud.google.com > "$_gcp_home/install.sh"
        bash "$_gcp_home/install.sh" --disable-prompts --install-dir=$_gcp_home
        rm -f "$_gcp_home/install.sh"

    else
        log_app_installation "gcp" "sys-name-unknown"
        return 2
    fi
}


# Installs Go programming language
function _dotfiles_install_golang() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "go"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "golang"
    else
        log_app_installation "golang" "sys-name-unknown"
        return 2
    fi
}


# Installs htop system-monitoring tool
function _dotfiles_install_htop() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps htop
    else
        log_app_installation "htop" "sys-name-unknown"
        return 2
    fi
}


# Installs iTerm2 (macOS only) terminal emulator
function _dotfiles_install_iterm() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        # skip if already installed
        if is_app_installed "iterm2"; then
            log_app_installation "iterm" "skip"
            return 0
        fi

        # install
        log_app_installation "iterm" "start"
        brew install --cask iterm2

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        log_app_installation "iterm" "sys-name-not-supported"
        return 2
    else
        log_app_installation "iterm" "sys-name-unknown"
        return 2
    fi
}


# Installs Java Development Kit (JDK)
function _dotfiles_install_jdk() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        # brew install --cask oracle-jdk
        install_apps "openjdk"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "default-jdk"
    else
        log_app_installation "jdk" "sys-name-unknown"
        return 2
    fi
}


# Installs keyd (Linux only) for keyboard remapping
function _dotfiles_install_keyd() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        log_app_installation "keyd" "sys-name-not-supported"
        return 2
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if command_exists "keyd" || is_app_installed "keyd"; then
            log_app_installation "keyd" "skip"
            return 0
        fi

        log_app_installation "keyd" "start"

        # home
        local _keyd_home="$DOTFILES_XDG_CONFIG_DIR/keyd"
        [[ -d $_keyd_home ]] || mkdir -p $_keyd_home

        # install manually
        local _keyd_git_dir="$_keyd_home/keyd.git"
        if [[ ! -d $_keyd_git_dir ]]; then
            git clone https://github.com/rvaiya/keyd $_keyd_git_dir
        fi
        cd $_keyd_git_dir && make && sudo make install

        # start
        sudo systemctl enable keyd && sudo systemctl start keyd
    else
        log_app_installation "keyd" "sys-name-unknown"
        return 2
    fi
}


# Installs Kubernetes CLI (kubectl)
# Dependency: curl
function _dotfiles_install_kube() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "kubectl"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if command_exists "kubectl" || is_app_installed "kubectl"; then
            log_app_installation "kube" "skip"
            return 0
        fi

        # check if system archt is supported
        if [[ $DOTFILES_SYS_ARCHT != "arm64" && $DOTFILES_SYS_ARCHT != "amd64" ]]; then
            log_app_installation "kube" "sys-archt-unknown"
            return 2
        fi

        # install
        log_app_installation "kube" "start"

        curl -fLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$DOTFILES_SYS_ARCHT/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm -f kubectl

    else
        log_app_installation "kube" "sys-name-unknown"
        return 2
    fi
}


# Installs Meilisearch search engine
# Dependency: curl
function _dotfiles_install_meilisearch() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "meilisearch"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if command_exists "meilisearch" || is_app_installed "meilisearch"; then
            log_app_installation "meilisearch" "skip"
            return 0
        fi

        # install
        log_app_installation "meilisearch" "start"

        curl -L https://install.meilisearch.com | sh
        sudo install -o root -g root -m 0755 meilisearch /usr/local/bin/meilisearch
        rm -f meilisearch

    else
        log_app_installation "meilisearch" "sys-name-unknown"
        return 2
    fi
}


# Installs nvtop GPU monitoring tool
# Dependency: cmake and make
function _dotfiles_install_nvtop() {

    # skip if already installed
    if command_exists "nvtop"; then
        log_app_installation "nvtop" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then

        # install
        # sudo apt-get install nvtop
        # https://github.com/Syllo/nvtop?tab=readme-ov-file#nvtop-build

        # home
        local _nvtop_home="$DOTFILES_XDG_CONFIG_DIR/nvtop"
        [[ -d $_nvtop_home ]] || mkdir -p $_nvtop_home

        # check if exist
        local _nvtop_git_dir="$_nvtop_home/nvtop.git"
        if [[ ! -d $_nvtop_git_dir ]]; then

            log_app_installation "nvtop" "start"

            # download, build and install
            git clone https://github.com/Syllo/nvtop.git $_nvtop_git_dir
            mkdir -p "$_nvtop_git_dir/build" && cd "$_nvtop_git_dir/build"
            cmake .. -DAPPLE_SUPPORT=ON
            make && sudo make install

            cd -
        fi

    else
        log_app_installation "nvtop" "sys-name-unknown"
        return 2
    fi
}


# Installs nvitop (Linux only) GPU monitoring tool via pip
# Dependency: nvidia-smi and pip
function _dotfiles_install_nvitop() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        log_app_installation "nvitop" "sys-name-not-supported"
        return 2
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if command_exists "nvitop"; then
            log_app_installation "nvitop" "skip"
            return 0
        fi

        # check dependency
        if { ! command_exists "nvidia-smi" } || { ! command_exists "pip" }; then
            log_app_installation "nvitop" "dependency-missing"
            return 1
        fi

        # install with pip
        log_app_installation "nvitop" "start"
        pip install nvitop

    else
        log_app_installation "nvitop" "sys-name-unknown"
        return 2
    fi
}


# Installs OpenVPN for virtual private networking
function _dotfiles_install_openvpn() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "openvpn"
        # sudo brew services start openvpn
    else
        log_app_installation "openvpn" "sys-name-unknown"
        return 2
    fi
}


# Installs Python and upgrades pip
function _dotfiles_install_python(){

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        sudo pip install --upgrade pip
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "python3 python3-pip python3-dev build-essential"
        sudo pip3 install --upgrade pip
    else
        log_app_installation "python" "sys-name-unknown"
        return 2
    fi
}


# Installs pyenv for Python version management
function _dotfiles_install_pyenv() {

    # skip if already installed
    if command_exists "pyenv"; then
        log_app_installation "pyenv" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        log_app_installation "pyenv" "start"
        install_apps "openssl readline sqlite3 xz zlib pyenv pyenv-virtualenv"

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        log_app_installation "pyenv" "start"

        # install prerequisites
        install_apps "make libssl-dev zlib1g-dev libbz2-dev libreadline-dev"
        install_apps "libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev"
        install_apps "libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"

        # home directory
        local _pyenv_home="$DOTFILES_XDG_CONFIG_DIR/pyenv"
        [[ -d $_pyenv_home ]] || mkdir -p $_pyenv_home

        # clone repositories
        local _pyenv_git_dir="$_pyenv_home/pyenv.git"
        local _pyenv_venv_git_dir="$_pyenv_home/pyenv.git/plugins/pyenv-virtualenv"
        [[ -d $_pyenv_git_dir ]] || git clone https://github.com/pyenv/pyenv.git $_pyenv_git_dir
        [[ -d $_pyenv_venv_git_dir ]] || git clone https://github.com/pyenv/pyenv-virtualenv.git $_pyenv_venv_git_dir

    else
        log_app_installation "pyenv" "sys-name-unknown"
        return 2
    fi
}


# Installs Subversion (SVN) version control
function _dotfiles_install_svn() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "subversion"
    else
        log_app_installation "svn" "sys-name-unknown"
        return 2
    fi
}


# Installs tmux terminal multiplexer
function _dotfiles_install_tmux() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "tmux"
    else
        log_app_installation "tmux" "sys-name-unknown"
        return 2
    fi
}


# Installs tree command for directory listing
function _dotfiles_install_tree() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "tree"
    else
        log_app_installation "tree" "sys-name-unknown"
        return 2
    fi
}


# Installs Vim text editor
function _dotfiles_install_vim() {

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then
        install_apps "vim"
    else
        log_app_installation "vim" "sys-name-unknown"
        return 2
    fi
}


# Installs Volta for Node.js version management
# Dependency: curl
function _dotfiles_install_volta() {

    # skip if already installed
    if command_exists "volta"; then
        log_app_installation "volta" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]; then

        log_app_installation "volta" "start"

        # home directory
        local _volta_home="$DOTFILES_XDG_CONFIG_DIR/volta"
        [[ -d $_volta_home ]] || mkdir -p $_volta_home
        export VOLTA_HOME=$_volta_home

        # volta npm config
        local _volta_npm_home_dir="$_volta_home/npm"
        [[ -d $_volta_npm_home_dir ]] || mkdir -p $_volta_npm_home_dir

        local _volta_npm_config_path="$_volta_npm_home_dir/.npmrc"
        export NPM_CONFIG_USERCONFIG=$_volta_npm_config_path

        # install
        curl https://get.volta.sh | bash -s -- --skip-setup

    else
        log_app_installation "volta" "sys-name-unknown"
        return 2
    fi
}


# Installs Visual Studio Code editor
# Dependency: wget
function _dotfiles_install_vscode() {

    # skip if already installed
    if command_exists "code"; then
        log_app_installation "vscode" "skip"
        return 0
    fi

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        # skip if already installed
        if is_app_installed "visual-studio-code"; then
            log_app_installation "vscode" "skip"
            return 0
        fi

        # install with brew cask
        log_app_installation "vscode" "start"
        brew install --cask visual-studio-code

    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then

        # skip if already installed
        if is_app_installed "code"; then
            log_app_installation "vscode" "skip"
            return 0
        fi

        # Add repository and install
        log_app_installation "vscode" "start"

        sudo apt-get install wget gpg
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        rm -f packages.microsoft.gpg

        install_apps "apt-transport-https"
        sudo apt update
        sudo_apt_install code

    else
        log_app_installation "vscode" "sys-name-unknown"
        return 2
    fi
}


# Installs watch command (macOS only) for running commands periodically
function _dotfiles_install_watch() {

    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        install_apps "watch"
    elif [[ $DOTFILES_SYS_NAME == "linux" ]]; then
        log_app_installation "watch" "sys-name-not-supported"
        return 0
    else
        log_app_installation "watch" "sys-name-unknown"
        return 2
    fi
}
