#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(short long)
#Icons
degree="°"
ramp1=""
ramp2=""
ramp3=""
ramp4=""
ramp5=""

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
    grep '^temperature:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^temperature:/s/:.*/:$1/" "$mode_file"
}

get_temp() {
    sensors \
        |& grep -v 'ERROR' \
        | grep Package \
        | sed -e 's/^.*: *+\([0-9]*\)\..*$/\1/'
}
icon() {
    temp="$(get_temp)"
    case 1 in
        $(($temp < 40))) icon=$ramp1 ;;
        $(($temp < 50))) icon=$ramp2 ;;
        $(($temp < 60))) icon=$ramp3 ;;
        $(($temp < 70))) icon=$ramp4 ;;
        $(($temp < 80))) icon=$ramp5 ;;
    esac
    echo "$icon"
}
short() {
    echo "$(get_temp)$degree"
}
long() {
    sensors |& grep -v 'ERROR' | grep 'Package\|Core' | sed -e "s/^.*: *+\([0-9]*\).*$/\1${degree}/" | tr '\n' ' '
}
display(){
    mode="$1"
    case $mode in
        'short') temp="$(icon) $(short)" ;;
        'long')  temp="$(icon) $(long)"  ;;
        *) help && exit 1 ;;
    esac
    echo "$temp"
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

main "$@"
