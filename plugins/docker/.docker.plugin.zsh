#!/bin/zsh

# Check if Docker is installed
if ! command -v docker >/dev/null; then
    echo "Error: Docker is not installed or not in PATH." >&2
    return 1
fi

# docker containers
alias dps='docker ps '
alias dpsa='docker ps -a '

alias dcls='docker container ls '
alias dcin='docker container inspect '
alias dcl='docker container logs '
alias dcp='docker container port '

alias dcs='docker container start '
alias dcrs='docker container restart '
alias dcst='docker container stop '
alias dcsta='docker container stop $(docker ps -q) '
alias dcr='docker container run '
alias dcex='docker container exec '

alias dcrm='docker container rm '

# docker build
alias dils='docker image ls '
alias diin='docker image inspect '

alias dib='docker image build '
alias dit='docker image tag '
alias dipu='docker image pull '
alias dip='docker image push '

alias dipr='docker image prune '
alias dirm='docker image rm '

# docker network
alias dnls='docker network ls '
alias dni='docker network inspect '

alias dnc='docker network create '
alias dnrm='docker network rm '

# docker volume
alias dvls='docker volume ls '
alias dvi='docker volume inspect '

alias dvc='docker volume create '
alias dvrm='docker volume rm '
alias dvpr='docker volume prune '

# Docker system
alias dsp='docker system prune '
alias dsdf='docker system df '
alias dsi='docker system info '

# Docker compose
if command -v docker-compose >/dev/null; then
    alias dcps='docker-compose ps '
    alias dcl='docker-compose logs '
    alias dcu='docker-compose up '
    alias dcd='docker-compose down '
fi
