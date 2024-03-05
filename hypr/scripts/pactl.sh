#!/bin/sh

mute_in() {
    # toggle mute
    pactl set-source-mute @DEFAULT_SOURCE@ toggle

    # play sound
    paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

    # get mute status
    mute_status=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -oE '[^ ]+$')

    # display notification
    if [ "$mute_status" = "yes" ]; then
        dunstify -r 2593 -u normal "Mute" "Microphone muted"
    else
        dunstify -r 2593 -u normal "Unmute" "Microphone unmuted"
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
        dunstify -r 2593 -u normal "Mute" "Speakers muted"
    else
        dunstify -r 2593 -u normal "Unmute" "Speakers unmuted"
    fi

}

# get our arguments
subcommand=$1

# run the appropriate function
case "$subcommand" in
    mute_in)
        mute_in ;;
    mute_out)
        mute_out ;;
esac