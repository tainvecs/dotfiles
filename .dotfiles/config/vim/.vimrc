" ------------------------------------------------------------------------------
" vim directories
" ------------------------------------------------------------------------------


" Enable full Vim features
set nocompatible

" DOTFILES_LOCAL_CONFIG_DIR/vim
" DOTFILES_LOCAL_SHARE_DIR/vim
set runtimepath^=$DOTFILES_LOCAL_CONFIG_DIR/vim
set runtimepath+=$DOTFILES_LOCAL_SHARE_DIR/vim

" DOTFILES_LOCAL_STATE_DIR/vim
if !isdirectory($DOTFILES_LOCAL_STATE_DIR . '/vim')
    call mkdir($DOTFILES_LOCAL_STATE_DIR . '/vim', 'p')
endif
set viminfofile=$DOTFILES_LOCAL_STATE_DIR/vim/viminfo

" DOTFILES_LOCAL_CACHE_DIR/vim
let s:cache_dir = $DOTFILES_LOCAL_CACHE_DIR . '/vim'
if !isdirectory(s:cache_dir)
    call mkdir(s:cache_dir, 'p', 0700)
endif

if !isdirectory(s:cache_dir . '/undo')
    call mkdir(s:cache_dir . '/undo', 'p', 0700)
endif
set undodir=$DOTFILES_LOCAL_CACHE_DIR/vim/undo//

if !isdirectory(s:cache_dir . '/backup')
    call mkdir(s:cache_dir . '/backup', 'p', 0700)
endif
set backupdir=$DOTFILES_LOCAL_CACHE_DIR/vim/backup//

if !isdirectory(s:cache_dir . '/swp')
    call mkdir(s:cache_dir . '/swp', 'p', 0700)
endif
set directory=$DOTFILES_LOCAL_CACHE_DIR/vim/swp//


" ------------------------------------------------------------------------------
" local
" ------------------------------------------------------------------------------


" VIM_LOCAL_CONFIG_PATH: $DOTFILES_LOCAL_CONFIG_DIR/vim/.local.vimrc
if filereadable(expand("$VIM_LOCAL_CONFIG_PATH"))
    source $VIM_LOCAL_CONFIG_PATH
endif
