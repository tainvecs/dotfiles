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


" VIM_CONFIG_LOCAL_PATH: $DOTFILES_XDG_CONFIG_DIR/vim/.local.vimrc
if filereadable(expand("$VIM_CONFIG_LOCAL_PATH"))
    source $VIM_CONFIG_LOCAL_PATH
endif
