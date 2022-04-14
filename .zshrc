# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# ------------------------------------------------------------------------------
# parameter
# ------------------------------------------------------------------------------


OS_TYPE=`uname`
SSH_PORT=22
VPN_PORT=1194

ZDOTDIR="$HOME/.zsh" && mkdir -p $ZDOTDIR
MOTD_FILE=$ZDOTDIR'/.dynmotd'
GCLOUD_SDK_DIR="$HOME/.gcp/google-cloud-sdk"


# ------------------------------------------------------------------------------
# shell
# ------------------------------------------------------------------------------


alias shell-which="echo $0"

shell-change(){
    shell_target=$(which $1)
    $(chsh -s $shell_target)
    clear
    exec $shell_target
}


# ------------------------------------------------------------------------------
# zsh history
# ------------------------------------------------------------------------------


HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------


if [[ -d $HOME"/.local/bin" ]] && [[ ! $PATH = *$HOME"/.local/bin"* ]]; then
   export PATH=$PATH:$HOME"/.local/bin"
fi

if [[ -d /usr/bin ]] && [[ ! $PATH = *"/usr/bin"* ]]; then
   export PATH=$PATH:/usr/bin
fi

if [[ -d /usr/local/sbin ]] && [[ ! $PATH = *"/usr/local/sbin"* ]]; then
    export PATH=$PATH:/usr/local/sbin
fi


# ------------------------------------------------------------------------------
# locale
# ------------------------------------------------------------------------------


export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL="en_US.UTF-8"


# ------------------------------------------------------------------------------
# color
# ------------------------------------------------------------------------------


export TERM=xterm-256color

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ "$OS_TYPE" = 'Linux' ]; then
    export color_prompt=yes
elif [ "$OS_TYPE" = 'Darwin' ]; then
    export CLICOLOR=YES
fi

if [ "$color_prompt" = 'yes' ] || [ "$CLICOLOR" = 'YES' ]; then

    export PROMPT="%F{228}%K{000}%n%F{15}%K{000}@%F{156}%K{000}%m%F{15}%K{000}:%F{222}%K{000}[%d]%F{15}%K{000}$ %F{default}%K{default}"

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi

fi


# ------------------------------------------------------------------------------
# auto complete
# ------------------------------------------------------------------------------


if [[ -d "$ZDOTDIR/zsh-completions/src" ]]; then
    fpath=($ZDOTDIR"/zsh-completions/src" $fpath)
fi

