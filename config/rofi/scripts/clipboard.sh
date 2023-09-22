#!/bin/bash

theme="$HOME/.config/rofi/clipboard.rasi"

# |  | cliphist decode | wl-copy

# parse clip-hist into rofi with cliphist list
cliphist list | rofi -dmenu -i -p "Clipboard" -theme "$theme" | cliphist decode | wl-copy
