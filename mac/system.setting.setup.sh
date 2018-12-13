
#!bin/bash

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
    ssh-keygen

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


CUR_DIR=$PWD

cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

cd $CUR_DIR


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


if [ "$OS_TYPE" == 'Linux' ]; then
    dpkg-reconfigure -f noninteractive locales
    sudo locale-gen en_US.UTF-8
fi
