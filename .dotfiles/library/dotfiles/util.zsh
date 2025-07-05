#!/bin/zsh


# ------------------------------------------------------------------------------
#
# Dotfiles Utility Functions
#
#
# Version: 0.0.6
# Last Modified: 2025-07-03
#
# - Dependency
#   - Environment Variable Files
#     - .dotfiles/env/dotfiles.env
#     - .dotfiles/env/color.env
#     - .dotfiles/env/return_code.env
#
#   - Environment Variables
#     - DOTFILES_PACKAGE_ASC_ARR
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - ZINIT_REGISTERED_PLUGINS
#
#   - Library
#     - $DOTFILES_DOT_LIB_DIR/util.zsh
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Local
# ------------------------------------------------------------------------------


# Setup dot config with symlink
# $1: package name
# $2: dot config filename
# $3: local package name
# $4: local dot config filename
# Returns: dot config link path via echo if successful, exits on failure
function link_dotfiles_dot_config_to_local() {

    # local package dot config link -> dot config file
    local _source_path="$DOTFILES_DOT_CONFIG_DIR/$1/$2"
    local _link_path="$DOTFILES_LOCAL_CONFIG_DIR/$3/$4"

    ensure_directory "$DOTFILES_LOCAL_CONFIG_DIR/$3"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        log_message "Skipped linking config from $_source_path to $_link_path." "warn"
    elif [[ $_rc != $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}

# Setup user config with symlink
# $1: package name
# $2: user config filename
# $3: local package name
# $4: local user config filename
# Returns: local user config link path via echo
function link_dotfiles_user_config_to_local() {

    # local package user config link -> user config file
    local _source_path="$DOTFILES_USER_CONFIG_DIR/$1/$2"
    local _link_path="$DOTFILES_LOCAL_CONFIG_DIR/$3/$4"

    ensure_directory "$DOTFILES_LOCAL_CONFIG_DIR/$3"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        :
    elif [[ $_rc != $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}

# Setup user credentials with symlink
# $1: package name
# $2: user credentials filename
# $3: local package name
# $4: local credentials filename
# Returns: credentials link path via echo
function link_dotfiles_user_credential_to_local() {

    # local package user credential link -> user credential file
    local _source_path="$DOTFILES_USER_SECRET_DIR/$1/$2"
    local _link_path="$DOTFILES_LOCAL_CONFIG_DIR/$3/$4"

    ensure_directory "$DOTFILES_LOCAL_CONFIG_DIR/$3"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        :
    elif [[ $_rc != $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}

# Setup local share config with symlink
# $1: package name
# $2: share config filename
# $3: local package name
# $4: local share config filename
# Returns: share config link path via echo if successful, exits on failure
function link_dotfiles_share_config_to_local() {

    # local package share config link -> share config file
    local _source_path="$DOTFILES_LOCAL_SHARE_DIR/$1/$2"
    local _link_path="$DOTFILES_LOCAL_CONFIG_DIR/$3/$4"

    ensure_directory "$DOTFILES_LOCAL_CONFIG_DIR/$3"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        log_message "Skipped linking config from $_source_path to $_link_path." "warn"
    elif [[ $_rc != $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}

# Setup local share completion with symlink
# $1: share completion directory
# $2: share completion filename
# $3: local completion filename
# Returns: dot completion link path via echo if successful, exits on failure
function link_dotfiles_share_completion_to_local() {

    local _source_path="$DOTFILES_LOCAL_SHARE_DIR/$1/$2"
    local _link_path="$DOTFILES_ZSH_COMP_DIR/$3"

    ensure_directory "$DOTFILES_ZSH_COMP_DIR"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        log_message "Skipped linking completion from $_source_path to $_link_path." "warn"
    elif [[ $_rc -ne $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}


# ------------------------------------------------------------------------------
# User
# ------------------------------------------------------------------------------


# Setup history symlink in user history directory to local package history
# $1: package name
# $2: history filename in DOTFILES_LOCAL_STATE_DIR
# $3: history filename in user directory (optional, defaults to "$package_name.history")
function link_dotfiles_local_history_to_user() {

    # sanity check
    [[ -d "$DOTFILES_USER_HIST_DIR" ]] || return $RC_SKIPPED

    # user history link -> local state history file
    local _package_name="$1"
    local _state_history_file="$2"
    local _user_history_file="${3:-$_package_name.history}"

    local _source_path="$DOTFILES_LOCAL_STATE_DIR/$_package_name/$_state_history_file"
    local _link_path="$DOTFILES_USER_HIST_DIR/$_user_history_file"

    local _rc
    create_validated_symlink "$_source_path" "$_link_path"
    _rc=$?
    if [[ $_rc == $RC_SKIPPED ]]; then
        :
    elif [[ $_rc != $RC_SUCCESS ]]; then
        log_message "Failed to link from $_source_path to $_link_path" "error"
    fi

    return $_rc
}


# ------------------------------------------------------------------------------
#
# Packages
#
# - Dependency
#   - Apps
#     - apt-get
#     - homebrew
#     - git
#     - zinit
#
#   - Environment Variables
#     - DOTFILES_PACKAGE_ASC_ARR
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#     - ZINIT_REGISTERED_PLUGINS
#
# ------------------------------------------------------------------------------


function init_all_dotfiles_packages() {

    # init powerlevel10k before other dotfiles packages
    if is_dotfiles_managed_package "powerlevel10k"; then
        dotfiles_init_powerlevel10k
    fi

    # init dotfiles packages
    for _pkg in ${(k)DOTFILES_PACKAGE_ASC_ARR}; do

        # skip powerlevel10k
        if [[ "$_pkg" == "powerlevel10k" ]]; then
            continue
        fi

        # double check and skip false
        if ! is_dotfiles_managed_package "$_pkg"; then
            continue
        fi

        # skip package without init function
        local _init_func="dotfiles_init_${_pkg}"
        if (( ! ${+functions[$_init_func]} )); then
            continue
        fi

        # init package
        $_init_func
        if [[ $? -ne $RC_SUCCESS ]]; then
            log_dotfiles_package_initialization "$_pkg" "fail"
        fi
    done
}

function install_all_dotfiles_packages() {

    local -a skipped_packages=("python" "git" "ssh")

    # install python before other dotfiles packages
    if is_dotfiles_managed_package "python"; then
        dotfiles_install_python
    fi

    # install dotfiles packages
    for _pkg in ${(k)DOTFILES_PACKAGE_ASC_ARR}; do

        # skip python
        if [[ " ${skipped_packages[@]} " =~ " $_pkg " ]]; then
            continue
        fi

        # double check and skip false
        if ! is_dotfiles_managed_package "$_pkg"; then
            continue
        fi

        # skip package without installation function
        local _install_func="dotfiles_install_${_pkg}"
        if [[ ! -v "functions[${_install_func}]" ]]; then
            log_dotfiles_package_installation "$_pkg" "skip"
            continue
        fi

        # installation package
        $_install_func
    done
}

# Usage: _install_dotfiles_package_with_package_manager
#        <package_name> <package_management_type> <upgrade_bool> <package_id>
function _install_dotfiles_package_with_package_manager() {

    # input argument
    local _package_name="$1"
    local _package_type="$2"
    local _upgrade_bool="$3"
    local _package_id="$4"

    # install or upgrade
    if ! { command_exists "$_package_id" || is_dotfiles_package_installed "$_package_name" "$_package_type" "$_package_id" }; then

        case "$DOTFILES_SYS_NAME" in

            "mac")
                brew install "$_package_id" || return $RC_ERROR ;;

            "linux")
                sudo apt-get install --no-install-recommends --no-install-suggests -y "$_package_id" || return $RC_ERROR ;;

            *)
                return $RC_UNSUPPORTED ;;
        esac

    elif $_upgrade_bool; then

        case "$DOTFILES_SYS_NAME" in

            "mac")
                brew upgrade "$_package_id" || return $RC_ERROR ;;

            "linux")
                sudo apt-get install --only-upgrade "$_package_id" || return $RC_ERROR ;;

            *)
                return $RC_UNSUPPORTED ;;
        esac

    else
        return $RC_SKIPPED
    fi

    return $RC_SUCCESS
}

# Usage: _install_dotfiles_package_with_zinit
#        <package_name> <package_management_type> <upgrade_bool> <package_id>
function _install_dotfiles_package_with_zinit() {

    # input argument
    local _package_name="$1"
    local _package_type="$2"
    local _upgrade_bool="$3"
    local _package_id="$4"

    # install or upgrade
    if ! { is_dotfiles_package_installed "$_package_name" "$_package_type" "$_package_id" }; then

        if [[ "$_package_type" == "zinit-plugin" ]]; then
            zinit light "$_package_id" || return $RC_ERROR
        elif [[ "$_package_type" == "zinit-snippet" ]]; then
            zinit snippet "$_package_id" || return $RC_ERROR
        fi

    elif [[ "$_upgrade_bool" == "true" ]]; then
        zinit update "$_package_id"
    else
        return $RC_SKIPPED
    fi

    return $RC_SUCCESS
}

# Usage: _install_dotfiles_package_with_git_repo
#        <package_name> <package_management_type> <upgrade_bool> <package_id>
function _install_dotfiles_package_with_git_repo() {

    # check input argument
    local _package_name="$1"
    local _package_type="$2"
    local _upgrade_bool="$3"
    local _package_id="$4"

    local _package_git_url="https://github.com/$_package_id.git"

    # install or upgrade
    local _package_home_dir="$DOTFILES_LOCAL_SHARE_DIR/$_package_name"
    local _package_git_dir="$_package_home_dir/$_package_name.git"
    ensure_directory "$_package_home_dir"

    if ! { is_dotfiles_package_installed "$_package_name" "$_package_type" "$_package_id"}; then

        if [[ -d $_package_git_dir ]]; then
            return $RC_ALREADY_EXISTS
        fi

        case $_package_type in

            "git-repo-pull")
                git clone $_package_git_url $_package_git_dir || return $RC_ERROR  ;;

            "git-repo-make-install")
                {
                    git clone $_package_git_url $_package_git_dir && \
                    pushd $_package_git_dir >/dev/null && \
                    make && sudo make install && \
                    popd >/dev/null

                } || {
                    popd >/dev/null
                    return $RC_ERROR
                } ;;
        esac

    elif [[ "$_upgrade_bool" == "true" ]]; then

        case $_package_type in

            "git-repo-pull")
                git -C $_package_git_dir pull || return $RC_ERROR  ;;

            "git-repo-make-install")
                {
                    # TODO: make upgrade
                    git -C $_package_git_dir pull && \
                    pushd $_package_git_dir >/dev/null && \
                    popd >/dev/null

                } || {
                    popd >/dev/null
                    return $RC_ERROR
                } ;;
        esac

    else
        return $RC_SKIPPED
    fi

    return $RC_SUCCESS
}

