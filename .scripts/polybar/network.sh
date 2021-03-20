#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/netmode"
modes=(standard standardd ip text name strength all)
terminal="st"
interface="wlp1s0"
pipurl="ifconfig.co"
#Icons
# 𝍥𝌮𝌭𝌪𝌡𝌆
#
#▁▂▃▄▅▆▇█▉
ramp1="⎽"
ramp2="⎼"
ramp3="⎯"
ramp4="⎻"


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

open() {
    $terminal -e nmtui connect
}

lip() {
    hostname -I | cut -d' ' -f1
}
pip() {
    curl -s  "$pipurl"
}
name() {
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
        $(($percent <  25))) icon="$ramp1" ;;
        $(($percent <  40))) icon="$ramp1" ;;
        $(($percent <  55))) icon="$ramp1" ;;
        $(($percent <  70))) icon="$ramp2" ;;
        $(($percent <  85))) icon="$ramp3" ;;
        $(($percent < 100))) icon="$ramp4" ;;
    esac
    echo "$icon"
}

display(){
    mode="$1"
    case $mode in
        'standard' ) msg="$(icon) $(name)" ;;
        'standardd') msg="$(icon) $(strength)% $(name)" ;;
        'ip'       ) msg="L:$(lip) P:$(pip)"  ;;
        'text'     ) msg="$(name) $(strength)% $(pip)" ;;
        'name'     ) msg="$(name)" ;;
        'strength' ) msg="$(strength)%" ;;
        'all'      ) msg="$(icon) $(strength)% $(name) $(pip)" ;;
        *) help && exit 1 ;;
    esac
    echo "$msg"
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "$2" ]] && dmode="$(cat $mode_file)" || dmode="$2"
        display "$dmode"
    else
        tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
        case "$mode" in
            'open') dmode="$(cat $mode_file)" && open ;;
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        echo "$dmode"  >| "$mode_file"
    fi
}

main "$@"

