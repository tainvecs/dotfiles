

# ------------------------------------------------------------------------------
# parameter
# ------------------------------------------------------------------------------


# motd
MOTD_FILE=./setting/dynmotd
MOTD_PATH=/etc/dynmotd


#  bashrc
BASHRC_FILE=./setting/bashrc
BASHRC_PATH=~/.bashrc


#  bash_profile
BASH_PROFILE_FILE=./setting/bash_profile
BASH_PROFILE_PATH=~/.bash_profile


# ssh_config
SSH_CONFIG_FILE=./setting/ssh_config
SSH_CONFIG_DIR=~/.ssh
SSH_CONFIG_PATH=$SSH_CONFIG_DIR'/config'


# ipython_config
IPYTHON_FILE=./setting/ipython_config.py
IPYTHON_DIR=~/.ipython/profile_default/
IPYTHON_PATH=$IPYTHON_DIR'/ipython_config.py'


# vimrc
VIM_COLOR_RES_DIR=./vim-colors/
VIM_COLOR_TRG_DIR=~/.vim/colors/

VIMRC_FILE=./setting/vimrc
VIMRC_PATH=~/.vimrc


# vundle
VUNDLE_PATH=~/.vim/bundle


# set up default time zone seletoion (edit and uncomment TZ_AREA and TZ_CITY)
# TZ_AREA=America
# TZ_CITY=Los_Angeles


OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# motd : ./dynmotd
# ------------------------------------------------------------------------------


sudo cp $MOTD_FILE $MOTD_PATH


# ------------------------------------------------------------------------------
# bashrc : ./bashrc
# ------------------------------------------------------------------------------


if [ -f $BASHRC_FILE ]; then

    cp $BASHRC_FILE $BASHRC_PATH

fi


# ------------------------------------------------------------------------------
# bash_profile : ./bash_profile
# ------------------------------------------------------------------------------


cp $BASH_PROFILE_FILE $BASH_PROFILE_PATH


# ------------------------------------------------------------------------------
# ssh_config : ./ssh_config
# ------------------------------------------------------------------------------


if [ -f $SSH_CONFIG_FILE ]; then

    if ! [ -d $SSH_CONFIG_DIR ]; then

        mkdir $SSH_CONFIG_DIR

    fi

    cp $SSH_CONFIG_FILE $SSH_CONFIG_PATH

    # ssh key generation
    if [ "${DEBIAN_FRONTEND}" != 'noninteractive' ]; then
        while true; do
            read -p "Do you wish to generate ssh key? " yn
            case $yn in
                [Yy]* ) ssh-keygen; break;;
                [Nn]* ) break;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi

fi


# ------------------------------------------------------------------------------
# ipython_config.py : ~/.ipython/profile_default/ipython_config.py
# ------------------------------------------------------------------------------


if [ -f $IPYTHON_FILE ]; then

    if ! [ -d $IPYTHON_DIR ]; then

        mkdir -p $IPYTHON_DIR

    fi

    cp $IPYTHON_FILE $IPYTHON_PATH

fi


# ------------------------------------------------------------------------------
# tmux configuration
# ------------------------------------------------------------------------------


if ! [ -d .tmux ] && ! [ -f ~/.tmux.conf ] && ! [ -f ~/.tmux.conf.local ]; then
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux/
    ln -sf ~/.tmux/.tmux.conf ~/.tmux.conf
    cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
fi


# ------------------------------------------------------------------------------
# vimrc : ./vimrc
# ------------------------------------------------------------------------------


if [ -d $VIM_COLOR_RES_DIR ]; then

    if ! [ -d $VIM_COLOR_TRG_DIR ]; then

        mkdir -p $VIM_COLOR_TRG_DIR

    fi

    if [ "$OS_TYPE" = 'Linux' ]; then

        cp -RT $VIM_COLOR_RES_DIR $VIM_COLOR_TRG_DIR

    elif [ "$OS_TYPE" = 'Darwin' ]; then

        cp -r $VIM_COLOR_RES_DIR $VIM_COLOR_TRG_DIR

    fi

fi

cp $VIMRC_FILE $VIMRC_PATH


# ------------------------------------------------------------------------------
# vundle
# ------------------------------------------------------------------------------


if ! [ -d $VUNDLE_PATH ]; then
    mkdir -p $VUNDLE_PATH
    git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_PATH'/Vundle.vim'
fi

if [ -d $VUNDLE_PATH'/Vundle.vim' ]; then
    vim +PluginInstall +qall
fi


# ------------------------------------------------------------------------------
# locales
# ------------------------------------------------------------------------------


if [ "$OS_TYPE" = 'Linux' ]; then
    sudo dpkg-reconfigure -f noninteractive locales
    sudo locale-gen en_US.UTF-8
fi


# ------------------------------------------------------------------------------
# time zone
# ------------------------------------------------------------------------------


# change the selection of time zone
if ! [ -z "$TZ_AREA" ] && ! [ -z "$TZ_CITY" ] && [ "$OS_TYPE" = 'Linux' ]; then
    sudo echo "tzdata tzdata/Areas select "$TZ_AREA | debconf-set-selections
    sudo echo "tzdata tzdata/Zones/"$TZ_AREA" select "$TZ_CITY | debconf-set-selections
    sudo rm -f /etc/localtime /etc/timezone
    sudo dpkg-reconfigure -f noninteractive tzdata
elif [ "$OS_TYPE" = 'Linux' ] && [ "${DEBIAN_FRONTEND}" != 'noninteractive' ]; then
    sudo dpkg-reconfigure tzdata
fi
