DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# ------------------------------------------------------------------------------
# iterm color
# ------------------------------------------------------------------------------


ITERM_COLORS_DST="$DOTFILES_RESOURCES/iterm"
mkdir -p $ITERM_COLORS_DST

if [[ ! -f "$ITERM_COLORS_DST/Solarized High Contrast Dark.itermcolors" ]]; then
    wget -O "$ITERM_COLORS_DST/Solarized High Contrast Dark.itermcolors" \
         "https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20Higher%20Contrast.itermcolors"
fi


# ------------------------------------------------------------------------------
# vim color
# ------------------------------------------------------------------------------


VIM_COLORS_DST="$DOTFILES_RESOURCES/vim/colors"
mkdir -p $VIM_COLORS_DST

if [[ ! -f "$VIM_COLORS_DST/desertEx.vim" ]]; then
    wget -O "$VIM_COLORS_DST/desertEx.vim" \
         "https://raw.githubusercontent.com/vim-scripts/desertEx/master/colors/desertEx.vim"
fi


# ------------------------------------------------------------------------------
# fonts
# ------------------------------------------------------------------------------


FONTS_DST="$DOTFILES_RESOURCES/fonts"
mkdir -p $FONTS_DST

if [[ ! -f "$FONTS_DST/all-the-icons.ttf" ]]; then
    wget -O "$FONTS_DST/all-the-icons.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/all-the-icons.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/file-icons.ttf" ]]; then
    wget -O "$FONTS_DST/file-icons.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/file-icons.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/fontawesome.ttf" ]]; then
    wget -O "$FONTS_DST/fontawesome.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/fontawesome.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/material-design-icons.ttf" ]]; then
    wget -O "$FONTS_DST/material-design-icons.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/material-design-icons.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/octicons.ttf" ]]; then
    wget -O "$FONTS_DST/octicons.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/octicons.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/weathericons.ttf" ]]; then
    wget -O "$FONTS_DST/weathericons.ttf" \
         "https://github.com/domtronn/all-the-icons.el/blob/master/fonts/weathericons.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/MesloLGS NF Regular.ttf" ]]; then
    wget -O "$FONTS_DST/MesloLGS NF Regular.ttf" \
         "https://github.com/romkatv/powerlevel10k-media/blob/master/MesloLGS%20NF%20Regular.ttf?raw=true"
fi

if [[ ! -f "$FONTS_DST/SourceCodePro-Medium.ttf" ]]; then
    wget -O "$FONTS_DST/SourceCodePro-Medium.ttf" \
         "https://github.com/adobe-fonts/source-code-pro/blob/release/TTF/SourceCodePro-Medium.ttf?raw=true"
fi
