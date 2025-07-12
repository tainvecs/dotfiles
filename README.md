# dotfiles
Setting up a terminal on a computer—including configurations, environment variables, and package installations—requires significant effort. Moreover, when working on multiple computers, synchronizing all these settings becomes a major challenge.

This dotfiles project provides a framework for managing these setups across macOS and Ubuntu shell environments.

## Prerequisite
- macOS or Ubuntu
- zsh
- curl or wget

## Basic Installation
- (Optional) Specify the installation path
  ```zsh
  # defaults to "$HOME/dotfiles" if not specified
  export DOTFILES_ROOT_DIR="$HOME/dotfiles"
  ```

- Install dotfiles by running the `curl` or `wget` command in the terminal.
    | Method   | Command                                                                                              |
    |:---------|:-----------------------------------------------------------------------------------------------------|
    | **curl** | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/tainvecs/dotfiles/refs/heads/main/.dotfiles/script/install.zsh)"` |
    | **wget** | `sh -c "$(wget -O- https://raw.githubusercontent.com/tainvecs/dotfiles/refs/heads/main/.dotfiles/script/install.zsh)"`   |

## Overview
There are three main directories in this dotfiles framework.
```
dotfiles
├── .dotfiles
├── .local
└── user
```
- `dotfiles/.dotfiles`
  - dotfiles framework code, such as libraries, environment variables, and scripts
  - Users should not need to access or change the code files in this directory.

- `dotfiles/.local`
  - The local directories (including XDG base directories) for user-specific configurations, cached data, state files, and binaries.
  - This directory will be automatically generated after dotfiles installation and initialization.
  - Files in this directory are not tracked by the dotfiles Git repository.
  - Generally, users should not need to access or change the files in this directory, except for tasks like clearing cache files.

- `dotfiles/user`
  - Directory for user-customized configs, environment variables, and secrets.
  - Users can manually create config or secret files to customize tools such as `ssh`.
  - Files in this directory are not tracked by the dotfiles Git repository.
  - Files in this directory will be symlinked to `dotfiles/.local` and sourced when the shell starts.
  - For more information, please check out the examples at [dotfiles-user].

## Uninstallation
Simply remove the following commands from your `~/.zshenv` file.
```zsh
export DOTFILES_ROOT_DIR=/custom/path/dotfiles
source /custom/path/dotfiles/.dotfiles/env/dotfiles.env
```

In addition, you can back up the `dotfiles/user` directory and then purge the dotfiles from your system by removing the dotfiles repository.
```zsh
rm -r /custom/path/dotfiles
```

## Reference
- [thoughtbot / dotfiles](https://github.com/thoughtbot/dotfiles)
- [mathiasbynens / dotfiles](https://github.com/mathiasbynens/dotfiles)
- [ohmyzsh / ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [gpakosz / .tmux](https://github.com/gpakosz/.tmux)


[dotfiles-user]: https://github.com/tainvecs/dotfiles-user
