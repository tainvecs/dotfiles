#!/bin/zsh


_sys_name=$(uname)


# ------------------------------------------------------------------------------
#
# list
#
# - reference
#
#   - apt
#     - https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an#comment2564796_148968
#     - https://manpages.ubuntu.com/manpages/jammy/man5/sources.list.5.html#examples
#     - https://man7.org/linux/man-pages/man1/dpkg-query.1.html
#
#   - completion
#     - https://stackoverflow.com/questions/40010848/how-to-list-all-zsh-autocompletions
#
#   - links
#     - https://unix.stackexchange.com/questions/34248/how-can-i-find-broken-symlinks
#
#   - string processing
#     - https://stackoverflow.com/questions/10520623/how-to-split-one-string-into-multiple-variables-in-bash-shell
#     - https://unix.stackexchange.com/questions/396223/bash-shell-script-output-alignment
#     - https://superuser.com/questions/284187/how-to-iterate-over-lines-in-a-variable-in-bash
#     - https://unix.stackexchange.com/questions/35469/why-does-ls-sorting-ignore-non-alphanumeric-characters
#     - https://askubuntu.com/questions/595269/use-sed-on-a-string-variable-rather-than-a-file
#     - https://askubuntu.com/questions/678915/whats-the-difference-between-and-in-bash
#     - https://stackoverflow.com/questions/3618078/pipe-only-stderr-through-a-filter
#
# ------------------------------------------------------------------------------


# ----- apt

