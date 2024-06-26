#!/bin/bash

# Pause all music players
playerctl pause

# Mute the audio
pactl set-sink-mute @DEFAULT_SINK@ true

# Lock the screen with swaylock
swaylock -f \
    --image '$(xdg-user-dir PICTURES)/Wallpapers/lock.png' \
    --clock \
    --indicator \
    --indicator-radius 100 \
    --indicator-thickness 7 \
    --effect-blur 10x5 \
    --effect-vignette 0.5:0.5 \
    --grace 0 \
    --fade-in 1.2 \
    --font "Fira Sans" \
    --inside-color 1e1e2e \
    --inside-clear-color 1e1e2e \
    --inside-ver-color 1e1e2e \
    --inside-wrong-color 1e1e2e \
    --inside-caps-lock-color 1e1e2e \
    --ring-color 6c7086 \
    --ring-clear-color f9e2af \
    --ring-ver-color 89b4fa \
    --ring-wrong-color f38ba8 \
    --ring-caps-lock-color cdd6f4 \
    --line-color 00000000 \
    --bs-hl-color f38ba8 \
    --key-hl-color a6e3a1 \
    --text-color cdd6f4 \
    --text-clear-color cdd6f4 \
    --text-ver-color cdd6f4 \
    --text-wrong-color cdd6f4 \
    --text-caps-lock-color cdd6f4
