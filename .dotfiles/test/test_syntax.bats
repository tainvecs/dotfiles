#!/usr/bin/env bats
#
# Syntax validation: runs `zsh -n` on all tracked shell files.
#

DOTFILES_ROOT_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"

ZSH_FILES=(
    .dotfiles/config/zsh/.zshrc
    .dotfiles/env/color.env
    .dotfiles/env/dotfiles.env
    .dotfiles/env/package.env
    .dotfiles/env/return_code.env
    .dotfiles/library/util.zsh
    .dotfiles/library/dotfiles/init.zsh
    .dotfiles/library/dotfiles/util.zsh
    .dotfiles/library/package/built_in.zsh
    .dotfiles/library/package/delete.zsh
    .dotfiles/library/package/init.zsh
    .dotfiles/library/package/install.zsh
    .dotfiles/library/package/update.zsh
    .dotfiles/library/zsh/completion.zsh
    .dotfiles/script/delete.zsh
    .dotfiles/script/install.zsh
    .dotfiles/script/update.zsh
)

@test "all tracked shell files pass zsh -n syntax check" {
    local failed=()
    for file in "${ZSH_FILES[@]}"; do
        if ! zsh -n "$DOTFILES_ROOT_DIR/$file" 2>/dev/null; then
            failed+=("$file")
        fi
    done
    if [[ ${#failed[@]} -gt 0 ]]; then
        echo "Syntax errors in: ${failed[*]}" >&2
        return 1
    fi
}
