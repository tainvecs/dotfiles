#!/bin/zsh


# ------------------------------------------------------------------------------
# init params
# ------------------------------------------------------------------------------


DOTFILES_ROOT="$(dirname $(cd $(dirname $0) >/dev/null 2>&1; pwd -P;))"

DOTFILES_CONFIG="$DOTFILES_ROOT/config"
DOTFILES_LOCAL="$DOTFILES_ROOT/local"
DOTFILES_RESOURCES="$DOTFILES_ROOT/resources"


# ------------------------------------------------------------------------------
# copy local/config_template to local/config
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
# config -> local/config
# ------------------------------------------------------------------------------


DOTFILES_LOCAL_CONFIG="$DOTFILES_LOCAL/config"
mkdir -p "$DOTFILES_CONFIG"

# local config
declare -a LOCAL_CONFIG_PATH_ARR=(

    # aws
    "$DOTFILES_LOCAL/config/aws/config"

    # docker
    "$DOTFILES_LOCAL/config/docker/config.json"
    "$DOTFILES_LOCAL/config/docker/daemon.json"

    # emacs
    "$DOTFILES_LOCAL/config/emacs/init.el.local"

    # git: delta
    "$DOTFILES_LOCAL/config/git/config"

    # iterm2
    "$DOTFILES_LOCAL/config/iterm2/keymap.itermkeymap"
    "$DOTFILES_LOCAL/config/iterm2/profile-default.json"

    # lazydocker
    "$DOTFILES_LOCAL/config/lazydocker/config.yaml"

    # p10k
    "$DOTFILES_LOCAL/config/p10k/.p10k.zsh"

    # peco
    "$DOTFILES_LOCAL/config/peco/config.json"

    # python
    "$DOTFILES_LOCAL/config/python/.pythonrc"

    # ssh
    "$DOTFILES_LOCAL/config/ssh/config"

    # tmux
    "$DOTFILES_LOCAL/config/tmux/.tmux.conf.local"

    # vim
    "$DOTFILES_LOCAL/config/vim/.vimrc.local"

    # zsh
    "$DOTFILES_LOCAL/config/zsh/.zshenv.local"
    "$DOTFILES_LOCAL/config/zsh/.zshrc_initialize.zsh.local"
    "$DOTFILES_LOCAL/config/zsh/.zshrc_apps.zsh.local"
    "$DOTFILES_LOCAL/config/zsh/.zshrc_plugins.zsh.local"
    "$DOTFILES_LOCAL/config/zsh/.zshrc_finalize.zsh.local"

)

setopt nullglob
for src_path in $LOCAL_CONFIG_PATH_ARR; do

    dst_path=$(echo $src_path | sed "s#${DOTFILES_LOCAL_CONFIG}#${DOTFILES_CONFIG}#")
    dst_dir=$(dirname "$dst_path")

    if [[ ! -d $dst_dir ]]; then
        echo "missing directory $dst_dir"
        mkdir -p $dst_dir
    fi

    [[ -L $dst_path || -f $dst_path ]] || ln -s $src_path $dst_path

done
unsetopt nullglob


# ------------------------------------------------------------------------------
# git: delta
# ------------------------------------------------------------------------------


# config -> resources
GIT_THEME_SRC="$DOTFILES_RESOURCES/git/themes.gitconfig"
GIT_THEME_DST="$DOTFILES_CONFIG/git/themes.gitconfig"
[[ -f $GIT_THEME_SRC ]] && [[ ! -f $GIT_THEME_DST ]] && ln -s $GIT_THEME_SRC $GIT_THEME_DST


# ------------------------------------------------------------------------------
# ssh
# ------------------------------------------------------------------------------


# ssh_keys
mkdir -p "$DOTFILES_CONFIG/ssh/ssh_keys"
