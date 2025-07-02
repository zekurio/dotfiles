#!/usr/bin/env fish

# Base margin values for different resolutions
set A_1080 400
set B_1080 400
set A_1440 530
set B_1440 530

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null
    pkill -x "wlogout"
    exit 0
end

# Detect monitor resolution and scaling factor
set monitor_info (hyprctl -j monitors | jq -r '.[] | select(.focused==true)')
set resolution (echo $monitor_info | jq -r '.height / .scale' | awk -F'.' '{print $1}')
set width (echo $monitor_info | jq -r '.width / .scale' | awk -F'.' '{print $1}')
set hypr_scale (echo $monitor_info | jq -r '.scale')

# Determine base margins based on resolution
if test $resolution -le 1200
    # 1080p and below
    set base_top $A_1080
    set base_bottom $B_1080
    set base_res 1080
else if test $resolution -le 1600
    # 1440p range
    set base_top $A_1440
    set base_bottom $B_1440
    set base_res 1440
else
    # 4K and above - scale from 1440p
    set base_top $A_1440
    set base_bottom $B_1440
    set base_res 1440
end

# Calculate scaled margins
set top_margin (awk "BEGIN {printf \"%.0f\", $base_top * $base_res * $hypr_scale / $resolution}")
set bottom_margin (awk "BEGIN {printf \"%.0f\", $base_bottom * $base_res * $hypr_scale / $resolution}")

# Launch wlogout with calculated parameters
wlogout -C $HOME/.config/wlogout/style.css -l $HOME/.config/wlogout/layout --protocol layer-shell -b 5 -T $top_margin -B $bottom_margin &