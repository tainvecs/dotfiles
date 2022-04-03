if type vim >/dev/null; then

    vimdiff2html(){
        vimdiff $1 $2 -c TOhtml -c "w! $3" -c "qa!"
    }

fi
