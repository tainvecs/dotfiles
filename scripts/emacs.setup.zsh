#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_HOME="$DOTFILES_ROOT/home"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# init emacs
# ------------------------------------------------------------------------------


# load init
emacs --load "$DOTFILES_HOME/.emacs/init.el" --batch


# ------------------------------------------------------------------------------
# programming languages
# ------------------------------------------------------------------------------


# install for javascript
if type npm >/dev/null; then
    npm install eslint
fi


# install for python
if type pip >/dev/null; then
    pip install flake8 pylint
fi


# install for go
if type go >/dev/null; then

    if [[ $OS_TYPE = "Darwin" ]]; then

        go install golang.org/x/tools/gopls@latest
        go install golang.org/x/tools/cmd/goimports@latest
        go install github.com/rogpeppe/godef@latest
        go install github.com/mdempsky/gocode@latest
        go install honnef.co/go/tools/cmd/staticcheck@latest

    elif [[ $OS_TYPE = "Linux" ]]; then

        export GO111MODULE=on
        go get golang.org/x/tools/gopls@latest
        go get golang.org/x/tools/cmd/goimports@latest
        go get github.com/rogpeppe/godef@latest
        go get github.com/mdempsky/gocode@latest
        go get honnef.co/go/tools/cmd/staticcheck@latest

    fi

fi
