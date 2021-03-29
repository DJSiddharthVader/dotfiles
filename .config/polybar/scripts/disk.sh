#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
modes=(percent amount amounts used free all)
#icon=""

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
getMode() {
    grep '^disk:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^disk:/s/:.*/:$1/" "$mode_file"
}

disk() {
    # disk space for / partition
    #-f1 is total disk space
    #-f2 is used disk space
    #-f3 is free disk space
    #-f4 is percent used
    df -h | grep '/$' | tr -s ' ' '\t' | cut -f2-5 | cut -f"$1"
}
percent_free() {
    disk 4 | sed -e 's/\([0-9]*\)%/100-\1/' | bc | sed -e 's/^\([0-9]\)$/0\1/' | sed -e 's/$/%/'
}
display() {
    mode="$1"
    case "$mode" in
        'percent') msg="$(percent_free)" ;;
        'amount' ) msg="$(disk 3)" ;;
        'amounts') msg="U: $(disk 2) F: $(disk 3)" ;;
        'used'   ) msg="U: $(disk 2) $(disk 4)" ;;
        'free'   ) msg="F: $(percent_free) $(disk 3)" ;;
        'all'    ) msg="U: $(disk 2) $(disk 4) F: $(disk 3) $(percent_free)" ;;
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

