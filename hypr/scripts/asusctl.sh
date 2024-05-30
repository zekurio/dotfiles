#!/bin/bash

# controls the profiles with asusctl

# get the current profile, the profile is the last word and in uppercase
current_profile=$(asusctl profile -p | grep -oE '[^ ]+$')

# set the next profile with asusctl profile -n and do the same as above
asusctl profile -n
next_profile=$(asusctl profile -p | grep -oE '[^ ]+$')

notify-send -r 2593 -u normal "Switched from $current_profile to $next_profile"