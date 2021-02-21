#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/memmode"
modes=(percent data) #no spaces in mode titles

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
info() { cat /proc/meminfo | grep "$1" | sed -e 's/^[^0-9]*\([0-9]\+\) kB.*$/\1/' | numfmt --from-unit="Ki" --to-unit="Gi" --format="%.2f" ; }
data() { echo "scale=2; $1" | bc | sed -e 's/^\./0./' | sed -e 's/^\([0-9]\{1\}\)$/0\1/' ; }
perc() { echo "scale=2; $1" | bc | sed  -e 's/\.[0-9]\{2\}//' | sed -e 's/^\./0./' | sed -e 's/^\([0-9]\{1\}\)$/0\1/' ; }
display() {
    mem_total="$(info 'MemTotal')"
    mem_free="$(info 'MemAvailable')"
    swp_total="$(info 'SwapTotal')"
    swp_free="$(info 'SwapFree')"
    mode="$1"
    case "$mode" in
        "data"   ) msg="$(data "$mem_total-$mem_free") Gi $(data "$swp_total-$swp_free") Gi" ;;
        'percent') msg="$(perc "($mem_total-$mem_free)/$mem_total*100")% $(perc "($swp_total-$swp_free)/$swp_total*100")%" ;;
        *) help && exit 1 ;;
    esac
    echo " $msg"
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


#DEPRECIATED
#info() {
#    type="$1"
#    if [[ "$type" == 'mem' ]]; then
#        info="$(free -m | head -2 | tail -1)"
#    elif [[ "$type" == 'swp' ]]; then
#        info="$(free -m | head -3 | tail -1)"
#    fi
#    echo "$info" | tr -s ' ' ' ' | cut -f2-4 -d' ' |
#         numfmt --field=1- --from-unit="Mi" --to-unit="Gi" --format="%.2f"
#}
#display() {
#    mode="$(cat $mode_file)"
#    mem_info="$(info 'mem')"
#    mem_used="$(echo $mem_info | cut -f2-3 -d' ' | tr ' ' '+' | bc)"
#    mem_total="$(echo $mem_info | cut -f1 -d' ')"
#    swp_info="$(info 'swp')"
#    swp_used="$(echo $swp_info | cut -f2-3 -d' ' | tr ' ' '+' | bc)"
#    swp_total="$(echo $swp_info | cut -f1 -d' ')"
#    case "$mode" in
#        'data'   ) msg="" ;;
#        'precent') msg="" ;;
#        *) help && exit 1 ;;
#    esac
#    echo " $msg"
#}

