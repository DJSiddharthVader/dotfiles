#!/bin/bash

icon() {
    echo 'none'
    case $1 in
        '') app="" ;;
        *)  app="" ;;
    esac
    echo $app
}
main() {
    sleep 5
    id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    ws="$(xprop -id $id | grep '^_NET_WM_DESKTOP' | cut -d'=' -f2 | tr -d '" ' | sed -s 's/$/+1/' | bc)"
    name="$(xprop -id $id | grep '^WM_NAME' | cut -d'=' -f2 | tr -d '" ')"
    icon="$(icon $name)"
    echo "$id $ws $icon $name"
}

main
