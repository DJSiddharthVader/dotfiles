#!/bin/bash

mode_file="$HOME/dotfiles/.varfiles/batmode"
#icons
charging=" "
ramp0="  "
ramp1="  "
ramp2="  "
ramp3="  "
ramp4="  "


function showPercent() {
    percent=$(acpi -b | cut -d',' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0}')
    echo $percent
}
function showStatus() {
    status=$(acpi -b | cut -d',' -f1 | cut -d':' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0}')
    if [[ $status == 'Charging' ]]; then
        echo $charging
    elif [[ $status == 'Not charging' ]]; then
        echo $charging #full and plugged in
    else
        echo ""
    fi
}
function showTime() {
    time=$(acpi -b | cut -d',' -f3 | cut -d' ' -f-2 | cut -d':' -f-2 |  awk '{gsub(/^ +| +$/,"")} {print $0}')
    echo $time
}
function showIcon() {
    percent=$(showPercent | tr -d '%' )
    case 1 in
        $(($percent <= 20)))
            icon=$ramp0
            ;;
        $(($percent <= 40)))
            icon=$ramp1
            ;;
        $(($percent <= 60)))
            icon=$ramp2
            ;;
        $(($percent <= 80)))
            icon=$ramp3
            ;;
        $(($percent <= 100)))
            icon=$ramp4
            ;;
    esac
    echo "$icon"
}
function display(){
    mode="$1"
    case $mode in
        'short')
            bat="$(showStatus) $(showIcon) $(showPercent)"
            ;;
        'long')
            bat="$(showStatus) $(showIcon) $(showPercent) $(showTime)"
            ;;
        *)
            echo "Usage $0 {short|long}"
            exit 1
            ;;
    esac
    echo $bat
}
function main() {
    mode="$1"
    case $mode in
        'short')
            echo 'short' >| $mode_file
            ;;
        'long')
            echo 'long' >| $mode_file
            ;;
        'toggle')
            mode="$(cat $mode_file)"
            if [[ $mode == "short" ]]; then
                echo 'long' >| $mode_file
            else
                echo 'short' >| $mode_file
            fi
            ;;
        '')
            sleep 0.001
            ;;
        *)
            echo "Usage $0 {toggle|short|long}"
            exit 1
            ;;
    esac
    mode="$(cat $mode_file)"
    display $mode
}

main "$1"