# Usage: _install_dotfiles_package_with_pip
#        <package_name> <package_management_type> <upgrade_bool> <package_id>
function _install_dotfiles_package_with_pip() {

    # input argument
    local _package_name="$1"
    local _package_type="$2"
    local _upgrade_bool="$3"
    local _package_id="$4"

    # install or upgrade
    if ! { is_dotfiles_package_installed "$_package_name" "$_package_type" "$_package_id" }; then
        pip install "$_package_id" || return $RC_ERROR
    elif [[ "$_upgrade_bool" == "true" ]]; then
        pip install --upgrade "$_package_id" || return $RC_ERROR
    else
        return $RC_SKIPPED
    fi

    return $RC_SUCCESS
}

# Helper function to pivot package installation by management type
function _install_dotfiles_package() {

    local _package_name="$1"
    local _package_type="$2"
    local _upgrade_bool="$3"
    local _package_id="$4"

    # install or upgrade
    case $_package_type in

        "git-repo-pull" | "git-repo-make-install")
            _install_dotfiles_package_with_git_repo $_package_name $_package_type $_upgrade_bool $_package_id ;;

        "package-manager")
            _install_dotfiles_package_with_package_manager $_package_name $_package_type $_upgrade_bool $_package_id ;;

        "pip")
            _install_dotfiles_package_with_pip $_package_name $_package_type $_upgrade_bool $_package_id ;;

        "zinit-plugin" | "zinit-snippet")
            _install_dotfiles_package_with_zinit $_package_name $_package_type $_upgrade_bool $_package_id ;;

        *)
            log_message "Unknown package management type $_package_type provided for package $_package_name." "error"
            return $RC_INVALID_ARGS ;;
    esac
}

