#!/bin/bash

# if we are in WSL, we add some more packages
if [ -n "$WSL2" ]; then
    PACMAN_PACKAGES="$PACMAN_PACKAGES socat"
fi

# now we update the package lists
echo "Updating package lists..."
pacman -Syu

# now we install the packages
echo "Checking for packages..."
for package in $PACKAGES; do
    if [ -x "$(command -v $package)" ]; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing..."
        pacman -S --noconfirm $package
    fi
done

# if there are packages from the AUR, we install paru
if [ -n "$AUR_PACKAGES" ]; then
    echo "Checking for paru..."
    if [ -x "$(command -v paru)" ]; then
        echo "paru is already installed."
    else
        echo "paru is not installed. Installing..."
        pacman -S --needed --noconfirm base-devel
        git clone https://aur.archlinux.org/paru.git
        cd paru || exit
        makepkg -si
        cd .. || exit
        rm -rf paru
    fi
fi

# now we install paru from the AUR
echo "Checking for packages from the AUR..."
for package in $AUR_PACKAGES; do
    if [ -x "$(command -v "$package")" ]; then
        echo "$package is already installed."
    else
        echo "$package is not installed. Installing..."
        paru -S --noconfirm "$package"
    fi
done

# now we install packages like g which are not in the official repos
echo "Checking for g..."
if [ -x "$(command -v g)" ]; then
    echo "g is already installed."
else
    echo "g is not installed. Installing..."
    curl -sSL https://git.io/g-install | sh -s -- -y
fi