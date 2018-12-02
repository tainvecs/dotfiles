
Overview
========
Scripts for automatically setup setting files and install ubuntu packages.

Requirements
============
* Ubuntu 18.04.1

Setting Files
=============
* setting/bash_profile : the configuration file ~/.bash_profile
* setting/bashrc : the configuration file ~/.bashrc
* setting/vimrc : the vim setting file ~/.vimrc
* setting/ssh_config : the ~/.ssh/config file
* setting/dynmotd : a dynamic motd file that shows system information


Install Packages
================
run ubuntu.app.install.sh the following command ::

    bash ubuntu.app.install.sh

Setup Setting Files
===================
run system.setting.setup with the following command (git and vim should be installed by ubuntu.package.install.sh in advance)::

    bash system.setting.setup
