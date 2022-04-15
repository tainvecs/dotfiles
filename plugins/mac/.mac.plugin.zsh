if [[ `uname` = "Darwin" ]]; then

    function mac-cleanup() {

        # recursively delete `.DS_Store` files
        find . -type f -name '*.DS_Store' -ls -delete

        if type brew>/dev/null; then
            brew doctor
            brew cleanup -s
            brew cleanup --prune=all
        fi

    }

    # show/hide hidden files
    function mac-finder-show() {
        defaults write com.apple.finder AppleShowAllFiles TRUE
        killall Finder
        echo "Finder show hidden file mode was setted to True."
    }
    function mac-finder-hide() {
        defaults write com.apple.finder AppleShowAllFiles FALSE
        killall Finder
        echo "Finder show hidden file mode was setted to False."
    }

    # hide/show all desktop icons (useful when presenting)
    function mac-desktop-show() {
        defaults write com.apple.finder CreateDesktop TRUE
        killall Finder
        echo "Finder show hidden file mode was setted to True."
    }
    function mac-desktop-hide() {
        defaults write com.apple.finder CreateDesktop FALSE
        killall Finder
        echo "Finder show hidden file mode was setted to False."
    }

    # afk
    function afk(){
        osascript -e 'tell app "System Events" to key code 12 using {control down, command down}'
    }

fi
