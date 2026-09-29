#!/bin/bash

POS_X=1202
POS_Y=796 
WIDTH=718
HEIGHT=404 
I3_MPV_MARK=""

get_mpv_window_id() {
    xdotool search ' - mpv' 2> /dev/null
}

get_mode() {
    window_id="${1}"
    window_json="$(i3-msg -t get_tree | jq -r --argjson target "${window_id}" ' .. | objects | select(.window? == $target)')"
    is_window_floating="$(echo "${window_json}" | jq '.floating' | tr -d '"')"
    is_on_scratchpad="$(echo "${window_json}" | jq '.output' | tr -d '"')"
    # echo "get_mode():---${is_window_floating}---${is_on_scratchpad}---"
    if [[ ${is_window_floating} == 'user_off' ]]; then
        echo 'tiled'
    else 
        if [[ ${is_on_scratchpad} == '__i3' ]]; then
            echo 'hidden'
        else 
            echo 'corner' 
        fi
    fi
}

unpause_video() { 
    # echo '{"command": ["set_property", "pause", false]}' | socat - "UNIX-CONNECT:${MPV_SOCKET}"
    xdotool key --window "${1}" p
    echo 'unpaused'
}

pause_video() { 
    # echo '{"command": ["set_property", "pause", true]}' | socat - "UNIX-CONNECT:${MPV_SOCKET}"
    xdotool key --window "${1}" p
    echo 'paused'
}

hide_window() {
    # i3-msg "[id=${1}] sticky disable"
    # i3-msg "[id=${1}] move window to scratchpad"
    i3-msg "[id=${1}] move scratchpad"
}

show_window() {
    mpv_window="${1}"
    i3-msg "[id=${mpv_window}] show scratchpad"
}

push_to_corner() {
    mpv_window="${1}"
    I3_LAPTOP_WORKSPACE="$(i3-msg -t get_workspaces | jq 'map(select(.output == "eDP-1")) | map(select(.visible)) .[] .num')"
    i3-msg "[id=${mpv_window}] move window to workspace ${I3_LAPTOP_WORKSPACE}"
    xdotool windowmove -sync "${mpv_window}" ${POS_X} ${POS_Y}
    xdotool windowsize -sync "${mpv_window}" ${WIDTH} ${HEIGHT}
    # i3-msg "[id=${mpv_window}] floating enable"
    i3-msg "[id=${mpv_window}] sticky enable"
}

main() {
    mpv_window="$(get_mpv_window_id)"
    echo "window id: ${mpv_window}"
    mpv_mode="$(get_mode "${mpv_window}")"
    echo "mode: ${mpv_mode}"
    if [[ "${mpv_mode}" == "tiled" ]]; then
        echo 'new mode: corner'
        i3-msg "[id=${mpv_window}]" floating enable
        mpc pause
        push_to_corner "${mpv_window}"
    elif [[ "${mpv_mode}" == "hidden" ]]; then
        echo 'new mode: corner'
        show_window "${mpv_window}"
        mpc pause
        push_to_corner "${mpv_window}"
        unpause_video "${mpv_window}"
    elif [[ "${mpv_mode}" == "corner" ]]; then
        echo 'new mode: hidden'
        hide_window "${mpv_window}"
        pause_video "${mpv_window}"
    else
        echo "Invalid window mode: ${mpv_mode}"
        exit 2 
    fi
}

main

