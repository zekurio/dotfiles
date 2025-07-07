#!/usr/bin/env fish

function get_keyboard_level
    asusctl -k | string split ' ' | tail -n 1
end

function get_current_profile
    set -l profile_output (asusctl profile -p)
    echo $profile_output | string match -r 'Active profile is (.+)' | string split ' ' | tail -n 1
end

function increase_keyboard
    set -l current_level (get_keyboard_level)
    if test "$current_level" != "High"
        asusctl -n
    end
end

function decrease_keyboard
    set -l current_level (get_keyboard_level)
    if test "$current_level" != "Off"
        asusctl -p
    end
end

function cycle_profile
    set -l old_profile (get_current_profile)
    asusctl profile -n
    set -l new_profile (get_current_profile)
    
    # Send notification about profile change
    notify-send "ASUS Profile" "Switched from $old_profile to $new_profile" --icon=preferences-system
end

function show_profile
    get_current_profile
end

function show_usage
    echo "Usage: $argv[0] [increase|decrease|cycle|profile]"
    echo "  increase  - Increase keyboard backlight level"
    echo "  decrease  - Decrease keyboard backlight level"
    echo "  cycle     - Cycle to next performance profile"
    echo "  profile   - Show current performance profile"
end

# Main script logic
set -l command $argv[1]

switch $command
    case 'increase'
        increase_keyboard
    case 'decrease'
        decrease_keyboard
    case 'cycle'
        cycle_profile
    case 'profile'
        show_profile
    case '*'
        show_usage
        exit 1
end