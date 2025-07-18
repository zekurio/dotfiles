#!/usr/bin/env bash

# Simple Script To Pick Color Quickly.

# pick, autocopy and get the value
color=$(hyprpicker -a)

echo "$color"

if [[ "$color" ]]; then
  image=/tmp/${color}.png
  # generate preview
  convert -size 48x48 xc:"$color" "$image"
  # notify the color
  notify-send -i "$image" "$color" "Copied to clipboard"
fi