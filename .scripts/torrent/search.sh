#!/bin/bash
shopt -s extglob

# search 1337x.to for torrents given a query and echo the magnet links as one space delimited string

MAX_PAGES=3 # max number of results pages to parse when searching

search() {
    # download search results for query
    query="$(rofi -lines 0 -dmenu -p "Enter Torrent Query")"
    [[ -z "$query" ]] && exit 1 #no query
    results=$(mktemp)
    ~/.scripts/torrent/search_1337x.sh "$query" "$MAX_PAGES"  >| "$results" 
    ~/.scripts/torrent/get_kickass_results.sh "$query" "$MAX_PAGES" >> "$results"
    formatted_results=$(mktemp)
    paste <(seq 1 "$(wc -l "$results" | cut -d' ' -f1)") $results |\
            tr -s ' ' | sort --field-separator='\t' --key=5n >| "$formatted_results"
    # pick result(s)
    chosen="$(cut -f1,3- "$formatted_results" | sed 's/\t/=|=/g' | column -s'=' -t |\
              rofi -lines 25 -width 80 -dmenu -multi-select -p "Pick Torrent")"
    [[ -z "$chosen" ]] && echo "no queries selected, exiting" && exit 0 #no query
    ids="$(echo "$chosen" | cut -d'|' -f1 | sed 's/^\([^ ]*\).*$/^\1\t/')"
    grep -f <(echo "$ids") "$formatted_results" | cut -f1,2  # print all magnet lints to stdout
    # send notification
    total="$(wc -l $formatted_results | cut -d' ' -f1)"
    if [[ $total -eq 1 ]]; then
        name="$(head -1 "$chosen_results" | rev | cut -f1 | rev | tr -s ' ' '.')"
        notify-send "Found: $name"
    else
        links_added="$(wc -l $chosen_results | cut -d' ' -f1)"
        notify-send "Query: $query, Links added: $links_added"
    fi
}

search
