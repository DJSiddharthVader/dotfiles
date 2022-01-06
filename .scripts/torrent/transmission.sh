#!/bin/bash
set -uo pipefail
shopt -s extglob

MODE_FILE="$HOME/dotfiles/.config/polybar/modules.mode"
MODE_PREFIX="torrent"
STATS_FILE="$HOME/dotfiles/.config/transmission-daemon/stats.tsv"
DOWNLOAD_DIR="$HOME/Torrents"
VID_DIR="$HOME/Videos/ToOrganize"
MODES=(ratiototal datatotal ratio data speed active) #no spaces in mode titles
DELIM="~"
SEARCH_SCRIPT="$HOME/dotfiles/.scripts/torrent/search.sh"

help() {
    mode='$mode'
    echo "Usage: ./$(basename $0) -m $mode

    -u) {Ki|Mi|Gi|Ti}
        - specify unit for display

    -m) $mode
        - display modes are {$(echo ${MODES[*]} | tr ' ' '|')}
        Modes   | Description
        --------|---------------------------------------------
        display | display torrent data using default mode
        next    | cycle defualt display mode forward
        prev    | cycle defualt display mode backward
        $mode   | set defualt display mode to $mode
        current | display current default mode
        --------|---------------------------------------------
        search  | search online for a torrent query
        start   | start transmission daemon
        pause   | pause all torrents
        resume  | resume all torrents
        stats   | update up/download stats csv file
        table   | print formatted table of torrents 
        filter  | print table of torrents filtered
                | by criteria i.e. {ratio|done|undone|error}
        del     | deleted torrents by criteria (same as table)
