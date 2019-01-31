## Environment
* macOS Mojave
* Python3


## Maintainer Info
* Chin-Ho, Lin
* tainvecs@gmail.com
* [Github](https://github.com/tainvecs/system-setting)


## Package Installation

* Install Mac OS Apps
    - google chrome
    - firefox
    - adobe acrobat reader dc
    - iina
    - vlc
    - keka
    - evernote
    - insomniax
    - appcleaner
    - teamviewer
    - atom
    - filezilla

* Install Terminal Packages and Apps
    - git
    - docker
    - tmux
    - vim
    - coreutils
    - cconv
    - wget
    - unrar
    - 7zip
    - python3


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
    - define bash functions
        + **extract( )**
            - extract compressed file
            - format: extract "file_name"
        + **motd( )**
            - clear screan and print motd
        + **space_file( )**
            - add space to each line of a file
            - format: space_file "n_space" "in_file" "out_file"
    - define mac functions
        + **macfm( )**
            - switch mac finder mode, "-t": show hidden file, "-f": don't show hidden file
            - format: macfm "finder_mode"
        + **meminfo( )**
            - show memory and swap information

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

* locale and time zone
    - set system locale to "en_US.UTF-8"
    - uncomment and edit parameters TZ_AREA and TZ_CITY in **system.setting.setup.sh** to set up default time zone selectoin for the setting script

* if **system.setting.setup.sh** is not running in noninteractive mode
    - interactively asking if user want to change the system time zone
    - interactively asking if user want to generate ssh key
