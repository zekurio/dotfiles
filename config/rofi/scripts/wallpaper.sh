#!/bin/bash

WALLPAPERS_DIR="$HOME/dev/dotfiles/walls"
THUMBNAILS_DIR="$HOME/.cache/rofi_thumbnails" # Directory to store thumbnails

# Ensure the thumbnails directory exists
mkdir -p "$THUMBNAILS_DIR"

# we need to get the first argument to know if we're booting or not
if [[ "$1" == "boot" ]]; then
    current_wallpaper="$(readlink -f "$WALLPAPERS_DIR/current.wall")"

    if [[ "$current_wallpaper" =~ \.mp4$ ]]; then
        mpvpaper -o "no-audio --loop-playlist" '*' "$current_wallpaper" & disown
    else # otherwise we stick to swww
        swww init
        swww img "$current_wallpaper"
    fi
    exit 0
fi

build_theme() {
    rows=$1
    cols=$2
    icon_size=$3

    echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:$icon_size.0000em;}listview{lines:$rows;columns:$cols;}"
}

get_thumbnail() {
    input_file="$1"

    if [[ "$input_file" == "$WALLPAPERS_DIR/current.wall" ]]; then
        input_file="$(readlink -f "$input_file")"
    fi

    thumbnail_path="$THUMBNAILS_DIR/$(basename "$input_file").png"

    if [[ "$input_file" =~ \.(gif|mp4)$ ]]; then
        if [[ ! -f "$thumbnail_path" ]]; then
            ffmpeg -v quiet -i "$input_file" -vf "thumbnail,scale=1920:-2:flags=lanczos" -frames:v 1 "$thumbnail_path"
        fi
    else # if it's not a gif or mp4, we just use the file itself
        thumbnail_path="$input_file"
    fi


    echo "$thumbnail_path"
}

theme="$HOME/.config/rofi/wallpaper.rasi"

ROFI_CMD="rofi -dmenu -i -show-icons -theme-str $(build_theme 3 6 6) -theme ${theme}"

choice=$(\
    ls --escape "$WALLPAPERS_DIR" | \
        while read A; do
            thumbnail=$(get_thumbnail "$WALLPAPERS_DIR/$A")
            echo -en "$A\x00icon\x1f$thumbnail\n"
        done | \
        $ROFI_CMD -p "Wallpaper" \
)

# if the user didn't choose anything, we exit
if [[ -z "$choice" ]]; then
    exit 0
fi

wallpaper="$WALLPAPERS_DIR/$choice"

if [[ "$wallpaper" =~ \.mp4$ ]]; then
    pkill swww

    pkill mpvpaper

    mpvpaper -o "no-audio --loop-playlist" '*' "$wallpaper" & disown && \
    ln -sf "$wallpaper" "$WALLPAPERS_DIR"/current.wall
else # otherwise we stick to swww
    # kill mpvpaper if it's running
    pkill mpvpaper

    # if swww is not running, we start it
    if ! pgrep swww; then
        swww init
    fi

    swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration 1 --transition-step 255 --transition-fps 165 "$wallpaper" && \
    ln -sf "$wallpaper" "$WALLPAPERS_DIR"/current.wall
fi

exit 0