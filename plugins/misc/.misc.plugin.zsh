# ------------------------------------------------------------------------------
# shell
# ------------------------------------------------------------------------------


alias shell-which="echo $SHELL"

function shell-change(){
    shell_target=$(which $1)
    $(chsh -s $shell_target)
    clear
    exec $shell_target
}


# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------


function path-ls(){
    echo -e ${PATH//:/\\n}
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
# cron
# ------------------------------------------------------------------------------


alias cron-edit="crontab -e "
alias cron-edit-sudo="sudo crontab -e "


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

# ------------------------------------------------------------------------------
# timestamp
# ------------------------------------------------------------------------------


alias timestamp-gen='date +%s '
alias timestamp-decode='strftime "%c UTC%z" $1 '
alias timestamp-decode-utc='TZ="UTC" strftime "%c UTC%z" $1 '


# ------------------------------------------------------------------------------
# uuid
# ------------------------------------------------------------------------------


if type uuidgen >/dev/null; then

    alias uuid-gen="uuidgen "

fi


# ------------------------------------------------------------------------------
# checksums
# ------------------------------------------------------------------------------


if type sha256sum >/dev/null; then

    alias sha="sha256sum "

elif type shasum >/dev/null; then

    alias sha="shasum -a 256 "

fi


# ------------------------------------------------------------------------------
# random number
# ------------------------------------------------------------------------------


if type shuf >/dev/null; then

    function rand(){
        shuf -i ${1:-0-99} -n ${2:-1}
    }

fi


# ------------------------------------------------------------------------------
# cd
# ------------------------------------------------------------------------------


# easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"


# ------------------------------------------------------------------------------
# misc alias
# ------------------------------------------------------------------------------


# add space to command so that next word will be checked for alias substitution
alias sudo="sudo "
alias watch="watch -n 2 -c "

# alias for my freq typo
alias celar="clear "
