#!/bin/bash

mute_in() {
    # toggle mute
    pactl set-source-mute @DEFAULT_SOURCE@ toggle

    # play sound
    paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

    # get mute status
    mute_status=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -oE '[^ ]+$')

    # display notification
    if [ "$mute_status" = "yes" ]; then
        notify-send -r 2593 -u normal "Mute" "Microphone muted"
    else
        notify-send -r 2593 -u normal "Unmute" "Microphone unmuted"
    fi
}

mute_out() {

    # toggle mute
    pactl set-sink-mute @DEFAULT_SINK@ toggle

    # play sound
    paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

    # get mute status
    mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oE '[^ ]+$')

    # display notification
    if [ "$mute_status" = "yes" ]; then
        notify-send -r 2593 -u normal "Mute" "Speakers muted"
    else
        notify-send -r 2593 -u normal "Unmute" "Speakers unmuted"
    fi

}

subcommand=$1
case "$subcommand" in
    mute_in)
        mute_in ;;
    mute_out)
        mute_out ;;
esac