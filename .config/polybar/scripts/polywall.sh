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
    mode="$1"
    case "$mode" in
        'font') modeicon="" ;;
        'back') modeicon="" ;;
        'both') modeicon="" ;;
        *) help && exit 1 ;;
    esac
    echo "$modeicon"
}
display() {
    wallpaper="$(head -"$(cat $wallidfile)" "$wallpfile" | tail -1 | sed -E 's/^.*wallpapers\/(.*)$/...\/\1/p')"
    icon="$(icon "$mode")"
    echo " $icon $wallpaperx "
}
main() {
    mode="$(cat $mode_file | head -1)"
    case "$1" in
        'prev'   ) /home/sidreed/.scripts/wallpaper.sh "$mode" prev ;;
        'next'   ) /home/sidreed/.scripts/wallpaper.sh "$mode" next ;;
        'stay') /home/sidreed/.scripts/wallpaper.sh "$mode" 'stay' ;;
        'mode'   ) cycle next ;;
        'display') display ;;
        *) help && exit 1 ;;
    esac
}

main "$1"