function _install_dotfiles_package_parse_argument() {

    # parse input
    local _upgrade_bool="false"
    local _package_name
    local _package_type
    local _package_ids

    if [[ "$1" == "--upgrade" ]]; then
        _upgrade_bool="true"
        shift
    fi

    if [[ -z "$1" ]]; then
        log_message "No package name provided." "error"
        return $RC_INVALID_ARGS
    fi
    _package_name="$1"

    if [[ -z "$2" ]]; then
        log_message "No package management type provided for package $_package_name." "error"
        return $RC_INVALID_ARGS
    fi
    _package_type="$2"

    if [[ -z "$3" ]]; then
        log_message "No package ids provided for package $_package_name." "error"
        return $RC_INVALID_ARGS
    fi
    _package_ids="${@:3}"

    # sanity check
    case $_package_type in

        "git-repo-pull" | "git-repo-make-install")
            [[ $# -eq 3 ]] || {
                log_message "Package management type $_package_type does not support multiple packages installation." "error"
                return $RC_UNSUPPORTED
            } ;;

        "zinit-plugin" | "zinit-snippet")
            [[ $# -eq 3 ]] || {
                log_message "Package management type $_package_type does not support multiple packages installation." "error"
                return $RC_UNSUPPORTED
            } ;;
    esac

    # return parsed arguements
    echo "$_upgrade_bool" "$_package_name" "$_package_type" "$_package_ids"
}

