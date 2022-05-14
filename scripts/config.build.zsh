#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_LOCAL="$DOTFILES_ROOT/local"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# ------------------------------------------------------------------------------
# local/config_template
# ------------------------------------------------------------------------------


if [[ $DOTFILES_APPLY_LOCAL_CONFIG_TEMPLATES = true ]]; then

    DOTFILES_LOCAL_CONFIG="$DOTFILES_LOCAL/config"
    DOTFILES_LOCAL_CONFIG_TEMPLATE="$DOTFILES_LOCAL/config_template"

    mkdir -p "$DOTFILES_LOCAL_CONFIG"

    setopt nullglob
    for src_dir in $DOTFILES_LOCAL_CONFIG_TEMPLATE/*; do

        # src_dir
        if [[ ! -d $src_dir ]]; then
            continue
        fi

        # dst_dir
        dst_dir=$( echo $src_dir | sed "s#${DOTFILES_LOCAL_CONFIG_TEMPLATE}#${DOTFILES_LOCAL_CONFIG}#" )
        if [[ ! -d $dst_dir ]]; then
            echo "missing directory $dst_dir"
            mkdir -p $dst_dir
        fi

        # src_file
        for src_file in $src_dir/* $src_dir/.* ; do

            src_file_name=$( echo $src_file | sed "s#${src_dir}/##" )

            # check if it is template
            if [[ ! "$src_file_name" =~ ".template" ]]; then
                continue
            fi

            # copy src_file to dst_file
            dst_file=$( echo "$dst_dir/$src_file_name" | sed "s#\.template##" )
            if [[ ! -f $dst_file ]]; then
                cp -v $src_file $dst_file
            fi

        done

    done

    unsetopt nullglob

fi


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


# config -> local
AWS_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/aws/config"
AWS_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/aws/config"
[[ -L $AWS_LOCAL_CONFIG_DST || -f $AWS_LOCAL_CONFIG_DST ]] || ln -s $AWS_LOCAL_CONFIG_SRC $AWS_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# git: delta
# ------------------------------------------------------------------------------


# config -> resources
GIT_THEME_SRC="$DOTFILES_RESOURCES/git/themes.gitconfig"
GIT_THEME_DST="$DOTFILES_CONFIG/git/themes.gitconfig"
[[ -f $GIT_THEME_SRC ]] && [[ ! -f $GIT_THEME_DST ]] && ln -s $GIT_THEME_SRC $GIT_THEME_DST

# config -> local
GIT_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/git/config.local"
GIT_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/git/config.local"
[[ -L $GIT_LOCAL_CONFIG_DST || -f $GIT_LOCAL_CONFIG_DST ]] || ln -s $GIT_LOCAL_CONFIG_SRC $GIT_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# p10k
# ------------------------------------------------------------------------------


# config -> local
P10K_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/p10k/.p10k.zsh.local"
P10K_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/p10k/.p10k.zsh.local"
[[ -L $P10K_LOCAL_CONFIG_DST || -f $P10K_LOCAL_CONFIG_DST ]] || ln -s $P10K_LOCAL_CONFIG_SRC $P10K_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


# ssh_keys
mkdir -p "$DOTFILES_CONFIG/ssh/ssh_keys"

# config -> local
SSH_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/ssh/config"
SSH_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/ssh/config"
[[ -L $SSH_LOCAL_CONFIG_DST || -f $SSH_LOCAL_CONFIG_DST ]] || ln -s $SSH_LOCAL_CONFIG_SRC $SSH_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------


# config -> local
TMUX_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/tmux/.tmux.conf.local"
TMUX_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/tmux/.tmux.conf.local"
[[ -L $TMUX_LOCAL_CONFIG_DST || -f $TMUX_LOCAL_CONFIG_DST ]] || ln -s $TMUX_LOCAL_CONFIG_SRC $TMUX_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# vim
# ------------------------------------------------------------------------------


# config -> local
VIMRC_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/vim/.vimrc.local"
VIMRC_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/vim/.vimrc.local"
[[ -L $VIMRC_LOCAL_CONFIG_DST || -f $VIMRC_LOCAL_CONFIG_DST ]] || ln -s $VIMRC_LOCAL_CONFIG_SRC $VIMRC_LOCAL_CONFIG_DST


# ------------------------------------------------------------------------------
# zsh
# ------------------------------------------------------------------------------


# config -> local
ZSHENV_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/zsh/.zshenv.local"
ZSHENV_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/zsh/.zshenv.local"
[[ -L $ZSHENV_LOCAL_CONFIG_DST || -f $ZSHENV_LOCAL_CONFIG_DST ]] || ln -s $ZSHENV_LOCAL_CONFIG_SRC $ZSHENV_LOCAL_CONFIG_DST

ZSHRC_LOCAL_CONFIG_SRC="$DOTFILES_LOCAL/config/zsh/.zshrc.local"
ZSHRC_LOCAL_CONFIG_DST="$DOTFILES_CONFIG/zsh/.zshrc.local"
[[ -L $ZSHRC_LOCAL_CONFIG_DST || -f $ZSHRC_LOCAL_CONFIG_DST ]] || ln -s $ZSHRC_LOCAL_CONFIG_SRC $ZSHRC_LOCAL_CONFIG_DST
