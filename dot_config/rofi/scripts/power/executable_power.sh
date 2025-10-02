#!/bin/bash

# variables
theme="$HOME/.config/rofi/scripts/power/style.rasi"

# options to be displayed
shutdown="󰐥 Shutdown"
reboot="󰜉 Reboot"
logout="󰍃 Logout"
suspend="󰒲 Suspend"
lock="󰖔 Lock"

selected="$(echo -e "$shutdown\n$reboot\n$logout\n$suspend\n$lock" | rofi -dmenu -theme "${theme}")"

case $selected in
$shutdown)
  systemctl poweroff
  ;;
$reboot)
  systemctl reboot
  ;;
$logout)
  hyprctl dispatch exit
  ;;
$suspend)
  systemctl suspend
  ;;
$lock)
  ~/.config/hypr/scripts/hyprlock.sh
  ;;
esac
