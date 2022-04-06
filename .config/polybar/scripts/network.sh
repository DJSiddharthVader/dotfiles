#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(sleek standard text name strength ip all)
interface="wlp1s0"
pipurl="ifconfig.co"
# Ramp Icons
## Segmented Block
#ramp1="𝍥"
#ramp2="䷒"
#ramp3="䷊"
#ramp4="䷡"
#ramp5="䷀"
#ramp6="䷪"
## Lines
#ramp1=" "
#ramp2="⎽"
#ramp3="⎽"
#ramp4="⎼"
#ramp5="⎯"
#ramp6="⎻"
## Block │
ramp1="▃"
ramp2="▄"
ramp3="▅"
ramp4="▆"
ramp5="▇"
ramp6="█"


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
    grep '^wifi:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^wifi:/s/:.*/:$1/" "$mode_file"
}

open() {
    $TERM -e nmtui connect
}

lip() {
    # local IP
    hostname -I | cut -d' ' -f1
}
pip() {
    # public IP
    curl -s  "$pipurl"
}
name() {
    # network SSID
    iwgetid -r
}
strength() {
    percent="$(grep "^\s*w" /proc/net/wireless \
               | awk '{ print "", int($3 * 100 / 70)}'\
               | xargs | sed 's/100/99/')"
    [[ -z "$percent" ]] && percent=0
    echo $percent
}
icon() {
    percent=$(strength)
    case 1 in
        $(($percent <  50))) icon="$ramp1" ;;
        $(($percent <  60))) icon="$ramp2" ;;
        $(($percent <  70))) icon="$ramp3" ;;
        $(($percent <  80))) icon="$ramp4" ;;
        $(($percent <  90))) icon="$ramp5" ;;
        $(($percent < 101))) icon="$ramp6" ;;
    esac
    echo "$icon" #▎
}
display(){
    mode="$1"
    case $mode in
        'sleek' ) msg="$(icon) $(name)" ;;
        'standard') msg="$(icon) $(strength)% $(name)" ;;
        'text'     ) msg="$(strength)% $(name) $(pip)" ;;
        'name'     ) msg="$(name)" ;;
        'strength' ) msg="$(strength)%" ;;
        'ip'       ) msg="L:$(lip) P:$(pip)"  ;;
        'all'      ) msg="$(icon) $(strength)% $(name) $(pip)" ;;
        *) help && exit 1 ;;
    esac
    echo "$msg"
}

main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
        display "$dmode"
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'open') dmode="$(getMode)" && open ;;
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        setMode "$dmode"
    fi
}

main "$@"
