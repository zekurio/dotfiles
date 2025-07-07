#!/bin/bash

wallpapers_dir="$(xdg-user-dir PICTURES)/wall"

build_theme() {
  rows=$1
  cols=$2
  icon_size=$3

  echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:$icon_size.0000em;}listview{lines:$rows;columns:$cols;}"
}

theme="$HOME/.config/rofi/scripts/wallpaper/style.rasi"

rofi_cmd="rofi -dmenu -i -show-icons -theme-str $(build_theme 4 3 12) -theme ${theme}"

choice=$(
  ls --escape "$wallpapers_dir" |
    while read A; do echo -en "$A\x00icon\x1f$wallpapers_dir/$A\n"; done |
    $rofi_cmd
)

if [ -z "$choice" ]; then
  exit 1
fi

WALLPAPER="$wallpapers_dir/$choice"

# assert that we are running hyprpaper
hyprctl hyprpaper reload ,"$WALLPAPER" && notify-send "Wallpaper Changed" -i "$WALLPAPER" --app-name=Wallpaper

# symbolic link in ~/.current_wallpaper
ln -sf "$WALLPAPER" "$HOME/.current_wallpaper" || notify-send "Failed to create symbolic link" --app-name=Wallpaper

exit 1
