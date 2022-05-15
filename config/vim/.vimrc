" ------------------------------------------------------------------------------
" vim directories
" ------------------------------------------------------------------------------


set nocompatible

set runtimepath+=$VIM_HOME
set viminfofile=$VIM_HOME/viminfo
set undodir=$VIM_HOME/.undo//
set backupdir=$VIM_HOME/.backup//
set directory=$VIM_HOME/.swp//


" ------------------------------------------------------------------------------
" local
" ------------------------------------------------------------------------------


if filereadable(expand("$VIM_HOME/.vimrc.local"))

    source $VIM_HOME/.vimrc.local

endif
