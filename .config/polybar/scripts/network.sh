#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/netmode"
modes=(name ip strength namestrength all)
terminal="st"
interface="wlp1s0"
#Icons
ramp1=" "
ramp2=" "
ramp3=" "
ramp4=""

help() { echo "Error: usage ./$(basename $0) {display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}" ; }
cycle() {
    # cycle through modes either forwards or backwards
    # get index of current mode in the modes array, find index for next/previous mode and get the array value of that index and echo it
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    dir="$1"
    mode="$(cat $mode_file)"
    idx="$(echo "${modes[*]}" | grep -o "^.*$mode" | tr ' ' '\n' | wc -l)"
    idx=$(($idx -1)) #current mode idx
    case "$dir" in
         'next') idx=$(($idx + 1)) ;;
         'prev') idx=$(($idx +${#modes[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#modes[@]})) #modulo to wrap back
    echo "${modes[$next_idx]}"
}
ip() { hostname -I | cut -d' ' -f1 ; }
name() { nmcli -t -f active,ssid dev wifi | cut -d':' -f2 ; }
strength() { ; }
icon() {
    strength="$(strength)"
    case 1 in
        $(($strength < 30))) icon=$ramp1 ;;
        $(($strength < 40))) icon=$ramp2 ;;
        $(($strength < 50))) icon=$ramp3 ;;
        $(($strength < 60))) icon=$ramp4 ;;
    esac
    echo "$icon"
}
open() { $terminal -e nmtui connect ; }
display(){
    mode="$(cat $mode_file)"
    case $mode in
        *) help && exit 1 ;;
    esac
    echo "$temp"
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        display
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'open') open ;;
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        echo "$dmode"  >| "$mode_file"
    fi
}

main "$1"

