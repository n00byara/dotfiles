#!/bin/bash

IMAGES_PATH=$(pwd)/src/icons 

get_play_pause_icon () {
    case "$(playerctl status)" in
        "Playing")
            echo $IMAGES_PATH/pause.svg
        ;;
        "Paused")
            echo $IMAGES_PATH/play.svg
        ;;
        *)
            echo $IMAGES_PATH/music_off.svg
        ;;
    esac
}

get_volume_icon () {
    off=$(amixer -D pulse sget Master | awk -F '\\[*\\]' '/Left:/{print $2}')
    volume=$(amixer -D pulse sget Master | awk -F '[^0-9]+' '/Left:/{print $3}')

    if [[ (${#off} -eq "5") ]]; then
        echo $IMAGES_PATH/no_sound.svg
        exit
    elif [[ $volume == 0 ]]; then
        echo $IMAGES_PATH/volume_0.svg
    elif [[ $volume < 33 ]]; then
        echo $IMAGES_PATH/volume_1.svg
    elif [[ $volume < 66 ]]; then
        echo $IMAGES_PATH/volume_2.svg
    elif [[ $volume > 66 ]]; then
        echo $IMAGES_PATH/volume_3.svg
    fi

}

set_play_pause () {
    playerctl play-pause
}

call_next () {
    playerctl next
}

call_previous () {
    playerctl previous
}

get_music_image () {
    url=$(playerctl metadata --format "{{ mpris:artUrl }}")
    echo "${url#*//}"
}

set_volume () {
    seconds=$1
    position=$(playerctl metadata --format '{{ position }}')

    if [[ $position -gt $seconds ]]; then
        duration+=$((($position-$seconds)/1000000))
        $(playerctl position $duration-)
    else
        duration+=$((($seconds-$position)/1000000))
        $(playerctl position $duration+)
    fi
}

case "$1" in
    "play_pause_icon")
        get_play_pause_icon
    ;;
    "play_pause")
        set_play_pause
    ;;
    "next")
        call_next
    ;;
    "previous")
        call_previous
    ;;
    "music_image")
        get_music_image
    ;;
    "set_volume")
        set_volume "$2"
    ;;
    "get_volume")
        get_volume_icon
    ;;
esac

exit