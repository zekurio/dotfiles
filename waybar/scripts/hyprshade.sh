#!/bin/bash

# Function to get the current status of the blue light filter
get_status() {
    if hyprshade current | grep -q "blue-light-filter"; then
        echo "on"
    else
        echo "off"
    fi
}

# Function to toggle the filters
toggle_filters() {
    # Get the current status
    CURRENT_STATUS=$(get_status)

    # If the blue light filter is on, toggle vibrance (which will also disable blue light filter)
    if [ "$CURRENT_STATUS" = "on" ]; then
        hyprshade toggle vibrance
    else
        # If the blue light filter is off, toggle the blue light filter
        hyprshade toggle blue-light-filter
    fi
}

# If the script is called with the "toggle" argument, perform the toggle
if [ "$1" = "toggle" ]; then
    toggle_filters
fi

# Get the current status and set the appropriate icon
STATUS=$(get_status)
if [ "$STATUS" = "on" ]; then
    echo "<span foreground='#89b4fa'>󰌵</span>"
else
    echo "<span foreground='#fab387'>󰌵</span>"
fi