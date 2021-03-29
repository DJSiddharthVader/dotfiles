#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(short long)

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
    mode="$(getMode)"
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
getMode() {
    grep '^cpu:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^cpu:/s/:.*/:$1/" "$mode_file"
}

display() {
    mode="$1"
    case $mode in
        'short') cpu="$(mpstat -P ALL 1 1 | grep "Average: *all" | sed -e 's/ \{1,\}/\t/g' | cut -f3 | cut -d'.' -f1 | tr -dc '[:digit:]' | sed -e 's/^\([0-9]\{1\}\)$/0\1/' | sed -e 's/$/\%/' )" ;;
        'long' ) cpu="$(mpstat -P ALL 1 1 | \
                       awk '/Average:/ && $2 ~ /[0-9]/ {print $3}' | \
                       cut -d'.' -f1 | \
                       sed -e 's/^\([0-9]\{1\}\)$/0\1/g' | \
                       tr '\n' '%' | \
                       sed -e 's/%/% /g')" ;;
            #awk '/Average:/ && [ ~ /[0-9]/ {print {}' | #magic to get only load values
            #sed -uEn 's/(^[0-9]*)\..*$/0\1\%/p' | #trim decimals, pad 0 if < 10, add % after
            #tr '\n' ' ' # join lines together
        *) help && exit 1 ;;
    esac
    echo "$cpu"
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
        display "$dmode"
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        setMode "$dmode"
    fi
}

main "$1"

