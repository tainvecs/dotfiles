# ------------------------------------------------------------------------------
# shell
# ------------------------------------------------------------------------------


alias shell-which="echo $SHELL"

shell-change(){
    shell_target=$(which $1)
    $(chsh -s $shell_target)
    clear
    exec $shell_target
}


# ------------------------------------------------------------------------------
# link
# ------------------------------------------------------------------------------


function ln-prune-dry-run(){
    find -L . -maxdepth 1 -type l -print
}

function ln-prune(){
    for f in `find -L . -maxdepth 1 -type l`; do unlink $f; done
}


# ------------------------------------------------------------------------------
# schedule
# ------------------------------------------------------------------------------


alias cron-edit="crontab -e "
alias cron-edit-sudo="sudo crontab -e "


# ------------------------------------------------------------------------------
# alias
# ------------------------------------------------------------------------------


# add space to command so that next word will be checked for alias substitution
alias sudo="sudo "
alias watch="watch -n 2 -c "

# alias for my freq typo
alias celar="clear "

# wget
alias wget="wget --hsts-file "$ZSH_RESOURCES_DIR"/wget-hsts "


# ------------------------------------------------------------------------------
# completion
# ------------------------------------------------------------------------------


# list completion
function comp-ls() {

    # https://stackoverflow.com/questions/40010848/how-to-list-all-zsh-autocompletions
    for command completion in ${(kv)_comps:#-*(-|-,*)}
    do
        printf "%-32s %s\n" $command $completion
    done | sort

}
