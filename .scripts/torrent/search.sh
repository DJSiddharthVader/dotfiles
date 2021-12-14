#!/bin/bash
shopt -s extglob

# search 1337x.to and kickass for torrents given a query 
# echo the magnet links as one space delimited string for easy donwloading

MAX_PAGES=3 # max number of results pages to parse when searching

search() {
    # download search results for query
    query="$(rofi -lines 0 -dmenu -p "Enter Torrent Query")"
    [[ -z "$query" ]] && exit 1 # no query
    results=$(mktemp)
    ~/.scripts/torrent/search_1337x.sh "$query" "$MAX_PAGES"  >| "$results" 
    ~/.scripts/torrent/search_kickass.sh "$query" "$MAX_PAGES" >> "$results"
    formatted_results=$(mktemp)
    paste <(seq 001 "$(wc -l "$results" | cut -d' ' -f1)") $results |\
          tr -s ' ' >| $formatted_results
    # pick result(s)
    if [[ "$(wc -l $formatted_results | cut -d' ' -f1)" -eq 0 ]]; then
        rofi -lines 1 -width 80 -p "no results for $query"
        exit 0
    else
        chosen="$(cut -f1,3- "$formatted_results" |\
                  sed 's/ *\t */=|/g' | column -s'=' -t | sort -gr -t'|' -k5 |\
                  rofi -lines 25 -width 80 -dmenu -multi-select -p "Pick Torrent")"
    fi
    [[ -z "$chosen" ]] && echo "no queries selected, exiting" && exit 0 #no query
    ids="$(echo "$chosen" | cut -d'|' -f1 | sed 's/^\([0-9]*\)[^0-9]*$/^\1 *\t/')"
    grep -f <(echo "$ids") "$formatted_results" | cut -f2  # print all magnet lints to stdout
    # send notification
    total="$(wc -l $formatted_results | cut -d' ' -f1)"
    if [[ $total -eq 1 ]]; then
        name="$(head -1 "$chosen" | rev | cut -f1 | rev | tr -s ' ' '.')"
        notify-send "Found: $name"
    else
        links_added="$(echo "$chosen" | wc -l | cut -d' ' -f1)"
        notify-send "Query: $query, Links added: $links_added"
    fi
}

search
