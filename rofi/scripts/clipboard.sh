#!/bin/bash

theme="$HOME/.config/rofi/config.rasi"

# |  | cliphist decode | wl-copy

# parse clip-hist into rofi with cliphist list
cliphist list | rofi -dmenu -i -p "Clipboard" -theme "$theme" | cliphist decode | wl-copy
