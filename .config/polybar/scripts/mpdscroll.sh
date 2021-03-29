#!/bin/bash
#Script to scroll song name of current mpd song in polybar
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
spacechar=" "
thresh=45

help() {
    echo "Usage $0 {toggle|scroll|static}"
}
getMode() {
    grep '^songnames:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^songnames:/s/:.*/:$1/" "$mode_file"
}

static() {
    echo "$(mpc current)"
}
scroll() {
    song="$(mpc current)"
    if [[ ${#song} -gt $thresh ]]; then
        ( zscroll -l "$thresh" -d 0.40 -b "" -a "" -p " /// " "$(mpc current)" ) &
    else
        static
    fi
}
display() {
    mode="$1"
    if ! mpc >/dev/null 2>&1; then
        echo Server offline && exit 1
    elif mpc status | grep -q playing; then
        case $mode in
            'scroll') scroll ;;
            'static') static ;;
            *) echo "invalid arg" && exit 1 ;;
        esac
    elif mpc status | grep -q paused; then
        echo "Paused"
    else
        echo ""
    fi
    mpc idle >/dev/null
}
main() {
    mode="$1"
    case $mode in
        '') ;;
        'static') echo 'static' >| $mode_file ;;
        'scroll') echo 'scroll' >| $mode_file ;;
        'toggle') [[ "$(getMode)" == "static" ]] && setMode 'scroll' || setMode 'static' ;;
        *) help && exit 1 ;;
    esac
    mode="$(getMode)"
    display $mode
}

main "$1"
