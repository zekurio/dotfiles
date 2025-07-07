#!/usr/bin/env bash

if pgrep -x "hyprlock" > /dev/null; then
    pkill -x "hyprlock"
    exit 0
fi

# pause playerctl playback
playerctl pause

hyprlock &