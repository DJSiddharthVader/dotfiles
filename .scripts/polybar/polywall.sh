#!/bin/bash

wallidfile="$HOME/dotfiles/.varfiles/wallidx"
wallpfile="$HOME/dotfiles/.varfiles/fehbg"
mode_file="$HOME/dotfiles/.varfiles/polywallmode"
modes=(font back both)

help() { echo "Error: usage ./$(basename $0) {display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}" ; }
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
icon() {
#    case "$(cat $mode_file)" in
#        'font') modeicon="" ;;
#        'back') modeicon="" ;;
#        'both') modeicon="" ;;
#        *) help && exit 1 ;;
#    esac
#    echo "$modeicon"
    echo ""
}
display() {
    wallpaper="$(head -n $(cat $wallidfile) "$wallpfile" | tail -1 | sed -E 's/^.*wallpapers\/(.*)$/...\/\1/')"
    echo "$(icon) $wallpaper"
}
main() {
    mode="$(cat $mode_file)"
    case "$1" in
        'prev'   ) /home/sidreed/.scripts/wallpaper.sh prev  "$mode" ;;
        'next'   ) /home/sidreed/.scripts/wallpaper.sh next  "$mode" ;;
        'reload' ) /home/sidreed/.scripts/wallpaper.sh reload "$mode" ;;
        'mode'   ) cycle next ;;
        'display') display ;;
        *) help && exit 1 ;;
    esac
}

main "$1"
