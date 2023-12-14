swayidle -w timeout 300 '/home/michael/dev/dotfiles/config/hypr/scripts/lock.sh' \
            timeout 600 'hyprctl dispatch dpms off' \
            resume 'hyprctl dispatch dpms on' \
            before-sleep '/home/michael/dev/dotfiles/config/hypr/scripts/lock.sh' &