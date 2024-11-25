# Source pywal colors
source ~/.cache/wal/colors.fish

# disable greeting
set fish_greeting

# starship
starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end
