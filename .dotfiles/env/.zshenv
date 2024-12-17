# ------------------------------------------------------------------------------
#
# dotfiles
#
# - description
#   - coordinate environment variables used by dotfiles
#
# - notes
#   - dotfiles/.dotfiles/env/.dotfiles.env
#
# ------------------------------------------------------------------------------


# dotfiles/dotfiles/env/.dotfiles.env
local _dotfiles_env_dir="$(cd $(dirname $0) >/dev/null 2>&1; pwd -P;)"
local _dotfiles_dotfiles_env_file_path="$_dotfiles_env_dir/.dotfiles.env"

source $_dotfiles_dotfiles_env_file_path
