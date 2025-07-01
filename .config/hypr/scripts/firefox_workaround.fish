#!/usr/bin/env fish

# Check for required dependencies
set required_commands hyprctl jq socat
for cmd in $required_commands
    if not command -v $cmd >/dev/null 2>&1
        echo "Error: Required command '$cmd' not found" >&2
        exit 1
    end
end

# Check for required environment variables
if not set -q XDG_RUNTIME_DIR
    echo "Error: XDG_RUNTIME_DIR not set" >&2
    exit 1
end

if not set -q HYPRLAND_INSTANCE_SIGNATURE
    echo "Error: HYPRLAND_INSTANCE_SIGNATURE not set" >&2
    exit 1
end

# Configurable variables
set BROWSER_CLASS "zen"
set TITLE_PREFIX "Extension:"
set TITLE_SUFFIX "— Zen Browser"
set MAX_WIDTH 540
set MAX_HEIGHT 800

function handle_browser_extension_window
    set addr $argv[1]
    set is_floating (hyprctl clients -j | jq -r --arg addr "$addr" '.[] | select(.address==$addr) | .floating')
    if test "$is_floating" != "true"
        set cmd "dispatch setfloating address:$addr;setprop address:$addr maxsize $MAX_WIDTH $MAX_HEIGHT;dispatch focuswindow address:$addr;dispatch centerwindow"
        hyprctl --quiet --batch "$cmd"
    end
end

function handle_title_change_for_browser
    set addr $argv[1]
    set title $argv[2]
    if string match -q "$TITLE_PREFIX*$TITLE_SUFFIX" "$title"
        handle_browser_extension_window "$addr"
    end
end

function handle_title_change
    # input: windowtitlev2>>ADDRESS,Title
    set window_data (string split -m 1 '>>' $argv[1])[2]
    set window_address "0x"(string split -m 1 ',' $window_data)[1]
    set window_title (string split -m 1 ',' $window_data)[2]
    set window_initial_class (hyprctl clients -j | jq -r --arg addr "$window_address" '.[] | select(.address==$addr) | .initialClass')

    if test "$window_initial_class" = "$BROWSER_CLASS"
        handle_title_change_for_browser "$window_address" "$window_title"
    end
end

function handle
    if string match -q 'windowtitlev2*' $argv[1]
        handle_title_change $argv[1]
    end
end

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -l line
    handle "$line"
end
