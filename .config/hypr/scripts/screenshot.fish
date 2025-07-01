#!/usr/bin/env fish

# screenshot.fish - Hyprland screenshot utility
# Usage: screenshot.fish [selection|window|screen]

# Required packages
set -l required_packages grim slurp wl-clipboard libnotify hyprland

# Check for required packages
function check_dependencies
    set -l missing_packages
    
    for package in $required_packages
        switch $package
            case hyprland
                if not command -q hyprctl
                    set -a missing_packages hyprland
                end
            case libnotify
                if not command -q notify-send
                    set -a missing_packages libnotify
                end
            case wl-clipboard
                if not command -q wl-copy
                    set -a missing_packages wl-clipboard
                end
            case '*'
                if not command -q $package
                    set -a missing_packages $package
                end
        end
    end
    
    if test (count $missing_packages) -gt 0
        echo "Missing required packages: $missing_packages"
        echo "Install with: sudo pacman -S $missing_packages"
        return 1
    end
    
    return 0
end

# Setup screenshot directory
function setup_screenshot_dir
    set -l xdg_pictures (xdg-user-dir PICTURES 2>/dev/null; or echo "$HOME/Pictures")
    set -l screenshot_dir "$xdg_pictures/Screenshots"
    
    if not test -d $screenshot_dir
        if mkdir -p $screenshot_dir
            chmod 755 $screenshot_dir
            echo "Created screenshot directory: $screenshot_dir"
        else
            echo "Failed to create screenshot directory: $screenshot_dir"
            return 1
        end
    end
    
    echo $screenshot_dir
end

# Generate filename with timestamp
function generate_filename
    set -l timestamp (date +"%Y-%m-%d_%H-%M-%S")
    echo "screenshot_$timestamp.png"
end

# Send notification with screenshot preview
function send_notification
    set -l filepath $argv[1]
    set -l mode $argv[2]
    
    set -l title "Screenshot Saved"
    set -l body "Mode: $mode\nSaved to: $filepath"
    
    notify-send -i $filepath -t 5000 $title $body
end

# Take screenshot based on mode
function take_screenshot
    set -l mode $argv[1]
    set -l screenshot_dir (setup_screenshot_dir)
    
    if test $status -ne 0
        return 1
    end
    
    set -l filename (generate_filename)
    set -l filepath "$screenshot_dir/$filename"
    
    switch $mode
        case selection
            echo "Select area for screenshot..."
            if grim -g (slurp -d) $filepath
                wl-copy < $filepath
                send_notification $filepath "Selection"
                echo "Screenshot saved: $filepath"
            else
                echo "Screenshot cancelled or failed"
                return 1
            end
            
        case window
            echo "Taking window screenshot..."
            set -l window_info (hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
            
            if test -n "$window_info"
                if grim -g $window_info $filepath
                    wl-copy < $filepath
                    send_notification $filepath "Active Window"
                    echo "Screenshot saved: $filepath"
                else
                    echo "Failed to take window screenshot"
                    return 1
                end
            else
                echo "No active window found"
                return 1
            end
            
        case screen
            echo "Taking full screen screenshot..."
            if grim $filepath
                wl-copy < $filepath
                send_notification $filepath "Full Screen"
                echo "Screenshot saved: $filepath"
            else
                echo "Failed to take screen screenshot"
                return 1
            end
            
        case '*'
            echo "Invalid mode: $mode"
            echo "Usage: screenshot.fish [selection|window|screen]"
            return 1
    end
end

# Main function
function main
    # Check dependencies first
    if not check_dependencies
        return 1
    end
    
    # Check if jq is available for window mode
    if not command -q jq
        echo "Warning: jq not found. Window mode may not work properly."
        echo "Install with: sudo pacman -S jq"
    end
    
    set -l mode $argv[1]
    
    # Default to selection if no argument provided
    if test -z "$mode"
        set mode selection
    end
    
    take_screenshot $mode
end

# Run main function with all arguments
main $argv