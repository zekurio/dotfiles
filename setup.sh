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
for pkg in git zsh; do
    if ! [ -x "$(command -v $pkg)" ]; then
        echo "$pkg is not installed. Installing $pkg..."
        if [ "$PKG_MGR" = "apt" ]; then
            sudo apt update
            sudo apt install $pkg
        elif [ "$PKG_MGR" = "pacman" ]; then
            sudo pacman -Syu
            sudo pacman -S $pkg
        fi
    fi
done


# add zsh to /etc/shells
echo "Adding zsh to /etc/shells..."
if ! grep -Fxq "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
fi

# change shell to zsh
echo "Changing shell to zsh..."
chsh -s $(which zsh)

# if the user only downloaded the script, git clone the repo
echo "Cloning dotfiles repo..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/zekurio/dotfiles.git $DOTFILES
fi

# create symlinks for our dotfiles
echo "Creating symlinks..."
ln -fs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
mkdir -p ~/.ssh
ln -fs "${DOTFILES}/ssh/config" "${HOME}/.ssh/config"