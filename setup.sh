#!/bin/bash

export DOTFILES="$HOME/.dotfiles"

export GOPATH="$HOME/go"

export GOROOT="$HOME/.go"

# we need at least git, zsh, starship and rustup
export PACMAN_PACKAGES="git zsh starship rustup"

export AUR_PACKAGES=""

# CHECKS

# check if the script is being run as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root."
    exit
fi

# check if system is under WSL2 and set WSL=1
# use grep -p instead of [[ ]] to avoid errors
# use without &> /dev/null to avoid errors
if grep -qEi "(Microsoft|WSL)" /proc/version > /dev/null 2>&1 ; then
    echo "Running under WSL2."
    export WSL2=1
fi

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
    git clone https://github.com/zekurio/dotfiles.git "$DOTFILES"
fi

# run the packages script
echo "Running packages script..."
sh "$DOTFILES/scripts/packages.sh"

echo "Packages script finished."

# run the folders script
echo "Running folders script..."
sh "$DOTFILES/scripts/folders.sh"

echo "Folders script finished."

# adding zsh to /etc/shells and changing shell to zsh
echo "Adding zsh to /etc/shells and changing shell to zsh..."
if ! grep -Fxq "$(which zsh)" /etc/shells; then
    "$(which zsh)" | tee -a /etc/shells
    chsh -s "$(which zsh) $USER"
else
    chsh -s "$(which zsh) $USER"
fi

sed -i "s/# source $DOTFILES\/ssh\/agent-bridge.sh/source $DOTFILES\/ssh\/agent-bridge.sh/g" "$HOME/.zshrc"
echo "1password is now setup for WSL. make sure npiperelay.exe is in your windows PATH."
     
echo "Done, restart your terminal."