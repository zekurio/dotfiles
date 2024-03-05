#!/bin/bash

# race condition fix
sleep 3

# fix 96Mhz memclock on amdgpu by changing the refresh rate to 120 and then back to 165
# first change the refresh rate to 120
sed -i 's/2560x1440@165/2560x1440@120/g' ~/dev/dotfiles/config/hypr/hyprland.conf

sleep 1

# and then change it back to 165
sed -i 's/2560x1440@120/2560x1440@165/g' ~/dev/dotfiles/config/hypr/hyprland.conf