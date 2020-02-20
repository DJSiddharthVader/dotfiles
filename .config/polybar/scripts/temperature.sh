#!/bin/bash

mode_file="$HOME/dotfiles/.varfiles/tempmode"
#Icons
ramp0=""
ramp1=""
ramp2=""


function short() {
    sensors | grep Package | sed -e 's/^.*: \++\([0-9]*\.[0-9]*..\).*$/\1/' | sed -e 's/\(\.[0-9]\)//g'
}
function long() {
    sensors | grep 'Package\|Core' | sed -e 's/^.*: \++\([0-9]*\.[0-9]*..\).*$/\1/' | sed -e 's/\(\.[0-9]\)//g' | tr '\n' ' '
}
function getTemp () {
    sensors | grep Package | sed -e 's/^.*: \++\([0-9]*\.[0-9]*..\).*$/\1/' | grep -o '^..'
}
function showIcon() {
    temp=$(getTemp)
    case 1 in
        $(($temp < 40)))
            icon=$ramp0
            ;;
        $(($temp < 50)))
            icon=$ramp1
            ;;
        $(($temp < 60)))
            icon=$ramp2
            ;;
    esac
    echo "$icon"
}
function display(){
    mode="$1"
    case $mode in
        'short')
            temp="$(showIcon) $(short)"
            ;;
        'long')
            temp="$(showIcon) $(long)"
            ;;
        *)
            echo "Usage $0 {short|long}"
            exit 1
            ;;
    esac
    echo $temp
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
