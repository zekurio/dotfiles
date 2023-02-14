#!/bin/sh

export DOTFILES="$HOME/.dotfiles"

export GOPATH="$HOME/go"

export GOROOT="$HOME/.go"

# we need at least git, zsh, starship and rustup
export PACMAN_PACKAGES="git zsh starship rustup"

export AUR_PACKAGES=""

# CHECKS

# if user is root, then exit
if [ $(id -u) -eq 0 ]; then
    echo "You are root. Please run this script as a normal user."
    exit 1
fi

# check if system is under WSL2 and set WSL=1
if [[ $(grep -i microsoft /proc/version) && $(grep -i wsl2 /proc/version) ]]; then
    echo "Running under WSL2."
    export WSL2=1
fi

# ask for sudo password upfront and keep it alive in case of sudo timeout
echo "Please enter your sudo password. This is just to make sure that you have sudo access and to keep it alive for the duration of this script."
sudo -v

# keep-alive: update existing sudo time stamp until script is done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ask the user if they want to install additional packages
echo "Do you want to install more packages from the base repos? (y/n)"
read -r answer
if [ "$answer" = "y" ]; then
    echo "Please enter the packages you want to install, separated by spaces."
    read -r more_packages
    PACMAN_PACKAGES="$PACMAN_PACKAGES $more_packages"
fi

# now we ask the user if they want to install packages from the AUR
echo "Do you want to install packages from the AUR? (y/n)"
read -r answer
if [ "$answer" = "y" ]; then
    echo "Please enter the packages you want to install, separated by spaces."
    read -r more_packages
    AUR_PACKAGES="$AUR_PACKAGES $more_packages"
fi

# Cloning dotfiles repo
echo "Cloning dotfiles repo..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/zekurio/dotfiles.git $DOTFILES
fi

# run the packages script
echo "Running packages script..."
sh $DOTFILES/scripts/packages.sh

echo "Packages script finished."

# run the folders script
echo "Running folders script..."
sh $DOTFILES/scripts/folders.sh

echo "Folders script finished."

# adding zsh to /etc/shells and changing shell to zsh
echo "Adding zsh to /etc/shells and changing shell to zsh..."
if ! grep -Fxq "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
    sudo chsh -s $(which zsh) $USER
else
    sudo chsh -s $(which zsh) $USER
fi

sed -i 's/# source $DOTFILES\/ssh\/agent-bridge.sh/source $DOTFILES\/ssh\/agent-bridge.sh/g' $HOME/.zshrc
echo "1password is now setup for WSL. make sure npiperelay.exe is in your windows PATH."
     
echo "Done, restart your terminal."