if [[ -f "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Highlight the current autocomplete option
zstyle ':completion:*' menu select

# ssh/scp/rsync
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# git
if [[ -f "$ZDOTDIR/git-completion.bash" ]]; then
    zstyle ':completion:*:*:git:*' script "$ZDOTDIR/git-completion.bash"
    fpath=($ZDOTDIR $fpath)
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f $GCLOUD_SDK_DIR'/path.zsh.inc' ]; then
    . $GCLOUD_SDK_DIR'/path.zsh.inc';
fi

# The next line enables shell command completion for gcloud.
if [ -f $GCLOUD_SDK_DIR'/completion.zsh.inc' ]; then
    . $GCLOUD_SDK_DIR'/completion.zsh.inc';
fi

# Initialize the autocompletion
autoload -Uz compinit && compinit -d "$ZDOTDIR/.zcompdump" -i


# ------------------------------------------------------------------------------
# MOTD
# ------------------------------------------------------------------------------


if [ -f $MOTD_FILE ]; then

    motd() {
        clear
        php -f $MOTD_FILE | bash
    }

    php -f $MOTD_FILE | bash

fi


# ------------------------------------------------------------------------------
# info
# ------------------------------------------------------------------------------


if [ "$OS_TYPE" = 'Linux' ];then

    alias meminfo='free -html'                          # show memory information
    alias sysinfo="cat /etc/lsb-release && uname -a"    # show system info of ubuntu
    alias disk-info='df -h --total'

elif [ "$OS_TYPE" = 'Darwin' ];then

    meminfo-mac(){
        top -l 1 -s 0 | grep PhysMem    # show physical memory informaiton
        sysctl vm.swapusage             # show swap information
    }

fi


# ------------------------------------------------------------------------------
# tmux
# ------------------------------------------------------------------------------


if type tmux >/dev/null; then

    if [[ -f "$HOME/.tmux/.tmux.conf" ]]; then
        alias tmux="tmux -f $HOME/.tmux/.tmux.conf"
    fi

fi

# ------------------------------------------------------------------------------
# editor
# ------------------------------------------------------------------------------


if type vim >/dev/null; then

    export VISUAL=vim
    export VIMINIT="source "$HOME"/.vim/.vimrc"

    vimdiff2html(){
        vimdiff $1 $2 -c TOhtml -c 'w! '$3 -c 'qa!'
    }

elif type emacs >/dev/null; then
    export VISUAL=emacs
fi

export EDITOR=$VISUAL
export SUDO_EDITOR=/usr/bin/vim
export SELECTED_EDITOR=/usr/bin/vim


# ------------------------------------------------------------------------------
# emacs
# ------------------------------------------------------------------------------


if hash emacs 2>/dev/null; then

    if [[ -d "$HOME/.emacs/tainvecs" ]]; then

        alias emacs="env HOME=$HOME/.emacs/tainvecs emacs"

        if [[ -d "$HOME/.emacs/prelude" ]]; then
            alias emacs-pre="env HOME=$HOME/.emacs/prelude emacs"
        fi

    elif [[ -d "$HOME/.emacs/prelude" ]]; then
        alias emacs="env HOME=$HOME/.emacs/prelude emacs"
    else
        alias emacs="emacs -nw"
    fi

fi


# ------------------------------------------------------------------------------
# service
# ------------------------------------------------------------------------------


if [ "$OS_TYPE" = 'Linux' ];then

    alias service-ls="service --status-all"
    alias service-disalbe="sudo update-rc.d "$1" disable"

elif [ "$OS_TYPE" = 'Darwin' ] && type brew >/dev/null ;then

    alias service-ls="sudo brew services list"

fi


# ------------------------------------------------------------------------------
# homebrew
# ------------------------------------------------------------------------------


if [ "$OS_TYPE" = 'Darwin' ] && type brew >/dev/null ; then

    export HOMEBREW_NO_AUTO_UPDATE=1

fi

# ------------------------------------------------------------------------------
# users and groups
# ------------------------------------------------------------------------------


# user
if [ "$OS_TYPE" = 'Linux' ];then

    alias group-ls='cut -d: -f1 /etc/group | sort'
    alias group-new='sudo groupadd '$1

    group-add-user(){
        # $1: group, $2: user
        sudo adduser $2 $1
    }

fi

# group
if [ "$OS_TYPE" = 'Linux' ];then
    alias user-new='sudo adduser '$1
    alias user-list-group='groups '$1
fi

# login
if [ "$OS_TYPE" = 'Linux' ];then
    login-hist(){
        last $1 | head -n 15
    }
    alias login-top='watch w -u'
fi


# ------------------------------------------------------------------------------
# directory
# ------------------------------------------------------------------------------


if [ "$OS_TYPE" = 'Linux' ]; then

    l(){
        echo '--------------------------------------------------'
        ls --color=always -lahp | grep '^d'
        echo '--------------------------------------------------'
        ls --color=always -lahp | grep '^[-|l]'
        echo '--------------------------------------------------'
    }

    alias ls='ls --color=auto'                          # ls with color
    alias ll='ls --color=auto -lh'                      # list file
    alias la='ls --color=auto -lah'                     # show all file
    alias lh='ls --color=auto -ldh .?*'                 # show hidden files

    alias dir='du -h -d 1 | sort -hr'                   # show disk usage of current directory


elif [ "$OS_TYPE" = 'Darwin' ]; then

    l(){
        echo '-----------------------------------------------'
        ls -lahpG | grep '^d'
        echo '-----------------------------------------------'
        ls -lahpG | grep '^[-|l]'
        echo '-----------------------------------------------'
    }

    alias ls='ls -G'                                    # ls with color
    alias ll='ls -lhG'                                  # list file
    alias la='ls -lahG'                                 # show all file
    alias lh='ls -ldhG .?*'                             # show hidden files

    if ! type gsort >/dev/null; then                   # show disk usage of current directory
        alias dir='du -hs'
    else
        alias dir='du -h -d 1 | gsort -hr'
    fi

    # defined for switching mac finder mode that
    # -t for to show hidden files, and -f for not to show hidden files

    macfm() {
        if [ "$1" = "-t" ]; then
            defaults write com.apple.finder AppleShowAllFiles TRUE
            killall Finder
            echo "Finder show hidden file mode was setted to True."
        elif [ "$1" = "-f" ]; then
            defaults write com.apple.finder AppleShowAllFiles FALSE
            killall Finder
            echo "Finder show hidden file mode was setted to False."
        else
            echo "Finder show hidden file mode is unknown."
        fi
    }

fi


# ------------------------------------------------------------------------------
# file process
# ------------------------------------------------------------------------------


extract(){

    if [ -f $1 ]; then
        case $1 in
            *.tar.gz)   tar zxvf $1     ;;
            *.tar.bz)   tar jxvf $1     ;;
            *.tar.bz2)  tar jxvf $1     ;;
            *.tar.xz)   tar Jxvf $1     ;;
            *.tar.Z)    tar Zxvf $1     ;;
            *.tar.tgz)  tar zxvf $1     ;;
            *.tar)      tar xvf $1      ;;
            *.gz)       gunzip $1       ;;
            *.bz)       bunzip2 $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.xz)       xz -d $1        ;;
            *.Z)        uncompress $1   ;;
            *.tgz)      tar zxvf $1     ;;
            *.7z)       7z x $1         ;;
            *.zip)      unzip $1        ;;
            *.rar)      unrar e $1      ;;
            *.tbz2)     tar jxvf $1     ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi

}

