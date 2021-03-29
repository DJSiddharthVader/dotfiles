#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
stats="$HOME/dotfiles/.config/transmission-daemon/stats.json"
config_dir="$HOME/dotfiles/.config/transmission-daemon"
watch_dir="$HOME/Torrents"
modes=(ratio data datatotal speed active) #no spaces in mode titles
max_pages=5

help() {
    echo "Error: usage ./$(basename $0) {search|display|next|prev|$(echo ${modes[*]} | tr ' ' '|')}"
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
    grep '^torrent:' "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^torrent:/s/:.*/:$1/" "$mode_file"
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

start() {
    transmission-daemon -g $config_dir -w $watch_dir
    for torrent in $config_dir/torrents/*.torrent*; do
        echo "$torrent"
        transmission-remote -a "$torrent"
    done
}

extract_from_page() {
    grep "$1" "$2" | sed -e 's/^.*>\([^<>]\+\)<\(\/td\|\/a\|span\).*$/\1/'
}
parse_results() {
    page="$1"
    names="$(extract_from_page 'coll-1 name' $page)"
    seeders="$(extract_from_page 'coll-2 seeds' $page)"
    leechers="$(extract_from_page 'coll-3 leeches' $page)"
    date="$(extract_from_page 'coll-date' $page)"
    size="$(extract_from_page 'coll-4 size' $page)"
    paste <(echo "$date") <(echo "$seeders") <(echo "$leechers") <(echo "$size") <(echo "$names") | tail -n+2 | tr -s ' ' | tr -s '\t' #| column -t -s'\t'
}
get_search_results() {
    query="$1"
    results_page="$2"
    search_url="https://1337x.to/search/${query// /+}/1/"
    #curl -Ss "$search_url" >| ~/pages.html
    total_pages="$(curl -Ss "$search_url" | grep 'Last' |  sed -s 's/^.*class=.last.><a href=.\/search\/.*\/\([0-9]*\)\/.>.*$/\1/')"
    [[ $max_pages -lt $total_pages ]] && total_pages=$max_pages
    for page_num in $(seq 1 $total_pages); do
        search_url="https://1337x.to/sort-search/${query// /+}/seeders/desc/$page_num/"
        echo $search_url
        curl -Ss "$search_url" >> $results_page
    done
    #cp $results_page ~/results.html
}
search() {
    query="$(rofi -lines 0 -dmenu -p "Enter query")"
    [[ -z "$query" ]] && exit 1 #no query
    results_page=$(mktemp)
    get_search_results "$query" "$results_page"
    chosen="$(parse_results $results_page | rofi -lines 25 -width 80 -dmenu -p "Pick torrent")"
    [[ -z "$chosen" ]] && exit 1 #no query
    txlink="$(grep -F "$(echo "$chosen" | rev | cut -f1 | rev)" $results_page | sed -e 's/^.*href="\/\(torrent.*\)\/">.*$/\1/')"
    [[ -z "$txlink" ]] && exit 1 #no query
    magnet="$(curl -Ss "https://1337x.to/$txlink/" | grep 'magnet' | head -1 | sed -e 's/^.*href="\(magnet[^"<>]*\)".*$/\1/')"
    echo "$magnet"
    [[ -z "$magnet" ]] && exit 1 #no query
    transmission-remote -a "$magnet" && notify-send "$(echo $chosen | rev | cut -f1 | rev) torrent added"
    rm $results_page
}

main() {
    mode="$1"
    case $mode in
        'search' ) search ;;
        'start'  ) start ;;
        'display')
            [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
            display "$dmode"
            ;;
        *)
            tmp="@($(echo ${modes[*]} | sed -e 's/ /|/g'))"
            case "$mode" in
                'next'  ) dmode="$(cycle 'next')" ;;
                'prev'  ) dmode="$(cycle 'prev')" ;;
                $tmp    ) dmode="$mode" ;; #capture any valid mode
                *       ) help && exit 1 ;;
            esac
            setMode "$dmode"
            ;;
    esac
}

main "$@"
