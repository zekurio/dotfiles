#!/usr/bin/env bash

# Configurable variables
BROWSER_CLASS="zen"
TITLE_PREFIX="Extension:"
TITLE_SUFFIX="— Zen Browser"
MAX_WIDTH=540
MAX_HEIGHT=800

handle_browser_extension_window() {
    local addr="$1"
    is_floating=$(hyprctl clients -j | jq -r --arg addr "$addr" '.[] | select(.address==$addr) | .floating')
    if [ "$is_floating" != "true" ]; then
        cmd=$(printf 'dispatch setfloating address:%s;setprop address:%s maxsize %d %d;dispatch focuswindow address:%s;dispatch centerwindow' \
            "$addr" "$addr" "$MAX_WIDTH" "$MAX_HEIGHT" "$addr")
        hyprctl --quiet --batch "$cmd"
    fi
}

handle_title_change_for_browser() {
    local addr="$1"
    local title="$2"
    case "$title" in
        "${TITLE_PREFIX}"*"$TITLE_SUFFIX") handle_browser_extension_window "$addr";;
    esac
}

handle_title_change() {
    # input: windowtitlev2>>ADDRESS,Title
    window_data=$(printf "%s" "$1" | awk -F'>>' '{print $2}')
    window_address=$(printf "0x%s" "$window_data" | awk -F',' '{print $1}')
    window_title=$(printf "%s" "$window_data" | awk -F',' '{print $2}')
    window_initial_class=$(hyprctl clients -j | jq -r --arg addr "$window_address" '.[] | select(.address==$addr) | .initialClass')

    case "$window_initial_class" in
        "$BROWSER_CLASS") handle_title_change_for_browser "$window_address" "$window_title";;
    esac
}

handle() {
    case "$1" in
        windowtitlev2*) handle_title_change "$1";;
    esac
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
    | while read -r line; do handle "$line"; done
