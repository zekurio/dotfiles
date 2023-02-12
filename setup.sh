#!/bin/sh

DOTFILES="$HOME/.dotfiles"

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
    echo "No supported package manager found. This script only supports apt, apt-get, and pacman."
    exit 1
fi

# check if git and zsh are installed
echo "Checking for git and zsh..."
if [ -x "$(command -v git)" ] && [ -x "$(command -v zsh)" ] && [ -x "$(command -v socat)"]; then
    echo "git, zsh and socat are already installed."
else
    echo "git, zsh and/or socat are not installed. Installing..."
    if [ "$PKG_MGR" = "apt" ]; then
        sudo apt update
        sudo apt install -y git zsh socat
    elif [ "$PKG_MGR" = "pacman" ]; then
        sudo pacman -Syu
        sudo pacman -S --noconfirm git zsh socat
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
mkdir -p $HOME/.1password

echo "Done, restart your terminal."