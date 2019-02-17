#!/bin/bash
togglefile="$HOME/dotfiles/.bartoggle"

main() {
    #toggle or explicit
    if [ "$1" = 'toggle' ]; then
        option=$(tail -1 "$togglefile")
    else
        option="$1"
    fi
    #set bar
    case "$option" in
        full)
            feh --bg-scale ~/dotfiles/.config/i3/bordered_background.png
            ~/.scripts/polybar_launch 'full'
            echo -e "full\nmini" >| "$togglefile"
            ;;
        mini)
            feh --bg-scale ~/dotfiles/.config/i3/unbordered_background.png
            ~/.scripts/polybar_launch 'mini'
            echo -e "mini\nnone" >| "$togglefile"
            ;;
        none)
            feh --bg-scale ~/dotfiles/.config/i3/unbordered_background.png
            ~/.scripts/polybar_launch 'none'
            echo -e "none\nfull" >| "$togglefile"
            ;;
        *)
            echo "Usage: $0 {toggle|full||mini|none}"
            exit 1
    esac
}

main "$1"

