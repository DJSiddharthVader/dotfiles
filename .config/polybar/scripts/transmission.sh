#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/tormode"
modes=(ratio data speed active) #no spaces in mode titles

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
info() {
    transmission-remote -tall -i
}
sumConvert() {
    # parses output of tranmission-remote -i to sum sizes of a specified fild for all torrents and convert final  output to desired unit (K,M,G,T etc.)
    pattern="$1: "
    outunit="$2"
    info | grep "$pattern" | #isolate field for each torrent
           sed -e "s/^.*$pattern//" -e 's/(.*)//' | #extract values
           sed -e 's/\([0-9\.]*\) \([A-Za-z]\)B[^ ]*/\1\U\2 /g' |
           tr -d '\n' | sed -e 's/ *$/\n/' | numfmt --from=auto --field=1- | #convert to bits
           tr -s ' ' '+'  | bc | numfmt --to-unit="$outunit" --format="%.2f" #sum and convert to $unit
}
display() {
    mode="$(cat $mode_file)"
    #        
    case "$mode" in
        'ratio')
            unit="Gi"
            up="$(sumConvert 'Uploaded' "$unit")"
            down="$(sumConvert 'Downloaded' "$unit")"
            total="$(sumConvert 'Total size' "$unit")"
            msg=" $(echo "scale=2; $down/$total" | bc)  $(echo "scale=2; $up/$down" | bc)"
            ;;
        'data')
            unit="Gi"
            up="$(sumConvert 'Uploaded' "$unit" "$info")"
            down="$(sumConvert 'Downloaded' "$unit" "$info")"
            msg=" $down $unit  $up $unit "
            ;;
        'speed')
            unit="Mi"
            up="$(sumConvert 'Upload Speed' "$unit" "$info")"
            down="$(sumConvert 'Download Speed' "$unit" "$info")"
            msg=" $down $unit  $up $unit "
            ;;
        'active')

            seed="$(info | grep -c 'State: Seeding')"
            down="$(info | grep -c 'State: Downloading')"
            both="$(info | grep -c 'State: Up & Down')"
            idle="$(info | grep -c 'State: Idle')"
            msg=" $down  $seed  $both  $idle"
            ;;
        *) help && exit 1 ;;
    esac
    echo "  $msg"
}
main() {
    mode="$1"
    if [[ "$mode" == 'display' ]]; then
        display
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

main "$@"
