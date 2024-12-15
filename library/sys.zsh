#!/bin/zsh


function get_system_name() {

    os_name=$(uname)

    case $os_name in

        "Linux")
            echo "linux";;

        "Darwin" | "aarch64")
            echo "mac";;

        *)
            echo "unknown($os_name)";;
    esac
}

function get_system_architecture() {

    archt=$(uname -m)

    case $archt in

        "x86_64")
            echo "amd64";;

        "arm64" | "aarch64")
            echo "arm64";;

        arm*)
            echo "arm";;

        *)
            echo "unknown($archt)";;
    esac
}
