

# ------------------------------------------------------------------------------
#
# Author        :   Tainvecs
# Created Date  :   2017-03-10
#
# ------------------------------------------------------------------------------


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


# vimrc
VIM_COLOR_RES_DIR=./vim-colors/
VIM_COLOR_TRG_DIR=~/.vim/colors/

VIMRC_FILE=./setting/vimrc
VIMRC_PATH=~/.vimrc


# vundle
VUNDLE_PATH=~/.vim/bundle


OS_TYPE=`uname`


# ------------------------------------------------------------------------------
# motd : ./dynmotd
# ------------------------------------------------------------------------------


sudo cp -i $MOTD_FILE $MOTD_PATH


# ------------------------------------------------------------------------------
# bashrc : ./bashrc
# ------------------------------------------------------------------------------


if [ -f $BASHRC_FILE ]; then

    cp -i $BASHRC_FILE $BASHRC_PATH

fi


# ------------------------------------------------------------------------------
# bash_profile : ./bash_profile
# ------------------------------------------------------------------------------


cp -i $BASH_PROFILE_FILE $BASH_PROFILE_PATH


# ------------------------------------------------------------------------------
# ssh_config : ./ssh_config
# ------------------------------------------------------------------------------


if [ -f $SSH_CONFIG_FILE ]; then

    if ! [ -d $SSH_CONFIG_DIR ]; then

        mkdir $SSH_CONFIG_DIR

    fi

    cp -i $SSH_CONFIG_FILE $SSH_CONFIG_PATH
    ssh-keygen

fi


# ------------------------------------------------------------------------------
# vimrc : ./vimrc
# ------------------------------------------------------------------------------


if [ -d $VIM_COLOR_RES_DIR ]; then

    if ! [ -d $VIM_COLOR_TRG_DIR ]; then

        mkdir -p $VIM_COLOR_TRG_DIR

    fi

    if [ "$OS_TYPE" == 'Linux' ]; then

        cp -RT $VIM_COLOR_RES_DIR $VIM_COLOR_TRG_DIR

    elif [ "$OS_TYPE" == 'Darwin' ]; then

        cp -r $VIM_COLOR_RES_DIR $VIM_COLOR_TRG_DIR

    fi

fi

cp -i $VIMRC_FILE $VIMRC_PATH


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


if [ "$OS_TYPE" == 'Linux' ]; then
    dpkg-reconfigure -f noninteractive locales
fi
