#!/bin/bash
shopt -s extglob
# Icons
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=('icon' 'percent' 'time' 'text' 'all')
charging_icon=""
ramp0=""
ramp1=""
ramp2=""
ramp3=""
ramp4=""
# Code
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
         'prev') idx=$(($idx + ${#modes[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#modes[@]})) #modulo to wrap back
    echo "${modes[$next_idx]}"
}
getMode() {
    grep '^battery:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^battery:/s/:.*/:$1/" "$mode_file"
}
batinfo() {
    if [[ $(acpi -b | wc -l | cut -d' ' -f1) -eq 1 ]]; then
        acpi -b 
    else
        acpi -b | grep -v 'rate information unavailable' | head -1
    fi
}
get_percent() {
    batinfo | cut -d',' -f2 | tr -d '[ %]'
}
time_left() {
    batinfo | \
        cut -d':' -f2- | \
        cut -d',' -f3 | \
        cut -d':' -f-2 | \
        tr -d '[a-zA-z ]'
}
get_status() {
    isCharging="$(batinfo | cut -d':' -f2 | cut -d',' -f1 | tr -d ' ')"
    case "$isCharging" in
        'Charging'|'Not charging') msg="$charging_icon" ;;
        *) msg="" ;;
    esac
    echo "$msg"
}
get_icon() {
    percent=$(get_percent)
    [[ $percent -le 100 ]] && icon=$ramp4 
    [[ $percent -le 80  ]] && icon=$ramp3
    [[ $percent -le 60  ]] && icon=$ramp2 
    [[ $percent -le 40  ]] && icon=$ramp1
    [[ $percent -le 20  ]] && icon=$ramp0 
    echo "$icon"
}
display(){
    mode="$1"
    case $mode in
        'icon'   ) bat="$(get_icon)" ;;
        'percent') bat="$(get_icon) $(get_percent)%" ;;
        'time'   ) bat="$(get_icon) $(time_left)" ;;
        'text'   ) bat="$(get_percent)% $(time_left)" ;;
        'all'    ) bat="$(get_icon) $(get_percent)% $(time_left)" ;;
        *) help && exit 1 ;;
    esac
    echo "$(get_status) $bat"
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
