#!/bin/bash
shopt -s extglob
icon=""

help() {
    echo "Usage $0 {connect|disconnect|toggle|status} \$MAC_ADDR"
}

##################################
# Check/list what devices are connected
##################################
get_status() {
    device="$1" #uuid
    if [[ "$(is_device_connected $device)" == 'yes' ]]; then
        echo "$icon $(get_device_name $device)" 
    else
        echo "$icon None"
    fi
}

get_device_name() {
    mac="$1"
    echo -e "info $mac" | bluetoothctl | grep Name | head -1 | cut -f2- -d' '
}

list_connected_devices() {
    #check all paired devices and if connected and get name
    name=""
    while IFS= read -r uuid; do
        if [[ "$(is_device_connected $uuid)" == 'yes' ]]; then
            name="$name, $(get_device_name $uuid)"
        fi
    done <<< "$(echo -e "paired-devices" | bluetoothctl | grep '^Device' | cut -f2 -d' ')"
    [[ -n "$name" ]] && echo "$icon $name" | sed -e 's/^[, ]*//' || echo "$icon None"
}

##################################
# Handle connecting to devices 
##################################
is_device_connected() {
    device="$1" #uuid
    status="$(echo -e "info $device" | bluetoothctl | grep Connected | cut -d':' -f2)"
    [[ "$status" =~ 'yes' ]] && echo "yes" || echo "no"
}

change_output() {
    case "$1" in
        'speakers' ) sink=1 ;;
        'both'     ) sink=2 ;;
        'bluetooth')  sink=3 ;;
        *) echo "Error: invalid sink" && exit 1
    esac
    sink="$(pactl list sinks | grep Name | cut -f2- -d' ' | head -n "$sink" | tail -1)"
    pactl set-default-sink "$sink"
    pactl list short sink-inputs | while read stream; do
        pactl move-sink-input "$(echo $stream|cut '-d ' -f1)" "$sink"
    done
}

disconnect() {
    echo -e "disconnect\n" | bluetoothctl > /dev/null 2>&1
    mpc pause
    change_output 'speakers'
}

connect() {
    device="$1"  # a uuid
    if [[ "$(is_device_connected $device)" == 'no' ]]; then
        echo -e "connect $device\n" | bluetoothctl
    fi
    sleep 5
    change_output 'bluetooth'
}

toggle() {
    device="$1"
    status="$(is_device_connected $device)"
    case "$status" in
        "no") connect "$device" ;;
        "yes") disconnect ;;
        *) echo "Error: invalid status message $status" && exit 1
    esac
}

main() {
    mode="$1"
    device="$2"
    case "$mode" in
        connect) 
            connect "$device" 
            sleep 1
            polybar-msg action "#bluetooth.hook.0" 
            ;;
        disconnect) 
            disconnect "$device" 
            sleep 1
            polybar-msg action "#bluetooth.hook.0" 
            ;;
        toggle)
            toggle "$device" 
            sleep 1
            polybar-msg action "#bluetooth.hook.0" 
            ;;
        status) 
            get_status "$device" 
            ;;
        *) help && exit 1 ;;
    esac
}

##################################
# Handle args
##################################
# Set default args if not given
[[ -n "$1" ]] && mode="$1" || mode='toggle'
# [[ -n "$2" ]] && device="$2" || device="74:45:CE:F9:14:A8" # MTH20xBT
[[ -n "$2" ]] && device="$2" || device="98:8E:79:00:DE:CF" # Qualidex
# [[ -n "$2" ]] && device="$2" || device="5C:C6:E9:35:57:42" # HRF3000
# echo $mode $device
# Main 
main "$mode" "$device"
