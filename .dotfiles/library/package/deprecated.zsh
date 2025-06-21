#!/bin/zsh


# bottom
if [[ ${DOTFILES_PLUGINS[bottom]} = "true" ]]; then

    if [[ $SYS_NAME == mac ]]; then

        zinit ice wait"2" lucid from"gh-r" as"program" pick"btm"
        zinit light ClementTsang/bottom

    elif [[ $SYS_NAME == linux ]]; then

        zinit ice wait"2" lucid from"gh-r" as"program" bpick='*.deb' pick"usr/bin/btm"
        zinit light ClementTsang/bottom

    fi
fi


# ------------------------------------------------------------------------------
#
# clojure
#
# - Environment Variables
#   - CLJ_CONFIG
#
# - PATH
#   - /Applications/clojure
#
# ------------------------------------------------------------------------------


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

function _dotfiles_init_clojure() {

    # sanity check
    if ! command_exists "clojure"; then
        log_app_initialization "clojure" "fail"
        return $RC_ERROR
    fi

    # home
    local _clj_home_dir=$(setup_dotfiles_app_home "clojure")
    export CLJ_CONFIG=$_clj_home_dir

    # .m2 cache
    local _m2_dir="$DOTFILES_LOCAL_CACHE_DIR/maven/repository"
    ensure_directory "$_m2_dir"
    alias clojure="clojure -Sdeps '{:mvn/local-repo \"$_m2_dir\"}' "

    # path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        append_dir_to_path "PATH" "/Applications/clojure"
    fi
}


# ------------------------------------------------------------------------------
#
# docker
#
# - References
#   - https://docs.docker.com/reference/cli/docker/#environment-variables
#
# - Environment Variables
#   - DOCKER_CONFIG
#   - DOCKER_DEFAULT_PLATFORM
#
# dockerd
#
# - References
#   - https://docs.docker.com/reference/cli/dockerd/#environment-variables
#
# - Environment Variables
#   - DOCKER_CERT_PATH
#
# ------------------------------------------------------------------------------


# Installs Docker, with manual setup on macOS and repository on Linux
# Dependency: curl
function _dotfiles_install_docker() {

    # sanity check
    if ! is_supported_system_name; then
        log_app_installation "docker" "sys-name-not-supported"
        return $RC_UNSUPPORTED
    fi
    if ! is_supported_system_archt; then
        log_app_installation "docker" "sys-archt-not-supported"
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


# ------------------------------------------------------------------------------
#
# Elasticsearch
#
# Slow, should be loaded in background with zinit.
#
# - References
#   - https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-enroll-agent
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-windows.html#windows-service-settings
#
# - Environment Variables
#   - ES_HOME
#   - ES_JAVA_HOME
#
# ------------------------------------------------------------------------------


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
    local _es_home_dir="$DOTFILES_LOCAL_CONFIG_DIR/es"
    ensure_directory "$_es_home_dir"

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
    [[ -d "$_es_home_dir/es" ]] && rm -rf "$_es_home_dir/es"

    curl -O "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name"
    curl "https://artifacts.elastic.co/downloads/elasticsearch/$_es_zip_file_name.sha512" | shasum -a 512 -c -
    mkdir "$_es_home_dir/es" && tar -xzf "$_es_zip_file_name" -C "$_es_home_dir/es" --strip-components 1
    rm -f "$_es_zip_file_name"
}

function _dotfiles_init_es(){

    # sanity check
    local _es_home_dir="$DOTFILES_LOCAL_CONFIG_DIR/es/es"
    if [[ ! -d "$_es_home_dir" ]]; then
        log_app_initialization "es" "fail"
        return $RC_ERROR
    fi

    # home
    export ES_HOME=$_es_home_dir

    # path
    append_dir_to_path "PATH" "$_es_home_dir/bin"

    # java
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        export ES_JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home)}"
    fi
}


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

        local _bin_path="$DOTFILES_LOCAL_BIN_DIR/$_package_name"
        local _latest_ver="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

        # upgrade
        if [[ -f "$_bin_path" ]]; then

            # check local version
            local _local_ver=$(kubectl version --client | sed -n 's/Client Version: \(.*\)/\1/p')
            if [[ "$_local_ver" == "$_latest_ver" ]]; then
                log_dotfiles_package_installation "$_package_name" "up-to-date"
                return $RC_SUCCESS
            fi

            # remove and reinstall
            log_dotfiles_package_installation "$_package_name" "upgrade"
            sudo rm -f "$_bin_path"

        else
            log_dotfiles_package_installation "$_package_name" "install"
        fi

        # install
        curl -fLO "https://dl.k8s.io/release/$_latest_ver/bin/linux/$DOTFILES_SYS_ARCHT/kubectl"
        if sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; then
            log_dotfiles_package_installation "$_package_name" "success"
            rm -f kubectl
        else
            log_dotfiles_package_installation "$_package_name" "fail"
            rm -f kubectl
            return $RC_ERROR
        fi

    elif [[ $DOTFILES_SYS_NAME == "mac" ]]; then

        _package_id="kubectl"

        if ! command_exists "$_package_name"; then
            install_dotfiles_packages "$_package_name" "package-manager" "$_package_id"
        else
            install_dotfiles_packages --upgrade "$_package_name" "package-manager" "$_package_id"
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

    local _nvtop_home_dir="$DOTFILES_LOCAL_CONFIG_DIR/nvtop"
    ensure_directory "$_nvtop_home_dir"

    local _nvtop_git_dir="$_nvtop_home_dir/nvtop.git"
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


# ------------------------------------------------------------------------------
#
# openvpn
#
# - References
#   - https://openvpn.net/community-resources/reference-manual-for-openvpn-2-5/
#
# ------------------------------------------------------------------------------


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

function _dotfiles_init_openvpn() {

    # sanity check
    if ! command_exists "openvpn"; then
        log_app_initialization "openvpn" "fail"
        return $RC_ERROR
    fi

    # mac, path
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        append_dir_to_path "PATH" "$BREW_HOME/opt/openvpn/sbin"
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
