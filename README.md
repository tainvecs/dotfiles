# dotfiles

Setting up the terminal on a computer, including all the configuration, app, and
plugin installation, takes a lot of work and effort.
Moreover, especially when working on multiple computers, the synchronization of
all these setting become an issue.

Project `dotfiles` provides a framework to do all the setups with a bootstrap
script `scripts/bootstrap.zsh`.


## Prerequisite
- macOS or Ubuntu
- zsh
- git


## Basic Installation

Install dotfiles by running the `curl` or `wget` command in the terminal.

| Method   | Command                                                                                              |
|:---------|:-----------------------------------------------------------------------------------------------------|
| **curl** | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"` |
| **wget** | `sh -c "$(wget -O- https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"`   |


## Test with Docker

To test this package and tune your local config, pull the docker image and run it locally.
```zsh
docker pull ghcr.io/tainvecs/dotfiles:latest
docker run --rm -it ghcr.io/tainvecs/dotfiles:latest
```

Alternatively, you can also build the image locally.
```zsh
cd ~/dotfiles && sh ./deployment/docker_build_local.sh
```


## Reference
- [thoughtbot / dotfiles](https://github.com/thoughtbot/dotfiles)
- [mathiasbynens / dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ohmyzsh / ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [gpakosz / .tmux](https://github.com/gpakosz/.tmux)
