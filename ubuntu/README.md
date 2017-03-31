## Environment
* Ubuntu 18.04
* Python3


## Maintainer Info
* Chin-Ho, Lin
* tainvecs@gmail.com
* [Github](https://github.com/tainvecs/system-setting), [Docker Hub](https://hub.docker.com/r/tainvecs/my-ubuntu)


## Package Installation

* Install Apps and Packages with apt-get
    - php
    - tzdata
    - locales
    - sudo
    - man-db
    - curl
    - wget
    - net-tools
    - iputils-ping
    - git
    - tmux
    - htop
    - dialog
    - less
    - vim
    - openssh-server
    - denyhosts
    - python3
    - python3-pip python3-dev build-essential


## System Setting

* **/setting/bash_profile**
    - set environment variable
        + set **TERM** to xterm-256color
        + set Bash prompt **PS1** format and colors
        + set **LANG**, **LANGUAGE**, **LC_ALL** to "en_US.UTF-8"
        + set **VISUAL**, **EDITOR**, **GIT_EDITOR** to "vim"
    - define bash aliases
        + **ls**: ls with color
        + **ll**: list file
        + **la**: show all file
        + **lh**: show hidden files
        + **dir**: show disk usage of current directory
        + **meminfo**: show memory information
        + **sysinfo**: show system info of ubuntu
    - define bash functions
        + **extract( )**
            - extract compressed file
            - format: extract "file_name"
        + **motd( )**
            - clear screan and print motd
        + **space_file( )**
            - add space to each line of a file
            - format: space_file "n_space" "in_file" "out_file"
        + **jpn-server( )**
            - start an jupyter notebook server
            - format: jpn-server {local|ssh} "ssh_port"
            - Option "local" starts an localhost server. 
            - Option "ssh" starts a server that able to be accessed by ssh connections.
        + **jpn-client( )**
            - start a ssh connection to the jupyter ssh server and map it to localhost "ssh_port"
            - format: jpn-client {start|stop} "ssh_port" "ssh_host"
            - Option "start" starts a ssh connection to jpn-server "ssh_host" with "ssh_port" and map it to localhost "ssh_port".
            - Option "stop" closes the ssh connection.

* **/setting/vimrc**
    - set basic vim setting
        + set encoding to utf-8
        + set auto indent
        + set tab to be replaced by 4 space
    - set visual setting
        + set color scheme to "desertEx"
    - install vundle plugin
        + "itchyny/lightline.vim"

* **/setting/ssh_config**

    - set up an example config of ptt, the largest bbs of Taiwan
    - able to to access ptt with the following command

    ```bash
        ssh ptt
    ```

* **/setting/dynmotd**
    - dynamic message of the day that shows system information
        + **Date**
        + **User**
        + **Hostname**
        + **Kernel**
        + **Uptime**
        + **CPU**
        + **Memory**
        + **Disk**
        + **Processes**

* **/setting/ipython_config.py**
    - color scheme: 'Linux'
    - editor: 'vim'
    - log level: 30

* set up **tmux** colorful configuration
    - [gpakosz/.tmux](https://github.com/gpakosz/.tmux)

* php, tzdata and locales are installed in noninteractive mode
    - locales is set to "en_US.UTF-8" in **system.setting.setup.sh**
    - time zone can be set up if **system.setting.setup.sh** is not executed in noninteractive mode
    - alternatively, uncomment and edit parameters TZ_AREA and TZ_CITY in **system.setting.setup.sh** to set up default time zone selectoin for the setting script

* if **system.setting.setup.sh** is not running in noninteractive mode
    - interactively asking if user want to change the system time zone
    - interactively asking if user want to generate ssh key


## Dockerfile

* run scripts **ubuntu.app.install.sh** and **system.setting.setup.sh** in noninteractive mode
* after running the scripts, the scripts and all setting resources will be moved to /tmp
* alternatively, uncomment and edit the useradd and expose command lines to add new users and expose port for ssh connection
