#!/bin/bash

# Fetch player status
status=$(playerctl -p spotify status)

# Fetch current track information
artist=$(playerctl -p spotify metadata artist)
title=$(playerctl -p spotify metadata title)

# Determine icon color based on player status
if [ "$status" = "Playing" ]; then
  icon="<span foreground='#a6e3a1'></span>"
elif [ "$status" = "Paused" ]; then
  icon="<span foreground='#45475a'></span>"
else
  icon="" # Default icon without color
fi

# Output JSON formatted string for Waybar
echo "{\"text\": \"$icon $artist - $title\", \"class\": \"$status\", \"alt\": \"$status\", \"tooltip\": \"${artist} - ${title}\"}"