# add $1 number of spaces to each line of $2 and output to $3
space_file(){
    tmp_str=$(head -c $1 < /dev/zero | tr '\0' ' ')
    sed "s_^_${tmp_str}_" $2 > $3
}

# transform between tc and sc
if type iconv >/dev/null; then

    alias tc2u='iconv -f big5 -t utf-8 '$1      # convert big5 to utf-8
    alias u2tc='iconv -f utf-8 -t big5 '$1      # convert utf-8 to big5
    alias sc2u='iconv -f gbk -t utf-8 '$1       # convert gbk to utf-8
    alias u2sc='iconv -f utf-8 -t gbk '$1       # convert utf-8 to gbk

fi

if type cconv >/dev/null; then

    sc2tc() {
        iconv -f gbk -t utf8 $1 > $1'.temp'
        cconv -f UTF8-CN -t UTF8-TW $1'.temp' > $2
        rm -f $1'.temp'
    }

fi


# ------------------------------------------------------------------------------
# schedule
# ------------------------------------------------------------------------------


alias crontab-edit='crontab -e'
alias crontab-edit-sudo='sudo crontab -e'


# ------------------------------------------------------------------------------
# network connection
# ------------------------------------------------------------------------------


alias myip="curl ifconfig.me; echo"
alias port-ls='sudo lsof -i -P -n'

# pppoeconf switch
if type pppoeconf >/dev/null; then
    alias pppoe-on='sudo pon dsl-provider'
    alias pppoe-off='sudo poff -a'
fi

# check connected host
if type ssh >/dev/null; then
    alias ssh_host='ps auxwww | grep sshd'
fi

# sftp
if type with-readline >/dev/null; then
    alias sftp="with-readline sftp"
fi

# denyhosts
if [ -f '/etc/hosts.deny' ];then

    alias ssh_deny='sudo cat /etc/hosts.deny | tail -n +18'

    function unblock()
    {
        local  ip=$1

        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then

            sudo /etc/init.d/denyhosts stop

            sudo sed -i '/'$1'/d' /etc/hosts.deny
            sudo sed -i '/'$1'/d' /var/lib/denyhosts/hosts
            sudo sed -i '/'$1'/d' /var/lib/denyhosts/hosts-restricted
            sudo sed -i '/'$1'/d' /var/lib/denyhosts/hosts-root
            sudo sed -i '/'$1'/d' /var/lib/denyhosts/hosts-valid
            sudo sed -i '/'$1'/d' /var/lib/denyhosts/users-hosts

            echo "unblocked "$1' \nIf you still not able to login, please reboot the ssh server.'

            sudo /etc/init.d/denyhosts start

        else
            echo "format: unblock \"ip_address\""
        fi
    }