"
}
init() {
    # init files
    mkdir -p "$DOWNLOAD_DIR"
    touch "$STATS_FILE"
    touch "$MODE_FILE"
    echo "$MODE_PREFIX:speed" >> "$MODE_FILE"
}
cycle() {
    # cycle through modes either forwards or backwards
    # get index of current mode in the modes array, find index for next/previous mode and get the array value of that index and echo it
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    dir="$1" # direction to set the mode
    mode="$(getMode)"
    idx="$(echo "${MODES[*]}" | grep -o "^.*$mode" | tr ' ' '\n' | wc -l)"
    idx=$(($idx -1)) # current mode idx
    case "$dir" in
         'next') idx=$(($idx + 1)) ;;
         'prev') idx=$(($idx +${#MODES[@]} -1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    next_idx=$(($idx % ${#MODES[@]})) # modulo to wrap back around modes array
    echo "${MODES[$next_idx]}" # return new mode
}
getMode() {
    grep "^$MODE_PREFIX:" "$MODE_FILE" | cut -d':' -f2
}
setMode() {
    sed -i "/^$MODE_PREFIX:/s/:.*/:$1/" "$MODE_FILE"
}

# Torrent Data Tracking
get_info() {
    transmission-remote -tall -i
}
extract() {
    info="$1" # will always be get_info() output but make it an argument to reduce redundant calls
    pattern="$2" # field of data to extract
    echo "$info" \
        | grep "$pattern: " \
        | cut -d':' -f2- \
        | sed -E 's/\(.*\)//' \
        | sed -E 's/\[.*\]//' \
        | sed -E 's/ {2,}/ /' \
        | sed -E 's/^ //' \
        | sed -E 's/ $//'
}
scrape_stats() {
    info="$1"
    pattern="$2"
    extract "$info" "$pattern" \
            | sed -e 's/None/ /g' \
            | sed -e "s/\([0-9\.]*\) \([BKMGbkmg]\).*/\1\U\2\Li /" \
            | sed -e 's/0Bi /0 /' \
            | tr -d '\n' \
            | sed -e 's/ *$/\n/' \
            | numfmt --from=auto --field=1- \
            | tr -s ' ' '\n'
}
update_stats() {
    # get data  for each field from torrents and format as tsv
    #header="id"$DELIM"name"$DELIM"size"$DELIM"downloaded"$DELIM"uploaded"
    info="$(get_info)"
    hashes="$(extract "$info" 'Hash')"
    names="$(extract "$info" 'Name')"
    sizes="$(scrape_stats "$info" 'Total size')"
    downloaded="$(scrape_stats "$info" 'Downloaded')"
    uploaded="$(scrape_stats "$info" 'Uploaded')"
    # append new data to current records
    tmp=$(mktemp)
    cp "$STATS_FILE" $tmp
    paste -d"$DELIM" <(echo "$hashes") <(echo "$names") <(echo "$sizes") <(echo "$downloaded") <(echo "$uploaded") >> $tmp
    # remove old redundant records
    sort -t"$DELIM" -r -g -k5,5 -k4,4 $tmp | sort -u -t"$DELIM" -k1,1 -o $tmp #dedup
    mv $tmp $STATS_FILE
}

# Display Torrent Data
sum_convert() {
    # sum list of data sizes and format to desired unit (Kb, Mb, Gb, Tb)
    terms="$1"
    unit="$2"
    echo "$terms" \
         | grep -v '^$' \
         | tr '\n' '+' \
         | sed -e 's/[ \+]*$/\n/' \
         | sed -e 's/^[ \+]*/\n/' \
         | bc \
         | numfmt --to-unit="$unit" --format="%.2f"
}
total_stats() {
    field="$1"
    unit="$2"
    case "$field" in
        'size') fn=3 ;; # total size of all torrents
        'down') fn=4 ;; # total download
        'up'  ) fn=5 ;; # total upload
    esac
    terms="$(cut -d"$DELIM" -f$fn $STATS_FILE)"
    sum_convert "$terms" "$unit"
}
divide() {
    num="$1"
    denom="$2"
    scale="$3"
    echo "scale=$scale; $num/$denom" | bc | sed -e 's/^\./0./'
}
display() {
    mode="$1"
    unit="$2"
    info="$(get_info)"
    case "$mode" in
        'data') # amount of data uploaded/downloaded for current torrents
            [[ -n "$unit" ]] || unit="Gi"
            up="$(scrape_stats "$info" 'Uploaded')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Downloaded')"
            down="$(sum_convert "$down" "$unit")"
            [[ -z "$up$down" ]] &&  msg=" - $unit  - $unit" || msg=" $down $unit  $up $unit"
            ;;
        'ratio') # get ratio of downloaded:size and uploaded:downloaded for current torrents
            [[ -n "$unit" ]] || unit="Ki"
            size="$(scrape_stats "$info" 'Total size')"
            size="$(sum_convert "$size" "$unit")"
            up="$(scrape_stats "$info" 'Uploaded')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Downloaded')"
            down="$(sum_convert "$down" "$unit")"
            [[ -z "$up$down" ]] &&  msg=" -  - " || msg=" $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'datatotal') # get total amount of data uploaded and downloaded for all current and previous torrents
            [[ -n "$unit" ]] || unit="Ti"
            [[ -z "$info" ]] || update_stats
            up="$(total_stats 'up' "$unit")"
            down="$(total_stats 'down' "$unit")"
            msg=" $down $unit  $up $unit"
            ;;
        'ratiototal') # get ratio of total downloaded to total size and total up to total down for all current and previous torrents
            [[ -n "$unit" ]] || unit="Ki"
            [[ -z "$info" ]] || update_stats
            up="$(cut -d"$DELIM" -f5 $STATS_FILE)"
            up="$(sum_convert "$up" "$unit")"
            down="$(cut -d"$DELIM" -f4 $STATS_FILE)"
            down="$(sum_convert "$down" "$unit")"
            size="$(cut -d"$DELIM" -f3 $STATS_FILE)"
            size="$(sum_convert "$size" "$unit")"
            msg="T  $(divide $down $size 2)  $(divide $up $down 2)"
            ;;
        'speed') # total upload/download speed
            [[ -n "$unit" ]] || unit="Mi"
            up="$(scrape_stats "$info" 'Upload Speed')"
            up="$(sum_convert "$up" "$unit")"
            down="$(scrape_stats "$info" 'Download Speed')"
            down="$(sum_convert "$down" "$unit")"
            [[ -z "$up$down" ]] &&  msg=" - $unit/s  - $unit/s" || msg=" $down $unit/s  $up $unit/s"
            ;;
        'active') # number of downloading, seeding and idle torrents
            states="$(extract "$info" "State")"
            down="$(echo "$states" | grep -c 'Downloading')"
            seed="$(echo "$states" | grep -c 'Seeding')"
            idle="$(echo "$states" | grep -c 'Idle')"
            both="$(echo "$states" | grep -c 'Both')"
            msg="$down $seed  $idle $both"
            ;;
        *) echo 'display fail' && help && exit 1 ;;
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
format_table() {
    # format torrent list so I can cut it and easily filter ids
    transmission-remote -tall -l | tail -n+2 | head -n-1 | sed -e 's/^ *//' | sed -e 's/ \{2,\}/\t/g'
}
filter_table() {
    # get torrent table and filter torrents and format visually
    mode="$1"
    case $mode in
        ratio) table="$(format_table | cut -f1,7,9 | grep -Pv '\t0\.[0-9]')" ;;
        done) table="$(format_table | cut -f1,2,9 | grep '100%')" ;;
        undone) table="$(format_table | cut -f1,2,9 | grep -v '100%')" ;;
        error) table="$(format_table | grep '\*' | cut -f 1,2,9 | tr -d '*')" ;;
        all)  table="$(format_table)" ;;
        *) echo "Invalid del mode $mode, must be {all|error|done|undone|ratio}" && exit 1 ;;
    esac
    echo "$table" | grep -vP 'None'
}
delete_torrents() {
    mode="$1"
    ids="$(filter_table "$mode" | cut -f1)"
    # remove and keep local data
    transmission-remote -t"$(echo "$ids" | cut -f1 | tr '\n' ',')" --remove
    # move all torrent files to Videos/ToOrganize
    files="$(format_table | cut -f1,7,9 | grep "^(${ids/\n/\\\|/})" | rev | cut -f1 | rev)"
    while IFS= read -r file; do
        echo "$file"
        mv "$DOWNLOAD_DIR/$file" "$VID_DIR"
    done <<< "$files"
}
search() {
    # search online for torrents, get magnets and start downloading
    magnets="$($SEARCH_SCRIPT)"
    echo -e "Found torrents\nAdding..."
    for magnet in ${magnets}; do
        transmission-remote -er -w $DOWNLOAD_DIR --add ${magnet}
    done
    echo "Added all torrents"
}