# Usage: install_dotfiles_packages
#        <options: --upgrade> <package_name> <package_management_type> <package_ids>
#
# package management type: (
#    "git-repo-make-install",
#    "git-repo-pull",
#    "package-manager",
#    "pip",
#    "zinit-plugin",
#    "zinit-snippet",
# )
# package_ids: space separated multiple package ids to install
function install_dotfiles_packages() {

    # parse arguments
    local _parsed_args=($(_install_dotfiles_package_parse_argument "$@"))
    local _return_code=$?
    if [[ $_return_code != $RC_SUCCESS ]]; then
        log_dotfiles_package_installation "$_package_name" "fail"
        return $_return_code
    fi

    local _upgrade_bool="${_parsed_args[1]}"
    local _package_name="${_parsed_args[2]}"
    local _package_type="${_parsed_args[3]}"

    # loop through package ids for installation
    if [[ "$_upgrade_bool" == "true" ]]; then
        log_dotfiles_package_installation "$_package_name" "upgrade"
    else
        log_dotfiles_package_installation "$_package_name" "install"
    fi

    for _pkg_id in "${_parsed_args[@]:3}"; do

        _install_dotfiles_package "$_package_name" "$_package_type" "$_upgrade_bool" "$_pkg_id"
        local _return_code=$?

        # handle return code
        if [[ $_return_code == $RC_SKIPPED ]]; then
            log_dotfiles_package_installation "$_pkg_id" "dependency-skip"
        elif [[ $_return_code != $RC_SUCCESS ]]; then
            case $_return_code in
                $RC_DEPENDENCY_MISSING)
                    log_dotfiles_package_installation "$_package_name" "dependency-missing" ;;
                $RC_ALREADY_EXISTS)
                    log_dotfiles_package_installation "$_package_name" "already-exist" ;;
                $RC_UNSUPPORTED)
                    log_dotfiles_package_installation "$_package_name" "sys-name-not-supported" ;;
                *)
                    log_dotfiles_package_installation "$_package_name" "fail" ;;
            esac
            return $_return_code
        fi
    done

    # success
    log_dotfiles_package_installation "$_package_name" "success"
}

# Check if a package is in the managed list
# Usage: is_dotfiles_managed_package "package_name"
# Returns: RC_SUCCESS if managed, RC_UNSUPPORTED if not managed, RC_INVALID_ARGS if no argument provided
function is_dotfiles_managed_package() {

    if [[ -z "$1" ]]; then
        log_message "No \$1 package name provided." "error"
        return $RC_INVALID_ARGS
    fi

    if [[ "${DOTFILES_PACKAGE_ASC_ARR[$1]}" == "true" ]]; then
        return $RC_SUCCESS
    else
        return $RC_UNSUPPORTED
    fi
}