fi

# firewall
if type ufw >/dev/null; then

    ufw-status(){
        sudo ufw status verbose
        sudo ufw app list
    }
    ufw-allow(){
        sudo ufw allow $1
        sudo ufw reload
        ufw-status
    }
    ufw-deny(){
        sudo ufw deny $1
        sudo ufw reload
        ufw-status
    }
    ufw-delete-allow(){
        sudo ufw delete allow $1
        sudo ufw reload
        ufw-status
    }

    ufw-delete-deny(){
        sudo ufw delete deny $1
        sudo ufw reload
        ufw-status
    }

fi

# vpn server
if [ "$OS_TYPE" = 'Linux' ] && type openvpn >/dev/null; then
    alias vpn-status="sudo service openvpn status"
    alias vpn-start="sudo service openvpn start && sudo ufw allow "$VPN_PORT
    alias vpn-stop="sudo service openvpn stop && sudo ufw deny "$VPN_PORT
    alias vpn-restart="sudo service openvpn restart && sudo ufw allow "$VPN_PORT
elif [ "$OS_TYPE" = 'Darwin' ] && type openvpn >/dev/null; then
    alias vpn-start="sudo brew services start openvpn"
    alias vpn-stop="sudo brew services stop openvpn"
    alias vpn-link="sudo openvpn --config ~/.vpn/config.ovpn"
fi

# ssl certificates with certbot
if type certbot >/dev/null; then

    alias ssl-ls='sudo certbot certificates'
    alias ssl-cert-renew='sudo certbot renew'
    alias ssl-cert-delete='sudo certbot delete'

    if type nginx >/dev/null; then
        alias ssl-cert-nginx-new='sudo certbot --nginx -d '$1
    fi

fi


# ------------------------------------------------------------------------------
# gcloud compute
# ------------------------------------------------------------------------------


if type gcloud >/dev/null; then
    alias gcp="gcloud compute"
    alias gcp-config-ssh="gcloud compute config-ssh"
fi


# ------------------------------------------------------------------------------
# kubernetes
# ------------------------------------------------------------------------------


if type kubectl >/dev/null; then

    alias k="kubectl"
    alias kms="k -n microservices"

    source <(kubectl completion zsh)
    complete -F __start_kubectl k

fi


# ------------------------------------------------------------------------------
# aws
# ------------------------------------------------------------------------------


if type aws >/dev/null; then

    alias aws-account="aws sts get-caller-identity"
    alias aws-status="aws configure list"

fi


# ------------------------------------------------------------------------------
# git
# ------------------------------------------------------------------------------


export GIT_EDITOR="$VISUAL"

function git-prune(){

    git fetch

    git_all_local_branch=`git for-each-ref --format '%(refname) %(upstream:track)' refs/heads`
    git_filtered_branch=`echo $git_all_local_branch | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'`
    git_filtered_branch_array=("${(f)git_filtered_branch}")
    git_origin_ready_prune_branch=`git remote prune origin --dry-run`

    if [ "$git_filtered_branch$git_origin_ready_prune_branch" = "" ];then
        echo "No branch to be pruned."
        return 0
    fi

    echo $git_filtered_branch'\n'$git_origin_ready_prune_branch
    while true; do
        read "?Do you want to prune these branches? " yn
        case $yn in
            [Yy]* ) for rm_branch in $git_filtered_branch_array;
                    do;
                        git branch -D $rm_branch;
                    done;
                    git remote prune origin;
                    break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}


# ------------------------------------------------------------------------------
# docker
# ------------------------------------------------------------------------------


if type docker >/dev/null; then

    docker-login-gitlab(){
        echo $2 | docker login -u $1 "registry.gitlab.com" --password-stdin
    }

fi


# ------------------------------------------------------------------------------
# elasticsearch
# ------------------------------------------------------------------------------


