#!/bin/sh

DOTFILES="$HOME/.dotfiles"

# for g
export GOPATH="$HOME/go"

export GOROOT="$HOME/.go"

# if user is root, then exit
if [ $(id -u) -eq 0 ]; then
    echo "You are root. Please run this script as a normal user."
    exit 1
fi

# check what package manager is installed
echo "Checking for supported package managers..."
if [ -x "$(command -v apt)" ]; then
    PKG_MGR="apt"
elif [ -x "$(command -v pacman)" ]; then
    PKG_MGR="pacman"
else
    echo "No supported package manager found. This script only supports apt and pacman."
    exit 1
fi

# check if git and zsh are installed
echo "Checking for git and zsh..."
if [ -x "$(command -v git)" ] && [ -x "$(command -v zsh)" ]; then
    echo "git and zsh are already installed."
else
    echo "git and/or are not installed. Installing..."
    if [ "$PKG_MGR" = "apt" ]; then
        sudo apt update
        sudo apt install -y git zsh
    elif [ "$PKG_MGR" = "pacman" ]; then
        sudo pacman -Syu
        sudo pacman -S --noconfirm git zsh
    fi
fi

# checking if g is installed
echo "Checking for g..."
if [ -x "$(command -v g)" ]; then
    echo "g is already installed."
else
    echo "g is not installed. Installing..."
    curl -sSL https://git.io/g-install | sh -s -- -y
fi

# checking if starship is installed
echo "Checking for starship..."
if [ -x "$(command -v starship)" ]; then
    echo "starship is already installed."
else
    echo "starship is not installed. Installing..."
    if [ "$PKG_MGR" = "apt" ]; then
        curl -sS https://starship.rs/install.sh | sh
    elif [ "$PKG_MGR" = "pacman" ]; then
        sudo pacman -S --noconfirm starship
    fi
fi

# adding zsh to /etc/shells and changing shell to zsh
echo "Adding zsh to /etc/shells and changing shell to zsh..."
if ! grep -Fxq "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
    sudo chsh -s $(which zsh) $USER
else
    sudo chsh -s $(which zsh) $USER
fi

# if the user only downloaded the script, git clone the repo
echo "Cloning dotfiles repo..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/zekurio/dotfiles.git $DOTFILES
fi

# create symlinks and directories
echo "Creating symlinks..."
ln -fs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
mkdir -p $HOME/.ssh
ln -fs "${DOTFILES}/ssh/config" "${HOME}/.ssh/config"

# check if we use WSL or not for 1password agent bridge
if [[ $(grep -i microsoft /proc/version) ]]; then
    echo "Setting up 1password for WSL..."
    # check if socat is installed
    if [ -x "$(command -v socat)" ]; then
        echo "socat is already installed."
    else
        echo "socat is not installed. Installing..."
        if [ "$PKG_MGR" = "apt" ]; then
            sudo apt update
            sudo apt install -y socat
        elif [ "$PKG_MGR" = "pacman" ]; then
            sudo pacman -Syu
            sudo pacman -S --noconfirm socat
        fi
    fi
    # create .1password directory
    mkdir -p $HOME/.1password
    # uncomment the source line in .zshrc
    sed -i 's/# source $DOTFILES\/ssh\/agent-bridge.sh/source $DOTFILES\/ssh\/agent-bridge.sh/g' $HOME/.zshrc

    echo "1password is now setup for WSL. make sure npiperelay.exe is in your windows PATH."
fi
     
echo "Done, restart your terminal."