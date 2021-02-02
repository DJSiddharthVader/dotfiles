#!/bin/bash

mode_file="$HOME/dotfiles/.varfiles/upmode"
modes=(short med long)

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
function getTime() {
    timeperiod="$1"
    pattern="[0-9]\{1,\}$timeperiod"
    #time=$(uptime -p | sed -re 's/ //g' | grep -Po "$pattern" | sed -re "s/[^0-9]//" )
    if [[ "$(uptime -p)" =~ "$timeperiod" ]]; then
        time=$(uptime -p | sed -rE "s/(^.*)( [0-9]{1,} $timeperiod).*$/\2/" | sed -re 's/[^0-9]//g')
        if [[ $time =~ [^0-9]+ ]]; then
            echo 0
        elif [[ $time =~ [0-9]{4} ]]; then
            echo 0
        else
            echo $time
        fi
    else
        echo 0
    fi
}
function display() {
    mode="$(cat $mode_file)"
    weeks=$(getTime 'week')
    days=$(getTime 'day')
    hours=$(getTime 'hour')
    minutes=$(getTime 'minute')
    case $mode in
        'short') uptime="H:$(($weeks*7*24 + $days*24 + $hours))" ;;
        'med'  ) uptime="D:$((7*$weeks + $days)) H:$hours" ;;
        'long' ) uptime="W:$weeks D:$days H:$hours M:$minutes" ;;
        *) help && exit 1 ;;
    esac
    echo " $uptime "
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

