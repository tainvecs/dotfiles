if type docker >/dev/null; then

    docker-login-gitlab(){
        docker login "registry.gitlab.com" -u $1 --password-stdin
    }

fi
