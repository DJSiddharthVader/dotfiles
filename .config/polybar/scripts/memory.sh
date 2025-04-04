#!/bin/bash
shopt -s extglob
mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(free_pct free_mem free_all all_mem)
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
    mem_used="$(data "$mem_total-$mem_free")"
    # swp_total="$(info 'SwapTotal' "$unit")"
    # swp_free="$(info  'SwapFree' "$unit")"
    case "$mode" in
        free_pct) msg="$(perc "($mem_free)/$mem_total*100")%" ;;
        free_mem) msg="$mem_free $unit";;
        free_all) msg="$mem_free $unit $(perc "($mem_free)/$mem_total*100")%" ;;
        all_mem)  msg="$mem_used $unit $mem_free $unit";;
        # used_mem) msg="$mem_used $unit";;
        # used_pct) msg="$(perc "($mem_used)/$mem_total*100")%" ;;
        # used_all) msg="$mem_used $unit $(perc "($mem_used)/$mem_total*100")%" ;;
        # all_pct)  msg="$(perc "($mem_used)/$mem_total*100")% $(perc "($mem_free)/$mem_total*100")%" ;;
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
