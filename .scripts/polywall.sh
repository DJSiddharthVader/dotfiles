#!/bin/bash

modefile="$HOME/dotfiles/.varfiles/polywallmode"
wallidfile="$HOME/dotfiles/.varfiles/wallidx"
wallpfile="$HOME/dotfiles/.varfiles/fehbg"
sep=""

changeMode() {
    mode="$1"
    case "$mode" in
        'font')
            newmode='back'
            ;;
        'back')
            newmode='both'
            ;;
        'both')
            newmode='font'
            ;;
        *)
            echo "Usage: $0 {font|back|both}"
            exit 1
    esac
    echo "$newmode" >| "$modefile"
}
getModeIcon() {
    mode="$1"
    case "$mode" in
        'font')
            modeicon=""
            ;;
        'back')
            modeicon=""
            ;;
        'both')
            modeicon=""
            ;;
        *)
            echo "Usage: $0 {font|back|both}"
            exit 1
    esac
    echo "$modeicon"
}
main() {
    mode="$(cat $modefile | head -1)"
    modeIcon="$(getModeIcon "$mode")"
    case "$1" in
        prev)
            /home/sidreed/.scripts/wallpaper.sh "$mode" prev
            ;;
        next)
            /home/sidreed/.scripts/wallpaper.sh "$mode" next
            ;;
        mode)
            mode="$(changeMode "$mode")"
            ;;
        current)
            wallp="$(head -"$(cat $wallidfile)" "$wallpfile" | tail -1)"
            echo " $modeIcon$sep $wallp "
            ;;
        *)
            echo "Usage: $0 {prev|next|mode|current}"
            exit 1
            ;;
    esac
}

main "$1"
