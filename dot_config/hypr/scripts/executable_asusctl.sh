#!/usr/bin/env bash

# Function to get the current keyboard backlight level
get_keyboard_level() {
    asusctl -k | awk '{print $NF}'
}

# Function to get the current active performance profile
get_current_profile() {
    asusctl profile -p | grep 'Active profile is' | awk '{print $NF}'
}

# Function to increase the keyboard backlight level
increase_keyboard() {
    local current_level
    current_level=$(get_keyboard_level)
    if [[ "$current_level" != "High" ]]; then
        asusctl -n
    fi
}

# Function to decrease the keyboard backlight level
decrease_keyboard() {
    local current_level
    current_level=$(get_keyboard_level)
    if [[ "$current_level" != "Off" ]]; then
        asusctl -p
    fi
}

# Function to cycle to the next performance profile and send a notification
cycle_profile() {
    local old_profile
    local new_profile
    old_profile=$(get_current_profile)
    asusctl profile -n
    new_profile=$(get_current_profile)

    # Send a notification about the profile change
    notify-send "ASUS Profile" "Switched from $old_profile to $new_profile" --icon=preferences-system
}

# Function to display the current performance profile
show_profile() {
    get_current_profile
}

# Function to display usage instructions
show_usage() {
    echo "Usage: $0 [increase|decrease|cycle|profile]"
    echo "  increase  - Increase keyboard backlight level"
    echo "  decrease  - Decrease keyboard backlight level"
    echo "  cycle     - Cycle to next performance profile"
    echo "  profile   - Show current performance profile"
}

# Main script logic to handle command-line arguments
case "$1" in
    increase)
        increase_keyboard
        ;;
    decrease)
        decrease_keyboard
        ;;
    cycle)
        cycle_profile
        ;;
    profile)
        show_profile
        ;;
    *)
        show_usage
        exit 1
        ;;
esac