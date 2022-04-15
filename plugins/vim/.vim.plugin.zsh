if type vim >/dev/null; then

    # https://stackoverflow.com/questions/25520709/html-conversion-with-vimdiff-in-shell-script
    function vimdiff2html(){
        vimdiff $1 $2 -c TOhtml -c "w! $3" -c "qa!"
    }

fi
