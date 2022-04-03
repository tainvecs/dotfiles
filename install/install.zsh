# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_INSTALL="$DOTFILES_ROOT/install"
DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# install script for macOS
# ------------------------------------------------------------------------------


if [[ $OS_TYPE = "Darwin" ]]; then


    # ----- resource
    zsh $DOTFILES_INSTALL/resources.install.zsh


    # ----- home
    zsh $DOTFILES_INSTALL/home.build.zsh


    # ----- zsh

    # zshenv
    DOTFILES_ZSHENV_PATH="$DOTFILES_CONFIG/zsh/.zshenv"
    if [[ ! -f "~/.zshenv" ]] && [[ -f $DOTFILES_ZSHENV_PATH ]]; then
        ln -s $DOTFILES_ZSHENV_PATH ~
    else
        echo "Please Link $DOTFILES_ZSHENV_PATH to ~/.zshenv"
        cat dotfiles/config/zsh/.zshenv >> .zshenv
    fi
    source $DOTFILES_ZSHENV_PATH

    # initialize
    if [[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]]; then 
        source "$ZDOTDIR/.zshrc_initialize.zsh"
    fi


    # ----- install apps
    zsh $DOTFILES_INSTALL/brew.install.zsh


    # ----- install plugins
    zsh $DOTFILES_INSTALL/zinit.install.zsh

    # ----- config and set up
    
    # config
    if [[ -f "$DOTFILES_CONFIG/dotfiles/.config.zsh" ]]; then
        source "$DOTFILES_CONFIG/dotfiles/.config.zsh"
    fi

    # set up vim
    zsh $DOTFILES_INSTALL/vim.install.zsh

    # set up emacs
    zsh $DOTFILES_INSTALL/emacs.install.zsh

    # apply template
    zsh $DOTFILES_INSTALL/template.apply.zsh

fi
