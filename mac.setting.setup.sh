

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
MOTD_CMD_FILE=/etc/profile


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


# ------------------------------------------------------------------------------
# motd : ./dynmotd
# ------------------------------------------------------------------------------


if ! grep -Fxq 'php -f '$MOTD_PATH' | bash' $MOTD_CMD_FILE ; then

    echo $'\n'"php -f $MOTD_PATH | bash"$'\n' | sudo tee -a $MOTD_CMD_FILE > /dev/null

fi

sudo cp -i $MOTD_FILE $MOTD_PATH


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

fi


# ------------------------------------------------------------------------------
# vimrc : ./vimrc
# ------------------------------------------------------------------------------


if ! [ -d $VIM_COLOR_TRG_DIR ]; then

    mkdir -p $VIM_COLOR_TRG_DIR
    cp -r $VIM_COLOR_RES_DIR $VIM_COLOR_TRG_DIR

fi


cp -i $VIMRC_FILE $VIMRC_PATH
