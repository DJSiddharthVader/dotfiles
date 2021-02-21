#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.varfiles/tormode"
stats="$HOME/dotfiles/.config/transmission-daemon/stats.json"
modes=(ratio data datatotal speed active) #no spaces in mode titles

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
    transmission-remote -tall -i | grep -v 'None'
}
sumConvert() {
    # parses output of tranmission-remote -i to sum sizes of a specified fild for all torrents and convert final  output to desired unit (K,M,G,T etc.)
    pattern="$1: "
    outunit="$2"
    info | grep "$pattern" | #isolate field for each torrent
           sed -e "s/^.*$pattern//" -e 's/(.*)//' | #extract values
           sed -e 's/\([0-9\.]*\) \([A-Za-z]\)B[^ ]*/\1\U\2 /g' |
           tr -d '\n' | sed -e 's/ *$/\n/' | #join lines add trailing newline for bc
           numfmt --from=auto --field=1- | #convert to bits
           tr -s ' ' '+'  | bc | #sum together
           numfmt --to-unit="$outunit" --format="%.2f" #sum and convert to $unit
}
divide() {
    num="$1"
    denom="$2"
    scale="$3"
    echo "scale=$scale; $num/$denom" | bc | sed -e 's/^\./0./'
}
display() {
    mode="$1"
    #        
    case "$mode" in
        'ratio')
            unit="Gi"
            down="$(sumConvert 'Have' "$unit")"
            total="$(sumConvert 'Total size' "$unit")"
            upt="$(jq '."uploaded-bytes"' "$stats" | numfmt --to-unit "$unit" --format="%.2f")"
            downt="$(jq '."downloaded-bytes"' "$stats" | numfmt --to-unit "$unit" --format="%.2f")"
            msg=" $(divide $down $total 2)  $(divide $upt $downt 2)"
            ;;
        'data')
            unit="Gi"
            up="$(sumConvert 'Uploaded' "$unit" "$info")"
            down="$(sumConvert 'Have' "$unit" "$info")"
            msg=" $down $unit  $up $unit"
            ;;
        'datatotal')
            unit="Gi"
            upt="$(jq '."uploaded-bytes"' $stats | numfmt --to-unit "$unit" --format="%.2f")"
            downt="$(jq '."downloaded-bytes"' $stats | numfmt --to-unit "$unit" --format="%.2f")"
            msg="  $downt $unit   $upt $unit"
            ;;
        'speed')
            unit="Mi"
            up="$(sumConvert 'Upload Speed' "$unit" "$info")"
            down="$(sumConvert 'Download Speed' "$unit" "$info")"
            [[ -z "$up$down" ]] &&  msg=" - $unit/s  - $unit/s" || msg=" $down $unit/s  $up $unit/s"
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
            'next') dmode="$(cycle 'next')" ;;
            'prev') dmode="$(cycle 'prev')" ;;
            $tmp  ) dmode="$mode" ;; #capture any valid mode
            *) help && exit 1 ;;
        esac
        echo "$dmode"  >| "$mode_file"
    fi
}

main "$@"
