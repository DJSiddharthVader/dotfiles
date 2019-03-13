#!/bin/bash
togglefile="$HOME/dotfiles/.bartoggle"

main() {
    #toggle or explicit
    arg="$1"
    case "$arg" in
        ftoggle)
            option="$(head -2 $togglefile | tail -1)"
            ;;
        rtoggle)
            option="$(head -3 $togglefile | tail -1)"
            ;;
        auto)
            option="$(head -1 $togglefile)"
            ;;
        *)
            echo "Usage: $0 {ftoggle|rtoggle|auto|full||mini|none}"
            exit 1
            ;;
    esac
    #set bar
    case "$option" in
        full)
            feh --bg-scale ~/dotfiles/.config/i3/bordered_background.png
            ~/.scripts/polybar_launch.sh 'full'
            echo -e "full\nmini\nnone" >| "$togglefile"
            ;;
        mini)
            feh --bg-scale ~/dotfiles/.config/i3/unbordered_background.png
            ~/.scripts/polybar_launch.sh 'mini'
            echo -e "mini\nnone\nfull" >| "$togglefile"
            ;;
        none)
            feh --bg-scale ~/dotfiles/.config/i3/unbordered_background.png
            ~/.scripts/polybar_launch.sh 'none'
            echo -e "none\nfull\nmini" >| "$togglefile"
            ;;
        *)
            echo "Usage: $0 {ftoggle|rtoggle|auto|full||mini|none}"
            exit 1
    esac
}

main "$1"

