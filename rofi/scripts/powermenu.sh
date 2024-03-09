#!/bin/bash
 
lock="󱅟 Lock"
logout="󰗽 Logout"
shutdown="󰤆 Shutdown"
reboot="󰜉 Reboot"
reboot_firmware="󰒓 Reboot to UEFI"
sleep="󰤄 Suspend"
 
selected_option=$(echo "$lock
$logout
$sleep
$reboot
$reboot_firmware
$shutdown" | rofi -dmenu -i -p "Powermenu" \
		  -theme "~/.config/rofi/config.rasi")

if [ "$selected_option" == "$lock" ]
then
  ~/.config/hypr/scripts/lock.sh
elif [ "$selected_option" == "$logout" ]
then
  hyprctl dispatch exit
elif [ "$selected_option" == "$shutdown" ]
then
  systemctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
  systemctl reboot
elif [ "$selected_option" == "$reboot_firmware"]
then
  systemctl reboot --firmware-setup
elif [ "$selected_option" == "$sleep" ]
then
  systemctl suspend
else
  echo "No match"
fi