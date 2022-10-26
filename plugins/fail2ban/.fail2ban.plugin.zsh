if type fail2ban-client >/dev/null; then

    if type sqlite3 >/dev/null; then

        function f2b-jails-ls(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'List all jails.'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT name, enabled FROM jails;")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tENABLED"
            echo $res_str
        }

        function f2b-baned-ls(){

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

        function f2b-sshd-baned-ls(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'List all sshd baned ip.'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT jail, ip FROM bans WHERE jail='sshd';")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tIP"
            echo $res_str
        }

        function f2b-sshd-baned-find(){

            if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
                echo 'Find an ip $1 in sshd jail.'
                echo '$1: ip'
                return 0
            fi

            raw_res_str=$(sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT jail, ip FROM bans WHERE jail='sshd' and ip='$1';")
            res_str=$(echo $raw_res_str | sed 's/|/\t/g')

            echo "JAIL\tIP"
            echo $res_str
        }

        function f2b-sshd-baned-count(){

            if [[ $1 == '-h' || $1 == '--help' ]]; then
                echo 'Count banned ip in sshd jail.'
                return 0
            fi

            sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT COUNT(*) FROM bans WHERE jail='sshd';"
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

    function f2b-sshd-ban(){

        if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
            echo 'sshd: ban an ip $1.'
            echo '$1: ip'
            return 0
        fi

        sudo fail2ban-client set sshd banip $1
    }

    function f2b-sshd-unban(){

        if [[ $1 == '-h' || $1 == '--help' || $1 == '' ]]; then
            echo 'sshd: unban an ip $1.'
            echo '$1: ip'
            return 0
        fi

        sudo fail2ban-client set sshd unbanip $1
    }
fi
