swayidle -w timeout 30 '/home/michael/dev/dotfiles/config/hypr/scripts/lock.sh' \
            timeout 60 'hyprctl dispatch dpms off' \
            resume 'hyprctl dispatch dpms on' \
            timeout 90 'systemctl suspend' \
            before-sleep '/home/michael/dev/dotfiles/config/hypr/scripts/lock.sh' &