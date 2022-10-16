#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(time numeric time_bar date date_bar full full_bar)
#RAMP=(▁ ▏ ▎ ▍ ▌ ▊ █)
RAMP=(▁ ░ ▒ ▓ █)
#RAMP=(▁ ▃ ▄ ▅ ▆ ▇ █)
DEFAULT_BAR_WIDTH="12"

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
         'prev') idx=$(($idx + ${#modes[@]} - 1)) ;;
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

days_in_month() {
    cal $(date +"%m %Y") | awk 'NF {DAYS = $NF}; END {print DAYS}'
}
get_denom(){
    mode="$1"
    case "$mode" in
        year ) denom=366 ;;
        month) denom=$(days_in_month) ;;
        day  ) denom=24 ;;
        hour ) denom=60 ;;
    esac
    echo "$denom"
}
get_progress() {
    mode="$1"
    case "$mode" in
        year ) field=1 ;; 
        month) field=2 ;;
        day  ) field=4 ;;
        hour ) field=5 ;;
    esac
    time="$(date +'%j:%d:%u:%H:%M' | cut -d':' -f$field)"
    echo $time
}
make_bar() {
    timescale="$1"; bar_width="$DEFAULT_BAR_WIDTH"
    time="$(get_progress $timescale)"; total="$(get_denom $timescale)"
    inc_size=$(echo "scale=2; $total / $bar_width" | bc)
    full_pips=$(echo "scale=0; $time / $inc_size" | bc)
    bar=""
    for i in $(seq 1 $bar_width); do
        if [[ $i -le $full_pips ]]; then
            bar="$bar${RAMP[${#RAMP[@]}-1]}"
        elif [[ $i -eq $(($full_pips + 1)) ]]; then 
            remainder=$(echo "$time % $inc_size" | bc)
            percent=$(echo "scale=2; $remainder / $inc_size" | bc)
            final_pip=$(echo "$percent * ${#RAMP[@]} / 1" | bc)
            bar="$bar${RAMP[$final_pip]}"
        else # left pad with spaces to be correct width
            bar="$bar${RAMP[0]}"
        fi
    done
    echo "$bar"
}
display() {
    mode="$1"
    case "$mode" in
        time    ) msg=" $(date +'%I:%M')" ;;
        time_bar) msg=" $(date +'%I:%M') $(make_bar 'day')" ;;
        date    ) msg=" $(date +'%B %d %Y')" ;;
        date_bar) msg=" $(date +'%B %d %Y')$(make_bar 'month')";;
        numeric ) msg=" $(date +'%I:%M')  $(date +'%d/%m/%Y')" ;;
        full    ) msg=" $(date +'%I:%M')  $(date +'%A, %B %d %Y')" ;;
        full_bar) msg=" $(date +'%I:%M')$(make_bar 'day')"  $(date +'%A, %B %d %Y')"$(make_bar 'year')";;
        bar_hour) msg="$(make_bar 'hour')" ;;
        bar_day) msg="$(make_bar 'day')" ;;
        bar_month) msg="$(make_bar 'month')" ;;
        bar_year) msg="$(make_bar 'year')" ;;
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
