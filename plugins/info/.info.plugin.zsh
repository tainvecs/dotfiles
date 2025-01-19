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

    # list apt source
    function ls-apt-source() {

        # list and filter source list
        local _raw_source_str=$(grep -r --include '*.list' '^deb ' '/etc/apt/')

        # string processing
        local _source_str=$(sed -re 's/\/etc\/apt\/(sources\.list(:| ))/\1/' \
                                -e 's/^\/etc\/apt\/sources\.list\.d\///' \
                                -e 's/[:]?(deb(-src)?) /@ \1@ /' \
                                -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/' \
                                -e 's/ (https?:[^ ]+) /@ \1@ /' \
                                -e 's/\s+//g' \
                                <<< $_raw_source_str)

        # split with '@' and print line with indent
        while IFS='@' read -r _src _type  _opt  _uri _; do
            echo "Source File: ${_src:=-}"
            echo "Type:        ${_type:=-}"
            echo "URI:         ${_uri:=-}"
            echo "Options:     ${_opt:=-}"
            echo "\n"

        done <<< $(LC_ALL=C sort <<< $_source_str)
    }

    # apt gpg key
    function ls-apt-key() {
        apt-key list 2> >(grep -v 'Warning:' >&2)
    }

    # apt installed packaged by manual and auto
    function ls-apt-package() {

        # print header
        printf '%-43.43s %-40.40s %-12.12s %-80.80s\n' "NAME" "VERSION" "ARCHITECTURE" "SUMMARY"
        printf '=%.0s' {1..43}
        printf ' '
        printf '=%.0s' {1..40}
        printf ' '
        printf '=%.0s' {1..12}
        printf ' '
        printf '=%.0s' {1..80}
        printf '\n'

        # process amd sort package strings
        local _pkg_lines=$(dpkg-query -W -f '${Package}, ${Version}, ${Architecture}, ${binary:Summary}\n' | LC_ALL=C sort)

        # split with ', ' and print line with indent
        while IFS=', ' read -r _name _ver _archt _summary; do
            printf '%-43.43s %-40.40s %-12.12s %-80.80s\n' $_name $_ver $_archt $_summary
        done <<< $_pkg_lines
    }

fi

# ----- completion

function ls-completion() {
    # print header
    printf '%-60.60s %s\n' "COMMAND" "COMPLETION"
    printf '=%.0s' {1..60}
    printf ' '
    printf '=%.0s' {1..60}
    printf '\n'

    # list and pretty completion
    for _command _completion in ${(kv)_comps:#-*(-|-,*)}; do
        printf "%-60.60s %s\n" $_command $_completion
    done | LC_ALL=C sort
}


# ----- link

# symbolic link
# - $1: max depth to search
function ls-link() {

    # check argument
    if [[ -z $1 ]]; then
        echo 'error: missing argument'
        echo '- $1: max depth to search'
        return 1
    fi

    # main
    find . -maxdepth $1 -type l
}

# broken symbolic links
# - $1: max depth to search
function ls-link-broken() {

    # check argument
    if [[ -z $1 ]]; then
        echo 'error: missing argument'
        echo '- $1: max depth to search'
        return 1
    fi

    # main
    find . -maxdepth $1 -xtype l
}


# ----- pip

if type pip >/dev/null; then

    function ls-pip-freeze() {

        # print header
        printf '%-30.30s %s\n' "PACKAGE" "VERSION"
        printf '=%.0s' {1..30}
        printf ' '
        printf '=%.0s' {1..30}
        printf '\n'

        # process strings from pip freeze
        local _pip_lines=$(pip freeze | sed -E 's/( )*(==|@)( )*/==/g' | sort)

        # print line with indent
        while IFS= read -r _line; do

            # split with ==
            local _name=${_line%==*}
            local _ver=${_line#*==}

            # print
            printf '%-30.30s %s\n' $_name $_ver

        done <<< $_pip_lines
    }
fi


# ----- docker

if type docker >/dev/null; then

    # ---- docker login
    if type jq >/dev/null; then

        # login mapping
        declare -A _login_mapping=(
            [ghcr.io]='GitHub'
            [index.docker.io]='Docker Hub'
            [nvcr.io]='Nvidia'
            [registry.gitlab.com]='GitLab'
        )

        # main
        function ls-docker-login(){

            # docker config file
            local _docker_config_path
            if [[ -d $DOCKER_CONFIG ]] && [[ -f "$DOCKER_CONFIG/config.json" ]]; then
                _docker_config_path="$DOCKER_CONFIG/config.json"
            else
                _docker_config_path="$HOME/.docker/config.json"
            fi

            # check config file
            if [[ ! -f $_docker_config_path ]]; then
                echo "error: docker config not found at '$_docker_config_path'"
                return 1
            fi

            # parse config json
            local _docker_login_auths=$(cat $_docker_config_path | jq '.auths')
            if [[ $_docker_login_auths = 'null' ]]; then
                echo "info: no docker login found."
                return 0
            fi
            local _docker_login_uri_lines=$(echo $_docker_login_auths | jq 'keys | .[]')

            # check if login array is empty
            if [[ ${#_docker_login_uri_lines[@]} == 0 ]]; then
                echo "info: no docker login found."
                return 0
            fi

            # process by line
            declare -a _array
            while IFS=',' read -r _line; do

                # process url
                local _url_line=$(sed -re 's#\"(https?://)?([^/]+)#\2#' \
                                      -e 's/\"$//' \
                                      <<< $_line)

                # match login mapping
                local _registry='-'
                for _key _val in ${(@kv)_login_mapping}; do
                    [[ $_url_line = "$_key"* ]] && _registry=$_val && break
                done

                # result
                _processed_line=$(printf '%-15.15s %s\n' $_registry $_url_line)
                _array+=($_processed_line)

            done <<< $_docker_login_uri_lines

            # sort
            IFS=$'\n' _sorted_lines=($(sort -n <<<"${_array[*]}"))
            unset IFS

            # output header and sorted line
            printf '%-15.15s %s\n' "REGISTRY" "URL"
            printf '=%.0s' {1..15}
            printf ' '
            printf '=%.0s' {1..30}
            printf '\n'

            for _line in ${_sorted_lines[@]}; do
                echo $_line
            done
        }
    fi
fi
