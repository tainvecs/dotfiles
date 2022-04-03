DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"
DOTFILES_DATA="$DOTFILES_ROOT/share"
OS_TYPE=`uname`

# fonts
FONTS_RESOURCES_SRC="$DOTFILES_RESOURCES/fonts"

if [[ $OS_TYPE = "Darwin" ]]; then

    FONTS_RESOURCES_DST="$HOME/Library/Fonts"

elif [[ $OS_TYPE = "Linux" ]]; then

    FONTS_RESOURCES_DST="$DOTFILES_DATA/fonts"

fi

[[ -d $FONTS_RESOURCES_DST ]] || mkdir -p $FONTS_RESOURCES_DST
cp $FONTS_RESOURCES_SRC/* $FONTS_RESOURCES_DST
