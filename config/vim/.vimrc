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
" basic setup
" ------------------------------------------------------------------------------


" Encoding
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

" Searching
set incsearch                       " Searches for strings incrementally
set hlsearch                        " Highlight all search results
set smartcase                       " Enable smart-case search

" Ident
"set autoindent                     " Auto-indent new lines
set smartindent                     " Enable smart-indent

" Other
set undolevels=1000                 " Number of undo levels
set showmatch                       " Highlight matching brace
set visualbell                      " Use visual bell (no beeping)
set ttyfast


" ------------------------------------------------------------------------------
" visual settings
" ------------------------------------------------------------------------------


syntax on
set ruler                           " Show row and column ruler information
set number                          " Show line numbers
set laststatus=2                    " always show status line


" ------------------------------------------------------------------------------
" local
" ------------------------------------------------------------------------------


if filereadable(expand("$VIM_HOME/.vimrc.local"))

    source $VIM_HOME/.vimrc.local

endif
