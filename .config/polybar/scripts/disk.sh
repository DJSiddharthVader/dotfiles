#!/bin/bash
set -euo pipefail
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(percent amount used free amounts all)
#icon=""

help() {
    echo "Error: usage ./$(basename ${0:-}) {display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}"
}
cycle() {
    # cycle through modes either forwards or backwards
    # get index of current mode in the modes array, find index for next/previous mode and get the array value of that index and echo it
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    dir="${1:-}"
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
    grep '^disk:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^disk:/s/:.*/:${1:-}/" "$mode_file"
}

disk() {
    # disk space for / partition
    #-f1 is total disk space
    #-f2 is used disk space
    #-f3 is free disk space
    #-f4 is percent used
    size="$(df | grep "${1:-}$" | tr -s ' ' '\t' | cut -f2-5 | cut -f"${2:-}")"
    if [[ "$2" == 4 ]]; then
        # just percentage, no scaling required
        echo "$size"
    else
        # chose the scale for display and format
        TB_size="$(echo 1 | numfmt --from-unit="Ti" --to-unit="Ki")"
        GB_size="$(echo 100 | numfmt --from-unit="Gi" --to-unit="Ki")"
        case 1 in 
            $(($TB_size < $size)))
                scale="Ti"
                fmt="%.2f"
                ;;
            $(($GB_size < $size)))
                scale="Gi"
                fmt="%.1f"
                ;;
            *) 
                scale="Gi"
                fmt="%.2f"
                ;;
        esac
        echo "$size ${scale}" | numfmt --from-unit=Ki --to-unit="$scale" --format "$fmt"
    fi
}
percent_free() {
    disk "${1:-}" 4 \
        | sed -e 's/\([0-9]*\)%/100-\1/' \
        | bc \
        | sed -e 's/^\([0-9]\)$/0\1/' \
        | sed -e 's/$/%/'
}
display() {
    mode="${1:-}"
    msg=""
    dirs="$(df -h | grep '/dev/sd.. ' | grep -v 'efi' | rev | cut -d' ' -f1 | rev)"
    for dir in ${dirs[@]}; do
        case "$mode" in
            'percent') space="$(percent_free "$dir")" ;;
            'amount' ) space="$(disk "$dir" 3)" ;;
            'used'   ) space="Used: $(disk "$dir" 2) $(disk "$dir" 4)" ;;
            'free'   ) space="Free: $(percent_free "$dir") $(disk "$dir" 3)" ;;
            'amounts') space="Used: $(disk "$dir" 2) Free: $(disk "$dir" 3)" ;;
            'all'    ) space="Used: $(disk "$dir" 2) $(disk "$dir" 4) Free: $(disk "$dir" 3) $(percent_free "$dir")" ;;
            *) help && exit 1 ;;
        esac
        msg="$msg/${dir##*/} $space "
    done
    echo "$msg" | sed -s 's/ *$//'
}

main() {
    mode="${1:-}"
    if [[ "$mode" == 'display' ]]; then
        [[ -z "${2:-}" ]] && dmode="$(getMode)" || dmode="${2:-}"
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
