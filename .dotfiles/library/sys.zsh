#!/bin/zsh


# ------------------------------------------------------------------------------
#
# System
#
#
# Version: 0.0.1
# Last Modified: 2025-03-31
#
# - Dependency
#
# ------------------------------------------------------------------------------


function get_system_name() {

    local os_name=$(uname)

    case $os_name in

        "Linux")
            echo "linux" ;;

        "Darwin")
            echo "mac" ;;

        *)
            echo "unknown($os_name)" ;;
    esac
}


function get_system_architecture() {

    local archt=$(uname -m)

    case $archt in

        "x86_64")
            echo "amd64" ;;

        "arm64" | "aarch64")
            echo "arm64" ;;

        arm*)
            echo "arm" ;;

        *)
            echo "unknown($archt)" ;;
    esac
}
