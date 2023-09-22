#!/bin/bash

CURRENT_DOTFILES_DIR="$HOME/.dotfiles"
TMP_DIR="/tmp/dots"

mkdir -p "$TMP_DIR"

# check if DOTFILES_DIR is set
if [ -z "$DOTFILES_DIR" ]; then
    export DOTFILES_DIR="$CURRENT_DOTFILES_DIR"
fi

install_yay() {
    # check if base-devel is installed, we do this with pacman -Qq base-devel
    # if it returns nothing, we install base-devel
    echo "Checking if base-devel is installed..."
    if ! pacman -Qq base-devel &> /dev/null; then
        echo "base-devel is not installed, installing..."
        sudo pacman -S --needed --noconfirm base-devel
    fi
    echo "base-devel is installed, continuing..."

    # check if git is installed, we do this with pacman -Qq git
    echo "Checking if git is installed..."
    if ! pacman -Qq git &> /dev/null; then
        echo "git is not installed, installing..."
        sudo pacman -S --noconfirm git
    fi
    echo "git is installed, continuing..."

    # clone the yay repo into our temp directory
    echo "Cloning yay into $TMP_DIR..."
    git clone https://aur.archlinux.org/yay.git "$TMP_DIR/yay"

    # cd into the yay directory
    echo "Changing directory to $TMP_DIR/yay..."
    cd "$TMP_DIR/yay"
    makepkg -si

    # cd back into the tmp directory
    cd "$TMP_DIR"
}

packages() {
    # Programs hyprland
    HYPRLAND=(
        "hyprland"
        "swww"
        "waybar"
        "swayidle"
        "swaylock-effects"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        "rofi-lbonn-wayland-git"
        "wl-clip-persist-git"
        "libappindicator-gtk3"
        "dunst"
        "gnome-keyring"
        "grimblast-git"
    )

    # Utilities
    UTILITIES=(
        "git"
        "alacritty"
        "zsh"
        "firefox"
        "spotify-launcher"
        "webcord"
        "nautilus"
        "eog"
        "evince"
        "seahorse"
        "celluloid"
        "obsidian"
        "visual-studio-code-bin"
        "intellij-idea-ultimate-edition"
        "intellij-idea-ultimate-edition-jre"
        "1password"
        # "steam" too many dependencies to check, will do sooner or later
    )

    # Fonts
    FONTS=(
        "ttf-maple"
        "ttf-fira-sans"
        "ttf-firacode-nerd"
        "ttf-ms-win11-auto"
        "ttf-roboto-slab"
    )

    # Themes & Icons
    THEMES=(
        "catppuccin-cursors-mocha"
        "papirus-icon-theme"
        "adw-gtk3"
        "gradience"
    )

    # update the system
    echo "Updating system..."
    sudo pacman -Syu --noconfirm

    # check if yay is installed, we do this with pacman -Qq yay
    echo "Checking if yay is installed..."
    if ! pacman -Qq yay &> /dev/null; then
        echo "yay is not installed, installing..."
        install_yay
    fi

    # install the programs
    echo "Installing programs..."
    yay -S --noconfirm "${HYPRLAND_PROGRAMS[@]}" "${UTILITIES[@]}" "${FONTS[@]}" "${THEMES[@]}"
}

clone_repo() {
    # check if git is installed, we do this with pacman -Qq git
    echo "Checking if git is installed..."
    if ! pacman -Qq git &> /dev/null; then
        echo "git is not installed, installing..."
        sudo pacman -S git
    fi
    echo "git is installed, continuing..."

    # clone the repo into our temp directory
    echo "Cloning dotfiles into $DOTFILES_DIR..."
    git clone https://github.com/zekurio/dotfiles.git "$DOTFILES_DIR"
}

check() {
    echo "Checking for problems..."

    # first, check if we have a DOTFILES_DIR set
    if [ -z "$DOTFILES_DIR" ]; then
        echo "DOTFILES_DIR is not set, please set it using export DOTFILES_DIR=\"path/to/dotfiles\" and try again."
        exit 1
    fi

    # check if the DOTFILES_DIR exists
    if [ ! -d "$DOTFILES_DIR" ]; then
        echo "DOTFILES_DIR does not exist, check if you set it correctly and try again."
        exit 1
    fi

    echo "Attempting update, this also fixes symlinks."

    update

    echo "Done, if you didn't see any errors, you're good to go!"
}

symlinks() {
    CONFIG_LINKS=("alacritty" "dunst" "hypr" "rofi" "waybar" "spicetify")

    for dir in "${CONFIG_LINKS[@]}"; do
        echo "Linking $dir"
        if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
            DATE=$(date +%s)
            echo "Found existing $dir, backing up..."
            mv "$HOME/.config/$dir" "$HOME/.config/$dir.bak.$DATE"
            echo "Backed up $dir at $HOME/.config/$dir.bak.$DATE"
        fi
        ln -sf "$DOTFILES_DIR/config/$dir" "$HOME/.config/$dir"
    done

    # link zshrc
    echo "Linking zshrc"
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        DATE=$(date +%s)
        echo "Found existing zshrc, backing up..."
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$DATE"
        echo "Backed up zshrc at $HOME/.zshrc.bak.$DATE"
    fi
    ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

    # link zprofile
    echo "Linking zprofile"
    if [ -f "$HOME/.zprofile" ] && [ ! -L "$HOME/.zprofile" ]; then
        DATE=$(date +%s)
        echo "Found existing zprofile, backing up..."
        mv "$HOME/.zprofile" "$HOME/.zprofile.bak.$DATE"
        echo "Backed up zprofile at $HOME/.zprofile.bak.$DATE"
    fi
    ln -sf "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"

    # editing the zprofile, in case the user set a different
    # DOTFILES_DIR
    echo "Editing zprofile"
    sed -i "s|DOTFILES_DIR=.*|DOTFILES_DIR=\"$DOTFILES_DIR\"|" "$HOME/.zprofile"
}

update() {
    cd "$DOTFILES_DIR"

    # check if git folder exists
    if [ ! -d .git ]; then
        echo "Not in git repo, please execute this script from the root of the repo."
        exit 1
    else 
        # check if we have a remote
        if [ -z "$(git remote)" ]; then
            echo "No remote found, can't pull."
            exit 1
        else
            # do a git pull
            git pull
        fi
    fi

    # refresh the symlinks
    symlinks
}

# if no arguments are passed, we just go through the whole process
# otherwise just do the function that was passed
if [ $# -eq 0 ]; then
    packages
    clone_repo
    symlinks
else
    $1
fi