#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"
DOTFILES_DATA="$DOTFILES_ROOT/share"

OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# iterm color
# ------------------------------------------------------------------------------


ITERM_COLORS_DST="$DOTFILES_RESOURCES/iterm"
mkdir -p $ITERM_COLORS_DST

if [[ ! -f "$ITERM_COLORS_DST/Solarized High Contrast Dark.itermcolors" ]]; then
    curl "https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20Higher%20Contrast.itermcolors"\
         -o "$ITERM_COLORS_DST/Solarized High Contrast Dark.itermcolors"
fi


# ------------------------------------------------------------------------------
# fonts
# ------------------------------------------------------------------------------


# download
FONTS_DST="$DOTFILES_RESOURCES/fonts"
mkdir -p $FONTS_DST

if [[ ! -f "$FONTS_DST/all-the-icons.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/all-the-icons.ttf?raw=true" \
         -o "$FONTS_DST/all-the-icons.ttf"
fi

if [[ ! -f "$FONTS_DST/file-icons.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/file-icons.ttf?raw=true" \
         -o "$FONTS_DST/file-icons.ttf"
fi

if [[ ! -f "$FONTS_DST/fontawesome.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/fontawesome.ttf?raw=true" \
         -o "$FONTS_DST/fontawesome.ttf"
fi

if [[ ! -f "$FONTS_DST/material-design-icons.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/material-design-icons.ttf?raw=true" \
         -o "$FONTS_DST/material-design-icons.ttf"
fi

if [[ ! -f "$FONTS_DST/octicons.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/octicons.ttf?raw=true" \
         -o "$FONTS_DST/octicons.ttf"
fi

if [[ ! -f "$FONTS_DST/weathericons.ttf" ]]; then
    curl "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/weathericons.ttf?raw=true" \
         -o "$FONTS_DST/weathericons.ttf"
fi

if [[ ! -f "$FONTS_DST/MesloLGS NF Regular.ttf" ]]; then
    curl "https://github.com/romkatv/powerlevel10k-media/blob/master/MesloLGS%20NF%20Regular.ttf?raw=true" \
         -o "$FONTS_DST/MesloLGS NF Regular.ttf"
fi

if [[ ! -f "$FONTS_DST/SourceCodePro-Medium.ttf" ]]; then
    curl "https://github.com/adobe-fonts/source-code-pro/blob/release/TTF/SourceCodePro-Medium.ttf?raw=true" \
         -o "$FONTS_DST/SourceCodePro-Medium.ttf"
fi

# copy to system shard folder
FONTS_RESOURCES_SRC="$DOTFILES_RESOURCES/fonts"

if [[ $OS_TYPE = "Darwin" ]]; then

    FONTS_RESOURCES_DST="$HOME/Library/Fonts"

elif [[ $OS_TYPE = "Linux" ]]; then

    FONTS_RESOURCES_DST="$DOTFILES_DATA/fonts"

fi
[[ -d $FONTS_RESOURCES_DST ]] || mkdir -p $FONTS_RESOURCES_DST

cp $FONTS_RESOURCES_SRC/* $FONTS_RESOURCES_DST


# ------------------------------------------------------------------------------
# git: delta theme config
# ------------------------------------------------------------------------------


DELTA_THEME_DST="$DOTFILES_RESOURCES/git"
mkdir -p $DELTA_THEME_DST

if [[ ! -f "$DELTA_THEME_DST/themes.gitconfig" ]]; then
    curl "https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig" \
         -o "$DELTA_THEME_DST/themes.gitconfig"
fi


# ------------------------------------------------------------------------------
# vim color
# ------------------------------------------------------------------------------


VIM_COLORS_DST="$DOTFILES_RESOURCES/vim/colors"
mkdir -p $VIM_COLORS_DST

if [[ ! -f "$VIM_COLORS_DST/desertEx.vim" ]]; then
    curl "https://raw.githubusercontent.com/vim-scripts/desertEx/master/colors/desertEx.vim" \
         -o "$VIM_COLORS_DST/desertEx.vim"
fi
