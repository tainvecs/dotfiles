if [[ `uname` = "Darwin" ]]; then

    # defined for switching mac finder mode that
    # -t for to show hidden files
    # -f for not to show hidden files
    macfm() {

        if [ "$1" = "-t" ]; then

            defaults write com.apple.finder AppleShowAllFiles TRUE
            killall Finder
        
            echo "Finder show hidden file mode was setted to True."
        
        elif [ "$1" = "-f" ]; then
        
            defaults write com.apple.finder AppleShowAllFiles FALSE
            killall Finder
        
            echo "Finder show hidden file mode was setted to False."
        
        else
        
            echo "Finder show hidden file mode is unknown."
        
        fi
    }

fi