# Check if a package is installed.
# $1: package name
# $2: package id
# $3: package management type (
#     "git-repo-make-install",
#     "git-repo-pull",
#     "package-manager",
#     "pip",
#     "zinit-plugin",
#     "zinit-snippet",
# )
# Returns: 0 if installed, non-zero if not installed or error
function is_dotfiles_package_installed() {

    # sanity check
    local _package_name="$1"
    local _package_manage_type="$2"
    local _package_id="$3"

    if [[ -z "$1" ]]; then
        log_message "No \$1 package name provided." "error"
        return $RC_INVALID_ARGS
    elif [[ -z "$2" ]]; then
        log_message "No \$2 package management type provided." "error"
        return $RC_INVALID_ARGS
    elif [[ -z "$3" ]]; then
        log_message "No \$3 package id provided." "error"
        return $RC_INVALID_ARGS
    fi

    # check installation
    case $_package_manage_type in

        "git-repo-pull" | "git-repo-make-install")
            [[ -d "$DOTFILES_LOCAL_SHARE_DIR/$_package_name/$_package_name.git" ]] ;;

        "package-manager")
            if [[ "$DOTFILES_SYS_NAME" == "linux" ]]; then
                dpkg-query -s "$_package_id" &>/dev/null
            elif [[ "$DOTFILES_SYS_NAME" == "mac" ]]; then
                brew list "$_package_id" --quiet &>/dev/null
            else
                log_message "Unsupported system name $DOTFILES_SYS_NAME." "error"
                return $RC_UNSUPPORTED
            fi ;;

        "pip")
            { pip show "$_package_name" &> /dev/null } || { python -c "import $_package_name" } ;;

        "zinit-plugin" | "zinit-snippet")
            # check with package name for id-as modifier
            [[ -d "$ZINIT_PLUGIN_DIR/$_package_name" ]] && return $RC_SUCCESS
            [[ -d "$ZINIT_SNIPPET_DIR/$_package_name" ]] && return $RC_SUCCESS

            # check with package id by splitting with /
            local _git_repo_name="${${_package_id%%/*}// /}"
            local _git_repo_path="${${_package_id#*/}// /}"
            if [[ -z $_git_repo_name ]] || [[ -z $_git_repo_path ]]; then
                log_message "Failed to parse package id $_package_id for package $_package_name." "error"
                return $RC_INVALID_ARGS
            fi
            [[ -d "$ZINIT_PLUGIN_DIR/$_git_repo_name---$_git_repo_path" ]] && return $RC_SUCCESS
            [[ -d "$ZINIT_SNIPPET_DIR/$_git_repo_name--$_git_repo_path" ]] && return $RC_SUCCESS

            [[ -d "$ZINIT_PLUGIN_DIR/$_git_repo_name/$_git_repo_path" ]] && return $RC_SUCCESS
            [[ -d "$ZINIT_SNIPPET_DIR/$_git_repo_name/$_git_repo_path" ]] && return $RC_SUCCESS

            return $RC_NOT_FOUND ;;

        *)
            log_message "Unknown package management type $_package_manage_type for package $_package_id." "error"
            return $RC_UNSUPPORTED ;;
    esac
}

# Logs a message related to the initialization of a package based on the provided status code.
#
# Parameters:
#   $1 - The name of the package.
#   $2 - The status code indicating the result of the initialization attempt.
#        Possible values:
#          "fail" - Initialization failed.
#          "success" - Initialization succeeded.
#          "sys-name-not-supported" - Package not supported on this system name.
#          "sys-archt-not-supported" - Package not supported on this system architecture.
function log_dotfiles_package_initialization() {

    local _package_name=$1
    local _status_code=$2

    case $_status_code in

        "fail")
            log_message "Failed to initialize package \"$_package_name\"." "error" ;;

        "success")
            log_message "Successfully initialized package \"$_package_name\"." "info" ;;

        "sys-name-not-supported")
            log_message "Package \"$_package_name\" is not supported on system '$DOTFILES_SYS_NAME'. Initialization skipped." "warn" ;;

        "sys-archt-not-supported")
            log_message "Package \"$_package_name\" is not supported on architecture '$DOTFILES_SYS_ARCHT'. Initialization skipped." "warn" ;;

        *)
            log_message "log_dotfiles_package_initialization: Invalid status code \"$_status_code\"" "error"

            local _usage_message="Usage: log_dotfiles_package_initialization <package_name> <status_code>"
            _usage_message+="\n\t<status_code> should be one of: fail, success, sys-name-not-supported, sys-archt-not-supported"
            log_message "$_usage_message" "info" ;;
    esac
}

