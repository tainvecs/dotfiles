DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_HOME="$DOTFILES_ROOT/home"


# load init
emacs --load "$DOTFILES_HOME/.emacs/init.el" --batch


# install for go
if type go >/dev/null; then

    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/rogpeppe/godef@latest
    go install github.com/mdempsky/gocode@latest
    go install golang.org/x/tools/gopls@latest

fi
