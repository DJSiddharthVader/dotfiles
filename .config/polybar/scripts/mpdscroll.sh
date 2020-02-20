#!/bin/bash
#Script to scroll song name of current mpd song in polybar
mode_file="$HOME/dotfiles/.varfiles/scrollmode"
spacechar="_"
thresh=20

function scroll() {
    ( zscroll -l "$thresh" -d 0.60 -b "" -a "" -p "///" "$(mpc current | sed -uEn 's/(^.*$)/ \1 /p' | tr '[:blank:]' "$spacechar" )" ) &
}
function static() {
    echo "$(mpc current)"
}
function display() {
    mode="$1"
    if ! mpc >/dev/null 2>&1; then
        echo Server offline
        exit 1
    elif mpc status | grep -q playing; then
        case $mode in
            'scroll')
                scroll
                ;;
            'static')
                static
                ;;
            *)
                echo "invalid arg"
                exit 1
                ;;
        esac
    elif mpc status | grep -q paused; then
        echo "Paused"
    else
        echo ""
    fi
    mpc idle >/dev/null
}
function main() {
    mode="$1"
    case $mode in
        'static')
            echo 'static' >| $mode_file
            ;;
        'scroll')
            echo 'scroll' >| $mode_file
            ;;
        'toggle')
            mode="$(cat $mode_file)"
            if [[ $mode == "static" ]]; then
                echo 'scroll' >| $mode_file
            else
                echo 'static' >| $mode_file
            fi
            ;;
        '')
            sleep 0.0000000001
            ;;
        *)
            echo "Usage $0 {toggle|scroll|static}"
            exit 1
            ;;
    esac
    mode="$(cat $mode_file)"
    display $mode
}

main "$1"
