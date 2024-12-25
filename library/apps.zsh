#!/bin/zsh


# $1: package name
# $2: function code ("start", "skip")
function echo_app_installation_message() {

    case $2 in

        "start")
            echo "start \"$1\" installation";;

        "skip")
            echo "skip \"$1\" as it is already installed";;

        *)
            echo 'print app installation message'
            echo '  $1: package name'
            echo '  $2: function code ("start", "skip")';;

    esac
}


# $@: package names
function sudo_apt_install() {

    for in_pkg in "$@"; do

        # skip the installation if the package is already installed
        if ! { type $in_pkg >"/dev/null" } && \
           ! { dpkg -L $in_pkg &>"/dev/null" } ; then
            sudo apt-get install --no-install-recommends --no-install-suggests -y $in_pkg
        else
            echo_app_installation_message $in_pkg 'skip'
        fi
    done
}


# $1: user name
# $2: project name
function get_github_release_latest_version() {
    curl -s "https://api.github.com/repos/$1/$2/releases" | \
        bat -l html | grep tag_name | head -n 1 | cut -d '"' -f 4
}
