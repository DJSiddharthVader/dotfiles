#!/bin/bash
shopt -s extglob

bgfile="$HOME/dotfiles/.varfiles/bordered_background.png"
unbgfile="$HOME/dotfiles/.varfiles/unbordered_background.png"
mode_file="$HOME/dotfiles/.varfiles/barmode"
modes=(float full mini none)

help() { echo "Error: usage ./$(basename $0) {reload|restart|next|prev|$(echo ${modes[*]} | tr ' ' '|')}" ; }
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
wallpaper() {
    echo "$1"
    case $1 in
        float|mini|none) feh --bg-scale "$unbgfile" ;;
        full) feh --bg-scale "$bgfile" ;;
        *) help && echo 'wall' && exit 1 ;;
    esac
}
launch() {
    mode="$1"
    wallpaper "$mode"
    killall -q polybar && sleep 0.00001 # Terminate already running bar instances
    for m in $(xrandr | grep ' connected' | cut -d' ' -f1); do
        case "$mode" in
            'float')
                MONITOR=$m polybar floating_top &
                MONITOR=$m polybar floating_bot &
                ;;
            'full' )
                MONITOR=$m polybar bordered_top &
                MONITOR=$m polybar bordered_bot &
                ;;
            'mini' ) MONITOR=$m polybar minimal & ;;
            'none' ) sleep 1 ;;
            *) help && echo 'launch' && exit 1 ;;
        esac
    done
}
main() {
    mode="$1"
    tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
    #echo "start: $mode $(cycle prev) $(cat $mode_file) $(cycle next) $tmp"
    case "$mode" in
        'reload' ) ! [[ -z "$(pgrep 'polybar')" ]] && polybar-msg cmd restart && exit 0 ;;
        'restart') dmode="$(cat $mode_file)" ;; #same mode, just launch again
        'next'   ) dmode="$(cycle 'next')" ;;
        'prev'   ) dmode="$(cycle 'prev')" ;;
         $tmp    ) dmode="$mode" ;; #capture any valid mode
        *) echo "failed: $mode" && help && exit 1 ;;
    esac
    echo "$dmode"  >| "$mode_file"
    launch "$(cat $mode_file)"
}

main "$1"
