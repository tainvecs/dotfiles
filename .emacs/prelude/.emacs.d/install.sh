
mkdir -p "$HOME/.emacs/prelude/.emacs.d"
export PRELUDE_INSTALL_DIR="$HOME/.emacs/prelude/.emacs.d" && curl -L https://github.com/bbatsov/prelude/raw/master/utils/installer.sh | sh
curl -L https://git.io/epre | sh

