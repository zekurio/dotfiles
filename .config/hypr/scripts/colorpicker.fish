#!/usr/bin/env fish

# Simple Script To Pick Color Quickly.

# Pick, autocopy and get the value.
# The output from hyprpicker can include warnings, so we take the last word.
set raw_output (hyprpicker -a)

if test -n "$raw_output"
    set color (string split ' ' -- $raw_output)[-1]

    # Create a filename-safe version of the color (removes '#')
    set clean_color (string replace '#' '' -- $color)
    set image /tmp/$clean_color.png

    # Generate preview
    convert -size 48x48 xc:"$color" "$image"

    # Notify the color
    notify-send -i "$image" "$color" "Copied to clipboard"
end