#!/bin/bash

mountdir="/media/1tbdrive"
function checkMount() {
    mountnode="$1"
    [[ "$mountnode" == "/dev/" ]] && \
    echo "No drive detected, connect drive" && \
    exit 1
}
function main() {
    mountnode="/dev/$(lsblk | grep '1.8T' | grep -o 'sd[a-z][0-9]')"
    checkMount $mountnode
    mode="$1"
    case $mode in
        'on')
            sudo mount $mountnode $mountdir
            ;;
        'off')
            sudo umount $mountnode
            ;;
        *)
            echo "Usage: $0 {on|off}"
            exit 1
            ;;
    esac
}

main "$1"