main() {
    # to avoid strict errors from -euo
    unit=""
    mode=""
    display="false"
    # handle flag arguments
    while getopts "hdu:m:" arg; do
        case $arg in
            u) unit="$OPTARG"
               if [[ $unit =~ ^[KMGT]i$ ]]; then
                   continue
                else
                   echo "Invalid unit $unit, pick from {Ki|Mi|Gi|Ti}"
                   exit 1
               fi
               ;;
            m) mode="$OPTARG" ;;
            d) display=true ;;
            h) help && exit 0 ;;
            *) echo "Invalid flag $arg" && help && exit 1 ;;
        esac
    done
    shift "$((OPTIND-1))"
    [[ -z $mode ]] && mode="${1:-}"
    # handle main argument behaviour
    case $mode in
        'start'  ) start_daemon ;;
        'pause'  ) action_all 'pause' ;;
        'resume' ) action_all 'resume' ;;
        'search' ) search ;;
        'stats'  ) update_stats ;;
        'display') display "$(getMode)" "$unit" ;;
        'current') echo "Current default is $(getMode)" ;;
        'table'  ) filter_table 'all' | column -s$'\t' -t ;;
        'filter' ) filter_table "$2";;
        'del'    ) delete_torrents "$2" ;;
        *) # change/set display mode
            tmp="@($(echo ${MODES[*]} | sed -e 's/ /|/g'))"
            case "$mode" in
                next) mode="$(cycle 'next')" ;;
                prev) mode="$(cycle 'prev')" ;;
                $tmp) mode="$mode" ;; #capture any valid mode
                *   ) echo "invalid mode $mode" && help && exit 1 ;;
            esac
            if [ "$display" = true ]; then
                display $mode $unit
            else
                setMode "$mode"
            fi
            ;;
    esac
}

[ $# -eq 0 ] && help && exit 1
main "$@"
