if type docker >/dev/null; then

    function docker-login-gitlab(){
        docker login "registry.gitlab.com" -u $1 --password-stdin
    }

fi
