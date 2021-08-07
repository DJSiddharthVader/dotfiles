#!/bin/bash
shopt -s extglob

mode_file="$HOME/dotfiles/.config/polybar/modules.mode"
mode_prefix="torrent"
stats_file="$HOME/dotfiles/.config/transmission-daemon/stats.tsv"
download_dir="$HOME/Torrents"
modes=(ratio ratiototal data datatotal speed active) #no spaces in mode titles
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
    mkdir -p "$download_dir"
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

# Global Torrent Data Tracking
get_info() {
    transmission-remote -tall -i
}
extract() {
    info="$1"
    pattern="$2"
    echo "$info" | grep "$pattern: " | cut -d':' -f2- |
                   sed -E 's/\(.*\)//' | sed -E 's/\[.*\]//' | #delete everything in parens
                   sed -E 's/ {2,}/ /' | sed -E 's/^ //' | sed -E 's/ $//' # delete trailing spaces
}
scrape_stats() {
    info="$1"
    pattern="$2"
    extract "$info" "$pattern" |
            sed -e "s/\([0-9\.]*\) \([BKMGbkmg]\).*/\1\U\2\Li /" |
            sed -e 's/0Bi /0 /' | tr -d '\n' | sed -e 's/ *$/\n/' |
            numfmt --from=auto --field=1- | tr -s ' ' '\n'
}
update_stats() {
    #header="id"$delim"name"$delim"size"$delim"downloaded"$delim"uploaded"
    cp "$stats_file" "$stats_file.bak"
    info="$(info)"
    hashes="$(extract "$info" 'Hash')"
    names="$(extract "$info" 'Name')"
    sizes="$(scrape_stats "$info" 'Total size')"
    downloaded="$(scrape_stats "$info" 'Downloaded')"
    uploaded="$(scrape_stats "$info" 'Uploaded')"
    paste -d"$delim" <(echo "$hashes") <(echo "$names") <(echo "$sizes") <(echo "$downloaded") <(echo "$uploaded") >> "$stats_file"
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
    cut -d"$delim" -f$fn $stats_file | tr '\n' '+' |
        sed -e 's/^+/\n/' | sed -e 's/+$/\n/' | bc |
        numfmt --to-unit="$outunit" --format="%.2f"
}

# Display Torrent Data
sum_convert() {
    terms="$1"
    unit="$2"
    echo "$terms" | tr '\n' '+' | sed -e 's/[ \+]*$/\n/' | sed -e 's/^[ \+]*/\n/' | bc |
          numfmt --to-unit="$unit" --format="%.2f"
}
divide() {
    num="$1"
    denom="$2"
    scale="$3"
    echo "scale=$scale; $num/$denom" | bc | sed -e 's/^\./0./'
}
display() {
    #        
    mode="$1"
    info="$(get_info)"
    case "$mode" in
        'data')
            unit="Gi"
            up="$(scrape_stats "$info" 'Uploaded')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Downloaded')"
            down="$(sum_convert "$down" "$unit")"
            msg="  $down $unit   $up $unit"
            ;;
        'ratio')
            unit="Gi"
            size="$(scrape_stats "$info" 'Total size')"
            size="$(sum_convert "$size" "$unit")"
            up="$(scrape_stats "$info" 'Uploaded')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Downloaded')"
            down="$(sum_convert "$down" "$unit")"
            msg=" $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'datatotal')
            unit="Gi"
            update_stats
            up="$(cut -d"$delim" -f5 $stats_file)"
            up="$(sum_convert "$up" "$unit")"
            down="$(cut -d"$delim" -f4 $stats_file)"
            down="$(sum_convert "$down" "$unit")"
            msg="  $down $unit   $up $unit"
            ;;
        'ratiototal')
            unit="Gi"
            update_stats
            up="$(cut -d"$delim" -f5 $stats_file)"
            up="$(sum_convert "$up" "$unit")"
            down="$(cut -d"$delim" -f4 $stats_file)"
            down="$(sum_convert "$down" "$unit")"
            size="$(cut -d"$delim" -f3 $stats_file)"
            size="$(sum_convert "$size" "$unit")"
            msg="T  $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'speed')
            unit="Mi"
            up="$(scrape_stats "$info" 'Upload Speed')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Download Speed')"
            down="$(sum_convert "$down" "$unit")"
            [[ -z "$up$down" ]] &&  msg=" - $unit/s  - $unit/s" || msg=" $down $unit/s  $up $unit/s"
            ;;
        'active')
            states="$(extract "$info" "State")"
            down="$(echo "$states" | grep -c 'Downloading')"
            seed="$(echo "$states" | grep -c 'Seeding')"
            idle="$(echo "$states" | grep -c 'Idle')"
            msg=" $down  $seed  $idle" # $both
            ;;
       *) help && exit 1 ;;
    esac
    echo "$msg"
}

# Managing Torrents
start_daemon() {
    sudo /etc/init.d/transmission-daemon start
}
action_all() {
    case "$1" in
        'pause') action="--stop";;
        'resume') action="--start";;
    esac
    transmission-remote -tall "$action"
}
clean_up(){
    echo TODO
}

search() {
    magnets="$($search_script)"
    for magnet in ${magnets}; do
        if [[ -n "${magnet}" ]]; then
            transmission-remote -er -w $download_dir --add ${magnet}
        fi
    done
}

main() {
    mode="$1"
    case $mode in
        'start'  ) start_daemon        ;;
        'pause'  ) action_all 'pause'  ;;
        'resume' ) action_all 'resume' ;;
        'clean'  ) clean_up            ;;
        'search' ) search              ;;
        'stats'  ) update_stats        ;;
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

