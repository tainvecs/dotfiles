#!/usr/bin/env bats
#
# Unit tests for .dotfiles/library/util.zsh
#

DOTFILES_ROOT_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
HELPER="$DOTFILES_ROOT_DIR/.dotfiles/test/helpers/setup.zsh"

# Helper: run a zsh snippet with the test environment loaded
run_zsh() {
    run zsh -c "DOTFILES_ROOT_DIR='$DOTFILES_ROOT_DIR'; source '$HELPER'; $1"
}

# ==============================================================================
# join_by
# ==============================================================================

@test "join_by: comma-separated" {
    run_zsh 'echo "$(join_by "," "a" "b" "c")"'
    [[ "$output" == "a,b,c" ]]
}

@test "join_by: single element" {
    run_zsh 'echo "$(join_by "," "a")"'
    [[ "$output" == "a" ]]
}

@test "join_by: uses first char of multi-char delimiter" {
    run_zsh 'echo "$(join_by " | " "x" "y")"'
    # IFS-based join uses only the first character of the delimiter
    [[ "$output" == "x y" ]]
}

# ==============================================================================
# get_system_name / get_system_architecture
# ==============================================================================

@test "get_system_name: returns mac or linux" {
    run_zsh 'get_system_name'
    [[ "$output" == "mac" || "$output" == "linux" ]]
}

@test "get_system_architecture: returns known architecture" {
    run_zsh 'get_system_architecture'
    [[ "$output" == "amd64" || "$output" == "arm64" || "$output" == "arm" ]]
}

# ==============================================================================
# command_exists
# ==============================================================================

@test "command_exists: zsh exists" {
    run_zsh 'command_exists zsh'
    [[ "$status" -eq 0 ]]
}

@test "command_exists: nonexistent command" {
    run_zsh 'command_exists __nonexistent_cmd_xyz_12345__'
    [[ "$status" -ne 0 ]]
}

@test "command_exists: empty arg returns RC_ERROR" {
    run_zsh 'command_exists ""'
    [[ "$status" -eq 1 ]]
}

# ==============================================================================
# log_message
# ==============================================================================

@test "log_message: info goes to stdout" {
    run_zsh 'log_message "hello" "info" 2>/dev/null'
    [[ "$output" == *"Info:"* ]] || [[ "$output" == *"hello"* ]]
}

@test "log_message: error goes to stderr" {
    run zsh -c "DOTFILES_ROOT_DIR='$DOTFILES_ROOT_DIR'; source '$HELPER'; log_message 'oops' 'error' 2>&1 1>/dev/null"
    [[ "$output" == *"Error:"* ]] || [[ "$output" == *"oops"* ]]
}

@test "log_message: warn goes to stderr" {
    run zsh -c "DOTFILES_ROOT_DIR='$DOTFILES_ROOT_DIR'; source '$HELPER'; log_message 'careful' 'warn' 2>&1 1>/dev/null"
    [[ "$output" == *"Warn:"* ]] || [[ "$output" == *"careful"* ]]
}

# ==============================================================================
# ensure_directory
# ==============================================================================

@test "ensure_directory: creates new directory" {
    run_zsh "ensure_directory '$BATS_TEST_TMPDIR/newdir'; [[ -d '$BATS_TEST_TMPDIR/newdir' ]]"
    [[ "$status" -eq 0 ]]
}

@test "ensure_directory: no-op for existing directory" {
    mkdir -p "$BATS_TEST_TMPDIR/existdir"
    run_zsh "ensure_directory '$BATS_TEST_TMPDIR/existdir'; [[ -d '$BATS_TEST_TMPDIR/existdir' ]]"
    [[ "$status" -eq 0 ]]
}

# ==============================================================================
# create_validated_symlink
# ==============================================================================

