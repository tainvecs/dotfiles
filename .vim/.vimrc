 

" ------------------------------------------------------------------------------
" Basic Setup
" ------------------------------------------------------------------------------


set nocompatible

set viminfofile=~/.vim/.viminfo

" Encoding

scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8


" Tabs

set expandtab                       " Use spaces instead of tabs
set smarttab                        " Enable smart-tabs
set shiftwidth=4                    " Number of auto-indent spaces
set softtabstop=4                   " Number of spaces per Tab
set tabstop=4


" Map leader

let mapleader=','


" Searching

set incsearch                       " Searches for strings incrementally
set hlsearch                        " Highlight all search results
set smartcase                       " Enable smart-case search
set ignorecase                      " Always case-insensitive


" Ident

"set autoindent                      " Auto-indent new lines
set smartindent                     " Enable smart-indent


"Wrap

set linebreak                       " Break lines at word (requires Wrap lines)
set textwidth=100                   " Line wrap (number of cols)


" Fold

set foldmethod=syntax
set nofoldenable


" Other

set backspace=indent,eol,start      " Fix backspace indent
set undolevels=1000                 " Number of undo levels
set showmatch                       " Highlight matching brace
set visualbell                      " Use visual bell (no beeping)
set ttyfast
set listchars=tab:▸\ ,eol:$


" ------------------------------------------------------------------------------
" Visual Settings
" ------------------------------------------------------------------------------


syntax on
set ruler                           " Show row and column ruler information
set number                          " Show line numbers

set laststatus=2                    " always show status line


" Color

set t_Co=256

colorscheme desertEx


" ------------------------------------------------------------------------------
" vundle
" ------------------------------------------------------------------------------


if !empty(glob('~/.vim/bundle/Vundle.vim'))

    set nocompatible                " required
    filetype off                    " required


    " set the runtime path to include Vundle and initialize

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()


    " let Vundle manage Vundle, required

    Plugin 'gmarik/Vundle.vim'


    " Add all your plugins here

    Plugin 'itchyny/lightline.vim'
    
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'scrooloose/nerdtree'
    Plugin 'scrooloose/syntastic'

    " All of your Plugins must be added before the following line


    call vundle#end()               " required
    filetype plugin indent on       " required


    " Setting related to plugins

    let g:lightline = { 'colorscheme': 'Tomorrow_Night_Blue' }

endif
