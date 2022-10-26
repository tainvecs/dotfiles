# ------------------------------------------------------------------------------
# ip
# ------------------------------------------------------------------------------


alias myip="curl ifconfig.me; echo"


# ------------------------------------------------------------------------------
# port
# ------------------------------------------------------------------------------


alias port-ls="sudo lsof -i -P -n"


# ------------------------------------------------------------------------------
# pppoeconf
# ------------------------------------------------------------------------------


# pppoeconf switch
if type pppoeconf >/dev/null; then
    alias pppoe-on='sudo pon dsl-provider'
    alias pppoe-off='sudo poff -a'
fi


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


if type ssh >/dev/null; then

    # check connecting host
    # https://www.baeldung.com/linux/list-connected-ssh-sessions
    alias ssh-connecting="last | grep 'still logged in'"

    # has ssh access through passwords
    # https://askubuntu.com/questions/984912/how-to-get-the-list-of-all-users-who-can-access-a-server-via-ssh
    if [[ -f /etc/shadow ]]; then
        alias ssh-users-haspassword='sudo cat /etc/shadow | grep "^[^:]*:[^\*!]" | cut -d ":" -f 1 | sort'
    fi

fi
