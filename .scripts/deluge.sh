#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
mode_prefix="torrent"
watch_dir="$HOME/Torrents"
modes=(ratio ratiototal data datatotal speed active) #no spaces in mode titles
max_pages=5 # max number of results pages to parse when searching
stats_file="$HOME/dotfiles/.config/deluge/stats.tsv"
delim="~"

help() {
    mode='$mode'
    echo "Error: usage ./$(basename $0) [FNC] [OPT]*

    FNC           | Description
   ---------------|-----------------------------------
    search        | search 1337x for a torrent query
    start         | start deluge daemon
    pause         | pause all torrents
    resume        | resume all torrents
    clean         | remove all errored torrents
    stats         | update up/download stats csv file
    display $mode | display data in the specified mode
                  | if mode blank then it will display in default mode
    next          | cycle defualt display mode forward
    prev          | cycle defualt display mode backward
    $mode         | set defualt display mode to $mode
   ---------------------------------------------------

   - modes are {$(echo ${modes[*]} | tr ' ' '|')}
   - you can see the defualt mode with \`grep 'torrent' ~/dotfiles/.config/polybar/modules.mode\`
"
}
init() {
    # init files
    mkdir -p "$watch_dir"
    touch "$stats_file"
    touch "$mode_file"
    echo "$mode_prefix:speed" >> "$mode_file"
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
    idx=$(($idx -1)) # current mode idx
    case "$dir" in
         'next') idx=$(($idx + 1)) ;;
         'prev') idx=$(($idx +${#modes[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#modes[@]})) # modulo to wrap back around modes array
    echo "${modes[$next_idx]}" # return new mode
}
getMode() {
    grep "^$mode_prefix:" "$mode_file" | cut -d':' -f2
}
setMode() {
    sed -i "/^$mode_prefix:/s/:.*/:$1/" "$mode_file"
}

info() {
    deluge-console 'info -v' 2> /dev/null
}
status() {
    deluge-console status 2> /dev/null
}

# Global Torrent Data Tracking
scrape_stats() {
    pattern="$2"
    echo "$1" | grep "$pattern: " |
                sed -e "s/\(^.*$pattern: \)[0-9\.]* [A-Z]\//\1/" |
                sed -e "s/^.*$pattern: \([0-9\.]*\) \([BKMG]\).*/\1\2i /" |
                sed -e 's/0Bi /0 /' | tr -d '\n' | sed -e 's/ *$/\n/' |
                numfmt --from=auto --field=1- | tr -s ' ' '\n'
}
update_stats() {
    # store all torrent stats in a tsv, update tsv and remove dups, keeping entries with the largest numbers
    #header="id"$delim"name"$delim"size"$delim"downloaded"$delim"uploaded"
    unit="Gi"
    info="$(info)"
    ids="$(echo "$info" | grep 'ID: ' | cut -f2 -d':' | tr -d ' ')"
    names="$(echo "$info" | grep 'Name: ' | cut -f2 -d':' | sed -e 's/^ //')"
    sizes="$(scrape_stats "$info" 'Size' "$unit")"
    downloaded="$(scrape_stats "$info" 'Downloaded' "$unit")"
    uploaded="$(scrape_stats "$info" 'Uploaded' "$unit" )"
    paste -d"$delim" <(echo "$ids") <(echo "$names") <(echo "$sizes") <(echo "$downloaded") <(echo "$uploaded") >> "$stats_file"
    cp "$stats_file" "$stats_file.bak"
    sort -t"$delim" -g -r -k5,5 -k4,4 $stats_file | sort -t"$delim" -u -k1,1 -o $stats_file #dedup
}
total_stats() {
    field="$1"
    outunit="$2"
    case "$field" in
        'size') fn=3 ;;
        'down') fn=4 ;;
        'up'  ) fn=5 ;;
    esac
    cut -d"$delim" -f$fn $stats_file | tr '\n' '+' | sed -e 's/^+/\n/' | sed -e 's/+$/\n/' | bc | numfmt --to-unit="$outunit" --format="%.2f"
}

# Display Toreent Data
speed() {
    # parses output of tranmission-remote -i to sum sizes of a specified fild for all torrents and convert final  output to desired unit (K,M,G,T etc.)
    pattern="$1"
    outunit="$2"
    info="$(status | grep "$pattern" | sed -e "s/^.*$pattern: \([0-9\.]*\) \([kmgKMG]i\).*$/\1 \2/")"
    speed="$(echo $info | cut -f1 -d' ')"
    unit="$(echo $info | cut -f2 -d' ')"
    numfmt --from-unit="$unit" --to-unit="$outunit" --format="%.2f" "$speed"
}
parse_data() {
    pattern="$2"
    outunit="$3"
    echo "$1" | grep "$pattern: " |
                sed -e "s/\(^.*$pattern: \)[0-9\.]* [A-Z]\//\1/" |
                sed -e "s/^.*$pattern: \([0-9\.]*\) \([BKMG]\).*/\1\2i /" |
                sed -e 's/0Bi //' | tr -d '\n' | sed -e 's/ *$/\n/' |
                numfmt --from=auto --field=1- |
                tr -s ' ' '+'  | bc |
                numfmt --to-unit="$outunit" --format="%.2f"
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
            info="$(info)"
            up="$(parse_data "$info" 'Uploaded' "$unit")"
            down="$(parse_data "$info" 'Downloaded' "$unit")"
            size="$(parse_data "$info" 'Size' "$unit")"
            msg=" $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'ratiototal')
            unit="Gi"
            update_stats
            up="$(total_stats 'up' "$unit")"
            down="$(total_stats 'down' "$unit")"
            size="$(total_stats 'size' "$unit")"
            msg="T  $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'data')
            unit="Gi"
            info="$(info)"
            up="$(parse_data "$info" 'Uploaded' "$unit")"
            down="$(parse_data "$info" 'Downloaded' "$unit")"
            msg="  $down $unit   $up $unit"
            ;;
        'datatotal')
            unit="Gi"
            update_stats
            upt="$(total_stats 'up' "$unit")"
            downt="$(total_stats 'down' "$unit")"
            msg="  $downt $unit   $upt $unit"
            ;;
        'speed')
            unit="Mi"
            up="$(speed 'Total upload' "$unit")"
            down="$(speed 'Total download' "$unit")"
            [[ -z "$up$down" ]] &&  msg=" - $unit/s  - $unit/s" || msg=" $down $unit/s  $up $unit/s"
            ;;
        'active')
            seed="$(status | grep 'Seeding' | cut -f2 -d':' | tr -d ' ')"
            down="$(status | grep 'Downloading' | cut -f2 -d':' | tr -d ' ')"
            idle="$(status | grep 'Queued' | cut -f2 -d':' | tr -d ' ')"
            #both="$(info | grep -c '')"
            msg=" $down  $seed  $idle" # $both
            ;;
       *) help && exit 1 ;;
    esac
    echo "$msg"
}

# Managing Torrents
start_daemon() {
    deluged
}
action_all() {
    # preform an action an all torrents in a given state (states are Error|Downloading|Seeding|etc., pass "" to match is all state) (action can be pause|resume|rm|etc. from deluge)
    action="$1"
    state="$2"
    deluge-console "$action $(info | grep -B1 "State: $state" | grep ID | cut -d':' -f2 | tr -d ' ' | tr '\n' '.' | sed -e "s/\./\;$action /g" | sed -e "s/\;$action $//")" 2> /dev/null
}

# Torrent Search
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
        #echo $search_url
        curl -Ss "$search_url" >> $results_page
    done
    #cp $results_page ~/results.html
}
search() {
    query="$(rofi -lines 0 -dmenu -p "Enter Torrent Query")"
    [[ -z "$query" ]] && exit 1 #no query
    results_page=$(mktemp)
    get_search_results "$query" "$results_page"
    chosen="$(parse_results $results_page | rofi -lines 25 -width 80 -dmenu -p "Pick Torrent")"
    [[ -z "$chosen" ]] && exit 1 #no query
    txlink="$(grep -F "$(echo "$chosen" | rev | cut -f1 | rev)" $results_page | sed -e 's/^.*href="\/\(torrent.*\)\/">.*$/\1/')"
    [[ -z "$txlink" ]] && exit 1 #no query
    magnet="$(curl -Ss "https://1337x.to/$txlink/" | grep 'magnet' | head -1 | sed -e 's/^.*href="\(magnet[^"<>]*\)".*$/\1/')"
    [[ -z "$magnet" ]] && exit 1 #no query
    name="$(echo "$chosen" | rev | cut -f1 | rev | tr -s ' ' '.')"
    echo "$watch_dir/$name"
    deluge-console add --path="$watch_dir" "$magnet" && notify-send "Torrent Added: $name"
    rm $results_page
}


main() {
    mode="$1"
    case $mode in
        'search' ) search                     ;;
        'start'  ) start_daemon               ;;
        'pause'  ) action_all pause ""        ;;
        'resume' ) action_all resume ""       ;;
        'clean'  ) action_all 'rm -c' 'Error' ;;
        'stats'  ) update_stats               ;;
        'display') # display torrent data
            [[ -z "$2" ]] && dmode="$(getMode)" || dmode="$2"
            display "$dmode"
            ;;
        *) # change/set display mode
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