## Home Directory
- Environment variable `DOTFILES[HOME_DIR]` is used as the home directory for installed applications. By default, it is set to `~/dotfiles/home`.
- `ZDOTDIR` is also set to `${DOTFILES[HOME_DIR]}/.zsh` which is `~/dotfiles/home/.zsh` by default.
- The script `dotfiles/scripts/home.build.zsh` will build the home directory by creating the missing subdirectory and linking config files from `dotfiles/config`. You can run the script if there is any subdirectory missing.
  ```zsh
  cd ~/dotfiles && zsh ./scripts/home.build.zsh
  ```