if [[ $_sys_name = "Linux" ]]; then

    # List apt sources
    function ls-apt-source() {

        local _raw_source_str _source_str _src _type _opt _uri

        # List and filter APT source files
        _raw_source_str=$(grep -r --include '*.list' '^deb ' '/etc/apt/' 2>/dev/null) || return

        # Process the string with sed for formatting
        _source_str=$(sed -re 's/\/etc\/apt\/(sources\.list(:| ))/\1/' \
                          -e 's/^\/etc\/apt\/sources\.list\.d\///' \
                          -e 's/[:]?(deb(-src)?) /@ \1@ /' \
                          -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/' \
                          -e 's/ (https?:[^ ]+) /@ \1@ /' \
                          -e 's/\s+//g' \
                          <<< $_raw_source_str)

        # Split and format output
        while IFS='@' read -r _src _type _opt _uri _; do
            printf "Source File: %s\n" "${_src:--}"
            printf "Type:        %s\n" "${_type:--}"
            printf "URI:         %s\n" "${_uri:--}"
            printf "Options:     %s\n\n" "${_opt:--}"
        done <<< $(LC_ALL=C sort <<< "$_source_str")
    }

    # apt gpg key
    # function ls-apt-key() {
    #     apt-key list 2> >(grep -v 'Warning:' >&2)
    # }

    function ls-apt-key() {
        gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --list-keys
        gpg --no-default-keyring --keyring /etc/apt/trusted.gpg.d/*.gpg --list-keys
    }

    # apt installed packaged by manual and auto
    # function ls-apt-package() {

    #     # print header
    #     printf '%-43.43s %-40.40s %-12.12s %-80.80s\n' "NAME" "VERSION" "ARCHITECTURE" "SUMMARY"
    #     printf '=%.0s' {1..43}
    #     printf ' '
    #     printf '=%.0s' {1..40}
    #     printf ' '
    #     printf '=%.0s' {1..12}
    #     printf ' '
    #     printf '=%.0s' {1..80}
    #     printf '\n'

    #     # process amd sort package strings
    #     local _pkg_lines=$(dpkg-query -W -f '${Package}, ${Version}, ${Architecture}, ${binary:Summary}\n' | LC_ALL=C sort)

    #     # split with ', ' and print line with indent
    #     while IFS=', ' read -r _name _ver _archt _summary; do
    #         printf '%-43.43s %-40.40s %-12.12s %-80.80s\n' $_name $_ver $_archt $_summary
    #     done <<< $_pkg_lines
    # }

    function ls-apt-package() {

        # Print header
        printf '%-43.43s %-40.40s %-12.12s %-80.80s\n' "NAME" "VERSION" "ARCHITECTURE" "SUMMARY"
        printf '=%.0s' {1..43}
        printf ' '
        printf '=%.0s' {1..40}
        printf ' '
        printf '=%.0s' {1..12}
        printf ' '
        printf '=%.0s' {1..80}
        printf '\n'

        # Process package information directly from dpkg-query
        dpkg-query -W -f '${Package}###${Version}###${Architecture}###${binary:Summary}\n' | LC_ALL=C sort | \
            while IFS='###' read -r _name _ver _archt _summary; do
                printf '%-43s %-40s %-12s %-80s\n' "$_name" "$_ver" "$_archt" "$_summary"
            done
    }

fi


# ----- completion

function ls-completion() {

    local _command _completion

    # Print header
    printf '%-60s %s\n' "COMMAND" "COMPLETION"
    printf '%s\n' "$(printf '=%.0s' {1..60}) $(printf '=%.0s' {1..60})"

    # List and format completions
    for _command _completion in ${(kv)_comps:#-*(-|-,*)}; do
        printf "%-60s %s\n" "$_command" "$_completion"
    done | LC_ALL=C sort
}


# ----- docker

if type docker >/dev/null; then

    # ---- docker login
    if type jq >/dev/null; then

        # login mapping
        local -A _login_mapping=(
            [ghcr.io]='GitHub'
            [index.docker.io]='Docker Hub'
            [nvcr.io]='Nvidia'
            [registry.gitlab.com]='GitLab'
        )

        # main
        function ls-docker-login() {

            # docker config file
            local _docker_config_path
            if [[ -d $DOCKER_CONFIG && -f "$DOCKER_CONFIG/config.json" ]]; then
                _docker_config_path="$DOCKER_CONFIG/config.json"
            else
                _docker_config_path="$HOME/.docker/config.json"
            fi

            # check config file
            if [[ ! -f "$_docker_config_path" ]]; then
                echo "error: docker config not found at '$_docker_config_path'"
                return 1
            fi

            # parse config json
            local _docker_login_auths
            _docker_login_auths=$(jq -r '.auths' "$_docker_config_path")
            if [[ "$_docker_login_auths" == "null" ]]; then
                echo "info: no docker login found."
                return 0
            fi

            local -a _docker_login_uri_lines
            _docker_login_uri_lines=("${(@f)$(echo $_docker_login_auths | jq 'keys | .[]')}")

            # check if login array is empty
            if [[ ${#_docker_login_uri_lines[@]} -eq 0 ]]; then
                echo "info: no docker login found."
                return 0
            fi

            # process by line
            local -a _array
            for _line in "${_docker_login_uri_lines[@]}"; do

                # process URL (strip protocol and trailing quotes)
                local _url_line=$(sed -re 's#\"?(https?://)?([^/]+)#\2#' \
                                      -e 's/\"$//' \
                                      <<< $_line)

                # match login mapping
                local _registry="-"
                for _key _val in "${(@kv)_login_mapping}"; do
                    [[ "$_url_line" == "$_key"* ]] && _registry="$_val" && break
                done

                # result
                local _processed_line=$(printf '%-15.15s %s\n' "$_registry" "$_url_line")
                _array+=("$_processed_line")
            done

            # sort
            local -a _sorted_lines
            IFS=$'\n' _sorted_lines=($(sort <<< "${_array[*]}"))
            unset IFS

            # output header and sorted lines
            printf '%-15.15s %s\n' "REGISTRY" "URL"
            printf '=%.0s' {1..15}
            printf ' '
            printf '=%.0s' {1..30}
            printf '\n'

            for _line in "${_sorted_lines[@]}"; do
                echo "$_line"
            done
        }

    fi
fi


# ----- link

# Helper function to find symbolic links
# - $1: max depth to search (must be a positive number)
# - $2: directory to search (optional, defaults to ".")
function _find_symlinks() {
    local _max_depth _dir _type

    # Validate max depth argument
    if [[ -z "$1" || ! "$1" =~ ^[0-9]+$ || "$1" -le 0 ]]; then
        echo "error: invalid or missing argument: '$1'"
        echo "Usage: $2 <max-depth> [directory]"
        return 1
    fi
    _max_depth="$1"

    # Set directory to search (default: current directory)
    _dir="${2:-.}"

    # Validate directory existence
    if [[ ! -d "$_dir" ]]; then
        echo "error: '$_dir' is not a valid directory"
        return 1
    fi

    # Ensure `find` command exists
    if ! command -v find &>/dev/null; then
        echo "error: 'find' command not found"
        return 1
    fi

    # Select find type (all symlinks or broken ones)
    _filter_str="${3:--type l}"  # Default: find all symlinks
    _filter_arr=(${=_filter_str})

    # Find symbolic links and sort results
    find "$_dir" -maxdepth "$_max_depth" "${_filter_arr[@]}" | sort
}

# List symbolic links
# - $1: max depth to search (must be a positive number)
# - $2: directory to search (optional, defaults to ".")
function ls-link() {
    _find_symlinks "$1" "$2" "-type l"
}

# List broken symbolic links
# - $1: max depth to search (must be a positive number)
# - $2: directory to search (optional, defaults to ".")
function ls-link-broken() {
    _find_symlinks "$1" "$2" "-type l ! -exec test -e {} ; -print"
}


# ----- path

function ls-fpath() {
    print -l "${(@)fpath}" | sort
}

function ls-path() {
    print -l "${(@)path}" | sort
}


# ----- pip

if type pip >/dev/null; then

    alias ls-pip-app="pip list"

    function ls-pip-freeze() {

        # print header
        printf '%-30.30s %s\n' "PACKAGE" "VERSION"
        printf '=%.0s' {1..30}
        printf ' '
        printf '=%.0s' {1..30}
        printf '\n'

        # Read pip freeze output into an array
        local -a _pip_lines
        _pip_lines=("${(@f)$(pip freeze | sed -E 's/( )*(==|@)( )*/==/g' | sort)}")

        # Process each line
        for _line in "${_pip_lines[@]}"; do
            # split with ==
            local _name=${_line%==*}
            local _ver=${_line#*==}

            # print
            printf '%-30.30s %s\n' "$_name" "$_ver"
        done
    }

fi
