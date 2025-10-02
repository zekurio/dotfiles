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

# If the wallpaper is a GIF, extract the first frame for notification
if [[ "$WALLPAPER" =~ \.gif$ ]]; then
  TMP_IMG="$(mktemp --suffix=.png)"
  ffmpeg -y -i "$WALLPAPER" -vf "select=eq(n\,0)" -vframes 1 "$TMP_IMG" >/dev/null 2>&1
  NOTIFY_IMG="$TMP_IMG"
else
  NOTIFY_IMG="$WALLPAPER"
fi

# Set wallpaper using swww
swww img "$WALLPAPER" --transition-type center --transition-fps 60 && notify-send "Wallpaper Changed" -i "$NOTIFY_IMG" --app-name=Wallpaper

# Clean up temp image if created
if [[ -n "$TMP_IMG" && -f "$TMP_IMG" ]]; then
  rm "$TMP_IMG"
fi

exit 0
