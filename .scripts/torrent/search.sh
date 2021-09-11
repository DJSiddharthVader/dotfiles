#!/bin/bash
shopt -s extglob

# search 1337x.to for torrents given a query and echo the magnet links as one space delimited string

max_pages=5 # max number of results pages to parse when searching

get_1337x_results() {
    # download the search results for a torrent query from 1337x.to
    query="$1"
    results_page="$2"
    search_url="https://1337x.to/search/${query// /+}/1/"
    total_pages="$(curl -Ss "$search_url" | grep 'Last' | sed -s 's/^.*class=.last.><a href=.\/search\/.*\/\([0-9]*\)\/.>.*$/\1/')"
    [[ $max_pages -lt $total_pages ]] && total_pages=$max_pages
    for page_num in $(seq 1 $total_pages); do
        search_url="https://1337x.to/sort-search/${query// /+}/seeders/desc/$page_num/"
        #echo $search_url
        curl -Ss "$search_url" >> "$results_page"
    done
}
get_kickass_results() {
    # download the search results for a torrent query from 1337x.to
    query="$1"
    results_page="$2"
    search_url="https://katcr.to/usearch/${query// /+}/1/"
    total_pages="$(curl -Ss "$search_url" | grep 'Last' |  sed -s 's/^.*class=.last.><a href=.\/search\/.*\/\([0-9]*\)\/.>.*$/\1/')"
    [[ $max_pages -lt $total_pages ]] && total_pages=$max_pages
    for page_num in $(seq 1 $total_pages); do
        search_url="https://1337x.to/sort-search/${query// /+}/seeders/desc/$page_num/"
        #echo $search_url
        curl -Ss "$search_url" >> "$results_page"
    done
}
extract_from_page() {
    # extract information about each torrent from the downloaded html results
    grep "$2" "$1" | sed -e "s/^.*>\([^<>]\+\)<$3.*$/\1/"
    # $1 is field, $2 is results page, $3 is the ending tag
    # ^.*  # from start
    # >\([^<>]\+\)< # capture everything between ><
    # \(\/td\|\/a\|span\) # patterns that signal end of info
    # .*$ # rest of the line matched
}
parse_results() {
    # parse downloaded torrent results into a tab delimited table for display
    page="$1"
    sed -i '/<\/th>/d' "$page" # filter crap
    names="$(extract_from_page $page 'coll-1 name' '\/a')"
    seeders="$(extract_from_page $page 'coll-2 seeds' '\/td')"
    leechers="$(extract_from_page $page 'coll-3 leeches' '\/td')"
    dates="$(extract_from_page $page 'coll-date' '\/td')"
    sizes="$(extract_from_page $page 'coll-4 size' 'span')"
   # echo "$names" | tr '\t' '\n' | wc -l 1>&2
    paste <(echo "$dates") <(echo "$seeders") <(echo "$leechers") <(echo "$sizes") <(echo "$names")
}
search() {
    # download search results for query
    query="$(rofi -lines 0 -dmenu -p "Enter Torrent Query")"
    [[ -z "$query" ]] && exit 1 #no query
    results_page=$(mktemp)
    get_1337x_results "$query" "$results_page"
    # pick result(s)
    chosen="$(parse_results $results_page |\
              tail -n+2 | tr -s ' ' |\
              sed 's/\t/=|=/g' | column -s'=' -t |\
              rofi -lines 25 -width 80 -dmenu -multi-select -p "Pick Torrent")"
    [[ -z "$chosen" ]] && exit 1 #no query
    chosen_results="$(mktemp)"
    echo "$chosen" | rev | cut -d'|' -f1 | rev | sed 's/^ *\([^ ].*\) *$/\1/' >| "$chosen_results"
    # parse magnet link from chosen result and echo
    links="$(grep -F -f "$chosen_results" "$results_page" | sed -e 's/^.*href="\/\(torrent.*\)\/">.*$/\1/')"
    links_added=0
    magnets=""
    while read link; do
        # add magnet link and count
        magnet="$(curl -Ss "https://1337x.to/$link/" | grep 'magnet' | head -1 | sed -e 's/^.*href="\(magnet[^"<>]*\)".*$/\1/')"
        if [[ -n "$magnet" ]]; then
            links_added=$((links_added + 1))
            magnets="$magnets $magnet"
        fi
    done <<< "$(echo $links | tr ' ' '\n')"
    echo "$magnets"
    # send notification
    total="$(wc -l $chosen_results | cut -d' ' -f1)"
    if [[ $total -eq 1 ]]; then
        name="$(head -1 "$chosen_results" | rev | cut -f1 | rev | tr -s ' ' '.')"
        notify-send "Found: $name"
    else
        notify-send "Query: $query, Links Found: $links_added/$total"
    fi
    rm $results_page $chosen_results
}

search
