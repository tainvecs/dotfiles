

# ------------------------------------------------------------------------------
#
# Author        :   Tainvecs
# Created Date  :   2017-04-02
# Last Updated  :   2017-04-02
#
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# function
# ------------------------------------------------------------------------------


install_mac_application() {

    #brew cask list --versions $1 &>/dev/null

    osascript -e "id of application \"$1\"" &>/dev/null

    if [ $? == 1 ]; then
        brew cask install $2
    fi

}


# ------------------------------------------------------------------------------
# mac applications
# ------------------------------------------------------------------------------


echo "Checking mac applications..."


# homebrew
if ! hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# google chrome
install_mac_application 'google chrome' 'google-chrome'

# firefox
install_mac_application 'firefox' 'firefox'

# adobe reader
install_mac_application 'adobe acrobat reader dc' 'adobe-reader'

# atom
install_mac_application 'atom' 'atom'

# insomniax
install_mac_application 'insomniax' 'insomniax'

# flux
install_mac_application 'flux' 'flux'

# appcleaner
install_mac_application 'appcleaner' 'appcleaner'

# teamviewer
install_mac_application 'teamviewer' 'teamviewer'

# filezilla
install_mac_application 'filezilla' 'filezilla'

# vlc
install_mac_application 'vlc' 'vlc'

# kid3
install_mac_application 'kid3' 'kid3'

# aegisub
install_mac_application 'aegisub' 'aegisub'

# steam
install_mac_application 'steam' 'steam'

# mipony
install_mac_application 'mipony' 'mipony'

# bilibili
install_mac_application 'bilibili' 'bilibili'


# ------------------------------------------------------------------------------
# other applications (will not be installed by this script)
# ------------------------------------------------------------------------------

# app in App Store e.g., pages and Xcode
# microsoft office
