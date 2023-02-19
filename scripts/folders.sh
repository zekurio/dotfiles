#!/bin/bash

# create our folders
echo "Creating folders..."
mkdir -p "$HOME/.ssh"

# if we are in WSL, create the .1password folder
if [ -n "$WSL2" ]; then
    mkdir -p "$HOME/.1password"
fi

# create symlinks
echo "Creating symlinks..."
ln -fs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
ln -fs "${DOTFILES}/ssh/config" "${HOME}/.ssh/config"