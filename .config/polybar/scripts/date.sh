#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/datemode"
modes=(time date numeric full) #no spaces in mode titles

help() {
    echo "Error: usage ./$(basename $0) {display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}"
}
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
display() {
    # 
    mode="$(cat $mode_file)"
    case "$mode" in
        'time'   ) msg=" $(date +'%I:%M')" ;;
        'date'   ) msg=" $(date +'%B %d %Y')" ;;
        'numeric') msg=" $(date +'%I:%M')  $(date +'%d/%m/%Y')" ;;
        'full'   ) msg=" $(date +'%I:%M')  $(date +'%A, %B %d %Y')" ;;
        *) help && exit 1 ;;
    esac
    echo " $msg "
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        display
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        echo "$dmode"  >| "$mode_file"
    fi
}

main "$1"

