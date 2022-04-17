DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`


# load init
emacs --load "$DOTFILES_HOME/.emacs/init.el" --batch


# install for go
if type go >/dev/null; then

    if [[ $OS_TYPE = "Darwin" ]]; then

        go install golang.org/x/tools/cmd/goimports@latest
        go install github.com/rogpeppe/godef@latest
        go install github.com/mdempsky/gocode@latest
        go install golang.org/x/tools/gopls@latest

    elif [[ $OS_TYPE = "Linux" ]]; then

        export GO111MODULE=on
        go get golang.org/x/tools/cmd/goimports@latest
        go get github.com/rogpeppe/godef@latest
        go get github.com/mdempsky/gocode@latest
        go get golang.org/x/tools/gopls@latest

    fi

fi
