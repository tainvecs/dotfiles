

# zsh startup profile: `time ZSH_PROF=1 zsh -i -c exit`
# zsh startup log: `zsh -x -i -c exit 2>&1 | sed -u "s/^/[$(date '+%Y-%m-%d %H:%M:%S')] /"`
# zsh startup benchmark: `hyperfine 'zsh -i -c exit'`
if [[ -n "$ZSH_PROF" ]]; then
    zmodload zsh/zprof
fi


# ------------------------------------------------------------------------------
# initialize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_initialize.zsh" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh"
[[ -f "$ZDOTDIR/.zshrc_initialize.zsh.local" ]] && source "$ZDOTDIR/.zshrc_initialize.zsh.local"


# ------------------------------------------------------------------------------
# apps: config
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_apps.zsh" ]] && source "$ZDOTDIR/.zshrc_apps.zsh"
[[ -f "$ZDOTDIR/.zshrc_apps.zsh.local" ]] && source "$ZDOTDIR/.zshrc_apps.zsh.local"

# layz load app config script
local _app_script_path="$ZDOTDIR/.zshrc_apps.lazy.zsh"
if [[ -f "$_app_script_path" ]]; then
    zinit ice wait"1" lucid
    zinit snippet "$_app_script_path"
fi


# ------------------------------------------------------------------------------
# plugins
# dependency: zinit
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_plugins.zsh" ]] && source "$ZDOTDIR/.zshrc_plugins.zsh"
[[ -f "$ZDOTDIR/.zshrc_plugins.zsh.local" ]] && source "$ZDOTDIR/.zshrc_plugins.zsh.local"


# ------------------------------------------------------------------------------
# finalize zsh
# ------------------------------------------------------------------------------


[[ -f "$ZDOTDIR/.zshrc_finalize.zsh" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh"
[[ -f "$ZDOTDIR/.zshrc_finalize.zsh.local" ]] && source "$ZDOTDIR/.zshrc_finalize.zsh.local"


if [[ -n "$ZSH_PROF" ]]; then
    zprof
fi
