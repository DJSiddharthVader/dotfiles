#!/bin/bash
# set -euo pipefail
shopt -s extglob

MAX_PAGES=3 # max number of results pages to parse when searching

search() {
    # download search results for query
    echo "Searching..." 1>&2
    query="$(rofi -lines 0 -dmenu -p "Enter Torrent Query")"
    [[ -z "$query" ]] && exit 1 # no query
    results=$(mktemp)
    ~/.scripts/torrent/search_1337x.sh "$query" "$MAX_PAGES"  >| "$results"  
    echo "Got 1337x results" 1>&2
    ~/.scripts/torrent/search_kickass.sh "$query" "$MAX_PAGES" >> "$results" 
    echo "Got kickass results" 1>&2
    # formatted_results=$(mktemp)
    formatted_results=~/dotfiles/.scripts/torrent/results.tsv
    ids="$(seq 001 "$(wc -l "$results" | cut -d' ' -f1)")"  # make id for each torrent
    hashes="$(cut -f1 $results | sed -e 's/^.*btih:\([A-Z0-9]*\).*$/\1/')" # torrent hash for dedup
    # paste <(echo "$ids") $results \
    paste <(echo "$hashes") <(echo "$ids") $results \
            | sort -t$'\t' -k1,1 -u | cut -f 2- \
            | tr -s ' ' \
            | sort -t$'\t' -k5 -gr >| $formatted_results  
    # pick result(s)
    if [[ "$(wc -l $formatted_results | cut -d' ' -f1)" -lt 2 ]]; then  
        rofi -dmenu -lines 1 -width 80 -p "no results for $query"  # if no results, quit
        exit 0
    else
        # format results nicelly in columns, sort be seeders
        chosen="$(cut -f1,3- "$formatted_results" \
            | sed 's/ *\(\t\) */\1|/g' | column -s$'\t' -t \
                  | rofi -dmenu -multi-select -lines 25 -width 80 -p "Pick Torrent")"
    fi
    [[ -z "$chosen" ]] && echo "no queries selected, exiting" && exit 0  # exit if no results chosen
    ids="$(echo "$chosen" | cut -d'|' -f1 | sed 's/^\([0-9]*\)[^0-9]*$/^\1 *\t/')"  # chosen torrent ids
    grep -f <(echo "$ids") "$formatted_results" | cut -f2  # print all chosen magnet lints to stdout
    # send notification
    total="$(wc -l $formatted_results | cut -d' ' -f1)"
    if [[ $total -eq 1 ]]; then
        name="$(head -1 "$chosen" | rev | cut -f1 | rev | tr -s ' ' '.')"
        notify-send "Found: $name"  # query link was found
    else
        links_added="$(echo "$chosen" | wc -l | cut -d' ' -f1)"
        notify-send "Query: $query, Links added: $links_added"  # how many links found
    fi
}

search
