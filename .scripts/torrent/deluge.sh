#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
mode_prefix="torrent"
watch_dir="$HOME/Torrents"
modes=(ratio ratiototal data datatotal speed active) #no spaces in mode titles
stats_file="$HOME/dotfiles/.config/deluge/stats.tsv"
delim="~"
search_script="$HOME/dotfiles/.scripts/torrent/search.sh"

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
    cp "$stats_file" "$stats_file.bak"
    unit="Gi"
    info="$(info)"
    ids="$(echo "$info" | grep 'ID: ' | cut -f2 -d':' | tr -d ' ')"
    echo 'scraped IDs'
    names="$(echo "$info" | grep 'Name: ' | cut -f2 -d':' | sed -e 's/^ //')"
    echo 'scraped names'
    sizes="$(scrape_stats "$info" 'Size' "$unit")"
    echo 'scraped sizes'
    downloaded="$(scrape_stats "$info" 'Downloaded' "$unit")"
    echo 'scraped downloads'
    uploaded="$(scrape_stats "$info" 'Uploaded' "$unit" )"
    echo 'scraped uploads'
    paste -d"$delim" <(echo "$ids") <(echo "$names") <(echo "$sizes") <(echo "$downloaded") <(echo "$uploaded") >> "$stats_file"
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

search() {
    magnets="$($search_script)"
    for magnet in ${magnets}; do
        # add magnet link and count
        if [[ -n "${magnet}" ]]; then
            deluge-console add --path="$watch_dir" "${magnet}" > /dev/null 2>&1 &
            #echo "link $links_added  worked"
        fi
    done
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
