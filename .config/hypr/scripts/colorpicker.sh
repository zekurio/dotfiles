#!/usr/bin/env bash

# Simple Script To Pick Color Quickly.

# Pick, autocopy and get the value.
# The output from hyprpicker can include warnings, so we take the last word.
raw_output=$(hyprpicker -a)

if [[ -n "$raw_output" ]]; then
    color=$(echo "$raw_output" | awk '{print $NF}')

    # Create a filename-safe version of the color (removes '#')
    clean_color="${color#\#}"
    image="/tmp/$clean_color.png"

    # Generate preview
    magick -size 48x48 xc:"$color" "$image"

    # Notify the color
    notify-send -i "$image" "$color" "Copied to clipboard"
fi