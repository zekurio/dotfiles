#!/bin/bash

# variables
theme="$HOME/.config/rofi/scripts/screenshot/style.rasi"
save_dir="$(xdg-user-dir PICTURES)/screenshots"
filename="$(date +%Y-%m-%d-%s).png"

# Check if freeze option is enabled
freeze_flag=""
if [ "$1" = "--freeze" ]; then
  freeze_flag="--freeze"
fi

# options to be displayed
region="󰆞"
output=""
folder=""

selected="$(echo -e "$region\n$output\n$folder" | rofi -dmenu -theme "${theme}")"

sleep 0.1

case $selected in
$region)
  grimblast --notify $freeze_flag copysave area "$save_dir/$filename"
  ;;
$output)
  grimblast --notify $freeze_flag copysave output "$save_dir/$filename"
  ;;
$folder)
  ~/.config/rofi/scripts/screenshot/screenshot_selection.sh
  ;;
esac