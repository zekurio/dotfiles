# Wallpapers Path
wallpaperDir="$(xdg-user-dir PICTURES)/Wallpaper"
themesDir="$HOME/.config/rofi/presets"

# Transition config
FPS=165
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Retrieve image files as a list
PICS=($(find "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort ))

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper.rasi"

# Execute command for wallpaper
executeCommand() {
  if command -v swww &>/dev/null; then
    swww img "$1" ${SWWW_PARAMS}
  else
    echo "swww is not installed."
    exit 1
  fi

  ln -sf "$1" "$HOME/.current_wallpaper"
  
  # Generate color scheme with pywal
  if command -v wal &>/dev/null; then
    wal -i "$HOME/.current_wallpaper" -n --saturate 0.3
  else
    echo "pywal is not installed."
    exit 1
  fi

  # Reapply theme to gradience
  if command -v gradience-cli &>/dev/null; then
    gradience-cli apply -n pywal --gtk both
  else
    echo "gradience-cli is not installed."
    exit 1
  fi

  # Reapply theme to firefox
  if command -v pywalfox &>/dev/null; then
    pywalfox update
  else
    echo "pywalfox is not installed."
    exit 1
  fi

  # Reapply theme to waybar
  if command -v waybar &>/dev/null; then
    pkill waybar
    waybar &
  else
    echo "waybar is not installed."
    exit 1
  fi

  # Reapply theme to spicetify
}

# Show the images
menu() {

  printf "$randomChoice\n"

  for i in "${!PICS[@]}"; do
  
    # If not *.gif, display
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(basename "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${PICS[$i]}\n"
    else
    # Displaying .gif to indicate animated images
      printf "$(basename "${PICS[$i]}")\n"
    fi
  done
}

# If swww exists, start it
if command -v swww &>/dev/null; then
  swww query || swww-daemon
fi

# Execution
main() {
  choice=$(menu | ${rofiCommand})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$randomChoice" ]; then
    executeCommand "${randomPicture}"
    return 0
  fi

  # Find the selected file
  for file in "${PICS[@]}"; do
  # Getting the file
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selectedFile="$file"
      break
    fi
  done

  # Check the file and execute
  if [[ -n "$selectedFile" ]]; then
    executeCommand "${selectedFile}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main