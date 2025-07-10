# ------------------------------------------------------------------------------
#
# hyperfine: a command-line benchmarking tool
#
# - References
#   - https://github.com/sharkdp/hyperfine
#
# ------------------------------------------------------------------------------


function dotfiles_install_hyperfine() {

    local _package_name="hyperfine"
    local _package_id="sharkdp/hyperfine"

    # binary, completions and manual
    if ! { is_dotfiles_package_installed "$_package_name" "zinit-plugin" "$_package_id" }; then

        zinit ice lucid from"gh-r" id-as"$_package_name" as"null" \
              mv"hyperfine* -> hyperfine" \
              atclone'ln -sf $(realpath ./hyperfine/hyperfine) $DOTFILES_LOCAL_BIN_DIR/$_package_name;           # binary
                      ln -sf $(realpath ./hyperfine/autocomplete/_hyperfine) $DOTFILES_ZSH_COMP_DIR/_hyperfine;  # completion
                      ln -sf $(realpath ./hyperfine/hyperfine.1) $DOTFILES_LOCAL_MAN_DIR/man1/hyperfine.1;       # manual' \
              atpull'%atclone'
        install_dotfiles_packages "$_package_name" "zinit-plugin" "$_package_id"

    else
        install_dotfiles_packages --upgrade "$_package_name" "zinit-plugin" "$_package_name"
    fi
}


function dotfiles_init_hyperfine() {

    local _package_name="hyperfine"

    # sanity check
    if ! command_exists "$_package_name"; then
        log_dotfiles_package_initialization "$_package_name" "fail"
        return $RC_ERROR
    fi

    # alias
    alias bm="hyperfine "
    alias bm-zsh='hyperfine "zsh -i -c exit" '
}
