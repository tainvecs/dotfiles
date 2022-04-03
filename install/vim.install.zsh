DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

# init
VIM_HOME=${VIM_HOME:-$DOTFILES_ROOT/.vim}
[[ -d $VIM_HOME/bundle ]] || mkdir -p $VIM_HOME/bundle

# VundleVim
if [[ ! -d $VIM_HOME/bundle/Vundle.vim ]]; then
    git clone https://github.com/VundleVim/Vundle.vim.git $VIM_HOME/bundle/Vundle.vim
fi

# install
vim +PluginInstall +qall
