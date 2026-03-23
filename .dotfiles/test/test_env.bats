#!/usr/bin/env bats
#
# Tests that env files define expected variables with correct values.
#

DOTFILES_ROOT_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
DOTFILES_DOT_ENV_DIR="$DOTFILES_ROOT_DIR/.dotfiles/env"

# -- return_code.env -----------------------------------------------------------

@test "return_code.env defines RC_SUCCESS as 0" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/return_code.env'; echo \$RC_SUCCESS"
    [[ "$output" == "0" ]]
}

@test "return_code.env defines RC_ERROR as 1" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/return_code.env'; echo \$RC_ERROR"
    [[ "$output" == "1" ]]
}

@test "return_code.env defines RC_SKIPPED as 77" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/return_code.env'; echo \$RC_SKIPPED"
    [[ "$output" == "77" ]]
}

@test "return_code.env defines RC_INVALID_ARGS as 3" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/return_code.env'; echo \$RC_INVALID_ARGS"
    [[ "$output" == "3" ]]
}

@test "return_code.env defines RC_UNSUPPORTED as 13" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/return_code.env'; echo \$RC_UNSUPPORTED"
    [[ "$output" == "13" ]]
}

# -- color.env -----------------------------------------------------------------

@test "color.env defines COLOR_OFF" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/color.env'; [[ -n \$COLOR_OFF ]]"
    [[ "$status" -eq 0 ]]
}

@test "color.env defines B_RED" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/color.env'; [[ -n \$B_RED ]]"
    [[ "$status" -eq 0 ]]
}

@test "color.env defines B_GREEN" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/color.env'; [[ -n \$B_GREEN ]]"
    [[ "$status" -eq 0 ]]
}

# -- package.env ---------------------------------------------------------------

@test "package.env defines DOTFILES_PACKAGE_ARR as an array" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/package.env'; [[ \${(t)DOTFILES_PACKAGE_ARR} == array* ]]"
    [[ "$status" -eq 0 ]]
}

@test "package.env DOTFILES_PACKAGE_ARR is non-empty" {
    run zsh -c "source '$DOTFILES_DOT_ENV_DIR/package.env'; echo \${#DOTFILES_PACKAGE_ARR[@]}"
    [[ "$output" -gt 0 ]]
}
