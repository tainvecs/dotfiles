
Overview
========
Scripts for automatically setup setting files, and install mac os apps, mac os packages and python3 packages.

Requirements
============
* macOS Sierra

Setting Files
=============
* setting/bash_profile : the configuration file ~/.bash_profile
* setting/vimrc : the vim setting file ~/.vimrc
* setting/ssh_config : the ~/.ssh/config file
* setting/dynmotd : a dynamic motd file that shows system information
* setting/ipython_config.py : the ipython config file ~/.ipython/profile_default/ipython_config.py


Install Packages
================
run mac.package.install.sh with the following command ::

    bash mac.package.install.sh

Install Mac APPs
================
run mac.app.install.sh with the following command ::

    bash mac.app.install.sh

Setup Setting Files
===================
run system.setting.setup with the following command (git and vim should be installed by mac.package.install.sh in advance) ::

    bash system.setting.setup
