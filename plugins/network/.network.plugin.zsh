# ------------------------------------------------------------------------------
# ip
# ------------------------------------------------------------------------------


alias myip="curl ifconfig.me; echo"


# ------------------------------------------------------------------------------
# port
# ------------------------------------------------------------------------------


alias port-ls="sudo lsof -i -P -n"


# ------------------------------------------------------------------------------
# fail2ban
# ------------------------------------------------------------------------------


if type fail2ban-client >/dev/null; then

    if type sqlite3 >/dev/null; then

        function f2b-jails(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'List all jails.'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT name, enabled FROM jails;")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tENABLED"
            echo $res_str
        }

        function f2b-baned(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'List all baned ip.'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT jail, ip FROM bans;")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tIP"
            echo $res_str
        }
    fi

    # sshd
    if type sqlite3 >/dev/null; then

        function f2b-sshd-baned(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'List all sshd baned ip.'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT jail, ip FROM bans WHERE jail='sshd';")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tIP"
            echo $res_str
        }
    fi

    function f2b-sshd-status(){

        if [[ $1 == '-h' || $1 == '--help' ]]; then
            echo 'sshd: status.'
            return 0
        fi

        sudo fail2ban-client status sshd
    }

    function f2b-sshd-reload(){

        if [[ $1 == '-h' || $1 == '--help' ]]; then
            echo 'sshd: reload config.'
            return 0
        fi

        sudo fail2ban-client reload sshd
        sudo fail2ban-client status sshd
    }

    function f2b-sshd-ban-ip(){

        if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
            echo 'sshd: ban an ip.'
            echo '$1: ip'
            return 0
        fi

        sudo fail2ban-client set sshd banip $1
    }

    function f2b-sshd-unban-ip(){

        if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
            echo 'sshd: unban an ip.'
            echo '$1: ip'
            return 0
        fi

        sudo fail2ban-client set sshd unbanip $1
    }
fi


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
    alias ssh-users-haspassword='sudo cat /etc/shadow | grep "^[^:]*:[^\*!]" | cut -d ":" -f 1 | sort'

fi
