# ------------------------------------------------------------------------------
#
# Dotfiles App Configuration
#
#
# Version: 0.0.1
# Last Modified: 2025-03-30
#
# - Reference
#   - DOTFILES_APP_ARR
#   - DOTFILES_PLUGIN_ARR
#   - DOTFILES_USER_APP_ARR
#   - DOTFILES_USER_PLUGIN_ARR
#
# - Environment Variable
#   - DOTFILES_APP_ASC_ARR
#   - DOTFILES_PLUGIN_ASC_ARR
#
# - Helper Function
#   - is_dotfiles_managed_app
#   - is_dotfiles_managed_plugin
#
# ------------------------------------------------------------------------------


# set up DOTFILES_APP_ASC_ARR
unset DOTFILES_APP_ASC_ARR
typeset -A DOTFILES_APP_ASC_ARR
update_associative_array_from_array "DOTFILES_APP_ASC_ARR" "DOTFILES_USER_APP_ARR" "DOTFILES_APP_ARR"


# DOTFILES_PLUGIN_ASC_ARR
unset DOTFILES_PLUGIN_ASC_ARR
typeset -A DOTFILES_PLUGIN_ASC_ARR
update_associative_array_from_array "DOTFILES_PLUGIN_ASC_ARR" "DOTFILES_PLUGIN_APP_ARR" "DOTFILES_PLUGIN_ARR"
