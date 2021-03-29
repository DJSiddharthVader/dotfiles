#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(hour day week)
#icon=""

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
    grep '^uptime:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^uptime:/s/:.*/:$1/" "$mode_file"
}

time_() {
    time_period="$1"
    if [[ "$(uptime -p)" =~ "$time_period" ]]; then
        time_passed="$(uptime -p | sed -rE "s/(^.*) ([0-9]{1,} $time_period).*$/\2/" | sed -re 's/[^0-9]//g')"
    else
        time_passed="0"
    fi
    echo "$time_passed"
}
display() {
    weeks=$(time_ 'week')
    days=$(time_ 'day')
    hours=$(time_ 'hour')
    minutes=$(time_ 'minute')
    mode="$1"
    case $mode in
        'hour') uptime="H:$(($weeks*7*24 + $days*24 + $hours))" ;;
        'day' ) uptime="D:$((7*$weeks + $days)) H:$hours" ;;
        'week') uptime="W:$weeks D:$days H:$hours M:$minutes" ;;
        *) help && exit 1 ;;
    esac
    echo "$uptime"
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

