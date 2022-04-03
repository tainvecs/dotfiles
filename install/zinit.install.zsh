DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

# install zinit
ZINIT_HOME="$DOTFILES_ROOT/home/.zsh/.zinit"
git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/zinit.git"
