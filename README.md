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

In addition, the following environment variables are configurable for the dotfiles installation scripts.
| Environment Variables                     | Default          | Descriptions                                                        |
|:------------------------------------------|:-----------------|:--------------------------------------------------------------------|
| **DOTFILES_ROOT_DIR**                     | `$HOME/dotfiles` | The customized root folder for dotfiles repo.                       |
| **DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES** | `''`             | Set to `true` to apply template configs in `local/config_template`. |

To run the installation script with these variables, try the following command.
| Method   | Command                                                                                                                                                                                         |
|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **curl** | `env DOTFILES_ROOT_DIR=/customized_path/dotfiles DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"` |
| **wget** | `env DOTFILES_ROOT_DIR=/customized_path/dotfiles DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES=true sh -c "$(wget -O- https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"`   |


## Test with Docker

To test this package and tune your local config, pull the docker image and run it locally.
```zsh
docker pull ghcr.io/tainvecs/dotfiles:latest
docker run --rm -it ghcr.io/tainvecs/dotfiles:latest
```

Alternatively, you can also build the image locally.
```zsh
cd /customized_path/dotfiles && sh ./deployment/docker_build_local.sh
```


## Uninstallation
Simply remove the following command from your `~/.zshenv` file
```zsh
source /customized_path/dotfiles/config/zsh/.zshenv
```

In addition, you can purge dotfiles from your system by removing the dotfiles repo.
```zsh
rm -r /customized_path/dotfiles
```


## Reference
- [thoughtbot / dotfiles](https://github.com/thoughtbot/dotfiles)
- [mathiasbynens / dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ohmyzsh / ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [gpakosz / .tmux](https://github.com/gpakosz/.tmux)
