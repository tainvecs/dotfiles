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
