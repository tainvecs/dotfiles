function update(){

    # mac
    if [[ ( $1 = "" || $1 = "mac" ) && `uname` = "Darwin" ]]; then

        echo "Update: softwareupdate..."
        sudo softwareupdate -i -a;

        if type brew >/dev/null; then
            echo "Update: brew..."
            brew update
            brew upgrade
        fi

    fi

    # mac
    if [[ ( $1 = "" || $1 = "linux" ) && `uname` = "Linux" ]]; then
        echo "Update: apt..."
        sudo apt update
        sude apt upgrade
    fi

    # zinit
    if [[ $1 = "" || $1 = "zinit" ]] && type zinit >/dev/null; then
        echo "Update: zinit..."
        zinit self-update
        zinit update --all
    fi

    # emacs
    if [[ $1 = "" || $1 = "emacs" ]] && type emacs >/dev/null; then
        echo "Update: emacs..."
        eval "emacs --eval '(progn (sit-for 2) (auto-package-update-now) (sit-for 2) (save-buffers-kill-terminal))'"
    fi

    # python
    if [[ $1 = "" || $1 = "python" ]] && type pip >/dev/null; then
        echo "Update: python..."
        python -m pip install --upgrade pip
    fi

}
