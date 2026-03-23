#!/usr/bin/env bats
#
# Unit tests for .dotfiles/library/dotfiles/util.zsh
#

DOTFILES_ROOT_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
HELPER="$DOTFILES_ROOT_DIR/.dotfiles/test/helpers/setup.zsh"
DOTFILES_UTIL="$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh"

# Helper: run a zsh snippet with both util.zsh and dotfiles/util.zsh loaded
run_zsh() {
    run zsh -c "
        DOTFILES_ROOT_DIR='$DOTFILES_ROOT_DIR'
        source '$HELPER'
        source '$DOTFILES_UTIL'
        $1
    "
}

# ==============================================================================
# is_supported_system_name
# ==============================================================================

@test "is_supported_system_name: mac is supported" {
    run zsh -c "DOTFILES_SYS_NAME=mac; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_name"
    [[ "$status" -eq 0 ]]
}

@test "is_supported_system_name: linux is supported" {
    run zsh -c "DOTFILES_SYS_NAME=linux; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_name"
    [[ "$status" -eq 0 ]]
}

@test "is_supported_system_name: windows is not supported" {
    run zsh -c "DOTFILES_SYS_NAME=windows; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_name"
    [[ "$status" -ne 0 ]]
}

# ==============================================================================
# is_supported_system_archt
# ==============================================================================

@test "is_supported_system_archt: arm64 is supported" {
    run zsh -c "DOTFILES_SYS_ARCHT=arm64; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_archt"
    [[ "$status" -eq 0 ]]
}

@test "is_supported_system_archt: amd64 is supported" {
    run zsh -c "DOTFILES_SYS_ARCHT=amd64; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_archt"
    [[ "$status" -eq 0 ]]
}

@test "is_supported_system_archt: unknown is not supported" {
    run zsh -c "DOTFILES_SYS_ARCHT=unknown; source '$DOTFILES_ROOT_DIR/.dotfiles/library/dotfiles/util.zsh'; is_supported_system_archt"
    [[ "$status" -ne 0 ]]
}

# ==============================================================================
# is_dotfiles_managed_package
# ==============================================================================

@test "is_dotfiles_managed_package: found in array" {
    run_zsh '
        typeset -gA DOTFILES_PACKAGE_ASC_ARR
        DOTFILES_PACKAGE_ASC_ARR[git]=true
        is_dotfiles_managed_package git
    '
    [[ "$status" -eq 0 ]]
}

@test "is_dotfiles_managed_package: not found in array" {
    run_zsh '
        typeset -gA DOTFILES_PACKAGE_ASC_ARR
        DOTFILES_PACKAGE_ASC_ARR[git]=true
        is_dotfiles_managed_package nonexistent 2>/dev/null
    '
    [[ "$status" -eq 13 ]]
}

@test "is_dotfiles_managed_package: empty arg returns RC_INVALID_ARGS" {
    run_zsh 'is_dotfiles_managed_package "" 2>/dev/null'
    [[ "$status" -eq 3 ]]
}

# ==============================================================================
# get_permission
# ==============================================================================

@test "get_permission: returns numeric permission string" {
    run_zsh "
        DOTFILES_SYS_NAME=\$(get_system_name)
        get_permission '$DOTFILES_ROOT_DIR/.dotfiles/test/helpers/setup.zsh'
    "
    [[ "$output" =~ ^[0-9]+$ ]]
}
