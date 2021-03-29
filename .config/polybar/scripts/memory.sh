#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(free_all free_mem used_all used_mem percent data short)
mem_unit="Gi"
icon=""

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
    grep '^memory:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^memory:/s/:.*/:$1/" "$mode_file"
}

info() {
    unit="$2"
    cat /proc/meminfo | grep "$1" | sed -e 's/^[^0-9]*\([0-9]\+\) kB.*$/\1/' | numfmt --from-unit="Ki" --to-unit="$unit" --format="%.2f"
}
data() {
    echo "scale=2; $1" | bc | sed -e 's/^\./0./' | sed -e 's/^\([0-9]\{1\}\)$/0\1/'
}
perc() {
    echo "scale=2; $1" | bc | sed  -e 's/\.[0-9]\{2\}//' | sed -e 's/^\./0./' | sed -e 's/^\([0-9]\{1\}\)$/0\1/'
}
display() {
    mode="$1"
    unit="$2"
    mem_total="$(info 'MemTotal' "$unit")"
    mem_free="$(info  'MemAvailable' "$unit")"
    swp_total="$(info 'SwapTotal' "$unit")"
    swp_free="$(info  'SwapFree' "$unit")"
    case "$mode" in
        'free_all') msg="$(perc "($mem_free)/$mem_total*100")% $(data $swp_free) $unit $(perc "($swp_free)/$swp_total*100")%" ;;
        'free_mem') msg="$(perc "($mem_free)/$mem_total*100")% $(data $swp_free) $unit" ;;
        'used_all') msg="$(perc "($mem_total-$mem_free)/$mem_total*100")% $(data "$swp_total-$swp_free") $unit $(perc "($swp_total-$swp_free)/$swp_total*100")%" ;;
        'used_mem') msg="$(perc "($mem_total-$mem_free)/$mem_total*100")% $(data "$swp_total-$swp_free") $unit" ;;
        'percent' ) msg="$(perc "($mem_total-$mem_free)/$mem_total*100")% $(perc "($swp_total-$swp_free)/$swp_total*100")%" ;;
        'data'    ) msg="$(data "$mem_total-$mem_free") $unit $(data "$swp_total-$swp_free") $unit" ;;
        'short'   ) msg="$(perc "($mem_total-$mem_free)/$mem_total*100")%" ;;
        *) help && exit 1 ;;
    esac
    echo "$msg"
}

main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
        display "$dmode" "$mem_unit"
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

