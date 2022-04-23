#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(time date numeric full bar_time bar_date bar_full) # no spaces in mode titles
BAR_WIDTH="5"

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
    grep '^date:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^date:/s/:.*/:$1/" "$mode_file"
}

compute_frac() {
    echo "$1" | sed -e "s/\(.*\)/scale=5; \1 \/ $2/" | bc
}
days_in_month() {
    cal $(date +"%m %Y") | awk 'NF {DAYS = $NF}; END {print DAYS}'
}
get_progress() {
    mode="$1"
    info="$(date +'%j:%d:%u:%H:%M')"
    case "$mode" in
        year ) field=1; denom=366 ;;
        month) field=2; denom=$(days_in_month) ;;
        week ) field=3; denom=7 ;;
        day  ) field=4; denom=23 ;;
        hour ) field=5; denom=59 ;;
    esac
    compute_frac "$(echo $info | cut -d':' -f$field)" "$denom"
}
make_bar() {
    progress=$(get_progress $1)
    echo $progress
}
progress() {
    mode="$1"
    case $mode in 
        year ) prefix="Y" ;;
        month) prefix="M" ;;
        week ) prefix="W" ;;
        day  ) prefix="D" ;;
        hour ) prefix="H" ;;
    esac
    echo "$prefix[$(make_bar $mode $BAR_WIDTH)]"
}
display() {
    mode="$1"
    case "$mode" in
        time    ) msg=" $(date +'%I:%M')" ;;
        date    ) msg=" $(date +'%B %d %Y')" ;;
        numeric ) msg=" $(date +'%I:%M')  $(date +'%d/%m/%Y')" ;;
        full    ) msg=" $(date +'%I:%M')  $(date +'%A, %B %d %Y')" ;;
        bar_time) msg=" $(progress 'hour') $(progress 'day')" ;;
        bar_date) msg=" $(progress 'week') $(progress 'month') $(progress 'year')" ;;
        bar_full) msg=" $(progress 'hour') $(progress 'day')  $(progress 'month') $(progress 'year')" ;;
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
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        setMode "$dmode"
    fi
}

main "$@"

