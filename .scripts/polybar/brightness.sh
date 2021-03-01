#!/bin/bash

help() { echo "Error: Usage $0 {inc|dec|set}" ; }

current() { xrandr --verbose | grep "^$1" -A5 | tail -1 | cut -d':' -f2 | tr -d ' ' ; }
inc() {
    monitor="$1"
    step="$2"
    new="$(current $monitor | sed -e "s/$/+$step/" | bc )"
    xrandr --output "$monitor" --brightness "$new"
}
dec() {
    monitor="$1"
    step="$2"
    new="$(current $monitor | sed -e "s/$/-$step/" | bc )"
    xrandr --output "$monitor" --brightness "$new"
}
setb() {
    monitor="$1"
    value="$2"
    xrandr --output "$monitor" --brightness "$value"
}
main() {
    mode="$1"
    if [[ $mode == 'display' ]]; then
        current "$(xrandr --listmonitors | rev | cut -f1 -d' ' | rev | tail -1)"
    else
        [[ -n "$2" ]] && step="$2" || step=0.05
        while IFS= read -r monitor; do
            case $mode in
                'inc') inc  "$monitor" "$step" ;;
                'dec') dec  "$monitor" "$step" ;;
                'set') setb "$monitor" "$step" ;;
                *) help && exit 1 ;;
            esac
        done <<< "$(xrandr --listmonitors | tail -n+2 | rev | cut -d' ' -f1 | rev)"
    fi
}

main $@

