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


" VIM_LOCAL_CONFIG_PATH: $DOTFILES_LOCAL_CONFIG_DIR/vim/.local.vimrc
if filereadable(expand("$VIM_LOCAL_CONFIG_PATH"))
    source $VIM_LOCAL_CONFIG_PATH
endif
