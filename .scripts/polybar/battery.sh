#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/batmode"
modes=('icon' 'percent' 'time' 'text' 'all')
#icons
charging=""
ramp0=""
ramp1=""
ramp2=""
ramp3=""
ramp4=""


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

percent() { acpi -b | cut -d',' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0}' | tr -d '%' ; }
time_left() { acpi -b | cut -d',' -f3 | cut -d' ' -f-2 | cut -d':' -f-2 | awk '{gsub(/^ +| +$/,"")} {print $0}' ; }
status() {
    status=$(acpi -b | cut -d',' -f1 | cut -d':' -f2 | awk '{gsub(/^ +| +$/,"")} {print $0}')
    case $status in
        'Charging'|'Not charging') msg="$charging" ;;
        *) msg="" ;;
    esac
    echo "$msg"
}
icon() {
    percent=$(percent)
    case 1 in
        $(($percent <= 20))) icon=$ramp0 ;;
        $(($percent <= 40))) icon=$ramp1 ;;
        $(($percent <= 60))) icon=$ramp2 ;;
        $(($percent <= 80))) icon=$ramp3 ;;
        $(($percent <= 100))) icon=$ramp4 ;;
    esac
    echo "$icon"
}
display(){
    mode="$1"
    case $mode in
        'icon'   ) bat="$(icon)" ;;
        'percent') bat="$(icon) $(percent)%" ;;
        'time'   ) bat="$(icon) $(time_left)" ;;
        'text'   ) bat="$(percent)% $(time_left)" ;;
        'all'    ) bat="$(icon) $(percent)% $(time_left)" ;;
        *) help && exit 1 ;;
    esac
    echo "$(status) $bat"
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "$2" ]] && dmode="$(cat $mode_file)" || dmode="$2"
        display "$dmode"
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

