#!/usr/bin/env bash

# Base margin values for different resolutions
A_1080=400
B_1080=400
A_1440=530
B_1440=530

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
monitor_info=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true)')
resolution=$(echo "$monitor_info" | jq -r '.height / .scale' | awk -F'.' '{print $1}')
hypr_scale=$(echo "$monitor_info" | jq -r '.scale')

# Determine base margins based on resolution
if [[ $resolution -le 1200 ]]; then
    # 1080p and below
    base_top=$A_1080
    base_bottom=$B_1080
    base_res=1080
elif [[ $resolution -le 1600 ]]; then
    # 1440p range
    base_top=$A_1440
    base_bottom=$B_1440
    base_res=1440
else
    # 4K and above - scale from 1440p
    base_top=$A_1440
    base_bottom=$B_1440
    base_res=1440
fi

# Calculate scaled margins
top_margin=$(awk "BEGIN {printf \"%.0f\", $base_top * $base_res * $hypr_scale / $resolution}")
bottom_margin=$(awk "BEGIN {printf \"%.0f\", $base_bottom * $base_res * $hypr_scale / $resolution}")

# Launch wlogout with calculated parameters
wlogout -C "$HOME/.config/wlogout/style.css" -l "$HOME/.config/wlogout/layout" --protocol layer-shell -b 5 -T "$top_margin" -B "$bottom_margin" &