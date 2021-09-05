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
            if [[ $(lsblk | grep -c $mountdir | cut -d' ' -f1 ) -eq 0 ]]; then
                sudo mount $mountnode $mountdir
            else
                echo 'Already mounted' && exit 0
            fi
            ;;
        'off')
            if [[ $(lsblk | grep -c $mountdir | cut -d' ' -f1 ) -eq 0 ]]; then
                echo 'Not connected' && exit 0
            else
                sudo umount $mountnode
            fi
            ;;
        *) echo "Usage: $0 {on|off}" && exit 1 ;;
    esac
}

main "$1"