@test "create_validated_symlink: creates symlink" {
    echo "test" > "$BATS_TEST_TMPDIR/source_file"
    run_zsh "create_validated_symlink '$BATS_TEST_TMPDIR/source_file' '$BATS_TEST_TMPDIR/link_file'"
    [[ "$status" -eq 0 ]]
    [[ -L "$BATS_TEST_TMPDIR/link_file" ]]
}

@test "create_validated_symlink: missing source returns RC_SKIPPED" {
    run_zsh "create_validated_symlink '$BATS_TEST_TMPDIR/no_such_file' '$BATS_TEST_TMPDIR/link_file'; echo \$?"
    [[ "$output" == "77" ]]
}

# ==============================================================================
# is_associative_array / is_normal_array / is_non_empty_array
# ==============================================================================

@test "is_associative_array: true for associative array" {
    run_zsh 'typeset -A mymap; mymap[k]=v; is_associative_array mymap'
    [[ "$status" -eq 0 ]]
}

@test "is_associative_array: false for normal array" {
    run_zsh 'typeset -a myarr; myarr=(a b); is_associative_array myarr'
    [[ "$status" -ne 0 ]]
}

@test "is_normal_array: true for normal array" {
    run_zsh 'typeset -a myarr; myarr=(a b); is_normal_array myarr'
    [[ "$status" -eq 0 ]]
}

@test "is_normal_array: false for associative array" {
    run_zsh 'typeset -A mymap; mymap[k]=v; is_normal_array mymap'
    [[ "$status" -ne 0 ]]
}

@test "is_non_empty_array: true for populated array" {
    run_zsh 'typeset -a myarr; myarr=(a b c); is_non_empty_array myarr'
    [[ "$status" -eq 0 ]]
}

@test "is_non_empty_array: false for empty array" {
    run_zsh 'typeset -a myarr; myarr=(); is_non_empty_array myarr'
    [[ "$status" -ne 0 ]]
}

# ==============================================================================
# update_associative_array_from_array
# ==============================================================================

@test "update_associative_array_from_array: populates from array" {
    run_zsh '
        typeset -A out; typeset -a src; src=(foo bar);
        update_associative_array_from_array out src "";
        [[ "${out[foo]}" == "true" && "${out[bar]}" == "true" ]]
    '
    [[ "$status" -eq 0 ]]
}

@test "update_associative_array_from_array: fails when output is not assoc array" {
    run_zsh '
        typeset -a out; typeset -a src; src=(foo);
        update_associative_array_from_array out src "" 2>/dev/null
    '
    [[ "$status" -ne 0 ]]
}

# ==============================================================================
# append_dir_to_path / prepend_dir_to_path
# ==============================================================================

@test "append_dir_to_path: appends directory" {
    run_zsh "
        MY_PATH='/usr/bin';
        append_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        echo \$MY_PATH
    "
    [[ "$output" == "/usr/bin:$BATS_TEST_TMPDIR" ]]
}

@test "append_dir_to_path: skips nonexistent directory" {
    run_zsh 'MY_PATH="/usr/bin"; append_dir_to_path MY_PATH "/no/such/dir" 2>/dev/null; echo $?'
    [[ "$output" == "77" ]]
}

@test "append_dir_to_path: idempotent" {
    run_zsh "
        MY_PATH='/usr/bin';
        append_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        append_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        echo \$MY_PATH
    "
    [[ "$output" == "/usr/bin:$BATS_TEST_TMPDIR" ]]
}

@test "prepend_dir_to_path: prepends directory" {
    run_zsh "
        MY_PATH='/usr/bin';
        prepend_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        echo \$MY_PATH
    "
    [[ "$output" == "$BATS_TEST_TMPDIR:/usr/bin" ]]
}

@test "prepend_dir_to_path: idempotent" {
    run_zsh "
        MY_PATH='/usr/bin';
        prepend_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        prepend_dir_to_path MY_PATH '$BATS_TEST_TMPDIR';
        echo \$MY_PATH
    "
    [[ "$output" == "$BATS_TEST_TMPDIR:/usr/bin" ]]
}
