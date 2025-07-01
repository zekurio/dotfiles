#!/usr/bin/env fish

# colorpicker.fish - Hyprland color picker utility with notifications
# Usage: colorpicker.fish

# Required packages
set -l required_packages hyprpicker libnotify imagemagick wl-clipboard

# Check for required packages
function check_dependencies
    set -l missing_packages
    
    for package in $required_packages
        switch $package
            case libnotify
                if not command -q notify-send
                    set -a missing_packages libnotify
                end
            case imagemagick
                if not command -q convert
                    set -a missing_packages imagemagick
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

# Setup temporary directory for icons
function setup_temp_dir
    set -l temp_dir "/tmp/colorpicker"
    
    if not test -d $temp_dir
        if mkdir -p $temp_dir
            chmod 755 $temp_dir
        else
            echo "Failed to create temp directory: $temp_dir"
            return 1
        end
    end
    
    echo $temp_dir
end

# Generate colored square icon
function generate_color_icon
    set -l color $argv[1]
    set -l temp_dir (setup_temp_dir)
    
    if test $status -ne 0
        return 1
    end
    
    # Remove # from color if present
    set -l clean_color (string replace '#' '' $color)
    set -l icon_path "$temp_dir/color_$clean_color.png"
    
    # Create 64x64 colored square
    if convert -size 64x64 "xc:#$clean_color" $icon_path
        echo $icon_path
        return 0
    else
        echo "Failed to generate color icon"
        return 1
    end
end

# Send notification with color info and icon
function send_notification
    set -l color $argv[1]
    set -l icon_path $argv[2]
    
    set -l title "Color Picked"
    set -l body "Color: $color\nCopied to clipboard!"
    
    notify-send -i $icon_path -t 5000 "$title" "$body"
end

# Pick color using hyprpicker
function pick_color
    echo "Click to pick a color..."
    
    # Use hyprpicker to pick color
    set -l picked_color (hyprpicker -a)
    
    if test $status -eq 0 -a -n "$picked_color"
        echo "Picked color: $picked_color"
        
        # Copy to clipboard
        echo -n $picked_color | wl-copy
        
        # Generate icon for the color
        set -l icon_path (generate_color_icon $picked_color)
        
        if test $status -eq 0
            # Send notification with color icon
            send_notification $picked_color $icon_path
        else
            # Fallback notification without custom icon
            notify-send -t 5000 "Color Picked" "Color: $picked_color\nCopied to clipboard!"
        end
        
        return 0
    else
        echo "Color picking cancelled or failed"
        return 1
    end
end

# Main function
function main
    # Check dependencies first
    if not check_dependencies
        return 1
    end
    
    pick_color
end

# Run main function
main $argv