# Logs a message related to the installation of a package based on the provided status code.
#
# Parameters:
#   $1 - The name of the package.
#   $2 - The status code indicating the result of the installation attempt.
#        Possible values:
#          "already-exist"
#          "dependency-missing" - Installation failed due to missing dependencies.
#          "dependency-skip"
#          "fail" - Installation or upgrade failed.
#          "install" - Starting installation.
#          "skip" - Package is already installed, skipping.
#          "success" - Installation or upgrade succeeded.
#          "sys-name-not-supported" - Package not supported on this system name.
#          "sys-archt-not-supported" - Package not supported on this system architecture.
#          "up-to-date"
#          "upgrade" - Package is installed, checking for upgrades.
function log_dotfiles_package_installation() {

    local _package_name=$1
    local _status_code=$2

    case $_status_code in

        "already-exist")
            log_message "Failed to install package \"$_package_name\" due to the package already exist." "error" ;;

        "dependency-missing")
            log_message "Failed to install package \"$_package_name\" due to missing dependencies." "error" ;;

        "dependency-skip")
            log_message "Skip package dependency \"$_package_name\" installation." "info" ;;

        "fail")
            log_message "Failed to install or upgrade package \"$_package_name\"." "error" ;;

        "install")
            log_message "Starting installation of package \"$_package_name\"." "info" ;;

        "skip")
            log_message "Package \"$_package_name\" is already installed. Skipping installation." "info" ;;

        "success")
            log_message "Successfully installed or upgraded package \"$_package_name\"." "info" ;;

        "sys-name-not-supported")
            log_message "Package \"$_package_name\" is not supported on system '$DOTFILES_SYS_NAME'. Installation skipped." "warn" ;;

        "sys-archt-not-supported")
            log_message "Package \"$_package_name\" is not supported on architecture '$DOTFILES_SYS_ARCHT'. Installation skipped." "warn" ;;

        "up-to-date")
            log_message "Package \"$_package_name\" is already installed and up to date." "info" ;;

        "upgrade")
            log_message "Package \"$_package_name\" is installed. Checking for upgrades." "info" ;;

        *)
            log_message "log_dotfiles_package_installation: Invalid status code \"$_status_code\"" "error"

            local _usage_message="Usage: log_dotfiles_package_installation <package_name> <status_code>"
            _usage_message+="\n\t<status_code> should be one of: already-exist, dependency-missing, dependency-skip, fail, install, "
            _usage_message+="skip, success, sys-name-not-supported, sys-archt-not-supported, up-to-date, upgrade."
            log_message "$_usage_message" "info" ;;
    esac
}


# ------------------------------------------------------------------------------
#
# Permission
#
# - Dependency
#   - Environment Variables
#     - DOTFILES_SYS_NAME
#
# ------------------------------------------------------------------------------


function get_permission() {

    local perms
    if [[ $DOTFILES_SYS_NAME == "mac" ]]; then
        perms=$(stat -f %Mp%Lp "$1")
    else
        perms=$(stat -c %a "$1")
    fi

    echo "${perms#0}"
}


# ------------------------------------------------------------------------------
#
# System
#
# - Dependency
#   - Environment Variables
#     - DOTFILES_SYS_NAME
#     - DOTFILES_SYS_ARCHT
#
# ------------------------------------------------------------------------------


function is_supported_system_archt() {
    [[ $DOTFILES_SYS_ARCHT == "amd64" || $DOTFILES_SYS_ARCHT == "arm64" ]]
}

function is_supported_system_name() {
    [[ $DOTFILES_SYS_NAME == "mac" || $DOTFILES_SYS_NAME == "linux" ]]
}