if [[ $(type elasticsearch >/dev/null) || -f "/etc/init.d/elasticsearch" ]]; then

    alias es="elasticsearch"

    function es-list(){
        curl -XPOST "localhost:9200/_refresh?pretty"
        curl -XGET "localhost:9200/_cat/indices?v&pretty"
    }
    function es-reset(){
        curl -XDELETE "localhost:9200/_all"
    }

    function es-create-index(){
        curl -XPUT "localhost:9200/"$1 \
             -H 'Content-Type: application/json' \
             -d '@'$2
        es-list
    }

    function es-index(){
        curl -XPUT "localhost:9200/"$1"/_doc/"$2"?pretty" \
             -H "Content-Type: application/json" \
             -d"@"$3
    }

fi


# ------------------------------------------------------------------------------
# cuda
# ------------------------------------------------------------------------------


if [ -d '/usr/local/cuda' ]; then

    if [[ ! $PATH = *"/usr/local/cuda/bin"* ]]; then
        export PATH=$PATH:/usr/local/cuda/bin
    fi

    if [[ ! $LD_LIBRARY_PATH = *"/usr/local/cuda/extras/CUPTI/lib64"* ]]; then
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64
    fi

    if [[ ! $LD_LIBRARY_PATH = *"/usr/local/cuda/lib64"* ]]; then
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
    fi

fi


# ------------------------------------------------------------------------------
# anaconda
# ------------------------------------------------------------------------------


if [ -d '/opt/anaconda/anaconda3/bin/' ]; then

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!

    __conda_setup="$('/opt/anaconda/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
        conda deactivate
    else
        if [ -f "/opt/anaconda/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/anaconda/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup

    # <<< conda initialize <<<

fi


# ------------------------------------------------------------------------------
# jupyter notebook
# ------------------------------------------------------------------------------


if type jupyter >/dev/null; then

    alias jpn="jupyter notebook"

    jpn-server(){

        case $1 in
            "local" )
                jupyter notebook --no-browser;;
            "ssh" )
                jupyter notebook --no-browser --port=$2;;
            * ) echo "format jpn-server {local|ssh} ssh_port";;
        esac
    }

    jpn-client(){

        case $1 in
            "Start"|"start" )
                cmd_str="ssh -N -f -L localhost:"$2":localhost:"$2" "$3" -p "$SSH_PORT
                eval $cmd_str;;
            "Stop"|"stop" )
                for pid in $(ps aux | grep -E "[localhost]:$2.*$3" | awk '{print $2}'); do
                    echo $pid;
                    kill -9 $pid;
                done;;
            * ) echo "format: jpn-client {start|stop} ssh_port ssh_host";;
        esac

    }

fi


# ------------------------------------------------------------------------------
# npm and nvm
# ------------------------------------------------------------------------------


if type npm > /dev/null; then

    NPM_DIR="$HOME/.npm"

    export NODE_REPL_HISTORY="$NPM_DIR/.node_repl_history"

fi

if type nvm >/dev/null; then

    export NVM_DIR="$HOME/.nvm"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        nvm-load(){
            \. "$NVM_DIR/nvm.sh"  # This loads nvm
        }
    fi

    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

fi


# ------------------------------------------------------------------------------
# python
# ------------------------------------------------------------------------------


if type python3 >/dev/null; then

    alias python="python3"
    alias pip="pip3"

    if [[ ! -d "$HOME/.python" ]]; then
       mkdir -p "$HOME/.python"
    fi
    export PYTHONSTARTUP=$HOME'/.python/.pythonrc'

    if [[ ! -d "$HOME/.python" ]]; then
       mkdir -p "$HOME/.python/nltk_data"
    fi
    export NLTK_DATA=$HOME'/.python/nltk_data'

fi


# ------------------------------------------------------------------------------
# GOLANG
# ------------------------------------------------------------------------------


export GOROOT=/usr/local/go
export GOPATH=$HOME/.go/golib && mkdir -p $HOME/.go/golib
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOPATH=$GOPATH:$HOME/.go/gocode && mkdir $HOME/.go/gocode


# ------------------------------------------------------------------------------
# crystal
# ------------------------------------------------------------------------------


if type crystal >/dev/null; then
    alias cr="crystal"
fi
