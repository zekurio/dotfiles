#!/bin/bash

# controls the profiles with asusctl
# when called, cycles through the profiles, pushes a notification with notify-send

# get the current profile, the profile is the last word and in uppercase
current_profile=$(asusctl profile -p | grep -oE '[^ ]+$')

# set the next profile with asusctl profile -n and do the same as above
asusctl profile -n
next_profile=$(asusctl profile -p | grep -oE '[^ ]+$')

# send a notification with notify-send
dunstify -r 2593 -u normal "Asusctl" "Switched from $current_profile to $next_profile"