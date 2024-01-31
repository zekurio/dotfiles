#!/bin/bash

WALLPAPERS_DIR="$(xdg-user-dir PICTURES)/Walls"

current_wallpaper="$(readlink -f "$WALLPAPERS_DIR/current.wall")"

build_theme() {
    rows=$1
    cols=$2
    icon_size=$3

    echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:$icon_size.0000em;}listview{lines:$rows;columns:$cols;}"
}

theme="$HOME/.config/rofi/wallpaper.rasi"

ROFI_CMD="rofi -dmenu -i -show-icons -theme-str $(build_theme 3 6 6) -theme ${theme}"

choice=$(\
    ls --escape "$WALLPAPERS_DIR" | \
        while read A; do
            echo -en "$A\x00icon\x1f$WALLPAPERS_DIR/$A\n"
        done | \
        $ROFI_CMD -p "Wallpaper" \
)

# if the user didn't choose anything, we exit
if [[ -z "$choice" ]]; then
    exit 0
fi

wallpaper="$WALLPAPERS_DIR/$choice"

# if swww is not running, we start it
if ! pgrep swww; then
    swww init
fi

swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration 1 --transition-step 255 --transition-fps 165 "$wallpaper" && \
ln -sf "$wallpaper" "$WALLPAPERS_DIR"/current.wall

exit 0