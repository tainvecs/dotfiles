# dotfiles

Setting up the terminal on a computer, including all the configuration, app, and plugin installation, takes a lot of work and effort. Moreover, especially when working on multiple computers, the synchronization of all these setting between these computing instances become an issue.

Project `dotfiles` provides a framework to do all the setups with a bootstrap script `scripts/bootstrap.zsh`.

Besides, docker image `ghcr.io/tainvecs/dotfiles:latest` also provides a test environment for trying out this project with the config templates.

## Prerequisite
- macOS or Ubuntu
- zsh
- git

## Basic Installation
Install dotfiles by running the `curl` or `wget` command in the terminal.
| Method    | Command                                                                                              |
| :-------- | :--------------------------------------------------------------------------------------------------- |
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/tainvecs/dotfiles/main/scripts/install.zsh)"`   |

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

## Config Directory
- Environment variable `DOTFILES[CONFIG_DIR]` is used as the config directory for installed applications. By default, it is set to `~/dotfiles/config`.
- `XDG_CONFIG_HOME` is also set to `${DOTFILES[CONFIG_DIR]}` which is `~/dotfiles/config` by default.
- The script `dotfiles/scripts/config.build.zsh` will build the config directory by linking local config files from `dotfiles/local/config`. You can run the script if there is any symbolic link missing.
  ```zsh
  cd ~/dotfiles && zsh ./scripts/config.build.zsh
  ```
- You can create your local config files in `local/config` by referencing `local/config_template`. Alternatively, you can also apply all the templates in `local/config_template` by setting the env `DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES`.
  ```zsh
  cd ~/dotfiles && env DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES=true zsh ./scripts/config.build.zsh
  ```

## Home Directory
- Environment variable `DOTFILES[HOME_DIR]` is used as the home directory for installed applications. By default, it is set to `~/dotfiles/home`.
- `ZDOTDIR` is also set to `${DOTFILES[HOME_DIR]}/.zsh` which is `~/dotfiles/home/.zsh` by default.
- The script `dotfiles/scripts/home.build.zsh` will build the home directory by creating the missing subdirectory and linking config files from `dotfiles/config`. You can run the script if there is any subdirectory missing.
  ```zsh
  cd ~/dotfiles && zsh ./scripts/home.build.zsh
  ```

## Reference
- [thoughtbot / dotfiles](https://github.com/thoughtbot/dotfiles)
- [mathiasbynens / dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ohmyzsh / ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [gpakosz / .tmux](https://github.com/gpakosz/.tmux)
